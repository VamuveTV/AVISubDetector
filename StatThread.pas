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
unit StatThread;

interface

uses
  Classes, Unit1, AVIFile, SysUtils, Math, VFW, MyTypes1, ASDSettings;

type
  TStatThread = class(TThread)
  private
    { Private declarations }
  protected
    ProcessFrame: integer;
    procedure Execute; override;
    procedure ParseFrame;
  public
    procedure InitThread(FrameNum: integer);
    function CurrentFrame:integer;
  end;

implementation

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure StatThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ StatThread }

function TStatThread.CurrentFrame;
begin
 Result:=ProcessFrame;
end;

procedure TStatThread.ParseFrame;
var ImageArr: PByteArray; CurrentFrameStats:TFrameStat; i:integer;
begin
//  MainForm.FrameIndex := ProcessFrame;
//  MainForm.FramePanel.Caption:='Current Frame: '+IntToStr(ProcessFrame)+' / '+IntToStr(AVIFile.MovieLength);

  i:=ProcessFrame;
   pbmi:=AVIStreamGetFrame(ob,i);
   while (pbmi=nil) and (ProcessFrame<AVIFile.MovieLength) do
   begin
    inc(i);
    pbmi:=AVIStreamGetFrame(ob,i);
    INC (ProcessFrame);
   end;


//  MainForm.CurrentStatus:=ST_NO_SUBTITLE;
//  if pbmi.biBitCount=24 then {continue with process}
//  While (pbmi<>Nil) and (MainForm.StopProcess=false) and (MainForm.PauseProcess=false)
//        and (MainForm.FrameIndex<AVIFile.MovieLength) do
//  begin
   ImageArr:=Pointer(Integer(pbmi)+pbmi^.biSize);
   if MainForm.IsPreprocess then
   begin
    AviFile.FrameToBitmap(AviFile.ImagePreprocessed,pbmi);
    MainForm.PreprocessImage2(AviFile.ImagePreprocessed,0,Min(FrameHeight-MainForm.ImageCutBottom-1,MainForm.ImageCutTop),
                                               FrameWidth-1,Max(FrameHeight-MainForm.ImageCutBottom-1,MainForm.ImageCutTop));
    ImageArr:=AviFile.ImagePreprocessed.ScanLine[ImagePreprocessed.Height-1];
   end;
  //doing image processing
   {MainForm.}frmASDSettings.ProcessImage(ImageArr,CurrentFrameStats);

   if Length(MainForm.Stats)>ProcessFrame then MainForm.Stats[ProcessFrame]:=CurrentFrameStats;
//   MainForm.UpdateStatusFor(MainForm.CurrentStatus,Max(ProcessFrame-MainForm.IgnorePeakDistance,0));

//   MainForm.SetPos(ProcessFrame); //   tbFrameSeek.Position:=FrameIndex;
//   MainForm.UpdateStatus;
//   Application.ProcessMessages;

//   ActByStatus(CurrentStatus); //creates subs, saves bitmaps, asks for user input etc

  //getting next frame
//   MainForm.FramePanel.Caption:='*Current Frame*: '+IntToStr(ProcessFrame-MainForm.IgnorePeakDistance+1)+' / '+IntToStr(AVIFile.MovieLength);

//   Application.ProcessMessages;
//   inc(i);


   INC (ProcessFrame);
end;

procedure TStatThread.InitThread;
begin
 ProcessFrame:=FrameNum;
end;

procedure TStatThread.Execute;
begin
 while not(Terminated) do
  Synchronize(ParseFrame);
  { Place thread code here }
end;

end.
