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
unit StatsForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, CheckLst, Math, AviFile;

type
  TStatForm = class(TForm)
    pbMainGraph: TPaintBox;
    pbDiffGraph: TPaintBox;
    pnlStatsControls: TPanel;
    stCurrentFrameStats: TStaticText;
    stLastChangedFrame: TStaticText;
    stLocalMax: TStaticText;
    Splitter1: TSplitter;
    clbShowGraphs: TCheckListBox;
    procedure pbMainGraphMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainGraphMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainGraphMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainGraphPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
{    procedure pbMainGraphPaint(Sender: TObject);
    procedure pbMainGraphMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainGraphMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainGraphMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);}
  private
    { Private declarations }
  public
     {ImageSaved,} MainGraphImg, DiffGraphImg: TBitmap;
    { Public declarations }
  end;

var
  StatForm: TStatForm;

implementation

uses Unit1;

{$R *.DFM}

procedure TStatForm.pbMainGraphMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var Start: integer;
begin
 if (ssLeft in Shift) then
 begin
  MainForm.SelectingGraphPos:=true;
  Start:=Max(0,MainForm.FrameIndex-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  MainForm.NewGraphPos:=Start + X;
  pbMainGraphPaint(Sender);
//  pbMainGraph.Invalidate;
 end;

end;

procedure TStatForm.pbMainGraphMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var NewPos, Start: integer;
begin
 if (ssLeft in Shift) then
 begin
  MainForm.SelectingGraphPos:=true;
  Start:=Max(0,MainForm.FrameIndex-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  MainForm.NewGraphPos:=Start + X;
  pbMainGraphPaint(Sender);
//  pbMainGraph.Invalidate;
 end;
end;

procedure TStatForm.pbMainGraphMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Start: integer;
begin
 if Button=mbLeft then
 begin
  Start:=Max(0,MainForm.FrameIndex-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  MainForm.NewGraphPos:=Start + X;
  MainForm.NewGraphPos:=Max(0,MainForm.NewGraphPos);
  MainForm.NewGraphPos:=Min(MainForm.tbFrameSeek.Max,MainForm.NewGraphPos);
  MainForm.SetPos(MainForm.NewGraphPos);//  tbFrameSeek.Position:=NewGraphPos;
  MainForm.SelectingGraphPos:=false;
 end;
end;

procedure TStatForm.pbMainGraphPaint(Sender: TObject);
var i, start, stop, x, y, ht, ht2, LocalMax, LocalLimit: integer;
    MainCanvas, DiffCanvas: TCanvas;
    R,G,B: byte; s:string; First: boolean;
begin
 if Length(MainForm.Stats)=0 then exit;
 Start:=Max(0,MainForm.FrameIndex-(pbMainGraph.ClientWidth div 2));
 Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
 Start:=Max(0,Start);
// if (Start<0) then Sta
 Stop:=Max(pbMainGraph.ClientWidth,MainForm.FrameIndex+(pbMainGraph.ClientWidth div 2));
 Stop:=Min(AviFile.MovieLength,Stop);
 Stop:=Stop-1;

 if (MainGraphImg.Height<>pbMainGraph.ClientHeight) or (MainGraphImg.Width<>pbMainGraph.ClientWidth) then
 begin
  MainGraphImg.Height:=pbMainGraph.ClientHeight;
  MainGraphImg.Width:=pbMainGraph.ClientWidth;
 end;
 if (DiffGraphImg.Height<>pbDiffGraph.ClientHeight) or (DiffGraphImg.Width<>pbDiffGraph.ClientWidth) then
 begin
  DiffGraphImg.Height:=pbDiffGraph.ClientHeight;
  DiffGraphImg.Width:=pbDiffGraph.ClientWidth;
 end;

 MainCanvas:=MainGraphImg.Canvas;//pbMainGraph.Canvas;
 DiffCanvas:=DiffGraphImg.Canvas;//pbDiffGraph.Canvas;

 MainCanvas.Brush.Color:=clWhite;
 MainCanvas.FillRect(pbMainGraph.Canvas.ClipRect);
 DiffCanvas.Brush.Color:=clWhite;
 DiffCanvas.FillRect(pbDiffGraph.Canvas.ClipRect);

  ht:=pbMainGraph.ClientHeight-2;
  ht2:=pbDiffGraph.ClientHeight-2;

 s:='Graph Maximums'+#13#10;
 if clbShowGraphs.Checked[0] then
// if cbDLCGraph.Checked then
 begin
  LocalLimit:=MainForm.LineCountNeeded;
  LocalMax:=LocalLimit*2;
  for i:=Start to Stop do
   if (MainForm.Stats[i].DLC>LocalMax) and (MainForm.Stats[i].HasData) then
   LocalMax:=MainForm.Stats[i].DLC;
  s:=s+'DLC: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=clBlue;
  First:=true; for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].DLC/LocalMax)); x:=i-Start;
     if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y); First:=false;
   end;
    MainCanvas.Pen.Mode:=pmNot;
    y:=Trunc(ht-ht*(LocalLimit/LocalMax));
    MainCanvas.MoveTo(0,y);
    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);
    //end of main graph

   LocalLimit:=MainForm.LineNumberChangeThreshold;
   LocalMax:=LocalLimit*2; //    LocalMax:=LineNumberChangeThreshold*2;
    for i:=Start+1 to Stop do
     if (MainForm.Stats[i].HasData) and (MainForm.Stats[i-1].HasData)
      then if (abs(MainForm.Stats[i].DLC-MainForm.Stats[i-1].DLC)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].DLC-MainForm.Stats[i-1].DLC);

    s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=clBlue;
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].DLC-Stats[i-1].DLC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].DLC-MainForm.Stats[i-1].DLC)/(LocalMax*2)); x:=i-Start;
     if First then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
    First:=false;
    end;
    DiffCanvas.Pen.Mode:=pmNot;
//    y:=Trunc(ht2-ht2*(LineNumberChangeThreshold/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;

 if clbShowGraphs.Checked[1] then
// if cbMEDGraph.Checked then
 begin
  R:=0; B:=0; G:=128;
  LocalMax:=1;
  for i:=Start to Stop do if (MainForm.Stats[i].MED>LocalMax) and (MainForm.Stats[i].HasData) then LocalMax:=MainForm.Stats[i].MED;
    s:=s+'MED: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  First:=true;
  for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].MED/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y);
    First:=false;
   end;
{    MainCanvas.Pen.Mode:=pmNot;
    y:=Trunc(ht-ht*(LineCountNeeded/LocalMax));
    MainCanvas.MoveTo(0,y);
    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);}
    //end of main graph

    LocalLimit:=MainForm.SharpLinesAvgMinChange;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (MainForm.Stats[i].HasData) and (abs(MainForm.Stats[i].MED-MainForm.Stats[i-1].MED)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].MED-MainForm.Stats[i-1].MED);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    R:=0; B:=0; G:=128;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MED-Stats[i-1].MED)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].MED-MainForm.Stats[i-1].MED)/(LocalMax*2)); x:=i-Start;
     if First then DiffCanvas.MoveTo(x,y)
     else DiffCanvas.LineTo(x,y);
    First:=false;
    end;
    R:=0; B:=0; G:=256-24; DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
//    y:=Trunc(ht2-ht2*(SharpLinesAvgMinChange/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;

 if clbShowGraphs.Checked[2] then
// if cbMBCGraph.Checked then
 begin
  LocalMax:=1;
  for i:=Start to Stop do if (MainForm.Stats[i].MBC>LocalMax) and (MainForm.Stats[i].HasData) then LocalMax:=MainForm.Stats[i].MBC;
  s:=s+'MBC: '+IntToStr(LocalMax);

  R:=64; B:=64; G:=64; MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].MBC/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y);
    First:=false;
   end;
    //end of main graph

    LocalLimit:=MainForm.MaxLineBlockCountDiff;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (MainForm.Stats[i].HasData) and (abs(MainForm.Stats[i].MBC-MainForm.Stats[i-1].MBC)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].MBC-MainForm.Stats[i-1].MBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].MBC-MainForm.Stats[i-1].MBC)/(LocalMax*2)); x:=i-Start;
    if First then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
     First:=false;
    end;
    R:=64*3; B:=64*3; G:=64*3;     DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
//    y:=Trunc(ht2-ht2*(MaxLineBlockCountDiff/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;

 if clbShowGraphs.Checked[3] then
// if cbLBCGraph.Checked then
 begin
  LocalMax:=1;
  for i:=Start to Stop do if (MainForm.Stats[i].LBC>LocalMax) and (MainForm.Stats[i].HasData) then LocalMax:=MainForm.Stats[i].LBC;
   s:=s+'LBC: '+IntToStr(LocalMax);

  R:=255; B:=64; G:=64; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].LBC/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
     First:=false;
   end;
    //end of main graph

    LocalLimit:=MainForm.LBCLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (MainForm.Stats[i].HasData) and (abs(MainForm.Stats[i].LBC-MainForm.Stats[i-1].LBC)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].LBC-MainForm.Stats[i-1].LBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].LBC-MainForm.Stats[i-1].LBC)/(LocalMax*2)); x:=i-Start;
     if First then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
     First:=false;
    end;
    R:=255; B:=64*2; G:=64*2;     DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
//    y:=Trunc(ht2-ht2*(MaxLineBlockCountDiff/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;
// ------------ LMB
 if clbShowGraphs.Checked[4] then
// if cbLBCGraph.Checked then
 begin
  LocalMax:=FrameWidth;
  for i:=Start to Stop do if (MainForm.Stats[i].LMB>LocalMax) and (MainForm.Stats[i].HasData) then LocalMax:=MainForm.Stats[i].LMB;
   s:=s+'LMB: '+IntToStr(LocalMax);

  R:=255; B:=128; G:=128; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].LMB/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
    First:=false;
   end;
    //end of main graph

    LocalLimit:=MainForm.LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (MainForm.Stats[i].HasData) and (abs(MainForm.Stats[i].LMB-MainForm.Stats[i-1].LMB)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].LMB-MainForm.Stats[i-1].LMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].LMB-MainForm.Stats[i-1].LMB)/(LocalMax*2)); x:=i-Start;
     if First then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y); First:=false;
    end;
    R:=255; B:=128; G:=128;     DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
//    y:=Trunc(ht2-ht2*(MaxLineBlockCountDiff/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;
// ------------ RMB
 if clbShowGraphs.Checked[5] then
// if cbLBCGraph.Checked then
 begin
  LocalMax:=FrameWidth;
  for i:=Start to Stop do if (MainForm.Stats[i].RMB>LocalMax) and (MainForm.Stats[i].HasData) then LocalMax:=MainForm.Stats[i].RMB;
   s:=s+'RMB: '+IntToStr(LocalMax);

  R:=128; B:=128; G:=255; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if MainForm.Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(MainForm.Stats[i].RMB/LocalMax)); x:=i-Start;
     if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y); First:=false;
   end;
    //end of main graph

    LocalLimit:=MainForm.LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (MainForm.Stats[i].HasData) and (abs(MainForm.Stats[i].RMB-MainForm.Stats[i-1].RMB)>LocalMax) then LocalMax:=abs(MainForm.Stats[i].RMB-MainForm.Stats[i-1].RMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if MainForm.Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(MainForm.Stats[i].RMB-MainForm.Stats[i-1].RMB)/(LocalMax*2)); x:=i-Start;
     if First then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y); First:=false;
    end;
//    R:=255; B:=64*2; G:=64*2;     DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    R:=128; B:=128; G:=255;     DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
//    y:=Trunc(ht2-ht2*(MaxLineBlockCountDiff/LocalMax));
    y:=Trunc(ht2/2-ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
    y:=Trunc(ht2/2+ht2*(LocalLimit)/(LocalMax*2)); x:=i-Start;
    DiffCanvas.MoveTo(0,y); DiffCanvas.LineTo(pbDiffGraph.ClientWidth,y);
 end;

    DiffCanvas.Pen.Mode:=pmNot;
    x:=MainForm.FrameIndex-Start;
    DiffCanvas.MoveTo(x,0);
    DiffCanvas.LineTo(x,pbDiffGraph.ClientHeight);

    MainCanvas.Pen.Mode:=pmNot; //    x:=tbFrameSeek.Position-Start;
    MainCanvas.MoveTo(x,0);
    MainCanvas.LineTo(x,pbMainGraph.ClientHeight);

    if MainForm.SelectingGraphPos and (MainForm.NewGraphPos<>MainForm.FrameIndex) then
    begin
     x:=MainForm.NewGraphPos-Start;
     MainCanvas.Pen.Mode:=pmNot; //    x:=tbFrameSeek.Position-Start;
     MainCanvas.MoveTo(x,0);
     MainCanvas.LineTo(x,pbMainGraph.ClientHeight);
     DiffCanvas.Pen.Mode:=pmNot;
     DiffCanvas.MoveTo(x,0);
     DiffCanvas.LineTo(x,pbDiffGraph.ClientHeight);
    end;

  BitBlt(pbMainGraph.Canvas.Handle,0,0,pbMainGraph.ClientWidth,pbMainGraph.ClientHeight,
         MainGraphImg.Canvas.Handle,0,0,SRCCOPY);  
  BitBlt(pbDiffGraph.Canvas.Handle,0,0,pbDiffGraph.ClientWidth,pbDiffGraph.ClientHeight,
         DiffGraphImg.Canvas.Handle,0,0,SRCCOPY);
  stLocalMax.Caption:=s;
end;

procedure TStatForm.FormCreate(Sender: TObject);
begin
 MainGraphImg:=TBitmap.Create;
 DiffGraphImg:=TBitmap.Create;
end;

procedure TStatForm.FormDestroy(Sender: TObject);
begin
 MainGraphImg.Free;
 DiffGraphImg.Free;
end;

end.
