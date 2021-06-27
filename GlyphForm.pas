{
 AVISubDetector by Pavel Batuev (Shalcker) - hard-burned subtitle extraction tool
 Copyright (C) 2003-2005 Pavel Batuev

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit GlyphForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, ExtDlgs, Math;

type
  TGlyphForm = class(TForm)
    CheckListBox1: TCheckListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    ImageMask1: TImage;
    ImageOrig: TImage;
    ImageMask2: TImage;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    edRDT: TEdit;
    edRT: TEdit;
    edRO: TEdit;
    edGO: TEdit;
    edGT: TEdit;
    edBT: TEdit;
    edBO: TEdit;
    edBDT: TEdit;
    edGDT: TEdit;
    btBuildMasks: TButton;
    btQuarterPel: TButton;
    edRDO: TEdit;
    edGDO: TEdit;
    edBDO: TEdit;
    ImageMask3: TImage;
    procedure Button3Click(Sender: TObject);
    procedure ImageOrigMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btBuildMasksClick(Sender: TObject);
    procedure btQuarterPelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RT, GT, BT,
    RO, GO, BO: byte;
    RDT, GDT, BDT,
    RDO, GDO, BDO: integer;
    procedure ReAlign;
  end;

var
  GlyphForm1: TGlyphForm;

implementation

{$R *.DFM}

procedure CheckMainColor(R, G, B, RD, GD, BD:integer; ProximityMult: extended; Bmp, BmpX:TBitmap);
var {R,G,B,} RX, GX, BX: byte; PX, PX2:PByteArray; {BmpX: TBitmap;} X,Y : integer;
    RP, GP, BP: ^byte; HasMatch: boolean;
begin
{ Clr:=Bmp.Canvas.Pixels[X,Y];
 R:=(Clr shl 16) and $FF;
 G:=(Clr shl 8) and $FF;
 B:=Clr and $FF;}
{ PX:=Bmp.ScanLine[YP];
 R:=PX[XP*3+2];
 G:=PX[XP*3+1];
 B:=PX[XP*3];}


// BmpX:=Result;
// BmpX:=TBitmap.Create;
 BmpX.PixelFormat:=pf8Bit;
 BmpX.Width:=Bmp.Width;
 BmpX.Height:=Bmp.Height;
// CheckDirectMatch;
 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  if (Abs(RX-R)<RD) and (Abs(GX-G)<GD) and (Abs(BX-B)<BD) then
   PX2[X]:=255 else PX2[X]:=0;
  end;
 end;

//checking proximity - creating map of pixels "close" to original match 
 for Y:=1 to Bmp.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y-1];
  PX2:=BmpX.ScanLine[Y];
  for X:=1 to Bmp.Width-1 do
  begin
   RP:=@PX[X];   GP:=@PX2[X];   BP:=@PX[X-1];
   HasMatch:=(RP^=255) or (GP^=255) or (BP^=255);
   if (HasMatch) then
   begin
    if RP^=0 then RP^:=128;
    if GP^=0 then GP^:=128;
    if BP^=0 then BP^:=128;
   end;
  end;
 end; 
// CheckProximityMatch;
// now we are removing those "proximity" pixels that don't fit into double threshold
 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  if (PX2[X]=128) then
  if (Abs(RX-R)<RD*ProximityMult) and (Abs(GX-G)<GD*ProximityMult) and (Abs(BX-B)<BD*ProximityMult) then
   PX2[X]:=254;// else PX2[X]:=128;
  if (PX2[X]=255) then PX2[X]:=15;
  if (PX2[X]=254) then PX2[X]:=16;
  if (PX2[X]=128) then PX2[X]:=13;
  if (PX2[X]=0) then PX2[X]:=11;
  end;
 end;

// BmpX.Free;

end;

procedure OverlapMasks(Bmp1, Bmp2, BmpRes: TBitmap);
begin
 BmpRes.Width:=Bmp1.Width;
 BmpRes.Height:=Bmp1.Height;
 BmpRes.PixelFormat:=pf8bit;
 BmpRes.Canvas.CopyMode:=cmSrcCopy;
 BmpRes.Canvas.Draw(0,0,Bmp1);
 BmpRes.Canvas.CopyMode:=cmNotSrcErase;//cmSrcInvert;//Paint;//Invert;//MergePaint;
 BmpRes.Canvas.Draw(0,0,Bmp2);
end;

procedure TGlyphForm.Button3Click(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
 begin
  ImageOrig.Picture.Bitmap.LoadFromFile(OpenPictureDialog1.FileName);
  ImageOrig.Picture.Bitmap.PixelFormat:=pf24bit;
  ReAlign;
 end;
end;

procedure TGlyphForm.ReAlign;
begin

  ImageOrig.Height:=ImageOrig.Picture.Bitmap.Height;
  ImageOrig.Width:=ImageOrig.Picture.Bitmap.Width;

  ImageMask1.Top:=ImageOrig.BoundsRect.Bottom+5;
  ImageMask1.Height:=ImageOrig.Height;
  ImageMask1.Width:=ImageOrig.Width;

  ImageMask2.Top:=ImageMask1.BoundsRect.Bottom+5;
  ImageMask2.Height:=ImageOrig.Height;
  ImageMask2.Width:=ImageOrig.Width;

  ImageMask3.Top:=ImageMask2.BoundsRect.Bottom+5;
  ImageMask3.Height:=ImageOrig.Height;
  ImageMask3.Width:=ImageOrig.Width;
end;

procedure TGlyphForm.ImageOrigMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var PX:PByteArray;  
begin
// Image2.Picture.Bitmap:=CheckMainColor(X,Y,30,30,30,2,Image3.Picture.Bitmap);
 if (Button = mbLeft) then
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  RT:=PX[X*3+2];  GT:=PX[X*3+1];  BT:=PX[X*3];
  edRT.Text:=IntToStr(RT);  edGT.Text:=IntToStr(GT);  edBT.Text:=IntToStr(BT);
  btBuildMasksClick(Sender);
{  CheckMainColor(RT,GT,BT,
                 StrToIntDef(edRD.Text,30),
                StrToIntDef(edGD.Text,30),
                StrToIntDef(edBD.Text,30),
                2,ImageOrig.Picture.Bitmap,ImageMask1.Picture.Bitmap);}
 end;
 if (Button = mbRight) then
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  RO:=PX[X*3+2];  GO:=PX[X*3+1];  BO:=PX[X*3];
  edRO.Text:=IntToStr(RO);  edGO.Text:=IntToStr(GO);  edBO.Text:=IntToStr(BO);
  btBuildMasksClick(Sender);
 end;
{ ImageMask1.Invalidate;
 ImageMask2.Invalidate;}
end;

procedure TGlyphForm.btBuildMasksClick(Sender: TObject);
begin
  RDT:=StrToIntDef(edRDT.Text,30);
  GDT:=StrToIntDef(edGDT.Text,30);
  BDT:=StrToIntDef(edBDT.Text,30);

  RDO:=StrToIntDef(edRDO.Text,30);
  GDO:=StrToIntDef(edGDO.Text,30);
  BDO:=StrToIntDef(edBDO.Text,30);

  RO:=StrToIntDef(edRO.Text,0);
  GO:=StrToIntDef(edGO.Text,0);
  BO:=StrToIntDef(edBO.Text,0);

  RT:=StrToIntDef(edRT.Text,255);
  GT:=StrToIntDef(edGT.Text,255);
  BT:=StrToIntDef(edBT.Text,255);

  CheckMainColor(RO,GO,BO, RDO, GDO, BDO,
                2,ImageOrig.Picture.Bitmap,ImageMask2.Picture.Bitmap);
  CheckMainColor(RT,GT,BT,RDT,GDT,BDT,
                2,ImageOrig.Picture.Bitmap,ImageMask1.Picture.Bitmap);
  OverlapMasks(ImageMask1.Picture.Bitmap,ImageMask2.Picture.Bitmap,
               ImageMask3.Picture.Bitmap);

 ImageMask1.Invalidate;
 ImageMask2.Invalidate;
 ImageMask3.Invalidate;

end;

procedure TGlyphForm.btQuarterPelClick(Sender: TObject);
var X,Y:integer; Bmp:TBitmap; PX, PXR, PX1, PX2, PX3, PX4: PByteArray;
begin
 Bmp:=TBitmap.Create;

 Bmp.Width:=ImageOrig.Picture.Bitmap.Width*4-3;
 Bmp.Height:=ImageOrig.Picture.Bitmap.Height*4-3;
 Bmp.PixelFormat:=pf24bit;

 //horizontal interpolation
 for Y:=0 to ImageOrig.Picture.Bitmap.Height-1 do
 begin
  PXR:=Bmp.ScanLine[Y*4];
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to ImageOrig.Picture.Bitmap.Width-2 do
  begin
   PXR[(X*4)*3+2]:=PX[X*3+2];
   PXR[(X*4)*3+1]:=PX[X*3+1];
   PXR[(X*4)*3]:=PX[X*3];

   PXR[(X*4+1)*3+2]:=Min(255,Round(PX[X*3+2]*0.75 + PX[(X+1)*3+2]*0.25));
   PXR[(X*4+1)*3+1]:=Min(255,Round(PX[X*3+1]*0.75 + PX[(X+1)*3+1]*0.25));
   PXR[(X*4+1)*3+0]:=Min(255,Round(PX[X*3+0]*0.75 + PX[(X+1)*3+0]*0.25));

   PXR[(X*4+2)*3+2]:=Min(255,Round(PX[X*3+2]*0.5 + PX[(X+1)*3+2]*0.5));
   PXR[(X*4+2)*3+1]:=Min(255,Round(PX[X*3+1]*0.5 + PX[(X+1)*3+1]*0.5));
   PXR[(X*4+2)*3+0]:=Min(255,Round(PX[X*3+0]*0.5 + PX[(X+1)*3+0]*0.5));

   PXR[(X*4+3)*3+2]:=Min(255,Round(PX[X*3+2]*0.25 + PX[(X+1)*3+2]*0.75));
   PXR[(X*4+3)*3+1]:=Min(255,Round(PX[X*3+1]*0.25 + PX[(X+1)*3+1]*0.75));
   PXR[(X*4+3)*3+0]:=Min(255,Round(PX[X*3+0]*0.25 + PX[(X+1)*3+0]*0.75));
  end;
 end;


 for Y:=0 to ImageOrig.Picture.Bitmap.Height-2 do
 begin
  PX:=Bmp.ScanLine[Y*4];
  PX1:=Bmp.ScanLine[(Y+1)*4];
  PX2:=Bmp.ScanLine[Y*4+1];
  PX3:=Bmp.ScanLine[Y*4+2];
  PX4:=Bmp.ScanLine[Y*4+3];
  for X:=0 to Bmp.Width-1 do
  begin

   PX2[X*3+2]:=Min(255,Round(PX[X*3+2]*0.75 + PX1[X*3+2]*0.25));
   PX2[X*3+1]:=Min(255,Round(PX[X*3+1]*0.75 + PX1[X*3+1]*0.25));
   PX2[X*3+0]:=Min(255,Round(PX[X*3+0]*0.75 + PX1[X*3+0]*0.25));

   PX3[X*3+2]:=Min(255,Round(PX[X*3+2]*0.5 + PX1[X*3+2]*0.5));
   PX3[X*3+1]:=Min(255,Round(PX[X*3+1]*0.5 + PX1[X*3+1]*0.5));
   PX3[X*3+0]:=Min(255,Round(PX[X*3+0]*0.5 + PX1[X*3+0]*0.5));

   PX4[X*3+2]:=Min(255,Round(PX[X*3+2]*0.25 + PX1[X*3+2]*0.75));
   PX4[X*3+1]:=Min(255,Round(PX[X*3+1]*0.25 + PX1[X*3+1]*0.75));
   PX4[X*3+0]:=Min(255,Round(PX[X*3+0]*0.25 + PX1[X*3+0]*0.75));

  end;

 end;

 ImageOrig.Picture.Bitmap.Assign(Bmp);
 Bmp.Free;
 ReAlign;
end;

end.
