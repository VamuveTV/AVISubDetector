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
unit CheckForm0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TCheckForm = class(TForm)
    MainImage: TImage;
    gbCheckData: TGroupBox;
    sbTransfer: TSpeedButton;
    sbColorsUsed: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbTransferClick(Sender: TObject);
    procedure sbColorsUsedClick(Sender: TObject);
  private
    { Private declarations }
    ImageSaved: TBitmap;
  public
    { Public declarations }
  end;

var
  CheckForm: TCheckForm;

implementation

uses Unit1;

{$R *.DFM}

procedure TCheckForm.FormCreate(Sender: TObject);
begin
 ImageSaved:=TBitmap.Create;
end;

procedure TCheckForm.FormDestroy(Sender: TObject);
begin
 ImageSaved.Free;
end;

procedure TCheckForm.sbTransferClick(Sender: TObject);
begin
 ImageSaved.Assign(MainForm.Image1.Picture.Bitmap);
 MainImage.Picture.Bitmap.Assign(ImageSaved);
end;

procedure TCheckForm.sbColorsUsedClick(Sender: TObject);
var PX, PXC:PByteArray; Y,i, j, Pix, Pix_offs, Pix_offs2, ValR, ValG, ValB, SharpXRedTmp, SharpXBlueTmp, SharpXGreenTmp:longint;
    R1,G1,B1, R2,G2,B2, LastR, LastG, LastB: byte;
    RDiff, GDiff, BDiff: array[0..255] of longint;
    MaxRDiff, MaxGDiff, MaxBDiff:longint;
begin
 for i:=0 to 255 do RDiff[i]:=0;
 for i:=0 to 255 do GDiff[i]:=0;
 for i:=0 to 255 do BDiff[i]:=0;

 for Y:=MainImage.Picture.Height-MainForm.Offs-1 downto (MainImage.Picture.Height-(MainImage.Picture.Height div MainForm.ImagePartial))+MainForm.Offs do
 begin
//  PX:=MainImage.Picture.Bitmap.ScanLine[Y];
  PXC:=ImageSaved.ScanLine[Y];
  for i:=MainForm.Offs to MainForm.FrameWidth-MainForm.Offs-1 do
   begin
    Pix:=(i)*3;
    Pix_offs:=(i+MainForm.Offs)*3;
    LastR:=255;
    LastG:=255;
    LastB:=255;
//    Pix_offs2:=(i-Offs)*3;
    ValR:=0; ValG:=0; ValB:=0; //for zero influence
    R1:=PXC[Pix+2]; G1:=PXC[Pix+1]; B1:=PXC[Pix];
    R2:=PXC[Pix_offs+2]; G2:=PXC[Pix_offs+1]; B2:=PXC[Pix_offs];

    ValR:=abs(PXC[Pix+2]-PXC[Pix_offs+2]); ValG:=abs(PXC[Pix+1]-PXC[Pix_offs+1]); ValB:=abs(PXC[Pix]-PXC[Pix_offs]);
    
    if (MainForm.IsDropRed) then if not(ValR>MainForm.DropRed) then ValR:=0;
    if (MainForm.IsDropGreen) then if not(ValG>MainForm.DropGreen) then ValG:=0;
    if (MainForm.IsDropBlue) then if not(ValB>MainForm.DropBlue) then ValB:=0;

    if (ValR>0) then Inc(RDiff[ValR]);
    if (ValG>0) then Inc(GDiff[ValG]);
    if (ValB>0) then Inc(BDiff[ValB]);
    
{    SharpXRedTmp:=0; SharpXBlueTmp:=0; SharpXGreenTmp:=0;
     if (MainForm.IsDropRed) then begin if (ValR>MainForm.DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (MainForm.IsDropGreen) then begin if (ValG>MainForm.DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (MainForm.IsDropBlue) then begin if (ValB>MainForm.DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
    if (MainForm.IsDropSum) then if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>MainForm.DropSum) then SharpXBlueTmp:=0; SharpXGreenTmp:=0; SharpXRedTmp:=0;
    if (SharpXRedTmp>0) then Inc(RDiff[SharpXRedTmp]);
    if (SharpXGreenTmp>0) then Inc(GDiff[SharpXGreenTmp]);
    if (SharpXBlueTmp>0) then Inc(BDiff[SharpXBlueTmp]);}
{
    if (SharpXRedTmp=0) and (SharpXBlueTmp=0) and (SharpXGreenTmp=0) then
      begin
       // no sharpness, point dropped to last sharp value
       PX[Pix]:=LastR;
       PX[Pix+1]:=LastG;
       PX[Pix+2]:=LastB;
      end
    else
      begin
       // got sharpness, point value memorized
       LastR:=R2;
       LastG:=G2;
       LastB:=B2;
      end}
   end;
 end;
 MaxRDiff:=1; MaxGDiff:=1; MaxBDiff:=1;
 for i:=0 to 255 do if (RDiff[i]>MaxRDiff) then MaxRDiff:=RDiff[i];
 for i:=0 to 255 do if (GDiff[i]>MaxGDiff) then MaxGDiff:=GDiff[i];
 for i:=0 to 255 do if (BDiff[i]>MaxBDiff) then MaxBDiff:=BDiff[i];

 MainImage.Width:=640;
 MainImage.Height:=480;
 for Y:=0 to MainImage.Picture.Height-1 {downto 0} do
 begin
 PX:=MainImage.Picture.Bitmap.ScanLine[Y];
 for i:=0 to MainImage.Width-1 do
 begin
  j:=Trunc(256*i/MainImage.Width);//*255;
  if (Y<160) then
   begin
    PX[i*3]:=255; PX[i*3+1]:=255; PX[i*3+2]:=255; //white
    if (RDiff[j]>0) then
//    if (RDiff[j]<(MaxRDiff div (160-Y+1))) then
    if not(RDiff[j]<(MaxRDiff*(160-Y+1)/160)) then
    begin PX[i*3]:=0; PX[i*3+1]:=0; end;
   end;
  if (Y>=160) and (Y<160*2) then
   begin
    PX[i*3]:=255; PX[i*3+1]:=255; PX[i*3+2]:=255; //white
    if (GDiff[j]>0) then
//    if (GDiff[j]<(MaxGDiff div (160*2-Y+1))) then
    if not(GDiff[j]<(MaxGDiff*(160*2-Y+1)/160)) then
    begin PX[i*3]:=0; PX[i*3+2]:=0; end;
   end;
  if (Y>=160*2) and (Y<160*3) then
   begin
    PX[i*3]:=255; PX[i*3+1]:=255; PX[i*3+2]:=255; //white
    if (BDiff[j]>0) then
    if not(BDiff[j]<(MaxBDiff*(160*3-Y+1)/160)) then
    begin PX[i*3+1]:=0; PX[i*3+2]:=0; end;
   end;
 end;
 end;
 MainImage.Invalidate;
end;

end.
