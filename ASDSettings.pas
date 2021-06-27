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
unit ASDSettings;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls, ComCtrls, Buttons, ExtCtrls, MyTypes1;

type
  TASDSettingsFrame = class(TForm)
    OpenAviFile: TOpenDialog;
    OpenBMP: TOpenPictureDialog;
    dlgSavePicture: TSavePictureDialog;
    pnlPreviewSet: TPanel;
    cbFullFrame: TCheckBox;
    cbCropFramePv: TCheckBox;
    cbDiffFramePv: TCheckBox;
    cbBlockFramePv: TCheckBox;
    cbLineFramePv: TCheckBox;
    ScrollBox1: TScrollBox;
    pbFrame: TPaintBox;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    lbFrameNow: TLabel;
    btOpenImage: TButton;
    btSaveBitmap: TButton;
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
    pbDrop: TPaintBox;
    sbGrayScaleDiffPreview: TSpeedButton;
    sbColorDiffPreview: TSpeedButton;
    sbBWDiffPreview: TSpeedButton;
    sbRevColorDiffPreview: TSpeedButton;
    Label4: TLabel;
    tbDropRed: TTrackBar;
    tbDropGreen: TTrackBar;
    tbDropBlue: TTrackBar;
    tbDropSum: TTrackBar;
    stDropSettings: TStaticText;
    tbShift: TTrackBar;
    gbBlock: TGroupBox;
    lbBlockVal: TLabel;
    lbBlockCount: TLabel;
    pbBlock: TPaintBox;
    sbInvBlockPreview: TSpeedButton;
    sbColorBlockPreview: TSpeedButton;
    sbEdgeBlockPreview: TSpeedButton;
    lbBlockSize: TLabel;
    sbUseBlockOverlap: TSpeedButton;
    tbBlockSum: TTrackBar;
    tbBlockCount: TTrackBar;
    tbBlockSize: TTrackBar;
    gbLine: TGroupBox;
    pbLine: TPaintBox;
    sbInvLinePreview: TSpeedButton;
    sbColorLinePreview: TSpeedButton;
    Label2: TLabel;
    cbCrop: TCheckBox;
    cbDrop: TCheckBox;
    cbBlock: TCheckBox;
    cbLine: TCheckBox;
    cbAllText: TCheckBox;
    cbFloatingPreview: TCheckBox;
    gbColorDom: TGroupBox;
    Label6: TLabel;
    PaintBox1: TPaintBox;
    gbDetectionSettings: TGroupBox;
    lbDrop: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    sbImageFull: TSpeedButton;
    sbHalf: TSpeedButton;
    sbImageOneThird: TSpeedButton;
    sbImageQuarter: TSpeedButton;
    sbOneFifth: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edDropLow: TEdit;
    edBlockValue: TEdit;
    tbSharpOffset: TTrackBar;
    cbCentralDomination: TCheckBox;
    edDropGreen: TEdit;
    cbDropRed: TCheckBox;
    cbDropGreen: TCheckBox;
    cbDropBlue: TCheckBox;
    edDropBlue: TEdit;
    edDropRed: TEdit;
    cbDropSum: TCheckBox;
    edLineBlockMinimum: TEdit;
    cbCheckMaxLineBlocks: TCheckBox;
    cbCheckLineNumber: TCheckBox;
    edLineNumberChangeThreshold: TEdit;
    edLineCountNeeded: TEdit;
    edMaxLineBlockDiff: TEdit;
    cbCheckLineAvg: TCheckBox;
    edLineAvgThreshold: TEdit;
    btSaveSettings: TButton;
    btLoadSettings: TButton;
    edLBCLimiter: TEdit;
    cbCheckBlockLines: TCheckBox;
    cbNoSingleFrame: TCheckBox;
    edMinimalFrameDistance: TEdit;
    edCutFromTop: TEdit;
    edCutFromBottom: TEdit;
    Label17: TLabel;
    edBlockSize: TEdit;
    OpenConfig: TOpenDialog;
    edCenterWeight: TEdit;
    tbCenterWeight: TTrackBar;
    sbCenterWeight: TSpeedButton;
    SaveConfig: TSaveDialog;
    pbPostCrop: TPaintBox;
    cbPreprocess: TCheckBox;
    sbYDiff: TSpeedButton;
    cbColorDomReplaceAll: TCheckBox;
    edLRMBLimit: TEdit;
    cbCheckLeftRightMost: TCheckBox;
    btSaveAVIBitmap: TButton;
    cbKillStrayGray: TCheckBox;
    sbShowSubPicRect: TSpeedButton;
    edPreKillStrayRepeat: TEdit;
    lbColorX: TLabel;
    lbColorT: TLabel;
    lbColorO: TLabel;
    lbColorNone: TLabel;
    Label19: TLabel;
    ColorDialog: TColorDialog;
    cbPreX: TCheckBox;
    cbPreT: TCheckBox;
    cbPreO: TCheckBox;
    cbPreOther: TCheckBox;
    cbColorPv: TCheckBox;
    cbColor: TCheckBox;
    pnlColorText: TPanel;
    sbPrevDominator: TSpeedButton;
    lbColorDominator: TLabel;
    sbNextDominator: TSpeedButton;
    sbDeleteDominator: TSpeedButton;
    sbAddDominator: TSpeedButton;
    lbCurrentDominator: TLabel;
    lbDominatorRGB: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edDomR: TEdit;
    edDomG: TEdit;
    edDomB: TEdit;
    edDomRD: TEdit;
    edDomGD: TEdit;
    edDomBD: TEdit;
    cbDominatorMode1: TCheckBox;
    cbDominatorMode2: TCheckBox;
    cbDominatorMode3: TCheckBox;
    edDominatorMode3: TEdit;
    edDominatorColorVariation: TEdit;
    sbRGBD: TSpeedButton;
    cbYDiff: TCheckBox;
    cbPeakProtection: TCheckBox;
    edPeakSize: TEdit;
    Label18: TLabel;
    gbTemporalDiff: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    pbTemporalDiff: TPaintBox;
    tbFramesUsed: TTrackBar;
    tbTemporalDelta: TTrackBar;
    procedure btSaveBitmapClick(Sender: TObject);
    procedure cbFullFrameClick(Sender: TObject);
    procedure cbLineClick(Sender: TObject);
    procedure cbFloatingPreviewClick(Sender: TObject);
    procedure pbFrameEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure pbColorDomSubtileClick(Sender: TObject);
{    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);}
    procedure btLoadSettingsClick(Sender: TObject);
    procedure sbImageFullClick(Sender: TObject);
    procedure btSaveSettingsClick(Sender: TObject);
    procedure pbFrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbCropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbPrevDominatorClick(Sender: TObject);
    procedure sbNextDominatorClick(Sender: TObject);
    procedure sbDeleteDominatorClick(Sender: TObject);
    procedure pbPostCropPaint(Sender: TObject);
    procedure btSaveAVIBitmapClick(Sender: TObject);
    procedure lbColorDominatorClick(Sender: TObject);
    procedure lbColorXClick(Sender: TObject);
   published 
{    procedure btOpenAVIClick(Sender: TObject);}
    procedure pbFramePaint(Sender: TObject);
    procedure tbFramesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
{    procedure tbCropTopChange(Sender: TObject);}
    procedure pbCropPaint(Sender: TObject);
    procedure pbDropPaint(Sender: TObject);
    procedure tbShiftChange(Sender: TObject);
    procedure pbBlockPaint(Sender: TObject);
    procedure pbDropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbDropMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
{    procedure sbNextKFClick(Sender: TObject);
    procedure sbPrevKFClick(Sender: TObject);}
    procedure pbLinePaint(Sender: TObject);
    procedure sbCopyFromMainClick(Sender: TObject);
    procedure sbCopyToMainClick(Sender: TObject);
    procedure Init;
    procedure FormDestroy(Sender: TObject);
    procedure btOpenImageClick(Sender: TObject);
    procedure PanelSettingsToData(Sender: TObject);
  private
    W,H, HN, HT, HP: integer;
    InitDone: boolean;
  public
    { Public declarations }
    ImageFrame, ImageCrop,
    ImagePostCrop,
    ImageDrop,
    ImageBlock, ImageLine: TBitmap;
    FrameProcessed, FrameDrawn: boolean; //to prevent continuous frame reprocessing
    ColorPickMode: boolean;
    CurrentColor: TColor;
    NoUpdate: boolean;
    LastPreviewX, LastPreviewY: integer;
    LastPreviewState: byte;
//    UpdateCtr, UpdateCtr2: integer;
    procedure UpdateSize;
    procedure ForceUpdate;
    procedure SetPreviewState(State: byte);
    procedure SaveToFile(Filename:string);
    procedure LoadFromFile(Filename:string);
    procedure UpdatePreColors;
    procedure UpdateDominator;
    procedure ProcessImage(Image:Pointer; var FrameStats: TFrameStat);
  end;

  var
frmASDSettings: TASDSettingsFrame;

implementation

uses Unit1, AviFile, Math, VFW;

{$R *.DFM}

{procedure TASDSettingsFrame.btOpenAVIClick(Sender: TObject);
begin
//
// if MainForm.OpenAvi.Execute then
 if OpenAviFile.Execute then
 begin
  if AviFile.pavi<>nil then AviFile.CloseAVI;
  AviFile.OpenAvi(OpenAviFile.FileName);  if AviFile.pavi=nil then exit;
  tbFrames.Max:=AviFile.MovieLength;
  tbFrames.Position:=0;  tbFrames.Enabled:=true;
  AviFile.GetFrame(0);
  H:=AviFile.FrameHeight;
  W:=AviFile.FrameWidth;
  UpdateSize;

  tbCropTopChange(Self);
  pbFramePaint(pbFrame);
 end;

end;}

procedure TASDSettingsFrame.pbFramePaint(Sender: TObject);
var HPx: integer;
begin
{ BitBlt(pbFrame.Canvas.Handle,0,0,W,pbFrame.Height,
        AviFile.ImageSaved.Canvas.Handle,0,Trunc(H*tbCropTop.Position/100),SRCCOPY);}
// if not(FrameProcessed) then
 if (AviFile.ImageSaved<>nil) and not(FrameProcessed) then
//   pbFrame.Width:=W; pbFrame.Left:=(Self.ClientWidth-W) div 2;
// BitBlt(pbFrame.Canvas.Handle,0,0,W,H,
 begin
 pbCropPaint(pbCrop);
 HPx:=0;
 if cbFullFrame.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),0,W,H,
        AviFile.ImageSaved.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,H,AviFile.ImageSaved.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,AviFile.ImageSaved.Height);
 end;
 if cbCropFramePv.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,HN,ImageCrop.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,HN);
 end;
 if cbColorPv.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImageDrop.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,HN,ImagePostCrop.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,HN);
 end;
 if cbDiffFramePv.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImageDrop.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,HN,ImageDrop.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,HN);
 end;
 if cbBlockFramePv.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,HN,ImageBlock.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,HN);
 end;
 if cbLineFramePv.Checked then
 begin
{  BitBlt(pbFrame.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);}
  BitBlt(ImageFrame.Canvas.Handle,0,HPx,W,HN,ImageLine.Canvas.Handle,0,0,SRCCOPY);
  Inc(HPx,HN);
 end;
//  FrameProcessed:=true;
// pbFrame.Height:=HP;
 end;
{ if not(FrameDrawn) then pbFrame.Canvas.Draw(0,0,ImageFrame);
 FrameDrawn:=true;}
{  if (UpdateCtr2)>(UpdateCtr) then
  begin}

   BitBlt(pbFrame.Canvas.Handle,((pbFrame.ClientWidth-W) div 2),0,W,pbFrame.Height,
        ImageFrame.Canvas.Handle,0,0,SRCCOPY);
//   Inc(UpdateCtr); sbTemp.Caption:=IntToStr(UpdateCtr)+'/'+IntToStr(UpdateCtr2);
{  end;}

end;

procedure TASDSettingsFrame.tbFramesChange(Sender: TObject);
begin
{  AviFile.GetFrame(tbFrames.Position);
  lbFrameNow.Caption:='Frame: '+IntToStr(tbFrames.Position);
  pbFramePaint(pbFrame);}
end;

procedure TASDSettingsFrame.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caHide;
end;

{procedure TASDSettingsFrame.tbCropTopChange(Sender: TObject);
//var HN: integer;
begin
{  HN:=H-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  if HN<0 then HN:=Trunc(H/100); //1% is minimum
  ImageCrop.Height:=HN;
  ImageDrop.Height:=HN;
  ImageBlock.Height:=HN;
//  pbFrame.Height:=HN;}
//  pbFramePaint(pbFrame);
{end;}

procedure TASDSettingsFrame.pbCropPaint(Sender: TObject);
begin
//
 if ImageCrop=nil then exit;
 if AviFile.ImageSaved<>nil then
 BitBlt(ImageCrop.Canvas.Handle,0,0,W,ImageCrop.Height,
        AviFile.ImageSaved.Canvas.Handle,0,HT,SRCCOPY);
        
// Inc(UpdateCtr2);
 pbDropPaint(pbDrop);
 
 if gbCrop.Visible then BitBlt(pbCrop.Canvas.Handle,0,0,W,pbCrop.Height,
                               ImageCrop.Canvas.Handle,0,0,SRCCOPY);
// pbFrame.Canvas.                              
end;

procedure TASDSettingsFrame.UpdateSize;
begin
 if ImageCrop=nil then exit;
  lbCropTop.Caption:='Top ('+IntToStr(tbCropTop.Position)+'%)';
  lbCropBottom.Caption:='Bottom ('+IntToStr(tbCropBottom.Position)+'%)';

  if (ImageCrop.Width<>W) then
  begin
   ImageCrop.Width:=W;
   ImagePostCrop.Width:=W;
   ImageDrop.Width:=W;
   ImageBlock.Width:=W;
   ImageLine.Width:=W;
   ImageFrame.Width:=W;

//  pbFrame.Width:=W; pbFrame.Left:=(Self.ClientWidth-W) div 2;
   pbCrop.Width:=W;
   pbDrop.Width:=W;
   pbBlock.Width:=W;
   pbLine.Width:=W;
   pbFrame.Width:=W;
   if (ClientWidth<W) or (ClientWidth<630) then ClientWidth:=Max(W,630);
  end;

  if (tbCropTop.Width<>(gbCrop.Width-tbCropTop.Left-10)) then
  begin
   tbCropTop.Width:=gbCrop.Width-tbCropTop.Left-10;
   tbCropBottom.Width:=gbCrop.Width-tbCropBottom.Left-10;

   tbDropRed.Width:=gbDrop.Width-tbDropRed.Left-10;
   tbDropGreen.Width:=gbDrop.Width-tbDropRed.Left-10;
   tbDropBlue.Width:=gbDrop.Width-tbDropRed.Left-10;
   tbDropSum.Width:=gbDrop.Width-tbDropRed.Left-10;
   tbShift.Width:=gbDrop.Width-tbShift.Left-10;

   tbBlockSum.Width:=gbBlock.Width-tbBlockSum.Left-10;
   tbBlockCount.Width:=gbBlock.Width-tbBlockSum.Left-10;
   tbBlockSize.Width:=gbBlock.Width-tbBlockSum.Left-10;
   tbCenterWeight.Width:=gbBlock.Width-tbBlockSum.Left-10;
  end; 

  if (pbCrop.Left<>((gbCrop.Width div 2) - (W div 2))) then
  begin
   pbCrop.Left:=(gbCrop.Width div 2) - (W div 2);
   pbPostCrop.Left:=(gbColorDom.Width div 2) - (W div 2);
   pbDrop.Left:=(gbDrop.Width-W) div 2;
   pbBlock.Left:=(gbBlock.Width-W) div 2;
   pbLine.Left:=(gbLine.Width-W) div 2;
  end; 

  HT:=Trunc(H*tbCropTop.Position/100);
  HN:=H-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  if HN<0 then HN:=Trunc(H/100); //1% is minimum
  if (ImageCrop.Height<>HN) then
  begin
   ImageCrop.Height:=HN;
   ImagePostCrop.Height:=HN;
   ImageDrop.Height:=HN;
   ImageBlock.Height:=HN;
   ImageLine.Height:=HN;

   pbCrop.Height:=HN;
   pbPostCrop.Height:=HN;
   pbDrop.Height:=HN;
   pbBlock.Height:=HN;
   pbLine.Height:=HN;

   gbCrop.Height:=HN+80;
   gbDrop.Height:=HN+200;
   gbBlock.Height:=HN+150;
   gbLine.Height:=HN+55;
   gbColorDom.Height:=pbPostCrop.Top+HN+10;//100;

  end;

//  pbFrame.Height:=H;//-Trunc(H*tbCropTop.Position/100)-Trunc(H*tbCropBottom.Position/100);
  cbFullFrameClick(Self);// sets pbFrame Height

end;

procedure TASDSettingsFrame.pbDropPaint(Sender: TObject);
var X,Y, i,j, Offs, OffsY: integer; PX, PY, PXC, PXB, PXL: PByteArray;
    R, G, B,
    RX, GX, BX,
    R1, G1, B1,
    R2, G2, B2,
    RDX, GDX, BDX: integer;
    RY, GY, BY,
    RDY, GDY, BDY: integer;
    PrevBlockVal, BlockVal: integer;
    BlockThresh, LineThresh, LineCtr: integer;
    RThresh, BThresh, GThresh, SumThresh: integer;
    LineThreshReached, PrevLineThreshReached:boolean;
    BlockSize, CenterWeight, Variance1, Variance2, LinesCount, LinesThresh: integer;
    HalfBlockVal, PrevHalfBlockVal: integer;
    HasDominator, IsDominator1, IsDominator2: boolean;
    X1, X2, Y1, Y2: integer; //base rect - everything within
    ImageCutTop: integer;

begin
//
 X1:=W; X2:=0;
 Y1:=HN; Y2:=0;
 Offs:=tbShift.Position;
 RThresh:=tbDropRed.Position;
 GThresh:=tbDropGreen.Position;
 BThresh:=tbDropBlue.Position;
 SumThresh:=tbDropSum.Position;
 BlockThresh:=tbBlockSum.Position;
 LineThresh:=tbBlockCount.Position; //MainForm.MinLineBlockNum
 LinesThresh:=StrToIntDef(edLineCountNeeded.Text,5);

 BlockSize:=tbBlockSize.Position;
 ImageCutTop:=(StrToIntDef(edCutFromTop.Text,50)*FrameHeight) div 100;


 LineThreshReached:=false;
// CenterWeight:=StrToIntDef(edCenterWeight.Text,2);
 CenterWeight:=tbCenterWeight.Position;
 HasDominator:=false; IsDominator1:=false; IsDominator2:=false;

 if cbPreprocess.Checked or Showing then
 begin
  BitBlt(ImagePostCrop.Canvas.Handle,0,0,W,pbCrop.Height,
         ImageCrop.Canvas.Handle,0,0,SRCCOPY);
  MainForm.PreprocessImage2(ImagePostCrop,0,0,ImagePostCrop.Width-1,ImagePostCrop.Height-1);
  BitBlt(pbPostCrop.Canvas.Handle,0,0,W,pbPostCrop.Height,
        ImagePostCrop.Canvas.Handle,0,0,SRCCOPY);
 end;

 if cbPreprocess.Checked then
 BitBlt(ImageLine.Canvas.Handle,0,0,W-Offs,HN,
        ImagePostCrop.Canvas.Handle,0,0,SRCCOPY)
 else  BitBlt(ImageLine.Canvas.Handle,0,0,W-Offs,HN,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);

 if sbYDiff.Down then OffsY:=Offs else OffsY:=0;

 LinesCount:=0;
 //---------------------------
 for Y:=0 to HN-1-OffsY do
 begin
//  PX:=ImageCrop.ScanLine[Y];
  if cbPreprocess.Checked then
  begin
   PX:=ImagePostCrop.ScanLine[Y];
   if sbYDiff.Down then PY:=ImagePostCrop.ScanLine[Y+Offs];
  end
  else
  begin
   PX:=ImageCrop.ScanLine[Y];
   if sbYDiff.Down then PY:=ImageCrop.ScanLine[Y+Offs];
  end;
  PXC:=ImageDrop.ScanLine[Y];
  PXB:=ImageBlock.ScanLine[Y];
  PXL:=ImageLine.ScanLine[Y];
  BlockVal:=0; PrevBlockVal:=0;
  LineCtr:=0; //in-line block ctr
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
//------------------------- X part   
   RX:=PX[(X+Offs)*3+2];  GX:=PX[(X+Offs)*3+1];  BX:=PX[(X+Offs)*3];
   RDX:=Abs(R-RX); GDX:=Abs(G-GX);  BDX:=Abs(B-BX);
   if sbRD.Down then   if (RDX<RThresh) then   RDX:=0;
   if sbGD.Down then   if (GDX<GThresh) then GDX:=0;
   if sbBD.Down then   if (BDX<BThresh) then  BDX:=0;
   if sbDSum.Down then if (RDX+GDX+BDX<SumThresh) then
   begin RDX:=0; GDX:=0; BDX:=0; end;
//---
    if (MainForm.IsDominatorMultiply or MainForm.IsDominatorMaxSharpness or MainForm.IsNonDominatorIgnore) then
    begin

     for j:=0 to Length(MainForm.ColorDominators)-1 do
      begin
      Variance1:=Abs(R-MainForm.ColorDominators[j].R)+
                 Abs(G-MainForm.ColorDominators[j].G)+
                 Abs(B-MainForm.ColorDominators[j].B);
      Variance2:=Abs(RX-MainForm.ColorDominators[j].R)+
                 Abs(GX-MainForm.ColorDominators[j].G)+
                 Abs(BX-MainForm.ColorDominators[j].B);
      if Variance1<MainForm.DominatorDeviation then begin IsDominator1:=true; HasDominator:=true; end;
      if Variance2<MainForm.DominatorDeviation then begin IsDominator2:=true; HasDominator:=true; end;
     end;
//  BDX ValB:=abs(PXLine[Pix]-PXLine[Pix_offs]);
//  GDX ValG:=abs(PXLine[Pix+1]-PXLine[Pix_offs+1]);
//  RDX ValR:=abs(PXLine[Pix+2]-PXLine[Pix_offs+2]);
      if (MainForm.IsDominatorMaxSharpness) then
      if ((IsDominator1) and not(IsDominator2))
      or (not(IsDominator1) and (IsDominator2))
//      if ((IsDominator1) or (IsDominator2))
      then begin RDX:=255; GDX:=255; BDX:=255; end;
    if (MainForm.IsDominatorMultiply) then if HasDominator then
    begin
     RDX:=Min(RDX*MainForm.DominatorMultiply,255);
     GDX:=Min(GDX*MainForm.DominatorMultiply,255);
     BDX:=Min(BDX*MainForm.DominatorMultiply,255);
    end;
   end;
   //------------- Y part ---------------
   if sbYDiff.Down then
   begin
    RY:=PY[X*3+2];  GY:=PY[X*3+1];  BY:=PY[X*3];
    RDY:=Abs(R-RY); GDY:=Abs(G-GY);  BDY:=Abs(B-BY);
    if sbRD.Down then   if (RDY<RThresh) then  RDY:=0;
    if sbGD.Down then   if (GDY<GThresh) then  GDY:=0;
    if sbBD.Down then   if (BDY<BThresh) then  BDY:=0;
    if sbDSum.Down then if (RDY+GDY+BDY<SumThresh) then
    begin RDY:=0; GDY:=0; BDY:=0; end;
    RDX:=Max(RDY,RDX); GDX:=Max(GDY,GDX); BDX:=Max(BDY,BDX);
   end;
//--------------------

   if (RDX<>0) or (GDX<>0) or (BDX<>0) then
   begin
    if (Y<Y1) then Y1:=Y; if (Y>Y2) then Y2:=Y;
    if (X<X1) then X1:=X; if (X>X2) then X2:=X;
   end;

//---
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

   if sbUseBlockOverlap.Down then
   begin
   end;
//blocks ------------------
   if (X mod BlockSize)=0 then
   begin
    if (MainForm.IsNonDominatorIgnore) and not(HasDominator) then BlockVal:=0; //block ignored
    if (PrevBlockVal>BlockThresh) and (BlockVal>BlockThresh) then
    begin
       inc(LineCtr); //in-line counter
      if cbCentralDomination.Checked then
      begin
       if abs(X-(FrameWidth div 2))<BlockSize*CenterWeight then
        Inc(LineCtr,abs((abs(X-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize));
{       if abs(X-(FrameWidth div 2))<BlockSize*2+1 then LineCtr:=LineCtr+1;
       if abs(X-(FrameWidth div 2))<BlockSize+1 then LineCtr:=LineCtr+1; //additional point for center subtitles (for small subs like No! and Yes!)}
      end;
    end;
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
       if sbEdgeBlockPreview.Down and (i=((X div BlockSize)-1)*BlockSize) then
        begin
         if sbCenterWeight.Down and (abs(X-(FrameWidth div 2))<BlockSize*CenterWeight) then
         begin PXB[i*3+2]:=(abs(abs(X-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize)*7;
               PXB[i*3+1]:=(abs(abs(X-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize)*7;
               PXB[i*3]:=255; end
         else begin PXB[i*3+2]:=0; PXB[i*3+1]:=0; PXB[i*3]:=0; end;
        end
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
      if sbEdgeBlockPreview.Down and (i=((X div BlockSize)-1)*BlockSize) then
      begin
         if sbCenterWeight.Down and (abs(X-(FrameWidth div 2))<BlockSize*CenterWeight) then
         begin PXB[i*3+2]:=(abs(abs(X-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize)*7;
               PXB[i*3+1]:=(abs(abs(X-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize)*7;
               PXB[i*3]:=255; end
         else begin PXB[i*3+2]:=0; PXB[i*3+1]:=0; PXB[i*3]:=0; end;
//      begin PXB[i*3+2]:=0; PXB[i*3+1]:=0; PXB[i*3]:=0; end
      end
      else begin PXB[i*3+2]:=255; PXB[i*3+1]:=255; PXB[i*3]:=255; end; //white
    //X mod BlockSize=0  
    IsDominator1:=false;  IsDominator2:=false; HasDominator:=false;

    end;
//----------------- Lines -----------
     if (LineCtr>{=}LineThresh) and not(LineThreshReached) then
//     if (MainForm.LineBlockCount[Y]>=LineThresh)
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
        if (PrevLineThreshReached) then
        if (LinesCount>=LinesThresh) then ImageLine.Canvas.Pen.Color:=clLime
        else ImageLine.Canvas.Pen.Color:=$008080FF 
        else ImageLine.Canvas.Pen.Color:=$00FF8080;
        ImageLine.Canvas.MoveTo(0,Y);
        ImageLine.Canvas.LineTo(W-Offs,Y);
       end;
       if (PrevLineThreshReached) then Inc(LinesCount);
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
 if sbShowSubPicRect.Down then
 for i:=0 to Length(MainForm.BandRects)-1 do
 begin
 x1:=MainForm.BandRects[i].Left;
 x2:=MainForm.BandRects[i].Right;
 y1:=Max(MainForm.BandRects[i].Top-ImageCutTop,1);
//ImageCutBottom to (FrameHeight-ImageCutTop)
 y2:=MainForm.BandRects[i].Bottom-ImageCutTop;
 y1:=Min(HN-1,y1); y2:=Min(HN-1,y2);
 if (Y1>0) and (Y2>0) and
 {if} (X1<X2) and (Y1<Y2) then
  begin
   PXC:=ImageDrop.ScanLine[Y1];
   for X:=X1 to X2 do begin PXC[X*3]:=0; PXC[X*3+1]:=0; PXC[X*3+2]:=0; end;
   PXC:=ImageDrop.ScanLine[Y2];
   for X:=X1 to X2 do begin PXC[X*3]:=0; PXC[X*3+1]:=0; PXC[X*3+2]:=0; end;
   for Y:=Y1 to Y2 do
   begin
    PXC:=ImageDrop.ScanLine[Y];
    PXC[X1*3]:=0; PXC[X1*3+1]:=0; PXC[X1*3+2]:=0;
    PXC[X2*3]:=0; PXC[X2*3+1]:=0; PXC[X2*3+2]:=0;
   end;
{   ImageDrop.Canvas.Pen.Mode:=pmCopy;
   ImageDrop.Canvas.Pen.Color:=clBlack;
   ImageDrop.Canvas.FrameRect(Rect(X1,Y1,X2,Y2));}
  end;
 end;
 if gbDrop.Visible then
 BitBlt(pbDrop.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageDrop.Canvas.Handle,0,0,SRCCOPY);
 if gbBlock.Visible then
 BitBlt(pbBlock.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);
 if gbLine.Visible then
 BitBlt(pbLine.Canvas.Handle,0,0,W-Offs,pbDrop.Height,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);
 FrameProcessed:=true;         
end;

procedure TASDSettingsFrame.tbShiftChange(Sender: TObject);
var PosX: integer;
begin
//
// Shift: 1 Red: 000 Blue 000 Green: 000 Sum: 000
 if ImageFrame=nil then exit;
 if NoUpdate then exit;
 FrameProcessed:=false;
 UpdateSize;
 if not(NoUpdate) then
 if (sbRGBD.Down) then
 if (Sender is TTrackBar) then
 begin
  PosX:=(Sender as TTrackBar).Position;
  if Sender=tbDropRed then begin tbDropGreen.Position:=PosX; tbDropBlue.Position:=PosX; end;
  if Sender=tbDropGreen then begin tbDropRed.Position:=PosX; tbDropBlue.Position:=PosX; end;
  if Sender=tbDropBlue then begin tbDropGreen.Position:=PosX; tbDropRed.Position:=PosX; end;
  edDropRed.Text:=IntToStr(PosX);
  edDropGreen.Text:=edDropRed.Text;
  edDropBlue.Text:=edDropRed.Text;
 end;
 stDropSettings.Caption:=Format('Shift: %u Red: %03u Blue: %03u Green: %03u Sum:%03u',
     [tbShift.Position,tbDropRed.Position,tbDropGreen.Position,tbDropBlue.Position,tbDropSum.Position]);
 lbBlockVal.Caption:='Value ('+IntToStr(tbBlockSum.Position)+')';
 lbBlockCount.Caption:='Count ('+IntToStr(tbBlockCount.Position)+')';
 lbBlockSize.Caption:='Size ('+IntToStr(tbBlockSize.Position)+')';
 if not(NoUpdate) then sbCopyToMainClick(Sender);
// pbDropPaint(pbDrop);
 pbFramePaint(pbFrame);
end;

procedure TASDSettingsFrame.pbBlockPaint(Sender: TObject);
begin
 BitBlt(pbBlock.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageBlock.Canvas.Handle,0,0,SRCCOPY);
end;


procedure TASDSettingsFrame.pbDropMouseDown(Sender: TObject;
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
  BitBlt(pbPostCrop.Canvas.Handle,0,0,W,pbPostCrop.Height,
        ImageCrop.Canvas.Handle,0,0,SRCCOPY);
 end;

end;

procedure TASDSettingsFrame.pbDropMouseUp(Sender: TObject;
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

{procedure TASDSettingsFrame.sbGoToFrameClick(Sender: TObject);
var i: integer;
begin
 i:=StrToIntDef(edGoFrame.Text,0);
 if (i<AviFile.MovieLength) then MainForm.tbFrameSeek.Position:=i;
end;}

{procedure TASDSettingsFrame.sbNextKFClick(Sender: TObject);
var i:DWORD;
begin
// tbFrames.Position:=AVIStreamNextKeyFrame(AviFile.pavis,tbFrames.Position);
 if AviFile.pavi=nil then exit;
 i:=AVIStreamNextKeyFrame(AviFile.pavis,MainForm.tbFrameSeek.Position);
 if (i>0) and (i<AviFile.MovieLength) then MainForm.tbFrameSeek.Position:=i;
end;

procedure TASDSettingsFrame.sbPrevKFClick(Sender: TObject);
begin
// tbFrames.Position:=AVIStreamPrevKeyFrame(AviFile.pavis,tbFrames.Position-1)+1;
 if AviFile.pavi=nil then exit;
 if MainForm.tbFrameSeek.Position>0 then
 MainForm.tbFrameSeek.Position:=AVIStreamPrevKeyFrame(AviFile.pavis,MainForm.tbFrameSeek.Position);
end;}

procedure TASDSettingsFrame.pbLinePaint(Sender: TObject);
begin
 if gbLine.Visible then
 BitBlt(pbLine.Canvas.Handle,0,0,W-tbShift.Position,pbDrop.Height,
        ImageLine.Canvas.Handle,0,0,SRCCOPY);
end;

procedure TASDSettingsFrame.sbCopyFromMainClick(Sender: TObject);
var R,G,B:byte;
begin
//
  NoUpdate:=true;
  tbCropTop.Position:=StrToIntDef(edCutFromTop.Text,50);
  tbCropBottom.Position:=StrToIntDef(edCutFromBottom.Text,0);
  tbDropRed.Position:=MainForm.DropRed;
  tbDropGreen.Position:=MainForm.DropGreen;
  tbDropBlue.Position:=MainForm.DropBlue;
  tbDropSum.Position:=MainForm.DropSum;
  sbRD.Down:=MainForm.IsDropRed;
  sbGD.Down:=MainForm.IsDropGreen;
  sbBD.Down:=MainForm.IsDropBlue;
  sbDSum.Down:=MainForm.IsDropSum;
  sbYDiff.Down:=MainForm.CheckYDiff;
  if (MainForm.DominatorSelected>=0) and (MainForm.DominatorSelected<Length(MainForm.ColorDominators)) then
  begin
//   edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);
   UpdateDominator;
  end;

  tbCenterWeight.Position:=StrToIntDef(edCenterWeight.Text,2);
  sbCenterWeight.Down:=cbCentralDomination.Checked;

  tbBlockSum.Position:=MainForm.BlockMinimum;
  tbShift.Position:=MainForm.Offs;
  tbBlockSize.Position:=MainForm.BlockSize;
  tbBlockCount.Position:=MainForm.MinLineBlockNum;

  cbPreX.Checked:=not(MainForm.ColorTypeReplaceMode[CT_EXTRA]=0);
  cbPreT.Checked:=not(MainForm.ColorTypeReplaceMode[CT_TEXT]=0);
  cbPreO.Checked:=not(MainForm.ColorTypeReplaceMode[CT_OUTLINE]=0);
  cbPreOther.Checked:=not(MainForm.ColorTypeReplaceMode[CT_OTHER]=0);

  UpdateSize;
  NoUpdate:=false;
  if (ImageFrame=nil) then exit
  else pbFramePaint(Sender);

end;

procedure TASDSettingsFrame.sbCopyToMainClick(Sender: TObject);
begin

  edCutFromTop.Text:=IntToStr(tbCropTop.Position);
  edCutFromBottom.Text:=IntToStr(tbCropBottom.Position);

{  MainForm.DropRed:=tbDropRed.Position;
  MainForm.DropGreen:=tbDropGreen.Position;
  MainForm.DropBlue:=tbDropBlue.Position;
  MainForm.DropSum:=tbDropSum.Position;}
  edCenterWeight.Text:=IntToStr(tbCenterWeight.Position);
  cbCentralDomination.Checked:=sbCenterWeight.Down;

  edDropRed.Text:=IntToStr(tbDropRed.Position);
  edDropGreen.Text:=IntToStr(tbDropGreen.Position);
  edDropBlue.Text:=IntToStr(tbDropBlue.Position);
  edDropLow.Text:=IntToStr(tbDropSum.Position);

  cbDropRed.Checked:=sbRD.Down;
  cbDropGreen.Checked:=sbGD.Down;
  cbDropBlue.Checked:=sbBD.Down;
  cbDropSum.Checked:=sbDSum.Down;

  tbSharpOffset.Position:=tbShift.Position;
  edBlockValue.Text:=IntToStr(tbBlockSum.Position);
  edBlockSize.Text:=IntToStr(tbBlockSize.Position);
  edLineBlockMinimum.Text:=IntToStr(tbBlockCount.Position);
  MainForm.BlockSize:=tbBlockSize.Position;
  cbYDiff.Checked:=sbYDiff.Down;

//  edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);

  PanelSettingsToData(Self);
end;

procedure TASDSettingsFrame.Init;
begin
// UpdateCtr:=0;

 ImageCrop:=TBitmap.Create;
 ImagePostCrop:=TBitmap.Create;
 ImageDrop:=TBitmap.Create;
 ImageBlock:=TBitmap.Create;
 ImageLine:=TBitmap.Create;
 ImageFrame:=TBitmap.Create;
 ImageFrame.PixelFormat:=pf24bit;
 ImageCrop.PixelFormat:=pf24bit;
 ImagePostCrop.PixelFormat:=pf24bit;
 ImageDrop.PixelFormat:=pf24bit;
 ImageBlock.PixelFormat:=pf24bit;
 ImageLine.PixelFormat:=pf24bit;
 H:=80;
 W:=640;
 HP:=H;
 InitDone:=true;
 if AVIFile.ImageSaved.Height<H then
  begin
   AVIFile.ImageSaved.Height:=H;
   AVIFile.ImageSaved.Width:=W;
  end;
 UpdateSize;
 UpdatePreColors;
end;

procedure TASDSettingsFrame.FormDestroy(Sender: TObject);
begin
 if AviFile.pavi<>nil then AviFile.CloseAVI;
 ImageCrop.Free;
 ImagePostCrop.Free;
 ImageDrop.Free;
 ImageBlock.Free;
 ImageLine.Free;
 ImageFrame.Free;
// FreeAndNil(self);

end;

procedure TASDSettingsFrame.btOpenImageClick(Sender: TObject);
begin
//
 if OpenBMP.Execute then AviFile.ImageSaved.LoadFromFile(OpenBMP.FileName);
  H:=AviFile.ImageSaved.Height;
  W:=AviFile.ImageSaved.Width;
  FrameProcessed:=false; FrameDrawn:=false;
  UpdateSize;
end;

procedure TASDSettingsFrame.ForceUpdate;
var s:string;
begin
 if AviFile.pavi<>nil then
 begin
//  tbFrames.Max:=AviFile.MovieLength;
//  tbFrames.Position:=MainForm.tbFrameSeek.Position;  tbFrames.Enabled:=true;

  UpdateSize; //pbFramePaint is called here if necessary
  FrameProcessed:=false; FrameDrawn:=false;
  if MainForm.tbFrameSeek.Enabled then
  BEGIN
   AviFile.GetFrame(MainForm.tbFrameSeek.Position);
   if pbmi<>nil then
   begin
//    MainForm.ProcessImage(Pointer(Integer(pbmi)+pbmi^.biSize),MainForm.CurrentFrameStats);
    {MainForm.}ProcessImage(AviFile.ImageSaved.ScanLine[ImageSaved.Height-1],MainForm.CurrentFrameStats);
    MainForm.UpdateCurrentStats;

    H:=AviFile.FrameHeight;
    W:=AviFile.FrameWidth;
    lbFrameNow.Caption:='Frame: '+IntToStr(MainForm.tbFrameSeek.Position);
//  tbCropTopChange(Self);
    FrameProcessed:=false; FrameDrawn:=false;
    pbFramePaint(pbFrame);
   end;
  END
  ELSE
  BEGIN
//   AviFile.GetFrame(MainForm.tbFrameSeek.Position);
   //frame is considered to be already Processed, no need to update that info
   AviFile.GetFrame(MainForm.tbFrameSeek.Position);
//   MainForm.ProcessImage(Pointer(Integer(pbmi)+pbmi^.biSize),MainForm.CurrentFrameStats);
//   if MainForm.sbShowPreview.Down then pbFramePaint(pbFrame) else
   pbFramePaint(pbFrame);
//   AVIFile.FrameToBitmap(AviFile.ImageSaved,AviFile.pbmi);
  END;

{   s:='Frame '+IntToStr(MainForm.FrameIndex);
   s:=s+#13#10+'MED='+IntToStr(Trunc(MainForm.SharpLinesAvg*10))+' ['+IntToStr(Trunc(abs(MainForm.SharpLinesAvgOlder-MainForm.SharpLinesAvg)*10))+']';
   s:=s+#13#10+'DLC='+IntToStr(MainForm.SharpLines)+' ['+IntToStr(abs(MainForm.SharpLinesOlder-MainForm.SharpLines))+']';
   s:=s+#13#10+'MBC='+IntToStr(MainForm.MaxSameLineCtr)+'/'+IntToStr(MainForm.MaxSameLineVal) + ' ['+IntToStr(abs(MainForm.MaxSameLineValOlder-MainForm.MaxSameLineVal))+']';
   s:=s+#13#10+'LBC='+IntToStr(MainForm.LBCLines)+' ('+IntToStr(MainForm.LBCCount)+')'+' ['+IntToStr(Trunc(abs(MainForm.LBCLinesOlder-MainForm.LBCLines)))+']';
   MainForm.stCurrentFrameStats.Caption:=s;
   MainForm.stbMain.Panels[1].Text:=StringReplace(MainForm.stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
   MainForm.stbMain.Panels[0].Text:='Frame '+IntToStr(MainForm.FrameIndex+1);}
 end;
end;

procedure TASDSettingsFrame.btSaveBitmapClick(Sender: TObject);
begin
 if dlgSavePicture.Execute then ImageFrame.SaveToFile(dlgSavePicture.FileName);
 { AviFile.ImageSaved.SaveToFile(dlgSavePicture.FileName);}

end;

procedure TASDSettingsFrame.cbFullFrameClick(Sender: TObject);
//var HP: integer;
begin
//
 HP:=0;
 if cbFullFrame.Checked then Inc(HP,AviFile.ImageSaved.Height);
 if cbCropFramePv.Checked then Inc(HP,HN);
 if cbColorPv.Checked then Inc(HP,HN);
 if cbDiffFramePv.Checked then Inc(HP,HN);
 if cbBlockFramePv.Checked then Inc(HP,HN);
 if cbLineFramePv.Checked then Inc(HP,HN);
 if pbFrame.Height<>HP then
 begin ImageFrame.Height:=HP;  pbFrame.Height:=HP;
       FrameProcessed:=false; FrameDrawn:=false;
       pbFramePaint(Sender);
 end;
end;

procedure TASDSettingsFrame.cbLineClick(Sender: TObject);
begin
 gbCrop.Visible:=cbCrop.Checked;
 gbDrop.Visible:=cbDrop.Checked;
 gbBlock.Visible:=cbBlock.Checked;
 gbColorDom.Visible:=cbColor.Checked;
 gbLine.Visible:=cbLine.Checked;
 gbDetectionSettings.Visible:=cbAllText.Checked;
end;

procedure TASDSettingsFrame.cbFloatingPreviewClick(Sender: TObject);
var x1,y1,x2,y2:integer;
begin
//
 if cbFloatingPreview.Checked then SetPreviewState(2)
 else SetPreviewState(1);
{ begin
//  pbFrame.ManualDock(nil);
    x1:=Max(0,pbFrame.ClientToScreen(Point(0,0)).x);  x1:=Min(x1,Screen.Width-W);
    y1:=Max(0,pbFrame.ClientToScreen(Point(0,0)).y);  y1:=Min(y1,Screen.Height-H);
    pbFrame.ManualFloat(Rect(x1, y1, x1+W, y1+HP));
//  pbFrame.DragMode:=dmAutomatic;
  pbFrame.DragMode:=dmManual;
  pbFrame.Align:=alNone;
  if (pbFrame.Top<0) then pbFrame.Top:=0;
  if (pbFrame.Left<0) then pbFrame.Left:=0;
  ScrollBox1.DockSite:=false;
//  pbFrame.DragKind:=dkDrag;
 end
//  pbFrame.DragMode:=dmAutomatic;
 else
 begin
  pbFrame.DragMode:=dmAutomatic;
  ScrollBox1.DockSite:=true;
  pbFrame.ManualDock(ScrollBox1,ScrollBox1,alTop);
  pbFrame.Align:=alTop;
//  pbFrame.DragKind:=dkDock;
//  pbFrame.
//  pbFrame.ManualDock(Self, , alTop);
 end;}
end;


procedure TASDSettingsFrame.pbFrameEndDock(Sender, Target: TObject; X,
  Y: Integer);
begin
//
// if Target=ScrollBo then
// begin
  pbFrame.Align:=alTop;
  cbFullFrameClick(Sender);
//  pbFrame.Top:=pnlPreviewSet.Height+1;
//  pbFrame.Height:=
// end;
end;

procedure TASDSettingsFrame.pbColorDomSubtileClick(Sender: TObject);
begin
 ColorPickMode:=true;
end;

{procedure TASDSettingsFrame.FrameMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var pt: TPoint;
begin
 if ColorPickMode then
 begin
  ClientToScreen(Point(X,Y));
  Screen.Monitors[0].
 end;
end;}

procedure TASDSettingsFrame.PanelSettingsToData(Sender: TObject);
var R,G,B: byte; Len: integer;
begin
 MainForm.IsDropRed:=cbDropRed.Checked;
 MainForm.IsDropGreen:=cbDropGreen.Checked;
 MainForm.IsDropBlue:=cbDropBlue.Checked;
 MainForm.IsDropSum:=cbDropSum.Checked;

 MainForm.DropRed:=StrToIntDef(edDropRed.Text, 100);
 MainForm.DropGreen:=StrToIntDef(edDropGreen.Text, 100);
 MainForm.DropBlue:=StrToIntDef(edDropBlue.Text, 100);
 MainForm.DropSum:=StrToIntDef(edDropLow.Text, 100);

 MainForm.LRMBLimit:=StrToIntDef(edLRMBLimit.Text, 20);
 MainForm.IsCheckLRMB:=cbCheckLeftRightMost.Checked;

 if cbPeakProtection.Checked then
 MainForm.IgnorePeakDistance:=StrToIntDef(edPeakSize.Text, 20)
 else MainForm.IgnorePeakDistance:=0; 

// DropGradient:=true;
 MainForm.IsTrackMaxBlockCount:=false;
// MaxDropOut:=100;
 MainForm.Offs:=tbSharpOffset.Position;
 MainForm.BlockMinimum:=StrToIntDef(edBlockValue.Text, 200); //difference in total of 16 points (for black-white stripes it is _maximum_ of 765*16=12240)
 MainForm.LineBlockNumDetection:=false;
 MainForm.BlockSize:=StrToIntDef(edBlockSize.Text,16);

 MainForm.MinLineBlockNum:=StrToIntDef(edLineBlockMinimum.Text, 3);

 MainForm.CentralDomination:=cbCentralDomination.Checked;
 MainForm.CenterWeight:=StrToIntDef(edCenterWeight.Text,2);

 MainForm.IsTrackLineMaxBlockCount:=cbCheckMaxLineBlocks.Checked;

 MainForm.IsCheckLineNumber:=cbCheckLineNumber.Checked;
 MainForm.LineNumberChangeThreshold:=StrToIntDef(Trim(edLineNumberChangeThreshold.Text),5);
 MainForm.LineCountNeeded:=StrToIntDef(Trim(edLineCountNeeded.Text), 5);

 MainForm.MaxLineBlockCountDiff:=StrToIntDef(edMaxLineBlockDiff.Text, 1);
 MainForm.MaxLinesBlockCountChanged:=5; //temp!!!+

 MainForm.SharpLinesAvgMinChange:=StrToIntDef(edLineAvgThreshold.Text,10);
 MainForm.IsTrackSharpLinesAvg:=cbCheckLineAvg.Checked;

  edMaxLineBlockDiff.Enabled:=MainForm.IsTrackLineMaxBlockCount;
  edLineNumberChangeThreshold.Enabled:=MainForm.IsCheckLineNumber;
  edDropRed.Enabled:=cbDropRed.Checked;
  edDropGreen.Enabled:=cbDropGreen.Checked;
  edDropBlue.Enabled:=cbDropBlue.Checked;
  edDropLow.Enabled:=cbDropSum.Checked;

//dominators section
 if length(MainForm.ColorDominators)>0 then
 begin

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=Min(StrToIntDef(edDomR.Text,0),255);
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=Min(StrToIntDef(edDomG.Text,0),255);
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=Min(StrToIntDef(edDomB.Text,0),255);

  MainForm.ColorDominators[MainForm.DominatorSelected].RD:=StrToIntDef(edDomRD.Text,0);
  MainForm.ColorDominators[MainForm.DominatorSelected].GD:=StrToIntDef(edDomGD.Text,0);
  MainForm.ColorDominators[MainForm.DominatorSelected].BD:=StrToIntDef(edDomBD.Text,0);

  R:=MainForm.ColorDominators[MainForm.DominatorSelected].R;
  G:=MainForm.ColorDominators[MainForm.DominatorSelected].G;
  B:=MainForm.ColorDominators[MainForm.DominatorSelected].B;
  lbColorDominator.Color:=B*256*256+G*256+R;
  lbDominatorRGB.Caption:='R:'+IntToStr(R)+' G:'+IntToStr(G)+' B:'+IntToStr(B);
  
{  edDomR.Text:=IntToStr(R);  edDomG.Text:=IntToStr(G);  edDomB.Text:=IntToStr(B);
  edDomRD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].RD);
  edDomGD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].GD);
  edDomBD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].BD);}

  if (B>128) then B:=0 else B:=255;
  if (G>128) then G:=0 else G:=255;
  if (R>128) then R:=0 else R:=255;
  lbColorDominator.Font.Color:=B*256*256+G*256+R;
   if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_TEXT then lbColorDominator.Caption:='T';
   if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_OUTLINE then lbColorDominator.Caption:='O';
   if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_EXTRA then lbColorDominator.Caption:='X';

//  MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=StrToIntDef(edCurrentDeviation.Text,MainForm.DominatorDeviation);
//  MainForm.ColorDominators[MainForm.DominatorSelected].RD:=StrToIntDef(edCurrentDeviation.Text,MainForm.DominatorDeviation);
//  MainForm.ColorDominators[MainForm.DominatorSelected].GD:=StrToIntDef(edCurrentDeviation.Text,MainForm.DominatorDeviation);
//  MainForm.ColorDominators[MainForm.DominatorSelected].BD:=StrToIntDef(edCurrentDeviation.Text,MainForm.DominatorDeviation);

  Len:=System.Length(MainForm.ColorDominators);

 lbCurrentDominator.Caption:=IntToStr(MainForm.DominatorSelected+1)
                          +'/'+IntToStr(Len);
 MainForm.IsDominatorMultiply:=cbDominatorMode3.Checked;
 MainForm.IsDominatorMaxSharpness:=cbDominatorMode2.Checked;
 MainForm.IsNonDominatorIgnore:=cbDominatorMode1.Checked;
 MainForm.DominatorDeviation:=StrToIntDef(edDominatorColorVariation.Text,15);
 MainForm.DominatorMultiply:=StrToIntDef(edDominatorMode3.Text, 10);

 MainForm.DominatorsUpdated;
 end;
 MainForm.IsCheckLBC:=cbCheckBlockLines.Checked;
 MainForm.LBCLimit:=StrToIntDef(edLBCLimiter.Text, 5);

 MainForm.IsReplaceAll:=cbColorDomReplaceAll.Checked;
 MainForm.IsPreprocess:=cbPreprocess.Checked;
 MainForm.IsPreKillStray:=cbKillStrayGray.Checked;

 MainForm.MinimalChangeFrameDistance:=StrToIntDef(edMinimalFrameDistance.Text,1);
 MainForm.PreKillStrayRepeat:=StrToIntDef(Trim(edPreKillStrayRepeat.Text),4);

 if (cbPreX.Checked) then MainForm.ColorTypeReplaceMode[CT_EXTRA]:=1
 else MainForm.ColorTypeReplaceMode[CT_EXTRA]:=0;
 if (cbPreT.Checked) then MainForm.ColorTypeReplaceMode[CT_TEXT]:=1
 else MainForm.ColorTypeReplaceMode[CT_TEXT]:=0;
 if (cbPreO.Checked) then MainForm.ColorTypeReplaceMode[CT_OUTLINE]:=1
 else MainForm.ColorTypeReplaceMode[CT_OUTLINE]:=0;
 if (cbPreOther.Checked) then MainForm.ColorTypeReplaceMode[CT_OTHER]:=1
 else MainForm.ColorTypeReplaceMode[CT_OTHER]:=0;

 MainForm.CheckYDiff:=cbYDiff.Checked;

 FrameProcessed:=false;

 MainForm.ImageCutTop:=(StrToIntDef(edCutFromTop.Text,50)*FrameHeight) div 100;
 MainForm.ImageCutBottom:=(StrToIntDef(edCutFromBottom.Text,0)*FrameHeight) div 100;

 sbCopyFromMainClick(Sender);

 ForceUpdate;

end;

procedure TASDSettingsFrame.btLoadSettingsClick(Sender: TObject);
begin
 //Saving full panel settings
 if OpenConfig.Execute then LoadFromFile(OpenConfig.Filename);

end;

procedure TASDSettingsFrame.sbImageFullClick(Sender: TObject);
begin
 edCutFromTop.Text:=IntToStr((100-(100 div (Sender as TComponent).Tag)));
 edCutFromBottom.Text:=IntToStr(1);
 if MainForm.AVIFileIsOpen then
 begin
  MainForm.ImageCutTop:=(StrToIntDef(edCutFromTop.Text,50)*FrameHeight) div 100;
  MainForm.ImageCutBottom:=(StrToIntDef(edCutFromBottom.Text,0)*FrameHeight) div 100;
 end;
 sbCopyFromMainClick(Sender);
end;

procedure TASDSettingsFrame.btSaveSettingsClick(Sender: TObject);
begin
 //Saving full panel settings
 if SaveConfig.Execute then SaveToFile(SaveConfig.FileName);

end;


procedure TASDSettingsFrame.pbFrameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var PX:PByteArray; R,G,B:byte;
begin
{ if (Shift=[ssShift, ssLeft]) and (Button=mbLeft) then
 begin
//
  PX:=ImageFrame.ScanLine[Y];
  B:=PX[X*3];
  G:=PX[X*3+1];
  R:=PX[X*3+2];
  lbColorDominator.Color:=B*256*256+G*256+R;

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);
 end;}
  if Y>ImageFrame.Height-1 then exit;
  PX:=ImageFrame.ScanLine[Y];
  X:=X-((pbFrame.ClientWidth-W) div 2);
  if (X<0) or (X>=ImageFrame.Height) then exit;
  B:=PX[X*3];  G:=PX[X*3+1];  R:=PX[X*3+2];
 if (Shift=[ssShift,ssLeft]) and (Button=mbLeft) then
 begin
//
  lbColorDominator.Color:=B*256*256+G*256+R;

  SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
  MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_TEXT; //main
//  MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].RD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].GD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].BD:=MainForm.DominatorDeviation;
//  edCurrentDeviation.Text:=IntToStr(MainForm.DominatorDeviation);
  lbColorDominator.Color:=B*256*256+G*256+R;
  lbCurrentDominator.Caption:=IntToStr(Length(MainForm.ColorDominators))+'/'+IntToStr(Length(MainForm.ColorDominators));
  PanelSettingsToData(Sender);

  {MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);}
 end
 else
 if (Shift=[ssLeft]) and (Button=mbLeft) then
 begin
//
  lbColorDominator.Color:=B*256*256+G*256+R;

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_TEXT; //main
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);
 end
 else
 if (Shift=[ssCtrl,ssLeft]) and (Button=mbLeft) then
 begin
  lbColorDominator.Color:=B*256*256+G*256+R;

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_OUTLINE; //main
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);
 end
 else
 if (Shift=[ssShift,ssCtrl,ssLeft]) and (Button=mbLeft) then
 begin
  lbColorDominator.Color:=B*256*256+G*256+R;

  SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
  MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_OUTLINE; //main
//  MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].RD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].GD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].BD:=MainForm.DominatorDeviation;
//  edCurrentDeviation.Text:=IntToStr(MainForm.DominatorDeviation);
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);
 end;

end;

procedure TASDSettingsFrame.pbCropMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var PX:PByteArray; R,G,B:byte;  
begin
  if Y>ImageCrop.Height-1 then exit;
  PX:=ImageCrop.ScanLine[Y];
  B:=PX[X*3];  G:=PX[X*3+1];  R:=PX[X*3+2];
 if (Shift=[ssShift,ssLeft]) and (Button=mbLeft) then
 begin
//
  lbColorDominator.Color:=B*256*256+G*256+R;

  SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
  MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_TEXT; //main
//  MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].RD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].GD:=MainForm.DominatorDeviation;
  MainForm.ColorDominators[MainForm.DominatorSelected].BD:=MainForm.DominatorDeviation;

//  edCurrentDeviation.Text:=IntToStr(MainForm.DominatorDeviation);
  lbColorDominator.Color:=B*256*256+G*256+R;
  lbCurrentDominator.Caption:=IntToStr(Length(MainForm.ColorDominators))+'/'+IntToStr(Length(MainForm.ColorDominators));
  sbCopyFromMainClick(Sender);
  PanelSettingsToData(Sender);

  {MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  lbColorDominator.Color:=B*256*256+G*256+R;
  PanelSettingsToData(Sender);}
 end
 else
 if (Shift=[ssLeft]) and (Button=mbLeft) then
 begin
//
  lbColorDominator.Color:=B*256*256+G*256+R;

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_TEXT; //main
  lbColorDominator.Color:=B*256*256+G*256+R;
  sbCopyFromMainClick(Sender);
  PanelSettingsToData(Sender);
 end
 else
 if (Shift=[ssCtrl,ssLeft]) and (Button=mbLeft) then
 begin
  lbColorDominator.Color:=B*256*256+G*256+R;

  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_OUTLINE; //main
  lbColorDominator.Color:=B*256*256+G*256+R;
  sbCopyFromMainClick(Sender);
  PanelSettingsToData(Sender);
 end
 else
 if (Shift=[ssShift,ssCtrl,ssLeft]) and (Button=mbLeft) then
 begin
  lbColorDominator.Color:=B*256*256+G*256+R;

  SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
  MainForm.DominatorSelected:=Length(MainForm.ColorDominators)-1;
  MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
  MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
  MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
  MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_OUTLINE; //main
//  edCurrentDeviation.Text:=IntToStr(MainForm.DominatorDeviation);
  lbColorDominator.Color:=B*256*256+G*256+R;
  sbCopyFromMainClick(Sender);
  PanelSettingsToData(Sender);

 end;

end;

procedure TASDSettingsFrame.sbPrevDominatorClick(Sender: TObject);
begin
 MainForm.DominatorSelected:=Math.Max(MainForm.DominatorSelected-1,0);
// edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);
 UpdateDominator;
 PanelSettingsToData(Sender);
end;

procedure TASDSettingsFrame.sbNextDominatorClick(Sender: TObject);
begin
 MainForm.DominatorSelected:=Min(MainForm.DominatorSelected+1,System.Length(MainForm.ColorDominators)-1);
// edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);
 UpdateDominator;
 PanelSettingsToData(Sender);
end;

procedure TASDSettingsFrame.sbDeleteDominatorClick(Sender: TObject);
var i:integer;
begin
 if (Length(MainForm.ColorDominators)>1) then
 begin
 for i:=MainForm.DominatorSelected to Length(MainForm.ColorDominators)-2 do
   MainForm.ColorDominators[i]:=MainForm.ColorDominators[i+1];
  SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)-1);
  MainForm.DominatorSelected:=Max(MainForm.DominatorSelected-1,System.Length(MainForm.ColorDominators)-1);
//  edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);
  PanelSettingsToData(Sender);
 end;
end;

procedure TASDSettingsFrame.pbPostCropPaint(Sender: TObject);
begin
 if ImagePostCrop<>nil then
{  BitBlt(pbPostCrop.Canvas.Handle,((Self.ClientWidth-W) div 2),HP,W,HN,
        ImagePostCrop.Canvas.Handle,0,0,SRCCOPY);}
 BitBlt(pbPostCrop.Canvas.Handle,0,0,W,pbPostCrop.Height,
        ImagePostCrop.Canvas.Handle,0,0,SRCCOPY);

end;

procedure TASDSettingsFrame.SetPreviewState;
var x1,y1,x2,y2:integer;
begin
//
 if pbFrame.Floating then
 begin
  LastPreviewX:=pbFrame.HostDockSite.Left;//pbFrame.ClientOrigin.x;
  LastPreviewY:=pbFrame.HostDockSite.Top;//ClientOrigin.y;
 end;
 ForceUpdate;

 case State of
 2: begin //make floating
// if cbFloatingPreview.Checked then
// begin
//  pbFrame.ManualDock(nil);
    x1:=Max(0,LastPreviewX{pbFrame.ClientToScreen(Point(0,0)).x});  x1:=Min(x1,Screen.Width-W);
    y1:=Max(0,LastPreviewY{pbFrame.ClientToScreen(Point(0,0)).y});  y1:=Min(y1,Screen.Height-H);
    pbFrame.ManualFloat(Rect(x1, y1, x1+W, y1+HP));
//  pbFrame.DragMode:=dmAutomatic;
    pbFrame.DragMode:=dmManual;
    pbFrame.Align:=alNone;
    if (pbFrame.Top<0) then pbFrame.Top:=0;
    if (pbFrame.Left<0) then pbFrame.Left:=0;
    ScrollBox1.DockSite:=false;
    pbFrame.Visible:=true;
//    pbFrame.FloatingDockSiteClass.
   end;
//  pbFrame.DragMode:=dmAutomatic;
 1: begin //snap to settings
//     pbFrame.DragMode:=dmAutomatic;
//     ScrollBox1.DockSite:=true;
     pbFrame.ManualDock(ScrollBox1,ScrollBox1,alTop);
     pbFrame.Align:=alTop;
     pbFrame.Visible:=true;
    end;
 4: begin
      pbFrame.Visible:=false; //Off
      if LastPreviewState=3 then MainForm.scrlbPreview.Visible:=false;
    end;  
 3: begin
     pbFrame.ManualDock(MainForm.scrlbPreview,MainForm.scrlbPreview,alTop);
     pbFrame.DragMode:=dmManual;
     pbFrame.Align:=alTop;
     pbFrame.Visible:=true;
     MainForm.scrlbPreview.Visible:=true;
     MainForm.SplitterX.Visible:=true;
    end; //Fixed preview (at fixed scrollbox)
 end; //end case
 if (State)<>3 then
 begin
  MainForm.SplitterX.Visible:=false;
  MainForm.scrlbPreview.Visible:=false;
 end;

 MainForm.sbShowPreview.Down:=(pbFrame.FloatingDockSiteClass<>nil);

 LastPreviewState:=State;  
end;


procedure TASDSettingsFrame.btSaveAVIBitmapClick(Sender: TObject);
begin
 if dlgSavePicture.Execute then
  AviFile.ImageSaved.SaveToFile(dlgSavePicture.FileName);

end;

procedure TASDSettingsFrame.lbColorDominatorClick(Sender: TObject);
begin
//
 case MainForm.ColorDominators[MainForm.DominatorSelected].DomType of
  0: MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_TEXT;
  1: MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_OUTLINE;
  2: MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=CT_EXTRA;
 end; 
  PanelSettingsToData(Sender);
end;

procedure TASDSettingsFrame.SaveToFile;
var SL:TStringList; i:integer;
begin
 begin
  SL:=TStringList.Create;
  try
   SL.Values['Version']:='AVISubDetector v'+VersionString;
   if (sbOneFifth.Down) then SL.Values['Coverage']:='5';
   if (sbImageQuarter.Down) then SL.Values['Coverage']:='4';
   if (sbImageOneThird.Down) then SL.Values['Coverage']:='3';
   if (sbHalf.Down) then SL.Values['Coverage']:='2';
   if (sbImageFull.Down) then SL.Values['Coverage']:='1';
   SL.Values['CutTop']:=edCutFromTop.Text;
   SL.Values['CutBottom']:=edCutFromBottom.Text;

   SL.Values['BlockValue']:=edBlockValue.Text;
   SL.Values['BlockCount']:=edLineBlockMinimum.Text;
   SL.Values['BlockSize']:=edBlockSize.Text;
   SL.Values['CenterWeight']:=edCenterWeight.Text;
   if cbCentralDomination.Checked then SL.Values['CenterWeightEnabled']:='1' else SL.Values['CenterWeightEnabled']:='0';
   SL.Values['LineCount']:=edLineCountNeeded.Text;

   if cbCheckMaxLineBlocks.Checked then SL.Values['MBC']:=edMaxLineBlockDiff.Text;
   if cbCheckBlockLines.Checked then SL.Values['LBC']:=edLBCLimiter.Text;
   if cbCheckLineAvg.Checked then SL.Values['MED']:=edLineAvgThreshold.Text;
   if cbCheckLineNumber.Checked then SL.Values['DLC']:=edLineNumberChangeThreshold.Text;
   if cbCheckLeftRightMost.Checked then SL.Values['RMB']:=edLRMBLimit.Text;
   
   SL.Values['Offset']:=IntToStr(tbSharpOffset.Position);
   if sbYDiff.Down then SL.Values['YDiff']:='1' else SL.Values['YDiff']:='0'; 
   if cbDropRed.Checked then SL.Values['DR']:=edDropRed.Text;
   if cbDropGreen.Checked then SL.Values['DG']:=edDropGreen.Text;
   if cbDropBlue.Checked then SL.Values['DB']:=edDropBlue.Text;
   if cbDropSum.Checked then SL.Values['DS']:=edDropLow.Text;
   SL.Values['DominatorVariation']:=edDominatorColorVariation.Text;
    for i:=0 to Length(MainForm.ColorDominators)-1 do SL.Values['DC'+IntToStr(i)]:=IntToHex(MainForm.ColorDominators[i].R*256*256+MainForm.ColorDominators[i].G*256+MainForm.ColorDominators[i].B, 6);
    for i:=0 to Length(MainForm.ColorDominators)-1 do SL.Values['DCType'+IntToStr(i)]:=IntToStr(MainForm.ColorDominators[i].DomType);
//    for i:=0 to Length(MainForm.ColorDominators)-1 do SL.Values['DCDev'+IntToStr(i)]:=IntToStr(MainForm.ColorDominators[i].Deviation);
    for i:=0 to Length(MainForm.ColorDominators)-1 do SL.Values['DCChDev'+IntToStr(i)]:=Format('%2.2x%2.2x%2.2x',[MainForm.ColorDominators[i].RD,MainForm.ColorDominators[i].GD,MainForm.ColorDominators[i].BD]);

   if cbDominatorMode1.Checked then SL.Values['DMode1']:='1' else SL.Values['DMode1']:='0';
   if cbDominatorMode2.Checked then SL.Values['DMode2']:='1' else SL.Values['DMode2']:='0';
   if cbDominatorMode3.Checked then SL.Values['DMode3']:='1' else SL.Values['DMode3']:='0';
   SL.Values['DMode3S']:=edDominatorMode3.Text;
   if cbPreprocess.Checked then SL.Values['Preprocess']:='1' else SL.Values['Preprocess']:='0';
   if cbColorDomReplaceAll.Checked then SL.Values['PreprocessAll']:='1' else SL.Values['PreprocessAll']:='0';
//   SL.Values['Preprocess']:=

   SL.SaveToFile(ChangeFileExt(FileName,'')+'.sdt');
  finally
   SL.Free;
  end;
 end;
end;

procedure TASDSettingsFrame.LoadFromFile;
var SL:TStringList; i, j:integer; R,G,B: byte; s, str:string;
begin
 //Saving full panel settings
 begin
  SL:=TStringList.Create;
  try
   SL.LoadFromFile(FileName);
//   SL.Values['Version']:='AVISubDetector v'+VersionString;
   s:=SL.Values['Coverage'];
   if s='5' then sbOneFifth.Down:=true
   else if s='3' then sbImageOneThird.Down:=true
   else if s='2' then sbHalf.Down:=true
   else if s='1' then sbImageFull.Down:=true
   else {if s='4' then }begin sbImageQuarter.Down:=true; s:='4'; end;
   edCutFromTop.Text:=SL.Values['CutTop'];
   edCutFromBottom.Text:=SL.Values['CutBottom'];
   if (edCutFromTop.Text='') then
   begin
    edCutFromTop.Text:=IntToStr((100-(100 div StrToInt(s))));
    edCutFromBottom.Text:=IntToStr(1);
   end;


   edBlockValue.Text:=SL.Values['BlockValue'];
   edLineBlockMinimum.Text:=SL.Values['BlockCount'];
   edLineCountNeeded.Text:=SL.Values['LineCount'];
   if SL.Values['BlockSize']<>'' then edBlockSize.Text:=SL.Values['BlockSize'];
   if SL.Values['YDiff']<>'' then
   if SL.Values['YDiff']='1' then cbYDiff.Checked:=true
   else cbYDiff.Checked:=false
   else cbYDiff.Checked:=false;



   if not(SL.Values['CenterWeight']='') then edCenterWeight.Text:=SL.Values['CenterWeight'];
   if not(SL.Values['CenterWeightEnabled']='0') then cbCentralDomination.Checked:=true;

   if not(SL.Values['MBC']='') then
    begin
     cbCheckMaxLineBlocks.Checked:=true;
     edMaxLineBlockDiff.Text:=SL.Values['MBC'];
    end else cbCheckMaxLineBlocks.Checked:=false;

   if not(SL.Values['RMB']='') then
    begin
     cbCheckLeftRightMost.Checked:=true;
     edLRMBLimit.Text:=SL.Values['RMB'];
    end else cbCheckLeftRightMost.Checked:=false;


   if not(SL.Values['LBC']='') then
    begin
     cbCheckBlockLines.Checked:=true;
     edLBCLimiter.Text:=SL.Values['LBC'];
    end else cbCheckBlockLines.Checked:=false;

//   if cbCheckLineAvg.Checked then SL.Values['MED']:=edLineAvgThreshold.Text;
   if not(SL.Values['MED']='') then
    begin
     cbCheckLineAvg.Checked:=true;
     edLineAvgThreshold.Text:=SL.Values['MED'];
    end else cbCheckLineAvg.Checked:=false;

//   if cbCheckLineNumber.Checked then SL.Values['DLC']:=edLineNumberChangeThreshold.Text;
   if not(SL.Values['DLC']='') then
    begin
     cbCheckLineNumber.Checked:=true;
     edLineNumberChangeThreshold.Text:=SL.Values['DLC'];
    end else cbCheckLineNumber.Checked:=false;

//   SL.Values['Offset']:=IntToStr(tbSharpOffset.Position);
   tbSharpOffset.Position:=StrToIntDef(SL.Values['Offset'],1);

//   if cbDropRed.Checked then SL.Values['DR']:=edDropRed.Text;
   if not(SL.Values['DR']='') then edDropRed.Text:=SL.Values['DR'];
   cbDropRed.Checked:=not(SL.Values['DR']='');
//   if cbDropGreen.Checked then SL.Values['DG']:=edDropGreen.Text;
   if not(SL.Values['DG']='') then edDropGreen.Text:=SL.Values['DG'];
   cbDropGreen.Checked:=not(SL.Values['DG']='');
//   if cbDropBlue.Checked then SL.Values['DB']:=edDropBlue.Text;
   if not(SL.Values['DB']='') then edDropBlue.Text:=SL.Values['DB'];
   cbDropBlue.Checked:=not(SL.Values['DB']='');
//   if cbDropSum.Checked then SL.Values['DS']:=edDropLow.Text;
   if not(SL.Values['DS']='') then edDropLow.Text:=SL.Values['DS'];
   cbDropSum.Checked:=not(SL.Values['DS']='');

//   SL.Values['DominatorVariation']:=edDominatorColorVariation.Text;
   edDominatorColorVariation.Text:=SL.Values['DominatorVariation'];

//   for i:=0 to Length(ColorDominators)-1 do
//SL.Values['DC'+IntToStr(i)]:=IntToHex(ColorDominators[i].R*256*256+ColorDominators[i].G*256+ColorDominators[i].B, 6);
   i:=0;
   while not(SL.Values['DC'+IntToStr(i)]='')  do
   begin
    if (i>Length(MainForm.ColorDominators)-1) then SetLength(MainForm.ColorDominators,i+1);
//    SetLength(MainForm.ColorDominators,Length(MainForm.ColorDominators)+1);
    MainForm.DominatorSelected:=i;//Length(MainForm.ColorDominators)-1;
    str:=SL.Values['DC'+IntToStr(i)];
    j:=StrToIntDef('$'+str,0);
    B:=j and $ff;
    G:=(j and $ff00) shr 8;
    R:=(j and $ff0000) shr 16;
    MainForm.ColorDominators[MainForm.DominatorSelected].R:=R;
    MainForm.ColorDominators[MainForm.DominatorSelected].G:=G;
    MainForm.ColorDominators[MainForm.DominatorSelected].B:=B;
    if not(SL.Values['DCType'+IntToStr(i)]='') then MainForm.ColorDominators[MainForm.DominatorSelected].DomType:=StrToIntDef(SL.Values['DCType'+IntToStr(i)],0);
    if not(SL.Values['DCDev'+IntToStr(i)]='') then
    begin
//     MainForm.ColorDominators[MainForm.DominatorSelected].Deviation:=StrToIntDef(SL.Values['DCDev'+IntToStr(i)],0);
     MainForm.ColorDominators[MainForm.DominatorSelected].RD:=StrToIntDef(SL.Values['DCDev'+IntToStr(i)],0);
     MainForm.ColorDominators[MainForm.DominatorSelected].GD:=StrToIntDef(SL.Values['DCDev'+IntToStr(i)],0);
     MainForm.ColorDominators[MainForm.DominatorSelected].BD:=StrToIntDef(SL.Values['DCDev'+IntToStr(i)],0);
    end;
    if not(SL.Values['DCChDev'+IntToStr(i)]='') then
    begin
     MainForm.ColorDominators[MainForm.DominatorSelected].RD:=StrToIntDef('$'+SL.Values['DCChDev'+IntToStr(i)][1]+SL.Values['DCChDev'+IntToStr(i)][2],1);
     MainForm.ColorDominators[MainForm.DominatorSelected].GD:=StrToIntDef('$'+SL.Values['DCChDev'+IntToStr(i)][3]+SL.Values['DCChDev'+IntToStr(i)][4],1);
     MainForm.ColorDominators[MainForm.DominatorSelected].BD:=StrToIntDef('$'+SL.Values['DCChDev'+IntToStr(i)][5]+SL.Values['DCChDev'+IntToStr(i)][6],1);
    end;

    lbColorDominator.Color:=B*256*256+G*256+R;
    lbCurrentDominator.Caption:=IntToStr(Length(MainForm.ColorDominators))+'/'+IntToStr(Length(MainForm.ColorDominators));
//    edCurrentDeviation.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].Deviation);
    inc(i);
   end;

   cbDominatorMode1.Checked:=(SL.Values['DMode1']='1');
   cbDominatorMode2.Checked:=(SL.Values['DMode2']='1');
   cbDominatorMode3.Checked:=(SL.Values['DMode3']='1');
   edDominatorMode3.Text:=SL.Values['DMode3S'];

   cbPreprocess.Checked:=SL.Values['Preprocess']='1';
   cbColorDomReplaceAll.Checked:=SL.Values['PreprocessAll']='1';

//   if cbDominatorMode1.Checked then SL.Values['DMode1']:='1' else SL.Values['DMode1']:='0';
//   if cbDominatorMode2.Checked then SL.Values['DMode2']:='1' else SL.Values['DMode2']:='0';
//   if cbDominatorMode3.Checked then SL.Values['DMode3']:='1' else SL.Values['DMode3']:='0';
//   SL.Values['DMode3S']:=edDominatorMode3.Text;

  NoUpdate:=true;
  edDomRD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].RD);
  edDomGD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].GD);
  edDomBD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].BD);

  edDomR.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].R);
  edDomG.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].G);
  edDomB.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].B);

  Application.ProcessMessages;
  Application.ProcessMessages;

  NoUpdate:=false;
   PanelSettingsToData(Self);
  finally
   SL.Free;
  end;
 end;

end;

procedure TASDSettingsFrame.lbColorXClick(Sender: TObject);
var CL:integer; R,G,B:byte;
begin
 ColorDialog.Color:=(Sender as TLabel).Color;
 if ColorDialog.Execute then
 begin
  CL:=ColorDialog.Color;
  R:=(CL and $FF);
  G:=(CL and $FF00) shr 8;
  B:=(CL and $FF0000) shr 16;
  MainForm.PreColorScheme[(Sender as TLabel).Tag].R:=R;
  MainForm.PreColorScheme[(Sender as TLabel).Tag].G:=G;
  MainForm.PreColorScheme[(Sender as TLabel).Tag].B:=B;
  UpdatePreColors;
  ForceUpdate;
 end;
end;

procedure TASDSettingsFrame.UpdatePreColors;
var i, R,G,B:byte; lb:TLabel;
begin
 for i:=0 to Length(MainForm.PreColorScheme)-1 do
 begin
  R:=MainForm.PreColorScheme[i].R;
  G:=MainForm.PreColorScheme[i].G;
  B:=MainForm.PreColorScheme[i].B;
  case i of
  0: lb:=lbColorX;//.Color:=B*256*256+G*256+R;
  1: lb:=lbColorT;
  2: lb:=lbColorO;
  3: lb:=lbColorNone;
  else exit;
  end;
  lb.Color:=B*256*256+G*256+R;
  if (B>128) then B:=0 else B:=255;
  if (G>128) then G:=0 else G:=255;
  if (R>128) then R:=0 else R:=255;
  lb.Font.Color:=B*256*256+G*256+R;
 end;
end;

procedure TASDSettingsFrame.UpdateDominator;
var R,G,B:integer;
begin
 //
 NoUpdate:=true;

   R:=MainForm.ColorDominators[MainForm.DominatorSelected].R;
   G:=MainForm.ColorDominators[MainForm.DominatorSelected].G;
   B:=MainForm.ColorDominators[MainForm.DominatorSelected].B;
 
   edDomR.Text:=IntToStr(R);  edDomG.Text:=IntToStr(G);  edDomB.Text:=IntToStr(B);
   edDomRD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].RD);
   edDomGD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].GD);
   edDomBD.Text:=IntToStr(MainForm.ColorDominators[MainForm.DominatorSelected].BD);

   lbColorDominator.Color:=B*256*256+G*256+R;
   lbDominatorRGB.Caption:='R:'+IntToStr(R)+' G:'+IntToStr(G)+' B:'+IntToStr(B);

   if (B>128) then B:=0 else B:=255;
   if (G>128) then G:=0 else G:=255;
   if (R>128) then R:=0 else R:=255;
   lbColorDominator.Font.Color:=B*256*256+G*256+R;
   if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_TEXT then lbColorDominator.Caption:='T'
   else if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_OUTLINE then lbColorDominator.Caption:='O'
   else if MainForm.ColorDominators[MainForm.DominatorSelected].DomType=CT_EXTRA then lbColorDominator.Caption:='X'
   else lbColorDominator.Caption:=' '; //CT_OTHER
 
 NoUpdate:=false;
end;

procedure TASDSettingsFrame.ProcessImage;
var i, j, k, SelSharp, Y, Pix, Pix_Offs, LineCtr, OldLineCtr, SameLineCtr, LinesChangedCtr, SharpXTmp:longint; LineMarked, BlockSharp, PrevBlockSharp: boolean;
    SharpBlockSum:longint; LastLineIsSharp: boolean;
    RightMostAvg, LeftMostAvg, LineRMB, LineLMB{, LineMostCtr}: integer;
    Image_Line,Image_Line2:PByteArray;
    BandLeft, BandRight, BandTop, BandBottom: integer;
    BandMargin, ImageSharpSum: integer;
    SharpLines, MaxBlockCount, MaxSameLineCtr, Offs : integer;
    SharpLinesAvg: extended;
    BlockSize, BlockMinimum, CenterWeight: integer;
    LBCLinesOlder, LBCLines, LBCCount: integer; //LBC debugging values
//   Image:=Pointer(Integer(pbmi)+pbmi^.biSize);
begin
 LBCLines:=0; LBCCount:=0;
 Offs:=MainForm.Offs;
 BlockSize:=MainForm.BlockSize;
 BlockMinimum:=MainForm.BlockMinimum;
 CenterWeight:=MainForm.CenterWeight;
 ImageSharpSum:=0;
 LastLineIsSharp:=false;
 SharpLines:=0;
 SharpLinesAvg:=0;
 MaxBlockCount:=0;
 MaxSameLineCtr:=0;
 SameLineCtr:=0;
 OldLineCtr:=1000; //impossible value
 LinesChangedCtr:=0;
 RightMostAvg:=0;
 LeftMostAvg:=0;

 BandLeft:=FrameWidth; BandRight:=0;
 BandTop:=FrameHeight; BandBottom:=0;
 BandMargin:=MainForm.SubPicMargin;
 MainForm.ClearBandRects;
 // for Y:=(FrameHeight div 3)*2 to FrameHeight-5 do
 // for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
 for Y:=MainForm.ImageCutBottom to (AVIFile.FrameHeight-MainForm.ImageCutTop)-1 do //checking lower part of image
 begin
  PrevBlockSharp:=false;  LineCtr:=0; SharpBlockSum:=0;
    Image_Line:=Pointer(Integer(pbmi)+pbmi^.biSize+Y*3*FrameWidth);
  LineRMB:=0; LineLMB:=(FrameWidth);
  // -------- LINE PARAMETERS CHECK -------------
  for i:=0 to (FrameWidth div BlockSize{16})-2 do
  BEGIN
    if MainForm.CheckYDiff or ((Y-Offs)<0) then
    begin
     if (Y-Offs)>=0 then Image_Line2:=Pointer(Integer(pbmi)+pbmi^.biSize+(Y-Offs)*3*FrameWidth);
     if (Y-Offs)>=0 then SharpXTmp:=MainForm.CheckLineBlock16SharpXY(Image_Line,Image_Line2,i*BlockSize{16},Y,Offs)
     else SharpXTmp:=MainForm.CheckLineBlock16SharpX(Image_Line,i*BlockSize{16},Y,Offs);
    end
    else SharpXTmp:=MainForm.CheckLineBlock16SharpX(Image_Line,i*BlockSize{16},Y,Offs);
    MainForm.BlockPattern[i,Y]:=SharpXTmp; //storing for later use
    if not(SharpXTmp<=BlockMinimum) then
    begin
     BlockSharp:=true;
     if (PrevBlockSharp) then
     begin
      LineCtr:=LineCtr+1;
      if MainForm.CentralDomination then
       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize*CenterWeight then
        Inc(LineCtr,abs((abs(i*BlockSize-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize));
{      begin
       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize*2 then LineCtr:=LineCtr+1;
       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize+1 then LineCtr:=LineCtr+1; //additional point for center subtitles (for small subs like No! and Yes!)
      end;}
      if (i<LineLMB) then LineLMB:=i-1;
      if (i>LineRMB) then LineRMB:=i;
     end;
     SharpBlockSum:=SharpBlockSum+SharpXTmp;
    end
    else
    begin
     BlockSharp:=false;
//     if PrevBlockSharp then LineCtr:=LineCtr-1;
    end;
    PrevBlockSharp:=BlockSharp;
   END; //end of block-for
   // ------ END OF LINE PARAMETERS CHECK ------

   MainForm.LineBlockCount[Y]:=LineCtr;
   if LineCtr>MainForm.MinLineBlockNum then
   begin

    if (LastLineIsSharp) then
    begin {Inc(LineMostCtr); <=> SharpLines} Inc(RightMostAvg,LineRMB); Inc(LeftMostAvg,LineLMB); end;

    //variation of line width change detector algorithm
    if (LastLineIsSharp) then
    if ((MainFOrm.LineBlockCount[Y]-MainForm.OldLineBlockCount[Y])>MainFOrm.MaxLineBlockCountDiff) then Inc(LinesChangedCtr);
    MainFOrm.OldLineBlockCount[Y]:=LineCtr;

    if (LastLineIsSharp) then
    begin
     if (LineLMB<BandLeft) then BandLeft:=LineLMB;
     if (LineRMB>BandRight) then BandRight:=LineRMB;
     if (BandTop>Y) then BandTop:=Y;
     if (BandBottom<Y) then BandBottom:=Y;
    end;

    //
    if (LastLineIsSharp) then Inc(SharpLines); //if two lines are sharp in a row
    if (LastLineIsSharp) then SharpLinesAvg:=SharpLinesAvg+LineCtr;
    ImageSharpSum:=ImageSharpSum+SharpBlockSum;

    if (LineCtr>MaxBlockCount) then MaxBlockCount:=LineCtr;
    if (LineCtr=OldLineCtr) then Inc(SameLineCtr) else SameLineCtr:=0;
    if (SameLineCtr>MaxSameLineCtr) then
     begin
      MainFOrm.MaxSameLineVal:=LineCtr;
      MainFOrm.MaxSameLineCtr:=SameLineCtr;
     end
    else if (LineCtr=MainFOrm.MaxSameLineVal) then Inc(MaxSameLineCtr);
    LastLineIsSharp:=true;
   end
   else
   begin
    if (LastLineIsSharp) then
     begin //previous line is sharp
       MainFOrm.AddBandRect(BandLeft*BlockSize,FrameHeight-BandTop,BandRight*BlockSize+BlockSize-1,FrameHeight-BandBottom, BandMargin);
       BandLeft:=FrameWidth; BandRight:=0;
       BandTop:=FrameHeight; BandBottom:=0;
     end;
    LastLineIsSharp:=false;
    MainFOrm.OldLineBlockCount[Y]:=LineCtr;
   end;
   OldLineCtr:=LineCtr;
 end;

    if (LastLineIsSharp) then
    begin
     if (LineLMB<BandLeft) then BandLeft:=LineLMB;
     if (LineRMB>BandRight) then BandRight:=LineRMB;
     if (BandTop>Y) then BandTop:=Y;
     if (BandBottom<Y) then BandBottom:=Y;
    end;
 
 if (LastLineIsSharp) then //AddBandRect(BandLeft,BandTop,BandRight,BandBottom, BandMargin); //if final line was still sharp
       MainFOrm.AddBandRect(BandLeft*BlockSize,FrameHeight-BandTop,BandRight*BlockSize+BlockSize-1,FrameHeight-BandBottom, BandMargin);
 if Length(MainFOrm.BandRects)>0 then MainFOrm.OptimizeBandRects;
//   CurrentFrameStats

   if (SharpLines>0) then SharpLinesAvg:=SharpLinesAvg/SharpLines else SharpLinesAvg:=0;

   FrameStats.DLC:=SharpLines;
   FrameStats.MED:=Trunc(SharpLinesAvg*10);
   FrameStats.MBC:=MainForm.MaxSameLineVal;
   FrameStats.LBC:=LBCLines;
   FrameStats.BandCount:=Length(MainForm.BandRects);
   if (SharpLines>0) then
   begin
    FrameStats.RMB:=Trunc((RightMostAvg*BlockSize)/SharpLines);
    FrameStats.LMB:=Trunc((LeftMostAvg*BlockSize)/SharpLines);
    FrameStats.MaxSameLineCtr:=MaxSameLineCtr;
    FrameStats.LBCCount:=LBCCount;
   end else
   begin
    FrameStats.RMB:=0;
    FrameStats.LMB:=0;
    FrameStats.MaxSameLineCtr:=0;
    FrameStats.LBCCount:=0;
   end;
   FrameStats.HasData:=true;

 if not(MainForm.IsFrameSubtitled(FrameStats)) then
 begin
  MainForm.MaxSameLineVal:=0;
  MainForm.MaxSameLineCtr:=0;
  LBCCount:=0;
 end;
end;


end.
