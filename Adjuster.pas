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
unit Adjuster;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, Math, ExtDlgs;

type
  TAdjustmentForm = class(TForm)
    pbFrame: TPaintBox;
    OpenAviFile: TOpenDialog;
    GroupBox3: TGroupBox;
    btOpenAVI: TButton;
    tbFrames: TTrackBar;
    gbCrop: TGroupBox;
    lbCropTop: TLabel;
    lbCropBottom: TLabel;
    pbCrop: TPaintBox;
    tbCropTop: TTrackBar;
    tbCropBottom: TTrackBar;
    gbDrop: TGroupBox;
    sbRD: TSpeedButton;
    sbGD: TSpeedButton;
    sbBD: TSpeedButton;
    sbDSum: TSpeedButton;
    Label3: TLabel;
    tbDropRed: TTrackBar;
    tbDropGreen: TTrackBar;
    tbDropBlue: TTrackBar;
    tbDropSum: TTrackBar;
    stDropSettings: TStaticText;
    tbShift: TTrackBar;
    gbBlock: TGroupBox;
    lbBlockVal: TLabel;
    lbBlockCount: TLabel;
    tbBlockSum: TTrackBar;
    tbBlockCount: TTrackBar;
    pbDrop: TPaintBox;
    pbBlock: TPaintBox;
    sbGrayScaleDiffPreview: TSpeedButton;
    sbColorDiffPreview: TSpeedButton;
    sbBWDiffPreview: TSpeedButton;
    sbRevColorDiffPreview: TSpeedButton;
    Label4: TLabel;
    sbInvBlockPreview: TSpeedButton;
    sbColorBlockPreview: TSpeedButton;
    gbLinePreview: TGroupBox;
    pbLine: TPaintBox;
    sbInvLinePreview: TSpeedButton;
    sbColorLinePreview: TSpeedButton;
    sbEdgeBlockPreview: TSpeedButton;
    edGoFrame: TEdit;
    sbGoToFrame: TSpeedButton;
    sbNextKF: TSpeedButton;
    sbPrevKF: TSpeedButton;
    lbFrameNow: TLabel;
    gbSettings: TGroupBox;
    sbCopyFromMain: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btOpenImage: TButton;
    OpenBMP: TOpenPictureDialog;
    tbBlockSize: TTrackBar;
    lbBlockSize: TLabel;
    procedure btOpenAVIClick(Sender: TObject);
    procedure pbFramePaint(Sender: TObject);
    procedure tbFramesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbCropTopChange(Sender: TObject);
    procedure pbCropPaint(Sender: TObject);
    procedure pbDropPaint(Sender: TObject);
    procedure tbShiftChange(Sender: TObject);
    procedure pbBlockPaint(Sender: TObject);
    procedure pbDropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbDropMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbGoToFrameClick(Sender: TObject);
    procedure sbNextKFClick(Sender: TObject);
    procedure sbPrevKFClick(Sender: TObject);
    procedure pbLinePaint(Sender: TObject);
    procedure sbCopyFromMainClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOpenImageClick(Sender: TObject);
  private
    { Private declarations }
    HasAVIOpen: boolean;
    W,H, HN, HT: integer;
  public
    { Public declarations }
    ImageCrop, ImageDrop,
    ImageBlock, ImageLine: TBitmap;
    procedure UpdateSize;
  end;

var
  AdjustmentForm: TAdjustmentForm;

implementation

{$R *.DFM}
uses AVIFile, VFW, Unit1;

procedure TAdjustmentForm.btOpenAVIClick(Sender: TObject);
begin
//
 if MainForm.dlgOpenAvi.Execute then
 begin
  if AviFile.pavi<>nil then AviFile.CloseAVI;
  OpenAvi(OpenAviFile.FileName);  if AviFile.pavi=nil then exit;
  tbFrames.Max:=AviFile.MovieLength;
  tbFrames.Position:=0;  tbFrames.Enabled:=true;
  AviFile.GetFrame(0);
  H:=AviFile.FrameHeight;
  W:=AviFile.FrameWidth;
  UpdateSize;

  tbCropTopChange(Self);
  pbFramePaint(pbFrame);
 end;

end;

procedure TAdjustmentForm.pbFramePaint(Sender: TObject);
begin
{ BitBlt(pbFrame.Canvas.Handle,0,0,W,pbFrame.Height,
        AviFile.ImageSaved.Canvas.Handle,0,Trunc(H*tbCropTop.Position/100),SRCCOPY);}
 BitBlt(pbFrame.Canvas.Handle,0,0,W,H,
        AviFile.ImageSaved.Canvas.Handle,0,0,SRCCOPY);
 pbCropPaint(pbCrop);       
end;

procedure TAdjustmentForm.tbFramesChange(Sender: TObject);
begin
  AviFile.GetFrame(tbFrames.Position);
  lbFrameNow.Caption:='Frame: '+IntToStr(tbFrames.Position);
  pbFramePaint(pbFrame);
end;

procedure TAdjustmentForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caHide;
end;

procedure TAdjustmentForm.tbCropTopChange(Sender: TObject);
//var HN: integer;
begin
  UpdateSize;
{  HN:=H-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  if HN<0 then HN:=Trunc(H/100); //1% is minimum
  ImageCrop.Height:=HN;
  ImageDrop.Height:=HN;
  ImageBlock.Height:=HN;
//  pbFrame.Height:=HN;}

  pbFramePaint(pbFrame);
end;

procedure TAdjustmentForm.pbCropPaint(Sender: TObject);
begin
//
 BitBlt(ImageCrop.Canvas.Handle,0,0,W,ImageCrop.Height,
        AviFile.ImageSaved.Canvas.Handle,0,HT,SRCCOPY);
 BitBlt(pbCrop.Canvas.Handle,0,0,W,pbCrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
 pbDropPaint(pbDrop);        
end;

procedure TAdjustmentForm.UpdateSize;
begin

  lbCropTop.Caption:='Top ('+IntToStr(tbCropTop.Position)+'%)';
  lbCropBottom.Caption:='Bottom ('+IntToStr(tbCropBottom.Position)+'%)';

  ImageCrop.Width:=W;
  ImageDrop.Width:=W;
  ImageBlock.Width:=W;
  ImageLine.Width:=W;
  pbCrop.Width:=W;
  pbDrop.Width:=W;
  pbBlock.Width:=W;
  pbLine.Width:=W;

  HT:=Trunc(H*tbCropTop.Position/100);
  HN:=H-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  if HN<0 then HN:=Trunc(H/100); //1% is minimum
  ImageCrop.Height:=HN;
  ImageDrop.Height:=HN;
  ImageBlock.Height:=HN;
  ImageLine.Height:=HN;

  pbCrop.Height:=HN;
  pbDrop.Height:=HN;
  pbBlock.Height:=HN;
  pbLine.Height:=HN;

  gbCrop.Height:=HN+80;
  gbDrop.Height:=HN+200;
  gbBlock.Height:=HN+110;
  gbLinePreview.Height:=HN+55;
  ClientWidth:=Max(W,630);

  pbFrame.Height:=H;//-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  pbFrame.Width:=W;

end;

procedure TAdjustmentForm.pbDropPaint(Sender: TObject);
var X,Y, i, Offs: integer; PX, PXC, PXB, PXL: PByteArray;
    R, G, B, RX, GX, BX, RDX, GDX, BDX: integer;
    PrevBlockVal, BlockVal: integer;
    BlockThresh, LineThresh, LineCtr: integer;
    RThresh, BThresh, GThresh, SumThresh: integer;
    LineThreshReached, PrevLineThreshReached:boolean;
    BlockSize: integer;

begin
//
 Offs:=tbShift.Position;
 RThresh:=tbDropRed.Position;
 GThresh:=tbDropGreen.Position;
 BThresh:=tbDropBlue.Position;
 SumThresh:=tbDropSum.Position;
 BlockThresh:=tbBlockSum.Position;
 LineThresh:=tbBlockCount.Position;

 BlockSize:=tbBlockSize.Position;

 BitBlt(ImageLine.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
 LineThreshReached:=false;

 for Y:=0 to HN-1 do
 begin
  PX:=ImageCrop.ScanLine[Y];
  PXC:=ImageDrop.ScanLine[Y];
  PXB:=ImageBlock.ScanLine[Y];
  PXL:=ImageLine.ScanLine[Y];
  BlockVal:=0; PrevBlockVal:=0; LineCtr:=0;
  PrevLineThreshReached:=LineThreshReached;
       LineThreshReached:=false;

      if sbColorLinePreview.Down then
       begin
        ImageLine.Canvas.Pen.Mode:=pmCopy;
//        if (PrevLineThreshReached) then ImageLine.Canvas.Pen.Color:=clYellow; else
        ImageLine.Canvas.Pen.Color:=clWhite;
        ImageLine.Canvas.MoveTo(0,Y);
        ImageLine.Canvas.LineTo(W-Offs,Y);
       end;
  for X:=0 to W-Offs-1 do
  begin
   R:=PX[X*3+2];   G:=PX[X*3+1];   B:=PX[X*3];
   RX:=PX[(X+Offs)*3+2];  GX:=PX[(X+Offs)*3+1];  BX:=PX[(X+Offs)*3];
   RDX:=Abs(R-RX); GDX:=Abs(G-GX);  BDX:=Abs(B-BX);
   if sbRD.Down then   if (RDX<RThresh) then   RDX:=0;
   if sbGD.Down then   if (GDX<GThresh) then GDX:=0;
   if sbBD.Down then   if (BDX<BThresh) then  BDX:=0;
   if sbDSum.Down then if (RDX+GDX+BDX<SumThresh) then
   begin RDX:=0; GDX:=0; BDX:=0; end;

   if (sbColorDiffPreview.Down) then begin PXC[X*3+2]:=RDX; PXC[X*3+1]:=GDX; PXC[X*3]:=BDX; end;
   if (sbRevColorDiffPreview.Down) then begin PXC[X*3+2]:=255-RDX; PXC[X*3+1]:=255-GDX; PXC[X*3]:=255-BDX; end;
   if (sbGrayScaleDiffPreview.Down) then
   begin
    PXC[X*3+2]:=255-Trunc((RDX+GDX+BDX)/3);
    PXC[X*3+1]:=255-Trunc((RDX+GDX+BDX)/3);
    PXC[X*3]:=255-Trunc((RDX+GDX+BDX)/3);
   end;
   if (sbBWDiffPreview.Down) then
   begin
    if (RDX<>0) or (GDX<>0) or (BDX<>0) then begin PXC[X*3+2]:=0; PXC[X*3+1]:=0; PXC[X*3]:=0; end
    else begin PXC[X*3+2]:=255; PXC[X*3+1]:=255; PXC[X*3]:=255; end;
   end;

   if (X mod BlockSize)=0 then
   begin
    if (PrevBlockVal>BlockThresh) and (BlockVal>BlockThresh) then inc(LineCtr); //in-line counter
    if (X>0) then
    begin
     if (BlockVal>BlockThresh) then
     begin
     for i:=((X div BlockSize)-1)*BlockSize to X-1 do
      if sbInvBlockPreview.Down then
      begin PXB[i*3+2]:=255-PX[i*3+2]; PXB[i*3+1]:=255-PX[i*3+1]; PXB[i*3]:=255-PX[i*3]; end
      else
      if sbColorBlockPreview.Down then
      begin
       if sbEdgeBlockPreview.Down and (i=((X div BlockSize)-1)*BlockSize) then begin PXB[i*3+2]:=0; PXB[i*3+1]:=0; PXB[i*3]:=0; end
       else
       begin
       if (i>BlockSize-1) then
        begin
        if (PrevBlockVal>BlockThresh) then
         begin
         if (LineCtr<LineThresh) then
         begin PXB[i*3+2]:=255; PXB[i*3+1]:=255; PXB[i*3]:=0; end //yellow
         else begin PXB[i*3+2]:=0; PXB[i*3+1]:=255; PXB[i*3]:=0; end //green
         end
         else begin PXB[i*3+2]:=255; PXB[i*3+1]:=128; PXB[i*3]:=128; end; //red
        end
        else  begin PXB[i*3+2]:=255; PXB[i*3+1]:=128; PXB[i*3]:=128; end;
       end;
      end; 
     end
     else
      for i:=((X div BlockSize)-1)*BlockSize to X-1 do
      if sbInvBlockPreview.Down then
      begin PXB[i*3+2]:=PX[i*3+2]; PXB[i*3+1]:=PX[i*3+1]; PXB[i*3]:=PX[i*3]; end
      else
      if sbColorBlockPreview.Down then
      if sbEdgeBlockPreview.Down and (i=((X div BlockSize)-1)*BlockSize) then begin PXB[i*3+2]:=0; PXB[i*3+1]:=0; PXB[i*3]:=0; end
      else begin PXB[i*3+2]:=255; PXB[i*3+1]:=255; PXB[i*3]:=255; end; //white
    end;
//----------------- Lines -----------
     if (LineCtr=LineThresh) and not(LineThreshReached) then
     begin
       LineThreshReached:=true;
      if sbInvLinePreview.Down then
       begin
       ImageLine.Canvas.Pen.Mode:=pmNot;
       ImageLine.Canvas.MoveTo(0,Y);
       ImageLine.Canvas.LineTo(W-Offs,Y);
       end
      else
      if sbColorLinePreview.Down then
       begin
        ImageLine.Canvas.Pen.Mode:=pmCopy;
        if (PrevLineThreshReached) then ImageLine.Canvas.Pen.Color:=clLime
        else ImageLine.Canvas.Pen.Color:=$00FF8080;
        ImageLine.Canvas.MoveTo(0,Y);
        ImageLine.Canvas.LineTo(W-Offs,Y);
       end;
     end;

//----------------- LINES END --------
     PrevBlockVal:=BlockVal; BlockVal:=0;
    Inc(BlockVal,RDX+GDX+BDX);
   end
   else
   begin
    Inc(BlockVal,RDX+GDX+BDX);
   end;

  end;
 end;
 BitBlt(pbDrop.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageDrop.Canvas.Handle,0,0,SRCCOPY);
 BitBlt(pbBlock.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);
 BitBlt(pbLine.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);
end;

procedure TAdjustmentForm.tbShiftChange(Sender: TObject);
begin
//
// Shift: 1 Red: 000 Blue 000 Green: 000 Sum: 000
 stDropSettings.Caption:=Format('Shift: %u Red: %03u Blue: %03u Green: %03u Sum:%03u',
     [tbShift.Position,tbDropRed.Position,tbDropGreen.Position,tbDropBlue.Position,tbDropSum.Position]);
 lbBlockVal.Caption:='Value ('+IntToStr(tbBlockSum.Position)+')';
 lbBlockCount.Caption:='Count ('+IntToStr(tbBlockCount.Position)+')';
 lbBlockSize.Caption:='Size ('+IntToStr(tbBlockSize.Position)+')';

 pbDropPaint(pbDrop);
end;

procedure TAdjustmentForm.pbBlockPaint(Sender: TObject);
begin
 BitBlt(pbBlock.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);
end;


procedure TAdjustmentForm.pbDropMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (mbLeft=Button) then
 begin
  BitBlt(pbBlock.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
  BitBlt(pbDrop.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
  BitBlt(pbLine.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
 end;

end;

procedure TAdjustmentForm.pbDropMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (mbLeft=Button) then
 begin
  BitBlt(pbDrop.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageDrop.Canvas.Handle,0,0,SRCCOPY);
  BitBlt(pbBlock.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);
  BitBlt(pbLine.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);
 end;

end;

procedure TAdjustmentForm.sbGoToFrameClick(Sender: TObject);
begin
 tbFrames.Position:=StrToIntDef(edGoFrame.Text,0);
end;

procedure TAdjustmentForm.sbNextKFClick(Sender: TObject);
begin
 tbFrames.Position:=AVIStreamNextKeyFrame(AviFile.pavis,tbFrames.Position);
end;

procedure TAdjustmentForm.sbPrevKFClick(Sender: TObject);
begin
 tbFrames.Position:=AVIStreamPrevKeyFrame(AviFile.pavis,tbFrames.Position-1)+1;
end;

procedure TAdjustmentForm.pbLinePaint(Sender: TObject);
begin
 BitBlt(pbLine.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);
end;

procedure TAdjustmentForm.sbCopyFromMainClick(Sender: TObject);
begin
//
  tbCropTop.Position:=StrToIntDef(MainForm.edCutFromTop.Text,50);
  tbCropBottom.Position:=StrToIntDef(MainForm.edCutFromBottom.Text,0);
  tbDropRed.Position:=MainForm.DropRed;
  tbDropGreen.Position:=MainForm.DropGreen;
  tbDropBlue.Position:=MainForm.DropBlue;
  tbDropSum.Position:=MainForm.DropSum;
  sbRD.Down:=MainForm.IsDropRed;
  sbGD.Down:=MainForm.IsDropGreen;
  sbBD.Down:=MainForm.IsDropBlue;
  sbDSum.Down:=MainForm.IsDropSum;

  tbBlockSum.Position:=MainForm.BlockMinimum;
  tbShift.Position:=MainForm.Offs;
  tbBlockCount.Position:=MainForm.MinLineBlockNum;
  UpdateSize;

end;

procedure TAdjustmentForm.SpeedButton1Click(Sender: TObject);
begin

  MainForm.edCutFromTop.Text:=IntToStr(tbCropTop.Position);
  MainForm.edCutFromBottom.Text:=IntToStr(tbCropBottom.Position);

{  MainForm.DropRed:=tbDropRed.Position;
  MainForm.DropGreen:=tbDropGreen.Position;
  MainForm.DropBlue:=tbDropBlue.Position;
  MainForm.DropSum:=tbDropSum.Position;}

  MainForm.edDropRed.Text:=IntToStr(tbDropRed.Position);
  MainForm.edDropGreen.Text:=IntToStr(tbDropGreen.Position);
  MainForm.edDropBlue.Text:=IntToStr(tbDropBlue.Position);
  MainForm.edDropLow.Text:=IntToStr(tbDropSum.Position);

  MainForm.cbDropRed.Checked:=sbRD.Down;
  MainForm.cbDropGreen.Checked:=sbGD.Down;
  MainForm.cbDropBlue.Checked:=sbBD.Down;
  MainForm.cbDropSum.Checked:=sbDSum.Down;

  MainForm.tbSharpOffset.Position:=tbShift.Position;
  MainForm.edBlockValue.Text:=IntToStr(tbBlockSum.Position);
  MainForm.edLineBlockMinimum.Text:=IntToStr(tbBlockCount.Position);
  MainForm.BlockSize:=tbBlockSize.Position;

  MainForm.PanelSettingsToData(Self);
end;

procedure TAdjustmentForm.FormCreate(Sender: TObject);
begin
 ImageCrop:=TBitmap.Create;
 ImageDrop:=TBitmap.Create;
 ImageBlock:=TBitmap.Create;
 ImageLine:=TBitmap.Create;
 ImageCrop.PixelFormat:=pf24bit;
 ImageDrop.PixelFormat:=pf24bit;
 ImageBlock.PixelFormat:=pf24bit;
 ImageLine.PixelFormat:=pf24bit;
 H:=480;
 W:=640;
 UpdateSize;

end;

procedure TAdjustmentForm.FormDestroy(Sender: TObject);
begin
 if AviFile.pavis<>nil then AviFile.CloseAVI;
 ImageCrop.Free;
 ImageDrop.Free;
 ImageBlock.Free;
 ImageLine.Free;
// FreeAndNil(self);

end;

procedure TAdjustmentForm.btOpenImageClick(Sender: TObject);
begin
//
 if OpenBMP.Execute then AviFile.ImageSaved.LoadFromFile(OpenBMP.FileName);
end;

end.
