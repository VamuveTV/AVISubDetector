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
unit SymbolRefine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls, GlyphForm;

type
  TRefineSymbolForm = class(TForm)
    clbAreas: TCheckListBox;
    Panel1: TPanel;
    AreaScroll: TScrollBox;
    Image: TImage;
    btOk: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure clbAreasClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IA_MAP, IA_CPY: TImageArray;
    Areas: array of TArea;
    Edge: integer;
{    procedure VolumeBlast(Bmp: TBitmap; Volume: integer; Clr: byte; IgnoreEdge: integer = 1);}

    procedure Separator(Bmp: TBitmap; Clr: byte; IgnoreEdge: integer = 1);
    procedure SetBitmap(Bmp: TBitmap);
    procedure EnableArea(Num: integer);
    procedure EnableAreaX(Num: integer);
    procedure EnableAll;
    procedure DisableAll;
  end;

var
  RefineSymbolForm: TRefineSymbolForm;

implementation

{$R *.DFM}
{procedure TRefineSymbolForm.VolumeBlast;
var PX:PByteArray;
    i, X,Y, W, H, AreaCtr, Vol : integer;
    CL: TColor;

function DiffAmount(BmpX: TBitmap; IAX, IAX_MAP: TImageArray; ClrX: byte): integer;
//check only difference in points with ClrX on IAX
var Y1,X1: integer;
    PXX: PByteArray;
begin
 Result:=0;
 for Y1:=0 to H-1 do
 begin
  PXX:=BmpX.ScanLine[Y1];
  for X1:=0 to W-1 do
   if (IAX.Pixels[X1+Y1*W]=ClrX) then
   if (IAX_MAP.Pixels[X1+Y1*W]=0) then
   if not(PXX[X1]=ClrX) then
   begin
    IAX_MAP.Pixels[X1+Y1*W]:=AreaCtr+1;
    inc(Result);
   end;

 end;
end;   

begin
 H:=Bmp.Height; W:=Bmp.Width;
 IA_MAP.Width:=W; IA_MAP.Height:=H;
 IA_CPY.Width:=W; IA_CPY.Height:=H;

 SetLength(IA_MAP.Pixels,H*W);
 SetLength(IA_CPY.Pixels,H*W);
 for i:=0 to H*W-1 do IA_MAP.Pixels[i]:=0;
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];  for X:=0 to W-1 do IA_CPY.Pixels[Y*W+X]:=PX[X];
 end;
 AreaCtr:=0;
 for Y:=IgnoreEdge to H-1-IgnoreEdge do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=IgnoreEdge to W-1-IgnoreEdge do
  if (PX[X]=Clr) and (IA_MAP.Pixels[Y*W+X]=0) then
  begin
   CL:=Bmp.Canvas.Pixels[X,Y];
//!   SymbolMatchForm.ImageMatch1.Picture.Bitmap.Assign(Bmp);
   Bmp.Canvas.Brush.Color:=0;
   Bmp.Canvas.FloodFill(X,Y,CL,fsSurface); //fill area
   //checking "volume" of affected area
   Vol:=DiffAmount(Bmp,IA_CPY,IA_MAP,Clr);
   inc(AreaCtr);
   if (AreaCtr>254) then AreaCtr:=0;
//!   SymbolMatchForm.ImageMatch2.Picture.Bitmap.Assign(Bmp);
//!   SymbolMatchForm.Mode:=2;
//!   SymbolMatchForm.ShowModal;
   if (Vol>=Volume) then
   begin
    Bmp.Canvas.Brush.Color:=CL;
    Bmp.Canvas.FloodFill(X,Y,0,fsSurface);
   end;
  end;
 end;
 SetLength(IA_MAP.Pixels,0);
 SetLength(IA_CPY.Pixels,0);
end;}

procedure TRefineSymbolForm.Separator;
var PX:PByteArray;
    i, X,Y, W, H, AreaCtr, Vol : integer;
    CL: TColor;
    XX1, XX2, YY1, YY2, FFX, FFY: integer;

function DiffAmount(BmpX: TBitmap; IAX, IAX_MAP: TImageArray; ClrX: byte): integer;
//check only difference in points with ClrX on IAX
var Y1,X1: integer;
    PXX: PByteArray;
begin
 Result:=0;
 YY2:=0;
 YY1:=H;
 XX1:=W;
 XX2:=0;
 for Y1:=0 to H-1 do
 begin
  PXX:=BmpX.ScanLine[Y1];
  for X1:=0 to W-1 do
   if (IAX.Pixels[X1+Y1*W]=ClrX) then
   if (IAX_MAP.Pixels[X1+Y1*W]=0) then
   if not(PXX[X1]=ClrX) then
   begin
    if (X1>XX2) then XX2:=X1;    if (X1<XX1) then XX1:=X1;
    if (Y1>YY2) then YY2:=Y1;    if (Y1<YY1) then YY1:=Y1;
    IAX_MAP.Pixels[X1+Y1*W]:=AreaCtr;
    FFX:=X1; FFY:=Y1;
    inc(Result);
   end;

 end;
end;

begin
 H:=Bmp.Height; W:=Bmp.Width;
 IA_MAP.Width:=W; IA_MAP.Height:=H;
 IA_CPY.Width:=W; IA_CPY.Height:=H;

 SetLength(IA_MAP.Pixels,H*W);
 SetLength(IA_CPY.Pixels,H*W);
 SetLength(Areas,0);
 for i:=0 to H*W-1 do IA_MAP.Pixels[i]:=0;
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];  for X:=0 to W-1 do IA_CPY.Pixels[Y*W+X]:=PX[X];
 end;
 AreaCtr:=0;
 for Y:=IgnoreEdge to H-1-IgnoreEdge do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=IgnoreEdge to W-1-IgnoreEdge do
  if (PX[X]=Clr) and (IA_MAP.Pixels[Y*W+X]=0) then
  begin
   CL:=Bmp.Canvas.Pixels[X,Y];
//!   SymbolMatchForm.ImageMatch1.Picture.Bitmap.Assign(Bmp);
   Bmp.Canvas.Brush.Color:=0;
   Bmp.Canvas.FloodFill(X,Y,CL,fsSurface); //fill area
   //checking "volume" of affected area
   inc(AreaCtr);
   Vol:=DiffAmount(Bmp,IA_CPY,IA_MAP,Clr);
   SetLength(Areas,Length(Areas)+1);
   Areas[Length(Areas)-1].Count:=Vol;
   Areas[Length(Areas)-1].X1:=XX1;
   Areas[Length(Areas)-1].X2:=XX2;
   Areas[Length(Areas)-1].Y1:=YY1;
   Areas[Length(Areas)-1].Y2:=YY2;
   Areas[Length(Areas)-1].FX:=FFX;
   Areas[Length(Areas)-1].FY:=FFY;
   Areas[Length(Areas)-1].AreaNum:=AreaCtr;

   if (AreaCtr>254) then AreaCtr:=0;
//!   SymbolMatchForm.ImageMatch2.Picture.Bitmap.Assign(Bmp);
//!   SymbolMatchForm.Mode:=2;
//!   SymbolMatchForm.ShowModal;
{   if (Vol>=Volume) then
   begin
    Bmp.Canvas.Brush.Color:=CL;
    Bmp.Canvas.FloodFill(X,Y,0,fsSurface);
   end;}
  end;
 end;
// SetLength(IA_MAP.Pixels,0);
// SetLength(IA_CPY.Pixels,0);
end;


procedure TRefineSymbolForm.SetBitmap;
var i:integer;
begin
// Image.Picture.Bitmap.Assign(Bmp); ShowModal; //test
 Separator(Bmp, GlyphForm1.CLR_MASK_MAIN, Edge);
// Separator(Image.Picture.Bitmap, GlyphForm1.CLR_MASK_MAIN, Edge);
 if Image.Picture.Width<AreaScroll.Width then
    Image.Left:=(AreaScroll.Width-Image.Picture.Width) div 2 else Image.Left:=0;
 if Image.Picture.Height<AreaScroll.Height then
    Image.Top:=(AreaScroll.Height-Image.Picture.Height) div 2 else Image.Top:=0;
 clbAreas.Items.Clear;
 for i:=0 to Length(Areas)-1 do
  clbAreas.Items.Add(Format('%.3d: (%.3d,%.3d,%.3d,%.3d), %d pixels',
                            [Areas[i].AreaNum,
                             Areas[i].X1,Areas[i].Y1,Areas[i].X2,Areas[i].Y2,
                             Areas[i].Count]));
 for i:=0 to Length(Areas)-1 do clbAreas.ItemEnabled[i]:=true;
 for i:=0 to Length(Areas)-1 do clbAreas.Checked[i]:=true;
 clbAreasClickCheck(Self);
end;

procedure TRefineSymbolForm.FormShow(Sender: TObject);
var i:integer;
begin
 if Image.Picture.Bitmap.PixelFormat=pf8bit then SetBitmap(Image.Picture.Bitmap);
{
 Separator(Image.Picture.Bitmap, GlyphForm1.CLR_MASK_MAIN, Edge);
 clbAreas.Items.Clear;
 for i:=0 to Length(Areas)-1 do
  clbAreas.Items.Add(Format('%.3d: (%.3d,%.3d,%.3d,%.3d), %d pixels',
                            [Areas[i].AreaNum,
                             Areas[i].X1,Areas[i].Y1,Areas[i].X2,Areas[i].Y2,
                             Areas[i].Count]));
 for i:=0 to Length(Areas)-1 do clbAreas.ItemEnabled[i]:=true;
 for i:=0 to Length(Areas)-1 do clbAreas.Checked[i]:=true;
 clbAreasClickCheck(Sender);
 }
end;

procedure TRefineSymbolForm.clbAreasClickCheck(Sender: TObject);
var Bmp: TBitmap; PX:PByteArray;
    i, X, Y, W, H: integer;
begin
 Bmp:=Image.Picture.Bitmap;
//x Bmp:=TBitmap.Create;
 Bmp.PixelFormat:=pf8bit;
// Bmp.PixelFormat:=pf24bit;
 W:=IA_MAP.Width;
 H:=IA_MAP.Height;
 Bmp.Width:=W; Bmp.Height:=H;
{ for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to W-1 do
  begin
   PX[X]:=GlyphForm1.CLR_MASK_NONE;
//    PX[X*3+2]:=128+32; PX[X*3+1]:=128+32; PX[X*3]:=128+32;
  end;
 end;}

// for i:=0 to Length(Areas)-1 do
// if clbAreas.Checked[i] then
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to W-1 do
  if (IA_MAP.Pixels[X+Y*W])=0 then PX[X]:=GlyphForm1.CLR_MASK_NONE
  else
  if clbAreas.Checked[(IA_MAP.Pixels[X+Y*W])-1] then
//  if IA_MAP.Pixels[X+Y*W]=Areas[i].AreaNum then
  begin
   PX[X]:=GlyphForm1.CLR_MASK_MAIN;
//   PX[X*3+2]:=255; PX[X*3+1]:=255; PX[X*3]:=32;
  end else PX[X]:=GlyphForm1.CLR_MASK_DBL;
//    if PX[X]:=GlyphForm1.CLR_MASK_MAIN;
 end;
// GlyphForm1.MaskToBitmap(Bmp,Image.Picture.Bitmap);//.Assign(Bmp);
// Image.Picture.Bitmap.Handle:=Bmp.Handle;
//! Image.Picture.Bitmap.Assign(Bmp);
//x Bmp.Free;
 Image.Invalidate;
end;

procedure TRefineSymbolForm.FormCreate(Sender: TObject);
begin
 Edge:=0;
end;

procedure TRefineSymbolForm.EnableArea;
var i:integer;
begin
 for i:=0 to clbAreas.Items.Count-1 do
  if i=Num then clbAreas.Checked[i]:=true else clbAreas.Checked[i]:=false;
 clbAreasClickCheck(Self);
end;

procedure TRefineSymbolForm.EnableAreaX;
var i:integer;
begin
 for i:=0 to clbAreas.Items.Count-1 do
  if i=Num then clbAreas.Checked[i]:=true;
 clbAreasClickCheck(Self);
end;

procedure TRefineSymbolForm.EnableAll;
var i:integer;
begin
 for i:=0 to clbAreas.Items.Count-1 do clbAreas.Checked[i]:=true;
 clbAreasClickCheck(Self);
end;

procedure TRefineSymbolForm.DisableAll;
var i:integer;
begin
 for i:=0 to clbAreas.Items.Count-1 do clbAreas.Checked[i]:=false;
 clbAreasClickCheck(Self);
end;

procedure TRefineSymbolForm.ImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//
 if IA_MAP.Pixels[X+Y*IA_MAP.Width]>0 then
 begin
  clbAreas.Checked[IA_MAP.Pixels[X+Y*IA_MAP.Width]-1]:=not(clbAreas.Checked[IA_MAP.Pixels[X+Y*IA_MAP.Width]-1]);
  clbAreasClickCheck(Self);
 end; 
end;

procedure TRefineSymbolForm.FormDestroy(Sender: TObject);
begin
 SetLength(IA_MAP.Pixels,0);
 SetLength(IA_CPY.Pixels,0);
end;

end.
