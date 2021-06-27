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
unit ImageForm0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ExtDlgs;

type
  TImageForm = class(TForm)
    Image1: TImage;
    SharpGraph: TPaintBox;
    Panel1: TPanel;
    sbGetFrameSample: TSpeedButton;
    sbRestoreImage: TSpeedButton;
    sbZeroPoints: TSpeedButton;
    sbCheckBlockLines: TSpeedButton;
    sbInvertLine: TSpeedButton;
    lbMBC: TLabel;
    lbDLC: TLabel;
    sbCheckBlockTopZero: TSpeedButton;
    sbCheckColorDomination: TSpeedButton;
    sbRemainDominatingColors: TSpeedButton;
    OpenBMP: TOpenPictureDialog;
    sbViewSubstract: TSpeedButton;
    sbAddDominatorColor: TSpeedButton;
    lbDominatorColor: TLabel;
    sbSetDominatorColor: TSpeedButton;
    sbDominating: TSpeedButton;
    sbDominatingSharp: TSpeedButton;
    procedure sbCheckBlockLinesClick(Sender: TObject);
    procedure sbRestoreImageClick(Sender: TObject);
    procedure sbZeroPointsClick(Sender: TObject);
    procedure sbGetFrameSampleClick(Sender: TObject);
    procedure sbCheckColorDominationClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAddDominatorColorClick(Sender: TObject);
    procedure sbSetDominatorColorClick(Sender: TObject);
//    procedure sbReduceColorsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MaxBlockCount: integer;
    SharpXRedTmp, SharpXGreenTmp, SharpXBlueTmp: longint;
    R,G,B: byte; //last colors of "clicked" pixel
     procedure SaveImage;
     procedure RestoreImage;
     function CheckLineBlock16SharpXImage(Y, BlockNum:integer):longint;
  end;

var
  ImageForm: TImageForm;

implementation

uses Unit1;

{$R *.DFM}

procedure TImageForm.sbCheckBlockLinesClick(Sender: TObject);
var i, j, SelSharp, Y, LineCtr:longint; LineMarked, BlockSharp, PrevBlockSharp: boolean;
    SharpXTmp, SharpLinesTmp, MaxSameLineCtrTmp, MaxSameLineValTmp, SameLineCtrTmp, OldLineCtr: longint; LastLineIsSharp:boolean;
begin
//
// LineMinimum:=StrToIntDef(edLineLimit.Text, 2000);
// MaximumDropoutValue:=StrToIntDef(edDropLow.Text, 20);
 RestoreImage;
 SaveImage;
 if Image1.Picture.Height>0 then
 begin
 SharpLinesTmp:=0;
 LastLineIsSharp:=false;
 MaxSameLineCtrTmp:=0;
 SameLineCtrTmp:=0;
 MaxBlockCount:=0;
 OldLineCtr:=0;
 MaxSameLineValTmp:=0;
 MaxSameLineCtrTmp:=0;

 Image1.Picture.Bitmap.Canvas.Pen.Mode:=pmNot;
 SharpGraph.Canvas.Pen.Mode:=pmCopy;
 SharpGraph.Height:=Image1.Height;
// SelSharp:=StrToIntDef(edSelSharp.Text, 1);
// MaxSharpX[SelSharp]:=0;
 if Image1.Picture.Height>0 then
// for Y:=Image1.Picture.Height-1 downto 0 do
// for Y:=Image1.Picture.Height-1 downto (Image1.Picture.Height-(Image1.Picture.Height div MainForm.ImagePartial))  do
 for Y:=Image1.Picture.Height-1-MainForm.ImageCutBottom downto (MainForm.ImageCutTop)  do
 begin
  PrevBlockSharp:=false;  LineCtr:=0;
  for i:=0 to (Image1.Width div 16)-2 do
   begin
//    CheckLineBlock16SharpX(Y,SelSharp,i);
    SharpXTmp:=CheckLineBlock16SharpXImage(Y,i);
//    if not(SharpXTmp<(LineMinimum/(FrameWidth div 16))) then
    if not(SharpXTmp<MainForm.BlockMinimum) then
    begin
     BlockSharp:=true;
     if (PrevBlockSharp) then
     begin
      LineCtr:=LineCtr+1;
      if MainForm.CentralDomination then
      begin
       if abs(i*16-(Image1.Width div 2))<24 then LineCtr:=LineCtr+1;
       if abs(i*16-(Image1.Width div 2))<10 then LineCtr:=LineCtr+1; //additional point for center subtitles (for small subs like No! and Yes!)
      end;
     end;
     if not(sbInvertLine.Down) then
     begin
     Image1.Picture.Bitmap.Canvas.MoveTo(i*16,Y);
     Image1.Picture.Bitmap.Canvas.LineTo(i*16+16, Y);
     end;
    end
    else
    begin
     BlockSharp:=false;
//     if PrevBlockSharp then LineCtr:=LineCtr-1;
    end;
    PrevBlockSharp:=BlockSharp;

   end;
   if LineCtr>MainForm.MinLineBlockNum then
   begin
     if (LastLineIsSharp) then Inc(SharpLinesTmp); //if two lines are sharp in a row
     LastLineIsSharp:=true;
     if (sbInvertLine.Down) then
     begin
      Image1.Picture.Bitmap.Canvas.MoveTo(0,Y);
      Image1.Picture.Bitmap.Canvas.LineTo(Image1.Picture.Width-1, Y);
     end;
    if (LineCtr>MaxBlockCount) then MaxBlockCount:=LineCtr;
    if (LineCtr=OldLineCtr) then Inc(SameLineCtrTmp) else SameLineCtrTmp:=0;
    if (SameLineCtrTmp>MaxSameLineCtrTmp) then
     begin
      MaxSameLineValTmp:=LineCtr;
      MaxSameLineCtrTmp:=SameLineCtrTmp;
     end
    else if (LineCtr=MaxSameLineValTmp) then Inc(MaxSameLineCtrTmp);

   end
   else LastLineIsSharp:=false;
   OldLineCtr:=LineCtr;

  Application.ProcessMessages;
  SharpGraph.Canvas.Pen.Color:=clWhite;
  SharpGraph.Canvas.MoveTo(0,Y);
  SharpGraph.Canvas.LineTo(SharpGraph.Width,Y);
  SharpGraph.Canvas.Pen.Color:=clBlack;
  SharpGraph.Canvas.MoveTo(0,Y);
  SharpGraph.Canvas.LineTo(Trunc(SharpGraph.Width*LineCtr/(Image1.Width div 16)),Y);

//   CheckLineSharpX(Y,2);
//   CheckLineSharpX(Y,3);
 end;
 SharpGraph.Canvas.Pen.Mode:=pmNot;
 SharpGraph.Canvas.MoveTo(Trunc((SharpGraph.Width)*(MainForm.MinLineBlockNum+1)/(Image1.Width div 16)),0);
 SharpGraph.Canvas.LineTo(Trunc((SharpGraph.Width)*(MainForm.MinLineBlockNum+1)/(Image1.Width div 16)),Image1.Height);
 SharpGraph.Canvas.Pen.Mode:=pmCopy;
 SharpGraph.Canvas.Pen.Color:=clGreen;
 SharpGraph.Canvas.MoveTo(Trunc((SharpGraph.Width)*(MaxSameLineValTmp)/(Image1.Width div 16)),0);
 SharpGraph.Canvas.LineTo(Trunc((SharpGraph.Width)*(MaxSameLineValTmp)/(Image1.Width div 16)),Image1.Height);
 lbMBC.Caption:='MBC='+IntToStr(MaxSameLineCtrTmp)+'/'+IntToStr(MaxSameLineValTmp);
 lbDLC.Caption:='DLC='+IntToStr(SharpLinesTmp);
 end;
end;

function TImageForm.CheckLineBlock16SharpXImage;
var PX: PByteArray; i, X, Pix, Pix_offs, ValR, ValG, ValB:integer;
begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  X:=BlockNum*16;
//  SharpXTmp:=0;
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;
  if (X+15+MainForm.Offs<Image1.Picture.Bitmap.Width) then
  for i:=0 to 15 do
  begin
   Pix:=(i+X)*3;
   Pix_offs:=(i+X+MainForm.Offs)*3;
   ValR:=abs(PX[Pix]-PX[Pix_offs]);
   ValG:=abs(PX[Pix+1]-PX[Pix_offs+1]);
   ValB:=abs(PX[Pix+2]-PX[Pix_offs+2]);
     if (MainForm.IsDropRed) then begin if (ValR>MainForm.DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (MainForm.IsDropGreen) then begin if (ValG>MainForm.DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (MainForm.IsDropBlue) then begin if (ValB>MainForm.DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
  end;
  Result:=0;
  if (MainForm.IsDropSum) then begin if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>MainForm.DropSum) then Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp; end else Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp;
//Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp;
end;


procedure TImageForm.SaveImage;
begin
 MainForm.ImageSaved.Assign(Image1.Picture.Bitmap);
end;

procedure TImageForm.RestoreImage;
begin
 Image1.Picture.Bitmap.Assign(MainForm.ImageSaved);
 Image1.Picture.Bitmap.PixelFormat:=pf24bit;
end;

procedure TImageForm.sbRestoreImageClick(Sender: TObject);
begin
 RestoreImage;
end;

procedure TImageForm.sbZeroPointsClick(Sender: TObject);
var PX, PXC, PXT{, PXB}:PByteArray; Y,i, Pix, Pix_offs, Pix_offs2, ValR, ValG, ValB:longint;
begin
 RestoreImage;
 SaveImage;
 if Image1.Picture.Height>0 then
 begin
// for Y:=Image1.Picture.Height-MainForm.Offs-1-MainForm.ImageCutBottom downto (Image1.Picture.Height-(Image1.Picture.Height-MainForm.ImageCutTop))+MainForm.Offs do
 for Y:=Image1.Picture.Height-MainForm.Offs-1-MainForm.ImageCutBottom downto (MainForm.ImageCutTop)+MainForm.Offs do
 begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  PXC:=MainForm.ImageSaved.ScanLine[Y];
  PXT:=MainForm.ImageSaved.ScanLine[Y-MainForm.Offs];
//  PXB:=ImageSaved.ScanLine[Y+Offs];
  for i:=MainForm.Offs to Image1.Width-MainForm.Offs-1 do
   begin
    Pix:=(i)*3;
    Pix_offs:=(i+MainForm.Offs)*3;
//    Pix_offs2:=(i-Offs)*3;
    ValR:=0; ValG:=0; ValB:=0; //for zero influence

    ValR:=abs(PXC[Pix]-PXC[Pix_offs]);
     if sbCheckBlockTopZero.Down then
      begin
       ValR:=(ValR+abs(PXC[Pix]-PXT[Pix])) div 1;
       {ValR:=(ValR+abs(PX[Pix]-PXB[Pix])) div 1;
       ValR:=(ValR+abs(PX[Pix]-PXC[Pix_offs2])) div 1;}
      end;
    ValG:=abs(PXC[Pix+1]-PXC[Pix_offs+1]);
     if sbCheckBlockTopZero.Down then
      begin
       ValG:=(ValG+abs(PXC[Pix+1]-PXT[Pix+1])) div 1;
       {ValG:=(ValG+abs(PX[Pix+1]-PXB[Pix+1])) div 1;
       ValG:=(ValG+abs(PX[Pix+1]-PXC[Pix_offs2+1])) div 1;}
      end;
    ValB:=abs(PXC[Pix+2]-PXC[Pix_offs+2]);
     if sbCheckBlockTopZero.Down then
      begin
       ValB:=(ValB+abs(PXC[Pix+2]-PXT[Pix+2])) div 1;
       {ValB:=(ValB+abs(PX[Pix+2]-PXB[Pix+2])) div 1;
       ValB:=(ValB+abs(PX[Pix+2]-PXC[Pix_offs2+2])) div 1;}
      end;
    SharpXRedTmp:=0;
    SharpXBlueTmp:=0;
    SharpXGreenTmp:=0;
     if (MainForm.IsDropRed) then begin if (ValR>MainForm.DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (MainForm.IsDropGreen) then begin if (ValG>MainForm.DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (MainForm.IsDropBlue) then begin if (ValB>MainForm.DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
    if (MainForm.IsDropSum) then if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>MainForm.DropSum) then SharpXBlueTmp:=0; SharpXGreenTmp:=0; SharpXRedTmp:=0;
    if (SharpXRedTmp=0) and (SharpXBlueTmp=0) and (SharpXGreenTmp=0) then
      begin PX[Pix]:=255; PX[Pix+1]:=255; PX[Pix+2]:=255; end //replaced with white
    else
      begin PX[Pix]:=0; PX[Pix+1]:=0; PX[Pix+2]:=0; end //replaced with black
   end;
//  Application.ProcessMessages;
 end;
{ for Y:=Image1.Picture.Height-Offs-1 downto (Image1.Picture.Height-(Image1.Picture.Height div ImagePartial))+Offs  do
 begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  PXC:=ImageSaved.ScanLine[Y];
  PXT:=ImageSaved.ScanLine[Y+Offs];
//  PXB:=ImageSaved.ScanLine[Y+Offs];
  for i:=Offs to FrameWidth-Offs-1 do
   begin
    Pix:=(i)*3;
//    Pix_offs:=(i+Offs)*3;
    Pix_offs:=(i-Offs)*3;
    ValR:=abs(PXC[Pix]-PXC[Pix_offs]);
     if sbCheckBlockTopZero.Down then
      begin
       ValR:=(ValR+abs(PXC[Pix]-PXT[Pix])) div 1;
      end;
    ValG:=abs(PXC[Pix+1]-PXC[Pix_offs+1]);
     if sbCheckBlockTopZero.Down then
      begin
       ValG:=(ValG+abs(PXC[Pix+1]-PXT[Pix+1])) div 1;
      end;
    ValB:=abs(PXC[Pix+2]-PXC[Pix_offs+2]);
     if sbCheckBlockTopZero.Down then
      begin
       ValB:=(ValB+abs(PXC[Pix+2]-PXT[Pix+2])) div 1;
      end;
    SharpXRedTmp:=0;
    SharpXBlueTmp:=0;
    SharpXGreenTmp:=0;
     if (IsDropRed) then begin if (ValR>DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (IsDropGreen) then begin if (ValG>DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (IsDropBlue) then begin if (ValB>DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
    if (IsDropSum) then if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>DropSum) then SharpXBlueTmp:=0; SharpXGreenTmp:=0; SharpXRedTmp:=0;
    if (SharpXRedTmp=0) and (SharpXBlueTmp=0) and (SharpXGreenTmp=0) then
  //    begin PX[Pix]:=255; PX[Pix+1]:=255; PX[Pix+2]:=255; end //replaced with white
    else
      begin PX[Pix]:=0; PX[Pix+1]:=0; PX[Pix+2]:=0; end //replaced with black
   end;
//  Application.ProcessMessages;
 end;}
 end;
end;

procedure TImageForm.sbGetFrameSampleClick(Sender: TObject);
begin
 if OpenBMP.Execute then
 begin
  Image1.Picture.Bitmap.LoadFromFile(OpenBMP.FileName);
  Image1.Picture.Bitmap.PixelFormat:=pf24bit;
  SaveImage;
  SharpGraph.Height:=Image1.Height;
//  FrameWidth:=Image1.Width;
//  FrameHeight:=Image1.Height;
 end;
end;

procedure TImageForm.sbCheckColorDominationClick(Sender: TObject);
var Dominators: array[0..50000] of TRGB24Count; DominatorsCount: integer;
var PX, PXC:PByteArray; Y,i, j, Pix, Pix_offs, Pix_offs2, ValR, ValG, ValB:longint;
    R1,G1,B1, R2,G2,B2: byte;
    ColorMatch1, ColorMatch2: boolean;
    MaxCount1, MaxCount2, MaxIndex1, MaxIndex2, Tolerance: integer;
begin
 RestoreImage;
 SaveImage;
 Tolerance:=10;
 if Image1.Picture.Height>0 then
 begin
 for i:=0 to 50000 do
  begin
   Dominators[i].R:=0;
   Dominators[i].G:=0;
   Dominators[i].B:=0;
   Dominators[i].Count:=-1;
  end;
 DominatorsCount:=0;
// for Y:=Image1.Picture.Height-MainForm.Offs-1 downto (Image1.Picture.Height-(Image1.Picture.Height div MainForm.ImagePartial))+MainForm.Offs do
 for Y:=Image1.Picture.Height-MainForm.Offs-1-MainForm.ImageCutBottom downto (MainForm.ImageCutTop)+MainForm.Offs do
 begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  PXC:=MainForm.ImageSaved.ScanLine[Y];
  for i:=MainForm.Offs to Image1.Width-MainForm.Offs-1 do
   begin
    Pix:=(i)*3;
    Pix_offs:=(i+MainForm.Offs)*3;
//    Pix_offs2:=(i-Offs)*3;
    ValR:=0; ValG:=0; ValB:=0; //for zero influence
    R1:=PXC[Pix]; G1:=PXC[Pix+1]; B1:=PXC[Pix+2];
    R2:=PXC[Pix_offs]; G2:=PXC[Pix_offs+1]; B2:=PXC[Pix_offs+2];
    ValR:=abs(PXC[Pix]-PXC[Pix_offs]); ValG:=abs(PXC[Pix+1]-PXC[Pix_offs+1]); ValB:=abs(PXC[Pix+2]-PXC[Pix_offs+2]);
    SharpXRedTmp:=0; SharpXBlueTmp:=0; SharpXGreenTmp:=0;
     if (MainForm.IsDropRed) then begin if (ValR>MainForm.DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (MainForm.IsDropGreen) then begin if (ValG>MainForm.DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (MainForm.IsDropBlue) then begin if (ValB>MainForm.DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
    if (MainForm.IsDropSum) then if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>MainForm.DropSum) then SharpXBlueTmp:=0; SharpXGreenTmp:=0; SharpXRedTmp:=0;
    if (SharpXRedTmp=0) and (SharpXBlueTmp=0) and (SharpXGreenTmp=0) then
      begin
       // no sharpness, point dropped
      end
    else
    if (SharpXRedTmp+SharpXGreenTmp+SharpXBlueTmp>(MainForm.BlockMinimum/16)) then
      begin
       // got sharpness, both point values noted
       if (DominatorsCount>0) then
        begin
         ColorMatch1:=false;
         ColorMatch2:=false;
         for j:=0 to DominatorsCount-1 do
         begin
          if  (Abs(R1-Dominators[j].R)<Tolerance)
          and (Abs(G1-Dominators[j].G)<Tolerance)
          and (Abs(B1-Dominators[j].B)<Tolerance)
           then begin Inc(Dominators[j].Count); ColorMatch1:=true; end;
          if  (Abs(R2-Dominators[j].R)<Tolerance)
          and (Abs(G2-Dominators[j].G)<Tolerance)
          and (Abs(B2-Dominators[j].B)<Tolerance)
           then begin Inc(Dominators[j].Count); ColorMatch2:=true; end;
         end;
         if not(ColorMatch1) then
          begin
           Dominators[DominatorsCount].R:=R1; Dominators[DominatorsCount].G:=G1; Dominators[DominatorsCount].B:=B1;
           Dominators[DominatorsCount].Count:=1;
           Inc(DominatorsCount);
          end;
         if not(ColorMatch2) then
          begin
           Dominators[DominatorsCount].R:=R2; Dominators[DominatorsCount].G:=G2; Dominators[DominatorsCount].B:=B2;
           Dominators[DominatorsCount].Count:=1;
           Inc(DominatorsCount);
          end;
        end
       else
        begin
         Dominators[0].R:=R1; Dominators[0].G:=G1; Dominators[0].B:=B1;
         Dominators[0].Count:=1;
         Inc(DominatorsCount);
          if  not((Abs(R1-R2)<Tolerance)
          and (Abs(G2-G1)<Tolerance)
          and (Abs(B2-B1)<Tolerance))
          then
          begin
           Dominators[DominatorsCount].R:=R2; Dominators[DominatorsCount].G:=G2; Dominators[DominatorsCount].B:=B2;
           Dominators[DominatorsCount].Count:=1;
           Inc(DominatorsCount);
          end;
        end;
      end
   end;
//  Application.ProcessMessages;
 end;
 MaxCount1:=0; MaxIndex1:=0;
 MaxCount2:=0; MaxIndex2:=0;
 for i:=0 to DominatorsCount-1 do
  begin
   if (Dominators[i].Count>MaxCount1) then
   begin
    if (MaxCount1>MaxCount2) then
     begin
      MaxCount2:=MaxCount1;
      MaxIndex2:=MaxIndex1;
     end;
    MaxCount1:=Dominators[i].Count;
    MaxIndex1:=i;
   end;
  end;
  if (MaxCount2=0) and (MaxCount1>0) then
  for i:=MaxIndex1+1 to DominatorsCount-1 do
   if (Dominators[i].Count>MaxCount2) then
   begin
    MaxCount2:=Dominators[i].Count;
    MaxIndex2:=i;
   end;

{  lbColor1.Color:=(Dominators[MaxIndex1].R+
                   Dominators[MaxIndex1].G*256+
                   Dominators[MaxIndex1].B*256*256);
  lbColor2.Color:=(Dominators[MaxIndex2].R+
                   Dominators[MaxIndex2].G*256+
                   Dominators[MaxIndex2].B*256*256);}

 if (sbRemainDominatingColors.Down) then
// for Y:=Image1.Picture.Height-MainForm.Offs-1 downto (Image1.Picture.Height-(Image1.Picture.Height div MainForm.ImagePartial))+MainForm.Offs do
 for Y:=Image1.Picture.Height-MainForm.Offs-1-MainForm.ImageCutBottom downto (MainForm.ImageCutTop)+MainForm.Offs do

 begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  PXC:=MainForm.ImageSaved.ScanLine[Y];
  for i:=MainForm.Offs to Image1.Width-MainForm.Offs-1 do
   begin
    Pix:=(i)*3;
    Pix_offs:=(i+MainForm.Offs)*3;
//    Pix_offs2:=(i-Offs)*3;
    R1:=PXC[Pix]; G1:=PXC[Pix+1]; B1:=PXC[Pix+2];
          if  not((Abs(R1-Dominators[MaxIndex1].R)<Tolerance)
          and (Abs(G1-Dominators[MaxIndex1].G)<Tolerance)
          and (Abs(B1-Dominators[MaxIndex1].B)<Tolerance))
          and
          not((Abs(R1-Dominators[MaxIndex2].R)<Tolerance)
          and (Abs(G1-Dominators[MaxIndex2].G)<Tolerance)
          and (Abs(B1-Dominators[MaxIndex2].B)<Tolerance))
          then
          begin
           PX[Pix]:=255;
           PX[Pix+1]:=255;
           PX[Pix+2]:=255;
          end
          else
          begin
           PX[Pix]:=0;
           PX[Pix+1]:=0;
           PX[Pix+2]:=0;
          end;
   end;
 end
 else   ShowMessage('Indexes: ' +
               IntToStr(MaxIndex2)+'/'+IntToStr(MaxCount2)+' ('+
               IntToStr(Dominators[MaxIndex2].R)+':'+
               IntToStr(Dominators[MaxIndex2].G)+':'+
               IntToStr(Dominators[MaxIndex2].B)+') '+
               IntToStr(MaxIndex1)+'/'+IntToStr(MaxCount1)+' ('+
               IntToStr(Dominators[MaxIndex1].R)+':'+
               IntToStr(Dominators[MaxIndex1].G)+':'+
               IntToStr(Dominators[MaxIndex1].B)+') '+
               IntToStr(DominatorsCount));

end;
end;

procedure TImageForm.FormHide(Sender: TObject);
begin
 MainForm.cbShowImage.Checked:=ImageForm.Visible;
 MainForm.ShowImages:=ImageForm.Visible;
end;

procedure TImageForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var PX: PByteArray;// R,G,B: byte;
begin
//

 PX:=Image1.Picture.Bitmap.ScanLine[Y];
 B:=PX[X*3];
 G:=PX[X*3+1];
 R:=PX[X*3+2];
 lbDominatorColor.Color:=B*256*256+G*256+R;
end;

procedure TImageForm.sbAddDominatorColorClick(Sender: TObject);
//var R,G,B: integer;
begin
//
// R:=lbDominatorColor.Color mod 256;
// G:=((lbDominatorColor.Color-R) mod 256*256) div 256;
// B:=((lbDominatorColor.Color-R-G*256) mod 256*256*256) div 256*256;
 SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
 MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
 MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
 MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
 MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
 MainForm.frmASDSettings.lbColorDominator.Color:=B*256*256+G*256+R;
 MainForm.frmASDSettings.lbCurrentDominator.Caption:=IntToStr(Length(MainForm.ColorDominators))+'/'+IntToStr(Length(MainForm.ColorDominators));
 MainForm.frmASDSettings.PanelSettingsToData(Sender);
end;

procedure TImageForm.sbSetDominatorColorClick(Sender: TObject);
//var R,G,B: integer;
begin
// R:=lbDominatorColor.Color mod 256;
// G:=((lbDominatorColor.Color-R) mod 256*256) div 256;
// B:=((lbDominatorColor.Color-R-G*256) mod 256*256*256) div 256*256;
 MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
 MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
 MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
 MainForm.frmASDSettings.lbColorDominator.Color:=B*256*256+G*256+R;
 MainForm.frmASDSettings.PanelSettingsToData(Sender);
end;

end.
