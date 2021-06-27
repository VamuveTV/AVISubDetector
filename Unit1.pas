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
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VFW, ExtCtrls, Ole2, Buttons, ComCtrls, FileCtrl, CheckLst, Math,
  ASDSettings, Grids, registry, Menus, ShellApi, AppEvnts, ImgList, ToolWin,
  PreOCR, ColorControl, GlyphForm, MyTypes1;

{type TRGB24Count = record
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
              end;}
type
     TDetectorStatus = ( ST_STOPPED, ST_PAUSED,
                          ST_NO_SUBTITLE, ST_NO_SUBTITLE_NOW,
                          ST_DETECTED, ST_DETECTED_NOW,
                          ST_CHANGED, ST_CHANGED_NOW,
                          ST_ERROR, ST_NO_DATA,
                          ST_SKIP, ST_SKIP_ONCE,
                          ST_FINISHED);
const VersionString = '0.6.0.5 Beta';

const MYWM_NOTIFYICON = 8932;

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
    cbAutoSaveSub: TCheckBox;
    cbNameFrameFirst: TCheckBox;
    dlgOpenAVI: TOpenDialog;
    SaveSub: TSaveDialog;
    OpenSub: TOpenDialog;
    FindDialog: TFindDialog;
    pnlCurrentAVI: TPanel;
    StatusPanel: TPanel;
    FramePanel: TPanel;
    sbManualProcessing: TSpeedButton;
    sbAutomaticProcessing: TSpeedButton;
    tbFrameSeek: TTrackBar;
    tbsSubtitle: TTabSheet;
    pnlSubtitleControl: TPanel;
    sbOpenSub: TSpeedButton;
    cbTimeOffset: TCheckBox;
    edTimeOffset: TEdit;
    sbSaveScript: TSpeedButton;
    cbSaveSub: TComboBox;
    sbClearScript: TSpeedButton;
    sbCallFind: TSpeedButton;
    cbShowLastLine: TCheckBox;
    cbFullFramePreview: TCheckBox;
    cbAskOnEmpty: TCheckBox;
    cbDebugEmptyData: TCheckBox;
    Panel1: TPanel;
    btAVIClear: TButton;
    btAddAVI: TButton;
    sbForceSub: TSpeedButton;
    sgSubData: TStringGrid;
    stbMain: TStatusBar;
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
    ImageList: TImageList;
    cbAutoSaveStat: TCheckBox;
    cbAutoLoadStat: TCheckBox;
    miPreview: TMenuItem;
    miPreviewIsFloating: TMenuItem;
    miPreviewIsFixed: TMenuItem;
    miPreviewIsSettings: TMenuItem;
    miPreviewOff: TMenuItem;
    miPreviewFullFrame: TMenuItem;
    miPreviewCroppedFrame: TMenuItem;
    miPreviewDrop: TMenuItem;
    miPreviewBlocks: TMenuItem;
    miPreviewLines: TMenuItem;
    SplitterX: TSplitter;
    scrlbPreview: TScrollBox;
    tlbNavigate: TToolBar;
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
    cbAutoSavePreOCR: TCheckBox;
    tlbProcess: TToolBar;
    tlbStartProcessing: TToolButton;
    tlbPauseProcessing: TToolButton;
    tlbStartStatProcessing: TToolButton;
    tlbStopProcessing: TToolButton;
    tlbOpenAVI: TToolButton;
    tlbCloseAVI: TToolButton;
    edSubPicMargin: TEdit;
    Label1: TLabel;
    cbSaveIndividualSubpictures: TCheckBox;
    cbAutoSaveSettings: TCheckBox;
    edProjectAutoSaveDirectory: TEdit;
    Label2: TLabel;
    btAutoSaveAll: TButton;
    cbAutoLoadSettings: TCheckBox;
    cbSaveProjectSubPics: TCheckBox;
    cbUseCropDimensions: TCheckBox;
    edMaxProjectBMPHeight: TEdit;
    Label3: TLabel;
    cbAutoLoadScript: TCheckBox;
    tbsColorControl: TTabSheet;
    ColorControlFrame: TColorControlFrame;
    miColorChange: TMenuItem;
//    frmASDSettings: TASDSettingsFrame;
    cbAutoSubs: TComboBox;
    Label4: TLabel;
    cbSaveIndividualPostSubpictures: TCheckBox;
    cbPostMode: TComboBox;
    sbOCRProcessing: TSpeedButton;
    tlbRecent: TToolButton;
    ToolButton1: TToolButton;
    mbPreviewPosition: TMenuItem;
    miContent: TMenuItem;
    edStartingFrame: TEdit;
    sbGoTo: TSpeedButton;
    edGoTo: TEdit;
    sbShowPreview: TSpeedButton;
    RecentFilesPopup: TPopupMenu;
    RF1: TMenuItem;
    RF2: TMenuItem;
    RF3: TMenuItem;
    RF4: TMenuItem;
    RF5: TMenuItem;
    RF6: TMenuItem;
    RF7: TMenuItem;
    RF8: TMenuItem;
    RF9: TMenuItem;
    RF0: TMenuItem;
    cbMergeSimilar: TCheckBox;
    SaveLangFile: TSaveDialog;
    miLanguage: TMenuItem;
    miLoadLanguageFile: TMenuItem;
    miSaveLanguage: TMenuItem;
    OpenLangFile: TOpenDialog;
    cbFullLineSubPic: TCheckBox;
    cbAutoSaveSymbols: TCheckBox;
    cbAutoLoadSymbols: TCheckBox;
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
//    procedure cbDLCGraphClick(Sender: TObject);
    procedure miSaveStatsClick(Sender: TObject);
    procedure miLoadStatsClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure miUseStatsOnlyClick(Sender: TObject);
{    procedure pbMainGraphPaint(Sender: TObject);
    procedure pbMainGraphMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainGraphMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainGraphMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);}
    procedure miPreviewClick(Sender: TObject);
    procedure miPreviewLinesClick(Sender: TObject);
    procedure miCloseAVIClick(Sender: TObject);
    procedure miAVIClick(Sender: TObject);
    procedure btAutoSaveAllClick(Sender: TObject);
    procedure edSubPicMarginChange(Sender: TObject);
    procedure miLoadSettingsClick(Sender: TObject);
    procedure miSaveSettingsClick(Sender: TObject);
    procedure miLoadSubClick(Sender: TObject);
    procedure miSaveSubClick(Sender: TObject);
    procedure sbGoToClick(Sender: TObject);
    procedure edMaxProjectBMPHeightChange(Sender: TObject);
    procedure tbsColorControlShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ColorControlFramebtAnalyzeClick(Sender: TObject);
    procedure sbOCRProcessingClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAVIListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RecentFilesPopupPopup(Sender: TObject);
    procedure RF9Click(Sender: TObject);
    procedure tlbRecentMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btSaveLangDataClick(Sender: TObject);
    procedure miLoadLanguageFileClick(Sender: TObject);
//    procedure sbCheckColorDominationClick(Sender: TObject);
//    procedure sbReduceColorsClick(Sender: TObject);
  public
//     FrameWidth, FrameHeight, FrameRate, FrameScale, MovieLength: integer;
//     AudioRate, AudioScale, AudioLength: integer;
     RecentFilesList: TStringList;
     FrameIndex:  INTEGER;
     LastChangeFrame, MinimalChangeFrameDistance: integer;
     Offs, {MaxDropOut,} BlockMinimum{, LineMinimum}: integer;
     {DropGradient,} StopProcess, PauseProcess, LineBlockNumDetection: boolean;
     LineCountNeeded: integer;
     LRMBLimit: integer; IsCheckLRMB: boolean;
     HasChecked:boolean;
     ShowImages:boolean;
     SharpLinesAvg{, SharpLinesAvgOld, SharpLinesAvgOlder}: extended;
     SharpLinesAvgMinChange: integer;
     IsTrackSharpLinesAvg: boolean;

     DropRed, DropGreen, DropBlue, DropSum: integer;

     IsDropRed, IsDropGreen, IsDropBlue, IsDropSum,
     CentralDomination, IsSaveBMP, IsEmptyDebugged: boolean;
     IsReplaceAll, IsPreprocess, IsPreKillStray: boolean;
     PreKillStrayRepeat: integer;
     IsTrackLineMaxBlockCount, IsCheckLineNumber: boolean;
     MinLineBlockNum, MaxSameLineVal, {MaxSameLineValOld, MaxSameLineValOlder,}
     MaxSameLineCtr: integer;

     {ImagePartial,} LineNumberChangeThreshold:integer;
     ImageCutTop, ImageCutBottom: integer;

     IgnorePeakDistance: integer;

     BlockSize: integer; //default is 16
     SubPicMargin: integer;
//     ImageCutTopPercent, ImageCutBottomPercent: integer;

     TimeOffset: integer;

{     ImageIsSharp, ImageIsChanged: boolean;
     OldImageIsSharp: boolean;}
     {ImageSaved,} MainGraphImg, DiffGraphImg: TBitmap;

     AVIFileIsOpen: boolean;
     CurrentAVI: string;
     LastSeekFrame: integer;
     SelectingGraphPos: boolean;
     NewGraphPos: integer;
     CurrentIcon: integer;
//     BaseBandRects: array of TRect;

     ImageSharpSum, ImageSharpSumOld: longint;
{     SharpLines, SharpLinesOld, SharpLinesOlder: longint;}
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
     BlockPattern:array[0..1024,0..4096] of integer; //BlockNum, LineNum BlockValue (sharpness)
{     MaxBlockCount, OldMaxBlockCount:integer;}
     IsTrackMaxBlockCount, IsShowAVI, IsStatMode: boolean;
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
{    LBCLinesOlder, LBCLines, LBCCount: integer; //LBC debugging values}

    BlockMap, DiffMap: TImageArray;

    Stats: array of TFrameStat;
    CurrentFrameStats: TFrameStat;
    PrevFrameStats: TFrameStat;
    CheckYDiff: boolean;
    AltLineCheck: boolean;

//    DomTypeReplaced: array[0..4] of boolean;
    PreColorScheme:array[0..4] of TRGB24;
    ColorTypeReplaceMode:array[0..4] of byte; //if 0, this color type remains unchanged (ignored)


     procedure ShowAvi(FFilename : string);
     function CheckLineBlock16SharpX(var PXLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
//     CheckYDiff
     function CheckLineBlock16SharpXY(var PXLine, PYLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
//     function CheckLineX(PXLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
//     procedure CloseVideo;
//     procedure OpenVideo(Filename:string);
//     procedure FrameToBitmap(Bitmap:TBitmap;pbmi:PBitmapInfoHeader);
//     function CheckLineBlock(Y, BlockSize, BlockNum:integer):longint;
     procedure SaveFrame(FrameType:integer);
{     procedure HighlightImage(Bitmap:TBitmap);}
//     function AlternativeLBCCheck:boolean;
     procedure UpdateStatus;
     procedure UpdateStatusFor(var Status:TDetectorStatus; FrameNum:integer);
     procedure MyAVIFileOpen(FFileName: string);
     procedure MyAVIFileClose;
     procedure ManualProcessing(FrameType: integer);
     procedure SaveToRegistry;
     procedure LoadFromRegistry;
     procedure AddShellIcon;
     procedure RemoveShellIcon;
     procedure UpdateShellIcon(TipStr: string);
     procedure SaveScriptToFile(Filename:string);
     procedure LoadScriptFromFile(Filename:string);
//     procedure PreprocessImage(Bmp:TBitmap);
     procedure PreprocessImage2(Bmp:TBitmap; X1,Y1,X2,Y2: integer);
     procedure ImageMap(Bmp,BmpMap:TBitmap; X1,Y1,X2,Y2: integer);
     procedure ActByStatus(Status: TDetectorStatus);
//     procedure ProcessFrameManualDetected;
//     procedure DataToPanelSettings;
    { Private declarations }
  public
    { Public declarations }
    BandRects: array of TRect;

//    procedure ProcessImage(Image:Pointer; var FrameStats: TFrameStat);
//    procedure ProcessImageX(Image:Pointer; var FrameStats: TFrameStat);
//    procedure AddSubLine(s:string);
    procedure AddSubLineTimed( Time:int64; s:string; Forced: boolean = false);
    function GetFrameTime( FrameNum: integer): int64;
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
    procedure ClearBandRects;
    procedure AddBandRect(x1,y1,x2,y2,margin: integer);
    procedure OptimizeBandRects;
    function GetSubTextSaveDir:string;
    function GetSubPictSaveDir:string;
    function GetSubStatSaveDir:string;
    function GetSettingSaveDir:string;
    function GetSymbolsSaveDir:string;
    procedure CheckPathCreate(Path:string);

    procedure SetPos(FrameNum:integer; SetCaption: boolean = true);
    procedure DominatorsUpdated;
    function IsMatchingColor(RX,GX,BX:byte;Dominator:TColorDominator):boolean;
  end;
//  function x: integer; external 'comdlg32.dll';
var
  MainForm: TMainForm;
implementation

{$R *.DFM}

uses UScript, {MyTypes1, {ImageForm0,} ManualProcessing, {Adjuster,} AviFile,
  StatsForm, StatThread;

function TMainForm.GetFrameTime;
begin
 Result:=Trunc(1000*Max(FrameNum - IgnorePeakDistance,0)/(FrameRate/FrameScale));
end;

function TMainForm.CheckLineBlock16SharpX;//(var PXLine:PByteArray; BlockX, BlockY:integer):integer;
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

{ if IsPreprocess then
 begin
  for i:=0 to BlockSize-1 do //  for X:=0 to W-1 do
  begin
   Pix:=(i+X)*3;
   R1:=PXLine[Pix+2];   G1:=PXLine[Pix+1];   B1:=PXLine[Pix];
   R2:=127; G2:=127; B2:=127; //default
   for j:=0 to Length(ColorDominators)-1 do
   begin
     Variance1:=Abs(R1-ColorDominators[i].R)+
                 Abs(G1-ColorDominators[i].G)+
                 Abs(B1-ColorDominators[i].B);
//     if Variance1<MainForm.DominatorDeviation then
     if Variance1<ColorDominators[i].Deviation then
     case ColorDominators[i].DomType of
      1: begin R2:=255; G2:=255; B2:=255; break; end;
      2: begin R2:=0; G2:=0; B2:=0; break; end;
//      else begin RX:=32; GX:=32; BX:=32; break; end;
      else begin R2:=127; G2:=127; B2:=127; break; end;
     end;
   end;
   if IsReplaceAll then
   begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
   else if R2<>32 then
    begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
    else begin PXLine[Pix+2]:=R1; PXLine[Pix+1]:=G1; PXLine[Pix]:=B1; end;
  end;
 end;}

 if not(IsDominatorMultiply or IsDominatorMaxSharpness or IsNonDominatorIgnore) then
 begin
  for i:=0 to BlockSize-1{15} do
  begin
   Pix:=(i+X)*3;
   Pix_offs:=(i+X+Offs)*3;
   ValR:=abs(PXLine[Pix+2]-PXLine[Pix_offs+2]);
   ValG:=abs(PXLine[Pix+1]-PXLine[Pix_offs+1]);
   ValB:=abs(PXLine[Pix]-PXLine[Pix_offs]);
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

function TMainForm.CheckLineBlock16SharpXY;//(var PXLine, PYLine:PByteArray; BlockX, BlockY:integer):integer;
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
   ValR:=abs(PXLine[Pix+2]-PXLine[Pix_offs+2]);
   ValG:=abs(PXLine[Pix+1]-PXLine[Pix_offs+1]);
   ValB:=abs(PXLine[Pix]-PXLine[Pix_offs]);
     if (IsDropRed) then begin if (ValR>DropRed) then SharpXRedTmp:=SharpXRedTmp+ValR end else SharpXRedTmp:=SharpXRedTmp+ValR;
     if (IsDropGreen) then begin if (ValG>DropGreen) then SharpXGreenTmp:=SharpXGreenTmp+ValG end else SharpXGreenTmp:=SharpXGreenTmp+ValG;
     if (IsDropBlue) then begin if (ValB>DropBlue) then SharpXBlueTmp:=SharpXBlueTmp+ValB end else SharpXBlueTmp:=SharpXBlueTmp+ValB;
   ValR:=abs(PXLine[Pix+2]-PYLine[Pix+2]);
   ValG:=abs(PXLine[Pix+1]-PYLine[Pix+1]);
   ValB:=abs(PXLine[Pix]-PYLine[Pix]);
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

   R1:=PXLine[Pix+2]; R2:=PYLine[Pix+2];
   G1:=PXLine[Pix+1]; G2:=PYLine[Pix+1];
   B1:=PXLine[Pix];   B2:=PYLine[Pix];

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
   ValB:=abs(B1-B2);   ValG:=abs(G1-G2);   ValR:=abs(R1-R2);
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
// Image:PByte;
 i:integer;
// Desti:TCanvas;

   // Shevin: Variables added
//   bitmap : TBitmap;
//   hexcode : string;
//   EMsg : string;
//   lasterr : integer;
//   SubIndex: integer;
//   ModalRes: integer;
  s:string;
//  ST: TStatThread;
begin
  if (IsShowAVI) then exit;
//  if not(StopProcess) or not(PauseProcess) then
  if not(AVIFileIsOpen) then MyAVIFileOpen(FFileName);

  i:=StrToIntDef(edStartingFrame.Text,0);
  i:=Min(MovieLength-1,i);

  SetPos(i);//  tbFrameSeek.Position:=i;
  
  pbmi:=AVIStreamGetFrame(ob,i);

      ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
      ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
  
  StopProcess:=false;  PauseProcess:=false;
  FrameIndex := i;
//  lbFrameCount.Caption:='/ '+IntToStr(MovieLength);
  FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex+1)+' / '+IntToStr(MovieLength);

{  ImageForm.RestoreImage;
  ImageForm.SaveImage;}
  IsShowAVI:=true; miAVIClick(Self);
   tbFrameSeek.Enabled:=false;
{  if (FrameIndex>0) then OldImageIsSharp:=IsFrameSubtitled(Stats[FrameIndex-1])
  else OldImageIsSharp:=false;}

  CurrentStatus:=ST_NO_SUBTITLE;

{  if pbmi.biBitCount=24 then {continue with process}
{   ST:=TStatThread.Create(false) else exit;
   ST.InitThread(i);}

  if pbmi<>nil then 
  if pbmi.biBitCount=24 then {continue with process}
  While (pbmi<>Nil) and (StopProcess=false) and (PauseProcess=false)
        and (FrameIndex<MovieLength) do
  begin
   ImageArr:=Pointer(Integer(pbmi)+pbmi^.biSize);
   if IsPreprocess then
   begin
    AviFile.FrameToBitmap(AviFile.ImagePreprocessed,pbmi);
    PreprocessImage2(AviFile.ImagePreprocessed,0,Min(FrameHeight-ImageCutBottom-1,ImageCutTop),
                                               FrameWidth-1,Max(FrameHeight-ImageCutBottom-1,ImageCutTop));
    ImageArr:=AviFile.ImagePreprocessed.ScanLine[ImagePreprocessed.Height-1];
   end;
  //doing image processing
   frmASDSettings.ProcessImage(ImageArr,CurrentFrameStats);
   if Length(Stats)>FrameIndex then Stats[FrameIndex]:=CurrentFrameStats;
{   i:=ST.CurrentFrame;
   while (FrameIndex<i) and (StopProcess=false) and (PauseProcess=false)
   do
   begin
//    i:=ST.CurrentFrame;
    FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex-IgnorePeakDistance+1)+' ['+IntToStr(i)+'] / '+IntToStr(MovieLength);
    Application.ProcessMessages;
    if (FrameIndex<i) then break;
   end;}

   FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex-IgnorePeakDistance+1)+' / '+IntToStr(MovieLength);
   Application.ProcessMessages;
//   if Length(Stats)>FrameIndex then Stats[FrameIndex]:=CurrentFrameStats;
   UpdateStatusFor(CurrentStatus,Max(FrameIndex-IgnorePeakDistance,0));

   SetPos(FrameIndex, false); //   tbFrameSeek.Position:=FrameIndex;
   UpdateStatus;
   Application.ProcessMessages;

   ActByStatus(CurrentStatus); //creates subs, saves bitmaps, asks for user input etc

  //getting next frame
//   FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex-IgnorePeakDistance+1)+' ['+IntToStr(ST.CurrentFrame)+'] / '+IntToStr(MovieLength);
   FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex-IgnorePeakDistance+1)+' / '+IntToStr(MovieLength);

   Application.ProcessMessages;
   INC (FrameIndex);
   i:=FrameIndex;


   pbmi:=AVIStreamGetFrame(ob,i);
   while (pbmi=nil) and (FrameIndex<MovieLength) do
   begin
    inc(i);
    pbmi:=AVIStreamGetFrame(ob,i);
    INC (FrameIndex);
    FramePanel.Caption:='Current Frame: '+IntToStr(FrameIndex-IgnorePeakDistance+1)+' / '+IntToStr(MovieLength);
    Application.ProcessMessages;
   end;
  end
  else ShowMessage('Only 24bit RGB Sources are supported so far. Try creating AviSynth script with ConvertToRGB24().');

//  ST.FreeOnTerminate:=true;
//  ST.Terminate;
  tbFrameSeek.Enabled:=true;

  if (StopProcess) or (PauseProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);
//  DrawDIBStop(han);
//  DrawDIBClose(han);

 if not(StopProcess) and not(PauseProcess) then
 begin
  AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
{  AddSubLine('<SYNC Start='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))+'ms><P>&nbsp;');}
  CurrentStatus:=ST_FINISHED;
  PreOCRFrame.PerformPartialSave;
 end else
 if (StopProcess) then CurrentStatus:=ST_STOPPED
 else if (PauseProcess) then CurrentStatus:=ST_PAUSED;

 if (CurrentStatus=ST_FINISHED) then
 begin
  StopProcess:=TRUE;
  edStartingFrame.Text:='0';
 end;

 IsShowAVI:=false;
 UpdateStatus;
 miAVIClick(Self);
 Application.ProcessMessages;

 if (StopProcess) and not(cbAutoSaveSub.Checked) then sbSaveScript.Click;


end;

{procedure TMainForm.ProcessImageX;
var i, j, k, SelSharp, Y, Pix, Pix_Offs, LineCtr, OldLineCtr, SameLineCtr, LinesChangedCtr, SharpXTmp:longint; LineMarked, BlockSharp, PrevBlockSharp: boolean;
    SharpBlockSum:longint; LastLineIsSharp: boolean;
    RightMostAvg, LeftMostAvg, LineRMB, LineLMB: integer;
    Image_Line,Image_Line2:PByteArray;
    BandLeft, BandRight, BandTop, BandBottom: integer;
    BandMargin: integer;
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

 BandLeft:=FrameWidth; BandRight:=0;
 BandTop:=FrameHeight; BandBottom:=0;
 BandMargin:=SubPicMargin;
 ClearBandRects;
 // for Y:=(FrameHeight div 3)*2 to FrameHeight-5 do
 // for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
 for Y:=ImageCutBottom to (FrameHeight-ImageCutTop)-1 do //checking lower part of image
 begin
  PrevBlockSharp:=false;  LineCtr:=0; SharpBlockSum:=0;
    Image_Line:=Pointer(Integer(pbmi)+pbmi^.biSize+Y*3*FrameWidth);
  LineRMB:=0; LineLMB:=(FrameWidth);
  // -------- LINE PARAMETERS CHECK -------------
  for i:=0 to (FrameWidth div BlockSize)-2 do
  BEGIN
    if CheckYDiff or ((Y-Offs)<0) then
    begin
     if (Y-Offs)>=0 then Image_Line2:=Pointer(Integer(pbmi)+pbmi^.biSize+(Y-Offs)*3*FrameWidth);
     if (Y-Offs)>=0 then SharpXTmp:=CheckLineBlock16SharpXY(Image_Line,Image_Line2,i*BlockSize,Y,Offs)
     else SharpXTmp:=CheckLineBlock16SharpX(Image_Line,i*BlockSize,Y,Offs);
    end
    else SharpXTmp:=CheckLineBlock16SharpX(Image_Line,i*BlockSize,Y,Offs);
    BlockPattern[i,Y]:=SharpXTmp; //storing for later use
    if not(SharpXTmp<=BlockMinimum) then
    begin
     BlockSharp:=true;
     if (PrevBlockSharp) then
     begin
      LineCtr:=LineCtr+1;
      if CentralDomination then
       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize*CenterWeight then
        Inc(LineCtr,abs((abs(i*BlockSize-(FrameWidth div 2))-BlockSize*CenterWeight) div BlockSize));
//      begin
//       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize*2 then LineCtr:=LineCtr+1;
//       if abs(i*BlockSize-(FrameWidth div 2))<BlockSize+1 then LineCtr:=LineCtr+1; //additional point for center subtitles (for small subs like No! and Yes!)
//      end;
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

   LineBlockCount[Y]:=LineCtr;
   if LineCtr>MinLineBlockNum then
   begin

    if (LastLineIsSharp) then
    begin //Inc(LineMostCtr); <=> SharpLines
     Inc(RightMostAvg,LineRMB); Inc(LeftMostAvg,LineLMB); end;

    //variation of line width change detector algorithm
    if (LastLineIsSharp) then
    if ((LineBlockCount[Y]-OldLineBlockCount[Y])>MaxLineBlockCountDiff) then Inc(LinesChangedCtr);
    OldLineBlockCount[Y]:=LineCtr;

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
      MaxSameLineVal:=LineCtr;
      MaxSameLineCtr:=SameLineCtr;
     end
    else if (LineCtr=MaxSameLineVal) then Inc(MaxSameLineCtr);
    LastLineIsSharp:=true;
   end
   else
   begin
    if (LastLineIsSharp) then
     begin //previous line is sharp
       AddBandRect(BandLeft*BlockSize,FrameHeight-BandTop,BandRight*BlockSize+BlockSize-1,FrameHeight-BandBottom, BandMargin);
       BandLeft:=FrameWidth; BandRight:=0;
       BandTop:=FrameHeight; BandBottom:=0;
     end;
    LastLineIsSharp:=false;
    OldLineBlockCount[Y]:=LineCtr;
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
       AddBandRect(BandLeft*BlockSize,FrameHeight-BandTop,BandRight*BlockSize+BlockSize-1,FrameHeight-BandBottom, BandMargin);
 if Length(BandRects)>0 then OptimizeBandRects;
//   CurrentFrameStats

   if (SharpLines>0) then SharpLinesAvg:=SharpLinesAvg/SharpLines else SharpLinesAvg:=0;

   FrameStats.DLC:=SharpLines;
   FrameStats.MED:=Trunc(SharpLinesAvg*10);
   FrameStats.MBC:=MaxSameLineVal;
   FrameStats.LBC:=LBCLines;
   FrameStats.BandCount:=Length(BandRects);
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

 if not(IsFrameSubtitled(FrameStats)) then
 begin
  MaxSameLineVal:=0;
  MaxSameLineCtr:=0;
  LBCCount:=0;
 end;
end;}


// Shevin: The initialization and finalization sections are required for
// use with Windows NT and Win 2000.
procedure TMainForm.sbStopClick(Sender: TObject);
begin
 StopProcess:=true;
// if not(IsShowAvi) then MyAviFileClose;//AviFile.CloseAVI;
 IsShowAVI:=false; //in case of errors
 miAVIClick(Sender);
// lbFileName.Caption:='No file opened';
// lbFileInfo.Caption:='No file opened';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

 IgnorePeakDistance:=0;
 cbAutoSubs.ItemIndex:=1;
 
 cbPostMode.ItemIndex:=0;
 DominatorDeviation:=30;

 RecentFilesList:=TStringList.Create;
// RecentFilesList.Sorted:=true;
 RecentFilesList.Duplicates:=dupIgnore;

// tbsStats.ManualFloat(Rect(0,0,300,300));

 PreColorScheme[0].R:=255;
 PreColorScheme[0].G:=255;
 PreColorScheme[0].B:=255;

 PreColorScheme[1].R:=0;
 PreColorScheme[1].R:=0;
 PreColorScheme[1].R:=0;

 PreColorScheme[2].R:=255;
 PreColorScheme[2].G:=255;
 PreColorScheme[2].B:=255;

 PreColorScheme[3].R:=255; //3 is "empty" (unused) color
 PreColorScheme[3].G:=255;
 PreColorScheme[3].B:=255;

 PreColorScheme[4].R:=255;
 PreColorScheme[4].G:=255;
 PreColorScheme[4].B:=255;

 ColorTypeReplaceMode[0]:=1;
 ColorTypeReplaceMode[1]:=1;
 ColorTypeReplaceMode[2]:=1;
 ColorTypeReplaceMode[3]:=1;
 ColorTypeReplaceMode[4]:=1; //replace with "predefined" color

// DropGradient:=true;
// MaxDropOut:=100; //both replaced with separate values
{ if ImageForm=nil then ImageForm:=TImageForm.Create(Self);}

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
// FrameWidth:=640;//ImageForm.Image1.Width;
// FrameHeight:=480;// ImageForm.Image1.Height;
 
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
 ColorDominators[0].RD:=30;
 ColorDominators[0].GD:=30;
 ColorDominators[0].BD:=30;

 BlockSize:=16;
 TimeOffset:=0;
 LRMBLimit:=20;

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

 PreKillStrayRepeat:=4;


// PreOCRFrame.Init;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// CloseVideo;
// if AviFile.pavi<>nil then AviFile.CloseAVI;
 GlyphForm1.ModalResult:=mrCancel;
 Application.ProcessMessages;
 if (AVIFileIsOpen) then
 begin
  PerformAutoSave;
  MyAVIFileClose;
 end;
//  if not(CurrentAVI='')
 SaveToRegistry;
{ ImageSaved.Free;}
 try
 if DiffGraphImg<>nil then begin DiffGraphImg.Free; DiffGraphImg:=nil; end;
 MainGraphImg.Free;
 DrawDIBClose(han);
 SetLength(ColorDominators,0);
 SetLength(Stats,0);
 frmASDSettings.FormDestroy(Self);
 PreOCRFrame.FormDestroy;
 RemoveShellIcon;
 SetLength(BandRects,0);
 RecentFilesList.Free;
 except
 end;
{ if ImageForm<>nil then ImageForm.Free;}

end;



{procedure TMainForm.FrameToBitmap;
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
 }
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
//var SL:TStringList; Script:TScript; s1:string; i:integer;
begin
//
 if sgSubData.RowCount>2 then
 if SaveSub.Execute then SaveScriptToFile(SaveSub.Filename);
{ begin
 Script:=TScript.Create;
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
 end;}
end;

procedure TMainForm.sbClearScriptClick(Sender: TObject);
begin
// reSubData.Text:='';
 if not sbAutomaticProcessing.Down then
 if MessageDlg('Clear Script?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 sgSubData.RowCount:=2;
 sgSubData.Rows[sgSubData.RowCount-1].Clear;

{ sgSubData.Cells[0,sgSubData.RowCount-1]:='';
 sgSubData.Cells[1,sgSubData.RowCount-1]:='';
 sgSubData.Cells[2,sgSubData.RowCount-1]:='';
 sgSubData.Cells[3,sgSubData.RowCount-1]:='';}
end;

procedure TMainForm.cbSaveFrameBMPClick(Sender: TObject);
begin
// edSaveBMPPath.Enabled:=cbSaveFrameBMP.Checked;
 IsSaveBMP:=cbSaveFrameBMP.Checked;
// cbSaveIndividualSubpictures.Enabled:=cbSaveFrameBMP.Checked;
// cbAutoSavePreOCR.Enabled:=cbSaveFrameBMP.Checked;
end;

procedure TMainForm.cbDebugEmptyDataClick(Sender: TObject);
begin
 IsEmptyDebugged:=(cbDebugEmptyData.Checked);
end;

procedure TMainForm.SaveFrame;
var s, s1:string; Bmpx: TBitmap;
    i: integer;
begin
//
 if (FrameType=0) and not(IsEmptyDebugged) then exit; //no bmp for empty frame
// if not(cbShowImage.Checked) then
// FrameToBitmap(AviFile.ImageSaved,pbmi); //otherwise frame is already there
 AviFile.GetFrame(FrameIndex);
{ if IsPreprocess then
 begin
    AviFile.FrameToBitmap(AviFile.ImagePreprocessed,pbmi);
    PreprocessImage2(AviFile.ImagePreprocessed,0,0,FrameWidth-1,FrameHeight-1);
//    ImageArr:=AviFile.ImagePreprocessed.ScanLine[ImagePreprocessed.Height-1];
 end;}
 if not DirectoryExists(GetSubPictSaveDir) then
    if not CreateDir(GetSubPictSaveDir) then
    begin
     cbSaveFrameBMP.Checked:=false;
     cbSaveFrameBMPClick(cbSaveFrameBMP);
    raise Exception.Create('Cannot create '+GetSubPictSaveDir);
    end;
 if (cbAutoSavePreOCR.Checked) then
 begin
  if (IsStatMode) then frmASDSettings.ProcessImage(Pointer(Integer(pbmi)+pbmi^.biSize),CurrentFrameStats); //getframe already done
  Bmpx:=TBitmap.Create; Bmpx.Height:=abs(FrameHeight-ImageCutTop-ImageCutBottom);
// ImageCutBottom to (FrameHeight-ImageCutTop)-1
  Bmpx.Width:=FrameWidth;
{  Bmpx.Canvas.Pen.Mode:=pmCopy;
  Bmpx.Canvas.Pen.Color:=clWhite;
  Bmpx.Canvas.Brush.Color:=clWhite;
  Bmpx.Canvas.Brush.Style:=bsCross;}

  OptimizeBandRects;
//  if (Length(BandRects)=0) then ShowMessage('ZERO BandRects at frame '+IntToStr(FrameIndex)+'!');
  for i:=Length(BandRects) downto 1 do
  begin
    if not(cbUseCropDimensions.Checked) then
    begin
     Bmpx.Width:=BandRects[i-1].Right-BandRects[i-1].Left;
     Bmpx.Height:=BandRects[i-1].Bottom-BandRects[i-1].Top;
    end;
    if IsPreprocess then BitBlt(Bmpx.Canvas.Handle,0,0,BandRects[i-1].Right-BandRects[i-1].Left,BandRects[i-1].Bottom-BandRects[i-1].Top,AviFile.ImagePreprocessed.Canvas.Handle,BandRects[i-1].Left,BandRects[i-1].Top,SRCCOPY)
    else BitBlt(Bmpx.Canvas.Handle,0,0,BandRects[i-1].Right-BandRects[i-1].Left,BandRects[i-1].Bottom-BandRects[i-1].Top,AviFile.ImageSaved.Canvas.Handle,BandRects[i-1].Left,BandRects[i-1].Top,SRCCOPY);
//    BitBlt(Bmpx.Canvas.Handle,0,0,Bmpx.Width,Bmpx.Height,AviFile.ImageSaved.Canvas.Handle,BandRects[i-1].Left,BandRects[i-1].Top,SRCCOPY);
//    Bmpx.Canvas.Rectangle(Rect(BandRects[i-1].Left,BandRects[i-1].Top,BandRects[i-1].Right,BandRects[i-1].Bottom));
    if IsSaveBMP then s:=PreOCRFrame.AddSubPicture(Bmpx, FrameIndex, @BandRects[i-1]);
    if (sbOCRProcessing.Down) then
    begin
//     GlyphForm1.Visible:=true;
//     GlyphForm1.BringToFront;
     GlyphForm1.UpdateTimer.Enabled:=false;
     GlyphForm1.SetBitmap(BmpX);

//     if GlyphForm1.ShowModal=mrOk then
     s1:=Caption;
     Caption:=s1+ 'Waiting for OCR result - Press OK on OCR page if you use ''Pause'' there';

     if GlyphForm1.ProcessBitmap=mrOk then
     begin
      s:=GlyphForm1.stGlyphText.Text;
     end;
     Caption:=s1;
     AddSubLineTimed(GetFrameTime(FrameIndex),s,true);
    end;
    if (Length(BandRects)>0) then if (cbAutoSubs.ItemIndex=2) and (sbAutomaticProcessing.Down) then AddSubLineTimed(GetFrameTime(FrameIndex),s,true);
  end;
//  BitBlt(Bmpx.Canvas.Handle,0,0,FrameWidth,Bmpx.Height,AviFile.ImageSaved.Canvas.Handle,0,ImageCutTop,SRCCOPY);
//  PreOCRFrame.AddSubPicture(Bmpx, FrameIndex);
  Bmpx.Free;
 end
 else   //if not using PreOCR
 if DirectoryExists(GetSubPictSaveDir) then
 begin

 s:=GetSubPictSaveDir;
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
  s:=s+' Time='+IntToStr(GetFrameTime(FrameIndex))+'ms';
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

  s:=s+' Time='+IntToStr(GetFrameTime(FrameIndex))+'ms';
  s:=s+'.bmp';
 end;
  try
   ImageSaved.SaveToFile(s);
  except
   cbSaveFrameBMP.Checked:=false;
   cbSaveFrameBMPClick(cbSaveFrameBMP);
  end;
{                       'Time='+IntToStr(Trunc(1000*FrameIndex/(FrameRate/FrameScale)))
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
//var SL:TStringList; Script:TScript; s1:string;
begin
 IsReplaceAll:=frmASDSettings.cbColorDomReplaceAll.Checked;
 IsPreprocess:=frmASDSettings.cbPreprocess.Checked;

 if cbAVIList.Items.Count=0 then
 begin
  btAddAVIClick(Sender);
 end;
 HasChecked:=true;

{ btAVIClear.Enabled:=false;}
   if not(IsShowAVI) and not(IsStatMode) then
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
    BEGIN
{     if not(StopProcess) and not(PauseProcess) then OldImageIsSharp:=false;}

     miStartProcessing.Checked:=true;//     ShowAvi(OpenAVI.Files[i-1]);
//     if not(CurrentAVI='') and
     if (AVIFileIsOpen) and not(CurrentAVI=cbAVIList.Items[i-1]) then
     begin
         MyAVIFileClose; StopProcess:=false; PauseProcess:=false;
         edStartingFrame.Text:='0';
     end;
     CurrentAVI:=cbAVIList.Items[i-1];
//     MyAviFileOpen(cbAVIList.Items[i-1]);
     ShowAvi(cbAVIList.Items[i-1]);

     if (PauseProcess) then exit;
     IF (StopProcess) THEN
     BEGIN //if not paused then save result
      if (FrameIndex>=MovieLength) or (CurrentStatus=ST_FINISHED) then
      begin cbAVIList.Checked[i-1]:=false; cbAVIList.ItemIndex:=i-1; end;
       PerformAutoSave; if CurrentStatus<>ST_FINISHED then exit;
     END
//      cbAVIList.ItemIndex:=i+1;
     ELSE begin  {btAVIClear.Enabled:=true;} EXIT; end;
    END
//    ShowAvi(OpenAVI.FileName)
    else begin {btAVIClear.Enabled:=true;} exit; end;
   end;
end;

procedure TMainForm.cbAutoSaveSubClick(Sender: TObject);
begin
 //
// edSaveSubPath.Enabled:=cbAutoSaveSub.Checked;
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
{function TMainForm.AlternativeLBCCheck:boolean;
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
 //if (Alt<40) then
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

end;}


procedure TMainForm.sbOpenSubClick(Sender: TObject);
begin
 if OpenSub.Execute then LoadScriptFromFile(OpenSub.FileName);
end;

procedure TMainForm.LoadScriptFromFile;
var SL:TStringList; Script:TScript; s1:string;
    i:integer;
begin
 begin
 Script:=TScript.Create;
 SL:=TStringList.Create;
 try

 SL.LoadFromFile(FileName);
   if (UpperCase(ExtractFileExt(FileName))='.SSA') then Script.ParseSSA(SL,'SSA0', FileDateToDateTime(FileAge(FileName)));
   if (UpperCase(ExtractFileExt(FileName))='.SRT') then Script.ParseSRT(SL,'SRT0', FileDateToDateTime(FileAge(FileName)));
   if (UpperCase(ExtractFileExt(FileName))='.RT') then  Script.ParseRT(SL, 'RT0', FileDateToDateTime(FileAge(FileName)));
   if (UpperCase(ExtractFileExt(FileName))='.FSB') then Script.ParseFSB(SL{, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName))});
   if (UpperCase(ExtractFileExt(FileName))='.SMI') then Script.ParseSAMI(SL, FileDateToDateTime(FileAge(FileName)));
   if (UpperCase(ExtractFileExt(FileName))='.ZEG') then Script.ParseZEG(SL,'ZEG0', FileDateToDateTime(FileAge(FileName)));
   if (UpperCase(ExtractFileExt(FileName))='.JS') then  Script.ParseJS(SL, 'JS0', FileDateToDateTime(FileAge(FileName)));
   sbClearScriptClick(Self);
//   reSubData.Text:=Script.GetPlainSAMI;
   SL.Text:=Script.GetPlainSAMI;
   Script.Free;
   Script:=TScript.Create;
   Script.ParseSAMI(SL,FileDateToDateTime(FileAge(FileName)));
   for i:=0 to Script.Count-1 do
   begin
    if (Script._SI[i].Status=_Text) then
     AddSubLineTimed(Script._SI[i].Time,Script._SI[i].Line, true); 
    if (Script._SI[i].Status=_Clear) then
     AddSubLineTimed(Script._SI[i].Time,'&nbsp;', true); 

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
  ST_SKIP_ONCE: StatusPanel.Caption:='FRAME SKIPPED';
  ST_FINISHED: StatusPanel.Caption:='FINISHED';
 end;
 UpdateShellIcon('Frame: '+IntToStr(FrameIndex)+'/'+IntToStr(AviFile.MovieLength)+' of '+ExtractFileName(CurrentAVI));

end;

procedure TMainForm.MyAVIFileOpen(FFileName: string);
//var s:string;
//    principio,fin:integer;
//    microsperframe:integer;
var i,j, fps1, fps2: integer; s: string;
begin
  if AviFile.pavi<>nil then AviFile.CloseAVI;
  FrameIndex:=0;
   AviFile.OpenAvi(FFileName);
   CurrentAVI:=FFileName;

   RecentFilesList.Insert(0,FFileName);

   i:=0;
   while (i<RecentFilesList.Count) do
   begin
   j:=i+1;
   while (j<RecentFilesList.Count) do
   begin
     if RecentFilesList[i]=RecentFilesList[j] then RecentFilesList.Delete(j); 
     inc(j);
   end;
   inc(i);
   end;

//   RecentFilesList.Add(FFileName);

   AVIFileIsOpen:=true;
   tbFrameSeek.Enabled:=true;
   tbFrameSeek.Max:=AviFile.MovieLength-1;
   SetPos(0);//   tbFrameSeek.Position:=0;
   CurrentFrameStats.DLC:=0; {PrevFrameStats:=CurrentFrameStats;}
{   pbmi:=AVIStreamGetFrame(ob,0);}

   AviFile.GetFrame(0);
   if pbmi=nil then begin AviFile.GetFrame(1); if tbFrameSeek.Position=0 then tbFrameSeek.Position:=1; end;

   ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
   ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;

 try
   frmASDSettings.ForceUpdate;
 finally
 end;
{  lbFileInfo.Caption:=IntToStr(FrameWidth)+'x'+IntToStr(FrameHeight)+'x'+IntToStr(pbmi.biBitCount)
                       +' (FPS:'+FloatToStr(FrameRate/FrameScale)+')';
  lbFileName.Caption:=FFileName;
  lbFileName.Hint:=FFileName;}
  fps1:=Trunc(FrameRate/FrameScale);
  fps2:=Trunc(((FrameRate/FrameScale)-fps1)*1000);
  Caption:='AviSubDetector: Processing File "'+ExtractFileName(FFileName)+'" ['+
           IntToStr(FrameWidth)+'x'+IntToStr(FrameHeight)+'x'+IntToStr(pbmi.biBitCount)
                       +' (FPS:'+IntToStr(fps1)+'.'+IntToStr(fps2)+')]';
  FrameRateUpdate; //updating frame numbers in script
  SetLength(Stats,AviFile.MovieLength);
  for i:=0 to Length(Stats)-1 do Stats[i].HasData:=false;
  if cbAutoLoadStat.Checked then
  begin
         s:=ChangeFileExt(ExtractFileName(CurrentAvi),'.ast');
         s:=GetSubStatSaveDir+s; //         s:=s+'.ast';
       if FileExists(s) then LoadStats(s);
  end;
  if cbAutoLoadSettings.Checked then
  begin
         s:=ChangeFileExt(ExtractFileName(CurrentAvi),'.sdt');
         s:=GetSettingSaveDir+s;
       if FileExists(s) then
       begin
        frmASDSettings.LoadFromFile(s);

       end;
  end;
  if cbAutoLoadSymbols.Checked then
  begin
         s:=ChangeFileExt(ExtractFileName(CurrentAvi),'.sym');
         s:=GetSymbolsSaveDir+s; //         s:=s+'.ast';
       if FileExists(s) then GlyphForm1.LoadSymbolsFrom(s);
  end;

  if sbAutomaticProcessing.Down then //sbClearScriptClick(Self);
  if cbClearScriptOnAviOpen.Checked then sbClearScriptClick(Self);
  if cbAutoLoadScript.Checked then
  begin
   s:=ChangeFileExt(ExtractFileName(CurrentAvi),'.ssa');
   s:=GetSubTextSaveDir+s;
   if (FileExists(s)) then LoadScriptFromFile(s);
   s:=ChangeFileExt(s,'.smi');   if (FileExists(s)) then LoadScriptFromFile(s);
   s:=ChangeFileExt(s,'.srt');   if (FileExists(s)) then LoadScriptFromFile(s);
  end;
  PreOCRFrame.ClearData;
//  PreOCRFrame.LoadData;
  if cbAVIList.Items.IndexOf(FFileName)<0 then
//  if cbAVIList.Items.Count=0 then
  begin
    cbAVIList.Items.Insert(0,FFileName);
    cbAVIList.Checked[0]:=true;
  end;


  tbFrameSeekChange(Self);
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
//   NewPos:=reSubData.FindText(FindDialog.FindText,reSubData.SelStart+1,Length(reSubData.Text),SearchType);
{  else
  begin
   LastPos:=0; //not yet implemented
   while reScript1.FindText(FindDialog.FindText,LastPos,reScript1.SelStart
   NewPos:=reScript1.FindText(FindDialog.FindText,
  end;}
  if NewPos>=0 then
  begin
{    reSubData.SetFocus;
    reSubData.SelStart:=NewPos;
    reSubData.SelLength:=Length(FindDialog.FindText);}
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
 if not(Forced) and (sbAutomaticProcessing.Down)
 then {cbNoAutomaticSubs.Checked}
 begin
  if (cbAutoSubs.ItemIndex=0) then exit;
  if (cbAutoSubs.ItemIndex=2) and (s<>'&nbsp;') then exit;
  if (cbAutoSubs.ItemIndex=3) and (s<>'&nbsp;') then s:=s[1];
 end;

 str:='<SYNC Start='+IntToStr(Time)+'ms><P>'+s;
{ if cbShowLastLine.Checked then
 begin
  AC:=ActiveControl;
  if reSubData.CanFocus then reSubData.SetFocus;
  reSubData.Lines.Add(str);
  ActiveControl:=AC;
 end
 else  reSubData.Lines.Add(str);}
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
  Cells[3,RowCount-2]:=StringReplace(StatForm.stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
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
 miAVIClick(Sender);

end;

procedure TMainForm.tbFrameSeekChange(Sender: TObject);
begin
 if FrameIndex<>tbFrameSeek.Position then SetPos(tbFrameSeek.position);
{ if Self.Visible then
 begin
  FrameIndex:=tbFrameSeek.Position;
  if tbsSettings.Visible or frmASDSettings.pbFrame.Floating
    or scrlbPreview.Visible then
  begin
   if LastSeekFrame<>tbFrameSeek.Position then frmASDSettings.ForceUpdate;
   LastSeekFrame:=tbFrameSeek.Position;
  end;
  if tbsStats.Visible then
   begin
    pbMainGraphPaint(Sender);
   end;
   FramePanel.Caption:='Current Frame: '+IntToStr(tbFrameSeek.Position)+' / '+IntToStr(MovieLength);
   if Length(Stats)<=FrameIndex then exit;
   if (FrameIndex<Length(Stats)) then if Stats[FrameIndex].HasData then  UpdateCurrentStats;
 end;}
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
 AVIFile.GetFrame(FrameIndex, ImageSaved);
// FrameToBitmap(ImageSaved,pbmi);
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
 ManualProcessingForm.lbInfo.Caption:=StringReplace(StatForm.stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
 ManualProcessingForm.pbSubtitle.Height:=ManualProcessingForm.LocalBitmap.Height+2;
 ManualProcessingForm.pbSubtitle.Width:=FrameWidth;
 ManualProcessingForm.AutoSize:=false;
 ManualProcessingForm.ClientWidth:=FrameWidth;
 ManualProcessingForm.AutoSize:=true;

 ManualProcessingForm.lbInfo.Caption:=StringReplace(StatForm.stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
 ManualProcessingForm.ActiveControl:=ManualProcessingForm.SubMemoX;
 ManualProcessingForm.SubMemoX.SelectAll;
 ModalRes:=ManualProcessingForm.ShowModal;
     if (ModalRes<>mrRetry) then
     begin LastChangeFrame:=FrameIndex; end
     else CurrentStatus:=ST_SKIP_ONCE{ImageIsSharp:=false}; //skip to next "sharp" frame
     if ModalRes=mrOk then
     begin
      s:=StringReplace(ManualProcessingForm.SubText{SubMemo.Text},#13#10,'<BR>',[rfReplaceAll]);
      s:=StringReplace(s,#10,'<BR>',[rfReplaceAll]);
      s:=StringReplace(s,#13,'<BR>',[rfReplaceAll]);
      AddSubLineTimed(GetFrameTime(FrameIndex),s, true); //forced sub
      if IsSaveBMP then SaveFrame(FrameType);
     end;
     if ModalRes=mrIgnore then //write nothing, ignore, skip until subtitle disappearance or change
     if (cbAskOnEmpty.Checked) or ((FrameType)<>1) then //since it is possible that _empty_ position was marked with subtitle while still being "non-sharp"
     begin
      //no subtitle - force write 'end of subtitle' &nbsp;
      //      ImageIsSharp:=false;
      AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
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
   SetPos(   {tbFrameSeek.Position:=}StrToIntDef((Sender as TStringGrid).Cells[1,GC.Y],0));
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
 i:=AVIStreamNextKeyFrame(AviFile.pavis,FrameIndex{MainForm.tbFrameSeek.Position});
 if (i>0) and (i<AviFile.MovieLength) then SetPos(i);//tbFrameSeek.Position:=i;
end;

procedure TMainForm.sbGoToFrameClick(Sender: TObject);
var i: integer;
begin
 i:=StrToIntDef(edStartingFrame.Text,0);
 if (i<AviFile.MovieLength) then SetPos(i);//tbFrameSeek.Position:=i;
end;

procedure TMainForm.sbPrevKFClick(Sender: TObject);
begin
 if AviFile.pavi=nil then exit;
 if {MainForm.tbFrameSeek.Position}FrameIndex>0 then
{ tbFrameSeek.Position:=}
 SetPos(AVIStreamPrevKeyFrame(AviFile.pavis,FrameIndex{tbFrameSeek.Position}));
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

{procedure TMainForm.pbMainGraphPaint(Sender: TObject);
var i, start, stop, x, y, ht, ht2, LocalMax, LocalLimit: integer;
    MainCanvas, DiffCanvas: TCanvas;
    R,G,B: byte; s:string; First: boolean;
begin
 if Length(Stats)=0 then exit;
 Start:=Max(0,FrameIndex-(pbMainGraph.ClientWidth div 2));
 Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
 Start:=Max(0,Start);
// if (Start<0) then Sta
 Stop:=Max(pbMainGraph.ClientWidth,FrameIndex+(pbMainGraph.ClientWidth div 2));
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
  LocalLimit:=LineCountNeeded;
  LocalMax:=LocalLimit*2;
  for i:=Start to Stop do
   if (Stats[i].DLC>LocalMax) and (Stats[i].HasData) then
   LocalMax:=Stats[i].DLC;
  s:=s+'DLC: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=clBlue;
  First:=true; for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].DLC/LocalMax)); x:=i-Start;
     if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y); First:=false;
   end;
    MainCanvas.Pen.Mode:=pmNot;
    y:=Trunc(ht-ht*(LocalLimit/LocalMax));
    MainCanvas.MoveTo(0,y);
    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);
    //end of main graph

   LocalLimit:=LineNumberChangeThreshold;
   LocalMax:=LocalLimit*2; //    LocalMax:=LineNumberChangeThreshold*2;
    for i:=Start+1 to Stop do
     if (Stats[i].HasData) and (Stats[i-1].HasData)
      then if (abs(Stats[i].DLC-Stats[i-1].DLC)>LocalMax) then LocalMax:=abs(Stats[i].DLC-Stats[i-1].DLC);

    s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=clBlue;
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].DLC-Stats[i-1].DLC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].DLC-Stats[i-1].DLC)/(LocalMax*2)); x:=i-Start;
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
  for i:=Start to Stop do if (Stats[i].MED>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].MED;
    s:=s+'MED: '+IntToStr(LocalMax);

  MainCanvas.Pen.Mode:=pmCopy;
  MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  First:=true;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].MED/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y);
    First:=false;
   end;
//    MainCanvas.Pen.Mode:=pmNot;
//    y:=Trunc(ht-ht*(LineCountNeeded/LocalMax));
//    MainCanvas.MoveTo(0,y);
//    MainCanvas.LineTo(pbMainGraph.ClientWidth,y);
    //end of main graph

    LocalLimit:=SharpLinesAvgMinChange;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].MED-Stats[i-1].MED)>LocalMax) then LocalMax:=abs(Stats[i].MED-Stats[i-1].MED);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    R:=0; B:=0; G:=128;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MED-Stats[i-1].MED)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].MED-Stats[i-1].MED)/(LocalMax*2)); x:=i-Start;
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
  for i:=Start to Stop do if (Stats[i].MBC>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].MBC;
  s:=s+'MBC: '+IntToStr(LocalMax);

  R:=64; B:=64; G:=64; MainCanvas.Pen.Color:=(B+G*256+R*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].MBC/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y);
    First:=false;
   end;
    //end of main graph

    LocalLimit:=MaxLineBlockCountDiff;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].MBC-Stats[i-1].MBC)>LocalMax) then LocalMax:=abs(Stats[i].MBC-Stats[i-1].MBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;

    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(B+G*256+R*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
    y:=Trunc(ht2/2-ht2*(Stats[i].MBC-Stats[i-1].MBC)/(LocalMax*2)); x:=i-Start;
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
  for i:=Start to Stop do if (Stats[i].LBC>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].LBC;
   s:=s+'LBC: '+IntToStr(LocalMax);

  R:=255; B:=64; G:=64; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].LBC/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
     First:=false;
   end;
    //end of main graph

    LocalLimit:=LBCLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].LBC-Stats[i-1].LBC)>LocalMax) then LocalMax:=abs(Stats[i].LBC-Stats[i-1].LBC);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].LBC-Stats[i-1].LBC)/(LocalMax*2)); x:=i-Start;
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
  for i:=Start to Stop do if (Stats[i].LMB>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].LMB;
   s:=s+'LMB: '+IntToStr(LocalMax);

  R:=255; B:=128; G:=128; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].LMB/LocalMax)); x:=i-Start;
    if First then MainCanvas.MoveTo(x,y)
    else MainCanvas.LineTo(x,y);
    First:=false;
   end;
    //end of main graph

    LocalLimit:=LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].LMB-Stats[i-1].LMB)>LocalMax) then LocalMax:=abs(Stats[i].LMB-Stats[i-1].LMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].LMB-Stats[i-1].LMB)/(LocalMax*2)); x:=i-Start;
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
  for i:=Start to Stop do if (Stats[i].RMB>LocalMax) and (Stats[i].HasData) then LocalMax:=Stats[i].RMB;
   s:=s+'RMB: '+IntToStr(LocalMax);

  R:=128; B:=128; G:=255; MainCanvas.Pen.Color:=(R+G*256+B*256*256);
  MainCanvas.Pen.Mode:=pmCopy;
  First:=true;
  for i:=Start to Stop do
  if Stats[i].HasData then
   begin
    y:=Trunc(ht-ht*(Stats[i].RMB/LocalMax)); x:=i-Start;
     if First then MainCanvas.MoveTo(x,y) else MainCanvas.LineTo(x,y); First:=false;
   end;
    //end of main graph

    LocalLimit:=LRMBLimit;
    LocalMax:=LocalLimit*2;
    for i:=Start+1 to Stop do if (Stats[i].HasData) and (abs(Stats[i].RMB-Stats[i-1].RMB)>LocalMax) then LocalMax:=abs(Stats[i].RMB-Stats[i-1].RMB);
     s:=s+' / '+IntToStr(LocalMax)+#13#10;
    DiffCanvas.Pen.Mode:=pmCopy;
    DiffCanvas.Pen.Color:=(R+G*256+B*256*256);
    First:=true;
    for i:=Start+1 to Stop do
    if Stats[i].HasData then
    begin
//    y:=Trunc(ht2-ht2*(abs(Stats[i].MBC-Stats[i-1].MBC)/LocalMax)); x:=i-Start;
     y:=Trunc(ht2/2-ht2*(Stats[i].RMB-Stats[i-1].RMB)/(LocalMax*2)); x:=i-Start;
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
    x:=FrameIndex-Start;
    DiffCanvas.MoveTo(x,0);
    DiffCanvas.LineTo(x,pbDiffGraph.ClientHeight);

    MainCanvas.Pen.Mode:=pmNot; //    x:=tbFrameSeek.Position-Start;
    MainCanvas.MoveTo(x,0);
    MainCanvas.LineTo(x,pbMainGraph.ClientHeight);

    if SelectingGraphPos and (NewGraphPos<>FrameIndex) then
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
end;}

{procedure TMainForm.cbDLCGraphClick(Sender: TObject);
begin
 pbMainGraphPaint(Sender);
end;}

procedure TMainForm.SaveToRegistry;
var Reg:TRegistry;
begin
 Reg:=TRegistry.Create;
 Reg.RootKey:=HKEY_CURRENT_USER;
// if not(Reg.KeyExists('Software/AviSubDetector')) then Reg.CreateKey('Software/AviSubDetector');
 Reg.OpenKey('Software\AviSubDetector',true);
 Reg.WriteBool('SaveBitmaps',cbSaveFrameBMP.Checked);
 Reg.WriteBool('SaveSymbols',cbAutoSaveSymbols.Checked);
 Reg.WriteBool('SaveSubs',cbAutoSaveSub.Checked);
 Reg.WriteBool('SaveStats',cbAutoSaveStat.Checked);
 Reg.WriteBool('LoadStats',cbAutoLoadStat.Checked);
 Reg.WriteBool('AutoClearScript',cbClearScriptOnAviOpen.Checked);
 Reg.WriteBool('AutoUsePreOCR',cbAutoSavePreOCR.Checked);
 Reg.WriteInteger('AutomaticSubType',cbAutoSubs.ItemIndex);
// Reg.WriteBool('NoAutomaticSubs',cbNoAutomaticSubs.Checked);
 Reg.WriteBool('cbNameFrameFirst',cbNameFrameFirst.Checked);
 Reg.WriteBool('cbAutoSavePreOCR',cbAutoSavePreOCR.Checked);
 Reg.WriteBool('cbSaveIndividualSubpictures',cbSaveIndividualSubpictures.Checked);
 Reg.WriteBool('cbSaveIndividualPostSubpictures',cbSaveIndividualPostSubpictures.Checked);
 Reg.WriteBool('cbSaveProjectSubPics',cbSaveProjectSubPics.Checked);
 Reg.WriteBool('cbAutoSaveSettings',cbAutoSaveSettings.Checked);
 Reg.WriteBool('cbAutoLoadSettings',cbAutoLoadSettings.Checked);
 Reg.WriteBool('cbAutoLoadSymbols',cbAutoLoadSymbols.Checked);
 Reg.WriteBool('cbFullFramePreview',cbFullFramePreview.Checked);
 Reg.WriteBool('cbUseCropDimensions',cbUseCropDimensions.Checked);
 Reg.WriteBool('cbFullLineSubPic',cbFullLineSubPic.Checked);
 Reg.WriteBool('cbAutoLoadScript',cbAutoLoadScript.Checked);
 Reg.WriteInteger('edMaxProjectBMPHeight',StrToIntDef(Trim(edMaxProjectBMPHeight.Text),6000));
 Reg.WriteInteger('ScriptTypeUsed',cbSaveSub.ItemIndex);
 Reg.WriteInteger('PostMode',cbPostMode.ItemIndex);
{ Reg.WriteBool('',.Checked);}
 if sbManualProcessing.Down then  Reg.WriteInteger('ProcessMode',0)
 else if sbAutomaticProcessing.Down then  Reg.WriteInteger('ProcessMode',1)
 else if sbOCRProcessing.Down then Reg.WriteInteger('ProcessMode',2); 

  if RecentFilesList.Count>0 then Reg.WriteString('RecentFile0',RecentFilesList[0])
  else Reg.DeleteValue('RecentFile0');
  if RecentFilesList.Count>1 then Reg.WriteString('RecentFile1',RecentFilesList[1])
  else Reg.DeleteValue('RecentFile1');
  if RecentFilesList.Count>2 then Reg.WriteString('RecentFile2',RecentFilesList[2])
  else Reg.DeleteValue('RecentFile2');
  if RecentFilesList.Count>3 then Reg.WriteString('RecentFile3',RecentFilesList[3])
  else Reg.DeleteValue('RecentFile3');
  if RecentFilesList.Count>4 then Reg.WriteString('RecentFile4',RecentFilesList[4])
  else Reg.DeleteValue('RecentFile4');
  if RecentFilesList.Count>5 then Reg.WriteString('RecentFile5',RecentFilesList[5])
  else Reg.DeleteValue('RecentFile5');
  if RecentFilesList.Count>6 then Reg.WriteString('RecentFile6',RecentFilesList[6])
  else Reg.DeleteValue('RecentFile6');
  if RecentFilesList.Count>7 then Reg.WriteString('RecentFile7',RecentFilesList[7])
  else Reg.DeleteValue('RecentFile7');
  if RecentFilesList.Count>8 then Reg.WriteString('RecentFile8',RecentFilesList[8])
  else Reg.DeleteValue('RecentFile8');
  if RecentFilesList.Count>9 then Reg.WriteString('RecentFile9',RecentFilesList[9])
  else Reg.DeleteValue('RecentFile9');

 Reg.WriteString('SaveProjectTo',edProjectAutoSaveDirectory.Text);
 Reg.WriteInteger('SubPicMargin',StrToIntDef(edSubPicMargin.Text,16));
// Reg.WriteString('SaveBitmapsTo',edSaveBMPPath.Text);
// Reg.WriteString('SaveSubsTo',edSaveSubPath.Text);
// Reg.WriteString('SaveStatsTo',edSaveStatPath.Text);
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
  if Reg.ValueExists('SaveSymbols') then cbAutoSaveSymbols.Checked:=Reg.ReadBool('SaveSymbols');
  if Reg.ValueExists('SaveSubs') then cbAutoSaveSub.Checked:=Reg.ReadBool('SaveSubs');
  if Reg.ValueExists('SaveStats') then cbAutoSaveStat.Checked:=Reg.ReadBool('SaveStats');
  if Reg.ValueExists('LoadStats') then cbAutoLoadStat.Checked:=Reg.ReadBool('LoadStats');
  if Reg.ValueExists('SaveProjectTo') then   edProjectAutoSaveDirectory.Text:=Reg.ReadString('SaveProjectTo');
//  if Reg.ValueExists('SaveBitmapsTo') then edSaveBMPPath.Text:=Reg.ReadString('SaveBitmapsTo');
//  if Reg.ValueExists('NoAutomaticSubs') then cbNoAutomaticSubs.Checked:=Reg.ReadBool('NoAutomaticSubs');
  if Reg.ValueExists('AutomaticSubType') then cbAutoSubs.ItemIndex:=Reg.ReadInteger('AutomaticSubType') else cbAutoSubs.ItemIndex:=1;
  if cbAutoSubs.ItemIndex<0 then cbAutoSubs.ItemIndex:=1; 
//  if Reg.ValueExists('SaveSubsTo') then edSaveSubPath.Text:=Reg.ReadString('SaveSubsTo');
//  if Reg.ValueExists('SaveStatsTo') then edSaveStatPath.Text:=Reg.ReadString('SaveStatsTo');
  if Reg.ValueExists('AutoUsePreOCR') then cbAutoSavePreOCR.Checked:=Reg.ReadBool('AutoUsePreOCR');
  if Reg.ValueExists('AutoClearScript') then cbClearScriptOnAviOpen.Checked:=Reg.ReadBool('AutoClearScript');
  if Reg.ValueExists('cbNameFrameFirst') then cbNameFrameFirst.Checked:=Reg.ReadBool('cbNameFrameFirst');
  if Reg.ValueExists('cbAutoSavePreOCR') then cbAutoSavePreOCR.Checked:=Reg.ReadBool('cbAutoSavePreOCR');
  if Reg.ValueExists('cbSaveIndividualSubpictures') then cbSaveIndividualSubpictures.Checked:=Reg.ReadBool('cbSaveIndividualSubpictures');
  if Reg.ValueExists('cbSaveProjectSubPics') then cbSaveProjectSubPics.Checked:=Reg.ReadBool('cbSaveProjectSubPics');
  if Reg.ValueExists('cbAutoSaveSettings') then cbAutoSaveSettings.Checked:=Reg.ReadBool('cbAutoSaveSettings');
  if Reg.ValueExists('cbAutoLoadSettings') then cbAutoLoadSettings.Checked:=Reg.ReadBool('cbAutoLoadSettings');
  if Reg.ValueExists('cbAutoLoadSymbols') then cbAutoLoadSymbols.Checked:=Reg.ReadBool('cbAutoLoadSymbols');

  if Reg.ValueExists('cbFullFramePreview') then cbFullFramePreview.Checked:=Reg.ReadBool('cbFullFramePreview');
  if Reg.ValueExists('cbUseCropDimensions') then cbUseCropDimensions.Checked:=Reg.ReadBool('cbUseCropDimensions');
  if Reg.ValueExists('cbFullLineSubPic') then cbFullLineSubPic.Checked:=Reg.ReadBool('cbFullLineSubPic');

  if Reg.ValueExists('cbAutoLoadScript') then  cbAutoLoadScript.Checked:=Reg.ReadBool('cbAutoLoadScript');
  if Reg.ValueExists('ScriptTypeUsed') then  cbSaveSub.ItemIndex:=Reg.ReadInteger('ScriptTypeUsed');
//  if Reg.ValueExists('') then  :=Reg.Read('');
//   Reg.WriteInteger('ScriptTypeUsed',cbSaveSub.ItemIndex);
  if Reg.ValueExists('PostMode') then  cbPostMode.ItemIndex:=Reg.ReadInteger('PostMode');
  if Reg.ValueExists('cbSaveIndividualPostSubpictures') then cbSaveIndividualPostSubpictures.Checked:=Reg.ReadBool('cbSaveIndividualPostSubpictures');

  if Reg.ValueExists('ProcessMode') then
  begin
   case Reg.ReadInteger('ProcessMode') and $FF of
    0: sbManualProcessing.Down:=true;
    1: sbAutomaticProcessing.Down:=true;
    2: sbOCRProcessing.Down:=true;
   end;
  end;

  if Reg.ValueExists('SubPicMargin') then edSubPicMargin.Text:=IntToStr(Reg.ReadInteger('SubPicMargin'));
  if Reg.ValueExists('edMaxProjectBMPHeight') then
  begin
   edMaxProjectBMPHeight.Text:=IntToStr(Reg.ReadInteger('edMaxProjectBMPHeight'));
   PreOCRFrame.HeightLimit:=Reg.ReadInteger('edMaxProjectBMPHeight');
  end;
  if Reg.ValueExists('RecentFile0') then RecentFilesList.Add(Reg.ReadString('RecentFile0'));
  if Reg.ValueExists('RecentFile1') then RecentFilesList.Add(Reg.ReadString('RecentFile1'));
  if Reg.ValueExists('RecentFile2') then RecentFilesList.Add(Reg.ReadString('RecentFile2'));
  if Reg.ValueExists('RecentFile3') then RecentFilesList.Add(Reg.ReadString('RecentFile3'));
  if Reg.ValueExists('RecentFile4') then RecentFilesList.Add(Reg.ReadString('RecentFile4'));
  if Reg.ValueExists('RecentFile5') then RecentFilesList.Add(Reg.ReadString('RecentFile5'));
  if Reg.ValueExists('RecentFile6') then RecentFilesList.Add(Reg.ReadString('RecentFile6'));
  if Reg.ValueExists('RecentFile7') then RecentFilesList.Add(Reg.ReadString('RecentFile7'));
  if Reg.ValueExists('RecentFile8') then RecentFilesList.Add(Reg.ReadString('RecentFile8'));
  if Reg.ValueExists('RecentFile9') then RecentFilesList.Add(Reg.ReadString('RecentFile9'));

   SubPicMargin:=StrToIntDef(edSubPicMargin.Text,16);
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
  max:=0;
  try
   SL:=TStringList.Create;
   SL.LoadFromFile(FileName);

   for i:=0 to SL.Count-1 do
   begin
    str:=SL[i];
    for j:=1 to Length(str) do if str[j]=':' then break;
    if j<Length(str) then
    begin
     frm:=StrToIntDef(Copy(str,1,j-1),-1);
     if (frm>max) then max:=frm;
    end;
   end;   
//   SetLength(Stats,0);
   if Length(Stats)<max then SetLength(Stats,max+1{SL.Count});
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
      {if (Length(Stats)<frm) then SetLength(Stats,frm);}
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
 if not(PFStat.HasData and FStat.HasData) then begin Result:='Not enough data'; exit; end;
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
 if not(Compact) then
 begin
//DLC=0 [24] MED=0 [214] RMB=0 [464] LMB=0 [144] MBC=0/25 [0] LBC=0 (0) [0]
  Result:=Format('DLC=%.3d [%.3d];MED=%.3d [%.3d];RMB=%.3d [%.3d];LMB=%.3d [%.3d];MBC=%.3d/%.3d [%.3d];LBC=%.3d (%.3d) [%.3d];',
          [FStat.DLC, abs(PFStat.DLC-FStat.DLC),
           FStat.MED, abs(PFStat.MED-FStat.MED),
           FStat.RMB, abs(PFStat.RMB-FStat.RMB),
           FStat.LMB, abs(PFStat.LMB-FStat.LMB),
           FStat.MaxSameLineCtr,FStat.MBC,abs(PFStat.MBC-FStat.MBC),
           FStat.LBC, FStat.LBCCount,abs(PFStat.LBC-FStat.LBC)]); 
 end
 else
 begin
  if (abs(PFStat.DLC-FStat.DLC)>0) then
   Result:=Result+'DLC='+IntToStr(FStat.DLC)+' ['+IntToStr(abs(PFStat.DLC-FStat.DLC))+'];';
  if (abs(PFStat.MED-FStat.MED)>0) then
   Result:=Result+'MED='+IntToStr(FStat.MED)+' ['+IntToStr(abs(PFStat.MED-FStat.MED))+'];';
  if (abs(PFStat.RMB-FStat.RMB)>0) then
   Result:=Result+'RMB='+IntToStr(FStat.RMB)+' ['+IntToStr(abs(PFStat.RMB-FStat.RMB))+'];';
  if (abs(PFStat.LMB-FStat.LMB)>0) then
   Result:=Result+'LMB='+IntToStr(FStat.LMB)+' ['+IntToStr(abs(PFStat.LMB-FStat.LMB))+'];';
  if (abs(PFStat.MaxSameLineCtr-FStat.MaxSameLineCtr)>0) then
   Result:=Result+'MBC='+IntToStr(FStat.MaxSameLineCtr)+'/'+IntToStr(FStat.MBC) + ' ['+IntToStr(abs(PFStat.MBC-FStat.MBC))+'];';
  if (abs(PFStat.LBC-FStat.LBC)>0) then
   Result:=Result+'LBC='+IntToStr(FStat.LBC)+' ('+IntToStr(FStat.LBCCount)+')'+' ['+IntToStr(abs(PFStat.LBC-FStat.LBC))+'];';
 end;

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
//  Self.Visible:=not(Self.Visible);
  if Self.Visible then
  begin
{   Application.Minimize;}
   Hide;
  end
  else
  begin
   Show;

   Application.ProcessMessages;
   {Self.}BringToFront;
   Application.ProcessMessages;
   {Self.}SetFocus;
   Application.ProcessMessages;
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
  if ({self.}Visible) then
  begin
   LastSeekFrame:=Max(0,FrameIndex-1);
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
 IsReplaceAll:=frmASDSettings.cbColorDomReplaceAll.Checked;
 IsPreprocess:=frmASDSettings.cbPreprocess.Checked;
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
  i:=StrToIntDef(edStartingFrame.Text,0);
  i:=Min(MovieLength-1,i);



  SetPos(i);//  tbFrameSeek.Position:=i;  FrameIndex:=i;
  if (FrameIndex<0) then exit;
  CurrentStatus:=ST_NO_SUBTITLE;

//  OldImageIsSharp:=false;
{  if (FrameIndex>0) then OldImageIsSharp:=IsFrameSubtitled(Stats[FrameIndex-1])
  else OldImageIsSharp:=false;}


  miStartStatProcessing.Checked:=true;
  IsShowAVI:=false; IsStatMode:=true;
  miAVIClick(Sender);

  ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
  ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
  While {(pbmi<>Nil) and} (StopProcess=false) and (PauseProcess=false)
        and (FrameIndex<MovieLength) do
  begin
  //  pbmi:=AVIStreamGetFrame(ob,i);
  //    AVIFile.GetFrame(i);

    CurrentFrameStats:=Stats[FrameIndex];
    PrevFrameStats:=Stats[Max(0,FrameIndex-1)];
//    UpdateStatusFor(CurrentStatus,FrameIndex);
    UpdateStatusFor(CurrentStatus,Max(FrameIndex-IgnorePeakDistance,0));


    if (CurrentFrameStats.HasData) and (PrevFrameStats.HasData) then
    begin
//     UpdateStatusFor(CurrentStatus,FrameIndex);
    UpdateStatusFor(CurrentStatus,Max(FrameIndex-IgnorePeakDistance,0));

     UpdateStatus;
//     SetPos(FrameIndex);//     tbFrameSeek.Position:=FrameIndex;
     if (CurrentStatus=ST_CHANGED_NOW) then
      StatForm.stLastChangedFrame.Caption:='Last Changed '+StatForm.stCurrentFrameStats.Caption;
     Application.ProcessMessages;

     ActByStatus(CurrentStatus);

  end //if HasData end
  else CurrentStatus:=ST_NO_DATA;

{    OldImageIsSharp:=ImageIsSharp;}
    inc(FrameIndex);
    SetPos(FrameIndex);// tbFrameSeek.Position:=FrameIndex;
    UpdateStatus;
    Application.ProcessMessages;

  end;

  tbFrameSeek.Enabled:=true;
  
  if (StopProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);
  if (PauseProcess) then edStartingFrame.Text:=IntToStr(FrameIndex-1);

 if not(StopProcess) and not(PauseProcess) then
 begin
  AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
  CurrentStatus:=ST_FINISHED;
  PreOCRFrame.PerformPartialSave;
 end else
 if (StopProcess) then CurrentStatus:=ST_STOPPED
 else if (PauseProcess) then CurrentStatus:=ST_PAUSED;

 if (CurrentStatus=ST_FINISHED) then
 begin
  StopProcess:=TRUE;  //MyAVIFileClose;
  edStartingFrame.Text:='0';
 end;

{ if (StopProcess) or not(FrameIndex<MovieLength) then
 begin
  StopProcess:=TRUE;
  //MyAVIFileClose;
  edStartingFrame.Text:='0';
 end;}

 IsShowAVI:=false;
 IsStatMode:=false;
 UpdateStatus;
 miAVIClick(Self);
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
    if (IsCheckLBC) then Result:=(Result) or (abs(FrameNowStat.LBC-PrevFrameStat.LBC)>LBCLimit);
{    (AlternativeLBCCheck); end;}

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

{procedure TMainForm.pbMainGraphMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var NewPos, Start: integer;
begin
 if (ssLeft in Shift) then
 begin
  SelectingGraphPos:=true;
  Start:=Max(0,FrameIndex-(pbMainGraph.ClientWidth div 2));
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
  Start:=Max(0,FrameIndex-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  NewGraphPos:=Start + X;
  NewGraphPos:=Max(0,NewGraphPos);
  NewGraphPos:=Min(tbFrameSeek.Max,NewGraphPos);
  SetPos(NewGraphPos);//  tbFrameSeek.Position:=NewGraphPos;
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
  Start:=Max(0,FrameIndex-(pbMainGraph.ClientWidth div 2));
  Start:=Min(AviFile.MovieLength-(pbMainGraph.ClientWidth),Start);
  Start:=Max(0,Start);
  NewGraphPos:=Start + X;
  pbMainGraphPaint(Sender);
//  pbMainGraph.Invalidate;
 end;

end;}

procedure TMainForm.UpdateCurrentStats;
var s:string;
begin
{   if Length(Stats)<=FrameIndex then exit
   else
   s:='Frame '+IntToStr(FrameIndex)+#13#10+StringReplace(
      DeltaFrameStatToLine(Stats[FrameIndex],Stats[Max(0,FrameIndex-1)], false),
      ';',#13#10,[rfReplaceAll]);
   stCurrentFrameStats.Caption:=s;}
//   if (FrameIndex>MovieLength) then FrameIndex:=tbFrameSeek.Position;

   if (IsShowAvi) then
   begin
    stbMain.Panels[1].Text:=DeltaFrameStatToLine(Stats[FrameIndex],Stats[Max(0,FrameIndex-1)]{CurrentFrameStats,PrevFrameStats}, false); //StringReplace(stCurrentFrameStats.Caption,#13#10,' ',[rfReplaceAll]);
    s:='Frame '+IntToStr(FrameIndex)+#13#10+StringReplace(stbMain.Panels[1].Text,';',#13#10,[rfReplaceAll]);
    StatForm.stCurrentFrameStats.Caption:=s;
   end
   else if FrameIndex>0 then
        if FrameIndex<Length(Stats) then
        begin
         stbMain.Panels[1].Text:=DeltaFrameStatToLine(Stats[FrameIndex],Stats[Max(0,FrameIndex-1)], false);
         s:='Frame '+IntToStr(FrameIndex)+#13#10+StringReplace(
            stbMain.Panels[1].Text,
            ';',#13#10,[rfReplaceAll]);
            StatForm.stCurrentFrameStats.Caption:=s;
        end;
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
 miPreviewCroppedFrame.Checked:=frmASDSettings.cbCropFramePv.Checked;
 miPreviewDrop.Checked:=frmASDSettings.cbDiffFramePv.Checked;
 miPreviewBlocks.Checked:=frmASDSettings.cbBlockFramePv.Checked;
 miPreviewLines.Checked:=frmASDSettings.cbLineFramePv.Checked;
 miColorChange.Checked:=frmASDSettings.cbColorPv.Checked; 
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
 frmASDSettings.cbCropFramePv.Checked:=miPreviewCroppedFrame.Checked;
 frmASDSettings.cbDiffFramePv.Checked:=miPreviewDrop.Checked;
 frmASDSettings.cbBlockFramePv.Checked:=miPreviewBlocks.Checked;
 frmASDSettings.cbLineFramePv.Checked:=miPreviewLines.Checked;

end;

procedure TMainForm.miCloseAVIClick(Sender: TObject);
begin
 if not(IsShowAvi) then MyAviFileClose;//AviFile.CloseAVI;
 miAVIClick(Sender);
end;

procedure TMainForm.miAVIClick(Sender: TObject);
begin
//
{ if IsShowAVI then
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
 }
 if (IsShowAVI) or (IsStatMode) then
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
 tlbStartStatProcessing.Down:=(IsStatMode);
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
         s1:=GetSubStatSaveDir+s1;
         SaveStats(s1);
      end;

      if (cbAutoSaveSub.Checked) then
      begin
         s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'.');
         s1:=GetSubTextSaveDir+s1;
         SaveScriptToFile(s1);
      end;

      if (cbAutoSaveSettings.Checked) then
      begin
         s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'.sdt');
         s1:=GetSettingSaveDir+s1;
         frmASDSettings.SaveToFile(s1);
      end;

      if (cbSaveFrameBMP.Checked) then
      begin
{         s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'.sdt');
         s1:=GetSettingSaveDir+s1;
         frmASDSettings.SaveToFile(s1);}
         PreOCRFrame.PerformPartialSave;
      end;

      if (cbAutoSaveSymbols.Checked) then
      begin
        s1:=ChangeFileExt(ExtractFileName(CurrentAVI),'.sym');
        s1:=GetSymbolsSaveDir+s1;
        GlyphForm1.SaveSymbolsTo(s1);
      end;
      
end;

procedure TMainForm.ClearBandRects;
begin
 SetLength(BandRects,0);
end;

procedure TMainForm.AddBandRect;
var xx1,yy1,xx2,yy2: integer;
begin
 if (x1>x2) then exit; //impossible - means "miss"
// if (abs(y2-y1)>LineCountNeeded) then
// if (abs(y2-y1)<(FrameHeight-3)) then
 begin
  xx1:=min(x1,x2); xx2:=max(x1,x2);
  yy1:=min(y1,y2); yy2:=max(y1,y2);
  SetLength(BandRects,Length(BandRects)+1);
  BandRects[Length(BandRects)-1].Top:=max(yy1-margin,1);
  BandRects[Length(BandRects)-1].Bottom:=min(yy2+margin,FrameHeight-ImageCutBottom-2);
  if cbFullLineSubPic.Checked then
  begin
   BandRects[Length(BandRects)-1].Left:=0;
   BandRects[Length(BandRects)-1].Right:=FrameWidth;
  end
  else
  begin
   BandRects[Length(BandRects)-1].Left:=max(xx1-margin,1);
   BandRects[Length(BandRects)-1].Right:=min(xx2+margin,FrameWidth-2);
  end;
 end;
// else;
end;

procedure TMainForm.OptimizeBandRects;
var i, j: integer; x1,x2,y1,y2: integer;

procedure MergeBandRects(n1,n2: integer);
var nmerge, nremove, k: integer;
begin //removes second rect by merging it with first one
 nmerge:=min(n1,n2); nremove:=max(n1,n2);
 BandRects[nmerge].Left:=min(BandRects[n1].Left,BandRects[n2].Left);
 BandRects[nmerge].Right:=max(BandRects[n1].Right,BandRects[n2].Right);
 BandRects[nmerge].Top:=min(BandRects[n1].Top,BandRects[n2].Top);
 BandRects[nmerge].Bottom:=max(BandRects[n1].Bottom,BandRects[n2].Bottom);
 for k:=nremove to Length(BandRects)-2 do BandRects[k]:=BandRects[k+1];
 SetLength(BandRects,Length(BandRects)-1);
end;
begin
 if Length(BandRects)<2 then exit; //no optimization necessary - only one rect present
 i:=0; while (i<Length(BandRects)) do
 begin
  j:=i+1; while (j<Length(BandRects)) do
  begin
   if ((BandRects[i].Top>BandRects[j].Top) and (BandRects[i].Top<BandRects[j].Bottom))
   or ((BandRects[i].Bottom>BandRects[j].Top) and (BandRects[i].Bottom<BandRects[j].Bottom))
   then MergeBandRects(i,j)
   else Inc(j);
  end;
  Inc(i);
 end;
end;


function TMainForm.GetSubTextSaveDir:string;
begin
// CheckPath
 Result:=edProjectAutoSaveDirectory.Text+'\Text\';
 Result:=StringReplace(Result,'\\','\',[rfReplaceAll]);
 CheckPathCreate(Result);
end;
function TMainForm.GetSubPictSaveDir:string;
begin
 Result:=edProjectAutoSaveDirectory.Text+'\SubPic\';
 Result:=StringReplace(Result,'\\','\',[rfReplaceAll]);
 CheckPathCreate(Result);
end;
function TMainForm.GetSubStatSaveDir:string;
begin
 Result:=edProjectAutoSaveDirectory.Text+'\Stats\';
 Result:=StringReplace(Result,'\\','\',[rfReplaceAll]);
 CheckPathCreate(Result);
end;
function TMainForm.GetSettingSaveDir:string;
begin
 Result:=edProjectAutoSaveDirectory.Text+'\Set\';
 Result:=StringReplace(Result,'\\','\',[rfReplaceAll]);
 CheckPathCreate(Result);
end;

function TMainForm.GetSymbolsSaveDir:string;
begin
 Result:=edProjectAutoSaveDirectory.Text+'\Symbols\';
 Result:=StringReplace(Result,'\\','\',[rfReplaceAll]);
 CheckPathCreate(Result);
end;

procedure TMainForm.CheckPathCreate;
var i: integer; s:string;
begin
 for i:=1 to Length(Path)-1 do
 begin
  s:=s+Path[i]; if (Path[i+1]='\') then if not(DirectoryExists(s)) then CreateDir(s);
 end; 
end;

procedure TMainForm.SaveScriptToFile;
var Script:TScript; s1:string; i,j:integer;
begin
//
 if cbMergeSimilar.Checked then
 begin
  while(i<sgSubData.RowCount-1) do
  begin
   if sgSubData.Cells[2, i]=sgSubData.Cells[2, i+1] then
   begin
   for j:=i to sgSubData.RowCount-1 do sgSubData.Rows[j]:=sgSubData.Rows[j+1];
    sgSubData.RowCount:=sgSubData.RowCount-1;
   end
   else inc(i);
  end;
 end;
 Script:=TScript.Create;// Script.ParseSAMI(SL,Now);}
 for i:=1 to sgSubData.RowCount-1 do
 if StrToTimeMS(sgSubData.Cells[0, i],-1)>=0 then
 begin  Script.AddSimple(StrToTimeMS(sgSubData.Cells[0, i],0),-1,sgSubData.Cells[2, i]);  end;
 Script.CheckScript;
 if Script.Count<=0 then begin Script.Free; exit; end;
// s1:=ChangeFileExt(ExtractFileName(SaveSub.FileName),'');
 s1:=ChangeFileExt(FileName,'');
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

 Script.Free;
end;


procedure TMainForm.btAutoSaveAllClick(Sender: TObject);
begin
 PerformAutoSave;
end;

procedure TMainForm.edSubPicMarginChange(Sender: TObject);
begin
 SubPicMargin:=StrToIntDef(edSubPicMargin.Text,16);
end;

procedure TMainForm.miLoadSettingsClick(Sender: TObject);
begin
 frmASDSettings.btLoadSettingsClick(sender);
end;

procedure TMainForm.miSaveSettingsClick(Sender: TObject);
begin
 frmASDSettings.btSaveSettingsClick(sender);
end;

procedure TMainForm.miLoadSubClick(Sender: TObject);
begin
 sbOpenSubClick(Sender);
end;

procedure TMainForm.miSaveSubClick(Sender: TObject);
begin
 sbSaveScriptClick(Sender);
end;

procedure TMainForm.SetPos;
begin
 FrameIndex:=FrameNum;
 tbFrameSeek.Position:=FrameNum;
 if Self.Visible then
 begin
  if {frmASDSettings.Visible or}
    (pgMain.ActivePageIndex=3) or frmASDSettings.pbFrame.Floating
    or scrlbPreview.Visible then
  begin
   if LastSeekFrame<>FrameNum then frmASDSettings.ForceUpdate;
   LastSeekFrame:=FrameNum;
  end;
  if StatForm.Visible  then
   begin
    StatForm.pbMainGraphPaint(Self);
   end;
   if SetCaption then FramePanel.Caption:='Current Frame: '+IntToStr(FrameNum)+' / '+IntToStr(MovieLength);
   if (FrameIndex<0) then Exit;
   if Length(Stats)<=FrameIndex then exit
   else if Stats[FrameIndex].HasData then UpdateCurrentStats;
  if tbsColorControl.Visible then
  begin
//   ColorControlFrame.btAnalyzeClick(Self);
   ColorControlFrame.AnalyzeFrame;
  end;
 end;
// FrameNum;
end;

procedure TMainForm.sbGoToClick(Sender: TObject);
begin
 SetPos(StrToIntDef(edGoTo.Text,0));
end;

procedure TMainForm.edMaxProjectBMPHeightChange(Sender: TObject);
begin
 PreOCRFrame.HeightLimit:=StrToIntDef(Trim(edMaxProjectBMPHeight.Text),6000);
end;

{procedure TMainForm.PreprocessImage;
var j, X, Y, Pix, Variance1, Variance2: integer; R, G, B, R1, G1, B1, R2, G2, B2: byte;
    PXLine, PXC, PY, PXB: PByteArray; Y1, Y2, HT, WT: integer;
begin
//
// if IsPreprocess then
//- for Y:=ImageCutBottom to (FrameHeight-ImageCutTop)-1 do //checking lower part of image
// Y1:=FrameHeight-ImageCutBottom-1;
// Y2:=ImageCutTop;
 Y1:=Min(FrameHeight-ImageCutBottom-1,ImageCutTop);
 Y2:=Max(FrameHeight-ImageCutBottom-1,ImageCutTop);
 HT:=Bmp.Height; WT:=Bmp.Width;
 for Y:=Y1 to Y2 do
 begin
  PXLine:=Bmp.ScanLine[Y];
  for X:=0 to BMP.Width-1 do//to BlockSize-1 do //  for X:=0 to W-1 do
  begin
   Pix:=X*3;
   R1:=PXLine[Pix+2];
   G1:=PXLine[Pix+1];
   B1:=PXLine[Pix];
//   R2:=127; G2:=127; B2:=127; //default
//     if DomTypeReplaced[3] then     begin
   if (ColorTypeReplaceMode[CT_OTHER]>0) then
   begin
      R2:=PreColorScheme[CT_OTHER].R;
      G2:=PreColorScheme[CT_OTHER].G;
      B2:=PreColorScheme[CT_OTHER].B;
   end
   else begin R2:=R1; G2:=G1; B2:=B1; end; //not changed
   
   for j:=0 to Length(ColorDominators)-1 do
   if (ColorTypeReplaceMode[ColorDominators[j].DomType]>0) then
   begin
//      Variance1:=Abs(R1-ColorDominators[j].R)+Abs(G1-ColorDominators[j].G)+Abs(B1-ColorDominators[j].B);
//     if Variance1<MainForm.DominatorDeviation then
//     if Variance1<MainForm.ColorDominators[j].Deviation then
     if IsMatchingColor(R1,G1,B1,ColorDominators[j]) then
     begin
      if IsReplaceAll or (ColorDominators[j].DomType>0)
         //and DomTypeReplaced[ColorDominators[j].DomType] then
      then   
      begin
       R2:=PreColorScheme[ColorDominators[j].DomType].R;
       G2:=PreColorScheme[ColorDominators[j].DomType].G;
       B2:=PreColorScheme[ColorDominators[j].DomType].B;
      end
      else
      begin
       R2:=ColorDominators[j].R; //R1
       G2:=ColorDominators[j].G; //G1
       B2:=ColorDominators[j].B; //B1
      end;
      break;
     end;
//     else
   end;
//   if MainForm.IsReplaceAll then
   begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
{   R2:=127; G2:=127; B2:=127; //default
   for j:=0 to Length(ColorDominators)-1 do
   begin
     Variance1:=Abs(R1-ColorDominators[j].R)+
                 Abs(G1-ColorDominators[j].G)+
                 Abs(B1-ColorDominators[j].B);
//     if Variance1<MainForm.DominatorDeviation then
     if Variance1<ColorDominators[j].Deviation then
     case ColorDominators[j].DomType of
      1: begin R2:=255; G2:=255; B2:=255; break; end;
      2: begin R2:=0; G2:=0; B2:=0; break; end;
//      else begin RX:=32; GX:=32; BX:=32; break; end;
      else begin R2:=127; G2:=127; B2:=127; break; end;
     end;
   end;
   if IsReplaceAll then
   begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
   else if R2<>32 then
    begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
    else begin PXLine[Pix+2]:=R1; PXLine[Pix+1]:=G1; PXLine[Pix]:=B1; end;}
{  end;
 end;
 if IsPreKillStray then
  for j:=1 to PreKillStrayRepeat do
    for Y:=Y1 to Y2 do
    begin
     PXC:=Bmp.ScanLine[Y];
     if (Y>0) and (Y<HT-1) then
     begin PY:=Bmp.ScanLine[Y-1]; PXB:=Bmp.ScanLine[Y+1]; end;
     for X:=0 to WT-1 do
     begin
      if (PXC[X*3+2]=32) or (PXC[X*3+2]=127) then
      begin
       if (X>0) and (X<WT-1) then
       if (PXC[(X+1)*3+2]<>127) and (PXC[(X-1)*3+2]<>127) {and (PXC[(X+1)*3+2]<>PXC[(X-1)*3+2])}{ then
//         then begin PXC[X*3+2]:=PXC[(X+1)*3+2]; PXC[X*3+1]:=PXC[(X+1)*3+2]; PXC[X*3]:=PXC[(X+1)*3+2]; end;
{        begin
         if (PXC[(X+1)*3+2]=255) and (PXC[(X-1)*3+2]=255) then begin PXC[X*3+2]:=255; PXC[X*3+1]:=255; PXC[X*3]:=255; end
         else begin PXC[X*3+2]:=0; PXC[X*3+1]:=0; PXC[X*3]:=0; end; //actually it should be 0 if any of two surrounding is 0 and 255 otherwise
        end;
       if (Y>0) and (Y<HT-1) then
       if (PY[X*3+2]<>127) and (PXB[X*3+2]<>127) {and (PXB[X*3+2]<>PY[X*3+2])}{ then
{       begin
//         then begin PXC[X*3+2]:=PXB[X*3+2]; PXC[X*3+1]:=PXB[X*3+1]; PXC[X*3]:=PXB[X*3]; end;
         if (PY[X*3+2]=255) and (PXB[X*3+2]=255) then begin PXC[X*3+2]:=255; PXC[X*3+1]:=255; PXC[X*3]:=255; end
         else begin PXC[X*3+2]:=0; PXC[X*3+1]:=0; PXC[X*3]:=0; end; //it should be 0 if any of two surrounding is 0 and 255 otherwise
       end;
      end;
     end;
 end;
end;}

function TMainForm.IsMatchingColor(RX,GX,BX:byte;Dominator:TColorDominator):boolean;
begin
 Result:=(Abs(RX-Dominator.R)<Dominator.RD) and
         (Abs(GX-Dominator.G)<Dominator.GD) and
         (Abs(BX-Dominator.B)<Dominator.BD);
 //instead of older (sum of differences below common threshold) - now common threshold is ignored
end;

procedure TMainForm.PreprocessImage2;
var j, X, Y, Pix: integer; R, G, B, R1, G1, B1, R2, G2, B2: byte;
    PXLine, PXC, PY, PXB: PByteArray; HT, WT: integer;


begin //performing color replacement - for detection purposes only
// Y1:=Min(FrameHeight-ImageCutBottom-1,ImageCutTop);
// Y2:=Max(FrameHeight-ImageCutBottom-1,ImageCutTop);
 HT:=Bmp.Height; WT:=Bmp.Width;
 for Y:=Y1 to Y2 do
 begin
  PXLine:=Bmp.ScanLine[Y];
  for X:=X1 to X2{BMP.Width-1} do
  begin
   Pix:=X*3;
   R1:=PXLine[Pix+2];   G1:=PXLine[Pix+1];   B1:=PXLine[Pix];
   if (ColorTypeReplaceMode[CT_OTHER]>0) then
   begin
      R2:=PreColorScheme[CT_OTHER].R;
      G2:=PreColorScheme[CT_OTHER].G;
      B2:=PreColorScheme[CT_OTHER].B;
   end
   else begin R2:=R1; G2:=G1; B2:=B1; end; //not changed
   
   for j:=0 to Length(ColorDominators)-1 do
   if (IsMatchingColor(R1,G1,B1,ColorDominators[j])) then
   begin
     case ColorTypeReplaceMode[ColorDominators[j].DomType] of
     0: begin R2:=R1; G2:=G1; B2:=B1; end; //not replaced
     1: begin
        R2:=PreColorScheme[ColorDominators[j].DomType].R;
        G2:=PreColorScheme[ColorDominators[j].DomType].G;
        B2:=PreColorScheme[ColorDominators[j].DomType].B;
        end;
     2: begin R2:=ColorDominators[j].R; G2:=ColorDominators[j].G; B2:=ColorDominators[j].B; end;
     end; //end case
     break;
   end;
   PXLine[Pix+2]:=R2;
   PXLine[Pix+1]:=G2;
   PXLine[Pix]:=B2;
 end;
end;
end;

procedure TMainForm.ImageMap;
var j, X, Y, Pix: integer; R, G, B, R1, G1, B1, R2, G2, B2: byte;
    PXLine, PXC, PY, PXB: PByteArray; HT, WT: integer;

function IsMatchingColor(RX,GX,BX:byte;Dominator:TColorDominator):boolean;
begin
 Result:=(Abs(RX-Dominator.R)<Dominator.RD) and
         (Abs(GX-Dominator.G)<Dominator.GD) and
         (Abs(BX-Dominator.B)<Dominator.BD);
 //instead of older (sum of differences below common threshold) - now common threshold is ignored        
end;    

begin //performing color map creation - creates bitmap with "type" bytes for each pixel
// Y1:=Min(FrameHeight-ImageCutBottom-1,ImageCutTop);
// Y2:=Max(FrameHeight-ImageCutBottom-1,ImageCutTop);

 HT:=Bmp.Height; WT:=Bmp.Width;
 BmpMap.Width:=0;
 BmpMap.PixelFormat:=pf8bit;
 BmpMap.Width:=Abs(X1-X2+1);
 BmpMap.Height:=Abs(Y1-Y2+1);
 
 for Y:=Y1 to Y2 do
 begin
  PXLine:=Bmp.ScanLine[Y];
  PXC:=BmpMap.ScanLine[Y-Y1];
  for X:=X1 to X2{BMP.Width-1} do
  begin
   Pix:=X*3;
   R1:=PXLine[Pix+2];   G1:=PXLine[Pix+1];   B1:=PXLine[Pix];
   PXC[X-X1]:=CT_OTHER;
   for j:=0 to Length(ColorDominators)-1 do
   if (IsMatchingColor(R1,G1,B1,ColorDominators[j])) then
   begin
     PXC[X-X1]:=ColorDominators[j].DomType;
{     case ColorTypeReplaceMode[ColorDominators[j].DomType] of
     0: PXC[X-X1]:=CT_OTHER; //not replaced
     1,2: PXC[X-X1]:=ColorDominators[j].DomType;
     end; //end case}
     break;
   end;
 end;
end;
end;


procedure TMainForm.tbsColorControlShow(Sender: TObject);
begin
  ImageCutTop:=(StrToIntDef(frmASDSettings.edCutFromTop.Text,50)*FrameHeight) div 100;
  ImageCutBottom:=(StrToIntDef(frmASDSettings.edCutFromBottom.Text,0)*FrameHeight) div 100;
 ColorControlFrame.UpdateCurrentDominator;
 ColorControlFrame.AnalyzeFrame;
end;

procedure TMainForm.DominatorsUpdated;
begin
 if tbsColorControl.Visible then ColorControlFrame.UpdateCurrentDominator;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
 StatusPanel.Left:=ClientWidth-5-StatusPanel.Width;
 FramePanel.Left:=ClientWidth-5-FramePanel.Width;
 sbForceSub.Left:=StatusPanel.Left;
end;

procedure TMainForm.ActByStatus(Status: TDetectorStatus);
begin
//
   if sbManualProcessing.Down then
   begin
    if (Status in [ST_DETECTED_NOW, ST_CHANGED_NOW]) or
    (cbAskOnEmpty.Checked and (CurrentStatus=ST_NO_SUBTITLE_NOW)) then AVIFile.GetFrame(FrameIndex);

    case Status of
     ST_DETECTED_NOW: ManualProcessing(1);
     ST_CHANGED_NOW:  ManualProcessing(2);
     ST_NO_SUBTITLE_NOW: if cbAskOnEmpty.Checked  then  ManualProcessing(0)
                         else if (IsEmptyDebugged) then
                         begin
                         AddSubLineTimed(GetFrameTime(FrameIndex),'Empty Frame='+FrameStatToLine(CurrentFrameStats));
                         if IsSaveBMP then SaveFrame(0);
                         end
                         else AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
     end;
   end;
   if sbAutomaticProcessing.Down then
   case Status of
   ST_DETECTED_NOW:   begin
                    if (cbAutoSubs.ItemIndex=1) or (cbAutoSubs.ItemIndex=3) then
                    AddSubLineTimed(GetFrameTime(FrameIndex),
                        '! Frame='+IntToStr(FrameIndex)+':'+FrameStatToLine(CurrentFrameStats));
                     if IsSaveBMP then SaveFrame(1);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_CHANGED_NOW:
                  begin
                    if (cbAutoSubs.ItemIndex=1) or (cbAutoSubs.ItemIndex=3) then
                    AddSubLineTimed(GetFrameTime(FrameIndex),
                        '* Frame='+IntToStr(FrameIndex)+':'+FrameStatToLine(CurrentFrameStats));
                     if IsSaveBMP then SaveFrame(1);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_NO_SUBTITLE_NOW:
     if (IsEmptyDebugged) then
     begin
      if (cbAutoSubs.ItemIndex=1) or (cbAutoSubs.ItemIndex=3) then
      AddSubLineTimed(GetFrameTime(FrameIndex),'Empty Frame='+FrameStatToLine(CurrentFrameStats));
      if IsSaveBMP then SaveFrame(0);
     end
     else AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
    end; //case end
 if  sbOCRProcessing.Down then
   case Status of
   ST_DETECTED_NOW:   begin
                     SaveFrame(1);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_CHANGED_NOW:
                  begin
                     SaveFrame(2);
                     LastChangeFrame:=FrameIndex;
                  end;
   ST_NO_SUBTITLE_NOW:
     if (IsEmptyDebugged) then SaveFrame(0)
     else AddSubLineTimed(GetFrameTime(FrameIndex),'&nbsp;');
    end; //case end
end;

procedure TMainForm.UpdateStatusFor;//(var Status:TDetectorStatus; FrameNum:integer);
var OldImageIsSharp, ImageIsSharp, ImageIsChanged: boolean;
    i, Ctr, CtrX: integer;
begin
   if (FrameNum<1) then
   begin
    OldImageIsSharp:=FALSE;
    ImageIsChanged:=FALSE;
   end
   else
   begin
    OldImageIsSharp:=IsFrameSubtitled(Stats[FrameNum-1]);
    if IgnorePeakDistance>0 then
    begin
     CtrX:=0;
     for i:=1 to IgnorePeakDistance do if (FrameNum-1+i)<Length(Stats) then
      if IsFrameChanged(Stats[FrameNum-1],Stats[FrameNum-1+i]) then Inc(CtrX);
      ImageIsChanged:=(CtrX=IgnorePeakDistance);
    end else ImageIsChanged:=IsFrameChanged(Stats[FrameNum-1],Stats[FrameNum]); 
   end;
    if (IgnorePeakDistance>0) and (OldImageIsSharp) then
    begin
     CtrX:=0;
     for i:=1 to IgnorePeakDistance do if (FrameNum-1+i)<Length(Stats) then
      if IsFrameSubtitled(Stats[FrameNum-1+i]) then Inc(CtrX);
      ImageIsSharp:=(CtrX=IgnorePeakDistance);
    end else ImageIsSharp:=IsFrameSubtitled(Stats[FrameNum]);

     if Status=ST_DETECTED_NOW then Status:=ST_DETECTED
     else if Status=ST_CHANGED_NOW then Status:=ST_CHANGED
     else if Status=ST_NO_SUBTITLE_NOW then Status:=ST_NO_SUBTITLE;

     if (Status=ST_SKIP_ONCE) then
     begin
      if (ImageIsSharp) then Status:=ST_DETECTED_NOW
                        else Status:=ST_NO_SUBTITLE_NOW;
     end
     else
     if not(OldImageIsSharp) and (ImageIsSharp) then Status:=ST_DETECTED_NOW
     else if (ImageIsChanged) and (ImageIsSharp) then Status:=ST_CHANGED_NOW;
     if not(ImageIsSharp) and (OldImageIsSharp) then Status:=ST_NO_SUBTITLE_NOW;

   if (frmASDSettings.cbNoSingleFrame.Checked) then
   if (Status=ST_CHANGED_NOW) then
   if not(((FrameNum-LastChangeFrame>MinimalChangeFrameDistance) or (FrameNum-LastChangeFrame<1)))
      then Status:=ST_SKIP;
end;


procedure TMainForm.ColorControlFramebtAnalyzeClick(Sender: TObject);
begin
  ColorControlFrame.btAnalyzeClick(Sender);

end;

procedure TMainForm.sbOCRProcessingClick(Sender: TObject);
begin
 if sbOCRProcessing.Down then cbAutoSavePreOCR.Checked:=true;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 frmASDSettings.Init;
 frmASDSettings.sbCopyFromMainClick(Self);
 frmASDSettings.sbCopyToMainClick(Self);
 frmASDSettings.PanelSettingsToData(Self);
 
 ColorControlFrame.Init;
 if frmASDSettings.Floating then
 begin
  frmASDSettings.Align:=alClient;
  frmASDSettings.ManualDock(pgMain, nil, alTop);
  frmASDSettings.Visible:=true;
  pgMain.ActivePageIndex:=0;
 end;
 if StatForm.Floating then
 begin
  StatForm.Align:=alClient;
  StatForm.ManualDock(pgMain, nil, alTop);
  StatForm.Visible:=true;
  pgMain.ActivePageIndex:=0;
  StatForm.clbShowGraphs.Checked[0]:=true;
  StatForm.Show;
 end;
 if PreOCRFrame.Floating then
 begin
  PreOCRFrame.Align:=alClient;
  PreOCRFrame.ManualDock(pgMain, nil, alTop);
  PreOCRFrame.Visible:=true;
  pgMain.ActivePageIndex:=0;
 end;
 if GlyphForm1.Floating then
 begin
  GlyphForm1.Align:=alClient;
  GlyphForm1.ManualDock(pgMain, nil, alTop);
  GlyphForm1.Visible:=true;
  pgMain.ActivePageIndex:=0;
 end;

  LoadFromRegistry;
end;

procedure TMainForm.cbAVIListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin
 if Key=VK_DELETE then
 if MessageDlg('Remove file from list?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
 for i:=0 to cbAVIList.Items.Count-1 do
 if cbAVIList.Selected[i] then cbAVIList.Items.Delete(i);
end;

procedure TMainForm.RecentFilesPopupPopup(Sender: TObject);
begin
 if RecentFilesList.Count>0 then RF0.Caption:=RecentFilesList[0];
 if RecentFilesList.Count>1 then RF1.Caption:=RecentFilesList[1];
 if RecentFilesList.Count>2 then RF2.Caption:=RecentFilesList[2];
 if RecentFilesList.Count>3 then RF3.Caption:=RecentFilesList[3];
 if RecentFilesList.Count>4 then RF4.Caption:=RecentFilesList[4];
 if RecentFilesList.Count>5 then RF5.Caption:=RecentFilesList[5];
 if RecentFilesList.Count>6 then RF6.Caption:=RecentFilesList[6];
 if RecentFilesList.Count>7 then RF7.Caption:=RecentFilesList[7];
 if RecentFilesList.Count>8 then RF8.Caption:=RecentFilesList[8];
 if RecentFilesList.Count>9 then RF9.Caption:=RecentFilesList[9];
 RF0.Visible:=(RecentFilesList.Count>0);
 RF1.Visible:=(RecentFilesList.Count>1);
 RF2.Visible:=(RecentFilesList.Count>2);
 RF3.Visible:=(RecentFilesList.Count>3);
 RF4.Visible:=(RecentFilesList.Count>4);
 RF5.Visible:=(RecentFilesList.Count>5);
 RF6.Visible:=(RecentFilesList.Count>6);
 RF7.Visible:=(RecentFilesList.Count>7);
 RF8.Visible:=(RecentFilesList.Count>8);
 RF9.Visible:=(RecentFilesList.Count>9);
end;

procedure TMainForm.RF9Click(Sender: TObject);
begin
 MyAVIFileOpen((Sender as TMenuItem).Caption);
 miAVIClick(Sender);
end;

procedure TMainForm.tlbRecentMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 (Sender as TToolButton).Down:=false;
end;

procedure TMainForm.btSaveLangDataClick(Sender: TObject);
var SL:TStringList; i,j:integer; s, st:string;

procedure ProcessSubMenu(mi: TMenuItem; BaseName: string);
var j: integer;
begin
  for  j:=0 to mi.Count-1 do
   if (mi.Items[j] is TMenuItem) then
//   with (mi.Items[j] as TMenuItem) do
   begin
    st:=BaseName+'.'+mi.Items[j].Name;
    s:=st + '.Text='+mi.Items[j].Caption;
    s:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    s:=StringReplace(s,#13,'|',[rfReplaceAll]);
    s:=StringReplace(s,#10,'|',[rfReplaceAll]);
    {if Hint<>''} if s<>'' then
    begin
     s:=s+#13#10;
     s:=s+st+'.Hint='+mi.Items[j].Hint;
    end;
    if s<>'' then SL.Add(s);

    if mi.Items[j].Count>0 then ProcessSubMenu(mi.Items[j],BaseName+'.'+mi.Items[j].Name);
   end;
end;

procedure ProcessControl(Ctrl: TControl);
begin
    st:=Screen.Forms[I].Name+'.'+(Screen.Forms[I].Components[j] as TControl).Name;
    if      (Screen.Forms[I].Components[j] is TLabel) then   s:=st + '.Text='+(Screen.Forms[I].Components[j] as TLabel).Caption
    else if (Screen.Forms[I].Components[j] is TSpeedButton) then   s:=st + '.Text='+(Screen.Forms[I].Components[j] as TSpeedButton).Caption
    else if (Screen.Forms[I].Components[j] is TButton) then   s:=st + '.Text='+(Screen.Forms[I].Components[j] as TButton).Caption
    else if (Screen.Forms[I].Components[j] is TMenuItem) then   s:=st + '.Text='+(Screen.Forms[I].Components[j] as TMenuItem).Caption
//    else if (Screen.Forms[I].Components[j] is TEdit) then   SL.Add((Screen.Forms[I].Components[j] as TControl).Name +'.Text='+(Screen.Forms[I].Components[j] as TEdit).Caption )
    else if (Screen.Forms[I].Components[j] is TCheckBox) then   s:=st+'.Text='+(Screen.Forms[I].Components[j] as TCheckBox).Caption
    else s:='';
    s:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    s:=StringReplace(s,#13,'|',[rfReplaceAll]);
    s:=StringReplace(s,#10,'|',[rfReplaceAll]);
    {if Hint<>''} if s<>'' then
    begin
     s:=s+#13#10;
     s:=s+st+'.Hint='+(Screen.Forms[I].Components[j] as TControl).Hint;
    end;
    if s<>'' then SL.Add(s);
end;

begin
 SL:=TStringList.Create;
 try
 if SaveLangFile.Execute then
 BEGIN
  for  I := 0 to Screen.FormCount-1 do
  for  j:=0 to Screen.Forms[I].ComponentCount-1 do
  if (Screen.Forms[I].Components[j] is TControl) then ProcessControl(Screen.Forms[I].Components[j] as TControl);

  for  j:=0 to MainMenu.Items.Count-1 do
   if (MainMenu.Items[j] is TMenuItem) then
   with (MainMenu.Items[j] as TMenuItem) do
   begin
    st:=MainMenu.Name+'.'+MainMenu.Items[j].Name;
    s:=st + '.Text='+MainMenu.Items[j].Caption;
    s:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    s:=StringReplace(s,#13,'|',[rfReplaceAll]);
    s:=StringReplace(s,#10,'|',[rfReplaceAll]);
    {if Hint<>''} if s<>'' then
    begin
     s:=s+#13#10;
     s:=s+st+'.Hint='+MainMenu.Items[j].Hint;
    end;
    if s<>'' then SL.Add(s);
    if MainMenu.Items[j].Count>0 then ProcessSubMenu(MainMenu.Items[j],st);
   end;
  SL.Sorted:=true;
  SL.SaveToFile(SaveLangFile.Filename);

 END;
 finally
  SL.Free;
 end;
end;

procedure TMainForm.miLoadLanguageFileClick(Sender: TObject);
var SL:TStringList; i,j: integer; st, s: string;

procedure ProcessSubMenu(mi: TMenuItem; BaseName: string);
var j: integer;
begin
  for  j:=0 to mi.Count-1 do
   if (mi.Items[j] is TMenuItem) then
//   with (mi.Items[j] as TMenuItem) do
   begin
   st:=BaseName+'.'+mi.Items[j].Name;
   s:=SL.Values[st+'.Hint'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then mi.Items[j].Hint:=s;
   
   s:=SL.Values[st+'.Text'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then mi.Items[j].Caption:=s;
   if mi.Items[j].Count>0 then ProcessSubMenu(mi.Items[j],st);
  end;
end;

begin
 if OpenLangFile.Execute then
 BEGIN
  SL:=TStringList.Create;
  SL.LoadFromFile(OpenLangFile.FileName);
  try
  for  i:=0 to Screen.FormCount-1 do
  for  j:=0 to Screen.Forms[I].ComponentCount-1 do
  if (Screen.Forms[I].Components[j] is TControl) then
  with (Screen.Forms[I].Components[j] as TControl) do
  begin
   st:=Screen.Forms[I].Name+'.'+(Screen.Forms[I].Components[j] as TControl).Name;
   s:=SL.Values[st+'.Hint'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then
   begin
    (Screen.Forms[I].Components[j] as TControl).Hint:=s;
    (Screen.Forms[I].Components[j] as TControl).ShowHint:=true;
   end; 
   s:=SL.Values[st+'.Text'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then
    if      (Screen.Forms[I].Components[j] is TLabel) then   (Screen.Forms[I].Components[j] as TLabel).Caption:=s
    else if (Screen.Forms[I].Components[j] is TSpeedButton) then   (Screen.Forms[I].Components[j] as TSpeedButton).Caption:=s
    else if (Screen.Forms[I].Components[j] is TButton) then   (Screen.Forms[I].Components[j] as TButton).Caption:=s
    else if (Screen.Forms[I].Components[j] is TMenuItem) then   (Screen.Forms[I].Components[j] as TMenuItem).Caption:=s
//    else if (Screen.Forms[I].Components[j] is TEdit) then   SL.Add((Screen.Forms[I].Components[j] as TControl).Name +'.Text='+(Screen.Forms[I].Components[j] as TEdit).Caption )
    else if (Screen.Forms[I].Components[j] is TCheckBox) then   (Screen.Forms[I].Components[j] as TCheckBox).Caption:=s;

  end;
  for  j:=0 to MainMenu.Items.Count-1 do
   if (MainMenu.Items[j] is TMenuItem) then
   with (MainMenu.Items[j] as TMenuItem) do
   begin
   st:=MainMenu.Name+'.'+MainMenu.Items[j].Name;
   s:=SL.Values[st+'.Hint'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then MainMenu.Items[j].Hint:=s;
   
   s:=SL.Values[st+'.Text'];
   s:=StringReplace(s,'|',#13#10,[rfReplaceAll]);
   if s<>'' then MainMenu.Items[j].Caption:=s;
    if MainMenu.Items[j].Count>0 then ProcessSubMenu(MainMenu.Items[j],st);
   end;

  finally
  SL.Free;
  end;
 END;

end;

initialization
  CoInitialize(nil);

finalization
  CoUnInitialize();



end.


