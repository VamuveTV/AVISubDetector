unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VFW, ExtCtrls, Ole2, Buttons, ComCtrls, FileCtrl, CheckLst, Math,
  ASDSettings, Grids, registry, Menus, ShellApi, AppEvnts, ImgList, ToolWin,
  PreOCR;

type TRGB24Count = record
               R,G,B: byte;
               Count: integer;
              end;
type TRGB24 = record
               R,G,B:byte;
              end;
type TColorDominator = record
               R,G,B:byte;
               Deviation: integer;
               DomType: byte;
              end;
     TDetectorStatus = ( ST_STOPPED, ST_PAUSED,
                          ST_NO_SUBTITLE, ST_NO_SUBTITLE_NOW,
                          ST_DETECTED, ST_DETECTED_NOW,
                          ST_CHANGED, ST_CHANGED_NOW,
                          ST_ERROR, ST_NO_DATA,
                          ST_SKIP,
                          ST_FINISHED);
const VersionString = '0.5.1.2 Beta';

const MYWM_NOTIFYICON = 8932;

type TFrameStat = record
                    DLC, MED, LBC, MBC, RMB, LMB: integer;
                    //RMB - RightMost Block, LMB - LeftMost Block
                    MaxSameLineCtr: integer; //MBC "trust" parameter
                    LBCCount: integer; //LBC "trust" parameter
                    HasData: boolean;
                  end;
//   s:=s+#13#10+'MED='+IntToStr(Trunc(SharpLinesAvg*10))+' ['+IntToStr(Trunc(abs(SharpLinesAvgOlder-SharpLinesAvg)*10))+']';
//   s:=s+#13#10+'DLC='+IntToStr(SharpLines)+' ['+IntToStr(abs(SharpLinesOlder-SharpLines))+']';
//   s:=s+#13#10+'MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal) + ' ['+IntToStr(abs(MaxSameLineValOlder-MaxSameLineVal))+']';
//   s:=s+#13#10+'LBC='+IntToStr(LBCLines)+' ('+IntToStr(LBCCount)+')'+' ['+IntToStr(Trunc(abs(LBCLinesOlder-LBCLines)))+']';

type
  TMainForm = class(TForm)
    pgMain: TPageControl;
    tbsProject: TTabSheet;
    gbAVIData: TGroupBox;
    cbAVIList: TCheckListBox;
    gbProcessSettings: TGroupBox;
    cbSaveFrameBMP: TCheckBox;
    edSaveBMPPath: TEdit;
    cbAutoSaveSub: TCheckBox;
    edSaveSubPath: TEdit;
    cbNameFrameFirst: TCheckBox;
    dlgOpenAVI: TOpenDialog;
    SaveSub: TSaveDialog;
    OpenSub: TOpenDialog;
    FindDialog: TFindDialog;
    tbsSettings: TTabSheet;
    pnlCurrentAVI: TPanel;
    StatusPanel: TPanel;
    FramePanel: TPanel;
    btStart: TButton;
    sbPause: TSpeedButton;
    sbStop: TSpeedButton;
    edStartingFrame: TEdit;
    btOpenAvi: TButton;
    sbManualProcessing: TSpeedButton;
    sbAutomaticProcessing: TSpeedButton;
    tbFrameSeek: TTrackBar;
    tbsSubtitle: TTabSheet;
    pnlSubtitleControl: TPanel;
    reSubData: TRichEdit;
    sbOpenSub: TSpeedButton;
    cbTimeOffset: TCheckBox;
    edTimeOffset: TEdit;
    sbSaveScript: TSpeedButton;
    cbSaveSub: TComboBox;
    sbClearScript: TSpeedButton;
    sbCallFind: TSpeedButton;
    cbShowLastLine: TCheckBox;
    tbsStats: TTabSheet;
    cbFullFramePreview: TCheckBox;
    cbAskOnEmpty: TCheckBox;
    cbDebugEmptyData: TCheckBox;
    Panel1: TPanel;
    btAVIClear: TButton;
    btAddAVI: TButton;
    sbForceSub: TSpeedButton;
    sgSubData: TStringGrid;
    stbMain: TStatusBar;
    frmASDSettings: TASDSettingsFrame;
    sbShowPreview: TSpeedButton;
    pbMainGraph: TPaintBox;
    pbDiffGraph: TPaintBox;
    pnlStatsControls: TPanel;
    stCurrentFrameStats: TStaticText;
    stLastChangedFrame: TStaticText;
    Splitter1: TSplitter;
    stLocalMax: TStaticText;
    MainMenu: TMainMenu;
    miSettings: TMenuItem;
    miFile: TMenuItem;
    miLoadSettings: TMenuItem;
    miSaveSettings: TMenuItem;
    miStats: TMenuItem;
    miLoadStats: TMenuItem;
    miSaveStats: TMenuItem;
    miSubs: TMenuItem;
    miLoadSub: TMenuItem;
    miSaveSub: TMenuItem;
    miProject: TMenuItem;
    miLoadProject: TMenuItem;
    miSaveProject: TMenuItem;
    SaveStat: TSaveDialog;
    OpenStat: TOpenDialog;
    ApplicationEvents: TApplicationEvents;
    clbShowGraphs: TCheckListBox;
    ImageList: TImageList;
    cbAutoSaveStat: TCheckBox;
    edSaveStatPath: TEdit;
    cbAutoLoadStat: TCheckBox;
    miPreview: TMenuItem;
    miPreviewIsFloating: TMenuItem;
    miPreviewIsFixed: TMenuItem;
    miPreviewIsSettings: TMenuItem;
    miPreviewOff: TMenuItem;
    N1: TMenuItem;
    miPreviewFullFrame: TMenuItem;
    miPreviewCroppedFrame: TMenuItem;
    miPreviewDrop: TMenuItem;
    miPreviewBlocks: TMenuItem;
    miPreviewLines: TMenuItem;
    SplitterX: TSplitter;
    scrlbPreview: TScrollBox;
    ToolBar1: TToolBar;
    tbtNextKF: TToolButton;
    ControlImages: TImageList;
    tbtPrevKF: TToolButton;
    tbtGoTo: TToolButton;
    tbtSetStartingFrame: TToolButton;
    miAVI: TMenuItem;
    miOpenAVI: TMenuItem;
    miStartProcessing: TMenuItem;
    miPauseProcessing: TMenuItem;
    miStopProcessing: TMenuItem;
    miCloseAVI: TMenuItem;
    miStartStatProcessing: TMenuItem;
    PopupMenu1: TPopupMenu;
    miCheck1: TMenuItem;
    miCheck2: TMenuItem;
    cbClearScriptOnAviOpen: TCheckBox;
    tbsPreOCR: TTabSheet;
    PreOCRFrame: TPreOCRFrame;
    cbAutoSavePreOCR: TCheckBox;
    tlbProcess: TToolBar;
    tlbStartProcessing: TToolButton;
    tlbPauseProcessing: TToolButton;
    tlbStartStatProcessing: TToolButton;
    tlbStopProcessing: TToolButton;
    tlbOpenAVI: TToolButton;
    tlbCloseAVI: TToolButton;
    procedure btAddAVIClick(Sender: TObject);
    procedure sbStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edBlockValueChange(Sender: TObject);
{    procedure PanelSettingsToData(Sender: TObject);}
{    procedure sbShowSettingsClick(Sender: TObject);}
{    procedure sbImageFullClick(Sender: TObject);}
//    procedure sbGetFrameSampleClick(Sender: TObject);
    procedure sbSaveScriptClick(Sender: TObject);
    procedure sbClearScriptClick(Sender: TObject);
    procedure cbSaveFrameBMPClick(Sender: TObject);
    procedure cbDebugEmptyDataClick(Sender: TObject);
{    procedure cbShowImageClick(Sender: TObject);}
    procedure btStartClick(Sender: TObject);
    procedure cbAutoSaveSubClick(Sender: TObject);
    procedure btAVIClearClick(Sender: TObject);
//    procedure edMinimalFrameDistanceChange(Sender: TObject);
{    procedure lbColorDominatorClick(Sender: TObject);}
{    procedure sbPrevDominatorClick(Sender: TObject);}
{    procedure sbNextDominatorClick(Sender: TObject);
    procedure sbDeleteDominatorClick(Sender: TObject);}
    procedure sbOpenSubClick(Sender: TObject);
{    procedure btLoadSettingsClick(Sender: TObject);}
    procedure sbPauseClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure sbCallFindClick(Sender: TObject);
    procedure edCutFromTopChange(Sender: TObject);
    procedure btInteractiveSettingsAdjustmentClick(Sender: TObject);
    procedure tbsSettingsShow(Sender: TObject);
    procedure tbFrameSeekChange(Sender: TObject);
    procedure btOpenAviClick(Sender: TObject);
    procedure tbsSettingsHide(Sender: TObject);
    procedure sbStartFromFrameClick(Sender: TObject);
    procedure sbForceSubClick(Sender: TObject);
    procedure edTimeOffsetChange(Sender: TObject);
    procedure sgSubDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbNextKFClick(Sender: TObject);
    procedure sbGoToFrameClick(Sender: TObject);
    procedure sbPrevKFClick(Sender: TObject);
    procedure sgSubDataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbShowPreviewClick(Sender: TObject);
    procedure pbMainGraphPaint(Sender: TObject);
    procedure cbDLCGraphClick(Sender: TObject);
    procedure miSaveStatsClick(Sender: TObject);
    procedure miLoadStatsClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure miUseStatsOnlyClick(Sender: TObject);
    procedure pbMainGraphMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainGraphMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainGraphMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miPreviewClick(Sender: TObject);
    procedure miPreviewLinesClick(Sender: TObject);
    procedure miCloseAVIClick(Sender: TObject);
    procedure miAVIClick(Sender: TObject);
//    procedure sbCheckColorDominationClick(Sender: TObject);
//    procedure sbReduceColorsClick(Sender: TObject);
  public
//     FrameWidth, FrameHeight, FrameRate, FrameScale, MovieLength: integer;
//     AudioRate, AudioScale, AudioLength: integer;
     FrameIndex:  INTEGER;
     LastChangeFrame, MinimalChangeFrameDistance: integer;
     Offs, {MaxDropOut,} BlockMinimum{, LineMinimum}: integer;
     {DropGradient,} StopProcess, PauseProcess, LineBlockNumDetection: boolean;
     LineCountNeeded: integer;
     LRMBLimit: integer; IsCheckLRMB: boolean;
     HasChecked:boolean;
     ShowImages:boolean;
     SharpLinesAvg, SharpLinesAvgOld, SharpLinesAvgOlder: extended;
     SharpLinesAvgMinChange: integer;
     IsTrackSharpLinesAvg: boolean;

     DropRed, DropGreen, DropBlue, DropSum: integer;

     IsDropRed, IsDropGreen, IsDropBlue, IsDropSum,
     CentralDomination, IsSaveBMP, IsEmptyDebugged: boolean;
     IsTrackLineMaxBlockCount, IsCheckLineNumber: boolean;
     MinLineBlockNum, MaxSameLineVal, MaxSameLineValOld, MaxSameLineValOlder,
     MaxSameLineCtr: integer;

     {ImagePartial,} LineNumberChangeThreshold:integer;
     ImageCutTop, ImageCutBottom: integer;

     BlockSize: integer; //default is 16
//     ImageCutTopPercent, ImageCutBottomPercent: integer;

     TimeOffset: integer;

     ImageIsSharp, ImageIsChanged: boolean;
     OldImageIsSharp: boolean;
     {ImageSaved,} MainGraphImg, DiffGraphImg: TBitmap;

     AVIFileIsOpen: boolean;
     CurrentAVI: string;
     LastSeekFrame: integer;
     SelectingGraphPos: boolean;
     NewGraphPos: integer;
     CurrentIcon: integer;

     ImageSharpSum, ImageSharpSumOld: longint;
     SharpLines, SharpLinesOld, SharpLinesOlder: longint;
//     pavi:PAVIFile;
//     pavis:PAVIStream;
//     pavis_aud:PAVIStream;
//     ob:PGetFrame;
//     ob_aud:PGetFrame;
//     pbmi:PBitmapInfoHeader;
//     bmi: TBitmapInfoHeader;

//   AviOpen : int64;
   info  : PAVISTREAMINFOA;

//     pwih:PWAVEFORMATEX;
     ImageArr:PByteArray;
//     han: integer;
     LineBlockCount:array[0..1024] of integer;
     OldLineBlockCount:array[0..1024] of integer;
     BlockPattern:array[0..255,0..4096] of integer; //BlockNum, LineNum BlockValue (sharpness)
     MaxBlockCount, OldMaxBlockCount:integer;
     IsTrackMaxBlockCount, IsShowAVI: boolean;
     MaxLineBlockCountDiff: integer;
     MaxLinesBlockCountChanged: integer;
     CurrentStatus: TDetectorStatus; //STOPPED, PAUSED, NO_SUBTITLE, DETECTED, CHANGED, FINISHED

//     aud_buffer: array[0..50000] of smallint; //for 16bit PCM
    SharpXRedTmp, SharpXGreenTmp, SharpXBlueTmp: longint;

    ColorDominators: array of TColorDominator; //TRGB24; //dominating colors for subtitle detection
    DominatorSelected, DominatorDeviation, DominatorMultiply:integer;
    IsDominatorMultiply,
    IsDominatorMaxSharpness,
    IsNonDominatorIgnore: boolean;
    CenterWeight: integer;
    AlternativeMBC_Lines:array[0..40] of integer;
    AlternativeMBC_Count:array[0..40] of integer;
    AlternativeMBC_Lines_Old:array[0..40] of integer;
    AlternativeMBC_Count_Old:array[0..40] of integer;
    AlternativeMBC_Lines_Older:array[0..40] of integer;
    AlternativeMBC_Count_Older:array[0..40] of integer;
    IsCheckLBC: boolean;
    LBCLimit: integer;
    LBCLinesOlder, LBCLines, LBCCount: integer; //LBC debugging values

    Stats: array of TFrameStat;
    CurrentFrameStats: TFrameStat;
    PrevFrameStats: TFrameStat;

     procedure ShowAvi(FFilename : string);
     function CheckLineBlock16SharpX(var PXLine:PByteArray; BlockX, BlockY:integer):longint;
//     procedure CloseVideo;
//     procedure OpenVideo(Filename:string);
     procedure FrameToBitmap(Bitmap:TBitmap;pbmi:PBitmapInfoHeader);
//     function CheckLineBlock(Y, BlockSize, BlockNum:integer):longint;
     procedure SaveFrame(FrameType:integer);
{     procedure HighlightImage(Bitmap:TBitmap);}
     function AlternativeLBCCheck:boolean;
     procedure UpdateStatus;
     procedure MyAVIFileOpen(FFileName: string);
     procedure MyAVIFileClose;
     procedure ManualProcessing(FrameType: integer);
     procedure SaveToRegistry;
     procedure LoadFromRegistry;
     procedure AddShellIcon;
     procedure RemoveShellIcon;
     procedure UpdateShellIcon(TipStr: string);
//     procedure ProcessFrameManualDetected;
//     procedure DataToPanelSettings;
    { Private declarations }
  public
    { Public declarations }
    procedure ProcessImage(Image:Pointer);
//    procedure AddSubLine(s:string);
    procedure AddSubLineTimed( Time:int64; s:string);
    procedure FrameRateUpdate;
    function FrameStatToLine(FStat:TFrameStat; Compact: boolean = true):string;
    function DeltaFrameStatToLine(FStat, PFStat:TFrameStat; Compact: boolean = true):string;
    function LineToFrameStat(str:string):TFrameStat;
    procedure WM_ShellIcon(var Message: TMessage); message MYWM_NOTIFYICON;
    function IsFrameChanged(PrevFrameStat, FrameNowStat: TFrameStat):boolean;
    function IsFrameSubtitled(FrameNowStat: TFrameStat):boolean;
    procedure SaveStats(FileName: string);
    procedure LoadStats(FileName: string);
    procedure UpdateCurrentStats;
    procedure PerformAutoSave;
  end;
//  function x: integer; external 'comdlg32.dll';
var
  MainForm: TMainForm;
implementation

{$R *.DFM}

uses UScript, MyTypes1, {ImageForm0,} ManualProcessing, {Adjuster,} AviFile;

function TMainForm.CheckLineBlock16SharpX(var PXLine:PByteArray; BlockX, BlockY:integer):integer;
var i, j, X, Pix, Pix_offs, ValR, ValG, ValB:longint;
    R1,G1,B1, R2, B2, G2: byte; Variance1, Variance2: integer;
    HasDominator, IsDominator1, IsDominator2: boolean;

begin
//  PX:=Image.Picture.Bitmap.ScanLine[Y];
//  X:=BlockX+BlockY*FrameWidth*3; //for 24bit frames
  X:=BlockX; //for 24bit frames
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;
//  if (X+15+Offs<FrameWidth) then
 if not(IsDominatorMultiply or IsDominatorMaxSharpness or IsNonDominatorIgnore) then
 begin
  for i:=0 to BlockSize-1{15} do
  begin
   Pix:=(i+X)*3;
   Pix_offs:=(i+X+Offs)*3;
   ValR:=abs(PXLine[Pix]-PXLine[Pix_offs]);
   ValG:=abs(PXLine[Pix+1]-PXLine[Pix_offs+1]);
   ValB:=abs(PXLine[Pix+2]-PXLine[Pix_offs+2]);
     if (IsDropRed) then begin if (ValR>DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (IsDropGreen) then begin if (ValG>DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (IsDropBlue) then begin if (ValB>DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
  end;
  if (IsDropSum) then begin if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>DropSum) then Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp else Result:=0; end else Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp;
 end
 else
 begin
  HasDominator:=false;
  for i:=0 to BlockSize-1{15} do
  begin
   IsDominator1:=false;  IsDominator2:=false;
   Pix:=(i+X)*3;
   Pix_offs:=(i+X+Offs)*3;

   R1:=PXLine[Pix+2]; R2:=PXLine[Pix_offs+2];
   G1:=PXLine[Pix+1]; G2:=PXLine[Pix_offs+1];
   B1:=PXLine[Pix];   B2:=PXLine[Pix_offs];

   for j:=0 to Length(ColorDominators)-1 do
    begin
     Variance1:=Abs(R1-ColorDominators[j].R)+
                 Abs(G1-ColorDominators[j].G)+
                 Abs(B1-ColorDominators[j].B);
     Variance2:=Abs(R2-ColorDominators[j].R)+
                 Abs(G2-ColorDominators[j].G)+
                 Abs(B2-ColorDominators[j].B);
     if Variance1<DominatorDeviation then begin IsDominator1:=true; HasDominator:=true; end;
     if Variance2<DominatorDeviation then begin IsDominator2:=true; HasDominator:=true; end;
    end;
   ValB:=abs(PXLine[Pix]-PXLine[Pix_offs]);
   ValG:=abs(PXLine[Pix+1]-PXLine[Pix_offs+1]);
   ValR:=abs(PXLine[Pix+2]-PXLine[Pix_offs+2]);
   if (IsDominatorMaxSharpness) then
    if ((IsDominator1) and not(IsDominator2))
      or (not(IsDominator1) and (IsDominator2))
//    if ((IsDominator1) or (IsDominator2))
      then begin ValB:=255; ValG:=255; ValR:=255; end;
     if (IsDropRed) then begin if (ValR>DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (IsDropGreen) then begin if (ValG>DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (IsDropBlue) then begin if (ValB>DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
  end;
  if (IsDominatorMultiply) then if HasDominator then
  begin
   SharpXRedTmp:=SharpXRedTmp*DominatorMultiply;
   SharpXGreenTmp:=SharpXGreenTmp*DominatorMultiply;
   SharpXBlueTmp:=SharpXBlueTmp*DominatorMultiply;
  end;
  if (IsNonDominatorIgnore) then
   if not(HasDominator) then
   begin
    SharpXRedTmp:=0;
    SharpXGreenTmp:=0;
    SharpXBlueTmp:=0;
   end;
  if (IsDropSum) then begin if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>DropSum) then Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp else Result:=0; end else Result:=SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp;
 end
end;


procedure TMainForm.btAddAVIClick(Sender: TObject);
var i:integer;
begin
   if dlgOpenAVI.execute
       then
  begin
   for i:=0 to dlgOpenAVI.Files.Count-1 do
   begin
    cbAVIList.Items.Add(dlgOpenAVI.Files[i]);
//    cbAVIList.ItemEnabled[i]:=true;
    cbAVIList.Checked[cbAVIList.Items.Count-1]:=true;
   end;
   HasChecked:=true;
  end;
end;

procedure TMainForm.ShowAvi(FFilename : string);
var
// pavisound:PAVIStream;
 Image:PByte;
 i:integer;
// Desti:TCanvas;

   // Shevin: Variables added
//   bitmap : TBitmap;
//   hexcode : string;
//   EMsg : string;
   lasterr : integer;
   SubIndex: integer;
   ModalRes: integer;
  s:string;
begin
  // Shevin: save return code from AVIFileOpen to determine error msg.
  if (IsShowAVI) then exit;
//  if not(StopProcess) or not(PauseProcess) then
  if not(AVIFileIsOpen) then MyAVIFileOpen(FFileName);
{  then begin
   AviFile.OpenAvi(FFileName);
   CurrentAVI:=FFileName;
   AVIFileIsOpen:=true;
   tbFrameSeek.Enabled:=true;
  end;}


  i:=StrToIntDef(edStartingFrame.Text,0);
  i:=Min(MovieLength-1,i);

  tbFrameSeek.Position:=i;
  
  pbmi:=AVIStreamGetFrame(ob,i);

      ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
      ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
  
//  meFileInfo.Clear;
{  meFileInfo.Lines.Add(IntToStr(pbmi.biWidth)+'x'+IntToStr(pbmi.biHeight)+'x'+IntToStr(pbmi.biBitCount)
                       +' (FPS:'+FloatToStr(FrameRate/FrameScale)+')' );}
//  FrameWidth:=pbmi.biWidth;
//  FrameHeight:=pbmi.biHeight;


{  ImageForm.Image1.Picture.Bitmap.Width := pbmi^.biWidth;
  ImageForm.SharpGraph.Height:=ImageForm.Image1.Height;
  ImageForm.Image1.Picture.Bitmap.height := pbmi^.biHeight;}
  
{  ImageSaved.Width:=FrameWidth;
  ImageSaved.Height:=FrameHeight;}

  StopProcess:=false;  PauseProcess:=false;
  FrameIndex := i;
//  lbFrameCount.Caption:='/ '+IntToStr(MovieLength);
  FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex+1)+' / '+IntToStr(MovieLength);

{  ImageForm.RestoreImage;
  ImageForm.SaveImage;}
  IsShowAVI:=true;
   tbFrameSeek.Enabled:=false;
  OldImageIsSharp:=false;

  CurrentStatus:=ST_NO_SUBTITLE;
  if pbmi.biBitCount=24 then {continue with process}
  While (pbmi<>Nil) and (StopProcess=false) and (PauseProcess=false)
        and (FrameIndex<MovieLength) do
  begin
   ImageArr:=Pointer(Integer(pbmi)+pbmi^.biSize);
  //doing image processing
   ProcessImage(ImageArr);
{   if (cbShowImage.Checked) then
   begin
    FrameToBitmap(ImageSaved,pbmi);
    BitBlt(ImageForm.Image1.Picture.Bitmap.Canvas.Handle,0,0,FrameWidth,FrameHeight,ImageSaved.Canvas.Handle,0,0,SRCCOPY);
    HighlightImage(ImageForm.Image1.Picture.Bitmap);
    ImageForm.Image1.Invalidate;
   end;}

//   FrameToBitmap(Image1.Picture.Bitmap,pbmi);
   //time formula is Time:=FrameIndex/(FrameRate/FrameScale);
{   s:='Frame '+IntToStr(FrameIndex);
   s:=s+#13#10+'MED='+IntToStr(Trunc(SharpLinesAvg*10))+' ['+IntToStr(Trunc(abs(SharpLinesAvgOlder-SharpLinesAvg)*10))+']';
   s:=s+#13#10+'DLC='+IntToStr(SharpLines)+' ['+IntToStr(abs(SharpLinesOlder-SharpLines))+']';
   s:=s+#13#10+'MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal) + ' ['+IntToStr(abs(MaxSameLineValOlder-MaxSameLineVal))+']';
   s:=s+#13#10+'LBC='+IntToStr(LBCLines)+' ('+IntToStr(LBCCount)+')'+' ['+IntToStr(Trunc(abs(LBCLinesOlder-LBCLines)))+']';}

   Stats[FrameIndex]:=CurrentFrameStats;
   if (FrameIndex=0) then PrevFrameStats:=CurrentFrameStats;

   UpdateCurrentStats;
{   s:='Frame '+IntToStr(FrameIndex)+#13#10+StringReplace(DeltaFrameStatToLine(CurrentFrameStats,PrevFrameStats, false),';',#13#10,[rfReplaceAll]);
   stCurrentFrameStats.Caption:=s;
   stbMain.Panels[1].Text:=DeltaFrameStatToLine(CurrentFrameStats,PrevFrameStats, false); //StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
   stbMain.Panels[0].Text:='Frame '+IntToStr(FrameIndex+1);}

//       LBCLinesOlder:=AlternativeMBC_Lines_Old[0];
//       LBCLines:=AlternativeMBC_Lines[i];
//       LBCCount:=AlternativeMBC_Count[i];
//   if (ImageIsSharp) then CurrentStatus:=ST_DETECTED;

     if CurrentStatus=ST_DETECTED_NOW then CurrentStatus:=ST_DETECTED
     else if CurrentStatus=ST_CHANGED_NOW then CurrentStatus:=ST_CHANGED
     else if CurrentStatus=ST_NO_SUBTITLE_NOW then CurrentStatus:=ST_NO_SUBTITLE;

     if not(OldImageIsSharp) and (ImageIsSharp) then CurrentStatus:=ST_DETECTED_NOW
     else if (ImageIsChanged) and (ImageIsSharp) then CurrentStatus:=ST_CHANGED_NOW;
     if not(ImageIsSharp) and (OldImageIsSharp) then CurrentStatus:=ST_NO_SUBTITLE_NOW;

   if (CurrentStatus=ST_CHANGED_NOW) then
   if not(((FrameIndex-LastChangeFrame>MinimalChangeFrameDistance) or (FrameIndex-LastChangeFrame<1)))
      then CurrentStatus:=ST_SKIP;
     

   UpdateStatus;
   Application.ProcessMessages;

// Subtitle *DETECTED*
   If not(OldImageIsSharp) and (ImageIsSharp) then
   begin
    if (sbAutomaticProcessing.Down) then
    begin
    AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),
                        '! Frame='+IntToStr(FrameIndex)+';'+FrameStatToLine(CurrentFrameStats));
    if IsSaveBMP then SaveFrame(1);
    LastChangeFrame:=FrameIndex;
    end
    else if (sbManualProcessing.Down) then  ManualProcessing(1);
   end
   else
   //------------------ Subtitle Change ------------------
   if (ImageIsChanged) and (ImageIsSharp) then
   begin   // subtitle change at current frame
    if ((FrameIndex-LastChangeFrame>MinimalChangeFrameDistance) or (FrameIndex-LastChangeFrame<1))
       or (not(frmASDSettings.cbNoSingleFrame.Checked)) then
    begin
    s:='* Frame='+IntToStr(FrameIndex);
    s:=s+';'+DeltaFrameStatToLine(CurrentFrameStats,PrevFrameStats);
    stLastChangedFrame.Caption:='Last Changed '+stCurrentFrameStats.Caption;
    if sbAutomaticProcessing.Down then
    begin
     AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),s);
//     AddSubLine(s);
     if IsSaveBMP then SaveFrame(2);
    end
    else
    if (sbManualProcessing.Down) then   ManualProcessing(2);
   end;
    // MaxSameLineCtr/MaxSameLineVal
    LastChangeFrame:=FrameIndex;
//    if IsSaveBMP then SaveFrame(2);

   end;

  if not(ImageIsSharp) and (OldImageIsSharp) then
   begin
   // subtitle ends here, "empty" subtitle follows
   if (cbAskOnEmpty.Checked and sbManualProcessing.Down) then ManualProcessing(0)
   else
    if (IsEmptyDebugged) then
    begin
//     AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'Empty Frame='+IntToStr(FrameIndex)+' S='+IntToStr(ImageSharpSum)+' MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal)+' DLC='+IntToStr(SharpLines));
     AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'Empty Frame='+IntToStr(FrameIndex)+';'+FrameStatToLine(CurrentFrameStats));
     if IsSaveBMP then SaveFrame(0);
    end
    else AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
//     AddSubLine('<SYNC Start='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))+'ms><P>&nbsp;');
//   end;
  end;

   OldImageIsSharp:=ImageIsSharp;

  //getting next frame
//   if ImageIsSharp then lbFrameProcessed.Caption:='*'+IntToStr(FrameIndex+1)
//   else lbFrameProcessed.Caption:=IntToStr(FrameIndex+1);
   FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex+1)+' / '+IntToStr(MovieLength);

//   str:='AviSubDetector: Frame: '+IntToStr(FrameIndex)+'/'+IntToStr(AviFile.MovieLength)+' of '+CurrentAVI;
   UpdateShellIcon('Frame: '+IntToStr(FrameIndex)+'/'+IntToStr(AviFile.MovieLength)+' of '+ExtractFileName(CurrentAVI));
   Application.ProcessMessages;
   inc(i);

   pbmi:=AVIStreamGetFrame(ob,i);
   while (pbmi=nil) and (FrameIndex<MovieLength) do
   begin
    inc(i);
    pbmi:=AVIStreamGetFrame(ob,i);
    INC (FrameIndex);
   end;
   INC (FrameIndex);
   tbFrameSeek.Position:=FrameIndex;
  end
  else ShowMessage('Only 24bit RGB Sources are supported so far. Try creating avisynth script with ConvertToRGB24().');

  tbFrameSeek.Enabled:=true;
  
  if (StopProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);
  if (PauseProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);
//  DrawDIBStop(han);
//  DrawDIBClose(han);

 if not(StopProcess) and not(PauseProcess) then
 begin
  AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
{  AddSubLine('<SYNC Start='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))+'ms><P>&nbsp;');}
  CurrentStatus:=ST_FINISHED;
  PreOCRFrame.PerformPartialSave;
 end else
 if (StopProcess) then CurrentStatus:=ST_STOPPED
 else if (PauseProcess) then CurrentStatus:=ST_PAUSED;

 if (StopProcess) or not(FrameIndex<MovieLength) then
 begin
  StopProcess:=TRUE;
  //MyAVIFileClose;
  edStartingFrame.Text:='0';
 end;

// AVIStreamRelease(pavis_aud);
// Bitmap_tmp.free;  // Shevin: Added for testing
// ImageForm.SaveImage;
{ btOpenAVI.Enabled:=true;}

 IsShowAVI:=false;
 UpdateStatus;
 Application.ProcessMessages;

 if (StopProcess) and not(cbAutoSaveSub.Checked) then sbSaveScript.Click;


end;

procedure TMainForm.ProcessImage;
var i, j, k, SelSharp, Y, Pix, Pix_Offs, LineCtr, OldLineCtr, SameLineCtr, LinesChangedCtr, SharpXTmp:longint; LineMarked, BlockSharp, PrevBlockSharp: boolean;
    SharpBlockSum:longint; LastLineIsSharp: boolean;
    RightMostAvg, LeftMostAvg, LineRMB, LineLMB{, LineMostCtr}: integer;
    Image_Line:PByteArray;
//   Image:=Pointer(Integer(pbmi)+pbmi^.biSize);
begin
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
 // for Y:=(FrameHeight div 3)*2 to FrameHeight-5 do
 // for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
 for Y:=ImageCutBottom to (FrameHeight-ImageCutTop)-1 do //checking lower part of image
 begin
  PrevBlockSharp:=false;  LineCtr:=0; SharpBlockSum:=0;
    Image_Line:=Pointer(Integer(pbmi)+pbmi^.biSize+Y*3*FrameWidth);
  LineRMB:=0; LineLMB:=(FrameWidth);
  // -------- LINE PARAMETERS CHECK -------------  
  for i:=0 to (FrameWidth div BlockSize{16})-2 do
   begin
    SharpXTmp:=CheckLineBlock16SharpX(Image_Line,i*BlockSize{16},Y);
    BlockPattern[i,Y]:=SharpXTmp; //storing for later use
    if not(SharpXTmp<BlockMinimum) then
    begin
     BlockSharp:=true;
     if (PrevBlockSharp) then
     begin
      LineCtr:=LineCtr+1;
      if CentralDomination then
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
   end; //end of block-for
   // ------ END OF LINE PARAMETERS CHECK ------ 
   if LineCtr>MinLineBlockNum then
   begin
    LineBlockCount[Y]:=LineCtr;

    if (LastLineIsSharp) then
    begin {Inc(LineMostCtr); <=> SharpLines} Inc(RightMostAvg,LineRMB); Inc(LeftMostAvg,LineLMB); end;

    //variation of line width change detector algorithm
    if (LastLineIsSharp) then
    if ((LineBlockCount[Y]-OldLineBlockCount[Y])>MaxLineBlockCountDiff) then Inc(LinesChangedCtr);
    OldLineBlockCount[Y]:=LineCtr;

    //
    if (LastLineIsSharp) then Inc(SharpLines); //if two lines are sharp in a row
    if (LastLineIsSharp) then SharpLinesAvg:=SharpLinesAvg+LineCtr;
    ImageSharpSum:=ImageSharpSum+SharpBlockSum;
{    if (LineBlockNumDetection) then
    begin
     OldLineBlockCount[Y]:=LineBlockCount[Y];
     LineBlockCount[Y]:=LineCtr;
    end;}

    if (LineCtr>MaxBlockCount) then MaxBlockCount:=LineCtr;
    if (LineCtr=OldLineCtr) then Inc(SameLineCtr) else SameLineCtr:=0;
    if (SameLineCtr>MaxSameLineCtr) then
     begin
      MaxSameLineVal:=LineCtr;
      MaxSameLineCtr:=SameLineCtr;
     end
    else if (LineCtr=MaxSameLineVal) then Inc(MaxSameLineCtr);
    LastLineIsSharp:=true;
   end
   else
   begin
    LastLineIsSharp:=false;
    LineBlockCount[Y]:=LineCtr;
{    if (LastLineIsSharp) then
    if ((LineBlockCount[Y]-OldLineBlockCount[Y])>MaxLineBlockCountDiff) then Inc(LinesChangedCtr);}
    OldLineBlockCount[Y]:=LineCtr;
   end;
   OldLineCtr:=LineCtr;
 end;

//   CurrentFrameStats
   if (SharpLines>0) then SharpLinesAvg:=SharpLinesAvg/SharpLines else SharpLinesAvg:=0;

   PrevFrameStats:=CurrentFrameStats;
   CurrentFrameStats.DLC:=SharpLines;
   CurrentFrameStats.MED:=Trunc(SharpLinesAvg*10);
   CurrentFrameStats.MBC:=MaxSameLineVal;
   CurrentFrameStats.LBC:=LBCLines;
   if (SharpLines>0) then
   begin
    CurrentFrameStats.RMB:=Trunc((RightMostAvg*BlockSize)/SharpLines);
    CurrentFrameStats.LMB:=Trunc((LeftMostAvg*BlockSize)/SharpLines);
    CurrentFrameStats.MaxSameLineCtr:=MaxSameLineCtr;
    CurrentFrameStats.LBCCount:=LBCCount;
   end else
   begin
    CurrentFrameStats.RMB:=0;
    CurrentFrameStats.LMB:=0;
//    CurrentFrameStats.MaxSameLineVal:=0;
    CurrentFrameStats.MaxSameLineCtr:=0;
    CurrentFrameStats.LBCCount:=0;
   end;
   CurrentFrameStats.HasData:=true;

   ImageIsSharp:=IsFrameSubtitled(CurrentFrameStats);
   if ImageIsSharp then ImageIsChanged:=IsFrameChanged(PrevFrameStats, CurrentFrameStats)
   else ImageIsChanged:=false;
   
//!  if (SharpLines>LineCountNeeded) then ImageIsSharp:=true else ImageIsSharp:=false;
// if not((ImageSharpSum div 10000)=(ImageSharpSumOld div 10000)) then ImageIsChanged:=true else ImageIsChanged:=false;
//   ImageIsChanged:=false; //
// if (SharpLines>0) then
 if (ImageIsSharp) then
 begin
{  //only need to check if image is sharp, which requires sharp lines
//  if (IsCheckLineNumber) then ImageIsChanged:=(ImageIsChanged) or (abs(SharpLinesOld-SharpLines)>LineNumberChangeThreshold);
//  if IsTrackLineMaxBlockCount then ImageIsChanged:=(ImageIsChanged) or (abs(MaxSameLineValOld-MaxSameLineVal)>MaxLineBlockCountDiff);
    if (IsCheckLineNumber) then ImageIsChanged:=(ImageIsChanged)
       or (abs(CurrentFrameStats.DLC-PrevFrameStats.DLC)>LineNumberChangeThreshold);//(abs(SharpLinesOld-SharpLines)>LineNumberChangeThreshold);
    if IsTrackLineMaxBlockCount then ImageIsChanged:=(ImageIsChanged)
       or (abs(CurrentFrameStats.MaxSameLineCtr-PrevFrameStats.MaxSameLineCtr)>MaxLineBlockCountDiff);    //(abs(MaxSameLineValOld-MaxSameLineVal)>MaxLineBlockCountDiff);
    if (IsCheckLBC) then begin ImageIsChanged:=(ImageIsChanged) or (AlternativeLBCCheck); end;

// if TrackLineMaxBlockCount then ImageIsChanged:=(ImageIsChanged) or (not(LinesChangedCtr<MaxLinesBlockCountChanged));
//  if IsTrackSharpLinesAvg then ImageIsChanged:=(ImageIsChanged) or ((abs(SharpLinesAvgOld-SharpLinesAvg)*10)>SharpLinesAvgMinChange);
  if IsTrackSharpLinesAvg then ImageIsChanged:=(ImageIsChanged)
       or (abs(CurrentFrameStats.MED-PrevFrameStats.MED)>SharpLinesAvgMinChange);// ((abs(SharpLinesAvgOld-SharpLinesAvg)*10)>SharpLinesAvgMinChange);
  if IsCheckLRMB then ImageIsChanged:=(ImageIsChanged)
       or (abs(CurrentFrameStats.RMB-PrevFrameStats.RMB)>LRMBLimit);
  if IsCheckLRMB then ImageIsChanged:=(ImageIsChanged)
       or (abs(CurrentFrameStats.LMB-PrevFrameStats.LMB)>LRMBLimit);}
 end
 else
 begin
  MaxSameLineVal:=0;
  MaxSameLineCtr:=0;
  LBCCount:=0;
 end;
 SharpLinesAvgOlder:=SharpLinesAvgOld;
 SharpLinesAvgOld:=SharpLinesAvg;
// if IsTrackMaxBlockCount then ImageIsChanged:=(ImageIsChanged) or (abs(MaxBlockCount-OldMaxBlockCount)>1);
 SharpLinesOlder:=SharpLinesOld;
 SharpLinesOld:=SharpLines;
 ImageSharpSumOld:=ImageSharpSum;
 OldMaxBlockCount:=MaxBlockCount;
 MaxSameLineValOlder:=MaxSameLineValOld;
 MaxSameLineValOld:=MaxSameLineVal;
end;



// Shevin: The initialization and finalization sections are required for
// use with Windows NT and Win 2000.
procedure TMainForm.sbStopClick(Sender: TObject);
begin
 StopProcess:=true;
// if not(IsShowAvi) then MyAviFileClose;//AviFile.CloseAVI;
 IsShowAVI:=false; //in case of errors
// lbFileName.Caption:='No file opened';
// lbFileInfo.Caption:='No file opened';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
// DropGradient:=true;
// MaxDropOut:=100; //both replaced with separate values
{ if ImageForm=nil then ImageForm:=TImageForm.Create(Self);}
 frmASDSettings.Init;

 CurrentAVI:=''; AVIFileIsOpen:=false;
 CurrentStatus:=ST_STOPPED; //
 IsShowAVI:=false;
 IsTrackMaxBlockCount:=false;
 Offs:=1;
 BlockMinimum:=200; //difference in total of 16 points (for black-white stripes it is _maximum_ of 765*16=12240)
 LineBlockNumDetection:=false;
// ImagePartial:=4; // lower 1/4 of image is checked

 MinLineBlockNum:=3;

// LineMinimum:=10000;
 FrameWidth:=640;//ImageForm.Image1.Width;
 FrameHeight:=480;// ImageForm.Image1.Height;
 DropRed:=100;   IsDropRed:=true;
 DropGreen:=100; IsDropGreen:=true;
 DropBlue:=100;  IsDropBlue:=true;
 DropSum:=100;  IsDropSum:=false;
 CenterWeight:=2;

 MainGraphImg:=TBitmap.Create;
 DiffGraphImg:=TBitmap.Create;
{ ImageSaved:=TBitmap.Create;
 ImageSaved.Width:=FrameWidth;
 ImageSaved.Height:=FrameHeight;}
// ImageForm.SaveImage;

 cbSaveSub.ItemIndex:=0;
 IsSaveBMP:=false;
 IsEmptyDebugged:=false;

 han:=DrawDIBOpen;
 MinimalChangeFrameDistance:=5;
 HasChecked:=false;
 DominatorSelected:=0;
 SetLength(ColorDominators,1);
 ColorDominators[0].R:=255;
 ColorDominators[0].G:=255;
 ColorDominators[0].B:=255;

 BlockSize:=16;
 TimeOffset:=0;
 LRMBLimit:=20;

 frmASDSettings.sbCopyFromMainClick(Self);
 frmASDSettings.sbCopyToMainClick(Self);
 frmASDSettings.PanelSettingsToData(Self);
 Caption:='AVISubDetector by Shalcker v'+VersionString+' (bat@etel.ru)';
 Application.Title:='AVISubDetector v'+VersionString;


 LastSeekFrame:=-1;
 FrameRate:=1;
 FrameScale:=1;

// tbsStats.Hide;
 sgSubData.Cells[0,0]:='Time (ms)';
 sgSubData.Cells[1,0]:='Frame';
 sgSubData.Cells[2,0]:='Text';
 sgSubData.Cells[3,0]:='Other';
 AddShellIcon;

 clbShowGraphs.Checked[0]:=true;

 PreOCRFrame.Init;

 LoadFromRegistry;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// CloseVideo;
// if AviFile.pavi<>nil then AviFile.CloseAVI;
 if (AVIFileIsOpen) then
 begin
  PerformAutoSave;
  MyAVIFileClose;
 end;
//  if not(CurrentAVI='')
 SaveToRegistry;
{ ImageSaved.Free;}
 DiffGraphImg.Free;
 MainGraphImg.Free;
 DrawDIBClose(han);
 SetLength(ColorDominators,0);
 SetLength(Stats,0);
 frmASDSettings.FormDestroy(Self);
 PreOCRFrame.FormDestroy;
 RemoveShellIcon;
{ if ImageForm<>nil then ImageForm.Free;}

end;



procedure TMainForm.FrameToBitmap;
var Dest: TCanvas;
begin
// Bitmap := TBitmap.create;
 if pbmi=nil then exit;
 Dest:=Bitmap.Canvas;
// han:=DrawDIBOpen;
// DrawDIBStart(han,microsperframe);
// DRawDIBBegin(han,dest.handle,0,0,pbmi,pbmi^.biWidth,pbmi^.biheight,DDF_ANIMATE);
 DRawDIBBegin(han,dest.handle,0,0,pbmi,pbmi^.biWidth,pbmi^.biheight,0);
// DrawDIBRealize(han,dest.handle,false);
// DrawDIBDraw(han,dest.handle,0,0,pbmi^.biWidth,pbmi^.biheight,pbmi,Punter,0, 0,pbmi^.biwidth,pbmi^.biheight,0);
 DrawDIBDraw(han,dest.handle,0,0,pbmi^.biWidth,pbmi^.biheight,pbmi,ImageArr,0, 0,pbmi^.biwidth,pbmi^.biheight,0);
 DrawDIBEnd(han);
// DrawDIBStop(han);
// DrawDIBClose(han);
// Image1.Invalidate;
end;

{procedure TForm1.edDropLowChange(Sender: TObject);
begin
 MaxDropOut:=StrToIntDef(edDropLow.Text,100);
end;}


procedure TMainForm.edBlockValueChange(Sender: TObject);
begin
 BlockMinimum:=StrToIntDef(frmASDSettings.edBlockValue.Text,200);
end;



{procedure TMainForm.sbShowSettingsClick(Sender: TObject);
begin
 frmASDSettings.gbDetectionSettings.Visible:=not(frmASDSettings.gbDetectionSettings.Visible);
end;}


{procedure TMainForm.sbImageFullClick(Sender: TObject);
begin
// ImagePartial:=(Sender as TComponent).Tag;
 frmASDSettings.edCutFromTop.Text:=IntToStr((100-(100 div (Sender as TComponent).Tag)));
 frmASDSettings.edCutFromBottom.Text:=IntToStr(1);
 if AVIFileIsOpen then
 begin
  ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
  ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
 end;
 frmASDSettings.sbCopyFromMainClick(Sender);
end;}

procedure TMainForm.sbSaveScriptClick(Sender: TObject);
var SL:TStringList; Script:TScript; s1:string; i:integer;
begin
//
 if SaveSub.Execute then
 begin
 Script:=TScript.Create;
 SL:=TStringList.Create;
 SL.Text:=reSubData.Text;
// Script.ParseSAMI(SL,Now);
 for i:=1 to sgSubData.RowCount-1 do
 if StrToTimeMS(sgSubData.Cells[0, i],-1)>=0 then
 begin
  Script.AddSimple(StrToTimeMS(sgSubData.Cells[0, i],0),-1,sgSubData.Cells[2, i]);
 end;
 Script.CheckScript;
 s1:=ChangeFileExt(ExtractFileName(SaveSub.FileName),'');
 Script.MoveBy(TimeOffset);
 if cbSaveSub.ItemIndex=2 then
  begin
   s1:=s1+'.smi';
   Script.SaveAs(s1, SUB_SAMI);
  end;
 if cbSaveSub.ItemIndex=1 then
  begin
   s1:=s1+'.ssa';
   Script.SaveAs(s1, SUB_SSA);
  end;
 if cbSaveSub.ItemIndex=0 then
  begin
   s1:=s1+'.srt';
   Script.SaveAs(s1, SUB_SRT);
  end;
 if cbSaveSub.ItemIndex=3 then
  begin
   s1:=s1+'.srt';
   Script.SaveAs(s1, SUB_SRT_EXTENDED);
  end;

 SL.Free;
 Script.Free;
 end;
end;

procedure TMainForm.sbClearScriptClick(Sender: TObject);
begin
 reSubData.Text:='';
 sgSubData.RowCount:=2;
 sgSubData.Rows[sgSubData.RowCount-1].Clear;

{ sgSubData.Cells[0,sgSubData.RowCount-1]:='';
 sgSubData.Cells[1,sgSubData.RowCount-1]:='';
 sgSubData.Cells[2,sgSubData.RowCount-1]:='';
 sgSubData.Cells[3,sgSubData.RowCount-1]:='';}
end;

procedure TMainForm.cbSaveFrameBMPClick(Sender: TObject);
begin
 edSaveBMPPath.Enabled:=cbSaveFrameBMP.Checked;
 IsSaveBMP:=cbSaveFrameBMP.Checked;
end;

procedure TMainForm.cbDebugEmptyDataClick(Sender: TObject);
begin
 IsEmptyDebugged:=(cbDebugEmptyData.Checked);
end;

procedure TMainForm.SaveFrame;
var s:string; Bmpx: TBitmap;
begin
//
 if (FrameType=0) and not(IsEmptyDebugged) then exit; //no bmp for empty frame
// if not(cbShowImage.Checked) then
// FrameToBitmap(AviFile.ImageSaved,pbmi); //otherwise frame is already there
 AviFile.GetFrame(FrameIndex);
 if not DirectoryExists(edSaveBMPPath.Text) then
    if not CreateDir(edSaveBMPPath.Text) then
    begin
     cbSaveFrameBMP.Checked:=false;
     cbSaveFrameBMPClick(cbSaveFrameBMP);
    raise Exception.Create('Cannot create '+edSaveBMPPath.Text);
    end;
 if (cbAutoSavePreOCR.Checked) then
 begin
  Bmpx:=TBitmap.Create; Bmpx.Height:=abs(FrameHeight-ImageCutTop-ImageCutBottom);
// ImageCutBottom to (FrameHeight-ImageCutTop)-1
  Bmpx.Width:=FrameWidth;
  BitBlt(Bmpx.Canvas.Handle,0,0,FrameWidth,Bmpx.Height,AviFile.ImageSaved.Canvas.Handle,0,ImageCutTop,SRCCOPY);
  PreOCRFrame.AddSubPicture(Bmpx, FrameIndex);
  Bmpx.Free;
 end
 else   
 if DirectoryExists(edSaveBMPPath.Text) then
 begin

 s:=(edSaveBMPPath.Text)+'\';
 if cbNameFrameFirst.Checked then
 begin
  if (FrameIndex<100000) then s:=s+'0';
  if (FrameIndex<10000) then s:=s+'0';
  if (FrameIndex<1000) then s:=s+'0';
  if (FrameIndex<100) then s:=s+'0';
  if (FrameIndex<10) then s:=s+'0';
  s:=s+IntToStr(FrameIndex)+' ';
//  s:=s+Format('%6u',[FrameIndex])+' ';
  if FrameType=2 then s:=s+'C' else
  if FrameType=1 then s:=s+'S' else
  if FrameType=0 then s:=s+'E';
  s:=s+' Time='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))+'ms';
  s:=s+' '+ChangeFileExt(ExtractFileName(CurrentAVI),'');
  s:=s+'.bmp';
 end
 else
 begin
 s:=s+ChangeFileExt(ExtractFileName(CurrentAVI),'');
  if (FrameIndex<100000) then s:=s+'0';
  if (FrameIndex<10000) then s:=s+'0';
  if (FrameIndex<1000) then s:=s+'0';
  if (FrameIndex<100) then s:=s+'0';
  if (FrameIndex<10) then s:=s+'0';
  s:=s+' F='+IntToStr(FrameIndex);
//  s:=s+' F='+Format('%06u',[FrameIndex]);
  if FrameType=2 then s:=s+'C' else
  if FrameType=1 then s:=s+'S' else
  if FrameType=0 then s:=s+'E';

  s:=s+' Time='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))+'ms';
  s:=s+'.bmp';
 end;
  try
   ImageSaved.SaveToFile(s);
  except
   cbSaveFrameBMP.Checked:=false;
   cbSaveFrameBMPClick(cbSaveFrameBMP);
  end;


{
                       'Time='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))
                        +'ms Frame='+IntToStr(FrameIndex)+
                        ' MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal)+
                        ' DLC='+IntToStr(SharpLines));}
 end;

end;



{procedure TMainForm.sbReduceColorsClick(Sender: TObject);
var PX, PXC:PByteArray; Y,i, j, Pix, Pix_offs, Pix_offs2, ValR, ValG, ValB:longint;
    R1,G1,B1, R2,G2,B2, LastR, LastG, LastB: byte;
begin
 RestoreImage;
 SaveImage;
 for Y:=Image1.Picture.Height-Offs-1 downto (Image1.Picture.Height-(Image1.Picture.Height div ImagePartial))+Offs do
 begin
  PX:=Image1.Picture.Bitmap.ScanLine[Y];
  PXC:=ImageSaved.ScanLine[Y];
  for i:=Offs to FrameWidth-Offs-1 do
   begin
    Pix:=(i)*3;
    Pix_offs:=(i+Offs)*3;
    LastR:=255;
    LastG:=255;
    LastB:=255;
//    Pix_offs2:=(i-Offs)*3;
    ValR:=0; ValG:=0; ValB:=0; //for zero influence
    R1:=PXC[Pix]; G1:=PXC[Pix+1]; B1:=PXC[Pix+2];
    R2:=PXC[Pix_offs]; G2:=PXC[Pix_offs+1]; B2:=PXC[Pix_offs+2];
    ValR:=abs(PXC[Pix]-PXC[Pix_offs]); ValG:=abs(PXC[Pix+1]-PXC[Pix_offs+1]); ValB:=abs(PXC[Pix+2]-PXC[Pix_offs+2]);
    SharpXRedTmp:=0; SharpXBlueTmp:=0; SharpXGreenTmp:=0;
     if (IsDropRed) then begin if (ValR>DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (IsDropGreen) then begin if (ValG>DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (IsDropBlue) then begin if (ValB>DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
    if (IsDropSum) then if (SharpXRedTmp+SharpXBlueTmp+SharpXGreenTmp>DropSum) then SharpXBlueTmp:=0; SharpXGreenTmp:=0; SharpXRedTmp:=0;
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
      end
   end;
 end;
end;
}
{procedure TMainForm.cbShowImageClick(Sender: TObject);
begin
 ImageForm.Visible:=cbShowImage.Checked;
 ShowImages:=ImageForm.Visible;
end;}

procedure TMainForm.btStartClick(Sender: TObject);
var i:integer;
var SL:TStringList; Script:TScript; s1:string;
begin
 if cbAVIList.Items.Count=0 then
 begin
  btAddAVIClick(Sender);
 end;
 HasChecked:=true;

{ btAVIClear.Enabled:=false;}
   if not(IsShowAVI) then
   while(HasChecked) do
   begin
    HasChecked:=false;
    i:=0;
    while (i<cbAVIList.Items.Count) and not(HasChecked) do
    begin
     HasChecked:=cbAVIList.Checked[i];
     inc(i);
    end;
    if (HasChecked) and (i<=cbAVIList.Items.Count) then
    begin
     if not(StopProcess) and not(PauseProcess) then
     begin
      OldImageIsSharp:=false;
     end;

     miStartProcessing.Checked:=true;//     ShowAvi(OpenAVI.Files[i-1]);
//     if not(CurrentAVI='') and
     if (AVIFileIsOpen) and not(CurrentAVI=cbAVIList.Items[i-1]) then
     begin
         MyAVIFileClose;
         StopProcess:=false;
         PauseProcess:=false;
         edStartingFrame.Text:='0';
     end;
     CurrentAVI:=cbAVIList.Items[i-1];
     ShowAvi(cbAVIList.Items[i-1]);

     if (PauseProcess) then exit;
     IF (StopProcess) THEN
     BEGIN //if not paused then save result
      if (FrameIndex>MovieLength) then
      begin
       cbAVIList.Checked[i-1]:=false;
       cbAVIList.ItemIndex:=i-1;
      end;
       PerformAutoSave;
{      if (cbAutoSaveStat.Checked) then
      begin
         s1:=ChangeFileExt(ExtractFileName(cbAVIList.Items[i-1]),'.ast');
         //     s1:=ExtractFileName(cbAVIList.Items[i-1]);
         if not(edSaveStatPath.Text[length(edSaveStatPath.Text)]='\')
            then s1:=edSaveStatPath.Text+'\'+s1
            else s1:=edSaveStatPath.Text+s1;
       SaveStats(s1);
      end;
      if (cbAutoSaveSub.Checked) then
      begin
         Script:=TScript.Create;
         SL:=TStringList.Create;
         SL.Text:=reSubData.Text;
         Script.ParseSAMI(SL,Now);
         s1:=ChangeFileExt(ExtractFileName(cbAVIList.Items[i-1]),'');
         if not(edSaveSubPath.Text[length(edSaveSubPath.Text)]='\')
            then s1:=edSaveSubPath.Text+'\'+s1
            else s1:=edSaveSubPath.Text+s1;

         s1:=StringReplace(s1,'\\','\',[rfReplaceAll]);
         if not DirectoryExists(edSaveSubPath.Text) then
         if not CreateDir(edSaveSubPath.Text) then
         begin
          cbAutoSaveSub.Checked:=false;
          cbAutoSaveSubClick(cbAutoSaveSub);
         raise Exception.Create('Cannot create '+edSaveSubPath.Text);
         end;
         if cbSaveSub.ItemIndex=2 then
          begin
           s1:=s1+'.smi';
           Script.SaveAs(s1, SUB_SAMI);
          end;
         if cbSaveSub.ItemIndex=1 then
          begin
           s1:=s1+'.ssa';
           Script.SaveAs(s1, SUB_SSA);
          end;
         if cbSaveSub.ItemIndex=0 then
          begin
           s1:=s1+'.srt';
           Script.SaveAs(s1, SUB_SRT);
          end;
         SL.Free;
         Script.Free;
//         reSubData.Text:='';
         sbClearScriptClick(Sender);
       end;}


//      cbAVIList.ItemIndex:=i+1;

     END
     ELSE begin  {btAVIClear.Enabled:=true;} EXIT; end;
    end
//    ShowAvi(OpenAVI.FileName)
    else begin {btAVIClear.Enabled:=true;} exit; end;
   end;
end;

procedure TMainForm.cbAutoSaveSubClick(Sender: TObject);
begin
 //
 edSaveSubPath.Enabled:=cbAutoSaveSub.Checked;
// edSaveStatPath.Enabled:=cbAutoSaveStat.Checked;
end;

procedure TMainForm.btAVIClearClick(Sender: TObject);
begin
 if not(IsShowAVI) then cbAVIList.Clear;
end;

{procedure TMainForm.edMinimalFrameDistanceChange(Sender: TObject);
begin
 MinimalChangeFrameDistance:=StrToIntDef(edMinimalFrameDistance.Text,1);
end;}

{procedure TMainForm.HighlightImage;
var Y, i, j, k, Pix, Pix_Offs, ValR, ValB, ValG: integer;
    Image_Line:PByteArray;
    BV:integer;
  ZeroBlockCtr,  DropBlockCtr,  WeakBlockCtr,  StrongBlockCtr,
  StrongerBlockCtr: integer;

  DropBlockMaximum,  WeakBlockMaximum, StrongBlockMaximum,
  StrongerBlockMaximum, StrongBlockMinimum, StrongerBlockMinimum: integer;

  DropBlockAvg, WeakBlockAvg, StrongBlockAvg, StrongerBlockAvg: extended;

  IsWeakBlock:boolean;
  IsDominator:boolean;
  LineBlocker:array[0..255] of integer; //counters of lines with [X] number of blocks
  s: string;
begin
 if (ShowImages) then
// for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
 for Y:=ImageCutBottom to (FrameHeight - ImageCutTop)-1 do //checking lower part of image
     begin
      //
      Image_Line:=Bitmap.ScanLine[FrameHeight-Y-1];

      if ImageForm.sbDominating.Down then
      begin
      for i:=0 to FrameWidth-1 do
       begin
        Pix:=(i)*3;
        ValR:=Image_Line[Pix+2];
        ValG:=Image_Line[Pix+1];
        ValB:=Image_Line[Pix];
        IsDominator:=false;
       for j:=0 to Length(ColorDominators)-1 do
       begin
        k:=Abs(ValR-ColorDominators[j].R)+
                 Abs(ValG-ColorDominators[j].G)+
                 Abs(ValB-ColorDominators[j].B);
        if (k<=DominatorDeviation) then begin IsDominator:=true; break; end;
       end;
       if (IsDominator) then
        begin
         Image_Line[Pix]:=255;//ColorDominators[j].B;
         Image_Line[Pix+1]:=255;//ColorDominators[j].G;
         Image_Line[Pix+2]:=255;//ColorDominators[j].R;
        end
        else
        begin
         Image_Line[Pix]:=0;
         Image_Line[Pix+1]:=0;
         Image_Line[Pix+2]:=0;
        end;
       end;
      end;
      if ImageForm.sbDominatingSharp.Down then
      begin
      for i:=0 to FrameWidth-1 do
       begin
        Pix:=(i)*3;
        ValR:=Image_Line[Pix+2];
        ValG:=Image_Line[Pix+1];
        ValB:=Image_Line[Pix];
        IsDominator:=false;
       for j:=0 to Length(ColorDominators)-1 do
       begin
        k:=Abs(ValR-ColorDominators[j].R)+
                 Abs(ValG-ColorDominators[j].G)+
                 Abs(ValB-ColorDominators[j].B);
        if (k<=DominatorDeviation) then begin IsDominator:=true; break; end;
       end;
       if (IsDominator) and not(BlockPattern[i div BlockSize,Y]<BlockMinimum) then
        begin
         Image_Line[Pix]:=255;//ColorDominators[j].B;
         Image_Line[Pix+1]:=255;//ColorDominators[j].G;
         Image_Line[Pix+2]:=255;//ColorDominators[j].R;
        end
        else
        begin
         Image_Line[Pix]:=0;
         Image_Line[Pix+1]:=0;
         Image_Line[Pix+2]:=0;
        end;
       end;
      end;
      if ImageForm.sbViewSubstract.Down then
      for i:=0 to FrameWidth-1 do
       begin
        Pix:=(i)*3;
        Pix_offs:=(i+Offs)*3;
        ValR:=abs(Image_Line[Pix+2]-Image_Line[Pix_Offs+2]);
        ValG:=abs(Image_Line[Pix+1]-Image_Line[Pix_Offs+1]);
        ValB:=abs(Image_Line[Pix]-Image_Line[Pix_Offs]);
//        if (IsDropRed) then begin if (ValR>DropRed) then Image_Line[Pix+2]:=255 else Image_Line[Pix+2]:=0; end;
//        if (IsDropGreen) then begin if (ValG>DropGreen) then Image_Line[Pix+1]:=255 else Image_Line[Pix+1]:=0; end;
//        if (IsDropBlue) then begin if (ValB>DropBlue) then Image_Line[Pix]:=255 else Image_Line[Pix]:=0; end;
        Image_Line[Pix]:=abs(Image_Line[Pix]-Image_Line[Pix_Offs]);
        Image_Line[Pix+1]:=abs(Image_Line[Pix+1]-Image_Line[Pix_Offs+1]);
        Image_Line[Pix+2]:=abs(Image_Line[Pix+2]-Image_Line[Pix_Offs+2]);
       end;
      if ImageForm.sbCheckBlockLines.Down and (ImageForm.sbInvertLine.Down) then
      begin
      if (OldLineBlockCount[Y]>MinLineBlockNum) then
       for i:=0 to FrameWidth-1 do
       begin //inverting line
         Pix:=i*3;
         Image_Line[Pix]:=not(Image_Line[Pix]);
         Image_Line[Pix+1]:=not(Image_Line[Pix+1]);
         Image_Line[Pix+2]:=not(Image_Line[Pix+2]);
       end;
      end
     else 
     if ImageForm.sbCheckBlockLines.Down and
      not(ImageForm.sbInvertLine.Down) then
      for i:=0 to (FrameWidth div BlockSize)-2 do
        if not(BlockPattern[i,Y]<BlockMinimum) then
        for k:=0 to 15 do
        begin
         Pix:=(k+i*BlockSize)*3;
         Image_Line[Pix]:=not(Image_Line[Pix]);
         Image_Line[Pix+1]:=not(Image_Line[Pix+1]);
         Image_Line[Pix+2]:=not(Image_Line[Pix+2]);
        end;
      if ImageForm.sbZeroPoints.Down then
      for i:=0 to FrameWidth-1 do
       begin
        Pix:=(i)*3;
        Pix_offs:=(i+Offs)*3;
        ValR:=abs(Image_Line[Pix+2]-Image_Line[Pix_Offs+2]);
        ValG:=abs(Image_Line[Pix+1]-Image_Line[Pix_Offs+1]);
        ValB:=abs(Image_Line[Pix]-Image_Line[Pix_Offs]);
        if (IsDropRed) then begin if (ValR>DropRed) then Image_Line[Pix+2]:=255 else Image_Line[Pix+2]:=0; end;
        if (IsDropGreen) then begin if (ValG>DropGreen) then Image_Line[Pix+1]:=255 else Image_Line[Pix+1]:=0; end;
        if (IsDropBlue) then begin if (ValB>DropBlue) then Image_Line[Pix]:=255 else Image_Line[Pix]:=0; end;
//        Image_Line[Pix]:=abs(Image_Line[Pix]-Image_Line[Pix_Offs]);
//        Image_Line[Pix+1]:=abs(Image_Line[Pix+1]-Image_Line[Pix_Offs+1]);
//        Image_Line[Pix+2]:=abs(Image_Line[Pix+2]-Image_Line[Pix_Offs+2]);
       end;
    end;
}
{
  ZeroBlockCtr:=0;
  DropBlockCtr:=0;  DropBlockMaximum:=0;  DropBlockAvg:=0;
  WeakBlockCtr:=0;  WeakBlockMaximum:=0;  WeakBlockAvg:=0;
  StrongBlockCtr:=0;  StrongBlockMaximum:=0;  StrongBlockAvg:=0; StrongBlockMinimum:=100000;
  StrongerBlockCtr:=0;  StrongerBlockMaximum:=0;  StrongerBlockAvg:=0; StrongerBlockMinimum:=100000;

 for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
  for i:=0 to (FrameWidth div 16)-2 do
  begin
  BV:=BlockPattern[i,Y];
  if BV=0 then Inc(ZeroBlockCtr)
  else
  if BV<BlockMinimum then
   begin
    Inc(DropBlockCtr);
    if BV>DropBlockMaximum then DropBlockMaximum:=BV;
    DropBlockAvg:=DropBlockAvg+BV;
   end
  else //if not(BV<BlockMinumum)
  begin
   IsWeakBlock:=true;
   if (i>0) then IsWeakBlock:=(IsWeakBlock and (BlockPattern[i-1,Y]<BlockMinimum));
   if (i<((FrameWidth div 16)-2)) then IsWeakBlock:=IsWeakBlock and (BlockPattern[i+1,Y]<BlockMinimum);
   if (IsWeakBlock) then
   begin
    Inc(WeakBlockCtr);
    if BV>WeakBlockMaximum then WeakBlockMaximum:=BV;
    WeakBlockAvg:=WeakBlockAvg+BV;
   end
   else
   begin
    Inc(StrongBlockCtr);
    if BV>StrongBlockMaximum then StrongBlockMaximum:=BV;
    if BV<StrongBlockMinimum then StrongBlockMinimum:=BV;
    StrongBlockAvg:=StrongBlockAvg+BV;
    if (LineBlockCount[Y]>MinLineBlockNum) then
     if (LineBlockCount[Y+1]>MinLineBlockNum) then
     if (Y>0) and (LineBlockCount[Y-1]>MinLineBlockNum) then
     begin
      Inc(StrongerBlockCtr);
      if BV>StrongerBlockMaximum then StrongerBlockMaximum:=BV;
      if BV<StrongerBlockMinimum then StrongerBlockMinimum:=BV;
      StrongerBlockAvg:=StrongerBlockAvg+BV;
     end;
   end;
  end;
  end;
 if (StrongBlockCtr>0) then StrongBlockAvg:=StrongBlockAvg/StrongBlockCtr else StrongBlockMinimum:=0;
 if (DropBlockCtr>0) then DropBlockAvg:=DropBlockAvg/DropBlockCtr;
 if (WeakBlockCtr>0) then WeakBlockAvg:=WeakBlockAvg/WeakBlockCtr;
 if (StrongerBlockCtr>0) then StrongerBlockAvg:=StrongerBlockAvg/StrongerBlockCtr  else StrongerBlockMinimum:=0;
//  s:=
 lbTrack1.Caption:=IntToStr(DropBlockCtr)+' / '+IntToStr(DropBlockMaximum)+' / '+IntToStr(Trunc(DropBlockAvg));
 lbTrack2.Caption:=IntToStr(WeakBlockCtr)+' / '+IntToStr(WeakBlockMaximum)+' / '+IntToStr(Trunc(WeakBlockAvg));
 lbTrack3.Caption:=IntToStr(StrongBlockCtr)+' / '+IntToStr(StrongBlockMaximum)+' / '+IntToStr(StrongBlockMinimum)+' / '+IntToStr(Trunc(StrongBlockAvg));
 lbTrack4.Caption:=IntToStr(StrongerBlockCtr)+' / '+IntToStr(StrongerBlockMaximum)+' / '+IntToStr(StrongerBlockMinimum)+' / '+IntToStr(Trunc(StrongerBlockAvg));
 }
{end;}//end of HighLight

{procedure TMainForm.lbColorDominatorClick(Sender: TObject);
begin
 //Select Color from Image
 cbShowImage.Checked:=true;
 cbShowImageClick(Sender);
 ImageForm.Caption:='Image (selecting color)';
end;

procedure TMainForm.sbNextDominatorClick(Sender: TObject);
begin
 DominatorSelected:=Min(DominatorSelected+1,System.Length(ColorDominators)-1);
 frmASDSettings.PanelSettingsToData(Sender);
end;

procedure TMainForm.sbDeleteDominatorClick(Sender: TObject);
var i:integer;
begin
 if (Length(ColorDominators)>1) then
 begin
 for i:=DominatorSelected to Length(ColorDominators)-2 do
   ColorDominators[i]:=ColorDominators[i+1];
  DominatorSelected:=Max(DominatorSelected-1,System.Length(ColorDominators)-1);
  frmASDSettings.PanelSettingsToData(Sender);
 end;
end;
}
function TMainForm.AlternativeLBCCheck:boolean;
var i,j,Y, l1, l2:integer; MaxLineBlockCount, MaxOtherBlockCount, Counter, Alt: integer;
begin
 Result:=false;
 MaxLineBlockCount:=0;
// for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
 for Y:=ImageCutBottom to (FrameHeight - ImageCutTop)-1 do //checking lower part of image
 if LineBlockCount[Y]>MaxLineBlockCount then MaxLineBlockCount:=LineBlockCount[Y];

 if (MaxLineBlockCount>MinLineBlockNum) then
 begin
  Counter:=0; Alt:=0;
//  for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
  for Y:=ImageCutBottom to (FrameHeight - ImageCutTop)-1 do //checking lower part of image
   if LineBlockCount[Y]=MaxLineBlockCount then Inc(Counter);
  if Counter>LineCountNeeded then
   begin
    AlternativeMBC_Lines[Alt]:=Counter;
    AlternativeMBC_Count[Alt]:=MaxLineBlockCount;
    inc(Alt);
   end;
  while(Counter>0) and (MaxLineBlockCount>MinLineBlockNum) do
   begin
    MaxOtherBlockCount:=0;
//    for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
    for Y:=ImageCutBottom to (FrameHeight - ImageCutTop)-1 do //checking lower part of image
     if    (LineBlockCount[Y]>MaxOtherBlockCount)
        and(LineBlockCount[Y]<MaxLineBlockCount)
      then MaxOtherBlockCount:=LineBlockCount[Y]; //finding next to maximum block count
    Counter:=0;
//   for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
    for Y:=ImageCutBottom to (FrameHeight - ImageCutTop)-1 do //checking lower part of image
     if LineBlockCount[Y]=MaxOtherBlockCount then Inc(Counter);
    if Counter>LineCountNeeded then
    if not(Alt>40) then
    begin
     AlternativeMBC_Lines[Alt]:=Counter;
     AlternativeMBC_Count[Alt]:=MaxOtherBlockCount;
     inc(Alt);
    end;
     MaxLineBlockCount:=MaxOtherBlockCount;
   end; //end of while
 {if (Alt<40) then}
 for i:=Alt to 40 do
    begin
     AlternativeMBC_Lines[Alt]:=0;
     AlternativeMBC_Count[Alt]:=0;
    end;


 //let's think that we filled AlternativeMBC_Lines and AlternativeMBC_Count
 //with needed data, now we should sort them by AlternativeMBC_Lines
 //(aka number of lines with Count number of "blocks")
 //(now arrays are sorted by BlockCount)
 for i:=0 to 40 do //slow, but error-prone sorting algorithm :)
 for j:=i+1 to 40 do
  if (AlternativeMBC_Lines[i]<AlternativeMBC_Lines[j]) then
  //higher LineCount should be first
   begin
    l1:=AlternativeMBC_Lines[i];
    AlternativeMBC_Lines[i]:=AlternativeMBC_Lines[j];
    AlternativeMBC_Lines[j]:=l1;

    l1:=AlternativeMBC_Count[i];
    AlternativeMBC_Count[i]:=AlternativeMBC_Count[j];
    AlternativeMBC_Count[j]:=l1;
   end;
 //and now to actual Change Checking
 //checking first three old entries for changes
// LBCLinesOlder:=AlternativeMBC_Lines_Old[0];
 LBCLinesOlder:=LBCLines;
 //----------------------------
 for j:=0 to 2 do
  begin
  if (AlternativeMBC_Count_Old[j]>MinLineBlockNum) then
  for i:=0 to 40 do
   if AlternativeMBC_Count_Old[j]=AlternativeMBC_Count[i] then
    begin
     if (abs(AlternativeMBC_Lines[i]-AlternativeMBC_Lines_Old[j])>LBCLimit)
      then
      begin
       LBCLinesOlder:=AlternativeMBC_Lines_Old[j]; //old number of lines
       LBCLines:=AlternativeMBC_Lines[i]; //new number of lines with count blocks
       LBCCount:=AlternativeMBC_Count[i];
       Result:=true;
      end;
     break;
    end;
  if (i=40) and (Result=false) then //not found same number of blocks
  if (AlternativeMBC_Lines_Old[j]>LBCLimit) then //if it was over limit
  begin
   LBCLinesOlder:=AlternativeMBC_Lines_Old[j];
   LBCCount:=AlternativeMBC_Count_Old[j];
   LBCLines:=0; //since it was not found, it assumes that result is zero
   Result:=true;
  end;
  end;//end for j
//-------------------------
  for i:=0 to 40 do AlternativeMBC_Count_Old[i]:=AlternativeMBC_Count[i];
  for i:=0 to 40 do AlternativeMBC_Lines_Old[i]:=AlternativeMBC_Lines[i];
  if Result=false then
   begin
       LBCLines:=AlternativeMBC_Lines[0];
       LBCCount:=AlternativeMBC_Count[0];
       LBCLinesOlder:=LBCLines;
   end;
 end
 else
 begin //emptying Old records since highest of them are below MinLineBlockNum threshold
  for i:=0 to 40 do AlternativeMBC_Lines_Old[i]:=0;
  for i:=0 to 40 do AlternativeMBC_Count_Old[i]:=0;
  LBCLines:=0;
  LBCCount:=0;
  LBCLinesOlder:=0;
 end;

end;


procedure TMainForm.sbOpenSubClick(Sender: TObject);
var SL:TStringList; Script:TScript; s1:string;
    i:integer;
begin
 if OpenSub.Execute then
 begin
 Script:=TScript.Create;
 SL:=TStringList.Create;
 try
 
 SL.LoadFromFile(OpenSub.FileName);
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.SSA') then Script.ParseSSA(SL,'SSA0', FileDateToDateTime(FileAge(OpenSub.FileName)));
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.SRT') then Script.ParseSRT(SL,'SRT0', FileDateToDateTime(FileAge(OpenSub.FileName)));
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.RT') then  Script.ParseRT(SL, 'RT0', FileDateToDateTime(FileAge(OpenSub.FileName)));
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.FSB') then Script.ParseFSB(SL{, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName))});
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.SMI') then Script.ParseSAMI(SL, FileDateToDateTime(FileAge(OpenSub.FileName)));
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.ZEG') then Script.ParseZEG(SL,'ZEG0', FileDateToDateTime(FileAge(OpenSub.FileName)));
   if (UpperCase(ExtractFileExt(OpenSub.FileName))='.JS') then  Script.ParseJS(SL, 'JS0', FileDateToDateTime(FileAge(OpenSub.FileName)));
   sbClearScriptClick(Sender);
//   reSubData.Text:=Script.GetPlainSAMI;
   for i:=0 to Script.Count-1 do
   begin
    if (Script._SI[i].Status=_Text) or (Script._SI[i].Status=_Clear) then
    AddSubLineTimed(Script._SI[i].Time,Script._SI[i].Line);
   end;
//   if (UpperCase(ExtractFileExt(FileName))='.S2K') then MainScript.ParseS2K(SL{, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName))});
 except
 end;
 SL.Free;
 Script.Free;
 end;
end;


procedure TMainForm.UpdateStatus;
begin
 case CurrentStatus of
  ST_STOPPED: StatusPanel.Caption:='STOPPED';
  ST_PAUSED: StatusPanel.Caption:='PAUSED';
  ST_NO_SUBTITLE: StatusPanel.Caption:='NO SUBTITLE';
  ST_NO_SUBTITLE_NOW: StatusPanel.Caption:='*NO SUBTITLE*';
  ST_DETECTED: StatusPanel.Caption:='DETECTED';
  ST_DETECTED_NOW: StatusPanel.Caption:='*DETECTED*';
  ST_CHANGED: StatusPanel.Caption:='CHANGED';
  ST_CHANGED_NOW: StatusPanel.Caption:='*CHANGED*';
  ST_ERROR: StatusPanel.Caption:='*ERROR*';
  ST_NO_DATA: StatusPanel.Caption:='NO STAT DATA';
  ST_SKIP: StatusPanel.Caption:='CHANGE SKIPPED';
  ST_FINISHED: StatusPanel.Caption:='FINISHED';
 end;
 miAVIClick(Self);
end;

procedure TMainForm.MyAVIFileOpen(FFileName: string);
//var s:string;
//    principio,fin:integer;
//    microsperframe:integer;
var i: integer; s: string;
begin
  if AviFile.pavi<>nil then AviFile.CloseAVI;
  FrameIndex:=0;
   AviFile.OpenAvi(FFileName);
   CurrentAVI:=FFileName;
   AVIFileIsOpen:=true;
   tbFrameSeek.Enabled:=true;
   tbFrameSeek.Max:=AviFile.MovieLength-1;
   tbFrameSeek.Position:=0;
   CurrentFrameStats.DLC:=0; PrevFrameStats:=CurrentFrameStats;
{   pbmi:=AVIStreamGetFrame(ob,0);}
   AviFile.GetFrame(0);
   frmASDSettings.ForceUpdate;
{  lbFileInfo.Caption:=IntToStr(FrameWidth)+'x'+IntToStr(FrameHeight)+'x'+IntToStr(pbmi.biBitCount)
                       +' (FPS:'+FloatToStr(FrameRate/FrameScale)+')';
  lbFileName.Caption:=FFileName;
  lbFileName.Hint:=FFileName;}
  Caption:='AviSubDetector: Processing File "'+FFileName+'" ['+
           IntToStr(FrameWidth)+'x'+IntToStr(FrameHeight)+'x'+IntToStr(pbmi.biBitCount)
                       +' (FPS:'+FloatToStr(FrameRate/FrameScale)+')]';
  FrameRateUpdate; //updating frame numbers in script
  SetLength(Stats,AviFile.MovieLength);
  for i:=0 to Length(Stats)-1 do Stats[i].HasData:=false;
  if cbAutoLoadStat.Checked then
  begin
   //!x!
         s:=ChangeFileExt(ExtractFileName(CurrentAvi),'.ast');
//         s:=ExtractFileName(CurrentAvi);
         if not(edSaveStatPath.Text[length(edSaveStatPath.Text)]='\')
            then s:=edSaveStatPath.Text+'\'+s
            else s:=edSaveStatPath.Text+s;
//         s:=s+'.ast';
       if FileExists(s) then LoadStats(s);
  end;
  if sbAutomaticProcessing.Down then //sbClearScriptClick(Self);
  if cbClearScriptOnAviOpen.Checked then sbClearScriptClick(Self);
  PreOCRFrame.ClearData;
end;

procedure TMainForm.MyAVIFileClose;
begin
//if not(CurrentAVI='') then
{ if (AVIFileIsOpen) then
 begin}
  AviFile.CloseAVI;
  CurrentAVI:='';
  AVIFileIsOpen:=false;
  tbFrameSeek.Enabled:=false;
  Caption:='AVISubDetector by Shalcker v'+VersionString+' (bat@etel.ru)';

 {  AVIStreamEndStreaming(pavis);
  AVIStreamGetFrameClose(ob);
  AVIStreamRelease(pavis);
  AVIFileRelease(pavi);}
{end;}
end;

procedure TMainForm.sbPauseClick(Sender: TObject);
begin
 PauseProcess:=true;
 IsShowAVI:=false; //in case of errors
 miAVIClick(Sender);
end;

procedure TMainForm.FindDialogFind(Sender: TObject);
var NewPos,LastPos:integer; SearchType:TSearchTypes;
begin
// if FindDialog.Execute then
  SearchType:=[];
  if (frWholeWord in FindDialog.Options) then SearchType:=SearchType+[stWholeWord];
  if (frMatchCase in FindDialog.Options) then SearchType:=SearchType+[stMatchCase];
  NewPos:=-1;
//  if (frDown in FindDialog.Options)  then
   //finding text down from current position
   NewPos:=reSubData.FindText(FindDialog.FindText,reSubData.SelStart+1,Length(reSubData.Text),SearchType);
{  else
  begin
   LastPos:=0; //not yet implemented
   while reScript1.FindText(FindDialog.FindText,LastPos,reScript1.SelStart
   NewPos:=reScript1.FindText(FindDialog.FindText,
  end;}
  if NewPos>=0 then
  begin
    reSubData.SetFocus;
    reSubData.SelStart:=NewPos;
    reSubData.SelLength:=Length(FindDialog.FindText);
  end
  else Beep;

end;

procedure TMainForm.sbCallFindClick(Sender: TObject);
begin
 FindDialog.Execute;
end;

{procedure TMainForm.AddSubLine;
var AC:TWinControl;
begin
 if cbShowLastLine.Checked then
 begin
 AC:=ActiveControl;
 reSubData.SetFocus;
 reSubData.Lines.Add(s);
 ActiveControl:=AC;
 end
 else reSubData.Lines.Add(s);
end;}

procedure TMainForm.AddSubLineTimed;
var AC:TWinControl; str:string;
begin
 str:='<SYNC Start='+IntToStr(Time)+'ms><P>'+s;
 if cbShowLastLine.Checked then
 begin
  AC:=ActiveControl;
  if reSubData.CanFocus then reSubData.SetFocus;
  reSubData.Lines.Add(str);
  ActiveControl:=AC;
 end
 else  reSubData.Lines.Add(str);
// if cbShowLastLine.Checked then  AC:=ActiveControl;
 with sgSubData do
 begin
  RowCount:=RowCount+1;
  Rows[RowCount-1].Clear;
  Cells[0,RowCount-2]:=IntToStr(Time);
//  Time:=1000*FrameIndex/(FrameRate/FrameScale)
// FI:=(Time*FrameRate)/(1000*FrameScale)
  Cells[1,RowCount-2]:=IntToStr(Trunc((Time*FrameRate)/(1000*FrameScale))+1);//IntToStr(FrameIndex);
  Cells[2,RowCount-2]:=s;
  Cells[3,RowCount-2]:=StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
  if cbShowLastLine.Checked then Row:=RowCount-2;
 end;

end;

procedure TMainForm.edCutFromTopChange(Sender: TObject);
begin //!//
 if AVIFileIsOpen then
 begin
  ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
  ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,1)*FrameHeight) div 100;
 end;
end;

procedure TMainForm.btInteractiveSettingsAdjustmentClick(Sender: TObject);
begin
// if AdjustmentForm=nil then AdjustmentForm:=TAdjustmentForm.Create(Self);
// with AdjustmentForm do sbCopyFromMainClick(Self);

// AdjustmentForm.Show;
//   Application.CreateForm(TAdjustmentForm, AdjustmentForm);
end;




procedure TMainForm.btOpenAviClick(Sender: TObject);
begin
 if dlgOpenAVI.Execute then
 MyAVIFileOpen(dlgOpenAvi.FileName);
end;

procedure TMainForm.tbFrameSeekChange(Sender: TObject);
begin
 if Self.Visible then
 begin
 
 if tbsSettings.Visible or frmASDSettings.pbFrame.Floating
    or scrlbPreview.Visible then
 begin
  FrameIndex:=tbFrameSeek.Position;
  if LastSeekFrame<>tbFrameSeek.Position then frmASDSettings.ForceUpdate;
  LastSeekFrame:=tbFrameSeek.Position;
 end;
 if tbsStats.Visible then
  begin
   pbMainGraphPaint(Sender);
  end;
 FramePanel.Caption:='Current Frame: '+IntToStr(tbFrameSeek.Position)+' / '+IntToStr(MovieLength);
  if Stats[FrameIndex].HasData then  UpdateCurrentStats;
 end;
end;

procedure TMainForm.tbsSettingsShow(Sender: TObject);
begin
 frmASDSettings.sbCopyFromMainClick(Sender);
 frmASDSettings.ForceUpdate;
end;

procedure TMainForm.tbsSettingsHide(Sender: TObject);
begin
 frmASDSettings.sbCopyToMainClick(Sender);
end;

procedure TMainForm.ManualProcessing;
var ModalRes: integer; s:string;
begin
 if FrameType=2 then LastChangeFrame:=FrameIndex;
 FrameToBitmap(ImageSaved,pbmi);
 ManualProcessingForm.LocalBitmap.Width:=FrameWidth;
 if cbFullFramePreview.Checked then ManualProcessingForm.LocalBitmap.Height:=FrameHeight
 else ManualProcessingForm.LocalBitmap.Height:=FrameHeight - ImageCutTop - ImageCutBottom; //(FrameHeight div ImagePartial);
//     ManualProcessingForm.btIgnoreChange.Enabled:=false; //no change detected here, so it cannot be skipped
//! if FrameType=1 then ManualProcessingForm.btIgnoreChange.Enabled:=cbAskOnEmpty.Checked//no change detected here, so it cannot be skipped - unless you can mark empty with subtitle
//! else
 ManualProcessingForm.btIgnoreChange.Enabled:=true;
 if FrameType=1 then ManualProcessingForm.btIgnoreChange.Caption:='Ignore (&C)'
 else ManualProcessingForm.btIgnoreChange.Caption:='Not &Changed';

 BitBlt(ManualProcessingForm.LocalBitmap.Canvas.Handle,0,0,FrameWidth,ManualProcessingForm.LocalBitmap.Height,ImageSaved.Canvas.Handle,0,FrameHeight-(ManualProcessingForm.LocalBitmap.Height),SRCCOPY);
 ManualProcessingForm.lbInfo.Caption:=StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
 ManualProcessingForm.pbSubtitle.Height:=ManualProcessingForm.LocalBitmap.Height+2;
 ManualProcessingForm.pbSubtitle.Width:=FrameWidth;
 ManualProcessingForm.AutoSize:=false;
 ManualProcessingForm.AutoSize:=true;

 ManualProcessingForm.lbInfo.Caption:=StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
 ManualProcessingForm.ActiveControl:=ManualProcessingForm.SubMemo;
 ManualProcessingForm.SubMemo.SelectAll;
 ModalRes:=ManualProcessingForm.ShowModal;
     if (ModalRes<>mrRetry) then
     begin LastChangeFrame:=FrameIndex; end
     else ImageIsSharp:=false; //skip to next "sharp" frame
     if ModalRes=mrOk then
     begin
      s:=StringReplace(ManualProcessingForm.SubMemo.Text,#13#10,'<BR>',[rfReplaceAll]);
      s:=StringReplace(s,#10,'<BR>',[rfReplaceAll]);
      s:=StringReplace(s,#13,'<BR>',[rfReplaceAll]);
      AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),s);
      if IsSaveBMP then SaveFrame(FrameType);
     end;
     if ModalRes=mrIgnore then //write nothing, ignore, skip until subtitle disappearance or change
     if (cbAskOnEmpty.Checked) or ((FrameType)<>1) then //since it is possible that _empty_ position was marked with subtitle while still being "non-sharp"
     begin
      //no subtitle - force write 'end of subtitle' &nbsp;
      //      ImageIsSharp:=false;
      AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
      if IsSaveBMP then SaveFrame(0);
     end;

//     if ModalRes=mrAbort then begin StopProcess:=true; FrameIndex:=FrameIndex-1; end;
     if ModalRes=mrAbort then begin PauseProcess:=true; FrameIndex:=FrameIndex-1; end;
     if ModalRes=mrAll then begin StopProcess:=true; FrameIndex:=FrameIndex-1; end;


     if (ModalRes<>mrRetry) then
     begin LastChangeFrame:=FrameIndex; end;
//     else ImageIsSharp:=false; //not used here since this will cause &nbps; write
//     if ModalRes=mrCancel then; //write nothing, ignore, skip until subtitle disappearance or change
//     if ModalRes=mrAbort then begin StopProcess:=true; FrameIndex:=FrameIndex-1; end;
//    end;
//    if IsSaveBMP then SaveFrame(2);
end;

procedure TMainForm.sbStartFromFrameClick(Sender: TObject);
begin
 edStartingFrame.Text:=IntToStr(tbFrameSeek.Position);
end;

procedure TMainForm.sbForceSubClick(Sender: TObject);
begin
 FrameIndex:=tbFrameSeek.Position;
 ManualProcessing(2);
end;

procedure TMainForm.edTimeOffsetChange(Sender: TObject);
begin
 if cbTimeOffset.Checked then TimeOffset:=StrToIntDef(edTimeOffset.Text,0)
 else TimeOffset:=0;
end;


procedure TMainForm.sgSubDataMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var SetNewTime:longint; GC:TGridCoord;
begin
 if (mbRight=Button) then
 begin
  GC:=(Sender as TStringGrid).MouseCoord(X,Y);
  if (GC.Y>0) then
  begin
   (Sender as TStringGrid).Row:=GC.Y;
//  SetNewTime:=StrToIntDef((Sender as TStringGrid).Cells[ColTime,(Sender as TStringGrid).Row],InternalTimer);
//  SetNewTime:=GetPanelScript(1).StrToTimeMS((Sender as TStringGrid).Cells[ColTime,(Sender as TStringGrid).Row],InternalTimer);
   if StrToIntDef((Sender as TStringGrid).Cells[1,GC.Y],-1)>-1 then
   tbFrameSeek.Position:=StrToIntDef((Sender as TStringGrid).Cells[1,GC.Y],0);
  end;
 end;
end;

procedure TMainForm.FrameRateUpdate;
var i, res: integer;
begin
 for i:=1 to sgSubData.RowCount-1 do
 begin
  res:=StrToTimeMS(sgSubData.Cells[0,i],-1);
  if (res>-1) then sgSubData.Cells[1,i]:=IntToStr(Round((Res/1000)*(FrameRate/FrameScale))+1);
 end;
end;


procedure TMainForm.sbNextKFClick(Sender: TObject);
var i: integer;
begin
 if AviFile.pavi=nil then exit;
 i:=AVIStreamNextKeyFrame(AviFile.pavis,MainForm.tbFrameSeek.Position);
 if (i>0) and (i<AviFile.MovieLength) then MainForm.tbFrameSeek.Position:=i;
end;

procedure TMainForm.sbGoToFrameClick(Sender: TObject);
var i: integer;
begin
 i:=StrToIntDef(edStartingFrame.Text,0);
 if (i<AviFile.MovieLength) then MainForm.tbFrameSeek.Position:=i;
end;

procedure TMainForm.sbPrevKFClick(Sender: TObject);
begin
 if AviFile.pavi=nil then exit;
 if MainForm.tbFrameSeek.Position>0 then
 MainForm.tbFrameSeek.Position:=AVIStreamPrevKeyFrame(AviFile.pavis,MainForm.tbFrameSeek.Position);
end;

procedure TMainForm.sgSubDataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i:integer;  
begin
 if (Key=VK_DELETE) then
 if (Shift = [ssCtrl]) then
 with Sender as TStringGrid do
 begin
  if not(Row=RowCount-1) then
  begin
  for i:=Row to RowCount-1 do
  begin
   Rows[i]:=Rows[i+1];
  end;
  RowCount:=RowCount-1;
  Rows[RowCount-1].Clear;
//  NotifyScriptUpdate:=true;
//  PanelChanged[Panel]:=true;
  end;
 end;
{ else
 if (Shift = [ssAlt]) then
 with Sender as TStringGrid do
 begin
  if not(Row=RowCount-1) then
  if (Row>0) then
  begin
   Cells[, Row-1]:=
  //modify endtime
   GetPanelScript(Panel).TimeMSToStr(
   GetPanelScript(Panel).StrToTimeMS(Cells[ColTime, Row])+GetPanelScript(Panel).StrToTimeMS(Cells[ColLength, Row])
   -GetPanelScript(Panel).StrToTimeMS(Cells[ColTime, Row-1]),TableLengthFormat);
  Cells[ColText, Row-1]:=Cells[ColText, Row-1]+'|'+Cells[ColText, Row];
  for i:=Row to RowCount-1 do
  begin
   Rows[i]:=Rows[i+1];
  end;
  RowCount:=RowCount-1;
  Rows[RowCount-1].Clear;
  NotifyScriptUpdate:=true;
  PanelChanged[Panel]:=true;
  end;
 end;}

end;

procedure TMainForm.sbShowPreviewClick(Sender: TObject);
var Tg:integer;
begin

//
 Tg:=(Sender as TComponent).Tag;
 if Tg=0 then
  if frmASDSettings.pbFrame.Floating then Tg:=1 else Tg:=2;
{ begin frmASDSettings.cbFloatingPreview.Checked:=not(frmASDSettings.cbFloatingPreview.Checked); end;
 if (Sender as TComponent).Tag=1 then
 begin
  frmASDSettings.cbFloatingPreview.Checked:=false;
  miPreviewIsSettings.Checked:=true;
 end;
 if (Sender as TComponent).Tag=2 then
 begin
  frmASDSettings.cbFloatingPreview.Checked:=true;
  miPreviewIsFloating.Checked:=true;
 end;}

{ frmASDSettings.cbFloatingPreviewClick(Sender);}
 frmASDSettings.SetPreviewState(Tg);
 sbShowPreview.Down:=frmASDSettings.pbFrame.Floating;



end;

procedure TMainForm.pbMainGraphPaint(Sender: TObject);
var i, start, stop, x, y, ht, ht2, LocalMax, LocalLimit: integer;
    MainCanvas, DiffCanvas: TCanvas;
    R,G,B: byte; s:string;
begin
 if Length(Stats)=0 then exit;
 Start:=Max(0,tbFrameSeek.Position-(pbMainGraph.ClientWidth div 2));
 Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
 Start:=Max(0,Start);
// if (Start<0) then Sta
 Stop:=Max(pbMainGraph.ClientWidth,tbFrameSeek.Position+(pbMainGraph.ClientWidth div 2));
 Stop:=Min(AviFile.MovieLength,Stop);
 Stop:=Stop-1;

 if (MainGraphImg.Height<>pbMainGraph.ClientHeight) or (MainGraphImg.Width<>pbMainGraph.ClientWidth)
 then
 begin
  MainGraphImg.Height:=pbMainGraph.ClientHeight;
  MainGraphImg.Width:=pbMainGraph.ClientWidth;
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
  LocalLimit:=LineCountNeeded;
  LocalMax:=LocalLimit*2;
  for i:=Start to Stop do
   if (Stats[i].DLC>LocalMax) and (Stats[i].HasData) then
   LocalMax:=Stats[i].DLC;
  s:=s+'DLC: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=clBlue;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].DLC/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
    MainCanvas.Pen.Mode:=pmNot;
    y:=Trunc(ht-ht*(LocalLimit/LocalMax));
    MainCanvas.MoveTo(0,y);
    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);
    //end of main graph

   LocalLimit:=LineNumberChangeThreshold;
   LocalMax:=LocalLimit*2; //    LocalMax:=LineNumberChangeThreshold*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].DLC-Stats[i-1].DLC)>LocalMax) then LocalMax:=abs(Stats[i].DLC-Stats[i-1].DLC);
    
    s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=clBlue;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].DLC-Stats[i-1].DLC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].DLC-Stats[i-1].DLC)/(LocalMax*2)); x:=i-Start;
    if i=Start+1 then DiffCanvas.MoveTo(x,y)
    else DiffCanvas.LineTo(x,y);
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
  for i:=Start to Stop do if (Stats[i].MED>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].MED;
    s:=s+'MED: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].MED/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
{    MainCanvas.Pen.Mode:=pmNot;
    y:=Trunc(ht-ht*(LineCountNeeded/LocalMax));
    MainCanvas.MoveTo(0,y);
    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);}
    //end of main graph

    LocalLimit:=SharpLinesAvgMinChange;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].MED-Stats[i-1].MED)>LocalMax) then LocalMax:=abs(Stats[i].MED-Stats[i-1].MED);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    R:=0; B:=0; G:=128;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MED-Stats[i-1].MED)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].MED-Stats[i-1].MED)/(LocalMax*2)); x:=i-Start;
    if i=Start+1 then DiffCanvas.MoveTo(x,y)
    else DiffCanvas.LineTo(x,y);
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
  for i:=Start to Stop do if (Stats[i].MBC>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].MBC;
  s:=s+'MBC: '+IntToStr(LocalMax);

  R:=64; B:=64; G:=64; MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].MBC/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
    //end of main graph

    LocalLimit:=MaxLineBlockCountDiff;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].MBC-Stats[i-1].MBC)>LocalMax) then LocalMax:=abs(Stats[i].MBC-Stats[i-1].MBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].MBC-Stats[i-1].MBC)/(LocalMax*2)); x:=i-Start;
    if i=Start+1 then DiffCanvas.MoveTo(x,y)
    else DiffCanvas.LineTo(x,y);
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
  for i:=Start to Stop do if (Stats[i].LBC>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].LBC;
   s:=s+'LBC: '+IntToStr(LocalMax);

  R:=255; B:=64; G:=64; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].LBC/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
    //end of main graph

    LocalLimit:=LBCLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].LBC-Stats[i-1].LBC)>LocalMax) then LocalMax:=abs(Stats[i].LBC-Stats[i-1].LBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].LBC-Stats[i-1].LBC)/(LocalMax*2)); x:=i-Start;
     if i=Start+1 then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
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
  for i:=Start to Stop do if (Stats[i].LMB>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].LMB;
   s:=s+'LMB: '+IntToStr(LocalMax);

  R:=255; B:=128; G:=128; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].LMB/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
    //end of main graph

    LocalLimit:=LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].LMB-Stats[i-1].LMB)>LocalMax) then LocalMax:=abs(Stats[i].LMB-Stats[i-1].LMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].LMB-Stats[i-1].LMB)/(LocalMax*2)); x:=i-Start;
     if i=Start+1 then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
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
  for i:=Start to Stop do if (Stats[i].RMB>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].RMB;
   s:=s+'RMB: '+IntToStr(LocalMax);

  R:=128; B:=128; G:=255; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].RMB/LocalMax)); x:=i-Start;
    if i=Start then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
   end;
    //end of main graph

    LocalLimit:=LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].RMB-Stats[i-1].RMB)>LocalMax) then LocalMax:=abs(Stats[i].RMB-Stats[i-1].RMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].RMB-Stats[i-1].RMB)/(LocalMax*2)); x:=i-Start;
     if i=Start+1 then DiffCanvas.MoveTo(x,y) else DiffCanvas.LineTo(x,y);
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
    x:=tbFrameSeek.Position-Start;
    DiffCanvas.MoveTo(x,0);
    DiffCanvas.LineTo(x,pbDiffGraph.ClientHeight);

    MainCanvas.Pen.Mode:=pmNot; //    x:=tbFrameSeek.Position-Start;
    MainCanvas.MoveTo(x,0);
    MainCanvas.LineTo(x,pbMainGraph.ClientHeight);

    if SelectingGraphPos and (NewGraphPos<>tbFrameSeek.Position) then
    begin
     x:=NewGraphPos-Start;
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

procedure TMainForm.cbDLCGraphClick(Sender: TObject);
begin
 pbMainGraphPaint(Sender);
end;

procedure TMainForm.SaveToRegistry;
var Reg:TRegistry;
begin
 Reg:=TRegistry.Create;
 Reg.RootKey:=HKEY_CURRENT_USER;
// if not(Reg.KeyExists('Software/AviSubDetector')) then Reg.CreateKey('Software/AviSubDetector');
 Reg.OpenKey('Software\AviSubDetector',true);
 Reg.WriteBool('SaveBitmaps',cbSaveFrameBMP.Checked);
 Reg.WriteBool('SaveSubs',cbAutoSaveSub.Checked);
 Reg.WriteBool('SaveStats',cbAutoSaveStat.Checked);
 Reg.WriteBool('LoadStats',cbAutoLoadStat.Checked);
 Reg.WriteBool('AutoClearScript',cbClearScriptOnAviOpen.Checked);
 Reg.WriteBool('AutoUsePreOCR',cbAutoSavePreOCR.Checked);
 Reg.WriteString('SaveBitmapsTo',edSaveBMPPath.Text);
 Reg.WriteString('SaveSubsTo',edSaveSubPath.Text);
 Reg.WriteString('SaveStatsTo',edSaveStatPath.Text);
 Reg.CloseKey;
 Reg.Free;
end;

procedure TMainForm.LoadFromRegistry;
var Reg:TRegistry;
begin
 Reg:=TRegistry.Create;
 Reg.RootKey:=HKEY_CURRENT_USER;
// if not(Reg.KeyExists('Software/AviSubDetector')) then Reg.CreateKey('Software/AviSubDetector');
 if Reg.OpenKeyReadOnly('Software\AviSubDetector') then
 begin
  if Reg.ValueExists('SaveBitmaps') then cbSaveFrameBMP.Checked:=Reg.ReadBool('SaveBitmaps');
  if Reg.ValueExists('SaveSubs') then cbAutoSaveSub.Checked:=Reg.ReadBool('SaveSubs');
  if Reg.ValueExists('SaveStats') then cbAutoSaveStat.Checked:=Reg.ReadBool('SaveStats');
  if Reg.ValueExists('LoadStats') then cbAutoLoadStat.Checked:=Reg.ReadBool('LoadStats');
  if Reg.ValueExists('SaveBitmapsTo') then edSaveBMPPath.Text:=Reg.ReadString('SaveBitmapsTo');
  if Reg.ValueExists('SaveSubsTo') then edSaveSubPath.Text:=Reg.ReadString('SaveSubsTo');
  if Reg.ValueExists('SaveStatsTo') then edSaveStatPath.Text:=Reg.ReadString('SaveStatsTo');
  if Reg.ValueExists('AutoUsePreOCR') then cbAutoSavePreOCR.Checked:=Reg.ReadBool('AutoUsePreOCR');  
  if Reg.ValueExists('AutoClearScript') then cbClearScriptOnAviOpen.Checked:=Reg.ReadBool('AutoClearScript');  
  Reg.CloseKey;
 end;
 Reg.Free;
end;

procedure TMainForm.SaveStats;
var i: integer; SL:TStringList;
begin
 begin
  try
   SL:=TStringList.Create;
   SL.Add('AVISubDetector v'+VersionString);
   for i:=0 to Length(Stats)-1 do
    if Stats[i].HasData then SL.Add(IntToStr(i)+':'+FrameStatToLine(Stats[i]));
   SL.SaveToFile(ChangeFileExt(FileName,'.ast'));
  finally
   SL.Free;
  end;
 end;
end;

procedure TMainForm.LoadStats;
var i, j, frm, max: integer; SL:TStringList;
    str:string;
begin
  try
   SL:=TStringList.Create;
   SL.LoadFromFile(FileName);
   SetLength(Stats,SL.Count);
   for i:=0 to Length(Stats)-1 do Stats[i].HasData:=false;
   for i:=0 to SL.Count-1 do
   begin
    str:=SL[i];
    for j:=1 to Length(str) do if str[j]=':' then break;
    if j<Length(str) then
    begin
     frm:=StrToIntDef(Copy(str,1,j-1),-1);
     if frm>=0 then
     begin
      if (Length(Stats)<frm) then SetLength(Stats,frm);
      Stats[frm]:=LineToFrameStat(str);
     end;
    end;
//    if Stats[i].HasData then SL.Add(IntToStr(i)+':'+FrameStatToLine(Stats[i]));
   end;
  finally
   SL.Free;
  end;

end;

procedure TMainForm.miSaveStatsClick(Sender: TObject);
begin
 if SaveStat.Execute then SaveStats(SaveStat.FileName);
end;

procedure TMainForm.miLoadStatsClick(Sender: TObject);
begin
 if OpenStat.Execute then LoadStats(OpenStat.FileName);
end;

function TMainForm.FrameStatToLine;
begin
 Result:='';
// if not(Compact) or not(FStat.DLC=0) then //always writing DLC 
 Result:=Result+'DLC='+IntToStr(FStat.DLC)+';';
 if not(Compact) or not(FStat.MED=0) then
 Result:=Result+'MED='+IntToStr(FStat.MED)+';';
 if not(Compact) or not(FStat.MBC=0) then
 Result:=Result+'MBC='+IntToStr(FStat.MBC)+';';
 if not(Compact) or not(FStat.LBC=0) then
 Result:=Result+'LBC='+IntToStr(FStat.LBC)+';';
 if not(Compact) or not(FStat.MaxSameLineCtr=0) then
 Result:=Result+'MBX='+IntToStr(FStat.MaxSameLineCtr)+';';
 if not(Compact) or not(FStat.LBCCount=0) then
 Result:=Result+'LBX='+IntToStr(FStat.LBCCount)+';';
 if not(Compact) or not(FStat.LMB=0) then
 Result:=Result+'LMB='+IntToStr(FStat.LMB)+';';
 if not(Compact) or not(FStat.RMB=0) then
 Result:=Result+'RMB='+IntToStr(FStat.RMB)+';';
end;

function TMainForm.DeltaFrameStatToLine;
begin
 Result:='';
{ Result:=Result+'DLC='+IntToStr(FStat.DLC)+';';
 Result:=Result+'MED='+IntToStr(FStat.MED)+';';
 Result:=Result+'MBC='+IntToStr(FStat.MBC)+';';
 Result:=Result+'LBC='+IntToStr(FStat.LBC)+';';
 Result:=Result+'MBX='+IntToStr(FStat.MaxSameLineCtr)+';';
 Result:=Result+'LBX='+IntToStr(FStat.LBCCount)+';';
 Result:=Result+'LMB='+IntToStr(FStat.LMB)+';';
 Result:=Result+'RMB='+IntToStr(FStat.RMB)+';';}
//   Result:='Frame '+IntToStr(FrameIndex);
{    if (IsTrackSharpLinesAvg) then s:=s+' MED='+IntToStr(Trunc(SharpLinesAvg*10))+' ['+IntToStr(Trunc(abs(SharpLinesAvgOlder-SharpLinesAvg)*10))+']';
    if (IsCheckLBC) then s:=s+' LBC='+IntToStr(LBCLines)+' ('+IntToStr(LBCCount)+')'+' ['+IntToStr(Trunc(abs(LBCLinesOlder-LBCLines)))+']';
    if (IsCheckLineNumber) then s:=s+' DLC='+IntToStr(SharpLines)+' ['+IntToStr(abs(SharpLinesOlder-SharpLines))+']';
    if (IsTrackLineMaxBlockCount) then s:=s+' MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal) + ' ['+ IntToStr(abs(MaxSameLineValOlder-MaxSameLineVal))+']';}
  if not(Compact) or (abs(PFStat.DLC-FStat.DLC)>0) then
   Result:=Result+'DLC='+IntToStr(FStat.DLC)+' ['+IntToStr(abs(PFStat.DLC-FStat.DLC))+'];';
  if not(Compact) or (abs(PFStat.MED-FStat.MED)>0) then
   Result:=Result+'MED='+IntToStr(FStat.MED)+' ['+IntToStr(abs(PFStat.MED-FStat.MED))+'];';
  if not(Compact) or (abs(PFStat.RMB-FStat.RMB)>0) then
   Result:=Result+'RMB='+IntToStr(FStat.RMB)+' ['+IntToStr(abs(PFStat.RMB-FStat.RMB))+'];';
  if not(Compact) or (abs(PFStat.LMB-FStat.LMB)>0) then
   Result:=Result+'LMB='+IntToStr(FStat.LMB)+' ['+IntToStr(abs(PFStat.LMB-FStat.LMB))+'];';
  if not(Compact) or (abs(PFStat.MaxSameLineCtr-FStat.MaxSameLineCtr)>0) then
   Result:=Result+'MBC='+IntToStr(FStat.MaxSameLineCtr)+'/'+IntToStr(FStat.MBC) + ' ['+IntToStr(abs(PFStat.MBC-FStat.MBC))+'];';
  if not(Compact) or (abs(PFStat.LBC-FStat.LBC)>0) then
   Result:=Result+'LBC='+IntToStr(FStat.LBC)+' ('+IntToStr(FStat.LBCCount)+')'+' ['+IntToStr(abs(PFStat.LBC-FStat.LBC))+'];';

end;

function TMainForm.LineToFrameStat;
var ps,i: integer; GotData:boolean;
begin
 GotData:=false;
 ps:=Pos('DLC=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.DLC:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.DLC:=0;
 ps:=Pos('LBC=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.LBC:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.LBC:=0;
 ps:=Pos('MED=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.MED:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.MED:=0;
 ps:=Pos('MBC=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.MBC:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.MBC:=0;

 ps:=Pos('MBX=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.MaxSameLineCtr:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.MaxSameLineCtr:=0;

 ps:=Pos('LBX=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.LBCCount:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.LBCCount:=0;

 ps:=Pos('LMB=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.LMB:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.LMB:=0;

 ps:=Pos('RMB=',str); if ps>0 then
 begin
  for i:=ps to Length(str) do if str[i]=';' then break;
  Result.RMB:=StrToIntDef(Copy(str,ps+4,i-(ps+4)),0);
  GotData:=true;
 end else Result.RMB:=0;

 Result.HasData:=GotData;

end;

procedure TMainForm.WM_ShellIcon;
var Ic: TIcon;
var NI: TNotifyIconData;
    str:string[64];
    s:array[0..63] of Char;
    i: integer;
    bm: TBitmap;
begin
//    procedure WM_ShellIcon(var Message: TMessage); message MYWM_NOTIFYICON;
 {   if (uMouseMsg == WM_LBUTTONDOWN) {
        switch (uID) {
            case IDI_MYBATTERYICON:               ShowBatteryStatus();                break;
            case IDI_MYPRINTERICON:                ShowJobStatus();                break;
            default:    break;       }
 if Message.LParam=WM_RBUTTONDOWN then
 begin
//  PopupMenu1.Popup(Message.WParamLo,Message.WParamHi);
 end;
 if Message.LParam=WM_LBUTTONDOWN then
 begin
//  Ic:=TIcon.Create; Ic.Height:=16; Ic.Width:=16;
//  Ic.
//  Ic.
//  Bm:=TBitmap.Create; Bm.Height:=16; Bm.Width:=16; Bm.PixelFormat:=pf24bit;
//  Ic.Assign(bm);
//  Ic.LoadFromResourceName(
  Ic:=TIcon.Create;
  Self.Visible:=not(Self.Visible);
  if Self.Visible then
  begin
   Self.BringToFront;
   Self.SetFocus;
   Application.Restore;
  end;
  NI.cbSize := SizeOf(TNotifyIconData);
  NI.Wnd := Handle;
  NI.uID := 0;//uID;
  NI.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NI.uCallbackMessage := MYWM_NOTIFYICON;
  ImageList.GetIcon(3,Ic);
  NI.hIcon := Ic.Handle; //Application.Icon.Handle; //Ic.Handle;
  str:='AviSubDetector: Frame: '+IntToStr(FrameIndex)+'/'+IntToStr(AviFile.MovieLength)+' of '+CurrentAVI;
  for i:=0 to Min(63,Length(str)) do
   if i>=Length(Str) then NI.szTip[i]:=#0
   else NI.szTip[i]:=Str[i+1];
// NI.szTip:=;
  Shell_NotifyIcon(NIM_MODIFY,@NI);
  if (self.Visible) then
  begin
   LastSeekFrame:=Max(0,tbFrameSeek.Position-1);
   tbFrameSeekChange(Self);
  end;
  Ic.Free;
//  Ic.Free; Bm.Free;
 end;
// Icon.Free;
// Icon.Resource
end;

procedure TMainForm.AddShellIcon;
var NI: TNotifyIconData; Ic:TIcon;
begin
 NI.cbSize := SizeOf(TNotifyIconData);
 NI.Wnd := Handle;
 NI.uID := 0;//uID;
 NI.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
 NI.uCallbackMessage := MYWM_NOTIFYICON;
 Ic:=TIcon.Create;

 ImageList.GetIcon(3, Ic);
 NI.hIcon := Ic.Handle; //Application.Icon.Handle;
 NI.szTip:='AviSubDetector (tray)';
 Shell_NotifyIcon(NIM_ADD,@NI);
 Ic.Free;
end;

procedure TMainForm.RemoveShellIcon;
var NI: TNotifyIconData;
begin
 NI.cbSize := SizeOf(TNotifyIconData);
 NI.Wnd := Handle;
 NI.uID := 0;//uID;
 NI.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
 NI.uCallbackMessage := MYWM_NOTIFYICON;
 NI.hIcon := Application.Icon.Handle;
 NI.szTip:='AviSubDetector (tray)';
 Shell_NotifyIcon(NIM_DELETE,@NI);
end;

procedure TMainForm.UpdateShellIcon;
var NI: TNotifyIconData; i:integer; Ic: TIcon;
begin
  NI.cbSize := SizeOf(TNotifyIconData);
  NI.Wnd := Handle;
  NI.uID := 0;//uID;
  NI.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NI.uCallbackMessage := MYWM_NOTIFYICON;
  Ic:=TIcon.Create;
  ImageList.GetIcon(3, Ic);
  NI.hIcon := Ic.Handle; //Application.Icon.Handle; //Ic.Handle;
  for i:=0 to 63 do
   if i>=Length(TipStr) then NI.szTip[i]:=#0
   else NI.szTip[i]:=TipStr[i+1];
  if (IsShowAvi) then
  begin Inc(CurrentIcon); if (CurrentIcon>29) then CurrentIcon:=0;
  if (CurrentIcon mod 10)=0 then
   begin
   ImageList.GetIcon(CurrentIcon div 10, Ic);
   if Ic.Handle>0 then NI.hIcon := Ic.Handle;
   Shell_NotifyIcon(NIM_MODIFY,@NI);
   end;
  end
  else Shell_NotifyIcon(NIM_MODIFY,@NI); 
//  str:='AviSubDetector: Frame: '+IntToStr(FrameIndex)+'/'+IntToStr(AviFile.MovieLength)+' of '+CurrentAVI;
  Ic.Free;
end;

procedure TMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  Self.Hide;
//  Self.WindowState:=wsNormal;
  ApplicationEvents.CancelDispatch;
//  Self.Visible:=false;
//  Application.
end;

procedure TMainForm.miUseStatsOnlyClick(Sender: TObject);
var i: integer;
begin
//
//  miUseStatsOnly.Checked:=not(miUseStatsOnly.Checked);
  miStartStatProcessing.Checked:=true;
  if (IsShowAVI) then exit;
//  if not(StopProcess) or not(PauseProcess) then
//  if not(AVIFileIsOpen) then MyAVIFileOpen(FFileName);
{  then begin
   AviFile.OpenAvi(FFileName);
   CurrentAVI:=FFileName;
   AVIFileIsOpen:=true;
   tbFrameSeek.Enabled:=true;
  end;}

  StopProcess:=false; PauseProcess:=false;
  OldImageIsSharp:=false;
  i:=StrToIntDef(edStartingFrame.Text,0);
  i:=Min(MovieLength-1,i);

  tbFrameSeek.Position:=i;
  FrameIndex:=i;
  if (FrameIndex<0) then exit;
  CurrentStatus:=ST_NO_SUBTITLE;

  ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
  ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
  While {(pbmi<>Nil) and} (StopProcess=false) and (PauseProcess=false)
        and (FrameIndex<MovieLength) do
  begin
  //  pbmi:=AVIStreamGetFrame(ob,i);
  //    AVIFile.GetFrame(i);
    
    CurrentFrameStats:=Stats[FrameIndex];
    if (FrameIndex>0) then PrevFrameStats:=Stats[FrameIndex-1]
                      else PrevFrameStats:=Stats[FrameIndex];
    ImageIsSharp:=IsFrameSubtitled(CurrentFrameStats);
    if (CurrentFrameStats.HasData) and (PrevFrameStats.HasData) then
    begin
     if (FrameIndex>0) then ImageIsChanged:=IsFrameChanged(PrevFrameStats,CurrentFrameStats)
     else ImageIsChanged:=false;

     if CurrentStatus=ST_DETECTED_NOW then CurrentStatus:=ST_DETECTED
     else if CurrentStatus=ST_CHANGED_NOW then CurrentStatus:=ST_CHANGED
     else if CurrentStatus=ST_NO_SUBTITLE_NOW then CurrentStatus:=ST_NO_SUBTITLE;

     if not(OldImageIsSharp) and (ImageIsSharp) then CurrentStatus:=ST_DETECTED_NOW
     else if (ImageIsChanged) and (ImageIsSharp) then CurrentStatus:=ST_CHANGED_NOW;
     if not(ImageIsSharp) and (OldImageIsSharp) then CurrentStatus:=ST_NO_SUBTITLE_NOW;

   if (CurrentStatus=ST_CHANGED_NOW) then
   begin
   if not(((FrameIndex-LastChangeFrame>MinimalChangeFrameDistance) or (FrameIndex-LastChangeFrame<1)))
      then CurrentStatus:=ST_SKIP;
//      else LastChangeFrame:=FrameIndex; //less restrictiong version of frameskip
     LastChangeFrame:=FrameIndex;
   end;
     
     UpdateStatus;
     tbFrameSeek.Position:=FrameIndex;
     Application.ProcessMessages;

   if sbManualProcessing.Down then
   begin
    if (CurrentStatus in [ST_DETECTED_NOW, ST_CHANGED_NOW]) or
    (cbAskOnEmpty.Checked and (CurrentStatus=ST_NO_SUBTITLE_NOW)) then AVIFile.GetFrame(FrameIndex);
    
    case CurrentStatus of
     ST_DETECTED_NOW: ManualProcessing(1);
     ST_CHANGED_NOW:  ManualProcessing(2); 
     ST_NO_SUBTITLE_NOW: if cbAskOnEmpty.Checked  then  ManualProcessing(0)
                         else if (IsEmptyDebugged) then
                         begin
                         AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'Empty Frame='+IntToStr(FrameIndex)+' S='+IntToStr(ImageSharpSum)+' MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal)+' DLC='+IntToStr(SharpLines));
                         if IsSaveBMP then SaveFrame(0);
                         end
                         else AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
     end;                    
   end;
//   If not(OldImageIsSharp) and (ImageIsSharp) then
   if sbAutomaticProcessing.Down then
   case CurrentStatus of
//   if CurrentStatus=ST_DETECTED then
   ST_DETECTED_NOW:   begin
                    AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),
                        '! Frame='+IntToStr(FrameIndex)+':'+FrameStatToLine(CurrentFrameStats));
                     if IsSaveBMP then SaveFrame(1);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_CHANGED_NOW:
                  begin
                    AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),
                        '* Frame='+IntToStr(FrameIndex)+':'+FrameStatToLine(CurrentFrameStats));
                     if IsSaveBMP then SaveFrame(1);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_NO_SUBTITLE_NOW:
//    if not(ImageIsSharp) and (OldImageIsSharp) then
     if (IsEmptyDebugged) then
     begin
      AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'Empty Frame='+IntToStr(FrameIndex)+' S='+IntToStr(ImageSharpSum)+' MBC='+IntToStr(MaxSameLineCtr)+'/'+IntToStr(MaxSameLineVal)+' DLC='+IntToStr(SharpLines));
      if IsSaveBMP then SaveFrame(0);
     end
     else AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
    end; //case end
  end //if HasData end
  else CurrentStatus:=ST_NO_DATA;

    OldImageIsSharp:=ImageIsSharp;
    inc(FrameIndex);
    tbFrameSeek.Position:=FrameIndex;
    UpdateStatus;
    Application.ProcessMessages;

  end;

  tbFrameSeek.Enabled:=true;
  
  if (StopProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);
  if (PauseProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);

 if not(StopProcess) and not(PauseProcess) then
 begin
  AddSubLineTimed(Trunc(1000*FrameIndex/(FrameRate/FrameScale)),'&nbsp;');
  CurrentStatus:=ST_FINISHED;
  PreOCRFrame.PerformPartialSave;
 end else
 if (StopProcess) then CurrentStatus:=ST_STOPPED
 else if (PauseProcess) then CurrentStatus:=ST_PAUSED;

 if (StopProcess) or not(FrameIndex<MovieLength) then
 begin
  StopProcess:=TRUE;
  //MyAVIFileClose;
  edStartingFrame.Text:='0';
 end;

 IsShowAVI:=false;
 UpdateStatus;
 Application.ProcessMessages;

 if (StopProcess) and not(cbAutoSaveSub.Checked) then sbSaveScript.Click;
  
end;

function TMainForm.IsFrameChanged;
begin
//  SharpLinesAvg:=SharpLinesAvg/SharpLines;
  Result:=false;
  //only need to check if image is sharp, which requires sharp lines
{   Stats[FrameIndex].DLC:=SharpLines;
   Stats[FrameIndex].MED:=Trunc(SharpLinesAvg*10);
   Stats[FrameIndex].MBC:=MaxSameLineVal;
   Stats[FrameIndex].LBC:=LBCLines;
   Stats[FrameIndex].MaxSameLineCtr:=MaxSameLineCtr;
   Stats[FrameIndex].LBCCount:=LBCCount;
   Stats[FrameIndex].HasData:=true;}
//  if (IsCheckLineNumber) then ImageIsChanged:=(ImageIsChanged) or (abs(SharpLinesOld-SharpLines)>LineNumberChangeThreshold);
//  if IsTrackLineMaxBlockCount then ImageIsChanged:=(ImageIsChanged) or (abs(MaxSameLineValOld-MaxSameLineVal)>MaxLineBlockCountDiff);
    if (IsCheckLineNumber) then Result:=(Result)
       or (abs(FrameNowStat.DLC-PrevFrameStat.DLC)>LineNumberChangeThreshold);//(abs(SharpLinesOld-SharpLines)>LineNumberChangeThreshold);
    if IsTrackLineMaxBlockCount then Result:=(Result)
       or (abs(FrameNowStat.MaxSameLineCtr-PrevFrameStat.MaxSameLineCtr)>MaxLineBlockCountDiff);    //(abs(MaxSameLineValOld-MaxSameLineVal)>MaxLineBlockCountDiff);
    if (IsCheckLBC) then begin Result:=(Result) or (AlternativeLBCCheck); end;

  if IsTrackSharpLinesAvg then Result:=(Result)
       or (abs(FrameNowStat.MED-PrevFrameStat.MED)>SharpLinesAvgMinChange);// ((abs(SharpLinesAvgOld-SharpLinesAvg)*10)>SharpLinesAvgMinChange);
  if IsCheckLRMB then Result:=(Result)
       or (abs(FrameNowStat.RMB-PrevFrameStat.RMB)>LRMBLimit);
  if IsCheckLRMB then Result:=(Result)
       or (abs(FrameNowStat.LMB-PrevFrameStat.LMB)>LRMBLimit);


{  if (IsCheckLineNumber) then Result:=(Result) or
  (abs(PrevFrameStat.DLC-FrameNowStat.DLC)>LineNumberChangeThreshold);
//  (abs(SharpLinesOld-SharpLines)>LineNumberChangeThreshold);

  if IsTrackLineMaxBlockCount then Result:=(Result) or
  (abs(PrevFrameStat.MBC-FrameNowStat.MBC)>MaxLineBlockCountDiff);

// if TrackLineMaxBlockCount then ImageIsChanged:=(ImageIsChanged) or (not(LinesChangedCtr<MaxLinesBlockCountChanged));
  if IsTrackSharpLinesAvg then
   Result:=(Result) or (abs(PrevFrameStat.MED-PrevFrameStat.MED)>SharpLinesAvgMinChange);}
end;

function TMainForm.IsFrameSubtitled;
begin
//
//  if (SharpLines>LineCountNeeded) then ImageIsSharp:=true else ImageIsSharp:=false;
 Result:=(FrameNowStat.DLC>LineCountNeeded);
 
end;

procedure TMainForm.pbMainGraphMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var NewPos, Start: integer;
begin
 if (ssLeft in Shift) then
 begin
  SelectingGraphPos:=true;
  Start:=Max(0,tbFrameSeek.Position-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  NewGraphPos:=Start + X;
  pbMainGraphPaint(Sender);
//  pbMainGraph.Invalidate;
 end;
end;

procedure TMainForm.pbMainGraphMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Start: integer;
begin
 if Button=mbLeft then
 begin
  Start:=Max(0,tbFrameSeek.Position-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  NewGraphPos:=Start + X;
  NewGraphPos:=Max(0,NewGraphPos);
  NewGraphPos:=Min(tbFrameSeek.Max,NewGraphPos);
  tbFrameSeek.Position:=NewGraphPos;
  SelectingGraphPos:=false;
 end;
end;

procedure TMainForm.pbMainGraphMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var Start: integer;
begin
 if (ssLeft in Shift) then
 begin
  SelectingGraphPos:=true;
  Start:=Max(0,tbFrameSeek.Position-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  NewGraphPos:=Start + X;
  pbMainGraphPaint(Sender);
//  pbMainGraph.Invalidate;
 end;

end;

procedure TMainForm.UpdateCurrentStats;
var s:string;
begin
   s:='Frame '+IntToStr(FrameIndex)+#13#10+StringReplace(DeltaFrameStatToLine(CurrentFrameStats,PrevFrameStats, false),';',#13#10,[rfReplaceAll]);
   stCurrentFrameStats.Caption:=s;
   stbMain.Panels[1].Text:=DeltaFrameStatToLine(CurrentFrameStats,PrevFrameStats, false); //StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
   stbMain.Panels[0].Text:='Frame '+IntToStr(FrameIndex);
end;

procedure TMainForm.miPreviewClick(Sender: TObject);
begin
{ if frmASDSettings.Last then miPreviewIsFloating.Checked:=true;}
 case frmASDSettings.LastPreviewState of
  2: miPreviewIsFloating.Checked:=true;
  1: miPreviewIsSettings.Checked:=true;
  3: miPreviewIsFixed.Checked:=true;
  4: miPreviewOff.Checked:=true;
 end;
 miPreviewFullFrame.Checked:=frmASDSettings.cbFullFrame.Checked;
 miPreviewCroppedFrame.Checked:=frmASDSettings.cbCropFrame.Checked;
 miPreviewDrop.Checked:=frmASDSettings.cbDiffFrame.Checked;
 miPreviewBlocks.Checked:=frmASDSettings.cbBlockFrame.Checked;
 miPreviewLines.Checked:=frmASDSettings.cbLineFrame.Checked; 
end;

procedure TMainForm.miPreviewLinesClick(Sender: TObject);
begin
 case ((Sender as TComponent).Tag and $FF) of
  1: miPreviewFullFrame.Checked:=not(miPreviewFullFrame.Checked);
  2: miPreviewCroppedFrame.Checked:=not(miPreviewCroppedFrame.Checked);
  3: miPreviewDrop.Checked:=not(miPreviewDrop.Checked);
  4: miPreviewBlocks.Checked:=not(miPreviewBlocks.Checked);
  5: miPreviewLines.Checked:=not(miPreviewLines.Checked);
 end; 
 frmASDSettings.cbFullFrame.Checked:=miPreviewFullFrame.Checked;
 frmASDSettings.cbCropFrame.Checked:=miPreviewCroppedFrame.Checked;
 frmASDSettings.cbDiffFrame.Checked:=miPreviewDrop.Checked;
 frmASDSettings.cbBlockFrame.Checked:=miPreviewBlocks.Checked;
 frmASDSettings.cbLineFrame.Checked:=miPreviewLines.Checked;

end;

procedure TMainForm.miCloseAVIClick(Sender: TObject);
begin
 if not(IsShowAvi) then MyAviFileClose;//AviFile.CloseAVI;
end;

procedure TMainForm.miAVIClick(Sender: TObject);
begin
//
 if IsShowAVI then
 begin
  miOpenAVI.Enabled:=false;
  miStartProcessing.Enabled:=false;
  miStartStatProcessing.Enabled:=false;
  miPauseProcessing.Enabled:=true;
  miStopProcessing.Enabled:=true;
  miCloseAVI.Enabled:=false;
 end
 else
 begin
  miOpenAVI.Enabled:=true;
  miStartProcessing.Enabled:=true;
  miStartStatProcessing.Enabled:=true;
  miPauseProcessing.Enabled:=true;
  miStopProcessing.Enabled:=true;
  miCloseAVI.Enabled:=(AviFile.pavi<>nil);
 end;
 miPauseProcessing.Checked:=PauseProcess;
 miStopProcessing.Checked:=StopProcess;
 if PauseProcess or StopProcess then miStartStatProcessing.Checked:=false;
 if PauseProcess or StopProcess then miStartProcessing.Checked:=false;

 tlbStartProcessing.Down:=IsShowAvi;
 tlbStartStatProcessing.Down:=(IsShowAvi);
 tlbPauseProcessing.Down:=miPauseProcessing.Checked;
 tlbStopProcessing.Down:=miStopProcessing.Checked;
 tlbCloseAVI.Enabled:=miCloseAvi.Enabled;

 tlbPauseProcessing.Enabled:=miPauseProcessing.Enabled;
 tlbStopProcessing.Enabled:=miStopProcessing.Enabled;
 tlbStartProcessing.Enabled:=miStartProcessing.Enabled;
 tlbStartStatProcessing.Enabled:=miStartStatProcessing.Enabled;

end;

procedure TMainForm.PerformAutoSave;
var s1: string; Script: TScript; SL:TStringList;
begin
      if (cbAutoSaveStat.Checked) then
      begin
         s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'.ast');
         //     s1:=ExtractFileName(cbAVIList.Items[i-1]);
         if not(edSaveStatPath.Text[length(edSaveStatPath.Text)]='\')
            then s1:=edSaveStatPath.Text+'\'+s1
            else s1:=edSaveStatPath.Text+s1;
       SaveStats(s1);
      end;
      if (cbAutoSaveSub.Checked) then
      begin
         Script:=TScript.Create;
         SL:=TStringList.Create;
        try
         SL.Text:=reSubData.Text;
         Script.ParseSAMI(SL,Now);
         s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'');
         if not(edSaveSubPath.Text[length(edSaveSubPath.Text)]='\')
            then s1:=edSaveSubPath.Text+'\'+s1
            else s1:=edSaveSubPath.Text+s1; 

         s1:=StringReplace(s1,'\\','\',[rfReplaceAll]);
         if not DirectoryExists(edSaveSubPath.Text) then
         if not CreateDir(edSaveSubPath.Text) then
         begin
          cbAutoSaveSub.Checked:=false;
          cbAutoSaveSubClick(cbAutoSaveSub);
         raise Exception.Create('Cannot create '+edSaveSubPath.Text);
         end;
         if cbSaveSub.ItemIndex=2 then
          begin
           s1:=s1+'.smi';
           Script.SaveAs(s1, SUB_SAMI);
          end;
         if cbSaveSub.ItemIndex=1 then
          begin
           s1:=s1+'.ssa';
           Script.SaveAs(s1, SUB_SSA);
          end;
         if cbSaveSub.ItemIndex=0 then
          begin
           s1:=s1+'.srt';
           Script.SaveAs(s1, SUB_SRT);
          end;
        finally
         SL.Free;
         Script.Free;
        end; 
//         reSubData.Text:='';
//         sbClearScriptClick(Self);
       end;
end;

initialization
  CoInitialize(nil);

finalization
  CoUnInitialize();



end.


