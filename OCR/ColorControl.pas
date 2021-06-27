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
unit ColorControl;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Math, MyTypes1;

const CrossColor = clGreen;
const CrossBase = 10;

type
   TTwoColorMapArray = array[0..255,0..255] of integer; 
type
  TColorControlFrame = class(TFrame)
    scrlbColorControl: TScrollBox;
    tbR: TTrackBar;
    tbG: TTrackBar;
    tbB: TTrackBar;
    btAnalyze: TButton;
    tbLimit: TTrackBar;
    pbScatterPlotRG: TPaintBox;
    pbScatterPlotGB: TPaintBox;
    pbScatterPlotBG: TPaintBox;
    pbScatterPlotBR: TPaintBox;
    pbScatterPlotGR: TPaintBox;
    pbScatterPlotRB: TPaintBox;
    Panel1: TPanel;
    pbDominators: TPaintBox;
    tbDev: TTrackBar;
    btAnalyzeDrop: TButton;
    tbRD: TTrackBar;
    tbGD: TTrackBar;
    tbBD: TTrackBar;
    procedure pbScatterPlotGBPaint(Sender: TObject);
    procedure btAnalyzeClick(Sender: TObject);
    procedure pbScatterPlotRGPaint(Sender: TObject);
    procedure pbScatterPlotRBPaint(Sender: TObject);
    procedure pbScatterPlotRGMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbRChange(Sender: TObject);
    procedure pbDominatorsPaint(Sender: TObject);
    procedure pbDominatorsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btAnalyzeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
    procedure pbScatterPlotBGPaint(Sender: TObject);
    procedure pbScatterPlotGRPaint(Sender: TObject);
    procedure pbScatterPlotBRPaint(Sender: TObject);
//    procedure pbScatterPlotPaint(Sender: TObject);
  private
    { Private declarations }
//    procedure PutCross(Bmp1, Bmp2: TBitmap; X,Y,XD, YD: integer); overload;
//    procedure PutCross(Bmp1: TBitmap; X,Y: integer); overload;
    procedure PutCross(Bmp1: TBitmap; X,Y,XD, YD: integer); overload;
  public
    { Public declarations }
    CurrentDominator: TColorDominator;
    ColorMap: array[0..255,0..255,0..255] of integer; //check all colors
    ColorMapRG, ColorMapRB, ColorMapGB: TTwoColorMapArray;
    DelayUpdate: boolean;
    AnalyzeType: byte;
//    ColorMapBitmap: TBitmap;
    procedure AnalyzeBitmap(Bmp:TBitmap);
    procedure AnalyzeBitmapDrop(Bmp:TBitmap);
    procedure AnalyzeFrame; //analyzes current frame according to last selected analyzis type
    procedure PaintScatterPlot;
    procedure Init;
    procedure UpdateCurrentDominator;
    procedure DrawScatterPlot(ColorMap : TTwoColorMapArray; XY: boolean; Dest: TCanvas; CX,CY, CXD, CYD: integer);
//    procedure Done;
  end;

implementation

{$R *.DFM}

uses AviFile, Unit1;

procedure TColorControlFrame.Init;
begin
 DelayUpdate:=false;
 AnalyzeType:=1;
end;

procedure TColorControlFrame.AnalyzeFrame;
begin
 AviFile.GetFrame(MainForm.FrameIndex);
 case AnalyzeType of
  1: AnalyzeBitmap(AviFile.ImageSaved);
  2: AnalyzeBitmapDrop(AviFile.ImageSaved);
 end; 
// if (Sender as TControl).Tag=1 then AnalyzeBitmap(AviFile.ImageSaved);
// if (Sender as TControl).Tag=2 then AnalyzeBitmapDrop(AviFile.ImageSaved);
end;

procedure TColorControlFrame.AnalyzeBitmap;
var X,Y, i,j,k:integer;
    R,G,B:byte; Dev: integer;
    PXC: PByteArray;
    RIn, GIn, BIn: extended;
    ROut, GOut, BOut: extended;
    RNear, GNear, BNear: extended;
begin
//
 for i:=0 to 255 do
  for j:=0 to 255 do
  begin
   ColorMapRG[i,j]:=0;
   ColorMapRB[i,j]:=0;
   ColorMapGB[i,j]:=0;
   for k:=0 to 255 do ColorMap[i,j,k]:=0;
  end; 
// for Y:=0 to Bmp.Height-1 do
 for Y:=MainForm.ImageCutTop to FrameHeight-MainForm.ImageCutBottom-1 do
 begin
  PXC:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
   R:=PXC[X*3+2]; G:=PXC[X*3+1]; B:=PXC[X*3];
   Inc(ColorMap[R,G,B]);
   Inc(ColorMapRG[R,G]);
   Inc(ColorMapRB[R,B]);
   Inc(ColorMapGB[G,B]);
{   Dev:=abs(R-CurrentDominator.R)+abs(G-CurrentDominator.G)+abs(B-CurrentDominator.B);
   IF Dev<CurrentDominator.Deviation THEN
    begin //inside - fill statistics

    end
   ELSE
    begin //outside - fill statistics
    end;}

  end;
 end;
 PaintScatterPlot;
end;

procedure TColorControlFrame.AnalyzeBitmapDrop;
var X,Y, i,j,k:integer;
    R,G,B:byte; Dev: integer;
    RX,GX,BX:byte;
    PXC: PByteArray;
    RIn, GIn, BIn: extended;
    ROut, GOut, BOut: extended;
    RNear, GNear, BNear: extended;
begin
//
 for i:=0 to 255 do
  for j:=0 to 255 do
  begin
   ColorMapRG[i,j]:=0;
   ColorMapRB[i,j]:=0;
   ColorMapGB[i,j]:=0;
   for k:=0 to 255 do ColorMap[i,j,k]:=0;
  end; 
 for Y:=MainForm.ImageCutTop to FrameHeight-MainForm.ImageCutBottom do
 begin
  PXC:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1-1 do
  begin
   R:=PXC[X*3+2]; G:=PXC[X*3+1]; B:=PXC[X*3];
   RX:=PXC[(X+1)*3+2]; GX:=PXC[(X+1)*3+1]; BX:=PXC[(X+1)*3];
   R:=Abs(RX-R); G:=Abs(GX-G); B:=Abs(BX-B);

   Inc(ColorMap[R,G,B]);
   Inc(ColorMapRG[R,G]);
   Inc(ColorMapRB[R,B]);
   Inc(ColorMapGB[G,B]);

  end;
 end;
 PaintScatterPlot;
end;

procedure TColorControlFrame.btAnalyzeClick(Sender: TObject);
begin
//
 AnalyzeType:=(Sender as TControl).Tag;
 case AnalyzeType of
  1: begin
      btAnalyze.Caption:='*Color Map*';
      btAnalyzeDrop.Caption:='Difference Map';
     end;
  2: begin
      btAnalyze.Caption:='Color Map';
      btAnalyzeDrop.Caption:='*Difference Map*';
     end;
 end;
 AnalyzeFrame;
// if (Sender as TControl).Tag=1 then AnalyzeBitmap(AviFile.ImageSaved);
// if (Sender as TControl).Tag=2 then AnalyzeBitmapDrop(AviFile.ImageSaved);
end;

procedure TColorControlFrame.pbScatterPlotRGMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (Button = mbLeft) then
 begin
  DelayUpdate:=true;
  if (X>=0) and (X<256) then
    case (Sender as TComponent).Tag of
     1, 4: tbR.Position:=X;
     2, 5: tbG.Position:=X;
     3, 6: tbB.Position:=X;
    end;
  if (Y>=0) and (Y<256) then
    case (Sender as TComponent).Tag of
     1, 3: tbG.Position:=Y;
     5, 6: tbR.Position:=Y;
     4, 2: tbB.Position:=Y;
    end;
  if (ssShift in Shift) then
   begin //add current "position" as additional dominator
    SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
    MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
    MainForm.ColorDominators[MainForm.DominatorSelected].R:=tbR.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].G:=tbG.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].B:=tbB.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=1; //main
//    MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=tbDev.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].RD:=tbDev.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].GD:=tbDev.Position;
    MainForm.ColorDominators[MainForm.DominatorSelected].BD:=tbDev.Position;
   end;
  DelayUpdate:=false;
  tbRChange(Self);//  PaintScatterPlot;
 end;
end;

procedure TColorControlFrame.PaintScatterPlot;
var Y1, Y2:integer;
begin
 if not(DelayUpdate) then
 begin
   DelayUpdate:=true;
//   Y1:=pbScatterPlotRG.ClientToScreen(Point(0,0)).Y;
//   Y2:=MainForm.ClientToScreen(Point(0,0)).Y;
//   if (Y1-100)<Y2 then begin  DelayUpdate:=false; exit; end;
{  if ((pbScatterPlotRG.ClientToScreen(Point(0,0)).Y-100)<MainForm.ClientToScreen(Point(0,0)).Y)
   then    exit;}
  pbScatterPlotRGPaint(Self);
  pbScatterPlotRBPaint(Self);
  pbScatterPlotGBPaint(Self);
  pbScatterPlotGRPaint(Self);
  pbScatterPlotBRPaint(Self);
  pbScatterPlotBGPaint(Self);
//  pbScatterPlotPaint(Self);
  DelayUpdate:=false;
 end;
end;

procedure TColorControlFrame.tbRChange(Sender: TObject);
begin
 if not(DelayUpdate) then
 begin
  CurrentDominator.R:=tbR.Position;
  CurrentDominator.G:=tbG.Position;
  CurrentDominator.B:=tbB.Position;
//  CurrentDominator.Deviation:=tbDev.Position;
  if (Sender <> tbDev) then
  begin
   CurrentDominator.RD:=tbRD.Position;
   CurrentDominator.GD:=tbGD.Position;
   CurrentDominator.BD:=tbBD.Position;
  end
  else
  begin
   CurrentDominator.RD:=tbDev.Position;
   CurrentDominator.GD:=tbDev.Position;
   CurrentDominator.BD:=tbDev.Position;
   tbRD.Position:=tbDev.Position;
   tbGD.Position:=tbDev.Position;
   tbBD.Position:=tbDev.Position;
  end;
  
  MainForm.ColorDominators[MainForm.DominatorSelected]:=CurrentDominator;
  PaintScatterPlot;
  pbDominatorsPaint(Self);
 end; 
end;

procedure TColorControlFrame.pbDominatorsPaint(Sender: TObject);
var i, j, W, H, X, Y: integer; Bmp:TBitmap; R,G,B: byte; s:string;
begin
//
 Bmp:=TBitmap.Create;
 W:=pbDominators.Width; H:=pbDominators.Height;
 Bmp.Width:=W; Bmp.Height:=H;
 Bmp.Canvas.Pen.Color:=clBlack;
 Bmp.Canvas.Pen.Mode:=pmCopy;

 for i:=0 to Length(MainForm.ColorDominators)-1 do
 with Bmp.Canvas do
 begin
  R:=MainForm.ColorDominators[i].R;
  G:=MainForm.ColorDominators[i].G;
  B:=MainForm.ColorDominators[i].B;
  Brush.Color:=B*256*256+G*256+R;



  Rectangle(i*H+4,4,(i+1)*H-4,H-4);

  if (B>128) then B:=0 else B:=255;
  if (G>128) then G:=0 else G:=255;
  if (R>128) then R:=0 else R:=255;
  Font.Color:=B*256*256+G*256+R;
  Font.Height:=H-4*2;
  Font.Style:=[fsBold];
  case MainForm.ColorDominators[i].DomType of
   0: s:='X';
   1: s:='T';
   2: s:='O';
   else s:='';
  end;
  X:=TextWidth(s);
  Y:=TextHeight(s);
  TextOut(H*i+((H - X) div 2),(H -Y) div 2,s);
  
  Bmp.Canvas.Brush.Color:=clBlack;
  FrameRect(Rect(i*H+1,1,(i+1)*H-1,H-1));
 end;
 i:=MainForm.DominatorSelected;
 Bmp.Canvas.FrameRect(Rect(i*H+2,2,(i+1)*H-2,H-2));
 BitBlt(pbDominators.Canvas.Handle,0,0,W,H,Bmp.Canvas.Handle,0,0,SRCCOPY);
 Bmp.Free;
end;

procedure TColorControlFrame.pbDominatorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Sel: integer;  
begin
 if Button=mbLeft then
 begin
  Sel:=(X div pbDominators.Height);
  if (Sel<Length(MainForm.ColorDominators)) then
  begin
   btAnalyze.SetFocus;
   if Sel<>MainForm.DominatorSelected then
    begin
    MainForm.DominatorSelected:=Sel;
    UpdateCurrentDominator;
    end
   else
    begin
     case CurrentDominator.DomType of
      0: CurrentDominator.DomType:=1;
      1: CurrentDominator.DomType:=2;
      2: CurrentDominator.DomType:=0;
     else CurrentDominator.DomType:=0;
     end;
    MainForm.ColorDominators[Sel]:=CurrentDominator;
    pbDominatorsPaint(Sender);
    end;
  end;
 end;
end;

procedure TColorControlFrame.UpdateCurrentDominator;
begin
  CurrentDominator:=MainForm.ColorDominators[MainForm.DominatorSelected];
  DelayUpdate:=true;
  tbR.Position:=CurrentDominator.R;
  tbG.Position:=CurrentDominator.G;
  tbB.Position:=CurrentDominator.B;
  tbRD.Position:=CurrentDominator.RD;
  tbGD.Position:=CurrentDominator.GD;
  tbBD.Position:=CurrentDominator.BD;
//  tbDev.Position:=CurrentDominator.Deviation;
  DelayUpdate:=false;
  PaintScatterPlot;
  pbDominatorsPaint(Self);
end;

procedure TColorControlFrame.PutCross(Bmp1: TBitmap; X,Y,XD, YD: integer);
begin
  with Bmp1.Canvas do
  begin
   Pen.Mode:=pmNot; //pmCopy;  Pen.Color:=CrossColor;
   MoveTo(Max(X-CrossBase,0),Y); LineTo(Min(X+CrossBase,255),Y);
   MoveTo(X,Max(Y-CrossBase,0)); LineTo(X,Min(Y+CrossBase,255));
   Brush.Color:=clGreen;
   if AnalyzeType=1 then begin FrameRect(Rect(X-XD,Y-YD,X+XD,Y+YD)); end;
  end;
end;


{procedure TColorControlFrame.PutCross(Bmp1: TBitmap; X,Y: integer);
var Val: integer;
begin
//  X:=tbR.Position;  Y:=tbB.Position;
//  if AnalyzeType<>1 then exit; //no crosses in other modes
//  Val:=CurrentDominator.Deviation;
  Val:=10;
  with Bmp1.Canvas do
  begin
   Pen.Mode:=pmNot; //pmCopy;  Pen.Color:=CrossColor;
//   MoveTo(Max(X-CrossBase,0),Y); LineTo(Min(X+CrossBase,255),Y);
//   MoveTo(X,Max(Y-CrossBase,0)); LineTo(X,Min(Y+CrossBase,255));
   MoveTo(X-CrossBase,Y); LineTo(X+CrossBase,Y);
   MoveTo(X,Y-CrossBase); LineTo(X,Y+CrossBase);
   if AnalyzeType=1 then begin
   MoveTo(X-Val,Y); LineTo(X,Y+Val); LineTo(X+Val,Y); LineTo(X,Y-Val); LineTo(X-Val,Y);
   end;
  end;
end;}

procedure TColorControlFrame.btAnalyzeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var i:integer;  
begin
//
 if (Key=VK_DELETE) then
 begin
  if (Length(MainForm.ColorDominators)>1) then
  begin
  for i:=MainForm.DominatorSelected to Length(MainForm.ColorDominators)-2 do
    MainForm.ColorDominators[i]:=MainForm.ColorDominators[i+1];
   SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)-1);
   MainForm.DominatorSelected:=Max(MainForm.DominatorSelected-1,System.Length(MainForm.ColorDominators)-1);
  end;
  UpdateCurrentDominator;
 end;
end;

procedure TColorControlFrame.FrameResize(Sender: TObject);
begin
//
 tbR.Width:=ClientWidth-50;
 tbG.Width:=ClientWidth-50;
 tbB.Width:=ClientWidth-50;
 tbDev.Width:=ClientWidth-50;
 tbRD.Width:=ClientWidth-50;
 tbGD.Width:=ClientWidth-50;
 tbBD.Width:=ClientWidth-50;
 tbLimit.Width:=ClientWidth-50;
end;

procedure TColorControlFrame.DrawScatterPlot(ColorMap : TTwoColorMapArray; XY: boolean; Dest: TCanvas; CX,CY, CXD, CYD: integer);
var Bmp :TBitmap; X, Y, Limit, Ctr, i, W,H, Val: integer; PXC1:PByteArray;
begin
 Limit:=tbLimit.Position*1;
 Bmp:=TBitmap.Create;
 W:=256; H:=256;
 try
  Bmp.Width:=W;  Bmp.Height:=H;  Bmp.PixelFormat:=pf24bit;
  for Y:=0 to 255 do
  begin
   PXC1:=Bmp.ScanLine[Y];
   for X:=0 to 255 do
   begin
    if XY then
     if ColorMap[X,Y]>=Limit then Val:=0 else Val:=255-Round((ColorMap[X,Y]/Limit)*255)
    else
     if ColorMap[Y,X]>=Limit then Val:=0 else Val:=255-Round((ColorMap[Y,X]/Limit)*255);
    PXC1[X*3]:=Val; PXC1[X*3+1]:=Val; PXC1[X*3+2]:=Val;
   end;
  end;
  PutCross(Bmp,CX,CY,CXD,CYD);
  BitBlt(Dest.Handle,0,0,W,H,Bmp.Canvas.Handle,0,0,SRCCOPY);
 finally
  Bmp.Free;
 end;
end;

procedure TColorControlFrame.pbScatterPlotBGPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapGB,false,pbScatterPlotBG.Canvas,tbB.Position,tbG.Position,tbBD.Position,tbGD.Position);
end;

procedure TColorControlFrame.pbScatterPlotGRPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapRG,false,pbScatterPlotGR.Canvas,tbG.Position,tbR.Position,tbGD.Position,tbRD.Position);
end;

procedure TColorControlFrame.pbScatterPlotBRPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapRB,false,pbScatterPlotBR.Canvas,tbB.Position,tbR.Position,tbBD.Position,tbRD.Position);
end;

procedure TColorControlFrame.pbScatterPlotRGPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapRG,true,pbScatterPlotRG.Canvas,tbR.Position,tbG.Position,tbRD.Position,tbGD.Position);
end;

procedure TColorControlFrame.pbScatterPlotRBPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapRB,true,pbScatterPlotRB.Canvas,tbR.Position,tbB.Position,tbRD.Position,tbBD.Position);
end;

procedure TColorControlFrame.pbScatterPlotGBPaint(Sender: TObject);
begin
 DrawScatterPlot(ColorMapGB,true,pbScatterPlotGB.Canvas,tbG.Position,tbB.Position,tbGD.Position,tbBD.Position);
end;


end.
