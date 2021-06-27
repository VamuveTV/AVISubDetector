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
unit GlyphForm;

interface

{$DEFINE INSIDE_ASD}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, ExtDlgs, Math, Buttons, ComCtrls, Grids,
  ImgList, ToolWin
{$IFDEF INSIDE_ASD}
  , MyTypes1;
{$ELSE}
 ;
{$ENDIF}  

const
  REGION_SUB_ELEMENT = #5; //region is considered to be sub-element of multi-area symbol
  REGION_REMOVE = #4;
  REGION_CHECK_FULL = #3;
  REGION_ABORT = #2;
  REGION_UNKNOWN = #1;

type
  TLogPal = record
  lpal : TLogPalette;
  dummy:packed Array[0..255] of TPaletteEntry;
  end;

type TBaseGlyph = record
                   Num: integer;
                   Text: string[255];
                  end;

type TOCRResult = TBaseGlyph;

type TColorType = ( ctBoneText, ctMeatText, ctSkinOutline, ctDiffOutline, ctOther );
type TRGB24 = packed record
               B,G,R:byte;
              end;
type TRGB24Ctr = record
               B,G,R:byte;
               Count: integer;
              end;
type TRGBInt64 = record B,G,R, Ctr, RA, GA, BA, CtrA:int64; end;

type TRGB24CtrX = //TRGB24Ctr;
              record
               B,G,R:byte;
               Count: integer;
               RA, GA, BA: integer;
               RAD, GAD, BAD: integer;
               DD: integer;
              end;

{type TSymbol = record
                 Text: string;
                 IsItalic, IsBold, IsUnderline: boolean;
               end;}  


type TColorDominatorX = record
                        R,G,B: byte;
                        RD, GD, BD: integer;
                        ColorType: TColorType;
                       end;
type TImageArray = record
                    Width, Height: integer;
                    Pixels: array of byte;
                   end;


type TBaseCompareResult = record
                           Num: integer; //number of best match (from base symbols)
                           Text: string; //text for best match
                           Match: extended; //matching percent (after enhancement)
                           SizeError: extended; //size mismatch (percents)
                           Comment: string; //comment for best match
                          end;

type TFullColorMap = array[0..255,0..255,0..255] of integer;//[R,G,B]
type TColorMap16 = array[0..16,0..16,0..16] of integer;//[R,G,B]

type TGlyphCompareResult =
     record
      XOffs, YOffs: integer;
      BestMatch, RemainingPercent: Extended;
      Comment: string;
     end;

type TGlyphItem = record
                   Main, Text, Outline: TBitmap;
                   Equals: string;
                   RD, GD, BD: integer;
                   R, G, B: byte;
                   BestOtherMatch: integer;
                   BestCompare: TGlyphCompareResult;
                   IsBase: boolean;
//                   Comment: string;
                  end;

type TStartStopInt =  record
                  Start, Stop: integer;
                 end;

type TStartStopIntCtr3 = record
                          X1, X2, Ctr1, Ctr2, Ctr3: integer;
                         end;

type TRectArray = array of TRect;

type TSubPos = (Upper, Lower, Middle);
type TSubPosSet = set of TSubPos;


type TArea = record
              X1, X2, Y1, Y2, FX, FY, Count: integer;
              AreaNum, GlobalAreaNum: integer;
              AreaMatch: string[255];
              AreaEnabled: boolean;
              GuessedAreaPos: TSubPosSet;
             end;

type TAreaX = record
               X1, X2, Y1, Y2, FX, FY, Count, UnityNum, UnityLocalNum: integer;
               AreaEnabled, AreaProcessed: boolean;
               GuessedAreaPos: TSubPosSet;
              end;

type TGlyphData = record
                   TextMatch: string[255];
                   AreaCount: integer;
                   Areas: array[1..255] of TArea;
                   LineNum: integer;
                  end;
     TGlyphDataPtr = ^TGlyphData;

type TCharSizeMap = record
                 FontName: string[60];
                 Data:array[char] of record
                       WX, HX, X1, Y1, X2, Y2, AreasCtr: integer;
                       Areas: TGlyphData;
                       HasData: boolean;
                      end;
                 IData:array[char] of record
                       WX, HX, X1, Y1, X2, Y2, AreasCtr: integer;
                       Areas: TGlyphData;
                       HasData: boolean;
                      end;
                 end;


type TBaseSymbol = record
                    Text: string[255];
                    UsesIA: boolean;
                    AreaCount: integer;
                    IsItalic, IsBold, IsUnderline: boolean;
                    Areas: array[1..255] of TArea;
                    IA: TImageArray;
                    Bmp: TBitmap;
                   end;
type TBaseSymbolPtr = ^TBaseSymbol;

type
  TGlyphForm = class(TForm)
    MaimPage: TPageControl;
    tbsMain: TTabSheet;
    scrlImages: TScrollBox;
    ImageOrig: TImage;
    ImageMask2: TImage;
    ImageMask3: TImage;
    OpenList: TOpenDialog;
    tbsGlyphs: TTabSheet;
    gbGlyph1: TGroupBox;
    OpenPictureDialog1: TOpenPictureDialog;
    btReduceSimilar: TButton;
    edGlyphDir: TEdit;
    btSaveGlyphs: TButton;
    btOptimizeBase: TButton;
    tbsOCRResult: TTabSheet;
    sgOCRResults: TStringGrid;
    btLoadBaseGlyphs: TButton;
    OpenSymbolList: TOpenDialog;
    UpdateTimer: TTimer;
    Panel1: TPanel;
    btSaveList: TButton;
    SaveSymbols: TSaveDialog;
    ImageMask4: TImage;
    ImageMask5: TImage;
    stbMain: TStatusBar;
    btSortSymbols: TButton;
    Panel2: TPanel;
    tbsAutoFontSettings: TTabSheet;
    sgAlphabet: TStringGrid;
    edAutoRecognitionLine: TEdit;
    lbTrySymbols: TLabel;
    edAutoFontNameX: TEdit;
    btCheckFontMatch: TButton;
    sbShowAutoFontCompareResults: TSpeedButton;
    Label9: TLabel;
    sbReverseAutoOrder: TSpeedButton;
    stTempText: TStaticText;
    clbAutoFontsChecked: TCheckListBox;
    lbTryFonts: TListBox;
    btCheckBestMatch: TButton;
    cbTryItalic: TCheckBox;
    ImageListX: TImageList;
    pbSymbols: TPaintBox;
    sclGlyphScroll: TScrollBar;
    Image1: TImage;
    edSymbolText: TEdit;
    btSymbolOK: TButton;
    btSymbolCancel: TButton;
    cbItalic: TCheckBox;
    cbBold: TCheckBox;
    cbUnderline: TCheckBox;
    UpdateTimer2: TTimer;
    btSymbolDelete: TButton;
    gbSettings: TGroupBox;
    sbPause: TSpeedButton;
    btClearTxtIgnore: TButton;
    btLoad: TButton;
    btAddGlyphs: TButton;
    stGlyphText: TMemo;
    PageControl1: TPageControl;
    tbsColors: TTabSheet;
    sbGrowOutlineMatch: TSpeedButton;
    sbGrowTextMatch: TSpeedButton;
    lbColorX: TLabel;
    sbPrevClr: TSpeedButton;
    sbNextClr: TSpeedButton;
    sbDeleteClr: TSpeedButton;
    lbClrSel: TLabel;
    sbSetDominator: TSpeedButton;
    sbQuarterPel: TSpeedButton;
    sbReduceColors: TSpeedButton;
    sbCopyDominatorsFromMain: TSpeedButton;
    edRT: TEdit;
    edRDT: TEdit;
    edBDT: TEdit;
    edGDT: TEdit;
    edBT: TEdit;
    edGT: TEdit;
    btReduceColors: TButton;
    edColorDecimator: TEdit;
    edGrowText: TEdit;
    edGrowOutline: TEdit;
    btQuarterPel: TButton;
    tbsClearing: TTabSheet;
    tbsOCRSettings: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edAutoMatchThresh: TEdit;
    edManualMatchThresh: TEdit;
    edSpaceSize: TEdit;
    edLineSize: TEdit;
    edCompareEnhancement: TEdit;
    GroupBox1: TGroupBox;
    sbEliminateIntersectingMatch: TSpeedButton;
    sbEliminateIntersectingXMatch: TSpeedButton;
    sbEliminateInsideMatch: TSpeedButton;
    sbEliminateOutsideOfBand: TSpeedButton;
    sbStrikeLine: TSpeedButton;
    tbsAnalyze: TTabSheet;
    lbAnalyzeColor1: TLabel;
    lbAnalyzeColor2: TLabel;
    sbFullColorSearch: TSpeedButton;
    sbHalfShift: TSpeedButton;
    sbTextIsLighter: TSpeedButton;
    sbModeX: TSpeedButton;
    btAnalyze: TButton;
    edAnalyzeDivider: TEdit;
    edAnalyzeShift: TEdit;
    edAnalyzeDiffLimit: TEdit;
    edTextFinalDelta: TEdit;
    btAreaDiffMapX: TButton;
    edOutlineFinalDelta: TEdit;
    tbsBatchProcessing: TTabSheet;
    btLoadList: TButton;
    btStart: TButton;
    edOCRItem: TEdit;
    btNext: TButton;
    btAutoPost: TButton;
    btBuildMasksX: TButton;
    edUpdateDelay: TEdit;
    btOK: TButton;
    Panel3: TPanel;
    sbTryAutoOCRSearch: TSpeedButton;
    sbAutoColorAnalyzis: TSpeedButton;
    sbAutoOCR: TSpeedButton;
    sbDisableNewSymbols: TSpeedButton;
    Label15: TLabel;
    Label16: TLabel;
    tbsRects: TTabSheet;
    sbSubRectRefine: TSpeedButton;
    Label10: TLabel;
    edMinWidth: TEdit;
    edUniteVerticalLimit: TEdit;
    edMinVolume: TEdit;
    edMinHeight: TEdit;
    Label11: TLabel;
    Label13: TLabel;
    edMinTextHeight: TEdit;
    Label14: TLabel;
    Label12: TLabel;
    Panel4: TPanel;
    Label17: TLabel;
    cmbPreset: TComboBox;
    clbBuildMaskList: TCheckListBox;
    tlbPreset: TToolBar;
    tlbUp: TToolButton;
    tlbDown: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    edMaskActionParam: TEdit;
    cmbMaskActions: TComboBox;
    lbSymbolAreas: TLabel;
    sbBestMatchSearch: TSpeedButton;
    sbIgnoreNewSmall: TSpeedButton;
    sbIgnoreAllNew: TSpeedButton;
    cmbZoom: TComboBox;
    sbBeepOnNewSymbol: TSpeedButton;
    procedure btLoadClick(Sender: TObject);
    procedure ImageOrigMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btBuildMasksXClick(Sender: TObject);
    procedure btBuildMasksClick(Sender: TObject);
    procedure btQuarterPelClick(Sender: TObject);
    procedure ImageMaskXMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMask2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMask3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btReduceColorsClick(Sender: TObject);
    procedure btLoadListClick(Sender: TObject);
    procedure btAddGlyphsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbsGlyphsShow(Sender: TObject);
    procedure sclGlyphScrollChange(Sender: TObject);
//    procedure btReduceSimilarClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
{    procedure sbBaseGlyphsChange(Sender: TObject);}
    procedure btSaveGlyphsClick(Sender: TObject);
    procedure btOptimizeBaseClick(Sender: TObject);
{    procedure btConvertToTextClick(Sender: TObject);}
    procedure ImageMaskXMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
{    procedure btReformClick(Sender: TObject);
    procedure btLeakTestClick(Sender: TObject);}
    procedure sbNextClrClick(Sender: TObject);
    procedure sbSetDominatorClick(Sender: TObject);
    procedure ImageOrigMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sbDeleteClrClick(Sender: TObject);
    procedure tbsOCRResultShow(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLoadBaseGlyphsClick(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMask3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edRTChange(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure btSaveListClick(Sender: TObject);
    procedure lbColorXMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btAnalyzeClick(Sender: TObject);
    procedure stbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure lbAnalyzeColor2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btAutoPostClick(Sender: TObject);
    procedure edOCRItemChange(Sender: TObject);
    procedure btCheckFontMatchClick(Sender: TObject);
    procedure btSortSymbolsClick(Sender: TObject);
    procedure sgAlphabetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgAlphabetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edAutoRecognitionLineChange(Sender: TObject);
    procedure edAutoFontNameXChange(Sender: TObject);
    procedure btClearTxtIgnoreClick(Sender: TObject);
    procedure clbAutoFontsCheckedClick(Sender: TObject);
    procedure btAreaDiffMapXClick(Sender: TObject);
    procedure pbSymbolsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edSymbolTextChange(Sender: TObject);
    procedure btSymbolOKClick(Sender: TObject);
    procedure btSymbolCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btSymbolDeleteClick(Sender: TObject);
    procedure sbCopyDominatorsFromMainClick(Sender: TObject);
    procedure sbMoveUpClick(Sender: TObject);
    procedure sbMoveDownClick(Sender: TObject);
    procedure sbAddMaskActionClick(Sender: TObject);
    procedure clbBuildMaskListMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbSetMaskActionClick(Sender: TObject);
    procedure sbDeleteMaskActionClick(Sender: TObject);
    procedure cmbPresetChange(Sender: TObject);
    procedure sbDisableNewSymbolsClick(Sender: TObject);
    procedure cmbZoomChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RT, GT, BT,
    RO, GO, BO: byte;
    RDT, GDT, BDT,
    RDO, GDO, BDO: integer;
    OutlineIgnore: array of TPoint;
    TextIgnore: array of TPoint;
    TextIgnoreLine: array of TPoint;
    Glyphs: array of TGlyphItem;
    BaseGlyphs: array of TBaseGlyph;

    BaseSymbols: array of TBaseSymbol;
//    BaseSymbols: array of TBaseSymbolPtr;
    SymbolSelected: integer;

    GlyphRects: TRectArray; //array of TRect;
    GlyphData: array of TGlyphData;
    TempRects: TRectArray;  //array of TRect;
//    GlyphSelected: integer;

    ColorDoms: array of TColorDominatorX;
    ColorDomSelected: integer;

    CompareBitmap1, CompareBitmap2, CompareBitmap3,
    Mask1Bitmap,
    Mask2Bitmap,
    Mask3Bitmap,
    MaskDiffBitmap : TBitmap;
    LastCompareResult: string;

    LastCompare: TGlyphCompareResult;

    CharSizeMaps: array of TCharSizeMap;

    TempBaseBitmap: TBitmap;
//    FullColorMap: TFullColorMap;
//    FullDiffMap: TFullColorMap;

    GlyphRectsRemoved: boolean;
    BuildMaskRequested, OCRRequested: boolean;
//    BuildMaskProcessing


    PreOCRList, PostOCRList: TStringList;
    ListFileName: string;
    MatchedAreas: array of TArea;
    AreasX: array of TAreaX;
    AreasXCtr: integer;
    UnityResults: array of string[255];



    CurrentOCRLine: integer;
    XL, YL, XLB, YLB: integer;
    XFactor, YFactor: extended;

    DisableMaskUpdate: boolean;

  CLR_MASK_MAIN,// = 15;
  CLR_MASK_DBL,//  = 16;
  CLR_MASK_OUT,//  = 16; //13;
  CLR_MASK_IGNORE,
  CLR_MASK_NONE,
  CLR_MASK_KNOWN : byte;// = 11;

  CLRX_MASK_MAIN, CLRX_MASK_DBL, CLRX_MASK_OUT,
  CLRX_MASK_IGNORE, CLRX_MASK_NONE, CLRX_MASK_KNOWN: TColor;

    procedure ReAlign;
    procedure AddTextIgnorePoint(Point1: TPoint; GlyphRect: boolean = false);
    procedure AddTextIgnoreLine(Point1: TPoint);
    procedure AddOutlineIgnorePoint(Point1: TPoint);
    procedure ClearTextIgnorePoints;
    procedure ClearOutlineIgnorePoints;
    procedure ClearIgnores;
    procedure DoIgnoreFill(Bmp:TBitmap; Arr: Array of TPoint);
    procedure DoIgnoreLines(Bmp:TBitmap; Arr: Array of TPoint);
    procedure DeleteTextIgnorePoint(Num: integer);
    procedure DeleteTextIgnoreLine(Num: integer);
    procedure DeleteOutlineIgnorePoint(Num: integer);
    function FindNearestPoint(X,Y:integer; var Arr: array of TPoint):integer;

{    procedure AddGlyphX(Main, Text, Outline: TBitmap; R, G, B: Byte; RD, GD, BD: integer; Equals: string);}
    function FindGlyphRect(X,Y: integer):integer; // return rect number, if any, for specified coords
    procedure CreateGlyphRects(Mask:TBitmap);
//    procedure CheckGlyphRect(Num: integer);
    procedure CreateTempRects(Mask:TBitmap; Edge: integer = 0; CheckSize: boolean = false);
    procedure CheckVerticalTempRects;
    procedure MergeIntersectingTempRects;
    function  IsVerticalMatched(Rct1, Rct2: TRect):boolean;
    procedure AddGlyphRect(AddRect:TRect);
    procedure InsertGlyphRect(AddRect:TRect; Num: integer);
    procedure SortGlyphRects;
    procedure AddTempRect(AddRect:TRect; CheckSize: boolean = false);
    procedure DeleteGlyphRect(Num: integer);
    procedure DeleteTempRect(Num: integer);
{    procedure CompareGlyphRects(Num1, Num2: integer);}
    function CompareGlyphs(Num1, Num2: integer):TGlyphCompareResult; //returns "best match" result
    function CompareGlyphBitmaps(Bmp1, Bmp2: TBitmap):TGlyphCompareResult;
    procedure CheckMainColor(R, G, B, RD, GD, BD:integer; ProximityMult: extended; Bmp, BmpX:TBitmap; FirstRun: boolean = true);
    procedure MatchToOutline(BmpT, BmpO: TBitmap; Distance: integer);
    procedure EliminateMinor(Bmp: TBitmap; Distance: integer = 1);
    procedure EdgeFill(Bmp: TBitmap); overload;
    procedure EdgeFill(Bmp: TBitmap; Clr1, Clr2: byte); overload;
    procedure EdgeLine(Bmp: TBitmap);
    function VolumeBlast(Bmp: TBitmap; Volume: integer; Clr: byte; GlobalRect: PRect; Data: TGlyphDataPtr = nil;IgnoreEdge: integer = 1 ): integer; //return number of areas

    function SortGlyphDataByLeft(Data:TGlyphData):TGlyphData;
    function SortGlyphDataBySize(Data:TGlyphData):TGlyphData;

    procedure OutlineMainDouble(Bmp: TBitmap); //outlines all CLR_MASK_MAIN pixels with CLR_MASK_DBL color
    procedure OutlineColorWith(Bmp: TBitmap; Clr1, Clr2: byte);
    procedure AddGlyph(Num: integer);
//    function AddGlyphX(Num: integer):string; //returns string
    function AddGlyphX(Num: integer; NoNew: boolean = false):string; //returns string
    function GetNewGlyphBitmap(Num: integer):TBitmap; //returns bitmap
//    function CheckGlyphX(Bmp:TBitmap; BaseRect: TRect; NoNew: boolean = false ):string; //returns string
//    function CheckGlyphX(Bmp:TBitmap; BaseRect: TRect; Glyph: TGlyphData; NoNew: boolean = false ):string; //returns string
    function CheckGlyphX(Bmp:TBitmap; BaseRect: TRect; NoNew: boolean = false; GlyphNum: integer = -1 ):string; //returns string
    procedure AssignPalette(Bmp: TBitmap);
    function GetBestSymbol(Bmp: TBitmap; Num: integer = -1):TBaseCompareResult;

    procedure BitmapToImageArray(Bmp:TBitmap; var IA: TImageArray);
    procedure ImageArrayToBitmap(IA: TImageArray; Bmp:TBitmap);
    procedure ImageArrayToBitmap24(IA: TImageArray; Bmp:TBitmap);

    procedure OptimizeBaseSymbols; //converts BaseSymbols Bmp to ImageArray
    function GetBaseSymbolBitmap(Num: integer):TBitmap;

    procedure UpdateColorDominator;
    procedure OpenBitmap(FileName:string);
    procedure SetBitmap(Bmp:TBitmap);
    procedure LoadIgnorePoints(FileName:string);
    procedure SaveIgnorePoints(FileName:string);
    procedure GetOCRItem;
    function  GlyphSubMatch(Num: integer):string;
    procedure CreateDiffMap(RD, GD, BD:integer; Bmp, BmpX:TBitmap; FirstRun: boolean = true);
    procedure CreateDiffMap2(RD, GD, BD:integer; Bmp, BmpX:TBitmap; Shift: integer; FirstRun: boolean = true);
    procedure MaskToBitmap(Mask,Bmp:TBitmap);
    procedure MaskToBitmapX(Mask,Bmp:TBitmap);
    procedure SetSkinOutlineDominator(R,G,B, RD, GD, BD: byte);
    procedure SetBoneTextDominator(R,G,B, RD, GD, BD: byte);
    procedure AddSkinOutlineDominator(R,G,B, RD, GD, BD: byte);
    procedure AddBoneTextDominator(R,G,B, RD, GD, BD: byte);
    procedure SubtractMasks(Mask1,Mask2:TBitmap);
    procedure ReverseSubtractMasks(Mask1,Mask2:TBitmap; Clr: byte = 0);
//    procedure btBuildMasksClick(Sender: TObject = nil);
    procedure SetProgress(Progress: Extended);
    procedure CompareResultToAddSymbolForm;
    function  TryAutoOCR(BmpX:TBitmap; NoNew: boolean = false):string;
    function TryAreaPos(X1,Y1,X2,Y2: integer):TSubPosSet;
    procedure CreateCharSizeMap(FontName: string; var CharSizeMapX: TCharSizeMap);
    procedure ClearCharSizeMap(var CharSizeMapX: TCharSizeMap);
    procedure SetTitle(str: string);
    procedure SortAreas;
    function GetRect24b(Bmp: TBitmap):TRect; overload;
    function GetRect24b(Bmp, BmpX: TBitmap):TRect; overload;
    function CheckBaseBands:boolean;
    function ProcessBitmap:integer;
    procedure DeleteSymbol(Num: integer);
    procedure AddMaskAction(Action: byte; Param: integer = 0; IsChecked: boolean = true; IsEnabled: boolean = true);
    procedure SaveSymbolsTo(FName: string);
    procedure LoadSymbolsFrom(FName: string);

    procedure RemoveArea(GlobalNum:integer);//, LocalNum, GlyphNum: integer);
    function CheckGlobalArea(FX,FY: integer):integer;
  end;

  function IsInside(Rct1, Rct2: TRect):boolean;

var
  GlyphForm1: TGlyphForm;

implementation

uses {SymbolMatch,} SymbolAdd, SymbolRefine
{$IFDEF INSIDE_ASD}
  , Unit1;
{$ELSE}
  ;  
{$ENDIF}


//procedure GetDiffMap_SSE(Src, Dest: PChar; Size, Distance: integer);register; external 'sse.dll';
//void  GetDiffMap_SSE(PCHAR Src, PCHAR Dest, unsigned int Size, int Distance)

{ $L u2.obj

procedure GetData_Fast8(Count: integer;p1,p2,p3,p4,p5,p6,p7: pointer);external;
{;;extern "C" void GetData_Fast8(unsigned int Count,
    const unsigned char *src1,
    const unsigned char *src2,
   unsigned int *Res_SAD,
   unsigned long *Res_SSqE,
   int *SOD,
   short *Max,
   short *Min);
}

{$R *.DFM}

function TGlyphForm.CheckGlobalArea;
var i: integer;
begin
 Result:=-1;
 for i:=0 to Length(AreasX)-1 do
//  if AreasX[i].Enabled then
  if AreasX[i].FX=FX then
  if AreasX[i].FY=FY then
   begin
    Result:=i;
    break;
   end;
end;

procedure TGlyphForm.RemoveArea;
var Rct: TRect;
    i,j, Idx:integer;
    x1, y1, x2, y2, xx1, xx2, yy1, yy2,
    LocalNum, GlyphNum: integer;
begin
// exit; //temporarily disabled
 //finding Area by Global Number
 GlyphNum:=-1; LocalNum:=-1;
 for i:=0 to Length(GlyphData)-1 do
 Begin
  for j:=1 to GlyphData[i].AreaCount do
   if (GlyphData[i].Areas[j].GlobalAreaNum=GlobalNum) then
   begin
    GlyphNum:=i;
    LocalNum:=j;
    break;
   end;
  if GlyphNum>-1 then break;
 End;
 if GlyphNum<0 then exit; //area not found - do not remove  

 GlyphData[GlyphNum].Areas[LocalNum].AreaEnabled:=false;
 x1:=100000; y1:=x1;
 y2:=0; x2:=0;
 Rct:=GlyphRects[GlyphNum];
 if GlyphData[GlyphNum].AreaCount>1 then
 Begin
 for i:=1 to GlyphData[GlyphNum].AreaCount do
  if GlyphData[GlyphNum].Areas[i].AreaEnabled then
  BEGIN
   xx1:=AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X1;
   yy1:=AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y1;
   xx2:=AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X2;
   yy2:=AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y2;
   if xx1<x1 then x1:=xx1;
   if yy1<y1 then y1:=yy1;
   if xx2>x2 then x2:=xx2;
   if yy2>y2 then y2:=yy2;
  END;
  GlyphRects[GlyphNum]:=Rect(x1-2,y1-2,x2+1,y2+1);
 //removing area from glyph area list 
 for i:=LocalNum to GlyphData[GlyphNum].AreaCount do GlyphData[GlyphNum].Areas[i]:=GlyphData[GlyphNum].Areas[i+1];
 Dec(GlyphData[GlyphNum].AreaCount);
   //fixing possible change in relative coords
  for i:=1 to GlyphData[GlyphNum].AreaCount do
  BEGIN
   GlyphData[GlyphNum].Areas[i].X1:=GlyphData[GlyphNum].Areas[i].X1+(Rct.Left-x1+2);
   GlyphData[GlyphNum].Areas[i].X2:=GlyphData[GlyphNum].Areas[i].X2+(Rct.Left-x1+2);
   GlyphData[GlyphNum].Areas[i].FX:=GlyphData[GlyphNum].Areas[i].FX+(Rct.Left-x1+2);
   GlyphData[GlyphNum].Areas[i].Y1:=GlyphData[GlyphNum].Areas[i].Y1+(Rct.Top-y1+2);
   GlyphData[GlyphNum].Areas[i].Y2:=GlyphData[GlyphNum].Areas[i].Y2+(Rct.Top-y1+2);
   GlyphData[GlyphNum].Areas[i].FY:=GlyphData[GlyphNum].Areas[i].FY+(Rct.Top-y1+2);
   GlyphData[GlyphNum].Areas[i].AreaNum:=i;
  END;
  //------------------------------------------------------------------------------------
  // try to rebreak Glyph into components just in case it was united due to "bad" region
  //------------------------------------------------------------------------------------
  // we already have all rects in global AreasX[] as well as in local Areas[],
  // so we just need to check them against each other and see if
  // they should be united (if they intersect) or separated (if they don't)
  //------------------------------------------------------------------------------------
  // so we just create TempRects with all remaining areas (ONLY if there is more then one)
  // and use usual CheckVerticalTempRects and MergeIntersectingTempRects
  // then add each remaining entity in TempRects as separate glyph
  //------------------------------------------------------------------------------------
  if GlyphData[GlyphNum].AreaCount>1 then
  BEGIN
   SetLength(TempRects,GlyphData[GlyphNum].AreaCount);
   for i:=1 to GlyphData[GlyphNum].AreaCount do
{    TempRects[i-1]:=Rect(AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X1-2,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y1-2,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X2+1,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y2+1);}
    TempRects[i-1]:=Rect(AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X1-2,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y1-2,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].X2+1,
                         AreasX[GlyphData[GlyphNum].Areas[i].GlobalAreaNum].Y2+1);
   CheckVerticalTempRects;
   MergeIntersectingTempRects;
   if Length(TempRects)>1 then
   //there is MORE then one glyph after separation
   //before separation there was ONLY one glyph
   begin
    //well, let's add each remaining rect as glyph and remove old one
    for i:=0 to Length(TempRects)-1 do
    Begin
     AddGlyphRect(TempRects[i]);
     Idx:=Length(GlyphData)-1;
     GlyphData[Idx].TextMatch:=REGION_UNKNOWN;
     for j:=1 to GlyphData[GlyphNum].AreaCount do
     if IsInside(TempRects[i],
                 Rect(   AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].X1,
                         AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].Y1,
                         AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].X2,
                         AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].Y2)) then
     begin
      Inc(GlyphData[Idx].AreaCount);
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount]:=GlyphData[GlyphNum].Areas[j];
      //now let's fix relative coords since they are most likely broken
      //let's base them off current TempRect and global area rect
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].X1:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].X1-TempRects[i].Left+2;
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].Y1:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].Y1-TempRects[i].Top+2;
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].X2:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].X2-TempRects[i].Left+2;
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].Y2:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].Y2-TempRects[i].Top+2;

      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].FX:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].FX-TempRects[i].Left+2;
      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].FY:=
       AreasX[GlyphData[GlyphNum].Areas[j].GlobalAreaNum].FY-TempRects[i].Top+2;

      GlyphData[Idx].Areas[GlyphData[Idx].AreaCount].AreaNum:=GlyphData[Idx].AreaCount;
     end;
    End;
    DeleteGlyphRect(GlyphNum);
   end;
  END;

 End
 else //if there is only ONE area in glyph, then it is removed with glyph
 begin
      DeleteGlyphRect(GlyphNum);
 end;

      X1:=AreasX[GlobalNum].FX-1; //only one area
      Y1:=AreasX[GlobalNum].FY-1;
//      X:=GlyphRects[i].Left+GlyphData[i].Areas[1].FX-1; //only one area
//      Y:=GlyphRects[i].Top+GlyphData[i].Areas[1].FY-1;

      AddTextIgnorePoint(Point(X1,Y1),true);
      DoIgnoreFill(Mask1Bitmap, TextIgnore);
//      MaskToBitmap(Mask1Bitmap,ImageMask3.Picture.Bitmap);
      DoIgnoreFill(Mask3Bitmap, TextIgnore);
      MaskToBitmap(Mask3Bitmap,ImageMask3.Picture.Bitmap);

      //we shouldn't remove them from global areas since that will
      //mess up global numbers in Glyph.Areas[].GlobalAreaNum
      //changing global areas is unnecessary anyway
// for i:=GlobalNum to Length(AreasX)-2 do AreasX[i]:=AreasX[i+1];
// SetLength(AreasX,Length(AreasX)-1);

end;

function TGlyphForm.TryAreaPos(X1,Y1,X2,Y2: integer):TSubPosSet;
begin
 //...
end;


procedure TGlyphForm.CompareResultToAddSymbolForm;
begin
  MaskToBitmap(CompareBitmap1,AddSymbolForm.ImageSymbol.Picture.Bitmap);
  MaskToBitmap(CompareBitmap2,AddSymbolForm.ImageBestMatch.Picture.Bitmap);
  AddSymbolForm.ImageBestMatchDiff.Picture.Bitmap.Assign(CompareBitmap3);
  AddSymbolForm.lbMatchInfo.Caption:=LastCompareResult;
end;

procedure TGlyphForm.SetProgress;
begin
   stbMain.Panels[1].Text:=FloatToStr(Progress);
   stbMain.Update;
  Application.ProcessMessages;
end;

procedure TGlyphForm.OutlineMainDouble;
var PX, PY1, PY2:PByteArray; X,Y : integer;
begin
 for Y:=1 to Bmp.Height-2 do
 begin
  PX:=Bmp.ScanLine[Y];
  PY1:=Bmp.ScanLine[Y-1];
  PY2:=Bmp.ScanLine[Y+1];
  for X:=1 to Bmp.Width-2 do
  if not(PX[X]=CLR_MASK_MAIN) then
  begin
   if ( (PX[X-1]=CLR_MASK_MAIN) or (PX[X+1]=CLR_MASK_MAIN))
   or ( (PY1[X]=CLR_MASK_MAIN) or (PY2[X]=CLR_MASK_MAIN))
   then PX[X]:=CLR_MASK_DBL;
  end;
 end;
end;

procedure TGlyphForm.SubtractMasks;
var PY1, PY2:PByteArray; X,Y : integer;
begin
 for Y:=0 to Mask1.Height-1 do
 begin
  PY1:=Mask1.ScanLine[Y];
  PY2:=Mask2.ScanLine[Y];
  for X:=0 to Mask1.Width-1 do
  if (PY1[X]=PY2[X]) and (PY1[X]=CLR_MASK_MAIN) then PY1[X]:=CLR_MASK_DBL;
 end;
end;

procedure TGlyphForm.ReverseSubtractMasks;
var PY1, PY2:PByteArray; X,Y : integer;
begin
 if Clr=0 then Clr:=CLR_MASK_DBL;
 for Y:=0 to Mask1.Height-1 do
 begin
  PY1:=Mask1.ScanLine[Y];
  PY2:=Mask2.ScanLine[Y];
  for X:=0 to Mask1.Width-1 do
  if (PY1[X]=CLR_MASK_MAIN) then
  if (PY2[X]=CLR_MASK_NONE) then
  PY1[X]:=Clr;
 end;
end;

procedure TGlyphForm.OutlineColorWith;
var PX, PX2, PY1, PY2:PByteArray; X,Y : integer;
    Bmp2: TBitmap;
begin
 if Clr1<>Clr2 then
 for Y:=1 to Bmp.Height-2 do
 begin
  PX:=Bmp.ScanLine[Y];
  PY1:=Bmp.ScanLine[Y-1];
  PY2:=Bmp.ScanLine[Y+1];
  for X:=1 to Bmp.Width-2 do
  if not(PX[X]=Clr1) then
  begin
   if ( (PX[X-1]=Clr1) or (PX[X+1]=Clr1))
   or ( (PY1[X]=Clr1) or (PY2[X]=Clr1))
   then PX[X]:=Clr2;
  end;
 end
 else
 begin
 Bmp2:=TBitmap.Create; Bmp2.Assign(Bmp);
  for Y:=1 to Bmp.Height-2 do
  begin
  PX:=Bmp.ScanLine[Y];
  PX2:=Bmp2.ScanLine[Y];
  PY1:=Bmp.ScanLine[Y-1];
  PY2:=Bmp.ScanLine[Y+1];
  for X:=1 to Bmp.Width-2 do
  if not(PX[X]=Clr1) then
  begin
   if ( (PX[X-1]=Clr1) or (PX[X+1]=Clr1))
   or ( (PY1[X]=Clr1) or (PY2[X]=Clr1))
   then PX2[X]:=Clr2;
  end;
  end;
  Bmp.Assign(Bmp2);
  Bmp2.Free; 
 end; 
end;

procedure TGlyphForm.EliminateMinor;
var PX, PY1, PY2:PByteArray; X,Y : integer;

begin
 for Y:=1 to Bmp.Height-2 do
 begin
  PX:=Bmp.ScanLine[Y];
  PY1:=Bmp.ScanLine[Y-1];
  PY2:=Bmp.ScanLine[Y+1];
  for X:=1 to Bmp.Width-2 do
  if PX[X]=CLR_MASK_MAIN then
  begin
   if ( not(PX[X-1]=CLR_MASK_MAIN) and not(PX[X+1]=CLR_MASK_MAIN))
   or ( not(PY1[X]=CLR_MASK_MAIN) and not(PY2[X]=CLR_MASK_MAIN))
   then PX[X]:=CLR_MASK_DBL;
  end;
 end;
end;

function TGlyphForm.VolumeBlast;
var PX:PByteArray;
    i, X,Y, W, H, AreaCtr, Vol, BlastedCtr : integer;
    IA_MAP, IA_CPY: TImageArray;
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
 BlastedCtr:=0;

 SetLength(IA_MAP.Pixels,H*W);
 SetLength(IA_CPY.Pixels,H*W);
 for i:=0 to H*W-1 do IA_MAP.Pixels[i]:=0;
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];  for X:=0 to W-1 do IA_CPY.Pixels[Y*W+X]:=PX[X];
 end;
 AreaCtr:=1;
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
//!   SymbolMatchForm.ImageMatch2.Picture.Bitmap.Assign(Bmp);
//!   SymbolMatchForm.Mode:=2;
//!   SymbolMatchForm.ShowModal;
   IF (Vol>=Volume) THEN
   BEGIN
    Bmp.Canvas.Brush.Color:=CL;
    Bmp.Canvas.FloodFill(X,Y,0,fsSurface);
    if (Data<>nil) then
    with Data^ do
     begin
      Areas[AreaCtr].Count:=Vol;
      Areas[AreaCtr].X1:=XX1;
      Areas[AreaCtr].X2:=XX2;
      Areas[AreaCtr].Y1:=YY1;
      Areas[AreaCtr].Y2:=YY2;
      Areas[AreaCtr].FX:=FFX;
      Areas[AreaCtr].FY:=FFY;
      Areas[AreaCtr].AreaNum:=AreaCtr;
      if GlobalRect<>nil then
      begin
      if (CheckGlobalArea(FFX+GlobalRect.Left,FFY+GlobalRect.Top)<0)
       then Areas[AreaCtr].GlobalAreaNum:=AreasXCtr
       else Areas[AreaCtr].GlobalAreaNum:=CheckGlobalArea(FFX+GlobalRect.Left,FFY+GlobalRect.Top);
      end else Areas[AreaCtr].GlobalAreaNum:=0;
      Areas[AreaCtr].AreaEnabled:=true;
      Areas[AreaCtr].AreaMatch:='';
      Areas[AreaCtr].GuessedAreaPos:=[];//TryAreaPos(XX1,YY1,XX2,YY2);
      AreaCount:=AreaCtr;//-BlastedCtr;
     end;
     inc(AreaCtr);
     if (AreaCtr>254) then AreaCtr:=0;
     if GlobalRect<>nil then
     if (CheckGlobalArea(FFX+GlobalRect.Left,FFY+GlobalRect.Top)<0) then
     begin
     SetLength(AreasX,Length(AreasX)+1);
     with AreasX[AreasXCtr] do
     begin
      Count:=Vol;
      X1:=XX1+GlobalRect.Left;
      X2:=XX2+GlobalRect.Left;
      Y1:=YY1+GlobalRect.Top;
      Y2:=YY2+GlobalRect.Top;
      FX:=FFX+GlobalRect.Left;
      FY:=FFY+GlobalRect.Top;
//      AreaNum:=AreaCtr;
      AreaEnabled:=true;
//      AreaMatch:='';
      GuessedAreaPos:=[];//TryAreaPos(XX1,YY1,XX2,YY2);
      UnityNum:=0;
      AreaProcessed:=false;
     end;
     Inc(AreasXCtr);
     end;
   END ELSE   BEGIN    Inc(BlastedCtr);   END;
  end;
 end;
{    if (Data<>nil) then
    with Data^ do AreaCount:=AreaCtr-BlastedCtr;}

 if (AreaCtr)>1 then
 begin
{  RefineSymbolForm.Image.Picture.Bitmap.Assign(Bmp);
  RefineSymbolForm.ShowModal;}
 end;

 SetLength(IA_MAP.Pixels,0);
 SetLength(IA_CPY.Pixels,0);
 Result:=AreaCtr+BlastedCtr-1;
end;

{procedure TGlyphForm.AddGlyphX;
begin

end;}

function TGlyphForm.FindGlyphRect;
var i:integer;
begin
 Result:=-1;
 for i:=0 to Length(GlyphRects)-1 do
  if (GlyphRects[i].Left<X) and (GlyphRects[i].Right>X) then
  if (GlyphRects[i].Top<Y) and (GlyphRects[i].Bottom>Y) then
   begin Result:=i; break; end;
end;

procedure TGlyphForm.SortAreas;
begin
end;

procedure TGlyphForm.AddGlyphRect;
var MinH, MinW: integer;
begin
 MinH:=StrToIntDef(edMinHeight.Text,1);
 MinW:=StrToIntDef(edMinWidth.Text,1);
 if (AddRect.Right-AddRect.Left)<MinW then exit;
 if (AddRect.Bottom-AddRect.Top)<MinH then exit;

 SetLength(GlyphRects,Length(GlyphRects)+1);
 GlyphRects[Length(GlyphRects)-1]:=AddRect;

 SetLength(GlyphData,Length(GlyphData)+1);
 GlyphData[Length(GlyphData)-1].TextMatch:='';
 GlyphData[Length(GlyphData)-1].AreaCount:=0;

 for MinH:=1 to 255 do GlyphData[Length(GlyphData)-1].Areas[MinH].AreaEnabled:=false; 
 for MinH:=1 to 255 do GlyphData[Length(GlyphData)-1].Areas[MinH].AreaMatch:=''; 
end;

procedure TGlyphForm.InsertGlyphRect;
var MinH, MinW, i: integer;
begin
 MinH:=StrToIntDef(edMinHeight.Text,1);
 MinW:=StrToIntDef(edMinWidth.Text,1);
 if (AddRect.Right-AddRect.Left)<MinW then exit;
 if (AddRect.Bottom-AddRect.Top)<MinH then exit;
 SetLength(GlyphRects,Length(GlyphRects)+1);
 for i:=Length(GlyphRects)-2 downto Num do
  GlyphRects[i+1]:=GlyphRects[i];
 GlyphRects[Num]:=AddRect;

 SetLength(GlyphData,Length(GlyphData)+1);
 for i:=Length(GlyphRects)-2 downto Num do
  GlyphData[i+1]:=GlyphData[i];
 GlyphData[Num].TextMatch:='';
 GlyphData[Num].AreaCount:=0;


{GlyphRects[Length(GlyphRects)-1]:=AddRect;}
end;

procedure TGlyphForm.SortGlyphRects;
var i,j,k:integer; Rct: TRect;
   MiddleY: array of integer;
   Lefts: array of integer;
   MiddleYSaved: integer;
   HasClose: boolean;
   LineSize, Ctr: integer;
   TmpGlyphData:TGlyphData;
   Rct1: TRect;
//sort rects by closest middle-point outside of range
begin
SetLength(MiddleY,Length(GlyphRects));
for i:=0 to Length(GlyphRects)-1 do MiddleY[i]:=(GlyphRects[i].Top+GlyphRects[i].Bottom) div 2;

// LineSize:=StrToIntDef(edLineSize.Text,120);
 LineSize:=StrToIntDef(edMinTextHeight.Text,120)*2;
 GlyphData[0].LineNum:=0;

//sorting them so that those with lower Y will be in the beginning
for i:=0 to Length(GlyphRects)-1 do
 for j:=i+1 to Length(GlyphRects)-1 do
  if (MiddleY[i]-MiddleY[j]>LineSize) then
   BEGIN
    Rct1:=GlyphRects[i];
    TmpGlyphData:=GlyphData[i];
    MiddleYSaved:=MiddleY[i];

    GlyphRects[i]:=GlyphRects[j];
    GlyphData[i]:=GlyphData[j];
    MiddleY[i]:=MiddleY[j];

    GlyphRects[j]:=Rct1;
    GlyphData[j]:=TmpGlyphData;
    MiddleY[j]:=MiddleYSaved;
   END;

SetLength(Lefts,Length(GlyphRects));
 for i:=0 to Length(GlyphRects)-1 do Lefts[i]:=(GlyphRects[i].Left);

//now we sort them by their leftmost point in X direction,
//making sure that we wouldn't break already established Y sort
for i:=0 to Length(GlyphRects)-1 do
 for j:=i+1 to Length(GlyphRects)-1 do
 Begin
  if (abs(MiddleY[i]-MiddleY[j])<=LineSize) then
  begin
//  if (GlyphRects[j].Left<GlyphRects[i].Left) then
  if (Lefts[j]<Lefts[i]) then
   BEGIN
    Rct1:=GlyphRects[i];
    TmpGlyphData:=GlyphData[i];
    MiddleYSaved:=MiddleY[i];
    k:=Lefts[i];

    GlyphRects[i]:=GlyphRects[j];
    GlyphData[i]:=GlyphData[j];
    MiddleY[i]:=MiddleY[j];
    Lefts[i]:=Lefts[j];

    GlyphRects[j]:=Rct1;
    GlyphData[j]:=TmpGlyphData;
    MiddleY[j]:=MiddleYSaved;
    Lefts[j]:=k;
   END;
  end else Break;
 End;  


{ Ctr:=0;
for i:=1 to Length(GlyphRects)-1 do
begin
 if (MiddleY[i]-MiddleY[i-1])>LineSize then
 for j:=Length(MiddleY)-1 downto i+1 do
 BEGIN
  if (abs(MiddleY[j]-MiddleY[i])<LineSize) then
  if (GlyphRects[j].Left<GlyphRects[i].Left) then
  Begin
    Rct1:=GlyphRects[i];
    TmpGlyphData:=GlyphData[i];
    MiddleYSaved:=MiddleY[i];
   for k:=i to j-1 do
   begin
    GlyphRects[k]:=GlyphRects[k+1];
    GlyphData[k]:=GlyphData[k+1];
    MiddleY[k]:=MiddleY[k+1];
   end;
    GlyphRects[j]:=Rct1;
    GlyphData[j]:=TmpGlyphData;
    MiddleY[j]:=MiddleYSaved;
   break;
  End;
 END;
end;}

//  if (GlyphRects[i].Top}
end;

procedure TGlyphForm.AddTempRect;
var MinH, MinW: integer;
begin
 if (CheckSize) then
 begin
  MinH:=StrToIntDef(edMinHeight.Text,1);
  MinW:=StrToIntDef(edMinWidth.Text,1);
  if (AddRect.Right-AddRect.Left)<MinW then exit;
  if (AddRect.Bottom-AddRect.Top)<MinH then exit;
 end; 

 SetLength(TempRects,Length(TempRects)+1);
 TempRects[Length(TempRects)-1]:=AddRect;
end;

procedure TGlyphForm.CreateTempRects;
var X,Y,i:integer; PX: PByteArray;
    StartX, StopX, StartY, StopY: array of integer;
    StartStopX, StartStopY, YBands: array of TStartStopInt;
    X1, X2, Y1, Y2, YB: integer;
    HasStart: boolean;
    HasStartX, HasStartY: boolean;

procedure CreateBands;
var X,Y: integer;
begin
 SetLength(YBands,0);
 //filling "First-Left-By-Y" and "Last-Right-By-Y" arrays
 for Y:=Edge to Mask.Height-1-Edge do
 begin
  HasStart:=false;
  PX:=Mask.ScanLine[Y];
  StartX[Y]:=-1;
  StopX[Y]:=-1;
  for X:=0 to Mask.Width-1 do
   if (PX[X]=CLR_MASK_MAIN) then
   begin
    if (not(HasStart)) then  begin    HasStart:=true;   StartX[Y]:=X;   end
    else StopX[Y]:=X;
   end;
 end;

 HasStart:=false;
 for Y:=Edge to Mask.Height-1-Edge do
 begin
  if (StartX[Y]>-1) and not(HasStart) then
   begin
    HasStart:=true;
    SetLength(YBands,Length(YBands)+1);
    YBands[Length(YBands)-1].Start:=Y;
   end
  else if (StartX[Y]<0) and (HasStart) then
    begin
     YBands[Length(YBands)-1].Stop:=Y;
     HasStart:=false;
    end;
 end;
// if (HasStart) then YBands[Length(YBands)-1].Stop:=(Mask.Height-1){Y}-1;
 if (HasStart) then YBands[Length(YBands)-1].Stop:=(Mask.Height-1-Edge){Y};
end;

begin

// SetLength(GlyphRects,0);
 SetLength(TempRects,0);

 SetLength(StartX,Mask.Height); SetLength(StartY,Mask.Width);
 SetLength(StopX,Mask.Height);  SetLength(StopY,Mask.Width);
 for X:=0 to Mask.Height-1 do StartX[X]:=-1;
 for X:=0 to Mask.Height-1 do StopX[X]:=-1;
 for X:=0 to Mask.Width-1 do StartY[X]:=-1;
 for X:=0 to Mask.Width-1 do StopY[X]:=-1;

 CreateBands;

for YB:=0 to Length(YBands)-1 do
begin
 SetLength(StartStopX,0);
 SetLength(StartStopY,0);
 //filling "First-Top-By-X" and "Last-Bottom-By-X" arrays
 for X:=Edge to Mask.Width-1-Edge do
 begin
 HasStart:=false;
 StartY[X]:=-1;
 StopY[X]:=-1;
//!  for Y:=0 to Mask.Height-1 do
  for Y:=YBands[YB].Start to YBands[YB].Stop do
  begin
   PX:=Mask.ScanLine[Y];
   if (PX[X]=CLR_MASK_MAIN) then
   begin
    if (not(HasStart)) then  begin    HasStart:=true;   StartY[X]:=Y;   end
    else StopY[X]:=Y;
   end;
  end;
 end;

 HasStartX:=false;
     X1:=-1;
     X2:=-1;
// for X:=0 to Mask.Width-1 do
//! for Y:=0 to Mask.Height-1 do
 for Y:=YBands[YB].Start to YBands[YB].Stop do
 begin
  if not(HasStartX) then
  begin
   if StartX[Y]>-1 then
    begin
     X1:=StartX[Y];
     X2:=StopX[Y];
     HasStartX:=true;
    end;
  end
  else
  begin
   if StartX[Y]>-1 then
    begin
     if (X1>StartX[Y]) then X1:=StartX[Y];
     if (X2<StopX[Y]) then X2:=StopX[Y];
    end
    else
    begin
     HasStartX:=false;
     SetLength(StartStopX,Length(StartStopX)+1);
     StartStopX[Length(StartStopX)-1].Start:=X1;
     StartStopX[Length(StartStopX)-1].Stop:=X2;
     X1:=-1;
     X2:=-1;
    end;
  end;
 end;
 if HasStartX then
 begin
     SetLength(StartStopX,Length(StartStopX)+1);
     StartStopX[Length(StartStopX)-1].Start:=X1;
     StartStopX[Length(StartStopX)-1].Stop:=X2;
 end;

 HasStartY:=false;
     Y1:=-1;
     Y2:=-1;
 for X:=Edge to Mask.Width-1-Edge do
// for Y:=0 to Mask.Height-1 do
 begin
  if not(HasStartY) then
  begin
   if StartY[X]>-1 then
    begin
     Y1:=StartY[X];
     Y2:=StopY[X];
     HasStartY:=true;
     X1:=X;
    end;
  end
  else
  begin
   if StartY[X]>-1 then
    begin
     if (Y1>StartY[X]) then Y1:=StartY[X];
     if (Y2<StopY[X]) then Y2:=StopY[X];
    end
    else
    begin
     HasStartY:=false;
     SetLength(StartStopY,Length(StartStopY)+1);
     StartStopY[Length(StartStopY)-1].Start:=Y1;
     StartStopY[Length(StartStopY)-1].Stop:=Y2;
     X2:=X;
//     for i:=0 to Length(StartStopX)-1 do
     AddTempRect(Rect(X1-1,Y1-1,X2+1,Y2+2), CheckSize);
{     if Edge=0 then AddTempRect(Rect(X1-1,Y1-1,X2+1,Y2+2), CheckSize)}
//     else AddTempRect(Rect(X1-1,Y1-1,X2+1,Min(Y2+2,Mask.Height{-1}-Edge-1)), CheckSize);
     Y1:=-1;
     Y2:=-1;
    end;
  end;
 end;
 if HasStartY then
 if (Y1>0) and (Y2>0) then
 begin
     SetLength(StartStopY,Length(StartStopY)+1);
     StartStopY[Length(StartStopY)-1].Start:=Y1;
     StartStopY[Length(StartStopY)-1].Stop:=Y2;
     for i:=0 to Length(StartStopX)-1 do
     AddTempRect(Rect(StartStopX[i].Start,Y1,
                    StartStopX[i].Stop,Y2), CheckSize);
 end;
end;
{ for X:=0 to Length(StartStopX)-1 do
 for Y:=0 to Length(StartStopY)-1 do
  AddGlyphRect(Rect(StartStopX[X].Start,StartStopY[Y].Start,
                    StartStopX[X].Stop,StartStopY[Y].Stop));}
 SetLength(StartX,0);
 SetLength(StopX,0);
 SetLength(StartY,0);
 SetLength(StopY,0);
 SetLength(StartStopX,0);
 SetLength(StartStopY,0);
 SetLength(YBands,0);


end;

function TGlyphForm.IsVerticalMatched;
var VLimit, i, j: integer;
begin
 VLimit:=StrToIntDef(edUniteVerticalLimit.Text,12);
 Result:=false;
   if (abs(Rct1.Bottom-Rct2.Top)<=VLimit)
   or (abs(Rct1.Top-Rct2.Bottom)<=VLimit) then
   if  (((Rct1.Left>=Rct2.Left) or (abs(Rct1.Left-Rct2.Left)<4))
    and ((Rct1.Right<=Rct2.Right)or (abs(Rct1.Right-Rct2.Right)<4) ))
      or
      (((Rct1.Left<=Rct2.Left) or (abs(Rct1.Left-Rct2.Left)<4)) and
      ((Rct1.Right>=Rct2.Right)or (abs(Rct1.Right-Rct2.Right)<4) ))
      or
      (((Rct1.Left>=Rct2.Left) and (Rct1.Left<=Rct2.Right)) or
      (((Rct1.Right>=Rct2.Left) and (Rct1.Right<=Rct2.Right))))
   then Result:=true;

end;

function MergeRectX(Rect1, Rect2: TRect):TRect;
var Nk: integer; Rct: TRect;
begin
 Rct.Left:=Min(Rect1.Left,Rect2.Left);
 Rct.Top:=Min(Rect1.Top,Rect2.Top);
 Rct.Right:=Max(Rect1.Right,Rect2.Right);
 Rct.Bottom:=Max(Rect1.Bottom,Rect2.Bottom);

 Result:=Rct;
end;


procedure TGlyphForm.CheckVerticalTempRects;
//edUniteVerticalLimit
var VLimit, i, j: integer;

procedure MergeRects(Num1, Num2: integer);
var Nk: integer; Rct: TRect;
begin
 Rct.Left:=Min(TempRects[Num1].Left,TempRects[Num2].Left);
 Rct.Top:=Min(TempRects[Num1].Top,TempRects[Num2].Top);
 Rct.Right:=Max(TempRects[Num1].Right,TempRects[Num2].Right);
 Rct.Bottom:=Max(TempRects[Num1].Bottom,TempRects[Num2].Bottom);
 Nk:=Min(Num1, Num2);

 DeleteTempRect(Max(Num1,Num2));
 TempRects[Nk]:=Rct;

end;

begin
 VLimit:=StrToIntDef(edUniteVerticalLimit.Text,12);
 i:=0;
 while(i<Length(TempRects)) do
 begin
  j:=i+1;
  while(j<Length(TempRects)) do
   if IsVerticalMatched(TempRects[i],TempRects[j])
{   if (abs(TempRects[i].Bottom-TempRects[j].Top)<=VLimit)
   or (abs(TempRects[i].Top-TempRects[j].Bottom)<=VLimit) then
//   if (abs(TempRects[i].Left-TempRects[j].Left)<4) and
//      (abs(TempRects[i].Right-TempRects[j].Right)<4)//) or
    if  (((TempRects[i].Left>=TempRects[j].Left) or (abs(TempRects[i].Left-TempRects[j].Left)<4))
    and ((TempRects[i].Right<=TempRects[j].Right)or (abs(TempRects[i].Right-TempRects[j].Right)<4) ))
      or
      (((TempRects[i].Left<=TempRects[j].Left) or (abs(TempRects[i].Left-TempRects[j].Left)<4)) and
      ((TempRects[i].Right>=TempRects[j].Right)or (abs(TempRects[i].Right-TempRects[j].Right)<4) ))}
{   if (abs(TempRects[i].Left-TempRects[j].Left)<=VLimit)
   or (abs(TempRects[i].Left-TempRects[j].Right)<=VLimit)
   or (abs(TempRects[i].Right-TempRects[j].Left)<=VLimit)
   or (abs(TempRects[i].Right-TempRects[j].Right)<=VLimit)}
   then MergeRects(i,j)
   else inc(j);
  inc(i);
 end;

end;

function IsLineIntersecting1(C1X1, C1Y1, C1Y2, C2X1, C2X2, C2Y1: integer): boolean;
begin
 Result:=false;
 if  ((C1X1>C2X1) and (C1X1<C2X2))
 and ((C2Y1>C1Y1) and (C2Y1<C1Y2)) then Result:=true;
end;

function IsIntersecting(Rct1, Rct2: TRect):boolean;
begin
 Result:=false;
 if (IsLineInterSecting1(Rct1.Left, Rct1.Top, Rct1.Bottom,
                        Rct2.Left, Rct2.Right, Rct2.Top)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct1.Right, Rct1.Top, Rct1.Bottom,
                        Rct2.Left, Rct2.Right, Rct2.Top)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct1.Left, Rct1.Top, Rct1.Bottom,
                        Rct2.Left, Rct2.Right, Rct2.Bottom)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct1.Right, Rct1.Top, Rct1.Bottom,
                        Rct2.Left, Rct2.Right, Rct2.Bottom)) then begin Result:=true; exit; end;
                        
 if (IsLineInterSecting1(Rct2.Left, Rct2.Top, Rct2.Bottom,
                        Rct1.Left, Rct1.Right, Rct1.Top)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct2.Right, Rct2.Top, Rct2.Bottom,
                        Rct1.Left, Rct1.Right, Rct1.Top)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct2.Left, Rct2.Top, Rct2.Bottom,
                        Rct1.Left, Rct1.Right, Rct1.Bottom)) then begin Result:=true; exit; end;
 if (IsLineInterSecting1(Rct2.Right, Rct2.Top, Rct2.Bottom,
                        Rct1.Left, Rct1.Right, Rct1.Bottom)) then begin Result:=true; exit; end;
end;

function IsInside(Rct1, Rct2: TRect):boolean;
begin
 Result:=false;
 if  ((Rct1.Left>=Rct2.Left) and (Rct1.Left<=Rct2.Right)
 and  (Rct1.Top>=Rct2.Top) and (Rct1.Top<=Rct2.Bottom))
 or  ((Rct2.Left>=Rct1.Left) and (Rct2.Left<=Rct1.Right)
 and  (Rct2.Top>=Rct1.Top) and (Rct2.Top<=Rct1.Bottom)) then Result:=true;
end;

procedure TGlyphForm.MergeIntersectingTempRects;
//edUniteVerticalLimit
var VLimit, i, j: integer;

procedure MergeRects(Num1, Num2: integer);
var Nk: integer; Rct: TRect;
begin
 Rct.Left:=Min(TempRects[Num1].Left,TempRects[Num2].Left);
 Rct.Top:=Min(TempRects[Num1].Top,TempRects[Num2].Top);
 Rct.Right:=Max(TempRects[Num1].Right,TempRects[Num2].Right);
 Rct.Bottom:=Max(TempRects[Num1].Bottom,TempRects[Num2].Bottom);
 Nk:=Min(Num1, Num2);

 DeleteTempRect(Max(Num1,Num2));
 TempRects[Nk]:=Rct;

end;


var Intersect, IntersectX: boolean;

begin
 VLimit:=StrToIntDef(edUniteVerticalLimit.Text,12);
 i:=0;
 while(i<Length(TempRects)) do
 begin
  j:=i+1;
  IntersectX:=false;
  while(j<Length(TempRects)) do
  begin
   Intersect:=IsIntersecting(TempRects[i],TempRects[j]);
   Intersect:=Intersect or IsInside(TempRects[i],TempRects[j]);
   IntersectX:=IntersectX or Intersect;
   if Intersect then MergeRects(i,j)
   else inc(j);
  end;
  if not(IntersectX) then inc(i)
  else i:=0;
 end;

end;


procedure TGlyphForm.CreateGlyphRects;
var i,j, Volume:integer;
    MaskX: TBitmap;
    Rct: TRect;
    HasEqual: boolean;
    GlyphDataSaved: TGlyphData;
begin
 Volume:=StrToIntDef(edMinVolume.Text,30);
 SetLength(GlyphRects,0);
 SetLength(GlyphData,0);
 AreasXCtr:=0;
 SetLength(AreasX,0); //all areas are added in VolumeBlast
// CreateTempRects(Mask);
 CreateTempRects(Mask, 0, true);
    CheckVerticalTempRects;
    MergeIntersectingTempRects;
    
 for i:=0 to Length(TempRects)-1 do AddGlyphRect(TempRects[i]);

 if sbSubRectRefine.Down then
 begin //refining rects
  MaskX:=TBitmap.Create;
  MaskX.PixelFormat:=pf8bit;
  try
   i:=0;
   while (i<Length(GlyphRects)) do
   begin
    Rct:=GlyphRects[i];
    MaskX.Height:=0;
    MaskX.Canvas.Brush.Color:=clBlack;
    MaskX.Width:=Rct.Right-Rct.Left+2;
    MaskX.Height:=Rct.Bottom-Rct.Top+2;

    BitBlt(MaskX.Canvas.Handle,1,1,MaskX.Width,MaskX.Height,
           Mask.Canvas.Handle,Rct.Left,Rct.Top,SRCCOPY);
{    BitBlt(MaskX.Canvas.Handle,0,0,MaskX.Width,MaskX.Height,
           Mask.Canvas.Handle,Rct.Left-1,Rct.Top-1,SRCCOPY);}
    EliminateMinor(MaskX);
    VolumeBlast(MaskX,Volume,CLR_MASK_MAIN, @Rct, @GlyphData[i], 1);
    CreateTempRects(MaskX,1,true);
    CheckVerticalTempRects;
    MergeIntersectingTempRects;
{    BitBlt(Mask.Canvas.Handle,Rct.Left-1,Rct.Top-1,MaskX.Width,MaskX.Height,
           MaskX.Canvas.Handle,0,0,SRCCOPY);}
    BitBlt(Mask.Canvas.Handle,Rct.Left,Rct.Top,MaskX.Width-2,MaskX.Height-2,
           MaskX.Canvas.Handle,1,1,SRCCOPY);
    BitBlt(ImageMask3.Picture.Bitmap.Canvas.Handle,Rct.Left,Rct.Top,MaskX.Width-2,MaskX.Height-2,
           MaskX.Canvas.Handle,1,1,SRCCOPY);

    if i>1000 then
    begin
     ShowMessage('ERROR - Too Many Rectangles!');
     exit;
    end;
    ImageMask3.Invalidate; //.Update;
    SetTitle(Format('Rect %d / %d',[i+1, Length(GlyphRects)]));
    SetProgress(50+(i*40/Length(GlyphRects)));

    if Length(TempRects)>=1 then
    begin
     GlyphDataSaved:=GlyphData[i];

     DeleteGlyphRect(i);
     HasEqual:=false;
     for j:=Length(TempRects)-1 downto 0 do
     begin
      TempRects[j].Left:=Max(0,TempRects[j].Left+Rct.Left-1);
      TempRects[j].Right:=Max(0,TempRects[j].Right+Rct.Left-1);
      TempRects[j].Top:=Max(0,TempRects[j].Top+Rct.Top-1);
      TempRects[j].Bottom:=Max(0,TempRects[j].Bottom+Rct.Top-1);
//      Inc(TempRects[j].Left,Rct.Left-1));
//      Inc(TempRects[j].Right,Rct.Left-1);
//      Inc(TempRects[j].Top,Rct.Top-1);
//      Inc(TempRects[j].Bottom,Rct.Top-1);
      InsertGlyphRect(TempRects[j],i); //      AddGlyphRect(TempRects[j]);
        if (abs(TempRects[j].Left-Rct.Left)<2) and
        (abs(TempRects[j].Right-Rct.Right)<2) and
        (abs(TempRects[j].Top-Rct.Top)<2) and
        (abs(TempRects[j].Bottom-Rct.Bottom)<2)
{        or (TempRects[j].Bottom=Rct.Bottom+1)
          or (TempRects[j].Bottom=Rct.Bottom-1))}
         then
         begin
          GlyphRects[i]:=Rct;
          HasEqual:=true;
         end; 

     end;
//        if Length(TempRects)>=1 then
{        if (TempRects[Length(TempRects)-1].Left<>Rct.Left) or
        (TempRects[Length(TempRects)-1].Right<>Rct.Right) or
        (TempRects[Length(TempRects)-1].Top<>Rct.Top) or
        (TempRects[Length(TempRects)-1].Bottom<>Rct.Bottom) then}
        if not(HasEqual) then
        begin
         Dec(i); //refining new rect again
         SetLength(TempRects,0);
        end else GlyphData[i]:=GlyphDataSaved;
    end
    else if Length(TempRects)=0 then begin DeleteGlyphRect(i); Dec(i); end;
    Inc(i);
   end;
  finally
   MaskX.Free;
  end;
 end;
end;

procedure TGlyphForm.DeleteTextIgnorePoint;
var i:integer;
begin
 if Num>=Length(TextIgnore) then exit;
 for i:=Num to Length(TextIgnore)-2 do TextIgnore[i]:=TextIgnore[i+1];

 SetLength(TextIgnore,Length(TextIgnore)-1);
end;

procedure TGlyphForm.DeleteGlyphRect;
var i,j:integer;
begin
 if Num>=Length(GlyphRects) then exit;

 for i:=Num to Length(GlyphRects)-2 do GlyphRects[i]:=GlyphRects[i+1];
 SetLength(GlyphRects,Length(GlyphRects)-1);

 for i:=Num to Length(GlyphData)-2 do
 begin
  GlyphData[i]:=GlyphData[i+1];
{  for j:=1 to GlyphData[i].AreaCount do
   GlyphData[i].Areas[j]:=GlyphData[i+1].Areas[j];}
 end; 
 SetLength(GlyphData,Length(GlyphData)-1);


end;

procedure TGlyphForm.DeleteTempRect;
var i:integer;
begin
 if Num>=Length(TempRects) then exit;
 for i:=Num to Length(TempRects)-2 do TempRects[i]:=TempRects[i+1];

 SetLength(TempRects,Length(TempRects)-1);
end;

procedure TGlyphForm.DeleteTextIgnoreLine;
var i:integer;
begin
 if Num>=Length(TextIgnoreLine) then exit;
 Num := (Num div 2) * 2;
 for i:=Num to Length(TextIgnoreLine)-2 do TextIgnoreLine[i]:=TextIgnoreLine[i+1];
 SetLength(TextIgnoreLine,Length(TextIgnoreLine)-1);
 for i:=Num to Length(TextIgnoreLine)-2 do TextIgnoreLine[i]:=TextIgnoreLine[i+1];
 SetLength(TextIgnoreLine,Length(TextIgnoreLine)-1);
end;


procedure TGlyphForm.DeleteOutlineIgnorePoint;
var i:integer;
begin
 if Num>=Length(OutlineIgnore) then exit;
 for i:=Num to Length(OutlineIgnore)-2 do OutlineIgnore[i]:=OutlineIgnore[i+1];

 SetLength(OutlineIgnore,Length(OutlineIgnore)-1);
end;

function TGlyphForm.FindNearestPoint;
var i, BestNum:integer; BestDist, Dist: extended;
begin
 BestNum:=0;
 BestDist:=ImageOrig.Width*ImageOrig.Width+ImageOrig.Height*ImageOrig.Height;
 for i:=0 to Length(Arr)-1 do
 begin
  Dist:=Sqrt((X-Arr[i].X)*(X-Arr[i].X)+(Y-Arr[i].Y)*(Y-Arr[i].Y));
  if BestDist>Dist then
  begin
   BestDist:=Dist;
   BestNum:=i;
  end;
 end;
 Result:=BestNum;
end;

procedure TGlyphForm.AddTextIgnorePoint;
var i:integer;
begin
//check for such point already in list
 for i:=0 to length(TextIgnore)-1 do
  if (Point1.X=TextIgnore[i].X) and (Point1.Y=TextIgnore[i].Y) then exit;

 if (GlyphRect) then GlyphRectsRemoved:=true;
 SetLength(TextIgnore,length(TextIgnore)+1);
 TextIgnore[length(TextIgnore)-1]:=Point1;

 ImageMask3.Picture.Bitmap.Canvas.Brush.Color:=CLRX_MASK_IGNORE;
 ImageMask3.Picture.Bitmap.Canvas.FloodFill(Point1.X, Point1.Y,CLRX_MASK_MAIN, fsSurface);
end;

procedure TGlyphForm.AddTextIgnoreLine;
var i: integer;
begin
 //check for no duplicates
 for i:=0 to length(TextIgnoreLine)-1 do
  if (Point1.X=TextIgnoreLine[i].X) and (Point1.Y=TextIgnoreLine[i].Y) then exit;
   
 SetLength(TextIgnoreLine,length(TextIgnoreLine)+1);
 TextIgnoreLine[length(TextIgnoreLine)-1]:=Point1;
end;

procedure TGlyphForm.AddOutlineIgnorePoint;
begin
 SetLength(OutlineIgnore,length(OutlineIgnore)+1);
 OutlineIgnore[length(OutlineIgnore)-1]:=Point1;
end;

procedure TGlyphForm.ClearTextIgnorePoints;
begin SetLength(TextIgnore,0);end;

procedure TGlyphForm.ClearOutlineIgnorePoints;
begin SetLength(OutlineIgnore,0);end;

procedure TGlyphForm.CheckMainColor;//(R, G, B, RD, GD, BD:integer; ProximityMult: extended; Bmp, BmpX:TBitmap);
var {R,G,B,} RX, GX, BX: byte; PX, PX2:PByteArray; {BmpX: TBitmap;} X,Y : integer;
    RP, GP, BP: ^byte; HasMatch: boolean;
begin
{ Clr:=Bmp.Canvas.Pixels[X,Y];
 R:=(Clr shl 16) and $FF;
 G:=(Clr shl 8) and $FF;
 B:=Clr and $FF;}
{ PX:=Bmp.ScanLine[YP];
 R:=PX[XP*3+2];
 G:=PX[XP*3+1];
 B:=PX[XP*3];}


// BmpX:=Result;
// BmpX:=TBitmap.Create;
 BmpX.PixelFormat:=pf8Bit;
 BmpX.Width:=Bmp.Width;
 BmpX.Height:=Bmp.Height;
// CheckDirectMatch;
 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
//  if (Abs(RX-R)<RD) and (Abs(GX-G)<GD) and (Abs(BX-B)<BD) then
//   PX2[X]:=255 else if (FirstRun) then PX2[X]:=0;
  if (Abs(RX-R)<RD) and (Abs(GX-G)<GD) and (Abs(BX-B)<BD) then
   PX2[X]:=CLR_MASK_MAIN else if (FirstRun) then PX2[X]:=CLR_MASK_NONE
   else if not(PX2[X]=CLR_MASK_MAIN) then PX2[X]:=CLR_MASK_NONE;
  end;
 end;
{
//checking proximity - creating map of pixels "close" to original match 
 for Y:=1 to Bmp.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y-1];
  PX2:=BmpX.ScanLine[Y];
  for X:=1 to Bmp.Width-1 do
  begin
   RP:=@PX[X];   GP:=@PX2[X];   BP:=@PX[X-1];
   HasMatch:=(RP^=255) or (GP^=255) or (BP^=255);
   if (HasMatch) then
   begin
    if RP^=0 then RP^:=128;
    if GP^=0 then GP^:=128;
    if BP^=0 then BP^:=128;
   end;
  end;
 end; 
// CheckProximityMatch;
// now we are removing those "proximity" pixels that don't fit into double threshold
 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  if (PX2[X]=128) then
  if (Abs(RX-R)<RD*ProximityMult) and (Abs(GX-G)<GD*ProximityMult) and (Abs(BX-B)<BD*ProximityMult) then
   PX2[X]:=254;// else PX2[X]:=128;
  if (PX2[X]=255) then PX2[X]:=CLR_MASK_MAIN;
  if (PX2[X]=254) then PX2[X]:=CLR_MASK_DBL;
  if (PX2[X]=128) then PX2[X]:=CLR_MASK_OUT;
  if (PX2[X]=0) then PX2[X]:=CLR_MASK_NONE;
  end;
 end;
}
// BmpX.Free;

end;

procedure TGlyphForm.CreateDiffMap;//(R, G, B, RD, GD, BD:integer; ProximityMult: extended; Bmp, BmpX:TBitmap);
var {R,G,B,}
    RX, GX, BX: byte;
    RXX, GXX, BXX: byte;
    RXY, GXY, BXY: byte;
    PX, PXY, PX2:PByteArray; {BmpX: TBitmap;} X,Y : integer;
    RP, GP, BP: ^byte; HasMatch: boolean;
begin
 BmpX.PixelFormat:=pf8Bit;
 BmpX.Width:=Bmp.Width;
 BmpX.Height:=Bmp.Height;

 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  if (Y>0) then PXY:=Bmp.ScanLine[Y-1];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  if (X=0) or (Y=0) then PX2[X]:=CLR_MASK_NONE
  else
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  RXX:=PX[(X+1)*3+2];  GXX:=PX[(X+1)*3+1];  BXX:=PX[(X+1)*3];
  RXY:=PXY[X*3+2];  GXY:=PXY[X*3+1];  BXY:=PXY[X*3];
  if ((Abs(RX-RXX)>=RD) and (Abs(GX-GXX)>=GD) and (Abs(BX-BXX)>=BD))
  or ((Abs(RX-RXY)>=RD) and (Abs(GX-GXY)>=GD) and (Abs(BX-BXY)>=BD)) then
   PX2[X]:=CLR_MASK_MAIN else if (FirstRun) then PX2[X]:=CLR_MASK_NONE
   else if not(PX2[X]=CLR_MASK_MAIN) then PX2[X]:=CLR_MASK_NONE;
  end;
 end;

end;

procedure TGlyphForm.CreateDiffMap2;//(R, G, B, RD, GD, BD:integer; ProximityMult: extended; Bmp, BmpX:TBitmap);
var {R,G,B,}
    RX, GX, BX: byte;
    RXX, GXX, BXX: byte;
    RXY, GXY, BXY: byte;
    PX, PXY, PX2:PByteArray; {BmpX: TBitmap;} X,Y : integer;
    RP, GP, BP: ^byte; HasMatch: boolean;
begin
 BmpX.PixelFormat:=pf8Bit;
 BmpX.Width:=Bmp.Width;
 BmpX.Height:=Bmp.Height;

 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  if (Y>=Shift) then PXY:=Bmp.ScanLine[Y-Shift];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  if (X<Shift) or (Y<Shift) then PX2[X]:=CLR_MASK_NONE
  else
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  RXX:=PX[(X-Shift)*3+2];  GXX:=PX[(X-Shift)*3+1];  BXX:=PX[(X-Shift)*3];
  RXY:=PXY[X*3+2];  GXY:=PXY[X*3+1];  BXY:=PXY[X*3];
  if ((Abs(RX-RXX)>=RD) or (Abs(GX-GXX)>=GD) or (Abs(BX-BXX)>=BD))
  or ((Abs(RX-RXY)>=RD) or (Abs(GX-GXY)>=GD) or (Abs(BX-BXY)>=BD)) then
   PX2[X]:=CLR_MASK_MAIN else if (FirstRun) then PX2[X]:=CLR_MASK_NONE
   else if not(PX2[X]=CLR_MASK_MAIN) then PX2[X]:=CLR_MASK_NONE;
  end;
 end;

 FirstRun:=false;
 for Y:=0 to Bmp.Height-1-Shift do
 begin
  PX:=Bmp.ScanLine[Y];
  PXY:=Bmp.ScanLine[Y+Shift];
  PX2:=BmpX.ScanLine[Y];
  for X:=0 to Bmp.Width-1-Shift do
  begin
  RX:=PX[X*3+2];  GX:=PX[X*3+1];  BX:=PX[X*3];
  RXX:=PX[(X+Shift)*3+2];  GXX:=PX[(X+Shift)*3+1];  BXX:=PX[(X+Shift)*3];
  RXY:=PXY[X*3+2];  GXY:=PXY[X*3+1];  BXY:=PXY[X*3];
  if ((Abs(RX-RXX)>=RD) or (Abs(GX-GXX)>=GD) or (Abs(BX-BXX)>=BD))
  or ((Abs(RX-RXY)>=RD) or (Abs(GX-GXY)>=GD) or (Abs(BX-BXY)>=BD)) then
   PX2[X]:=CLR_MASK_MAIN else if (FirstRun) then PX2[X]:=CLR_MASK_NONE
   else if not(PX2[X]=CLR_MASK_MAIN) then PX2[X]:=CLR_MASK_NONE;
  end;
 end;
 
end;


procedure TGlyphForm.MaskToBitmap;
var {R,G,B,}
    MX, RX, GX, BX: byte;
    PX, PX2:PByteArray; X,Y : integer;
    RP, GP, BP: ^byte; 
begin
 Bmp.Width:=0;
 Bmp.PixelFormat:=pf24bit;
 Bmp.Width:=Mask.Width;
 Bmp.Height:=Mask.Height;

 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Mask.ScanLine[Y];
  PX2:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
   MX:=PX[X];  RP:=@PX2[X*3+2];  GP:=@PX2[X*3+1];  BP:=@PX2[X*3];
   if MX=CLR_MASK_MAIN then
   begin RP^:=255; GP^:=255; BP^:=32; end else
   if MX=CLR_MASK_NONE then
   begin RP^:=128+32; GP^:=128+32; BP^:=128+32; end else
   if MX=CLR_MASK_DBL then
   begin RP^:=32; GP^:=32; BP^:=255; end else
   if MX=CLR_MASK_KNOWN then
   begin RP^:=32; GP^:=255; BP^:=32; end else
   if MX=CLR_MASK_OUT then
   begin RP^:=255; GP^:=32; BP^:=255; end else
   if MX=CLR_MASK_IGNORE then
   begin RP^:=32; GP^:=32; BP^:=32; end else
   if MX=0 then
   begin RP^:=0; GP^:=0; BP^:=0; end else
   begin RP^:=64; GP^:=64; BP^:=64; end;
  end;
 end;

end;

procedure TGlyphForm.MaskToBitmapX;
var {R,G,B,}
    MX, RX, GX, BX: byte;
    PX, PX2:PByteArray; X,Y : integer;
    RP, GP, BP: ^byte;
begin
 Bmp.Width:=0;
 Bmp.PixelFormat:=pf24bit;
 Bmp.Width:=Mask.Width;
 Bmp.Height:=Mask.Height;

 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Mask.ScanLine[Y];
  PX2:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
   MX:=PX[X];  RP:=@PX2[X*3+2];  GP:=@PX2[X*3+1];  BP:=@PX2[X*3];
   if MX=CLR_MASK_MAIN then
   begin RP^:=0; GP^:=0; BP^:=0; end
   else begin RP^:=255; GP^:=255; BP^:=255; end;
  end;
 end;

end;


procedure OverlapMasks(Bmp1, Bmp2, BmpRes: TBitmap);
begin
 BmpRes.Width:=Bmp1.Width;
 BmpRes.Height:=Bmp1.Height;
 BmpRes.PixelFormat:=pf8bit;
 BmpRes.Canvas.CopyMode:=cmSrcCopy;
 BmpRes.Canvas.Draw(0,0,Bmp1);
 BmpRes.Canvas.CopyMode:=cmNotSrcErase;//cmSrcInvert;//Paint;//Invert;//MergePaint;
 BmpRes.Canvas.Draw(0,0,Bmp2);
end;

procedure TGlyphForm.EdgeLine(Bmp:TBitmap);
var X, Y: integer; PXT:PByteArray;
begin
 PXT:=Bmp.ScanLine[0];
  for X:=0 to Bmp.Width-1 do if PXT[X]=CLR_MASK_MAIN then PXT[X]:=CLR_MASK_OUT;
 PXT:=Bmp.ScanLine[Bmp.Height-1];
  for X:=0 to Bmp.Width-1 do if PXT[X]=CLR_MASK_MAIN then PXT[X]:=CLR_MASK_OUT;
 for Y:=0 to Bmp.Height-1 do
 begin
  PXT:=Bmp.ScanLine[Y];
  if PXT[0]=CLR_MASK_MAIN then PXT[0]:=CLR_MASK_OUT;
  if PXT[Bmp.Width-1]=CLR_MASK_MAIN then PXT[Bmp.Width-1]:=CLR_MASK_OUT;
 end;
end;

procedure TGlyphForm.EdgeFill(Bmp: TBitmap; Clr1, Clr2: byte);
var X, Y, TX, OX, OX2: integer; ClrOUT, ClrMain: TColor; PXT, PXO: PByteArray;
begin

// Bmp.PixelFormat:=pf8bit;
 PXT:=Bmp.ScanLine[0];
 PXT[0]:=Clr1;
 ClrMain:=Bmp.Canvas.Pixels[0,0];
 PXT[0]:=Clr2;
 ClrOUT:=Bmp.Canvas.Pixels[0,0];

 for Y:=0 to Bmp.Height-1 do
 begin
  PXT:=Bmp.ScanLine[Y];
  X:=1;
   TX:=PXT[X];
   if (TX=Clr1) then
      begin
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end;
   X:=Bmp.Width-1;
   TX:=PXT[X];
   if (TX=Clr1) then
      begin
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end;
  end;

 for X:=0 to Bmp.Width-1 do
 begin
  Y:=0;
  PXT:=Bmp.ScanLine[Y];
   TX:=PXT[X];
   if (TX=Clr1) then
      begin
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end;
  Y:=Bmp.Height-1;
  PXT:=Bmp.ScanLine[Y];
   TX:=PXT[X];
   if (TX=Clr1) then
      begin
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end;
  end;

end;

procedure TGlyphForm.EdgeFill(Bmp:TBitmap);
var X, Y, TX, OX, OX2: integer; ClrOUT, ClrMain: TColor; PXT, PXO: PByteArray;
begin

// Bmp.PixelFormat:=pf8bit;
 PXT:=Bmp.ScanLine[0];
 PXT[0]:=CLR_MASK_MAIN;
 ClrMain:=Bmp.Canvas.Pixels[0,0];
 PXT[0]:=CLR_MASK_OUT;
 ClrOUT:=Bmp.Canvas.Pixels[0,0];

 for Y:=1 to Bmp.Height-1 do
 begin
  PXT:=Bmp.ScanLine[Y];
  PXO:=Bmp.ScanLine[Y-1];
  for X:=1 to Bmp.Width-1 do
  begin TX:=PXT[X]; OX:=PXO[X]; OX2:=PXT[X-1];
   if (TX=CLR_MASK_MAIN) then
      if ( ((OX=CLR_MASK_OUT) or (OX=CLR_MASK_NONE)) 
      or ((OX2=CLR_MASK_OUT) or (OX2=CLR_MASK_NONE))) then
      begin
//       PXT[X]:=CLR_MASK_OUT;
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end
  end;
 end;
 for Y:=Bmp.Height-2 downto 0 do
 begin
  PXT:=Bmp.ScanLine[Y];
  PXO:=Bmp.ScanLine[Y+1];
  for X:=Bmp.Width-2 downto 0 do
  begin
   TX:=PXT[X]; OX:=PXO[X]; OX2:=PXT[X+1];
   if (TX=CLR_MASK_MAIN) and
      ( ((OX=CLR_MASK_OUT) or (OX=CLR_MASK_NONE)) or
        ((OX2=CLR_MASK_OUT) or (OX2=CLR_MASK_NONE))) then
      begin
//       PXT[X]:=CLR_MASK_OUT;
         Bmp.Canvas.Brush.Color:=ClrOUT;
         Bmp.Canvas.FloodFill(X,Y,ClrMain,fsSurface);
      end
  end;
 end;

end;

procedure TGlyphForm.MatchToOutline(BmpT, BmpO: TBitmap; Distance: integer);
var X,Y, YD, XD:integer; PXT, PXO, PYO: PByteArray;
    TX, OX, OX2: byte;
    MatchLeft, MatchRight: boolean;
    MatchTop, MatchBottom: boolean;



{function GetDir(XD,YD: integer):byte;
begin
 Result:=0; //for X=0 Y=0
      if (XD=0) and (YD>0) then Result:=1
 else if (XD>0) and (YD>0) then Result:=2
 else if (XD>0) and (YD=0) then Result:=3
 else if (XD>0) and (YD<0) then Result:=4
 else if (XD=0) and (YD<0) then Result:=5
 else if (XD<0) and (YD<0) then Result:=6
 else if (XD<0) and (YD=0) then Result:=7
 else if (XD<0) and (YD>0) then Result:=8;
end;
}
function FullOutlineSearch(X1,Y1,Distance: integer; Bmp: TBitmap):boolean;
var PXX: PByteArray;
    i, X,Y, W, H: integer;
    HasMatch: array[0..8] of boolean;
begin
 for i:=0 to 8 do HasMatch[i]:=false;
 W:=Bmp.Width;
 H:=Bmp.Height;

 HasMatch[7]:=MatchLeft;
 HasMatch[3]:=MatchRight;
 HasMatch[5]:=MatchTop;
 HasMatch[1]:=MatchBottom;

 for Y:=Max(0,(Y1-Distance)) to Max(0,Y1-1) do
 begin
  PXX:=Bmp.ScanLine[Y];
  if not(HasMatch[8]) then
   for X:=Max(0,(X1-Distance)) to Max(0,X1-1) do
    if PXX[X]=CLR_MASK_MAIN then begin HasMatch[8]:=true; break; end;
  if not(HasMatch[2]) then
   for X:=Min(W-1,(X1+1)) to Min(W-1,X1+Distance) do
    if PXX[X]=CLR_MASK_MAIN then begin HasMatch[2]:=true; break; end;
  if (HasMatch[2] and HasMatch[8]) then break;  
 end;

 for Y:=Min(H-1,(Y1+1)) to Min(H-1,Y1+Distance) do
 begin
  PXX:=Bmp.ScanLine[Y];
  if not(HasMatch[6]) then
   for X:=Max(0,(X1-Distance)) to Max(0,X1-1) do
    if PXX[X]=CLR_MASK_MAIN then begin HasMatch[6]:=true; break; end;
  if not(HasMatch[4]) then
   for X:=Min(W-1,(X1+1)) to Min(W-1,X1+Distance) do
    if PXX[X]=CLR_MASK_MAIN then begin HasMatch[4]:=true; break; end;
  if (HasMatch[4] and HasMatch[6]) then break;
 end;
 
// Min(Bmp.Width-1,X1+Distance)
 Result:=(HasMatch[4] and HasMatch[8]) or (HasMatch[6] and HasMatch[2])
      or (HasMatch[7] and HasMatch[3]) or (HasMatch[5] and HasMatch[1]);

end;

begin

// EdgeLine(BmpT);
// EdgeFill(BmpT);
 for Y:=0 to BmpT.Height-1 do
 begin
  PXT:=BmpT.ScanLine[Y];
  PXO:=BmpO.ScanLine[Y];
  for X:=0 to BmpT.Width-1 do
  begin
   TX:=PXT[X];
   OX:=PXO[X];
   if (TX = CLR_MASK_MAIN) then
    if not(OX = CLR_MASK_MAIN) then //if not "intersects" with outline
    begin
     MatchRight:=false;
     MatchLeft:=false;
     for XD:=Max(0,X-Distance) to X do //Min(X+Distance,BmpT.Width-1) do
      if (PXO[XD]=CLR_MASK_MAIN) then begin MatchLeft:=True; break; end;
     for XD:=X to Min(X+Distance,BmpT.Width-1) do
      if (PXO[XD]=CLR_MASK_MAIN) then begin MatchRight:=True; break; end;
     if not(MatchLeft and MatchRight) then// PXT[X]:=CLR_MASK_DBL
     begin
      MatchTop:=false; MatchBottom:=false;
      for YD:=Max(0,Y-Distance) to Y do
      begin
       PYO := BmpO.ScanLine[YD];
       if (PYO[X]=CLR_MASK_MAIN) then
       begin MatchTop:=True; break; end;
      end;
      for YD:=Y to Min(Y+Distance, BmpT.Height-1) do
      begin
       PYO := BmpO.ScanLine[YD];
       if (PYO[X]=CLR_MASK_MAIN) then begin MatchBottom:=True; break; end;
      end;
      if not(MatchTop and MatchBottom) then //nothing on top and bottom
       if not(FullOutlineSearch(X,Y,Distance,BmpO)) then //perform full search
       PXT[X]:=CLR_MASK_OUT;
     end;
    end;
  end;
 end;
{  if (PX2[X]=255) then PX2[X]:=CLR_MASK_MAIN;
  if (PX2[X]=254) then PX2[X]:=CLR_MASK_DBL;
  if (PX2[X]=128) then PX2[X]:=CLR_MASK_OUT;
  if (PX2[X]=0) then PX2[X]:=CLR_MASK_NONE;}
//if sbPostEdgeFill.Down then EdgeFill(BmpT);
{begin
 X:=StrToIntDef(edPostEdgeFillCtr.Text,3);
 for Y:=1 to X do EdgeFill(BmpT);{ EdgeFill(BmpT); EdgeFill(BmpT);}
{end;} 

end;


procedure TGlyphForm.btLoadClick(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
 begin
  OpenBitmap(OpenPictureDialog1.FileName);
  CurrentOCRLine:=-1;
{  ImageOrig.Picture.Bitmap.LoadFromFile(OpenPictureDialog1.FileName);
  ImageOrig.Picture.Bitmap.PixelFormat:=pf24bit;

  ImageOrig.Height:=ImageOrig.Picture.Bitmap.Height;
  ImageOrig.Width:=ImageOrig.Picture.Bitmap.Width;

  ReAlign;
  ClearIgnores;

  if sbQuarterPel.Down then btQuarterPelClick(Sender);}
 end;
end;

procedure TGlyphForm.OpenBitmap(FileName:string);
var s: string;
begin

  ImageOrig.Picture.Bitmap.LoadFromFile(FileName);

  ClearIgnores;
  SetLength(MatchedAreas,0);

  ImageOrig.Picture.Bitmap.PixelFormat:=pf24bit;

  s:=ChangeFileExt(FileName,'.ign');
  if (FileExists(s)) then LoadIgnorePoints(s);


  ImageOrig.Height:=ImageOrig.Picture.Bitmap.Height;
  ImageOrig.Width:=ImageOrig.Picture.Bitmap.Width;

  ReAlign;

  DisableMaskUpdate:=true;

  if sbQuarterPel.Down then btQuarterPelClick(Self);
  if sbAutoColorAnalyzis.Down then btAnalyzeClick(Self)
  else btBuildMasksXClick(Self);
  if UpdateTimer.Enabled then
  begin
   DisableMaskUpdate:=false;
//   UpdateTimerTimer(UpdateTimer);
   UpdateTimerTimer(Self);
  end;
//  if sbAutoOCR.Down and (CurrentOCRLine>=0) then btAddGlyphs.Click;
  if sbAutoOCR.Down then btAddGlyphs.Click;

  DisableMaskUpdate:=false;

end;

procedure TGlyphForm.SetBitmap;
begin

  ImageOrig.Picture.Bitmap.Assign(Bmp);

  ClearIgnores;
  SetLength(MatchedAreas,0);

  ImageOrig.Picture.Bitmap.PixelFormat:=pf24bit;

  ImageOrig.Height:=ImageOrig.Picture.Bitmap.Height;
  ImageOrig.Width:=ImageOrig.Picture.Bitmap.Width;

  ReAlign;

  DisableMaskUpdate:=true;

  if sbQuarterPel.Down then btQuarterPelClick(Self);
  ReAlign;
  if sbAutoColorAnalyzis.Down then btAnalyzeClick(Self);
{  if UpdateTimer.Enabled then
  begin
   DisableMaskUpdate:=false;
   UpdateTimerTimer(Self);
  end;
//  if sbAutoOCR.Down and (CurrentOCRLine>=0) then btAddGlyphs.Click;
  if sbAutoOCR.Down then btAddGlyphs.Click;}

  DisableMaskUpdate:=false;
end;

procedure TGlyphForm.ReAlign;
begin


        ImageOrig.AutoSize:=false;
        ImageOrig.Stretch:=true;
        ImageMask2.Stretch:=true;
        ImageMask3.Stretch:=true;
        ImageMask4.Stretch:=true;
        ImageMask5.Stretch:=true;

case cmbZoom.ItemIndex and $FF of
 0..4:  begin
        ImageOrig.Height:=Round(scrlImages.Height/(cmbZoom.ItemIndex+1))-20;
        ImageOrig.Width:=Trunc(ImageOrig.Picture.Width*ImageOrig.Height/ImageOrig.Picture.Height);//Trunc(scrlImages.Height/4-5);
        end;
 5:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height div 8;
        ImageOrig.Width:=ImageOrig.Picture.Width div 8;
     end;
 6:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height div 4;
        ImageOrig.Width:=ImageOrig.Picture.Width div 4;
     end;
 7:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height div 2;
        ImageOrig.Width:=ImageOrig.Picture.Width div 2;
     end;
 8:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height;
        ImageOrig.Width:=ImageOrig.Picture.Width;
     end;
 9:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height*2;
        ImageOrig.Width:=ImageOrig.Picture.Width*2;
     end;
 10:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height*4;
        ImageOrig.Width:=ImageOrig.Picture.Width*4;
     end;
 11:  begin
        ImageOrig.Height:=ImageOrig.Picture.Height*8;
        ImageOrig.Width:=ImageOrig.Picture.Width*8;
     end;
//5  Zoom: x1/8
//6  Zoom: x1/4
//7  Zoom: x1/2
//8  Zoom: x1
//9  Zoom: x2
//10 Zoom: x4
//11 Zoom: x8

end;
{
if sbFitToScreen.Down then
begin
 ImageOrig.AutoSize:=false;
 ImageOrig.Stretch:=true;
 ImageMask2.Stretch:=true;
 ImageMask3.Stretch:=true;
 ImageMask4.Stretch:=true;
 ImageMask5.Stretch:=true;
// ImageOrig.Width:=scrlImages.Width-40;
// ImageOrig.Height:=Trunc(ImageOrig.Picture.Height*(scrlImages.Width-40)/ImageOrig.Picture.Width);//Trunc(scrlImages.Height/4-5);
 ImageOrig.Height:=Round(scrlImages.Height/3)-20;
 ImageOrig.Width:=Trunc(ImageOrig.Picture.Width*ImageOrig.Height/ImageOrig.Picture.Height);//Trunc(scrlImages.Height/4-5);
end;
if sbFitNormal.Down then
begin
 ImageOrig.Stretch:=false;
 ImageMask2.Stretch:=false;
 ImageMask3.Stretch:=false;
 ImageMask4.Stretch:=false;
 ImageMask5.Stretch:=false;
 ImageOrig.AutoSize:=true;
end;
if sbFitMagnify4.Down then
begin
 ImageOrig.AutoSize:=false;
 ImageOrig.Stretch:=true;
 ImageMask2.Stretch:=true;
 ImageMask3.Stretch:=true;
 ImageMask4.Stretch:=true;
 ImageMask5.Stretch:=true;
 ImageOrig.Height:=ImageOrig.Picture.Height*4;
 ImageOrig.Width:=ImageOrig.Picture.Width*4;
end;
if sbFitQuarter.Down then
begin
 ImageOrig.AutoSize:=false;
 ImageOrig.Stretch:=true;
 ImageMask2.Stretch:=true;
 ImageMask3.Stretch:=true;
 ImageMask4.Stretch:=true;
 ImageMask5.Stretch:=true;
 ImageOrig.Height:=ImageOrig.Picture.Height div 4;
 ImageOrig.Width:=ImageOrig.Picture.Width div 4;
end;}

 if ImageOrig.Width>0 then XFactor:=ImageOrig.Picture.Width/ImageOrig.Width;
 if ImageOrig.Height>0 then YFactor:=ImageOrig.Picture.Height/ImageOrig.Height;
{  ImageMask1.Top:=ImageOrig.BoundsRect.Bottom+5;
  ImageMask1.Height:=ImageOrig.Height;
  ImageMask1.Width:=ImageOrig.Width;}
  ImageOrig.Visible:=true;

  ImageMask3.Top:=ImageOrig.BoundsRect.Bottom+5;//ImageMask1.BoundsRect.Bottom+5;
  ImageMask3.Height:=ImageOrig.Height;
  ImageMask3.Width:=ImageOrig.Width;

  ImageMask3.Visible:=true;


  ImageMask2.Top:=ImageMask3.BoundsRect.Bottom+5;
  ImageMask2.Height:=ImageOrig.Height;
  ImageMask2.Width:=ImageOrig.Width;
  ImageMask2.Visible:=true;

  ImageMask4.Top:=ImageMask2.BoundsRect.Bottom+5;
  ImageMask4.Height:=ImageOrig.Height;
  ImageMask4.Width:=ImageOrig.Width;

  ImageMask5.Top:=ImageMask4.BoundsRect.Bottom+5;
  ImageMask5.Height:=ImageOrig.Height;
  ImageMask5.Width:=ImageOrig.Width;

  Mask1Bitmap.PixelFormat:=pf8bit;
  Mask1Bitmap.Height:=ImageOrig.Picture.Height;
  Mask1Bitmap.Width:=ImageOrig.Picture.Width;

end;

procedure TGlyphForm.ImageOrigMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var PX:PByteArray; LastSelected, i: integer; Found: boolean;
begin
// Image2.Picture.Bitmap:=CheckMainColor(X,Y,30,30,30,2,Image3.Picture.Bitmap);
 if (Button = mbLeft) or (Button = mbRight) then
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  RT:=PX[X*3+2];  GT:=PX[X*3+1];  BT:=PX[X*3];
//  edRT.Text:=IntToStr(RT);  edGT.Text:=IntToStr(GT);  edBT.Text:=IntToStr(BT);
  LastSelected:=ColorDomSelected;
  if (ssShift in Shift) then
  begin
    SetLength(ColorDoms,Length(ColorDoms)+1);
    ColorDomSelected:=Length(ColorDoms)-1;
  end
  else if (Button = mbRight) and not(ColorDoms[ColorDomSelected].ColorType=ctSkinOutline) then
  begin
   Found:=false;
   for i:=0 to Length(ColorDoms)-1 do
    if ColorDoms[i].ColorType=ctSkinOutline then
    begin
     Found:=true; break;
    end;
   if Found then ColorDomSelected:=i else
   begin
    SetLength(ColorDoms,Length(ColorDoms)+1);
    ColorDomSelected:=Length(ColorDoms)-1;
   end;
  end; 
  ColorDoms[ColorDomSelected].R:=RT;
  ColorDoms[ColorDomSelected].G:=GT;
  ColorDoms[ColorDomSelected].B:=BT;
  ColorDoms[ColorDomSelected].RD:=ColorDoms[LastSelected].RD;
  ColorDoms[ColorDomSelected].GD:=ColorDoms[LastSelected].GD;
  ColorDoms[ColorDomSelected].BD:=ColorDoms[LastSelected].BD;
  if (Button = mbLeft) then ColorDoms[ColorDomSelected].ColorType:=ctBoneText
  else  ColorDoms[ColorDomSelected].ColorType:=ctSkinOutline;
  UpdateColorDominator;

  btBuildMasksClick(Sender);
{  CheckMainColor(RT,GT,BT,
                 StrToIntDef(edRD.Text,30),
                StrToIntDef(edGD.Text,30),
                StrToIntDef(edBD.Text,30),
                2,ImageOrig.Picture.Bitmap,ImageMask1.Picture.Bitmap);}
 end;
{ if (Button = mbRight) then
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  RO:=PX[X*3+2];  GO:=PX[X*3+1];  BO:=PX[X*3];
  edRO.Text:=IntToStr(RO);  edGO.Text:=IntToStr(GO);  edBO.Text:=IntToStr(BO);
  btBuildMasksClick(Sender);
 end;}
{ ImageMask1.Invalidate;
 ImageMask2.Invalidate;}
end;

function GetParam1(str: string):string;
var x1, x2: integer;
begin
   x1:=Pos('[',str)+1;
   x2:=Pos(']',str);
   Result:=Copy(Str,x1,x2-x1);
end;

function GetParam2(str: string):string;
var x1, x2: integer;
begin
   x1:=Pos('(',str)+1;
   x2:=Pos(')',str);
   Result:=Copy(Str,x1,x2-x1);
end;

const
CMD_TEXTMASK = 1;
CMD_OUTLINEMASK = 2;
CMD_OPENBLASTTEXT = 3;
CMD_EDGEFILLOUTLINE = 4;
CMD_ELIMINATEMINORTEXT =5;
CMD_OUTLINETEXT = 6;
CMD_OUTLINEOUTLINE = 7;
CMD_MATCH_TO_OUTLINE = 8;
CMD_GROW_TEXT = 9;
CMD_GROW_OUTLINE = 10;
CMD_SUBTRACT_OUTLINE = 11;
CMD_EDGELINETEXT = 12;
CMD_IGNOREFILLTEXT = 13;
//CMD_IGNORELINETEXT = 14;
CMD_IGNOREFILLOUTLINE = 14;
CMD_DIFFMASK = 15;
CMD_GROW_DIFFMASK = 16;
CMD_REVERSE_SUBTRACT_DIFFMASK = 17;

procedure TGlyphForm.btBuildMasksXClick(Sender: TObject);
var i:integer; FirstRun: boolean;

procedure DoFunction(Func: byte; Param: integer = 0);
var i:integer;
begin
 case Func of
  CMD_ELIMINATEMINORTEXT: EliminateMinor(Mask1Bitmap);
  CMD_TEXTMASK:
     begin
      FirstRun:=true;
      for i:=0 to Length(ColorDoms)-1 do
      if ColorDoms[i].ColorType=ctBoneText then
      begin
       with ColorDoms[i] do
       CheckMainColor(R,G,B,RD,GD,BD,
                2,ImageOrig.Picture.Bitmap,Mask1Bitmap, FirstRun); //"text"
       FirstRun:=false;
      end;
     end;
  CMD_DIFFMASK:
     begin
      CreateDiffMap2(Param mod 1000,Param mod 1000,Param mod 1000, ImageOrig.Picture.Bitmap,MaskDiffBitmap, Param div 1000, true);
      //DiffMask
     end;
  CMD_REVERSE_SUBTRACT_DIFFMASK: ReverseSubtractMasks(Mask1Bitmap,MaskDiffBitmap,CLR_MASK_OUT);//if sbGrowOutlineMatch.Down then
  CMD_OUTLINEMASK: begin
     FirstRun:=true;
     for i:=0 to Length(ColorDoms)-1 do
     if ColorDoms[i].ColorType=ctSkinOutline then
     begin
      with ColorDoms[i] do
     CheckMainColor(R,G,B,RD,GD,BD,
                2,ImageOrig.Picture.Bitmap,Mask2Bitmap, FirstRun); //"text"
     FirstRun:=false;
    end;
    for i:=0 to Length(ColorDoms)-1 do
    if ColorDoms[i].ColorType=ctDiffOutline then
    begin
     with ColorDoms[i] do
      CreateDiffMap(RD,GD,BD,
                 ImageOrig.Picture.Bitmap,Mask2Bitmap, FirstRun); //"text"
      FirstRun:=false;
     end;
    end;
  CMD_GROW_TEXT: //grow text
  for i:=1 to Param{StrToIntDef(edGrowText.Text,0)} do
   OutlineColorWith(Mask1Bitmap,CLR_MASK_MAIN,CLR_MASK_MAIN);
  CMD_GROW_OUTLINE: //if sbGrowOutlineMatch.Down then
    for i:=1 to Param{StrToIntDef(edGrowOutline.Text,0)} do
     OutlineColorWith(Mask2Bitmap,CLR_MASK_MAIN,CLR_MASK_MAIN);
  CMD_GROW_DIFFMASK: //if sbGrowOutlineMatch.Down then
    for i:=1 to Param{StrToIntDef(edGrowOutline.Text,0)} do
     OutlineColorWith(MaskDiffBitmap,CLR_MASK_MAIN,CLR_MASK_MAIN);
  CMD_OUTLINETEXT:  OutlineMainDouble(Mask1Bitmap);
  CMD_OUTLINEOUTLINE: OutlineMainDouble(Mask2Bitmap);
  CMD_IGNOREFILLTEXT: begin
     DoIgnoreLines(Mask1Bitmap, TextIgnoreLine);
     DoIgnoreFill(Mask1Bitmap, TextIgnore);
     end;
  CMD_IGNOREFILLOUTLINE: DoIgnoreFill(Mask2Bitmap, OutlineIgnore);
  CMD_OPENBLASTTEXT: //  if sbFillOuterOutline.Down then
     EdgeFill(Mask1Bitmap);
//     EdgeFill(Mask1Bitmap,CLR_MASK_NONE,CLR_MASK_MAIN);
  CMD_EDGELINETEXT: EdgeLine(Mask1Bitmap);
  CMD_EDGEFILLOUTLINE:
   EdgeFill(Mask2Bitmap,CLR_MASK_NONE,CLR_MASK_MAIN);
  CMD_MATCH_TO_OUTLINE:
   begin
     MatchToOutline(Mask1Bitmap,Mask2Bitmap,Param
                    {StrToIntDef(edMatchDistance.Text,40)});
     {if sbPostEdgeFill.Down then}EdgeFill(Mask1Bitmap);
   end;
  CMD_SUBTRACT_OUTLINE: SubtractMasks(Mask1Bitmap,Mask2Bitmap);
   
 end;
end;

var str: string;
    x1, x2, Param1, Param2: integer;

label SHOW_MASKS, REPEAT_BUILDMASKS;    

begin
REPEAT_BUILDMASKS:
 btBuildMasksX.Caption:='Build Masks';

 if (ImageOrig.Picture.Bitmap.Width<10) then exit;
{  CLR_MASK_MAIN := StrToIntDef(edCLR_MAIN.Text, 15);  CLR_MASK_DBL := StrToIntDef(edCLR_DBL.Text, 16);
  CLR_MASK_OUT := StrToIntDef(edCLR_OUT.Text, 16);  CLR_MASK_NONE := StrToIntDef(edCLR_NONE.Text, 11);}
{  RDO:=StrToIntDef(edRDO.Text,30);  GDO:=StrToIntDef(edGDO.Text,30);  BDO:=StrToIntDef(edBDO.Text,30);
  RO:=StrToIntDef(edRO.Text,0);  GO:=StrToIntDef(edGO.Text,0);  BO:=StrToIntDef(edBO.Text,0);}

  RDT:=StrToIntDef(edRDT.Text,30);
  GDT:=StrToIntDef(edGDT.Text,30);
  BDT:=StrToIntDef(edBDT.Text,30);

  RT:=StrToIntDef(edRT.Text,255);
  GT:=StrToIntDef(edGT.Text,255);
  BT:=StrToIntDef(edBT.Text,255);

  Mask2Bitmap.PixelFormat:=pf8bit;
  Mask2Bitmap.Width:=Mask1Bitmap.Width;
  Mask2Bitmap.Height:=Mask1Bitmap.Height;
  MaskDiffBitmap.PixelFormat:=pf8bit;
  MaskDiffBitmap.Width:=Mask1Bitmap.Width;
  MaskDiffBitmap.Height:=Mask1Bitmap.Height;
{  CheckMainColor(RO,GO,BO, RDO, GDO, BDO,2,ImageOrig.Picture.Bitmap,ImageMask2.Picture.Bitmap); //outline
  CheckMainColor(RT,GT,BT,RDT,GDT,BDT,2,ImageOrig.Picture.Bitmap,ImageMask1.Picture.Bitmap); //"text"}
{  DoFunction(0);   SetProgress(10);  DoFunction(1);   SetProgress(20);  DoFunction(4);   SetProgress(20);}

  for i:=0 to clbBuildMaskList.Items.Count-1 do
  if clbBuildMaskList.Checked[i] then
  begin
   SetProgress(i/clbBuildMaskList.Items.Count*50);
   Str:=GetParam1(clbBuildMaskList.Items[i]);
   Param1:=StrToIntDef(Str,0);
   Str:=GetParam2(clbBuildMaskList.Items[i]);
   Param2:=StrToIntDef(Str,0);

   DoFunction(Param1, Param2);
  end;
//  Goto SHOW_MASKS;
//SHOW_MASKS:

   MaskToBitmap(Mask2Bitmap,ImageMask2.Picture.Bitmap);
   MaskToBitmap(Mask1Bitmap,ImageMask3.Picture.Bitmap);
   
   SetProgress(50);


//  CreateGlyphRects(ImageMask1.Picture.Bitmap);
  CreateGlyphRects(Mask1Bitmap);
  SortGlyphRects;
{  OverlapMasks(ImageMask1.Picture.Bitmap,ImageMask2.Picture.Bitmap,
               ImageMask3.Picture.Bitmap);}
   SetProgress(90);


  Mask3Bitmap.Assign(Mask1Bitmap);

// ImageMask1.Invalidate;
// ImageMask2.Picture.Bitmap.Assign(Mask2Bitmap);
// ImageMask3.Picture.Bitmap.Assign(Mask3Bitmap);
//  MaskToBitmap(Mask2Bitmap,ImageMask2.Picture.Bitmap);

  ImageMask3.Picture.Bitmap.Canvas.Pen.Mode:=pmNot;
  ImageMask3.Picture.Bitmap.Canvas.Pen.Color:=clBlack;

  ImageMask3.Picture.Bitmap.Canvas.Brush.Color:=clWhite;

  Mask3Bitmap.Canvas.Brush.Color:=clWhite;

 for i:=0 to Length(GlyphRects)-1 do
 begin
//  if i=GlyphSelected then ImageMask3.Picture.Bitmap.Canvas.Brush.Color:=clBlack
//  else ImageMask3.Picture.Bitmap.Canvas.Brush.Color:=clWhite;
//  ImageMask3.Picture.Bitmap.Canvas.FrameRect(GlyphRects[i]);
  Mask3Bitmap.Canvas.FrameRect(GlyphRects[i]);
 end;

 MaskToBitmap(Mask3Bitmap,ImageMask3.Picture.Bitmap);
 MaskToBitmap(MaskDiffBitmap,ImageMask5.Picture.Bitmap);
 ImageMask5.Visible:=true;

 ImageMask3.Picture.Bitmap.Canvas.Brush.Color:=clWhite;
 for i:=0 to Length(GlyphRects)-1 do
  ImageMask3.Picture.Bitmap.Canvas.FrameRect(GlyphRects[i]);

 SetProgress(100);


 ImageMask2.Update;
 ImageMask3.Update;

 if sbEliminateOutsideOfBand.Down then
 if CheckBaseBands then goto REPEAT_BUILDMASKS;
 SetProgress(0);

end;

procedure TGlyphForm.btQuarterPelClick(Sender: TObject);
var X,Y:integer; Bmp:TBitmap; PX, PXR, PX1, PX2, PX3, PX4: PByteArray;
    R,G,B: byte;
begin
 Bmp:=TBitmap.Create;

// for R:=0 to 255 do for G:=0 to 255 do for B:=0 to 255 do FullColorMap[R,G,B]:=0;

 Bmp.Width:=ImageOrig.Picture.Bitmap.Width*4-3;
 Bmp.Height:=ImageOrig.Picture.Bitmap.Height*4-3;
 Bmp.PixelFormat:=pf24bit;

 //horizontal interpolation
 for Y:=0 to ImageOrig.Picture.Bitmap.Height-1 do
 begin
  PXR:=Bmp.ScanLine[Y*4];
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to ImageOrig.Picture.Bitmap.Width-2 do
  begin
   PXR[(X*4)*3+2]:=PX[X*3+2];
   PXR[(X*4)*3+1]:=PX[X*3+1];
   PXR[(X*4)*3]:=PX[X*3];


   PXR[(X*4+1)*3+2]:=Min(255,Round(PX[X*3+2]*0.75 + PX[(X+1)*3+2]*0.25));
   PXR[(X*4+1)*3+1]:=Min(255,Round(PX[X*3+1]*0.75 + PX[(X+1)*3+1]*0.25));
   PXR[(X*4+1)*3+0]:=Min(255,Round(PX[X*3+0]*0.75 + PX[(X+1)*3+0]*0.25));

   PXR[(X*4+2)*3+2]:=Min(255,Round(PX[X*3+2]*0.5 + PX[(X+1)*3+2]*0.5));
   PXR[(X*4+2)*3+1]:=Min(255,Round(PX[X*3+1]*0.5 + PX[(X+1)*3+1]*0.5));
   PXR[(X*4+2)*3+0]:=Min(255,Round(PX[X*3+0]*0.5 + PX[(X+1)*3+0]*0.5));

   PXR[(X*4+3)*3+2]:=Min(255,Round(PX[X*3+2]*0.25 + PX[(X+1)*3+2]*0.75));
   PXR[(X*4+3)*3+1]:=Min(255,Round(PX[X*3+1]*0.25 + PX[(X+1)*3+1]*0.75));
   PXR[(X*4+3)*3+0]:=Min(255,Round(PX[X*3+0]*0.25 + PX[(X+1)*3+0]*0.75));

//   Inc(FullColorMap[PXR[(X*4+3)*3+2],PXR[(X*4+3)*3+1],PXR[(X*4+3)*3]]);
//   Inc(FullColorMap[PXR[(X*4+2)*3+2],PXR[(X*4+2)*3+1],PXR[(X*4+2)*3]]);
//   Inc(FullColorMap[PXR[(X*4+1)*3+2],PXR[(X*4+1)*3+1],PXR[(X*4+1)*3]]);
//   Inc(FullColorMap[PXR[(X*4+0)*3+2],PXR[(X*4+0)*3+1],PXR[(X*4+0)*3]]);
  end;
 end;


 for Y:=0 to ImageOrig.Picture.Bitmap.Height-2 do
 begin
  PX:=Bmp.ScanLine[Y*4];
  PX1:=Bmp.ScanLine[(Y+1)*4];
  PX2:=Bmp.ScanLine[Y*4+1];
  PX3:=Bmp.ScanLine[Y*4+2];
  PX4:=Bmp.ScanLine[Y*4+3];
  for X:=0 to Bmp.Width-1 do
  begin

   PX2[X*3+2]:=Min(255,Round(PX[X*3+2]*0.75 + PX1[X*3+2]*0.25));
   PX2[X*3+1]:=Min(255,Round(PX[X*3+1]*0.75 + PX1[X*3+1]*0.25));
   PX2[X*3+0]:=Min(255,Round(PX[X*3+0]*0.75 + PX1[X*3+0]*0.25));

   PX3[X*3+2]:=Min(255,Round(PX[X*3+2]*0.5 + PX1[X*3+2]*0.5));
   PX3[X*3+1]:=Min(255,Round(PX[X*3+1]*0.5 + PX1[X*3+1]*0.5));
   PX3[X*3+0]:=Min(255,Round(PX[X*3+0]*0.5 + PX1[X*3+0]*0.5));

   PX4[X*3+2]:=Min(255,Round(PX[X*3+2]*0.25 + PX1[X*3+2]*0.75));
   PX4[X*3+1]:=Min(255,Round(PX[X*3+1]*0.25 + PX1[X*3+1]*0.75));
   PX4[X*3+0]:=Min(255,Round(PX[X*3+0]*0.25 + PX1[X*3+0]*0.75));

//   Inc(FullColorMap[PX2[X*3+2],PX2[X*3+1],PX2[X*3]]);
//   Inc(FullColorMap[PX3[X*3+2],PX3[X*3+1],PX3[X*3]]);
//   Inc(FullColorMap[PX4[X*3+2],PX4[X*3+1],PX4[X*3]]);
  end;

 end;
 //full color map created

 ImageOrig.Picture.Bitmap.Assign(Bmp);
 Bmp.Free;
 ReAlign;

 if not DisableMaskUpdate then btBuildMasksClick(Sender);

end;

procedure TGlyphForm.ImageMaskXMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Num:integer;
begin
 if Button = mbLeft then
 begin
  if not(ssShift in Shift) then
  AddTextIgnorePoint(Point(X,Y))
  else AddTextIgnoreLine(Point(X,Y));
   btBuildMasksClick(Sender);
 end;
 if Button = mbRight then
 begin
 
  if not(ssShift in Shift) then
  begin
   Num:=FindNearestPoint(X,Y,TextIgnore);
   DeleteTextIgnorePoint(Num);
  end
  else
  begin
   Num:=FindNearestPoint(X,Y,TextIgnoreLine);
   DeleteTextIgnoreLine(Num);
  end;
  btBuildMasksClick(Sender);
 end;
end;

procedure TGlyphForm.DoIgnoreFill;
var i:integer; Clx: TColor;
begin
 for i:=0 to Length(Arr)-1 do
 begin
  Bmp.Canvas.Brush.Color:=CLRX_MASK_IGNORE;//clGray;
  Clx:=Bmp.Canvas.Pixels[Arr[i].X,Arr[i].Y];
//  Bmp.Canvas.FloodFill(TextIgnore[i].X, TextIgnore[i].Y, CLR_MASK_MAIN, fsSurface);
  Bmp.Canvas.FloodFill(Arr[i].X, Arr[i].Y, Clx, fsSurface);
  Bmp.Canvas.Pen.Mode:=pmCopy;
  Bmp.Canvas.Pen.Color:=clBlack;
  Bmp.Canvas.Brush.Color:=clBlack;
  Bmp.Canvas.MoveTo(Arr[i].X-1,Arr[i].Y);
  Bmp.Canvas.LineTo(Arr[i].X+1,Arr[i].Y);
  Bmp.Canvas.MoveTo(Arr[i].X,Arr[i].Y+1);
  Bmp.Canvas.LineTo(Arr[i].X,Arr[i].Y-1);
 end;
end;

procedure TGlyphForm.DoIgnoreLines;
var i:integer; PX:PByteArray; {Clr: byte;}
begin
 Bmp.Canvas.Brush.Color:=clGray;
 Bmp.Canvas.Pen.Mode:=pmCopy;
 PX:=Bmp.ScanLine[0];
 PX[0]:=CLR_MASK_OUT;
 Bmp.Canvas.Pen.Color:=Bmp.Canvas.Pixels[0,0];//clBlack;

 for i:=0 to (Length(Arr) div 2)-1 do
 begin
//  Clx:=Bmp.Canvas.Pixels[Arr[i].X,Arr[i].Y];
  Bmp.Canvas.MoveTo(Arr[i*2].X,Arr[i*2].Y);
  Bmp.Canvas.LineTo(Arr[i*2+1].X,Arr[i*2+1].Y);

  //Cross at the ends
{  Bmp.Canvas.MoveTo(Arr[i*2].X-1,Arr[i*2].Y);
  Bmp.Canvas.LineTo(Arr[i*2].X+1,Arr[i*2].Y);
  Bmp.Canvas.MoveTo(Arr[i*2].X,Arr[i*2].Y+1);
  Bmp.Canvas.LineTo(Arr[i*2].X,Arr[i*2].Y-1);

  Bmp.Canvas.MoveTo(Arr[i*2+1].X-1,Arr[i*2+1].Y);
  Bmp.Canvas.LineTo(Arr[i*2+1].X+1,Arr[i*2+1].Y);
  Bmp.Canvas.MoveTo(Arr[i*2+1].X,Arr[i*2+1].Y+1);
  Bmp.Canvas.LineTo(Arr[i*2+1].X,Arr[i*2+1].Y-1);}

{  PX:=Bmp.ScanLine[Arr[i*2].Y];
  Clr := PX[Arr[i*2].X];}
 end;
{ for Y:=0 to Bmp.Height-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
   if PX[X]=Clr then PX[X]:=CLR_MASK_OUT;
 end;} 
end;

procedure TGlyphForm.ImageMask2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Num:integer;
begin
 if Button = mbLeft then
 begin
  AddOutlineIgnorePoint(Point(X,Y));
  btBuildMasksClick(Sender);
 end;
 if Button = mbRight then
 begin
  Num:=FindNearestPoint(X,Y,OutlineIgnore);
  DeleteOutlineIgnorePoint(Num);
  btBuildMasksClick(Sender);
 end;
end;



procedure TGlyphForm.ImageMask3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var Num: integer;
begin
{ if (Button = mbLeft) then
 begin
  GlyphSelected := FindGlyphRect(X,Y);
  btBuildMasksClick(Sender);
 end;
 if (Button = mbRight) and (GlyphSelected>-1) then
  begin
   CompareGlyphRects(GlyphSelected,FindGlyphRect(X,Y));
  end;}
 X:=Round(X*XFactor);
 Y:=Round(Y*YFactor);
 if Button = mbLeft then
 if (XL>=0) then
 begin
  if (X=XL) and (Y=YL) then
  begin
   if not(ssShift in Shift) then
   AddTextIgnorePoint(Point(X,Y))
   else AddTextIgnoreLine(Point(X,Y));
  end else
  begin
   AddTextIgnoreLine(Point(XL,YL));
   AddTextIgnoreLine(Point(X,Y));
   XL:=-1; YL:=-1;
  end;
 end;
 if Button = mbRight then
 begin

  if not(ssShift in Shift) then
  begin
   Num:=FindNearestPoint(X,Y,TextIgnore);
   DeleteTextIgnorePoint(Num);
  end
  else
  begin
   Num:=FindNearestPoint(X,Y,TextIgnoreLine);
   DeleteTextIgnoreLine(Num);
  end;
 end;
 if Sender<>nil then btBuildMasksClick(Sender)
 else GlyphRectsRemoved:=true;


end;

{procedure TGlyphForm.CompareGlyphRects(Num1, Num2: integer);
var X, Y, W, H,
    W1, H1, W2, H2, X1, X2, X3,
    OffsX, OffsY, ShiftLimit: integer;
    PX1, PX2, PX3: PByteArray;
    MatchingCtr, NonMatchingCtr,
    IgnoredCtr, IgnoredMatchCtr,
    BestMatch: integer;
    MaxMatchingCtr, MaxNonMatchingCtr,
    MaxIgnoredCtr, MaxIgnoredMatchCtr,
    MaxBestMatch: integer;
    MaxOffsX, MaxOffsY: integer;
    MinWNum, MinHNum: integer;
    MaxWNum, MaxHNum: integer;
    s: string;
begin
 if (Num1<0) or (Num2<0) then exit;
 W1:=GlyphRects[Num1].Right-GlyphRects[Num1].Left;
 W2:=GlyphRects[Num2].Right-GlyphRects[Num2].Left;
 W:=Min(W1, W2);
 H1:=GlyphRects[Num1].Bottom-GlyphRects[Num1].Top;
 H2:=GlyphRects[Num2].Bottom-GlyphRects[Num2].Top;
 H:=Min(H1,H2);
 if H1<H2 then
 begin
  MinHNum:=Num1;
  MaxHNum:=Num2;
 end
 else
 begin
  MinHNum:=Num2;
  MaxHNum:=Num1;
 end;
 if W1<W2 then begin
  MinWNum:=Num1;
  MaxWNum:=Num2;
 end
 else
 begin
  MinWNum:=Num2;
  MaxWNum:=Num1;
 end;

 MaxMatchingCtr:=0; MaxNonMatchingCtr:=0;
 MaxIgnoredCtr:=0;  MaxIgnoredMatchCtr:=0;
 MaxOffsX:=0; MaxOffsY:=0;
 for OffsY:=0 to abs(H1-H2) do
 for OffsX:=0 to abs(W1-W2) do
 begin
  MatchingCtr:=0; NonMatchingCtr:=0;
  IgnoredCtr:=0;  IgnoredMatchCtr:=0;
  for Y:=0 to H-1 do
  begin
//   PX1:=ImageMask3.Picture.Bitmap.ScanLine[Y+GlyphRects[Num1].Top];
//   PX2:=ImageMask3.Picture.Bitmap.ScanLine[Y+GlyphRects[Num2].Top];
   PX1:=Mask3Bitmap.ScanLine[Y+GlyphRects[MinHNum].Top];
   PX2:=Mask3Bitmap.ScanLine[Y+OffsY+GlyphRects[MaxHNum].Top];
   for X:=0 to W-1 do
   begin
//    if (PX1[X+OffsX+GlyphRects[Num1].Left]=CLR_MASK_MAIN)
//       and (PX2[X+GlyphRects[Num2].Left]=CLR_MASK_MAIN) then inc(MatchingCtr)
    X2:=X+OffsX+GlyphRects[MaxWNum].Left;
    X1:=X+GlyphRects[MinWNum].Left;
    if (PX1[X1]=CLR_MASK_MAIN)
       and (PX2[X2]=CLR_MASK_MAIN) then inc(MatchingCtr)
    else
//    if (PX1[X+GlyphRects[Num1].Left]=CLR_MASK_MAIN)
//       or (PX2[X+GlyphRects[Num2].Left]=CLR_MASK_MAIN) then inc(NonMatchingCtr)
    if (PX1[X1]=CLR_MASK_MAIN)
       or (PX2[X2]=CLR_MASK_MAIN) then inc(NonMatchingCtr)
    else
    begin
     if PX1[X1]=PX2[X2] then Inc(IgnoredMatchCtr);
     inc(IgnoredCtr);
    end;
   end;
  end;
  if (MaxMatchingCtr<MatchingCtr) then
  begin
   MaxMatchingCtr:=MatchingCtr;
   MaxNonMatchingCtr:=NonMatchingCtr;
   MaxIgnoredCtr:=IgnoredCtr;
   MaxIgnoredMatchCtr:=IgnoredMatchCtr;
   MaxOffsX:=OffsX;
   MaxOffsY:=OffsY;
  end;
 end;
 if not(MaxIgnoredCtr=0) then //exit;
 s:=Format('Matching: %d, Non-Matching: %d, Similarity: %f %%'#13#10' Ignored: %d, Matching Ignored: %d (%f %%)'#13#10'Offsets - X=%d Y=%d',
//             [MatchingCtr, NonMatchingCtr, MatchingCtr*100/(NonMatchingCtr+MatchingCtr),
//             IgnoredCtr, IgnoredMatchCtr, IgnoredMatchCtr/(IgnoredCtr)]));
             [MaxMatchingCtr, MaxNonMatchingCtr, MaxMatchingCtr*100/(MaxNonMatchingCtr+MaxMatchingCtr),
             MaxIgnoredCtr, MaxIgnoredMatchCtr, MaxIgnoredMatchCtr*100/(MaxIgnoredCtr),
             MaxOffsX, MaxOffsY]);
// ShowMessage(s);
// with SymbolMatchForm.ImageMatch1.Picture.Bitmap do
 with CompareBitmap1 do
 begin
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
  PixelFormat:=pf8bit;
  BitBlt(Canvas.Handle,0,0,Width+4,Height+4,Mask3Bitmap.Canvas.Handle,GlyphRects[Num1].Left-2,GlyphRects[Num1].Top-2,SRCCOPY);
 end;
// with SymbolMatchForm.ImageMatch2.Picture.Bitmap do
 with CompareBitmap2 do
 begin
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
  PixelFormat:=pf8bit;
  BitBlt(Canvas.Handle,0,0,Width+4,Height+4,Mask3Bitmap.Canvas.Handle,GlyphRects[Num2].Left-2,GlyphRects[Num2].Top-2,SRCCOPY);
 end;

// with SymbolMatchForm.ImageDiff1.Picture.Bitmap do
 with CompareBitmap3 do
 begin
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
  BitBlt(Canvas.Handle,0,0,Width+4,Height+4,Mask3Bitmap.Canvas.Handle,GlyphRects[MaxWNum].Left-2,GlyphRects[MaxWNum].Top-2,SRCCOPY);
  PixelFormat:=pf24bit;
  Canvas.Pen.Mode:=pmNot;
  Canvas.Brush.Color:=clBlue;
  for Y:=0 to H-1 do
  begin
   PX1:=Mask3Bitmap.ScanLine[Y+GlyphRects[MinHNum].Top];
   PX2:=Mask3Bitmap.ScanLine[Y+MaxOffsY+GlyphRects[MaxHNum].Top];
   PX3:=ScanLine[2+MaxOffsY+Y];

   for X:=0 to W-1 do
   begin
    X2:=X+MaxOffsX+GlyphRects[MaxWNum].Left;
    X1:=X+GlyphRects[MinWNum].Left;
    X3:=(X+MaxOffsX+2)*3;
    if (PX1[X1]=CLR_MASK_MAIN)
       and (PX2[X2]=CLR_MASK_MAIN) then begin PX3[X3]:=255; PX3[X3+1]:=255; PX3[X3+2]:=255; end
    else
    if (PX1[X1]=CLR_MASK_MAIN)
       or (PX2[X2]=CLR_MASK_MAIN) then begin PX3[X3]:=64*3; PX3[X3+1]:=64*3; PX3[X3+2]:=64*3; end
    else begin PX3[X3]:=64*1; PX3[X3+1]:=64*1; PX3[X3+2]:=64*1; end
   end;
  end;

  for Y:=1 to H-2 do
  begin
   PX3:=ScanLine[2+MaxOffsY+Y];
   PX1:=ScanLine[2+MaxOffsY+Y-1];
   PX2:=ScanLine[2+MaxOffsY+Y+1];
   for X:=1 to W-2 do
   begin
    X3:=(X+MaxOffsX+2)*3;
    X1:=(X-1+MaxOffsX+2)*3;
    X2:=(X+1+MaxOffsX+2)*3;
    if (PX3[X3]=64*3) then
    if (PX1[X3]=255) or (PX2[X3]=255) or (PX3[X1]=255) or (PX3[X2]=255) then
    begin PX3[X3]:=254; PX3[X3+1]:=254; PX3[X3+2]:=254; end;
   end;
  end;

  MatchingCtr:=0; NonMatchingCtr:=0;
  for Y:=0 to H-1 do
  begin
   PX3:=ScanLine[2+MaxOffsY+Y];
   for X:=0 to W-1 do
   begin
    X3:=(X+MaxOffsX+2)*3;
    if (PX3[X3]>253) then Inc(MatchingCtr) else
    if (PX3[X3]=64*3) then Inc(NonMatchingCtr);
   end;
  end;
  if (NonMatchingCtr+MatchingCtr>0) then
  s:=s+Format(#13#10'"Enhanced" Matching: %d, Non-Matching: %d, Similarity: %f %%',
             [MatchingCtr, NonMatchingCtr, MatchingCtr*100/(NonMatchingCtr+MatchingCtr)]);
  Canvas.FrameRect(Rect(2+MaxOffsX,2+MaxOffsY,2+MaxOffsX+W,2+MaxOffsY+H));
 end;

{ with SymbolMatchForm.ReducedMatch1.Picture.Bitmap do
 begin
  Width:=1+(GlyphRects[Num1].Right-GlyphRects[Num1].Left) div 2;
  Height:=1+(GlyphRects[Num1].Bottom-GlyphRects[Num1].Top) div 2;
  PixelFormat:=pf8bit;
  for Y:=(GlyphRects[Num1].Top div 2) to (GlyphRects[Num1].Bottom div 2) do
  begin
   PX1:=ImageMask3.Picture.Bitmap.ScanLine[Y*2];
   PX2:=ImageMask3.Picture.Bitmap.ScanLine[Y*2+1];
   PX3:=ScanLine[Y-(GlyphRects[Num1].Top div 2)];
   for X:=(GlyphRects[Num1].Left div 2) to (GlyphRects[Num1].Right div 2) do
   begin
    MatchingCtr:=0;
    X1:=X-(GlyphRects[Num1].Left div 2);
    if PX1[X*2]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX1[X*2+1]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX2[X*2]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX2[X*2+1]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if MatchingCtr>1 then PX3[X1]:=CLR_MASK_MAIN else PX3[X1]:=CLR_MASK_NONE;
   end;
  end;

 end;

 with SymbolMatchForm.ReducedMatch2.Picture.Bitmap do
 begin
  Width:=1+(GlyphRects[Num2].Right-GlyphRects[Num2].Left) div 2;
  Height:=1+(GlyphRects[Num2].Bottom-GlyphRects[Num2].Top) div 2;
  PixelFormat:=pf8bit;
  for Y:=(GlyphRects[Num2].Top div 2) to (GlyphRects[Num2].Bottom div 2) do
  begin
   PX1:=ImageMask3.Picture.Bitmap.ScanLine[Y*2];
   PX2:=ImageMask3.Picture.Bitmap.ScanLine[Y*2+1];
   PX3:=ScanLine[Y-(GlyphRects[Num2].Top div 2)];
   for X:=(GlyphRects[Num2].Left div 2) to (GlyphRects[Num2].Right div 2) do
   begin
    MatchingCtr:=0;
    X1:=X-(GlyphRects[Num2].Left div 2);
    if PX1[X*2]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX1[X*2+1]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX2[X*2]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if PX2[X*2+1]=CLR_MASK_MAIN then Inc(MatchingCtr);
    if MatchingCtr>1 then PX3[X1]:=CLR_MASK_MAIN else PX3[X1]:=CLR_MASK_NONE;
   end;
  end;

 end;}
// SymbolMatchForm.TextData.Caption:=s;
// SymbolMatchForm.ShowModal;
{end;}

function TGlyphForm.CompareGlyphBitmaps;//(Bmp1, Bmp2: TBitmap);
var i, X, Y, W, H, MaxW, MaxH,
    W1, H1, W2, H2, X1, X2, X3,
    OffsX, OffsY, ShiftLimit: integer;
    PX1, PX2, PX3: PByteArray;
    MatchingCtr, NonMatchingCtr,
    IgnoredCtr, IgnoredMatchCtr,
    BestMatch: integer;
    MaxMatchingCtr, MaxNonMatchingCtr,
    MaxIgnoredCtr, MaxIgnoredMatchCtr,
    MaxBestMatch: integer;
    MaxOffsX, MaxOffsY, i1, i2: integer;
    f, f1, f2, f3, f4: extended;
//    MinWNum, MinHNum: integer;
//    MaxWNum, MaxHNum: integer;
//    ShowOnNum,
    RemainingCtr, EhancementCount: integer;
    s: string;
    MaxHBmp, MaxWBmp, MinHBmp, MinWBmp, ShowOnBmp: TBitmap;
begin
 W1:=Bmp1.Width;
 W2:=Bmp2.Width;
 W:=Min(W1, W2); MaxW:=Max(W1,W2);
 H1:=Bmp1.Height;
 H2:=Bmp2.Height;
 H:=Min(H1,H2);  MaxH:=Max(H1,H2);
 if H1<H2 then MinHBmp:=Bmp1 else MinHBmp:=Bmp2;
 if H1<H2 then MaxHBmp:=Bmp2 else MaxHBmp:=Bmp1;
 if W1<W2 then MinWBmp:=Bmp1 else MinWBmp:=Bmp2;
 if W1<W2 then MaxWBmp:=Bmp2 else MaxWBmp:=Bmp1;

 if (H1*W1>H1*W2) then ShowOnBmp:=Bmp1 else ShowOnBmp:=Bmp2;
// if (MaxWNum<>ShowOnNum) then ShowOnNum:=MaxWNum;

 MaxMatchingCtr:=-1; MaxNonMatchingCtr:=0;
 MaxIgnoredCtr:=0;  MaxIgnoredMatchCtr:=0;
 MaxOffsX:=0; MaxOffsY:=0;
 for OffsY:=0 to abs(H1-H2) do
 for OffsX:=0 to abs(W1-W2) do
 begin
  MatchingCtr:=0; NonMatchingCtr:=0;
  IgnoredCtr:=0;  IgnoredMatchCtr:=0;
  for Y:=0 to H-1 do
  begin
   PX1:=MinHBmp.ScanLine[Y];
   PX2:=MaxHBmp.ScanLine[Y+OffsY];
   //we expect that BOTH width and height are higher or equal for one of the glyphs
   for X:=0 to W-1 do
   begin
    if (MinHBmp=MinWBmp) then
    begin X2:=X+OffsX; X1:=X; end
    else begin X1:=X+OffsX; X2:=X; end;
    if (PX1[X1]=CLR_MASK_MAIN)
       and (PX2[X2]=CLR_MASK_MAIN)
       then inc(MatchingCtr)
    else
    if (PX1[X1]=CLR_MASK_MAIN)
       or (PX2[X2]=CLR_MASK_MAIN)
       then inc(NonMatchingCtr)
    else
    begin
     if PX1[X1]=PX2[X2] then Inc(IgnoredMatchCtr);
     inc(IgnoredCtr);
    end;
   end;
  end;
  if (MaxMatchingCtr<MatchingCtr) then
  begin
   MaxMatchingCtr:=MatchingCtr;
   MaxNonMatchingCtr:=NonMatchingCtr;
   MaxIgnoredCtr:=IgnoredCtr;
   MaxIgnoredMatchCtr:=IgnoredMatchCtr;
   MaxOffsX:=OffsX;
   MaxOffsY:=OffsY;
  end;
 end;
// if not(MaxIgnoredCtr=0) then //exit;
try
{ f1:=MaxMatchingCtr+1.0;
 f2:=MaxNonMatchingCtr+MaxMatchingCtr+1.0;
 f3:=100;
 f:=f1/f2;
 f:=f*f3;
 s:=s+Format('Matching: %d, ',[MaxMatchingCtr]);
 s:=s+Format('Non-Matching: %d, ',[MaxNonMatchingCtr]);
// s:=s+'Similarity: '+FloatToStrF(MaxMatchingCtr*100.0/(MaxNonMatchingCtr+MaxMatchingCtr),ffFixed,3,6)+'%'#13#10;
 s:=s+Format('Similarity: %f %%'#13#10,[f]);
 s:=s+ Format(
           'Ignored: %d, Matching Ignored: %d (%f %%)'#13#10+
           'Offsets - X=%d Y=%d',
     [MaxIgnoredCtr, MaxIgnoredMatchCtr, MaxIgnoredMatchCtr*100.0/(MaxIgnoredCtr),
             MaxOffsX, MaxOffsY]);}
// i1:=Trunc(MaxMatchingCtr*100/(MaxNonMatchingCtr+MaxMatchingCtr));
 if (MaxMatchingCtr+MaxNonMatchingCtr)=0 then MaxMatchingCtr:=1; 
 i1:=(MaxMatchingCtr*100) div (MaxNonMatchingCtr+MaxMatchingCtr);
 i2:=(MaxMatchingCtr*10000) div (MaxNonMatchingCtr+MaxMatchingCtr) - i1*100;

 s:=Format('Matching: %d, Non-Matching: %d, Similarity: %d.%d %%'#13#10+
           'Ignored: %d, Matching Ignored: %d (%f %%)'#13#10+
           'Offsets - X=%d Y=%d',
     [MaxMatchingCtr, MaxNonMatchingCtr, i1, i2,
             MaxIgnoredCtr, MaxIgnoredMatchCtr, MaxIgnoredMatchCtr*100.0/(MaxIgnoredCtr),
             MaxOffsX, MaxOffsY]);

{ s:=Format('Matching: %d, Non-Matching: %d, Similarity: %f %%'#13#10+
           'Ignored: %d, Matching Ignored: %d (%f %%)'#13#10+
// s:=Format('Matching: %g, Non-Matching: %g, Similarity: %d %%'#13#10+
//           'Ignored: %g, Matching Ignored: %g (%g %%)'#13#10+
           'Offsets - X=%d Y=%d',
     [MaxMatchingCtr, MaxNonMatchingCtr, MaxMatchingCtr*100/(MaxNonMatchingCtr+MaxMatchingCtr),
             MaxIgnoredCtr, MaxIgnoredMatchCtr, MaxIgnoredMatchCtr*100.0/(MaxIgnoredCtr),
             MaxOffsX, MaxOffsY]);}
except end;
// ShowMessage(s);
// with SymbolMatchForm.ImageMatch1.Picture.Bitmap do
 with CompareBitmap1 do
 begin
  Height:=0;
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
  PixelFormat:=pf8bit;
  BitBlt(Canvas.Handle,2,2,Width,Height,Bmp1.Canvas.Handle,0,0,SRCCOPY);
 end;
// with SymbolMatchForm.ImageMatch2.Picture.Bitmap do
 with CompareBitmap2 do
 begin
  Height:=0;
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
  PixelFormat:=pf8bit;
  BitBlt(Canvas.Handle,2,2,Width,Height,Bmp2.Canvas.Handle,0,0,SRCCOPY);
 end;

// with SymbolMatchForm.ImageDiff1.Picture.Bitmap do
 with CompareBitmap3 do
 begin
  Height:=0;
  Width:=Max(W1,W2)+4;
  Height:=Max(H1,H2)+4;
//  BitBlt(Canvas.Handle,2,2,Width,Height,Glyphs[ShowOnNum].Text.Canvas.Handle,0,0,SRCCOPY);
  BitBlt(Canvas.Handle,2,2,Width,Height,ShowOnBmp.Canvas.Handle,0,0,SRCCOPY);

  PixelFormat:=pf24bit;
  Canvas.Pen.Mode:=pmNot;
  Canvas.Brush.Color:=clBlue;
  for Y:=0 to H-1 do
  begin
   PX1:=MinHBmp.ScanLine[Y];
   PX2:=MaxHBmp.ScanLine[Y+MaxOffsY];
   PX3:=ScanLine[2+MaxOffsY+Y];

   for X:=0 to W-1 do
   begin
    X1:=X;
    X2:=X;
    if (MaxWBmp=MaxHBmp) then X2:=X2+MaxOffsX else X1:=X1+MaxOffsX;
    X3:=(X+MaxOffsX+2)*3;
    if (PX1[X1]=CLR_MASK_MAIN)
       and (PX2[X2]=CLR_MASK_MAIN) then
     begin PX3[X3]:=255; PX3[X3+1]:=255; PX3[X3+2]:=255; end
    else
    if (PX1[X1]=CLR_MASK_MAIN)
       or (PX2[X2]=CLR_MASK_MAIN) then
    begin PX3[X3]:=64*3; PX3[X3+1]:=64*3; PX3[X3+2]:=64*3; end
    else begin PX3[X3]:=64*1; PX3[X3+1]:=64*1; PX3[X3+2]:=64*1; end
   end;
  end;

  EhancementCount:=StrToIntDef(edCompareEnhancement.Text,3);
for i:=1 to EhancementCount do
begin
  for Y:=1 to H-2 do
  begin
   PX3:=ScanLine[2+MaxOffsY+Y];
   PX1:=ScanLine[2+MaxOffsY+Y-1];
   PX2:=ScanLine[2+MaxOffsY+Y+1];
   for X:=1 to W-2 do
   begin
    X3:=(X+MaxOffsX+2)*3;
    X1:=(X-1+MaxOffsX+2)*3;
    X2:=(X+1+MaxOffsX+2)*3;
    if (PX3[X3]=64*3) then
    if (PX1[X3]=255) or (PX2[X3]=255) or (PX3[X1]=255) or (PX3[X2]=255) then
    begin PX3[X3]:=254; PX3[X3+1]:=254; PX3[X3+2]:=254; end;
   end;
  end;

  for Y:=1 to H-2 do
  begin
   PX3:=ScanLine[2+MaxOffsY+Y];
   for X:=1 to W-2 do
   begin
    X3:=(X+MaxOffsX+2)*3;
    if (PX3[X3]=254) then begin PX3[X3]:=255; PX3[X3+1]:=255; PX3[X3+2]:=255; end;
   end;
  end;
end;
  MatchingCtr:=0; NonMatchingCtr:=0; RemainingCtr:=0;
  for Y:=0 to H-1 do
  begin
   PX3:=ScanLine[2+MaxOffsY+Y];
   for X:=0 to W-1 do
   begin
    X3:=(X+MaxOffsX+2)*3;
    if (PX3[X3]>253) then Inc(MatchingCtr) else
    if (PX3[X3]=64*3) then Inc(NonMatchingCtr);
//    else if (PX3[X3]=CLR_MASK_MAIN) then Inc(RemainingCtr);
   end;
  end;
  if (NonMatchingCtr+MatchingCtr>0) then
try
  s:=s+Format(#13#10'"Enhanced" Matching: %d, Non-Matching: %d, Similarity: %f %%, Remaining: %f %%',
             [MatchingCtr, NonMatchingCtr,
              MatchingCtr*100.0/(NonMatchingCtr+MatchingCtr),
              RemainingCtr*1.0/(MaxH*MaxW)]);
except end;              
  Canvas.FrameRect(Rect(2+MaxOffsX,2+MaxOffsY,2+MaxOffsX+W,2+MaxOffsY+H));
 end;

 Result.RemainingPercent:=RemainingCtr/(MaxH*MaxW);

 Result.XOffs:=MaxOffsX;
 Result.YOffs:=MaxOffsY;
 if (NonMatchingCtr+MatchingCtr>0) then
 Result.BestMatch:=MatchingCtr*100/(NonMatchingCtr+MatchingCtr)
 else Result.BestMatch:=0;
 s:=s+#13#10+'Size: '+IntToStr(Bmp1.Width)+'x'+IntToStr(Bmp1.Height);
 
// SymbolMatchForm.TextData.Caption:=s;
 LastCompareResult:=s;
// SymbolMatchForm.ShowModal;
 Result.Comment:=s;
 LastCompare:=Result;

end;

function TGlyphForm.CompareGlyphs;//(Num1, Num2: integer);
var{ i, X, Y, W, H, MaxW, MaxH,
    W1, H1, W2, H2, X1, X2, X3,
    OffsX, OffsY, ShiftLimit: integer;
    PX1, PX2, PX3: PByteArray;
    MatchingCtr, NonMatchingCtr,
    IgnoredCtr, IgnoredMatchCtr,
    BestMatch: integer;
    MaxMatchingCtr, MaxNonMatchingCtr,
    MaxIgnoredCtr, MaxIgnoredMatchCtr,
    MaxBestMatch: integer;
    MaxOffsX, MaxOffsY: integer;
    MinWNum, MinHNum: integer;
    MaxWNum, MaxHNum: integer;
    ShowOnNum, RemainingCtr: integer;
    s: string;}
    Bmp1, Bmp2: TBitmap;
begin
 if (Num1<0) or (Num2<0) or
  (Num1>=Length(Glyphs)) or (Num2>=Length(Glyphs))  then exit;

 Bmp1:=Glyphs[Num1].Text;
 Bmp2:=Glyphs[Num2].Text;
 Result:=CompareGlyphBitmaps(Bmp1,Bmp2);
end;

procedure TGlyphForm.FormCreate(Sender: TObject);
var CL: TColor;
    X, R, G, B, RB, GB, BB, BN, RQ, GQ, BQ: byte;
    i: integer;
begin
//
  XL:=-1;  YL:=-1;
  XFactor:=1; YFactor:=1;

  cmbZoom.ItemIndex:=2;//=8;

//  BaseSymbols:=TList.Create;

  SetTitle('');

  SymbolSelected:=0;

  DisableMaskUpdate:=false;

  DecimalSeparator:='.';
  CLR_MASK_MAIN := 15; //15
  CLR_MASK_DBL := 16;
  CLR_MASK_OUT := 17; //13;
  CLR_MASK_NONE := 11;


  CompareBitmap1:=TBitmap.Create;
  CompareBitmap2:=TBitmap.Create;
  CompareBitmap3:=TBitmap.Create;
  Mask1Bitmap:=TBitmap.Create;
  Mask2Bitmap:=TBitmap.Create;
  Mask3Bitmap:=TBitmap.Create;
  MaskDiffBitmap:=TBitmap.Create;
  Mask1Bitmap.PixelFormat:=pf8bit;
  Mask2Bitmap.PixelFormat:=pf8bit;
  Mask3Bitmap.PixelFormat:=pf8bit;
  MaskDiffBitmap.PixelFormat:=pf8bit;

  Mask1Bitmap.Width:=10;
  Mask1Bitmap.Height:=10;

  RB:=0; GB:=0; BB:=0; BN:=0;
  RQ:=128; GQ:=128; BQ:=128; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_NONE:=BN;
  CLRX_MASK_NONE:=RB+GB*256+BB*256*256;

  RB:=0; GB:=0; BB:=255; BN:=0;
  RQ:=255; GQ:=255; BQ:=0; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_MAIN:=BN;
  CLRX_MASK_MAIN:=RB+GB*256+BB*256*256;

  RB:=255; GB:=255; BB:=0; BN:=0;
  RQ:=0; GQ:=0; BQ:=255; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_DBL:=BN;
  CLRX_MASK_DBL:=RB+GB*256+BB*256*256;

  RB:=0; GB:=255; BB:=0; BN:=0;
  RQ:=255; GQ:=0; BQ:=255; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_OUT:=BN;
  CLRX_MASK_OUT:=RB+GB*256+BB*256*256;

  RB:=0; GB:=255; BB:=0; BN:=0;
  RQ:=0; GQ:=255; BQ:=0; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_KNOWN:=BN;
  CLRX_MASK_KNOWN:=RB+GB*256+BB*256*256;


  RB:=255; GB:=255; BB:=255; BN:=0;
  RQ:=64; GQ:=64; BQ:=64; //requested color
  for x:=0 to 255 do
  begin
   PByteArray(Mask1Bitmap.ScanLine[0])[0]:=x;
   CL:=Mask1Bitmap.Canvas.Pixels[0,0];
   R:= CL and $FF; G:= (CL shr 8) and $FF; B:= (CL shr 16) and $FF;
   if (abs(R-RQ)+abs(G-GQ)+abs(B-BQ))<(abs(RB-RQ)+abs(GB-GQ)+abs(BB-BQ))
   then begin RB:=R; GB:=G; BB:=B; BN:=x; end;
  end;
  CLR_MASK_IGNORE:=BN;
  CLRX_MASK_IGNORE:=RB+GB*256+BB*256*256;

//   if MX=CLR_MASK_MAIN then begin RP^:=255; GP^:=255; BP^:=32; end else
//   if MX=CLR_MASK_NONE then begin RP^:=128+32; GP^:=128+32; BP^:=128+32; end else
//   if MX=CLR_MASK_DBL then begin RP^:=32; GP^:=32; BP^:=255; end else
//   if MX=CLR_MASK_OUT then begin RP^:=255; GP^:=32; BP^:=255; end else
//   if MX=0 then begin RP^:=0; GP^:=0; BP^:=0; end
//   else begin RP^:=64+32; GP^:=64+32; BP^:=64+32; end;

//  AssignPalette(ImageMask1.Picture.Bitmap);
//  AssignPalette(ImageMask2.Picture.Bitmap);
//  AssignPalette(ImageMask3.Picture.Bitmap);
//  AssignPalette(Mask1Bitmap);

  TempBaseBitmap:=TBitmap.Create;
  AssignPalette(TempBaseBitmap);

  SetLength(ColorDoms,2);

  ColorDoms[0].R:=175;
  ColorDoms[0].G:=175;
  ColorDoms[0].B:=175;
  ColorDoms[0].RD:=100;
  ColorDoms[0].GD:=100;
  ColorDoms[0].BD:=100;
  ColorDoms[0].ColorType:=ctBoneText;

  ColorDoms[1].R:=0;
  ColorDoms[1].G:=0;
  ColorDoms[1].B:=0;
  ColorDoms[1].RD:=30;
  ColorDoms[1].GD:=30;
  ColorDoms[1].BD:=30;
  ColorDoms[1].ColorType:=ctSkinOutline;

  ColorDomSelected:=0;

  UpdateColorDominator;

  PreOCRList:=TStringList.Create;
  PostOCRList:=TStringList.Create;

  edAutoRecognitionLineChange(Self);

  clbAutoFontsChecked.Items.Clear;
  clbAutoFontsChecked.Items.AddStrings(Screen.Fonts);
//  clbAutoFontsChecked.Checked[clbAutoFontsChecked.Items.IndexOf('Arial')]:=true;
  clbAutoFontsCheckedClick(Self);

  DecimalSeparator:='.';

  i:=0;
{  while (i<clbBuildMaskList.Items.Count) do
  begin
   clbBuildMaskList.Items.Objects[i]:=ptr(StrToIntDef(Trim(clbBuildMaskList.Items[i]),0));
   if integer(clbBuildMaskList.Items.Objects[i])>=clbBuildMaskList.Items.Count then
   clbBuildMaskList.Items.Objects[i]:=ptr(0);
   clbBuildMaskList.Items[i]:=Format('[%.3d] %s',
                              [integer(clbBuildMaskList.Items.Objects[i]), cmbMaskActions.Items[integer(clbBuildMaskList.Items.Objects[i])] ]);
   clbBuildMaskList.Checked[i]:=true;
   inc(i);
  end;

  AddMaskAction(CMD_TEXTMASK);
  AddMaskAction(CMD_OUTLINEMASK);

  AddMaskAction(CMD_ELIMINATEMINORTEXT);
//  AddMaskAction(CMD_GROW_TEXT,10);
//  AddMaskAction(CMD_GROW_OUTLINE,10);

  AddMaskAction(CMD_OUTLINETEXT);
  AddMaskAction(CMD_OUTLINEOUTLINE);
  AddMaskAction(CMD_IGNOREFILLTEXT);
  AddMaskAction(CMD_IGNOREFILLOUTLINE);

  AddMaskAction(CMD_EDGEFILLOUTLINE);

  AddMaskAction(CMD_ELIMINATEMINORTEXT);

  AddMaskAction(CMD_EDGELINETEXT);

  AddMaskAction(CMD_SUBTRACT_OUTLINE);
  AddMaskAction(CMD_MATCH_TO_OUTLINE,20);

  AddMaskAction(CMD_DIFFMASK,64);
  AddMaskAction(CMD_GROW_DIFFMASK,10);
  AddMaskAction(CMD_REVERSE_SUBTRACT_DIFFMASK);
  AddMaskAction(CMD_OPENBLASTTEXT);



  clbBuildMaskList.ItemEnabled[0]:=false;
  clbBuildMaskList.ItemEnabled[1]:=false; }
  cmbMaskActions.ItemIndex:=0;
  cmbPreset.ItemIndex:=1;
  cmbPresetChange(Self);  
end; //end of FormCreate

procedure TGlyphForm.btReduceColorsClick(Sender: TObject);
var X,Y, Divider:integer; PX:PByteArray;
begin
 Divider:=StrToIntDef(edColorDecimator.Text,16);
 for Y:=0 to ImageOrig.Picture.Bitmap.Height-1 do
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to (ImageOrig.Picture.Bitmap.Width-1) do
  begin
   PX[X*3]:=Min(255,(PX[X*3] div Divider)*Divider);
   PX[X*3+1]:=Min(255,(PX[X*3+1] div Divider)*Divider);
   PX[X*3+2]:=Min(255,(PX[X*3+2] div Divider)*Divider);
  end;
 end;

end;

procedure TGlyphForm.btLoadListClick(Sender: TObject);
begin
 if OpenList.Execute then
 begin
  PreOCRList.LoadFromFile(OpenList.FileName);
  PostOCRList.Assign(PreOCRList);
  ListFileName:=OpenList.FileName;
  btStart.Enabled:=true;
  btNext.Enabled:=true;
  btAutoPost.Enabled:=true;
  edOCRItem.Enabled:=true;
//  clbBitmapList.Show;
 end;
end;

procedure TGlyphForm.btAddGlyphsClick(Sender: TObject);
var i, Last, X, Y:integer; s, s1:string;
    t: string;
    SpaceSize, LineSize, MinWidth, MinHeight: integer;

procedure CheckGlyphMatched(Num: integer);
var i,j, Ctr : integer; Found: boolean; str: string;
    DataSorted: TGlyphData;
begin
 Ctr:=0; str:='';
 for i:=1 to GlyphData[Num].AreaCount do
 begin
  Found:=false;
  for j:=0 to Length(MatchedAreas)-1 do
   if MatchedAreas[j].X1=GlyphData[Num].Areas[i].X1+GlyphRects[Num].Left then
   if MatchedAreas[j].X2=GlyphData[Num].Areas[i].X2+GlyphRects[Num].Left then
   if MatchedAreas[j].Y1=GlyphData[Num].Areas[i].Y1+GlyphRects[Num].Top then
   if MatchedAreas[j].Y2=GlyphData[Num].Areas[i].Y2+GlyphRects[Num].Top then
   begin Found:=true; inc(Ctr); break; end;
  if (Found) then
  begin
   GlyphData[Num].Areas[i].AreaMatch:=MatchedAreas[j].AreaMatch;
//   str:=str+MatchedAreas[j].AreaMatch;
   if MatchedAreas[j].AreaMatch<REGION_SUB_ELEMENT then dec(Ctr);
//   if GlyphData[Num].AreaCount=1 then GlyphData[Num].TextMatch:=GlyphData[Num].Areas[i].AreaMatch;
  end
  else
  begin
   GlyphData[Num].Areas[i].AreaMatch:=REGION_UNKNOWN;
//   if GlyphData[Num].AreaCount=1 then GlyphData[Num].TextMatch:=REGION_UNKNOWN;
  end;
 end;
 if Ctr=GlyphData[Num].AreaCount then
 begin
  DataSorted:=SortGlyphDataByLeft(GlyphData[Num]);
  Str:='';
  for i:=1 to GlyphData[Num].AreaCount do
  if DataSorted.Areas[i].AreaMatch[1]>#30 then
  Str:=Str+DataSorted.Areas[i].AreaMatch;
  GlyphData[Num].TextMatch:=str;
 end 
 else GlyphData[Num].TextMatch:=REGION_UNKNOWN;
end;

procedure AddMatchedAreas(Num: integer);
var i,j : integer; Found: boolean;
begin
 for i:=1 to GlyphData[Num].AreaCount do
 begin
  Found:=false;
  for j:=0 to Length(MatchedAreas)-1 do
   if MatchedAreas[j].X1=GlyphData[Num].Areas[i].X1+GlyphRects[Num].Left then
   if MatchedAreas[j].X2=GlyphData[Num].Areas[i].X2+GlyphRects[Num].Left then
   if MatchedAreas[j].Y1=GlyphData[Num].Areas[i].Y1+GlyphRects[Num].Top then
   if MatchedAreas[j].Y2=GlyphData[Num].Areas[i].Y2+GlyphRects[Num].Top then
   begin Found:=true; break; end;
  if not(Found) then
  if GlyphData[Num].Areas[i].AreaMatch[1]>REGION_REMOVE then
  begin
   SetLength(MatchedAreas,Length(MatchedAreas)+1);
   j:=Length(MatchedAreas)-1;
   MatchedAreas[j]:=GlyphData[Num].Areas[i];
   MatchedAreas[j].X1:=GlyphData[Num].Areas[i].X1+GlyphRects[Num].Left;
   MatchedAreas[j].X2:=GlyphData[Num].Areas[i].X2+GlyphRects[Num].Left;
   MatchedAreas[j].Y1:=GlyphData[Num].Areas[i].Y1+GlyphRects[Num].Top;
   MatchedAreas[j].Y2:=GlyphData[Num].Areas[i].Y2+GlyphRects[Num].Top;
  end;
 end;
end;

label REPEAT_OCR;
begin


REPEAT_OCR:
 SortGlyphRects;
 
 s:='';
 Last:=-1; GlyphRectsRemoved:=false;
 SpaceSize:=StrToIntDef(edSpaceSize.Text,24);
 LineSize:=StrToIntDef(edLineSize.Text,120);
 MinWidth:=StrToIntDef(edMinWidth.Text,8);
 MinHeight:=StrToIntDef(edMinHeight.Text,8);
 for i:=0 to Length(GlyphRects)-1 do CheckGlyphMatched(i);
 for i:=0 to Length(GlyphRects)-1 do
  if (GlyphRects[i].Right-GlyphRects[i].Left)>=MinWidth then
  if (GlyphRects[i].Bottom-GlyphRects[i].Top)>=MinHeight then
  if GlyphData[i].TextMatch<REGION_SUB_ELEMENT then
  begin
   t:=AddGlyphX(i,true);
   if t=REGION_ABORT then begin sbPause.Down:=true; exit; end;
   if t=REGION_UNKNOWN then
   begin
    GlyphData[i].TextMatch:=t; s:=s+'#';
    stTempText.Caption:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    Application.ProcessMessages;
   end
   else
   begin
{    if Last<0 then Last:=i;   if (GlyphRects[i].Top-GlyphRects[Last].Bottom)>LineSize then s:=s+#13#10;
    if (GlyphRects[i].Left-GlyphRects[Last].Right)>=SpaceSize then s:=s+' ';  s:=s+t; Last:=i;}
    GlyphData[i].TextMatch:=t;
    s1:=t;
//    if t.IsBold then s1:='<B>'+s1+'</B>';
//    if t.IsItalic then s1:='<I>'+s1+'</I>';
    s:=s+s1; Last:=i;
    s:=StringReplace(s,'</I><I>','',[rfReplaceAll]);
    s:=StringReplace(s,'</B><B>','',[rfReplaceAll]);
    stTempText.Caption:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    Application.ProcessMessages;

   end;
  end;
 // --------------------- Enhancement of missing symbols
 s:=''; Last:=-1;
 for i:=0 to Length(GlyphRects)-1 do
  if (GlyphRects[i].Right-GlyphRects[i].Left)>=MinWidth then
  if (GlyphRects[i].Bottom-GlyphRects[i].Top)>=MinHeight then
  begin
//   t:=AddGlyphX(i,true);
   t:=GlyphData[i].TextMatch;
   if (t=REGION_UNKNOWN) and (GlyphData[i].AreaCount=1) then
   begin
    t:=AddGlyphX(i,false);
    if t=REGION_ABORT then begin sbPause.Down:=true; exit; end;
    if t=REGION_REMOVE then
    begin
//      X:=GlyphRects[i].Left+GlyphData[i].Areas[1].FX-1; //only one area
//      Y:=GlyphRects[i].Top+GlyphData[i].Areas[1].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(GlyphData[i].Areas[1].GlobalAreaNum);//,1,i);
      //here order of GlyphData changes, so we MUST skip to resort point
      goto REPEAT_OCR;
      t:=REGION_UNKNOWN;
    end;
    GlyphData[i].TextMatch:=t;
    //t:=t+Format('#%.6d#',[i])
    {s:=s+'';}//s:=s+Format('#%.6d#',[Length(Glyphs)-1])
   end;
   if (t=REGION_UNKNOWN) and (GlyphData[i].AreaCount>1) then
   begin
    t:=GlyphSubMatch(i);
    if GlyphRectsRemoved then goto REPEAT_OCR;
    if t=REGION_UNKNOWN then t:=AddGlyphX(i,false);
    if t=REGION_ABORT then begin sbPause.Down:=true; exit; end;
//    if t<>REGION_REMOVE then exit;
    GlyphData[i].TextMatch:=t;

    //t:=t+Format('#%.6d#',[i])
    {s:=s+'';}//s:=s+Format('#%.6d#',[Length(Glyphs)-1])
   end;
   if GlyphData[i].AreaCount=1 then GlyphData[i].Areas[1].AreaMatch:=GlyphData[i].TextMatch;
   if t=REGION_ABORT then exit;
   if (t<>REGION_UNKNOWN) and (t<>REGION_ABORT) and (t<>REGION_CHECK_FULL) and (t<>REGION_REMOVE) then
   begin
    if Last<0 then Last:=i;
    if Last>0 then
    if ((GlyphRects[i].Top-GlyphRects[Last].Bottom)>LineSize)
       or ((GlyphRects[i].Left-GlyphRects[Last].Right)<(-LineSize*3)) then s:=s+#13#10;
    if (GlyphRects[i].Left-GlyphRects[Last].Right)>=SpaceSize then s:=s+' ';
    s:=s+t; Last:=i;
    AddMatchedAreas(i);
    stTempText.Caption:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    Application.ProcessMessages;
   end{ else
   begin
    s:=s+'#';
    stTempText.Caption:=StringReplace(s,#13#10,'|',[rfReplaceAll]);
    Application.ProcessMessages;
   end};
  end;
 stGlyphText.Text:=s;
// sgOCRResults.Cells[1,CurrentOCRLine]:=s;
 if PostOCRList.Count>0 then
 if (CurrentOCRLine<=PostOCRList.Count) and (CurrentOCRLine>=0) then
 begin
  PostOCRList[CurrentOCRLine]:=StringReplace(s,#13#10,'|',[rfReplaceAll]);//s;
  tbsOCRResultShow(Sender);
 end;
 OptimizeBaseSymbols;

 if GlyphRectsRemoved then
  begin
   //btBuildMasksXClick(Sender);
//!   SortGlyphRects; //put this into beginning of proc
//x   DoIgnoreFill(Mask1Bitmap, TextIgnore);
//x   MaskToBitmap(Mask1Bitmap,ImageMask3.Picture.Bitmap);

//   if sbAutoOCR.Down then
   goto REPEAT_OCR;
  end;
 if PostOCRList.Count>0 then
 if sbAutoOCR.Down then btNext.Click; 
end;

procedure TGlyphForm.AddGlyph;
begin
 AddGlyphX(Num);
end;

function TGlyphForm.GetNewGlyphBitmap;
var Bmp:TBitmap; X,Y, Bord: integer; PX, PXM:PByteArray;
begin
 Bmp:=TBitmap.Create;
 Bmp.PixelFormat:=pf8bit;
 Bord:=2;
// Bmp.Width:=GlyphRects[Num].Right-GlyphRects[Num].Left;
// Bmp.Height:=GlyphRects[Num].Bottom-GlyphRects[Num].Top;
 Bmp.Width:=GlyphRects[Num].Right-GlyphRects[Num].Left+Bord*2;
 Bmp.Height:=GlyphRects[Num].Bottom-GlyphRects[Num].Top+Bord*2;
// for Y:=0 to Bmp.Height-1 do
 for Y:=Bord to Bmp.Height-Bord-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PXM:=Mask3Bitmap.ScanLine[GlyphRects[Num].Top+Y-Bord];
//  for X:=0 to Bmp.Width-1 do
  for X:=Bord to Bmp.Width-Bord-1 do
  if PXM[GlyphRects[Num].Left+X-Bord]=CLR_MASK_MAIN then PX[X]:=CLR_MASK_MAIN else PX[X]:=CLR_MASK_NONE;
 end;
// for Y:=1 to Bmp.Height-2 do
 for Y:=0 to Bord-1 do
 begin
  PX:=Bmp.ScanLine[Y];
   for X:=0 to Bmp.Width-1 do PX[X]:=CLR_MASK_NONE;
  PX:=Bmp.ScanLine[Bmp.Height-1-Y];
   for X:=0 to Bmp.Width-1 do PX[X]:=CLR_MASK_NONE;
 end;
 for Y:=Bord to Bmp.Height-1-Bord do
 begin
  PX:=Bmp.ScanLine[Y];
   for X:=0 to Bord-1 do PX[X]:=CLR_MASK_NONE;
   for X:=Bmp.Width-1 downto Bmp.Width-Bord do PX[X]:=CLR_MASK_NONE;
 end;
 Result:=Bmp;
end;

function TGlyphForm.AddGlyphX;
var Bmp:TBitmap; X,Y, Bord: integer; PX, PXM:PByteArray;
    BaseCmp: TBaseCompareResult;
    ManualMatch, AutoMatch: extended;
    Res: TModalResult;

begin
 Result:=REGION_UNKNOWN;
 Bmp:=TBitmap.Create;
 Bmp.PixelFormat:=pf8bit;
 Bord:=2;
// Bmp.Width:=GlyphRects[Num].Right-GlyphRects[Num].Left;
// Bmp.Height:=GlyphRects[Num].Bottom-GlyphRects[Num].Top;
 Bmp.Width:=GlyphRects[Num].Right-GlyphRects[Num].Left+Bord*2;
 Bmp.Height:=GlyphRects[Num].Bottom-GlyphRects[Num].Top+Bord*2;
// for Y:=0 to Bmp.Height-1 do
 for Y:=Bord to Bmp.Height-Bord-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  PXM:=Mask3Bitmap.ScanLine[GlyphRects[Num].Top+Y-Bord];
//  for X:=0 to Bmp.Width-1 do
  for X:=Bord to Bmp.Width-Bord-1 do
  if PXM[GlyphRects[Num].Left+X-Bord]=CLR_MASK_MAIN then PX[X]:=CLR_MASK_MAIN else PX[X]:=CLR_MASK_NONE;
 end;
// for Y:=1 to Bmp.Height-2 do
 for Y:=0 to Bord-1 do
 begin
  PX:=Bmp.ScanLine[Y];
   for X:=0 to Bmp.Width-1 do PX[X]:=CLR_MASK_NONE;
  PX:=Bmp.ScanLine[Bmp.Height-1-Y];
   for X:=0 to Bmp.Width-1 do PX[X]:=CLR_MASK_NONE;
 end;
 for Y:=Bord to Bmp.Height-1-Bord do
 begin
  PX:=Bmp.ScanLine[Y];
   for X:=0 to Bord-1 do PX[X]:=CLR_MASK_NONE;
   for X:=Bmp.Width-1 downto Bmp.Width-Bord do PX[X]:=CLR_MASK_NONE;
 end;

// Result:=CheckGlyphX(Bmp,GlyphRects[Num],GlyphData[Num],NoNew);
 Result:=CheckGlyphX(Bmp,GlyphRects[Num],NoNew);
 Bmp.Free;

end;

function TGlyphForm.CheckGlyphX;
var X,Y, Bord: integer; PX, PXM:PByteArray;
    BaseCmp: TBaseCompareResult;
    ManualMatch, AutoMatch: extended;
    Res: TModalResult;

procedure CheckForNewBaseSymbol;
var tx: string; WD, HD: integer;
label STOP_MATCH;
begin

  SetLength(BaseSymbols,Length(BaseSymbols)+1);
//  GetMem(BaseSymbols[Length(BaseSymbols)-1],SizeOf(BaseSymbols));
//  BaseSymbols.Count:=BaseSymbols.Count+1;


  //try AutoMatch on "automatic" pass, and add if sucessful
   if NoNew then
   if sbTryAutoOCRSearch.Down then
   begin
    tx:=REGION_UNKNOWN;
    with ImageMask3.Picture.Bitmap.Canvas do
    begin
     Pen.Mode:=pmNot;
     MoveTo(BaseRect.Left, BaseRect.Top);
     LineTo(BaseRect.Right, BaseRect.Top);
     LineTo(BaseRect.Right, BaseRect.Bottom);
     LineTo(BaseRect.Left, BaseRect.Bottom);
     LineTo(BaseRect.Left, BaseRect.Top);
    end;
    ImageMask3.Invalidate;

    try
    tx:=TryAutoOCR(Bmp, NoNew);
    except end;
    with ImageMask3.Picture.Bitmap.Canvas do
    begin
     Pen.Mode:=pmNot;
     MoveTo(BaseRect.Left, BaseRect.Top);
     LineTo(BaseRect.Right, BaseRect.Top);
     LineTo(BaseRect.Right, BaseRect.Bottom);
     LineTo(BaseRect.Left, BaseRect.Bottom);
     LineTo(BaseRect.Left, BaseRect.Top);
     Pen.Mode:=pmCopy;
    end;
    ImageMask3.Invalidate;
    if tx<>REGION_UNKNOWN then begin Res:=mrOk; GOTO STOP_MATCH; end;
   end;


  if (NoNew) then
  begin
//   FreeMem(BaseSymbols[Length(BaseSymbols)-1]);
   SetLength(BaseSymbols,Length(BaseSymbols)-1);
   
//   BaseSymbols.Count:=BaseSymbols.Count-1;
   exit;
  end;

  //performing "sub-refine" sequence
  //



//  SymbolMatchForm.Mode:=1;
//  SymbolMatchForm.NumTop:=Length(BaseSymbols)-1;
  if BaseCmp.Match>=ManualMatch then
  begin
   CompareGlyphBitmaps(Bmp,GetBaseSymbolBitmap(BaseCmp.Num));
//   SymbolMatchForm.NumBottom:=BaseCmp.Num;
//   AddSymbolForm.ImageSymbol.Picture.Bitmap.Assign(CompareBitmap1);
//   AddSymbolForm.ImageBestMatch.Picture.Bitmap.Assign(CompareBitmap2);
{   MaskToBitmap(CompareBitmap1,AddSymbolForm.ImageSymbol.Picture.Bitmap);
   MaskToBitmap(CompareBitmap2,AddSymbolForm.ImageBestMatch.Picture.Bitmap);
   AddSymbolForm.ImageBestMatchDiff.Picture.Bitmap.Assign(CompareBitmap3);}
   CompareResultToAddSymbolForm;
    AddSymbolForm.cbItalic.Checked:=BaseSymbols[BaseCmp.Num].IsItalic;
    AddSymbolForm.cbBold.Checked:=BaseSymbols[BaseCmp.Num].IsBold;
    AddSymbolForm.cbUnderline.Checked:=BaseSymbols[BaseCmp.Num].IsUnderline;

   AddSymbolForm.edText.Text:=BaseSymbols[BaseCmp.Num].Text;
 end
  else
  begin

   CompareGlyphBitmaps(Bmp,Bmp);
    AddSymbolForm.cbItalic.Checked:=false;
    AddSymbolForm.cbBold.Checked:=false;
    AddSymbolForm.cbUnderline.Checked:=false;
//   SymbolMatchForm.NumBottom:=Length(BaseSymbols)-1;
//   AddSymbolForm.ImageSymbol.Picture.Bitmap.Assign(CompareBitmap1);
//   AddSymbolForm.ImageBestMatch.Picture.Bitmap.Assign(CompareBitmap2);
{   MaskToBitmap(CompareBitmap1,AddSymbolForm.ImageSymbol.Picture.Bitmap);
   MaskToBitmap(CompareBitmap2,AddSymbolForm.ImageBestMatch.Picture.Bitmap);
   AddSymbolForm.ImageBestMatchDiff.Picture.Bitmap.Assign(CompareBitmap3);}
   CompareResultToAddSymbolForm;
   AddSymbolForm.edText.Text:='';
  end;
  AddSymbolForm.edText.SelectAll;
//  BaseSymbols[Length(BaseSymbols)-1].Text
//!  Res:=SymbolMatchForm.ShowModal;
  AddSymbolForm.ImageContext.Picture.Bitmap.Assign(ImageMask3.Picture.Bitmap);
{!  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=0;
  AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Brush.Color:=clWhite;
  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=AddSymbolForm.ImageContext.Width;
//  HD:=(AddSymbolForm.ImageContext.Height-(GlyphRects[Num].Bottom-GlyphRects[Num].Top)) div 2;
//  WD:=(AddSymbolForm.ImageContext.Width-(GlyphRects[Num].Right-GlyphRects[Num].Left)) div 2;
  HD:=(AddSymbolForm.ImageContext.Height-(Bmp.Height)) div 2;
  WD:=(AddSymbolForm.ImageContext.Width-(Bmp.Width)) div 2;
  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=AddSymbolForm.ImageContext.Width;
  AddSymbolForm.ImageContext.Picture.Bitmap.Height:=AddSymbolForm.ImageContext.Height;
  AddSymbolForm.ImageContext.Picture.Bitmap.PixelFormat:=pf24bit;
  BitBlt(AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Handle,0,0,
         AddSymbolForm.ImageContext.Width,AddSymbolForm.ImageContext.Height,
  ImageMask3.Picture.Bitmap.Canvas.Handle,Max(0,BaseRect.Left-WD),Max(0,BaseRect.Top-HD),SRCCOPY);
!}  
  with AddSymbolForm.ImageContext.Picture.Bitmap.Canvas do
  begin
   Brush.Color:=clBlack;
   Pen.Color:=clBlack;
{!   FrameRect(Rect(BaseRect.Left-Max(0,BaseRect.Left-WD),
                  BaseRect.Top-Max(0,BaseRect.Top-HD),
                  BaseRect.Right-Max(0,BaseRect.Left-WD),
                  BaseRect.Bottom-Max(0,BaseRect.Top-HD)));
   FrameRect(Rect(BaseRect.Left-Max(0,BaseRect.Left-WD)-1,
                  BaseRect.Top-Max(0,BaseRect.Top-HD)-1,
                  BaseRect.Right-Max(0,BaseRect.Left-WD)+1,
                  BaseRect.Bottom-Max(0,BaseRect.Top-HD)+1)); !}
   FrameRect(Rect(BaseRect.Left, BaseRect.Top, BaseRect.Right, BaseRect.Bottom));
   FrameRect(Rect(BaseRect.Left-1, BaseRect.Top-1, BaseRect.Right+1, BaseRect.Bottom+1));
  end;
  AddSymbolForm.ContextScroll.HorzScrollBar.Position:=BaseRect.Left-(AddSymbolForm.ContextScroll.Width div 2);
  AddSymbolForm.ContextScroll.VertScrollBar.Position:=BaseRect.Top-(AddSymbolForm.ContextScroll.Height div 2);
  AddSymbolForm.lbMatchInfo.Caption:=LastCompareResult;
  if not sbDisableNewSymbols.Down then
  begin
   if sbBeepOnNewSymbol.Down then Beep();
   Res:=AddSymbolForm.ShowModal
  end
  else if sbIgnoreNewSmall.Down then
  if (BaseRect.Bottom-BaseRect.Top)>=StrToIntDef(edMinTextHeight.Text,40)
  then
  begin
   if sbBeepOnNewSymbol.Down then Beep();
   Res:=AddSymbolForm.ShowModal;
  end
  else Res:=mrCancel
  else Res:=mrCancel; //mrIgnore

  tx:=AddSymbolForm.edText.Text;
STOP_MATCH:
  if (Res=mrOk) then
  begin
  with BaseSymbols[Length(BaseSymbols)-1] do
//  with TBaseSymbol(BaseSymbols[BaseSymbols.Count-1]^) do
   begin
//   Added Base Symbol
//!   Result:=BaseSymbols[Length(BaseSymbols)-1].Text;
//   Result:=tx;
    Text:=tx;
    UsesIA:=false;
    IsItalic:=AddSymbolForm.cbItalic.Checked;
    IsBold:=AddSymbolForm.cbBold.Checked;
    IsUnderline:=AddSymbolForm.cbUnderline.Checked;
    AreaCount:=0;
   end;
   BaseSymbols[Length(BaseSymbols)-1].Bmp:=TBitmap.Create;
   BaseSymbols[Length(BaseSymbols)-1].Bmp.Assign(Bmp);
    if tbsGlyphs.Visible then tbsGlyphsShow(Self);
//    OptimizeBaseSymbols;
  end else
  begin
//   FreeMem(BaseSymbols[Length(BaseSymbols)-1]);
   SetLength(BaseSymbols,Length(BaseSymbols)-1); //remove symbol
//   BaseSymbols.Count:=BaseSymbols.Count-1;
//   FreeAndNil(Bmp); //remove bitmap
   if Res=mrIgnore then Result:=REGION_UNKNOWN else Result:=''; //return nothing
  end;
  if (Res=mrYes) or (Res=mrOk) then Result:=tx;
  if Res=mrAbort then Result:=REGION_ABORT;
  if Res=mrYesToAll then Result:=REGION_CHECK_FULL;
  if Res=mrCancel then Result:=REGION_REMOVE;

end;

begin
 Result:=REGION_UNKNOWN;
// Bmp:=TBitmap.Create;
// Bmp.PixelFormat:=pf8bit;
 Bord:=2;
{ SetLength(Glyphs,Length(Glyphs)+1);
 Glyphs[Length(Glyphs)-1].Text:=Bmp;
 Glyphs[Length(Glyphs)-1].Main:=nil;
 Glyphs[Length(Glyphs)-1].Outline:=nil;
 Glyphs[Length(Glyphs)-1].Equals:='';}

//! if (Bmp.Height>(BaseRect.Bottom-BaseRect.Top)) then Bmp.Height:=BaseRect.Bottom-BaseRect.Top+2;
//! if (Bmp.Width>(BaseRect.Right-BaseRect.Left)) then Bmp.Width:=BaseRect.Right-BaseRect.Left+4;

 AutoMatch:=StrToFloat(edAutoMatchThresh.Text);
 ManualMatch:=StrToFloat(edManualMatchThresh.Text);

 BaseCmp:=GetBestSymbol(Bmp, GlyphNum);
 if BaseCmp.Num<0 then //no good base, add image
 begin
//  AddBaseSymbol(Bmp);
  CheckForNewBaseSymbol;
 end
 else if (BaseCmp.Match>=AutoMatch) then
 begin
  Result:=BaseCmp.Text;
//  Bmp.Free;
 end
 else //if (BaseCmp.Match>=ManualMatch) then
 begin
  CheckForNewBaseSymbol;
{  Res:=SymbolMatch.ShowModal;
  if Res=mrOk then
  begin
  end;}
 end;
// if Bmp<>nil then FreeAndNil(Bmp);

end;

procedure TGlyphForm.FormDestroy(Sender: TObject);
var i:integer;
begin

 for i:=0 to Length(Glyphs)-1 do
  begin
   if not(Glyphs[i].Text=nil) then Glyphs[i].Text.Free;
   if not(Glyphs[i].Main=nil) then Glyphs[i].Main.Free;
   if not(Glyphs[i].Outline=nil) then Glyphs[i].Outline.Free;
  end;
  SetLength(Glyphs,0);
  SetLength(GlyphRects,0);
  SetLength(GlyphData,0);

 for i:=0 to Length(BaseSymbols)-1 do if BaseSymbols[i].UsesIA then SetLength(BaseSymbols[i].IA.Pixels,0) else BaseSymbols[i].Bmp.Free;
// for i:=0 to Length(BaseSymbols)-1 do FreeMem(BaseSymbols[i]);
 SetLength(BaseSymbols,0);
// for i:=0 to BaseSymbols.Count-1 do if TBaseSymbol(BaseSymbols[i]^).UsesIA then SetLength(TBaseSymbol(BaseSymbols[i]^).IA.Pixels,0) else TBaseSymbol(BaseSymbols[i]^).Bmp.Free;
// for i:=0 to BaseSymbols.Count-1 do FreeMem(BaseSymbols[i]);

// BaseSymbols.Free;

  SetLength(ColorDoms,0);
  TempBaseBitmap.Free;

  CompareBitmap1.Free;
  CompareBitmap2.Free;
  CompareBitmap3.Free;
  Mask1Bitmap.Free;
  Mask2Bitmap.Free;
  Mask3Bitmap.Free;

  PostOCRList.Free;
  PreOCRList.Free;

end;

procedure TGlyphForm.tbsGlyphsShow(Sender: TObject);
var Start, i, TopHeight, TopWidth,
    TopHeightX, TopWidthX,
    MarginXY, WX, WY, WW, HH: integer;
    Bmp, BmpX: TBitmap;
    Str: string;
begin

 sclGlyphScroll.Max:=Max(0,Length(BaseSymbols));
// sclGlyphScroll.Max:=Max(0,BaseSymbols.Count);
 Start:=sclGlyphScroll.Position;

 if Length(BaseSymbols)=0 then
// if BaseSymbols.Count=0 then
 begin
  pbSymbols.Canvas.Brush.Color:=clWhite;
  pbSymbols.Canvas.Pen.Color:=clBlack;
  pbSymbols.Canvas.Font.Color:=clBlack;
  pbSymbols.Canvas.Font.Size:=30;
  pbSymbols.Canvas.Font.Name:='Tahoma';
  Str:='Nothing to show';
  WX:=pbSymbols.Canvas.TextWidth(Str);
  WY:=pbSymbols.Canvas.TextHeight(Str);
  
  pbSymbols.Canvas.TextOut((pbSymbols.Width-WX) div 2,
                           (pbSymbols.Height-WY) div 2,
                           Str);
  Str:='';
  exit;
 end;

 Bmp:=TBitmap.Create;
   Bmp.Canvas.Brush.Color:=clWhite;
   Bmp.Canvas.Font.Color:=clBlack;
   Bmp.Canvas.Font.Height:=15;
   Bmp.Canvas.Pen.Color:=clBlack;
   Bmp.Width:=pbSymbols.Width;
   Bmp.Height:=pbSymbols.Height;
   Bmp.PixelFormat:=pf24bit;
// sclGlyphScroll.Max:=Max(0,Length(Glyphs)-20);
 TopHeight:=0; TopWidth:=0;
 for i:=Start to Length(BaseSymbols)-1 do
// for i:=Start to BaseSymbols.Count-1 do
  if TBaseSymbol(BaseSymbols[i]).UsesIA then
  begin
  if TBaseSymbol(BaseSymbols[i]).IA.Width>TopWidth then TopWidth:=TBaseSymbol(BaseSymbols[i]).IA.Width;
  end
  else if TBaseSymbol(BaseSymbols[i]).Bmp.Width>TopWidth then TopWidth:=TBaseSymbol(BaseSymbols[i]).Bmp.Width;
 for i:=Start to Length(BaseSymbols)-1 do
// for i:=Start to BaseSymbols.Count-1 do
  if TBaseSymbol(BaseSymbols[i]).UsesIA then
  begin
  if TBaseSymbol(BaseSymbols[i]).IA.Height>TopHeight then TopHeight:=TBaseSymbol(BaseSymbols[i]).IA.Height;
  end
  else if TBaseSymbol(BaseSymbols[i]).Bmp.Height>TopHeight then TopHeight:=TBaseSymbol(BaseSymbols[i]).Bmp.Height;

  MarginXY:=20;
 if TopWidth<=0 then exit; 
 TopWidthX:=TopWidth+MarginXY*2;
 TopHeightX:=TopHeight+MarginXY*2;
 WW:=Bmp.Width div TopWidthX;
 HH:=Bmp.Height div TopHeightX;

 for i:=Start to Length(BaseSymbols)-1 do
// for i:=Start to BaseSymbols.Count-1 do
 begin
    BmpX:=GetBaseSymbolBitmap(i);
    WX:=((i-Start) mod WW)*TopWidthX+((TopWidthX-BmpX.Width) div 2);//((TopWidth div 2)-BmpX.Width);
    WY:=((i-Start) div WW)*TopHeightX+((TopHeightX-BmpX.Height) div 2);
    if WY>Bmp.Height then break;
    Bmp.Canvas.Draw(WX,WY,BmpX);
    Bmp.Canvas.Brush.Color:=clWhite;
    Str:=Format('[%.4d] = %s',[i,TBaseSymbol(BaseSymbols[i]).Text]);
    WX:=((i-Start) mod WW)*TopWidthX+(TopWidthX div 2)-(Bmp.Canvas.TextWidth(Str) div 2);//((TopWidth div 2)-BmpX.Width);
    WY:=((i-Start) div WW)*TopHeightX+TopHeightX-Bmp.Canvas.TextHeight(Str)-5;
    Bmp.Canvas.TextOut(WX, WY, Str);
    Bmp.Canvas.Brush.Color:=clBlack;
    Bmp.Canvas.FrameRect(Rect(((i-Start) mod WW)*TopWidthX,
                              ((i-Start) div WW)*TopHeightX,
                              ((i-Start) mod WW)*TopWidthX+TopWidthX,
                              ((i-Start) div WW)*TopHeightX+TopHeightX));
    if i=SymbolSelected then
    Bmp.Canvas.FrameRect(Rect(((i-Start) mod WW)*TopWidthX+2,
                              ((i-Start) div WW)*TopHeightX+2,
                              ((i-Start) mod WW)*TopWidthX+TopWidthX-2,
                              ((i-Start) div WW)*TopHeightX+TopHeightX-2));
 end;
 pbSymbols.Canvas.Draw(0,0,Bmp);
 Bmp.Free;


{ for i:=0 to Length(GlyphImages)-1 do
 begin
//  if (i+Start)<Length(Glyphs) then
  if (i+Start)<Length(BaseSymbols) then
  begin
//   GlyphImages[i].Picture.Bitmap.Assign(Glyphs[i+Start].Text);
//   GlyphImages[i].Hint:=Glyphs[i+Start].BestCompare.Comment;
//   GlyphLabels[i].Caption:=Glyphs[i+Start].Equals;
   Bmp.Canvas.Draw((i mod 5)*TopWidth,(i div 5)*TopHeight,GetBaseSymbolBitmap(i+Start));

   GlyphImages[i].Picture.Bitmap.Assign(GetBaseSymbolBitmap(i+Start));
   GlyphImages[i].Hint:=BaseSymbols[i+Start].Text;
   GlyphLabels[i].Caption:=BaseSymbols[i+Start].Text;
  end
  else
  begin
   GlyphImages[i].Picture.Bitmap.Height:=0;
   GlyphLabels[i].Caption:='<No Picture>';
  end;
 end;}
end;

procedure TGlyphForm.sclGlyphScrollChange(Sender: TObject);
begin
 tbsGlyphsShow(Sender);
end;

{procedure TGlyphForm.btReduceSimilarClick(Sender: TObject);
var i,j:integer; Cmp:TGlyphCompareResult;
    AutoMatch, ManualMatch: extended;
    Res: TModalResult;
    HasMatch: boolean;

procedure SetGoodMatch(Num1, Num2: integer);
begin
 if (Glyphs[Num1].Equals='') and (Glyphs[Num2].Equals='') then
 begin
  CompareGlyphs(Num1,Num2);
//  SymbolMatchForm.NumTop:=Num1;
//  SymbolMatchForm.NumBottom:=Num2;
//  SymbolMatchForm.ShowModal;
 end;
 if (Glyphs[Num1].Equals<>'') and (Glyphs[Num2].Equals='')
 then Glyphs[Num2].Equals:=Glyphs[Num1].Equals;
 if (Glyphs[Num1].Equals='') and (Glyphs[Num2].Equals<>'')
 then Glyphs[Num1].Equals:=Glyphs[Num2].Equals;

end;


begin
//
 DecimalSeparator:='.';
 AutoMatch:=StrToFloat(edAutoMatchThresh.Text);
 ManualMatch:=StrToFloat(edManualMatchThresh.Text);
 for i:=0 to Length(Glyphs)-1 do if Glyphs[i].Equals='' then Glyphs[i].BestOtherMatch:=-1;
 for i:=0 to Length(Glyphs)-1 do if Glyphs[i].Equals='' then Glyphs[i].BestCompare.BestMatch:=-1;
 for i:=0 to Length(Glyphs)-1 do
 if Glyphs[i].Equals='' then 
// for j:=i+1 to Length(Glyphs)-1 do
 for j:=0 to Length(Glyphs)-1 do
 if not(i=j) then
// if (abs(Glyphs[i].Text.Width-Glyphs[j].Text.Width)<12)   //acceptable difference
// or (abs(Glyphs[i].Text.Height-Glyphs[j].Text.Height)<12) //for first compares (trying complete match)
 if (abs(Glyphs[i].Text.Width-Glyphs[j].Text.Width)<12)   //acceptable difference
 and (abs(Glyphs[i].Text.Height-Glyphs[j].Text.Height)<12) //for first compares (trying complete match)
 then
 begin
//  if not(Glyphs[i].BestCompare.BestMatch>AutoMatch) then
   Cmp:=CompareGlyphs(i,j);// else break;
  if Cmp.BestMatch>AutoMatch then Res:=mrOk
  else Res:=mrNone;
//  else if Cmp.BestMatch>ManualMatch then Res:=SymbolMatchForm.ShowModal;

  if Res=mrOk then
  begin
   if (Glyphs[i].BestCompare.BestMatch<Cmp.BestMatch) then
   begin
    Glyphs[i].BestCompare:=Cmp;
    Glyphs[i].BestCompare.Comment:='#'+IntToStr(i)+'#'#13#10+
      'Best Match = #'+IntToStr(j)+'#'#13#10+
      Glyphs[i].BestCompare.Comment;
    Glyphs[i].BestOtherMatch:=j;
    SetGoodMatch(i,j);
   end;
   if (Glyphs[j].BestCompare.BestMatch<Cmp.BestMatch) then
   begin
    Glyphs[j].BestCompare:=Cmp;
    Glyphs[j].BestCompare.Comment:='#'+IntToStr(j)+'#'#13#10+
      'Best Match = #'+IntToStr(i)+'#'#13#10+
      Glyphs[j].BestCompare.Comment;
    Glyphs[j].BestOtherMatch:=i;
   end;
  end
  else
  begin
   if (Glyphs[i].BestCompare.BestMatch<Cmp.BestMatch) then
    begin
     Glyphs[i].BestCompare:=Cmp;
     Glyphs[i].BestCompare.Comment:='#'+IntToStr(i)+'#'#13#10+
       'Best Match = #'+IntToStr(j)+'#'#13#10+
       Glyphs[i].BestCompare.Comment;
     Glyphs[i].BestOtherMatch:=j;
    end;
  end;
  if Res=mrOk then Break; //if we found full match, we don't need to check any further
 end;

 for i:=0 to Length(Glyphs)-1 do
 if Glyphs[i].Equals='' then
 begin
  SymbolMatchForm.NumTop:=i;
  if Glyphs[i].BestOtherMatch>=0 then SymbolMatchForm.NumBottom:=Glyphs[i].BestOtherMatch
                                 else SymbolMatchForm.NumBottom:=i;
  Cmp:=CompareGlyphs(SymbolMatchForm.NumTop,SymbolMatchForm.NumBottom);
  if (Cmp.BestMatch>AutoMatch) then SetGoodMatch(SymbolMatchForm.NumTop,SymbolMatchForm.NumBottom);
//  SymbolMatchForm.ShowModal;
 end;

 Res:=mrNone;
 for i:=0 to Length(Glyphs)-1 do
 if (Glyphs[i].Equals='') then
 if (Glyphs[i].BestCompare.BestMatch<AutoMatch) then
 begin
  Cmp:=CompareGlyphs(i,Glyphs[i].BestOtherMatch);// else break;
//  Cmp:=Glyphs[i].BestCompare;
  j:=Glyphs[i].BestOtherMatch;
  SymbolMatchForm.NumTop:=i;
  SymbolMatchForm.NumBottom:=j;
  if Cmp.BestMatch>AutoMatch then Res:=mrOk
  else if Cmp.BestMatch>ManualMatch then Res:=SymbolMatchForm.ShowModal;
  if (Res=mrOk) then SetGoodMatch(i,j)
  else //best match FAILS manual accept step
  if (Glyphs[i].Equals='') then
  for j:=0 to Length(Glyphs)-1 do
  if not(i=j) then
  if (abs(Glyphs[i].Text.Width-Glyphs[j].Text.Width)<12)   //acceptable difference
  and (abs(Glyphs[i].Text.Height-Glyphs[j].Text.Height)<12) //for first compares (trying complete match)
  then
   begin
    Cmp:=CompareGlyphs(i,j);
    SymbolMatchForm.NumTop:=i;
    SymbolMatchForm.NumBottom:=j;
    if Cmp.BestMatch>AutoMatch then Res:=mrOk
    else if Cmp.BestMatch>ManualMatch then Res:=SymbolMatchForm.ShowModal;
    if (Res=mrOk) then
    begin
     Glyphs[i].BestCompare:=Cmp;
     Glyphs[i].BestOtherMatch:=j;
     SetGoodMatch(i,j);
     break;
    end;
    if not(Glyphs[i].Equals='') then break; //manual match set
   end;

 end;

 for i:=0 to Length(Glyphs)-1 do
 if (Glyphs[i].Equals='') then
 begin //resolving symbols without ANY good match (those with best match below manual threshold)
    Cmp:=CompareGlyphs(i,i);
    SymbolMatchForm.NumTop:=i;
    SymbolMatchForm.NumBottom:=i;
    SetGoodMatch(i,i);
 end;

 SetLength(BaseGlyphs,0);
 for i:=0 to Length(Glyphs)-1 do
 if not(Glyphs[i].Equals='') then
 begin
  HasMatch:=false;
  for j:=0 to Length(BaseGlyphs)-1 do
  begin
   if (Glyphs[i].Equals=BaseGlyphs[j].Text) then
   begin
    HasMatch:=true;
    break;
   end;
  end;
  if not(HasMatch) then
  begin
   SetLength(BaseGlyphs,Length(BaseGlyphs)+1);
   BaseGlyphs[Length(BaseGlyphs)-1].Num:=i;
   BaseGlyphs[Length(BaseGlyphs)-1].Text:=Glyphs[i].Equals;
  end;
  Glyphs[i].IsBase:=not(HasMatch); 
 end;
// if Length(BaseGlyphs)>0 then sbBaseGlyphs.Max:=Length(BaseGlyphs)-1;

end;}

procedure TGlyphForm.Image1Click(Sender: TObject);
var Num1, Num2, Res: integer;
    Bmp:TBitmap;
begin
//
 Num1:=sclGlyphScroll.Position+(Sender as TComponent).Tag;
 Num2:=Num1;
// SymbolMatchForm.Mode:=1;
 Bmp:=GetBaseSymbolBitmap(Num1);
 CompareGlyphBitmaps(Bmp,Bmp);
// Num2:=Glyphs[Num1].BestOtherMatch;
// if (Num2<0) then Num2:=Num1;
// CompareGlyphs(Num1, Num2);
   CompareResultToAddSymbolForm;
{   AddSymbolForm.ImageSymbol.Picture.Bitmap.Assign(CompareBitmap1);
   AddSymbolForm.ImageBestMatch.Picture.Bitmap.Assign(CompareBitmap2);
   AddSymbolForm.ImageBestMatchDiff.Picture.Bitmap.Assign(CompareBitmap3);}
   AddSymbolForm.edText.Text:=TBaseSymbol(BaseSymbols[Num1]).Text;

  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=0;
  AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Brush.Color:=clWhite;
  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=AddSymbolForm.ImageContext.Width;
  AddSymbolForm.ImageContext.Picture.Bitmap.Height:=AddSymbolForm.ImageContext.Height;
  AddSymbolForm.ImageContext.Picture.Bitmap.PixelFormat:=pf8bit;
  BitBlt(AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Handle,
         (AddSymbolForm.ImageContext.Width div 2)-(CompareBitmap1.Width div 2),
         (AddSymbolForm.ImageContext.Height div 2)-(CompareBitmap1.Height div 2),
         AddSymbolForm.ImageContext.Width,AddSymbolForm.ImageContext.Height,
  CompareBitmap1.Canvas.Handle,0,0,SRCCOPY);
//  with AddSymbolForm.ImageContext.Picture.Bitmap.Canvas do

   Res:=AddSymbolForm.ShowModal;

   if Res=mrOK then TBaseSymbol(BaseSymbols[Num1]).Text:=AddSymbolForm.edText.Text;

 tbsGlyphsShow(Self);

{ SymbolMatchForm.NumTop:=Num1;
 SymbolMatchForm.NumBottom:=Num2;
 SymbolMatchForm.ShowModal;}
end;

procedure TGlyphForm.AssignPalette;
var Pal:TLogPal;
begin
// GetSystemPaletteEntries(Canvas.Handle,0,256,Pal.lpal.PalpalEntry);
 Bmp.Palette:=ImageMask2.Picture.Bitmap.Palette;

{
 Pal.lPal.palVersion:=$300;
 Pal.lPal.palNumEntries:=256;
 GetPaletteEntries(Bmp.Palette,0,256,Pal.lpal.PalpalEntry);


 Pal.dummy[CLR_MASK_NONE].peRed:=128;
 Pal.dummy[CLR_MASK_NONE].peGreen:=128;
 Pal.dummy[CLR_MASK_NONE].peBlue:=128;

 Pal.dummy[CLR_MASK_DBL].peRed:=255;
 Pal.dummy[CLR_MASK_DBL].peGreen:=0;
 Pal.dummy[CLR_MASK_DBL].peBlue:=255;

 Pal.dummy[CLR_MASK_OUT].peRed:=0;
 Pal.dummy[CLR_MASK_OUT].peGreen:=255;
 Pal.dummy[CLR_MASK_OUT].peBlue:=255;

 Pal.dummy[CLR_MASK_MAIN].peRed:=0;
 Pal.dummy[CLR_MASK_MAIN].peGreen:=0;
 Pal.dummy[CLR_MASK_MAIN].peBlue:=255;

 Bmp.Palette:=CreatePalette(Pal.lpal);}

end;


{procedure TGlyphForm.sbBaseGlyphsChange(Sender: TObject);
begin
 if not(sbBaseGlyphs.Position<Length(BaseGlyphs)) then exit;
 BaseGlyphImage.Picture.Bitmap.Assign(Glyphs[BaseGlyphs[sbBaseGlyphs.Position].Num].Text);
 edGlyphText.Text:=BaseGlyphs[sbBaseGlyphs.Position].Text;
 BaseGlyphImage.Invalidate;
end;}

procedure TGlyphForm.SaveSymbolsTo;
var SL:TStringList; i: integer; Bmp:TBitmap;
    s, s1: string;
begin
 SL:=TStringList.Create;
 try
// for i:=0 to Length(BaseGlyphs)-1 do
 for i:=0 to Length(BaseSymbols)-1 do
// for i:=0 to BaseSymbols.Count-1 do
// if Glyphs[i].IsBase then
 begin
//  Bmp:=Glyphs[i].Text;
  Bmp:=GetBaseSymbolBitmap(i);
  s:=Format('%s-%.6d.bmp',[ExtractFilePath(FName)+ExtractFileName(FName), i]);
  Bmp.SaveToFile(s);
  s1:=Format('%.6d',[i]);
  SL.Add('GS'+s1+'='+TBaseSymbol(BaseSymbols[i]).Text);//Glyphs[i].Equals);
  SL.Add('GP'+s1+'='+s);
  s:='';
  if TBaseSymbol(BaseSymbols[i]).IsBold then s:=s+'B';
  if TBaseSymbol(BaseSymbols[i]).IsUnderline then s:=s+'U';
  if TBaseSymbol(BaseSymbols[i]).IsItalic then s:=s+'I'; 
  if (s<>'') then SL.Add('GI'+s1+'='+s);//Glyphs[i].Equals);
 end;
 SL.SaveToFile(ChangeFileExt(FName,'.sym') {Format('%s\asd_base.sym',[Trim(edGlyphDir.Text)])});
 finally
  SL.Free;
 end;


end;

procedure TGlyphForm.btSaveGlyphsClick(Sender: TObject);
{var SL:TStringList;
    i: integer;
    Bmp: TBitmap;
    s, s1: string;}
begin

 SaveSymbols.InitialDir:=edGlyphDir.Text;
 if not(SaveSymbols.Execute) then exit;

 SaveSymbolsTo(SaveSymbols.FileName);

{ SL:=TStringList.Create;
 try
// for i:=0 to Length(BaseGlyphs)-1 do
 for i:=0 to Length(BaseSymbols)-1 do
// for i:=0 to BaseSymbols.Count-1 do
// if Glyphs[i].IsBase then
 begin
//  Bmp:=Glyphs[i].Text;
  Bmp:=GetBaseSymbolBitmap(i);
  s:=Format('%s-%.6d.bmp',[ExtractFilePath(SaveSymbols.FileName)+ExtractFileName(SaveSymbols.FileName), i]);
  Bmp.SaveToFile(s);
  s1:=Format('%.6d',[i]);
  SL.Add('GS'+s1+'='+TBaseSymbol(BaseSymbols[i]).Text);//Glyphs[i].Equals);
  SL.Add('GP'+s1+'='+s);
  s:='';
  if TBaseSymbol(BaseSymbols[i]).IsBold then s:=s+'B';
  if TBaseSymbol(BaseSymbols[i]).IsUnderline then s:=s+'U';
  if TBaseSymbol(BaseSymbols[i]).IsItalic then s:=s+'I';
  if (s<>'') then SL.Add('GI'+s1+'='+s);//Glyphs[i].Equals);
 end;
 SL.SaveToFile(ChangeFileExt(SaveSymbols.FileName,'.sym'); //Format('%s\asd_base.sym',[Trim(edGlyphDir.Text)]));
 finally
  SL.Free;
 end;}
end;

procedure TGlyphForm.btOptimizeBaseClick(Sender: TObject);
var i,j{, k}: integer;
    AutoMatch{, ManualMatch}: extended;
    Cmp, Cmp2:TGlyphCompareResult;
    Num, WorstMatchX : integer;
    IsBadMatch: boolean;
//optimize "known" equal glyphs - add those with
//higher error-margin then AutoMatch to base
begin
 AutoMatch:=StrToFloat(edAutoMatchThresh.Text);
// ManualMatch:=StrToFloat(edManualMatchThresh.Text);
 i:=0; WorstMatchX:=0;
 while (i<Length(BaseGlyphs)) do
 begin
// if (BaseGlyphs[i].IsBase) then
  Num:=BaseGlyphs[i].Num;
  Cmp.BestMatch:=100;
    for j:=0 to Length(Glyphs)-1 do
     if (Num<>j) and (BaseGlyphs[i].Text=Glyphs[j].Equals)
     and (not(Glyphs[j].IsBase)) then
     begin
      Cmp2:=CompareGlyphs(Num,j);
      if Cmp.BestMatch>Cmp2.BestMatch then
      begin Cmp:=Cmp2; WorstMatchX:=j; end;
     end;
    if (Cmp.BestMatch<AutoMatch) then
    begin
     j:=i+1;
     IsBadMatch:=true;
     while(j<Length(BaseGlyphs)) do
     begin
      if (BaseGlyphs[j].Text=Glyphs[WorstMatchX].Equals) then
        Cmp:=CompareGlyphs(BaseGlyphs[j].Num, WorstMatchX);
      if (Cmp.BestMatch>=AutoMatch) then
      begin
       IsBadMatch:=false;
       break;
      end;  
      inc(j); 
     end;
     if (IsBadMatch) then
     begin
      SetLength(BaseGlyphs,Length(BaseGlyphs)+1);
      Glyphs[WorstMatchX].IsBase:=true;
      BaseGlyphs[Length(BaseGlyphs)-1].Num:=WorstMatchX;
      BaseGlyphs[Length(BaseGlyphs)-1].Text:=Glyphs[WorstMatchX].Equals;
     end; 
    end;
   inc(i);
 end;


end;

function TGlyphForm.GetBestSymbol;
var Cmp, Cmp2:TGlyphCompareResult;
    i, WDiffLimit, HDiffLimit: integer;
    AutoMatch: extended;
    BaseBmp: TBitmap;
begin

 AutoMatch:=StrToFloat(edAutoMatchThresh.Text);

 WDiffLimit:=6;
 HDiffLimit:=6;

 Result.Num:=-1;
 Result.Text:='';
 Result.Match:=0;
 Result.SizeError:=0;
 Result.Comment:='';
 Cmp.BestMatch:=0;
 for i:=0 to Length(BaseSymbols)-1 do
// for i:=0 to BaseSymbols.Count-1 do
 begin
  BaseBmp:=GetBaseSymbolBitmap(i);
  if  (Abs(Bmp.Width-BaseBmp.Width)<WDiffLimit)
  and (Abs(Bmp.Height-BaseBmp.Height)<HDiffLimit) then
  begin
   Cmp2:=CompareGlyphBitmaps(Bmp,BaseBmp);
   if (Cmp.BestMatch<Cmp2.BestMatch) then
   begin
    Cmp:=Cmp2;
    Result.Num:=i;
    Result.Text:=TBaseSymbol(BaseSymbols[i]).Text;
    Result.Match:=Cmp.BestMatch;
    Result.Comment:=Cmp.Comment;
    Result.SizeError:=Abs(Bmp.Height-BaseBmp.Height) *
                      Abs(Bmp.Width-BaseBmp.Width);
    if not(sbBestMatchSearch.Down) then
    if Result.Match>=AutoMatch then break;
   end;
  end;
 end; 
end;

{procedure TGlyphForm.btConvertToTextClick(Sender: TObject);
var s:string; i: integer;
begin
//
 s:=stGlyphText.Text;
 for i:=0 to Length(Glyphs)-1 do
 if Glyphs[i].Equals<>'' then
  s:=StringReplace(s,Format('#%.6d#',[i]),Glyphs[i].Equals,[rfReplaceAll]);
 stGlyphText.Text:=s;
end;}

procedure TGlyphForm.ClearIgnores;
begin
 SetLength(TextIgnore,0);
 SetLength(TextIgnoreLine,0);
 SetLength(OutlineIgnore,0);
end;

procedure TGlyphForm.BitmapToImageArray;
var X,Y, W,H: integer; PX:PByteArray;
begin
 W:=Bmp.Width;
 H:=Bmp.Height;
 SetLength(IA.Pixels,W*H);
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to W-1 do IA.Pixels[Y*W+X]:=PX[X];
 end;
 IA.Width:=W;
 IA.Height:=H;

end;

procedure TGlyphForm.ImageArrayToBitmap;
var X,Y, W,H: integer; PX:PByteArray;
begin
 W:=IA.Width;
 H:=IA.Height;
 Bmp.Width:=0;
 Bmp.PixelFormat:=pf8bit;
 Bmp.Width:=W;
 Bmp.Height:=H;
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to W-1 do PX[X]:=IA.Pixels[Y*W+X];
 end;

end;

procedure TGlyphForm.ImageArrayToBitmap24;
var X,Y, W,H: integer; PX:PByteArray;
begin
 W:=IA.Width;
 H:=IA.Height;
 Bmp.Width:=0;
 Bmp.PixelFormat:=pf24bit;
 Bmp.Width:=W;
 Bmp.Height:=H;
 for Y:=0 to H-1 do
 begin
  PX:=Bmp.ScanLine[Y];
  for X:=0 to W-1 do
  begin
   PX[X*3+2]:=IA.Pixels[Y*W+X];
   PX[X*3+1]:=IA.Pixels[Y*W+X];
   PX[X*3]:=IA.Pixels[Y*W+X];
  end;
 end;

end;

procedure TGlyphForm.OptimizeBaseSymbols;
var i,j:integer;
begin
 i:=0;
 while(i<Length(BaseSymbols)) do
 begin
  if not(TBaseSymbol(BaseSymbols[i]).UsesIA) then
  begin
   BitmapToImageArray(TBaseSymbol(BaseSymbols[i]).Bmp,TBaseSymbol(BaseSymbols[i]).IA);
   TBaseSymbol(BaseSymbols[i]).UsesIA:=true;
   TBaseSymbol(BaseSymbols[i]).Bmp.Free;
   TBaseSymbol(BaseSymbols[i]).Bmp:=nil;//  FreeAndNil(BaseSymbols[i].Bmp);//.Free;
  end;
  if TBaseSymbol(BaseSymbols[i]).Text='' then
  begin
   SetLength(TBaseSymbol(BaseSymbols[i]).IA.Pixels,0);
//   FreeMem(BaseSymbols[i]);
   for j:=i to Length(BaseSymbols)-2 do BaseSymbols[j]:=BaseSymbols[j+1];
   SetLength(BaseSymbols,Length(BaseSymbols)-1);
  end else inc(i); 
 end;
 i:=0;
 while(i<Length(BaseSymbols)) do
 begin
  if BaseSymbols[i].AreaCount<=0 then
  begin
  RefineSymbolForm.SetBitmap(GetBaseSymbolBitmap(i));
  BaseSymbols[i].AreaCount:=Length(RefineSymbolForm.Areas);
  for j:=1 to BaseSymbols[i].AreaCount do
   BaseSymbols[i].Areas[j]:=RefineSymbolForm.Areas[j-1];
  end;
  inc(i);
 end;

end;

function TGlyphForm.GetBaseSymbolBitmap;
begin
 if Num>=Length(BaseSymbols) then Result:=nil else
  if (BaseSymbols[Num].UsesIA) then
   begin
    ImageArrayToBitmap(BaseSymbols[Num].IA,TempBaseBitmap);
    Result:=TempBaseBitmap;
   end
   else Result:=BaseSymbols[Num].Bmp;
end;


procedure TGlyphForm.ImageMaskXMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var s: string; i, AreaNum:integer; Rct1, Rct2: TRect;  
begin
 X:=Round(X*XFactor);
 Y:=Round(Y*YFactor);
 s:='X: '+IntToStr(X)+'; Y: '+IntToStr(Y);
  Rct2:=Rect(X,Y,X,Y);
 for i:=0 to Length(AreasX)-1 do
 begin
//               X1, X2, Y1, Y2, FX, FY, Count, UnityNum: integer;
//               AreaEnabled, AreaProcessed: boolean;
//               GuessedAreaPos: TSubPosSet;
  Rct1:=Rect(AreasX[i].X1,AreasX[i].Y1,AreasX[i].X2,AreasX[i].Y2);
  if (IsInside(Rct2,Rct1)) then
  begin
   s:=s+' Area: '+IntToStr(i)+
      ' ('+
        IntToStr(AreasX[i].X1)+','+
        IntToStr(AreasX[i].Y1)+','+
        IntToStr(AreasX[i].X2)+','+
        IntToStr(AreasX[i].Y2)+')'
      ;//+' Unit:'+IntToStr(AreasX[i].UnityNum);
   AreaNum:=i;
//   break;
  end;
 end;
 for i:=0 to Length(GlyphRects)-1 do
 begin
  Rct1:=GlyphRects[i];
  if (IsInside(Rct2,Rct1)) then
  begin
   s:=s+' Glyph: '+IntToStr(i)+'['+GlyphData[i].TextMatch+']'+
      ' ('+
        IntToStr(GlyphRects[i].Left)+','+
        IntToStr(GlyphRects[i].Top)+','+
        IntToStr(GlyphRects[i].Right)+','+
        IntToStr(GlyphRects[i].Bottom)+')';
//   break;
  end;
 end;
 if (XL>=0) then s:=s+ ' XL: '+IntToStr(XL)+'; YL: '+IntToStr(YL)+
                       ' XD: '+IntToStr(X-XL)+'; YD: '+IntToStr(Y-YL);
 stbMain.Panels[0].Text:=s;                 
end;


{procedure TGlyphForm.btLeakTestClick(Sender: TObject);
var Bmp:TBitmap;
    i:integer;
begin
 Bmp:=TBitmap.Create;
 Bmp.Assign(GetBaseSymbolBitmap(0));
 i:=StrToIntDef(btLeakTest.Caption,0)+1;
 btLeakTest.Caption:=IntToStr(i);
{ Bmp.PixelFormat:=pf8bit;
 Bmp.Width:=GlyphRects[0].Right-GlyphRects[0].Left;
 Bmp.Height:=GlyphRects[0].Bottom-GlyphRects[0].Top;
 BitBlt(Bmp.Canvas.Handle,0,0,Bmp.Width,Bmp.Height,ImageMask3.Picture.Bitmap.Canvas.Handle,GlyphRects[0].Left,GlyphRects[0].Top,SRCCOPY);}
{ AddGlyphX(0, true);
// i:=GetBestSymbol(Bmp).Num;
 Bmp.Free;
end;}

procedure TGlyphForm.UpdateColorDominator;
begin
 lbColorX.Color:=(ColorDoms[ColorDomSelected].R
                 +ColorDoms[ColorDomSelected].G*256
                 +ColorDoms[ColorDomSelected].B*256*256);
 lbColorX.Font.Color:=0;
 if ColorDoms[ColorDomSelected].R<128 then lbColorX.Font.Color:=lbColorX.Font.Color+255;
 if ColorDoms[ColorDomSelected].G<128 then lbColorX.Font.Color:=lbColorX.Font.Color+255*256;
 if ColorDoms[ColorDomSelected].B<128 then lbColorX.Font.Color:=lbColorX.Font.Color+255*256*256;

 lbColorX.Font.Height:=lbColorX.Height - 20;//div 2;//-10;

 edRT.Text:=IntToStr(ColorDoms[ColorDomSelected].R);
 edGT.Text:=IntToStr(ColorDoms[ColorDomSelected].G);
 edBT.Text:=IntToStr(ColorDoms[ColorDomSelected].B);
 edRDT.Text:=IntToStr(ColorDoms[ColorDomSelected].RD);
 edGDT.Text:=IntToStr(ColorDoms[ColorDomSelected].GD);
 edBDT.Text:=IntToStr(ColorDoms[ColorDomSelected].BD);

 lbClrSel.Caption:=IntToStr(ColorDomSelected+1)+' / '+IntToStr(Length(ColorDoms));
 case ColorDoms[ColorDomSelected].ColorType of
  ctBoneText: lbColorX.Caption:='Tb';
  ctMeatText: lbColorX.Caption:='Tm';
  ctSkinOutline: lbColorX.Caption:='Oc';
  ctDiffOutline: lbColorX.Caption:='Od';
  ctOther: lbColorX.Caption:='X';
 end;

 sbSetDominator.Caption:='SET';

end;

procedure TGlyphForm.sbNextClrClick(Sender: TObject);
begin
 Inc(ColorDomSelected,(Sender as TComponent).Tag);
 ColorDomSelected:=Max(ColorDomSelected,0);
 ColorDomSelected:=Min(ColorDomSelected,Length(ColorDoms)-1);
 UpdateColorDominator;
end;

procedure TGlyphForm.sbSetDominatorClick(Sender: TObject);
begin
 ColorDoms[ColorDomSelected].R:=StrToIntDef(edRT.Text,0);
 ColorDoms[ColorDomSelected].G:=StrToIntDef(edGT.Text,0);
 ColorDoms[ColorDomSelected].B:=StrToIntDef(edBT.Text,0);
 ColorDoms[ColorDomSelected].RD:=StrToIntDef(edRDT.Text,0);
 ColorDoms[ColorDomSelected].GD:=StrToIntDef(edGDT.Text,0);
 ColorDoms[ColorDomSelected].BD:=StrToIntDef(edBDT.Text,0);
 UpdateColorDominator;
end;

procedure TGlyphForm.ImageOrigMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var CL: TColor; R,G,B: byte;
    s: string;
    RR, GG, BB, RD, GD, BD, Ctr: integer;

begin
 X:=Round(X*XFactor);
 Y:=Round(Y*YFactor);
 s:='X: '+IntToStr(X)+'; Y: '+IntToStr(Y);
 CL:=ImageOrig.Picture.Bitmap.Canvas.Pixels[X,Y];
 R:= CL and $FF;
 G:= (CL shr 8) and $FF;
 B:= (CL shr 16) and $FF;
 s:=s+' Color: R = '+IntToStr(R)+', G = '+IntToStr(G)+', B = '+IntToStr(B);
 Ctr:=0;
 RD:=StrToIntDef(edRDT.Text,0);
 GD:=StrToIntDef(edGDT.Text,0);
 BD:=StrToIntDef(edBDT.Text,0);
{ for RR:=Max(0,R-RD) to Min(255,R+RD) do
 for GG:=Max(0,G-GD) to Min(255,G+GD) do
 for BB:=Max(0,B-BD) to Min(255,B+BD) do Inc(Ctr,FullColorMap[RR,GG,BB]);
 s:=s+' ( '+IntToStr(Ctr)+' pixels in picture withing given difference)';}

 stbMain.Panels[0].Text:=s;

end;

procedure TGlyphForm.sbDeleteClrClick(Sender: TObject);
var i:integer;
begin
//
 for i:=ColorDomSelected to Length(ColorDoms)-2 do
  ColorDoms[i]:=ColorDoms[i+1];
 if (Length(ColorDoms)>1) then SetLength(ColorDoms,Length(ColorDoms)-1);
 UpdateColorDominator;
end;

procedure TGlyphForm.tbsOCRResultShow(Sender: TObject);
begin
 sgOCRResults.DefaultColWidth:=(sgOCRResults.Width div 2)-20;
 sgOCRResults.RowCount:=PreOCRList.Count;
 sgOCRResults.Cols[0].Assign(PreOCRList);
 sgOCRResults.Cols[1].Assign(PostOCRList);
end;

procedure TGlyphForm.btStartClick(Sender: TObject);
begin
 CurrentOCRLine:=0;
 edOCRItem.Text:=IntToStr(CurrentOCRLine);
 GetOCRItem;
end;

procedure TGlyphForm.GetOCRItem;
var i:integer; s:string; HasFile: boolean;
begin
 if (CurrentOCRLine<0) then exit;
 if (PreOCRList.Count<=CurrentOCRLine) then exit;

 i:=CurrentOCRLine;
 while (i<PreOCRList.Count) do
 begin
  s:=PreOCRList[i];
  CurrentOCRLine:=i;
  edOCRItem.Text:=IntToStr(CurrentOCRLine);
  HasFile:=false;
  if FileExists(s) then begin OpenBitmap(s); HasFile:=true end;
//  if FileExists(s) then begin OpenBitmap(s); HasFile:=true end;
  if not(HasFile) then s:=OpenList.InitialDir+s;
  if not(HasFile) then if  (FileExists(s)) then begin OpenBitmap(s); HasFile:=true end;
  i:=CurrentOCRLine; if not(HasFile) then inc(i);
  if (HasFile) then break;
 end;
 CurrentOCRLine:=i;
 edOCRItem.Text:=IntToStr(CurrentOCRLine);
// if (CurrentOCRLine<0) then exit;
// if (PreOCRList.Count<=CurrentOCRLine) then exit;
end;

procedure TGlyphForm.btNextClick(Sender: TObject);
begin
 SaveIgnorePoints(ChangeFileExt(PreOCRList[CurrentOCRLine],'.ign'));
 Inc(CurrentOCRLine);
 edOCRItem.Text:=IntToStr(CurrentOCRLine);
 GetOCRItem;
end;

procedure TGlyphForm.btLoadBaseGlyphsClick(Sender: TObject);
begin
 OpenSymbolList.InitialDir:=edGlyphDir.Text;
 if not(OpenSymbolList.Execute) then exit;
 LoadSymbolsFrom(OpenSymbolList.FileName);
end;

procedure TGlyphForm.LoadSymbolsFrom;
var SL:TStringList; Ctr: integer; s, s1:string;
    Bmp:TBitmap;
begin
 Begin
  SL:=TStringList.Create;
  try
   SL.LoadFromFile(OpenSymbolList.FileName);
   Ctr:=0;
   s1:=Format('%.6d',[Ctr]);
   while not(SL.Values['GS'+s1]='') do
   begin
    Bmp:=TBitmap.Create;
    if FileExists(SL.Values['GP'+s1]) then Bmp.LoadFromFile(SL.Values['GP'+s1])
    else Bmp.LoadFromFile(OpenSymbolList.InitialDir+ExtractFileName(SL.Values['GP'+s1]));
    SetLength(BaseSymbols,Length(BaseSymbols)+1);
//    GetMem(BaseSymbols[Length(BaseSymbols)-1],SizeOf(TBaseSymbol));
    BaseSymbols[Length(BaseSymbols)-1].Text:=SL.Values['GS'+s1];
    BaseSymbols[Length(BaseSymbols)-1].Bmp:=Bmp;
    BaseSymbols[Length(BaseSymbols)-1].UsesIA:=false;
    BaseSymbols[Length(BaseSymbols)-1].AreaCount:=0;
    OptimizeBaseSymbols;
    BaseSymbols[Length(BaseSymbols)-1].IsItalic:=(Pos('I',SL.Values['GI'+s1])>0); 
    BaseSymbols[Length(BaseSymbols)-1].IsBold:=(Pos('B',SL.Values['GI'+s1])>0);
    BaseSymbols[Length(BaseSymbols)-1].IsUnderline:=(Pos('U',SL.Values['GI'+s1])>0);

    inc(Ctr);
    s1:=Format('%.6d',[Ctr]);
   end;
  finally SL.Free; {Bmp.Free;}
  end;
{ for i:=0 to Length(BaseSymbols)-1 do
// if Glyphs[i].IsBase then
 begin
//  Bmp:=Glyphs[i].Text;
  Bmp:=GetBaseSymbolBitmap(i);
  s:=Format('%s\%.6d.bmp',[Trim(edGlyphDir.Text), i]);
  Bmp.SaveToFile(s);
  s1:=Format('%.6d',[i]);
  SL.Add('GS'+s1+'='+BaseSymbols[i].Text);//Glyphs[i].Equals);
  SL.Add('GP'+s1+'='+s);
 end;
 SL.SaveToFile( Format('%s\asd_base.sym',[Trim(edGlyphDir.Text)]));
 finally
  SL.Free;
 end;}

 End;
 tbsGlyphsShow(Self);
end;

procedure TGlyphForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Res, Start, Off: integer;  
begin
 if Button=mbRight then
 begin
//  MaskToBitmap((Sender as TImage).Picture.Bitmap,RefineSymbolForm.Image.Picture.Bitmap);
  RefineSymbolForm.Image.Picture.Bitmap.Assign((Sender as TImage).Picture.Bitmap);
  Res:=RefineSymbolForm.ShowModal;
  if Res=mrOk then
  begin
   Off:=(Sender as TComponent).Tag;
   Start:=sclGlyphScroll.Position;
   if (BaseSymbols[Start+Off].UsesIA) then
    BaseSymbols[Start+Off].Bmp:=TBitmap.Create;
    BaseSymbols[Start+Off].Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
    BaseSymbols[Start+Off].UsesIA:=false;
   OptimizeBaseSymbols;
//   GlyphImages[Off].Picture.Bitmap.Assign(GetBaseSymbolBitmap(i+Start));
    
  end;
 end;
 tbsGlyphsShow(Sender);
end;

procedure TGlyphForm.ImageMask3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbLeft then
 begin
  XL:=Round(X*XFactor);
  YL:=Round(Y*YFactor);
 end
 else begin XL:=-1; YL:=-1; end;
end;

procedure TGlyphForm.edRTChange(Sender: TObject);
begin
 sbSetDominator.Caption:='*SET*';
end;

procedure TGlyphForm.UpdateTimerTimer(Sender: TObject);
begin
if (Sender as TComponent).Tag=4 then
begin
if UpdateTimer2.Enabled then
begin
 UpdateTimer2.Enabled:=false;
// if sbAutoColorAnalyzis.Down then btAnalyzeClick(Self);
 Application.ProcessMessages;

 btBuildMasksXClick(nil);
 Application.ProcessMessages;
 btAddGlyphsClick(nil);
 Application.ProcessMessages;
 if not sbPause.Down then ModalResult:=mrOk;
end 
end else
if not(DisableMaskUpdate) then
if UpdateTimer.Enabled then
 begin
  UpdateTimer.Enabled:=false;
  btBuildMasksXClick(Sender);
 end;
end;

procedure TGlyphForm.btBuildMasksClick;
var i: integer;
begin
 UpdateTimer.Enabled:=false;
 i:=StrToIntDef(edUpdateDelay.Text,1000); if i<0 then i:=0;
 UpdateTimer.Interval:=i;
 UpdateTimer.Enabled:=true;
 btBuildMasksX.Caption:='* Build Masks *';
end;

function TGlyphForm.GlyphSubMatch;

var    DataSorted: TGlyphData;
       X, Y: integer; 

function PointInRect(Pnt: TPoint; Rct: TRect): boolean;
begin
 Result:=((Pnt.x<Rct.Right) and (Pnt.x>Rct.Left))
     and ((Pnt.y<Rct.Bottom) and (Pnt.y>Rct.Top));
end;

function InBetween(X, X1, X2: integer):boolean;
begin
 Result:=(X>Min(X1,X2)) and (X<Max(X1,X2));
end;

function BlastAreaCross(i1, j1: integer):boolean;
var i,j: integer;
    X1, Y1, X2, Y2,
    XX1, YY1, XX2, YY2, Res:integer;
    Crossed: Boolean;
begin
  X1:=DataSorted.Areas[i1].X1;
  X2:=DataSorted.Areas[i1].X2;
  Y1:=DataSorted.Areas[i1].Y1;
  Y2:=DataSorted.Areas[i1].Y2;
  XX1:=DataSorted.Areas[j1].X1;
  XX2:=DataSorted.Areas[j1].X2;
  YY1:=DataSorted.Areas[j1].Y1;
  YY2:=DataSorted.Areas[j1].Y2;
   Crossed:=false;
   Crossed := Crossed or (InBetween(XX1, X1, X2));
   Crossed := Crossed or (InBetween(XX2, X1, X2));
//   Crossed:=Crossed or PointInRect(Point(XX1,YY1),Rect(X1,Y1,X2,Y2));
//   Crossed:=Crossed or PointInRect(Point(XX1,YY2),Rect(X1,Y1,X2,Y2));
//   Crossed:=Crossed or PointInRect(Point(XX2,YY1),Rect(X1,Y1,X2,Y2));
//   Crossed:=Crossed or PointInRect(Point(XX2,YY2),Rect(X1,Y1,X2,Y2));
   if Crossed then
   begin
     DataSorted.Areas[j1].AreaEnabled:=false;
     DataSorted.Areas[j1].AreaMatch:=REGION_ABORT;
//     X:=GlyphRects[num].Left+DataSorted.Areas[j1].FX-1;
//     Y:=GlyphRects[num].Top+DataSorted.Areas[j1].FY-1;
//     AddTextIgnorePoint(Point(X,Y),true);
     RemoveArea(DataSorted.Areas[j1].GlobalAreaNum);//,DataSorted.Areas[j1].AreaNum,num);

   end;
   Result:=Crossed;
end;

procedure RemoveIntersecting;
var i,j: integer;
    X1, Y1, X2, Y2,
    XX1, YY1, XX2, YY2, Res:integer;
    Crossed: Boolean;
begin
 for i:=1 to DataSorted.AreaCount do
 if (DataSorted.Areas[i].AreaMatch<>REGION_UNKNOWN)
 and (DataSorted.Areas[i].AreaMatch<>REGION_ABORT) then
 begin
  X1:=DataSorted.Areas[i].X1;
  X2:=DataSorted.Areas[i].X2;
  Y1:=DataSorted.Areas[i].Y1;
  Y2:=DataSorted.Areas[i].Y2;
  for j:=1 to DataSorted.AreaCount do
  if j<>i then
  begin
   Crossed:=false;
   XX1:=DataSorted.Areas[j].X1;
   XX2:=DataSorted.Areas[j].X2;
   YY1:=DataSorted.Areas[j].Y1;
   YY2:=DataSorted.Areas[j].Y2;
   Crossed:=Crossed or PointInRect(Point(XX1,YY1),Rect(X1,Y1,X2,Y2));
   Crossed:=Crossed or PointInRect(Point(XX1,YY2),Rect(X1,Y1,X2,Y2));
   Crossed:=Crossed or PointInRect(Point(XX2,YY1),Rect(X1,Y1,X2,Y2));
   Crossed:=Crossed or PointInRect(Point(XX2,YY2),Rect(X1,Y1,X2,Y2));
   if Crossed then
   begin
     DataSorted.Areas[j].AreaMatch:=REGION_ABORT;
//     X:=GlyphRects[num].Left+DataSorted.Areas[j].FX-1;
//     Y:=GlyphRects[num].Top+DataSorted.Areas[j].FY-1;
//     AddTextIgnorePoint(Point(X,Y),true);
     RemoveArea(DataSorted.Areas[j].GlobalAreaNum);//,DataSorted.Areas[j].AreaNum,num);
   end;
//   else DataSorted.Areas[j].AreaMatch:=REGION_CHECK_FULL;
  end;
  //and not(IsVerticalMatched(Rect(X1,Y1,X2,Y2),Rect(XX1,YY1,XX2,YY2)))  
 end;
end;

procedure RemoveInside;
var i,j: integer;
    X1, Y1, X2, Y2,
    XX1, YY1, XX2, YY2, Res:integer;
    Crossed: Boolean;
begin
 for i:=1 to DataSorted.AreaCount do
 if (DataSorted.Areas[i].AreaMatch<>REGION_UNKNOWN)
 and (DataSorted.Areas[i].AreaMatch<>REGION_ABORT) then
 begin
  X1:=DataSorted.Areas[i].X1;
  X2:=DataSorted.Areas[i].X2;
  Y1:=DataSorted.Areas[i].Y1;
  Y2:=DataSorted.Areas[i].Y2;
  for j:=1 to DataSorted.AreaCount do
  if j<>i then
  begin
   Crossed:=false;
   XX1:=DataSorted.Areas[j].X1;
   XX2:=DataSorted.Areas[j].X2;
   YY1:=DataSorted.Areas[j].Y1;
   YY2:=DataSorted.Areas[j].Y2;
   Crossed:=Crossed or
   (         ((XX1>X1) and (XX1<X2))
        and ((XX2>X1) and (XX2<X2))
        and ((YY1>Y1) and (YY1<Y2))
        and ((YY2>Y1) and (YY2<Y2))
   );
   if Crossed then
   begin
     DataSorted.Areas[j].AreaMatch:=REGION_ABORT;
//     X:=GlyphRects[num].Left+DataSorted.Areas[j].FX-1;
//     Y:=GlyphRects[num].Top+DataSorted.Areas[j].FY-1;
//     AddTextIgnorePoint(Point(X,Y),true);
     RemoveArea(DataSorted.Areas[j].GlobalAreaNum);//,DataSorted.Areas[j].AreaNum,num);

   end;
//   else DataSorted.Areas[j].AreaMatch:=REGION_CHECK_FULL;
  end;
  //and not(IsVerticalMatched(Rect(X1,Y1,X2,Y2),Rect(XX1,YY1,XX2,YY2)))  
 end;
end;

procedure PrepareAreaBitmap(Bmp: TBitmap; Num, i {Area}: integer); overload;
begin
  Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
  BitBlt(Bmp.Canvas.Handle,0,0,
  DataSorted.Areas[i].X2-DataSorted.Areas[i].X1+6,
  DataSorted.Areas[i].Y2-DataSorted.Areas[i].Y1+6,
  RefineSymbolForm.Image.Picture.Bitmap.Canvas.Handle,
  DataSorted.Areas[i].X1,DataSorted.Areas[i].Y1,
  SRCCOPY);
  Bmp.Width:=DataSorted.Areas[i].X2-DataSorted.Areas[i].X1+6;
  Bmp.Height:=DataSorted.Areas[i].Y2-DataSorted.Areas[i].Y1+6;
  BitBlt(Bmp.Canvas.Handle,1,1,
  DataSorted.Areas[i].X2-DataSorted.Areas[i].X1+6,
  DataSorted.Areas[i].Y2-DataSorted.Areas[i].Y1+6,
  RefineSymbolForm.Image.Picture.Bitmap.Canvas.Handle,
  DataSorted.Areas[i].X1,DataSorted.Areas[i].Y1,
  SRCCOPY);
end;

procedure PrepareAreaBitmap(Bmp: TBitmap; Rct: TRect); overload;
begin
  Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
  BitBlt(Bmp.Canvas.Handle,0,0,
  Rct.Right-Rct.Left+6,Rct.Bottom-Rct.Top+6,
//  DataSorted.Areas[i].X2-DataSorted.Areas[i].X1+6,
//  DataSorted.Areas[i].Y2-DataSorted.Areas[i].Y1+6,
  RefineSymbolForm.Image.Picture.Bitmap.Canvas.Handle,
  Rct.Left, Rct.Top,
//  DataSorted.Areas[i].X1,DataSorted.Areas[i].Y1,
  SRCCOPY);
  Bmp.Width:=Rct.Right-Rct.Left+6;
  Bmp.Height:=Rct.Bottom-Rct.Top+6;
  BitBlt(Bmp.Canvas.Handle,1,1,
  Rct.Right-Rct.Left+6,
  Rct.Bottom-Rct.Top+6,
//  DataSorted.Areas[i].X2-DataSorted.Areas[i].X1+6,
//  DataSorted.Areas[i].Y2-DataSorted.Areas[i].Y1+6,
  RefineSymbolForm.Image.Picture.Bitmap.Canvas.Handle,
  Rct.Left, Rct.Top,
//  DataSorted.Areas[i].X1,DataSorted.Areas[i].Y1,
  SRCCOPY);
end;


var i, j: integer;
    Bmp, BmpCpy:TBitmap;
//    PX, PX2:PByteArray;
//    Cl: TColor;
//    Crossed: boolean;
    st: string;
    Res: integer;
    label REPEAT_CYCLE, FINISH_SUBMATCH;

procedure AutoProcessDoubleRegions;
var i,j,l, j1, l1, i1, Ctr: integer; RctX: TRect;
//    GlyphDataX: TGlyphData;
   ArX: array of TArea;
   ArBX: array of integer;
   ArDX: array of integer;
   CtrX: array of integer;
   MatchTo: array of set of byte;
   AreaSet: set of byte;
   CurrentSet: set of byte;
   PosMatch: boolean;

{function CheckAreaMatch(BaseNum): boolean;
var CtrX: integer;
begin
 CtrX:=0;
 for i:=1 to BaseSymbols[BaseNum].AreaCount do
  if abs((BaseSymbols[i].Areas[j].X2-BaseSymbols[i].Areas[j].X1)
     -(DataSorted.Areas[l].X2-DataSorted.Areas[l].X1))<4 then
  if abs((BaseSymbols[i].Areas[j].Y2-BaseSymbols[i].Areas[j].Y1)
     -(DataSorted.Areas[l].Y2-DataSorted.Areas[l].Y1))<4 then

end;}

begin
// RefineSymbolForm.ShowModal;
// for i:=1 to 255 do GlyphDataX.Areas[i].AreaEnabled:=false;

 if DataSorted.AreaCount<2 then exit;
 for i:=0 to Length(BaseSymbols)-1 do
 if BaseSymbols[i].AreaCount>1 then
 if BaseSymbols[i].AreaCount<=DataSorted.AreaCount then
 BEGIN
 SetLength(ArX,0);
 SetLength(ArBX,0);
 SetLength(ArDX,0);
 SetLength(MatchTo,0);
 AreaSet:=[];
 for l:=1 to DataSorted.AreaCount do
 for j:=1 to BaseSymbols[i].AreaCount do
 if DataSorted.Areas[l].AreaMatch[1]<REGION_SUB_ELEMENT then
  if abs((BaseSymbols[i].Areas[j].X2-BaseSymbols[i].Areas[j].X1)
     -(DataSorted.Areas[l].X2-DataSorted.Areas[l].X1))<4 then
  if abs((BaseSymbols[i].Areas[j].Y2-BaseSymbols[i].Areas[j].Y1)
     -(DataSorted.Areas[l].Y2-DataSorted.Areas[l].Y1))<4 then
  BEGIN //adding ALL areas matching by size
    SetLength(ArX,Length(ArX)+1); //adding first area
    ArX[Length(ArX)-1]:=DataSorted.Areas[l];
    SetLength(ArBX,Length(ArBX)+1);
    ArBX[Length(ArBX)-1]:=j; //base area number
    SetLength(ArDX,Length(ArDX)+1);
    ArDX[Length(ArDX)-1]:=l; //sorted area number
    AreaSet:=AreaSet+[(Length(ArX)-1)];//[l and $FF];
  END;
  if Length(ArX)>=BaseSymbols[i].AreaCount then //for equal amount of areas, checking direct positional matching is sufficient
  begin
   Ctr:=0;
   SetLength(CtrX,Length(ArBX));
   SetLength(MatchTo,Length(ArBX));
   for i1:=0 to Length(ArBX)-1 do CtrX[i1]:=0;
   for i1:=0 to Length(ArBX)-1 do MatchTo[i1]:=[];
   for i1:=1 to Length(ArBX) do
   for j1:=i1+1 to Length(ArBX) do
   begin
    if abs(abs(BaseSymbols[i].Areas[ArBX[i1-1]].X1-BaseSymbols[i].Areas[ArBX[j1-1]].X1)-
       abs(ArX[i1-1].X1-ArX[j1-1].X1))<4 then
    if abs(abs(BaseSymbols[i].Areas[ArBX[i1-1]].X2-BaseSymbols[i].Areas[ArBX[j1-1]].X2)-
       abs(ArX[i1-1].X2-ArX[j1-1].X2))<4 then
    if abs(abs(BaseSymbols[i].Areas[ArBX[i1-1]].Y1-BaseSymbols[i].Areas[ArBX[j1-1]].Y1)-
       abs(ArX[i1-1].Y1-ArX[j1-1].Y1))<4 then
    if abs(abs(BaseSymbols[i].Areas[ArBX[i1-1]].Y2-BaseSymbols[i].Areas[ArBX[j1-1]].Y2)-
       abs(ArX[i1-1].Y2-ArX[j1-1].Y2))<4 then
       begin
        inc(Ctr,2);
        inc(CtrX[i1-1]);
        inc(CtrX[j1-1]);
        MatchTo[i1-1]:=MatchTo[i1-1]+[j1-1];
        MatchTo[j1-1]:=MatchTo[j1-1]+[i1-1];
       end;
   end;
   if Ctr>=(BaseSymbols[i].AreaCount-1) then
   while (AreaSet<>[]) and (Ctr>=(BaseSymbols[i].AreaCount-1)) do
   begin
    RefineSymbolForm.DisableAll; CurrentSet:=[];
    i1:=0; while not(i1 in AreaSet) and (i1<Length(ArX)) do inc(i1);
    AreaSet:=AreaSet-[i1];
    CurrentSet:=CurrentSet+[i1];
    RctX:=Rect(ArX[i1].X1, ArX[i1].Y1, ArX[i1].X2, ArX[i1].Y2);
    RefineSymbolForm.EnableAreaX(ArX[i1].AreaNum-1);
    Dec(Ctr);
    for j1:=0 to Length(ArX)-1 do
    if ((j1) in MatchTo[i1]) then
    begin
     RefineSymbolForm.EnableAreaX(ArX[j1].AreaNum-1);
     RctX:=MergeRectX(RctX,Rect(ArX[j1].X1, ArX[j1].Y1, ArX[j1].X2, ArX[j1].Y2));
     AreaSet:=AreaSet-[j1];
     CurrentSet:=CurrentSet+[j1];
     Dec(Ctr);
    end;

//    for i1:=0 to Length(ArX)-1 do
//    if CtrX[i1]>0 then RefineSymbolForm.EnableAreaX(ArX[i1].AreaNum-1);
{    for i1:=0 to Length(ArX)-1 do
     if CtrX[i1]>0 then
     begin RctX:=Rect(ArX[i1].X1, ArX[i1].Y1, ArX[i1].X2, ArX[i1].Y2); break; end;
    for i1:=1 to Length(ArX)-1 do
    if CtrX[i1]>0 then
     RctX:=MergeRectX(RctX,Rect(ArX[i1].X1, ArX[i1].Y1, ArX[i1].X2, ArX[i1].Y2));}
    PrepareAreaBitmap(Bmp,RctX);
    st:=CheckGlyphX(Bmp,RctX);{Rect(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y1-2,
                           GlyphRects[num].Left+DataSorted.Areas[i].X2+1,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y2+1)}
    if st>REGION_REMOVE then
    begin
     DataSorted.Areas[ArDX[i1]].AreaMatch:=st; //first gets symbol, other gets "element" sign
     CurrentSet:=CurrentSet-[i1];
     for j1:=0 to Length(ArDX)-1 do
     if (j1 in CurrentSet) then DataSorted.Areas[ArDX[j1]].AreaMatch:=REGION_SUB_ELEMENT;
    end;

   end;
  end;
 END;
 SetLength(ArX,0);
 SetLength(ArBX,0);
 SetLength(ArDX,0);

{ for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch<>REGION_ABORT then
 if DataSorted.Areas[i].AreaEnabled then
 for j:=i+1 to DataSorted.AreaCount do
 if DataSorted.Areas[j].AreaMatch<>REGION_ABORT then
 if DataSorted.Areas[j].AreaEnabled then
 begin
  RefineSymbolForm.EnableArea(DataSorted.Areas[i].AreaNum-1);
  RefineSymbolForm.EnableArea(DataSorted.Areas[j].AreaNum-1);
//  GlyphDataX.Areas[1]:=DataSorted.Areas[i];
//  GlyphDataX.Areas[2]:=DataSorted.Areas[j];
//  Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
  RctX:=MergeRectX(Rect(DataSorted.Areas[i].X1,
                        DataSorted.Areas[i].Y1,
                        DataSorted.Areas[i].X2,
                        DataSorted.Areas[i].Y2),
                   Rect(DataSorted.Areas[j].X1,
                        DataSorted.Areas[j].Y1,
                        DataSorted.Areas[j].X2,
                        DataSorted.Areas[j].Y2)
                        );
  PrepareAreaBitmap(Bmp,RctX);


  st:=CheckGlyphX(Bmp,Rect(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y1-2,
                           GlyphRects[num].Left+DataSorted.Areas[i].X2+1,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y2+1),
//                           GlyphDataX,
                           true);
  DataSorted.Areas[i].AreaMatch:=st;
  if sbEliminateIntersectingMatch.Down then
  if st<>REGION_UNKNOWN then RemoveIntersecting; //maybe it should be moved to later
  if sbStrikeLine.Down then
  if st<>REGION_UNKNOWN then
  begin
   l:=Length(TextIgnoreLine);
   //Strike Lines above and below
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           DataSorted.Areas[i].Y1+GlyphRects[num].Top-3));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X2+GlyphRects[num].Left+1,
                           DataSorted.Areas[i].Y1+GlyphRects[num].Top-3));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           DataSorted.Areas[i].Y2+GlyphRects[num].Top+1));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X2+GlyphRects[num].Left+1,
                           DataSorted.Areas[i].Y2+GlyphRects[num].Top+1));
   if Length(TextIgnoreLine)<>l then GlyphRectsRemoved:=true;
  end;
  if sbEliminateInsideMatch.Down then
  if st<>REGION_UNKNOWN then RemoveInside;
//  if st<>REGION_UNKNOWN then Result:=Result+st;
 end;}
end;

procedure AutoProcessSingleRegions;
var i: integer;                                       
begin
// RefineSymbolForm.ShowModal;
 for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch<>REGION_ABORT then
 if DataSorted.Areas[i].AreaMatch<>REGION_SUB_ELEMENT then
 if DataSorted.Areas[i].AreaMatch<REGION_SUB_ELEMENT then
 if DataSorted.Areas[i].AreaEnabled then
 begin
  RefineSymbolForm.EnableArea(DataSorted.Areas[i].AreaNum-1);
//  Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
  PrepareAreaBitmap(Bmp,num,i);
  st:=CheckGlyphX(Bmp,Rect(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y1-2,
                           GlyphRects[num].Left+DataSorted.Areas[i].X2+1,
                           GlyphRects[num].Top+DataSorted.Areas[i].Y2+1),
                           true);
  DataSorted.Areas[i].AreaMatch:=st;
  if sbEliminateIntersectingMatch.Down then
  if st<>REGION_UNKNOWN then RemoveIntersecting; //maybe it should be moved to later
  if sbStrikeLine.Down then
  if st<>REGION_UNKNOWN then
  begin
   j:=Length(TextIgnoreLine);
   //Strike Lines above and below
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           DataSorted.Areas[i].Y1+GlyphRects[num].Top-3));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X2+GlyphRects[num].Left+1,
                           DataSorted.Areas[i].Y1+GlyphRects[num].Top-3));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X1+GlyphRects[num].Left-2,
                           DataSorted.Areas[i].Y2+GlyphRects[num].Top+1));
   AddTextIgnoreLine(Point(DataSorted.Areas[i].X2+GlyphRects[num].Left+1,
                           DataSorted.Areas[i].Y2+GlyphRects[num].Top+1));
   if Length(TextIgnoreLine)<>j then GlyphRectsRemoved:=true;
  end;
  if sbEliminateInsideMatch.Down then
  if st<>REGION_UNKNOWN then
   RemoveInside;
//  if st<>REGION_UNKNOWN then Result:=Result+st;
 end;
end;

begin
 Result:='';
 DataSorted:=GlyphData[num];
 if DataSorted.AreaCount<2 then exit;

 DataSorted:=SortGlyphDataBySize(GlyphData[num]);

 Bmp:=TBitmap.Create;
 BmpCpy:=GetNewGlyphBitmap(Num);
 RefineSymbolForm.SetBitmap(BmpCpy);

 AutoProcessDoubleRegions;
 AutoProcessSingleRegions;

 //destroying areas intersecting with good match and without good match themselves

 for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch='' then
     begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[i].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[i].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[i].GlobalAreaNum);//,DataSorted.Areas[i].AreaNum,num);

     end;
 for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch='' then
 begin
      Result:=REGION_REMOVE;
      goto FINISH_SUBMATCH;
 end;

 //vertical blasting
 if sbEliminateIntersectingXMatch.Down then
 for i:=1 to DataSorted.AreaCount do
// if DataSorted.Areas[i].AreaMatch<>'' then
 if DataSorted.Areas[i].AreaEnabled then
 if DataSorted.Areas[i].AreaMatch[1]>REGION_REMOVE then
 for j:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[j].AreaEnabled then
 if DataSorted.Areas[j].AreaMatch[1]<=REGION_REMOVE then
 if BlastAreaCross(i,j) then Result:=REGION_REMOVE;

 if Result=REGION_REMOVE then goto FINISH_SUBMATCH;

 if GlyphRectsRemoved then goto FINISH_SUBMATCH;

REPEAT_CYCLE:
 for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch=REGION_UNKNOWN then
 if DataSorted.Areas[i].AreaEnabled then
 begin
  RefineSymbolForm.EnableArea(DataSorted.Areas[i].AreaNum-1);
//  Bmp:=TBitmap.Create;
  PrepareAreaBitmap(Bmp,num,i);


  AddSymbolForm.btUseFullRect.Enabled:=true;
//  AddSymbolForm.btRefine.Enabled:=true;
  st:=CheckGlyphX(Bmp,Rect(GlyphRects[num].Left+DataSorted.Areas[i].X1-2,
                           GlyphRects[num].Top +DataSorted.Areas[i].Y1-2,
                           GlyphRects[num].Left+DataSorted.Areas[i].X2+2,
                           GlyphRects[num].Top +DataSorted.Areas[i].Y2+2),
                           false);
  AddSymbolForm.btUseFullRect.Enabled:=false;
//  AddSymbolForm.btRefine.Enabled:=false;
  if st=REGION_REMOVE then
  if not(sbDisableNewSymbols.Down) then
  begin
   RefineSymbolForm.EnableAll;
   Res:=RefineSymbolForm.ShowModal;
   if Res=mrOk then
   begin
   for j:=1 to DataSorted.AreaCount do
    begin
     DataSorted.Areas[j].AreaEnabled:=RefineSymbolForm.clbAreas.Checked[DataSorted.Areas[j].AreaNum-1];
     if not(DataSorted.Areas[j].AreaEnabled) then
     begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[j].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[j].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[j].GlobalAreaNum);//,DataSorted.Areas[j].AreaNum,num);

     end;
    end;
   end;
//    goto REPEAT_CYCLE;
    Result:=REGION_REMOVE;
    goto FINISH_SUBMATCH;
   end
   else
    if sbIgnoreAllNew.Down then
    begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[i].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[i].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[i].GlobalAreaNum);//,DataSorted.Areas[i].AreaNum,num);

    end
    else
    if (GlyphRects[num].Top +DataSorted.Areas[i].Y2+2-(GlyphRects[num].Top +DataSorted.Areas[i].Y1-2))<StrToIntDef(edMinTextHeight.Text,40)
    then
    begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[i].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[i].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[i].GlobalAreaNum);//,DataSorted.Areas[i].AreaNum,num);
    end
    else
  begin
   RefineSymbolForm.EnableAll;
   Res:=RefineSymbolForm.ShowModal;
   if Res=mrOk then
   begin
   for j:=1 to DataSorted.AreaCount do
    begin
     DataSorted.Areas[j].AreaEnabled:=RefineSymbolForm.clbAreas.Checked[DataSorted.Areas[j].AreaNum-1];
     if not(DataSorted.Areas[j].AreaEnabled) then
     begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[j].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[j].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[j].GlobalAreaNum)//,DataSorted.Areas[j].AreaNum,num);
     end;
    end;
   end;
//    goto REPEAT_CYCLE;
    Result:=REGION_REMOVE;
    goto FINISH_SUBMATCH;
  end;

  DataSorted.Areas[i].AreaMatch:=st;
  if st<>REGION_UNKNOWN then
  if st<>REGION_ABORT then
  if sbEliminateIntersectingMatch.Down then
  if st<>REGION_CHECK_FULL then RemoveIntersecting;
  if st=REGION_ABORT then
  begin
     Result:=REGION_ABORT;
     goto FINISH_SUBMATCH;
  end;
  if (st=REGION_CHECK_FULL) then
   begin
    { Bmp:=TBitmap.Create;
     RefineSymbolForm.EnableAll;
     Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
     st:=CheckGlyphX(Bmp,GlyphRects[num],false);
     Result:=st;}
     Result:=REGION_UNKNOWN;
     goto FINISH_SUBMATCH;
   end;
 end;


// DataSorted:=SortGlyphDataByLeft(GlyphData[num]);
 DataSorted:=SortGlyphDataByLeft(DataSorted);
 Result:='';
 for i:=1 to DataSorted.AreaCount do
  if DataSorted.Areas[i].AreaEnabled then
  if DataSorted.Areas[i].AreaMatch<>REGION_UNKNOWN then
  if DataSorted.Areas[i].AreaMatch<>REGION_ABORT then
  if DataSorted.Areas[i].AreaMatch<>REGION_CHECK_FULL then
  if DataSorted.Areas[i].AreaMatch>REGION_SUB_ELEMENT then
  Result:=Result+DataSorted.Areas[i].AreaMatch;
// Image.Picture.Bitmap.Assign((Sender as TImage).Picture.Bitmap);
 if Result='' then Result:=REGION_UNKNOWN;

 if sbDisableNewSymbols.Down then
 for i:=1 to DataSorted.AreaCount do
  if DataSorted.Areas[i].AreaEnabled then
  if DataSorted.Areas[i].AreaMatch=REGION_UNKNOWN then
  begin
//      X:=GlyphRects[num].Left+DataSorted.Areas[i].FX-1;
//      Y:=GlyphRects[num].Top+DataSorted.Areas[i].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(DataSorted.Areas[i].GlobalAreaNum)//,DataSorted.Areas[i].AreaNum,num);
  end;

//  Result:=st;
FINISH_SUBMATCH:
 for i:=1 to DataSorted.AreaCount do
 if DataSorted.Areas[i].AreaMatch>REGION_REMOVE then
  GlyphData[num].Areas[DataSorted.Areas[i].AreaNum].AreaMatch:=DataSorted.Areas[i].AreaMatch;

 BmpCpy.Free;
 Bmp.Free;

end;

function TGlyphForm.SortGlyphDataByLeft;
var i, j:integer; Ar: TArea;
begin
 Result:=Data;
 for i:=1 to Result.AreaCount do
 for j:=i+1 to Result.AreaCount do
  if Result.Areas[i].X1>Result.Areas[j].X1 then
  begin
   Ar:=Result.Areas[i];
   Result.Areas[i]:=Result.Areas[j];
   Result.Areas[j]:=Ar;
  end;
  end;

function TGlyphForm.SortGlyphDataBySize;
var i, j:integer; Ar: TArea;
begin
 Result:=Data;
 for i:=1 to Result.AreaCount do
 for j:=i+1 to Result.AreaCount do
  if ((Result.Areas[i].X2-Result.Areas[i].X1)*(Result.Areas[i].Y2-Result.Areas[i].Y1))
    <((Result.Areas[j].X2-Result.Areas[j].X1)*(Result.Areas[j].Y2-Result.Areas[j].Y1)) then
  begin
   Ar:=Result.Areas[i];
   Result.Areas[i]:=Result.Areas[j];
   Result.Areas[j]:=Ar;
  end;
end;


procedure TGlyphForm.btSaveListClick(Sender: TObject);
var s:string;
begin
 s:=ChangeFileExt(ListFileName,'');
 s:=s+'.OCR.lst';
 sgOCRResults.Cols[1].SaveToFile(s);

end;


procedure TGlyphForm.lbColorXMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button=mbLeft then
 case ColorDoms[ColorDomSelected].ColorType of
  ctBoneText: ColorDoms[ColorDomSelected].ColorType:=ctMeatText;
  ctMeatText: ColorDoms[ColorDomSelected].ColorType:=ctSkinOutline;
  ctSkinOutline: ColorDoms[ColorDomSelected].ColorType:=ctDiffOutline;
  ctDiffOutline: ColorDoms[ColorDomSelected].ColorType:=ctOther;
  ctOther: ColorDoms[ColorDomSelected].ColorType:=ctBoneText;
 end
 else
 case ColorDoms[ColorDomSelected].ColorType of
  ctBoneText: ColorDoms[ColorDomSelected].ColorType:=ctOther;
  ctMeatText: ColorDoms[ColorDomSelected].ColorType:=ctBoneText;
  ctSkinOutline: ColorDoms[ColorDomSelected].ColorType:=ctMeatText;
  ctDiffOutline: ColorDoms[ColorDomSelected].ColorType:=ctSkinOutline;
  ctOther: ColorDoms[ColorDomSelected].ColorType:=ctDiffOutline;
 end;
 UpdateColorDominator;
end;

procedure TGlyphForm.LoadIgnorePoints;
var SL:TStringList; i, x, y:integer;
begin
SL:=TStringList.Create;
try
 SL.LoadFromFile(FileName);
 i:=0;
 while (SL.Values[Format('IP%.6dX',[i])]<>'') do
 begin
  AddTextIgnorePoint(Point(StrToIntDef(SL.Values[Format('IP%.6dX',[i])],0),
                           StrToIntDef(SL.Values[Format('IP%.6dY',[i])],0)));
  inc(i);                         
 end;
 i:=0;
 while (SL.Values[Format('IL%.6dX1',[i])]<>'') do
 begin
  AddTextIgnoreLine(Point(StrToIntDef(SL.Values[Format('IL%.6dX1',[i])],0),
                           StrToIntDef(SL.Values[Format('IL%.6dY1',[i])],0)));
  AddTextIgnoreLine(Point(StrToIntDef(SL.Values[Format('IL%.6dX2',[i])],0),
                           StrToIntDef(SL.Values[Format('IL%.6dY2',[i])],0)));
  inc(i);
 end;
finally
SL.Free;
end;

end;

procedure TGlyphForm.SaveIgnorePoints;
var SL:TStringList; i: integer;
begin
SL:=TStringList.Create;
try
 for i:=0 to Length(TextIgnore)-1 do
 begin
  SL.Add(Format('IP%.6dX=%.3d',[i, TextIgnore[i].x]));
  SL.Add(Format('IP%.6dY=%.3d',[i, TextIgnore[i].y]));
 end;
 for i:=0 to (Length(TextIgnoreLine) div 2)-1 do
 begin
  SL.Add(Format('IL%.6dX1=%.3d',[i, TextIgnoreLine[i*2].x]));
  SL.Add(Format('IL%.6dY1=%.3d',[i, TextIgnoreLine[i*2].y]));
  SL.Add(Format('IL%.6dX2=%.3d',[i, TextIgnoreLine[i*2+1].x]));
  SL.Add(Format('IL%.6dY2=%.3d',[i, TextIgnoreLine[i*2+1].y]));
 end;
 if SL.Count>0 then SL.SaveToFile(FileName);
//    TextIgnore: array of TPoint;
//    TextIgnoreLine: array of TPoint;
finally
SL.Free;
end;
end;


procedure TGlyphForm.btAnalyzeClick(Sender: TObject);
var i, j, X, Y, Shift, MX, RD, GD, BD,
   RDX, GDX, BDX, RDY, GDY, BDY,
   Ctr1, Ctr2, DD, DD1, DD2, BestDiv: integer;
   PX, PY, PXM, PYM: PByteArray;
   R, G, B, RY, GY, BY, RX, GX, BX: byte;
//   Map: ^TFullColorMap;
   Map16: ^TColorMap16;
   Map16_2: ^TColorMap16;
   MapRGB16: array[0..16,0..16,0..16] of TRGBInt64;
   s: string;
   BestRGB: array[0..9] of TRGB24CtrX;
   BestRGB1, BestRGB2,
   BestRGB1X, BestRGB2X, BestRGBX: TRGB24CtrX;
   TotalCtr: integer;
//   BmpDiff: TBitmap;
   IADiff: TImageArray;
   MT, MO: extended; //text and outline multipliers


procedure CreateDiffMask;
var i, X,Y, DD2: integer; BmpMask, BmpSrc: TBitmap;
    PX, PY, PX2, PY2: PByteArray;
    RP, GP, BP,
    RXP, GXP, BXP,
    RYP, GYP, BYP: ^byte;

begin

 BmpMask:=ImageMask4.Picture.Bitmap;
 BmpSrc:=ImageOrig.Picture.Bitmap;
 BmpMask.Canvas.Brush.Color:=clWhite;

 BmpMask.Width:=0;
 BmpMask.PixelFormat:=pf24bit;

 BmpMask.Width:=BmpSrc.Width;
 BmpMask.Height:=BmpSrc.Height;

// DD2:=(DD div 2)+1;
// DD2:=DD-1;
// DD2:=StrToIntDef(edFinalDelta.Text,32);
 try
  DD2:=Round(BestDiv*StrToFloat(edTextFinalDelta.Text));
 except
  DD2:=BestDiv{DD};
 end;
 for Y:=0 to BmpSrc.Height-1 do
 begin
  PX:=BmpSrc.ScanLine[Y];
  PX2:=BmpMask.ScanLine[Y];
  for X:=0 to BmpSrc.Width-1 do
  begin
   R:=PX[X*3+2]; G:=PX[X*3+1]; B:=PX[X*3];
   RP:=@PX2[X*3+2];    GP:=@PX2[X*3+1];    BP:=@PX2[X*3];


{   if (abs(R-RX)<DD2) and (abs(G-GX)<DD2) and (abs(B-BX)<DD2)
    then begin RP^:=128; GP^:=128; BP^:=128; end
   else
   if (abs(R-RY)<DD2) and (abs(G-GY)<DD2) and (abs(B-BY)<DD2)
    then begin RP^:=64; GP^:=64; BP^:=64; end;}
{   if (abs(R-BestRGB1.RA)<DD2) and (abs(G-BestRGB1.GA)<DD2) and (abs(B-BestRGB1.BA)<DD2)
    then begin RP^:=128; GP^:=128; BP^:=128; end
   else
   if (abs(R-BestRGB2.RA)<DD2) and (abs(G-BestRGB2.GA)<DD2) and (abs(B-BestRGB2.BA)<DD2)
    then begin RP^:=64; GP^:=64; BP^:=64; end;}
   if (abs(R-BestRGB1.RA)<BestRGB1.RAD) and (abs(G-BestRGB1.GA)<BestRGB1.GAD) and (abs(B-BestRGB1.BA)<BestRGB1.BAD)
    then begin RP^:=128; GP^:=128; BP^:=128; end
   else
   if (abs(R-BestRGB2.RA)<BestRGB2.RAD) and (abs(G-BestRGB2.GA)<BestRGB2.GAD) and (abs(B-BestRGB2.BA)<BestRGB2.BAD)
    then begin RP^:=64; GP^:=64; BP^:=64; end;


  end;
 end;


 ImageMask4.Visible:=true;

end;

procedure CreateDiffMaskX;
var i, j, X,Y, Ctr1, Ctr2: integer; BmpMask, BmpSrc: TBitmap;
    PX, PY, PX2, PY2: PByteArray;
    RP, GP, BP,
    RXP, GXP, BXP,
    RYP, GYP, BYP: ^byte;

begin

 BmpMask:=ImageMask4.Picture.Bitmap;
 BmpSrc:=ImageOrig.Picture.Bitmap;
 BmpMask.Canvas.Brush.Color:=clWhite;

 BmpMask.Width:=0;
 BmpMask.PixelFormat:=pf24bit;

 BmpMask.Width:=BmpSrc.Width;
 BmpMask.Height:=BmpSrc.Height;

// DD2:=(DD div 2)+1;
// DD2:=DD-1;
// DD2:=StrToIntDef(edFinalDelta.Text,32);
 for Y:=0 to BmpSrc.Height-1 do
 begin
  PX:=BmpSrc.ScanLine[Y];
  PX2:=BmpMask.ScanLine[Y];
  for X:=0 to BmpSrc.Width-1 do
  begin
   R:=PX[X*3+2]; G:=PX[X*3+1]; B:=PX[X*3];
   RP:=@PX2[X*3+2];    GP:=@PX2[X*3+1];    BP:=@PX2[X*3];

   for i:=0 to 9 do
   if BestRGB[i].Count>0 then
   if (abs(R-BestRGB[i].RA)<BestRGB[i].RAD) and (abs(G-BestRGB[i].GA)<BestRGB[i].GAD) and (abs(B-BestRGB[i].BA)<BestRGB[i].BAD) then
   begin
    Ctr1:=0; Ctr2:=0;
    for j:=0 to 9 do
    if i<>j then
    if ((BestRGB[i].RA+BestRGB[i].GA+BestRGB[i].BA)>(BestRGB[j].RA+BestRGB[j].GA+BestRGB[j].BA))
      xor sbTextIsLighter.Down then Inc(Ctr1) else Inc(Ctr2);
    if (Ctr1<Ctr2) then begin RP^:=128; GP^:=128; BP^:=128; end
    else begin RP^:=64; GP^:=64; BP^:=64; end;
    break;
   end;
  end;
 end;


 ImageMask4.Visible:=true;

end;

procedure FindBestRGBX16(MapX: TColorMap16; var Best1, Best2: TRGB24CtrX; DV, RShift, GShift, BShift: integer);
var R,G,B, RX, GX, BX, RY, GY, BY, SD: byte;
begin
 Best1.Count:=0;
 Best2.Count:=0;
 if sbHalfShift.Down then SD:=(DV div 2)
 else SD:=0;
 for R:=0 to 16 do
 for G:=0 to 16 do
 for B:=0 to 16 do
 begin
    if MapX[R,G,B]>Best1.Count then
    begin
     Best2:=Best1;
{     Best2.R:=Best1.R;
     Best2.G:=Best1.G;
     Best2.B:=Best1.B;
     Best2.Count:=Best1.Count;}
     Best1.R:=Min(255,R*DV+SD+RShift);
     Best1.G:=Min(255,G*DV+SD+GShift);
     Best1.B:=Min(255,B*DV+SD+BShift);
     Best1.RA:=MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].R
             div MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].Ctr;
     Best1.GA:=MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].G
             div MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].Ctr;
     Best1.BA:=MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].B
             div MapRGB16[Best1.R div DD,Best1.G div DD,Best1.B div DD].Ctr;
     Best1.Count:=MapX[R,G,B];
    end
    else
    if MapX[R,G,B]>Best2.Count then
    begin
     Best2.R:=Min(255,R*DV+SD);
     Best2.G:=Min(255,G*DV+SD);
     Best2.B:=Min(255,B*DV+SD);
     Best2.RA:=MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].R
             div MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].Ctr;
     Best2.GA:=MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].G
             div MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].Ctr;
     Best2.BA:=MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].B
             div MapRGB16[Best2.R div DD,Best2.G div DD,Best2.B div DD].Ctr;
     Best2.Count:=MapX[R,G,B];
    end;
 end;
end;


{procedure GetBestAverage(Divisor: integer; var Best: TRGB24CtrX);
var R,G,B: byte;
begin
 for R:=Best.R
end;}

{procedure FillReducedMaps(Divisor: integer);
var R,G,B, R1, G1, B1, MD: byte;
begin
 for R:=0 to 16 do
 for G:=0 to 16 do
 for B:=0 to 16 do
 begin
  Map16[R,G,B]:=0;
//  Map16_2[R,G,B]:=0;
 end;
 
 for R:=0 to 255 do
 for G:=0 to 255 do
 for B:=0 to 255 do
 if Map[R,G,B]>0 then
 begin
  Inc(Map16[R div Divisor,G div Divisor,B div Divisor],Map[R,G,B]);
//  Inc(Map16_2[Min(15,Round(R/Divisor)),Min(15,Round(G/Divisor)),Min(15,Round(B/Divisor))],Map[R,G,B]);
 end;

// MD:=255 div Divisor;
// for R:=0 to MD do
// for G:=0 to MD do
// for B:=0 to MD do
// for R1:=0 to Divisor-1 do if (R*Divisor+R1)<256 then
// for G1:=0 to Divisor-1 do if (G*Divisor+G1)<256 then
// for B1:=0 to Divisor-1 do if (B*Divisor+B1)<256 then
// if Map[R*Divisor+R1,G*Divisor+G1,B*Divisor+B1]>0 then
// begin
//  Inc(Map16[R,G,B],Map[R*Divisor+R1,G*Divisor+G1,B*Divisor+B1]);
////  Inc(Map16_2[Min(15,Round(R/Divisor)),Min(15,Round(G/Divisor)),Min(15,Round(B/Divisor))],Map[R,G,B]);
// end;
end;}


function GetColorCount(RX,GX,BX,RD,GD,BD: byte): integer;
var R,G,B, R1, G1, B1, MD: byte;
    X, Y: integer; PX: PByteArray;
begin

 Result:=0;
 for Y:=0 to IADiff.Height-1 do
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to IADiff.Width-1 do
  if IADiff.Pixels[Y*IADiff.Width+X]>0 then //masked => sharp enough
  begin
   R:=PX[X*3+2];
   G:=PX[X*3+1];
   B:=PX[X*3];
   if abs(R-RX)<=RD then
   if abs(G-GX)<=GD then
   if abs(B-BX)<=BD then
    Inc(Result);
  end;
 end;

end;

procedure FillReducedMapsXM(Divisor: integer);
var {R,G,B,} R1, G1, B1, MD: byte;
    X, Y: integer; PX: PByteArray;
begin
 for R1:=0 to 16 do
 for G1:=0 to 16 do
 for B1:=0 to 16 do
 begin
  Map16[R1,G1,B1]:=0;
  MapRGB16[R1,G1,B1].Ctr:=0;
  MapRGB16[R1,G1,B1].R:=0;
  MapRGB16[R1,G1,B1].G:=0;
  MapRGB16[R1,G1,B1].B:=0;
//  Map16_2[R,G,B]:=0;
 end;

 for Y:=0 to IADiff.Height-1 do
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to IADiff.Width-1 do
  if IADiff.Pixels[Y*IADiff.Width+X]>0 then //masked => sharp enough
  begin
   R1:=PX[X*3+2] div Divisor;
   G1:=PX[X*3+1] div Divisor;
   B1:=PX[X*3] div Divisor;
   Inc(Map16[R1,G1,B1]);
   Inc(MapRGB16[R1,G1,B1].R,PX[X*3+2]);
   Inc(MapRGB16[R1,G1,B1].G,PX[X*3+1]);
   Inc(MapRGB16[R1,G1,B1].B,PX[X*3]);
   Inc(MapRGB16[R1,G1,B1].Ctr);
  end;
 end;

end;

procedure FillReducedMapsXMF(Divisor, Diff: integer);
var {R,G,B,} R1, G1, B1, MD: byte;
    X, Y: integer; PX: PByteArray;
begin
 for R1:=0 to 16 do
 for G1:=0 to 16 do
 for B1:=0 to 16 do
 begin
  Map16[R1,G1,B1]:=0;
  MapRGB16[R1,G1,B1].Ctr:=0;
  MapRGB16[R1,G1,B1].R:=0;
  MapRGB16[R1,G1,B1].G:=0;
  MapRGB16[R1,G1,B1].B:=0;
//  Map16_2[R,G,B]:=0;
 end;

 for Y:=0 to IADiff.Height-1 do
 begin
  PX:=ImageOrig.Picture.Bitmap.ScanLine[Y];
  for X:=0 to IADiff.Width-1 do
  if IADiff.Pixels[Y*IADiff.Width+X]>0 then //masked => sharp enough
  begin
   R1:=PX[X*3+2] div Divisor;
   G1:=PX[X*3+1] div Divisor;
   B1:=PX[X*3] div Divisor;
   Inc(Map16[R1,G1,B1]);
   Inc(MapRGB16[R1,G1,B1].R,PX[X*3+2]);
   Inc(MapRGB16[R1,G1,B1].G,PX[X*3+1]);
   Inc(MapRGB16[R1,G1,B1].B,PX[X*3]);
   Inc(MapRGB16[R1,G1,B1].Ctr);
  end;
 end;

 for R1:=0 to 16 do
 for G1:=0 to 16 do
 for B1:=0 to 16 do
 if MapRGB16[R1,G1,B1].Ctr>0 then
 with MapRGB16[R1,G1,B1] do
 begin
   RA:=R div Ctr;
   GA:=G div Ctr;
   BA:=B div Ctr;
   CtrA:=GetColorCount(RA,GA,BA,Diff,Diff,Diff);
 end else
 begin
   MapRGB16[R1,G1,B1].RA:=0;
   MapRGB16[R1,G1,B1].BA:=0;
   MapRGB16[R1,G1,B1].GA:=0;
   MapRGB16[R1,G1,B1].CtrA:=0;
 end;

end;

procedure FindBestRGBX(Num, DV, DVM: integer);
var R,G,B, RX, GX, BX, RY, GY, BY, SD: byte;
    i, j, RD, GD, BD: integer;
begin
 BestRGB[Num].Count:=0;
 if sbHalfShift.Down then SD:=(DV div 2)
 else SD:=0;
 FillReducedMapsXMF(DV, DVM);
 if Num>0 then 

 for i:=0 to Num-1 do BestRGB[Num].Count:=0;

 for R:=0 to 16 do
 for G:=0 to 16 do
 for B:=0 to 16 do
 if MapRGB16[R,G,B].CtrA>0 then
 for i:=0 to Num-1 do
 begin
    if MapRGB16[R,G,B].CtrA>BestRGB[i].Count then
    begin
     for j:=Num-1 downto i+1 do BestRGB[j]:=BestRGB[j-1]; //shifting
     BestRGB[i].Count:=MapRGB16[R,G,B].CtrA;
     BestRGB[i].RA:=MapRGB16[R,G,B].RA;
     BestRGB[i].GA:=MapRGB16[R,G,B].GA;
     BestRGB[i].BA:=MapRGB16[R,G,B].BA;
     BestRGB[i].RAD:=DVM;
     BestRGB[i].GAD:=DVM;
     BestRGB[i].BAD:=DVM;
     break;
    end;
 end;

 for i:=0 to Num-1 do
 for j:=i+1 to Num-1 do
  if BestRGB[j].Count>BestRGB[i].Count then
  begin
   BestRGBX:=BestRGB[j];
   BestRGB[j]:=BestRGB[i];
   BestRGB[i]:=BestRGBX;
  end;

 //best found; reducing intersecting colors now
 for i:=0 to Num-1 do
 for j:=i+1 to Num-1 do
 if BestRGB[j].Count>0 then
 begin
  RD:=abs(BestRGB[j].RA-BestRGB[i].RA);
  GD:=abs(BestRGB[j].GA-BestRGB[i].GA);
  BD:=abs(BestRGB[j].BA-BestRGB[i].BA);
  if (RD<=DV) or (GD<=DV) or (BD<=DV) then
  begin
   BestRGB[j].RAD:=Min(RD,BestRGB[j].RAD);
   BestRGB[j].GAD:=Min(GD,BestRGB[j].GAD);
   BestRGB[j].BAD:=Min(BD,BestRGB[j].BAD);
   BestRGB[j].Count:=GetColorCount(BestRGB[j].RA,BestRGB[j].GA,BestRGB[j].BA,
                                  BestRGB[j].RAD,BestRGB[j].GAD,BestRGB[j].BAD);
  end;
 end;

 for i:=0 to Num-1 do
 for j:=i+1 to Num-1 do
  if BestRGB[j].Count>BestRGB[i].Count then
  begin
   BestRGBX:=BestRGB[j];
   BestRGB[j]:=BestRGB[i];
   BestRGB[i]:=BestRGBX;
  end;

end;

{procedure FillReducedMapsX(Divisor, RShift, GShift, BShift: integer);
var R,G,B, MR, MG, MB: byte;
begin
 for R:=0 to 16 do
 for G:=0 to 16 do
 for B:=0 to 16 do
 begin
  Map16[R,G,B]:=0;
//  Map16_2[R,G,B]:=0;
 end;

 for R:=0 to 255 do
 for G:=0 to 255 do
 for B:=0 to 255 do
 if Map[R,G,B]>0 then
 begin
  if (R-RShift)<0 then MR:=0 else MR:=((R-RShift) div Divisor)+1;
  if (G-GShift)<0 then MG:=0 else MG:=((G-GShift) div Divisor)+1;
  if (B-BShift)<0 then MB:=0 else MB:=((B-BShift) div Divisor)+1;
  Inc(Map16[MR, MG, MB], Map[R,G,B]);
//  Inc(Map16_2[Min(15,Round(R/Divisor)),Min(15,Round(G/Divisor)),Min(15,Round(B/Divisor))],Map[R,G,B]);
 end;
end;}

begin

{ BmpDiff:=TBitmap.Create;
 BmpDiff.PixelFormat:=pf8bit;
 BmpDiff.Canvas.Brush.Color:=clBlack;
 BmpDiff.Width:=ImageOrig.Picture.Bitmap.Width;
 BmpDiff.Height:=ImageOrig.Picture.Bitmap.Height;}
 IADiff.Width:=ImageOrig.Picture.Bitmap.Width;
 IADiff.Height:=ImageOrig.Picture.Bitmap.Height;
 SetLength(IADiff.Pixels,IADiff.Width*IADiff.Height);
 for X:=0 to IADiff.Width*IADiff.Height-1 do IADiff.Pixels[X]:=0;

// New(Map);
 New(Map16);
 New(Map16_2);
{ for R:=0 to 255 do
 for G:=0 to 255 do
 for B:=0 to 255 do
 Map[R,G,B]:=0;}

{ for R:=0 to 16 do
 for G:=0 to 16 do
 for B:=0 to 16 do
 begin
  Map16[R,G,B]:=0;
  Map16_2[R,G,B]:=0;
 end;}
 try
  MT:=StrToFloat(edTextFinalDelta.Text);
 except
  MT:=1;
 end;
 try
  MO:=StrToFloat(edOutlineFinalDelta.Text);
 except
  MO:=1;
 end;


// RD:=80; GD:=80; BD:=80;
 RD:=StrToIntDef(edAnalyzeDiffLimit.Text,80);
 GD:=RD; BD:=RD;

 Shift:=StrToIntDef(edAnalyzeShift.Text,4);//4;

 TotalCtr:=0;

 DD:=Max(16,StrToIntDef(edAnalyzeDivider.Text,16));//64; //16;

 with ImageOrig.Picture.Bitmap do
 for Y:=Shift to Height-1 do
 begin
  PX:=ScanLine[Y];
  PY:=ScanLine[Y-Shift];
  for X:=Shift to Width-1 do
//  if (X>=Shift) and (Y>=Shift) then
  begin
   R:=PX[X*3+2]; G:=PX[X*3+1]; B:=PX[X*3];
   RX:=PX[(X-Shift)*3+2]; GX:=PX[(X-Shift)*3+1]; BX:=PX[(X-Shift)*3];
   RY:=PY[X*3+2]; GY:=PY[X*3+1]; BY:=PY[X*3];

   RDX:=abs(R-RX);   GDX:=abs(G-GX);   BDX:=abs(B-BX);
   RDY:=abs(R-RY);   GDY:=abs(G-GY);   BDY:=abs(B-BY);
   if RDX<RD then RDX:=0;   if GDX<GD then GDX:=0;   if BDX<BD then BDX:=0;
   if RDY<RD then RDY:=0;   if GDY<GD then GDY:=0;   if BDY<BD then BDY:=0;

   if ((RDX+GDX+BDX)>0) then IADiff.Pixels[Y*IADiff.Width+X-Shift]:=255;
   if ((RDY+GDY+BDY)>0) then IADiff.Pixels[(Y-Shift)*IADiff.Width+X]:=255;
   if ((RDY+GDY+BDY)>0) or ((RDX+GDX+BDX)>0) then IADiff.Pixels[Y*IADiff.Width+X]:=255;

  end;
 end;

 with ImageOrig.Picture.Bitmap do
 for Y:=0 to Height-1 do
  for X:=0 to Width-1 do
  if IADiff.Pixels[IADiff.Width*Y+X]>0 then Inc(TotalCtr);
{  begin

   R:=PX[X*3+2]; G:=PX[X*3+1]; B:=PX[X*3];
   Inc(Map[R,G,B]);
  end;}

 DD:=Max(16,StrToIntDef(edAnalyzeDivider.Text,16));//64; //16;
 BestRGB1.Count:=0;
 BestRGB2.Count:=0;

 if sbModeX.Down then
 begin
  MX:=Max(16,StrToIntDef(edAnalyzeDivider.Text,16));
  FindBestRGBX(9,MX,MX);
//  BestRGB1:=BestRGB[0];
//  BestRGB2:=BestRGB[1];
  if sbAutoColorAnalyzis.Down then
  begin
   SetLength(ColorDoms,0);
   for i:=0 to 9 do
   if BestRGB[i].Count>0 then
   begin
   Ctr1:=0; Ctr2:=0;
   for j:=0 to 9 do
   if i<>j then
   if ((BestRGB[i].RA+BestRGB[i].GA+BestRGB[i].BA)>(BestRGB[j].RA+BestRGB[j].GA+BestRGB[j].BA))
      xor sbTextIsLighter.Down then Inc(Ctr1) else Inc(Ctr2);
   if (Ctr1<Ctr2) then
   begin
    BestRGB[i].RAD:=Round(BestRGB[i].RAD*MT);
    BestRGB[i].GAD:=Round(BestRGB[i].GAD*MT);
    BestRGB[i].BAD:=Round(BestRGB[i].BAD*MT);
    AddBoneTextDominator(BestRGB[i].RA,BestRGB[i].GA,BestRGB[i].BA,BestRGB[i].RAD,BestRGB[i].GAD,BestRGB[i].BAD)
   end
   else
   begin
    BestRGB[i].RAD:=Round(BestRGB[i].RAD*MO);
    BestRGB[i].GAD:=Round(BestRGB[i].GAD*MO);
    BestRGB[i].BAD:=Round(BestRGB[i].BAD*MO);
    AddSkinOutlineDominator(BestRGB[i].RA,BestRGB[i].GA,BestRGB[i].BA,BestRGB[i].RAD,BestRGB[i].GAD,BestRGB[i].BAD);
   end;
   end;
   btBuildMasksClick(Self);
  end;

  ImageArrayToBitmap24(IADiff,ImageMask5.Picture.Bitmap);
  ImageMask5.Visible:=true;
  CreateDiffMaskX;
  Dispose(Map16);
  Dispose(Map16_2);
  SetLength(IADiff.Pixels,0);
  exit;
 end
 else
 if sbFullColorSearch.Down then
 begin
  MX:=Max(16,StrToIntDef(edAnalyzeDivider.Text,16));
  BestDiv:=0;
  for DD:=MX downto 16 do
  begin
   SetProgress(100*(DD-16)/(MX-16+1));
{   stbMain.Panels[1].Text:=FloatToStr(100*(DD-16)/(MX-16+1));
   stbMain.Invalidate;}
//   FillReducedMaps(DD); //filling reduced color maps
   FillReducedMapsXM(DD); //filling reduced color maps
   FindBestRGBX16(Map16^,BestRGB1X,BestRGB2X,DD,0,0,0); //finding best matches in reduced color maps

   if not((BestRGB1X.RA+BestRGB1X.GA+BestRGB1X.BA)>(BestRGB2X.RA+BestRGB2X.GA+BestRGB2X.BA)) {xor sbTextIsLighter.Down} then
   begin
    BestRGBX:=BestRGB1X;
    BestRGB1X:=BestRGB2X;
    BestRGB2X:=BestRGBX;
   end;
    BestRGB1X.Count:=GetColorCount(BestRGB1X.RA,BestRGB1X.GA,BestRGB1X.BA,DD,DD,DD);
    BestRGB2X.Count:=GetColorCount(BestRGB2X.RA,BestRGB2X.GA,BestRGB2X.BA,DD,DD,DD);

   if (BestRGB1.Count+BestRGB2.Count)<(BestRGB1X.Count+BestRGB2X.Count) then
{   if (abs(BestRGB2X.R-BestRGB1X.R)>=DD)
   or (abs(BestRGB2X.G-BestRGB1X.G)>=DD)
   or (abs(BestRGB2X.B-BestRGB1X.B)>=DD) then}
   if (abs(BestRGB2X.RA-BestRGB1X.RA)>=DD)
   or (abs(BestRGB2X.GA-BestRGB1X.GA)>=DD)
   or (abs(BestRGB2X.BA-BestRGB1X.BA)>=DD) then
   begin
    if BestRGB1.Count<=BestRGB1X.Count then
    begin
     BestRGB1X.DD:=DD;
     BestRGB1X.RAD:=DD;
     BestRGB1X.GAD:=DD;
     BestRGB1X.BAD:=DD;
     BestRGB1:=BestRGB1X;
    end; 
    if BestRGB2.Count<=BestRGB2X.Count then
    begin
     BestRGB2X.DD:=DD;
     BestRGB2X.RAD:=DD;
     BestRGB2X.GAD:=DD;
     BestRGB2X.BAD:=DD;
     BestRGB2:=BestRGB2X;
    end; 
//    BestRGB1:=BestRGB1X;
//    BestRGB2:=BestRGB2X;

{    BestRGB1.RA:=MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].R
             div MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].Ctr;
    BestRGB1.GA:=MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].G
             div MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].Ctr;
    BestRGB1.BA:=MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].B
             div MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].Ctr;
    BestRGB2.RA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].R
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;
    BestRGB2.GA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].G
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;
    BestRGB2.BA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].B
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;}

    BestDiv:=DD;
   end;
  end;

 end
 else
 begin
{  MX:=8;
  for R:=0 to (DD div (2*MX)) do
  for G:=0 to (DD div (2*MX)) do
  begin
   stbMain.Panels[1].Text:=FloatToStr(100*(R*MX*256*256+G*MX*256+B*MX)/(256*256*256));
   stbMain.Invalidate;
   Application.ProcessMessages;
  for B:=0 to (DD div (2*MX)) do
  begin
   FillReducedMapsX(DD,R*MX,G*MX,B*MX); //filling reduced color maps
   FindBestRGBX16(Map16^,BestRGB1X,BestRGB2X,DD,R*MX,G*MX,B*MX); //finding best matches in reduced color maps
   if (BestRGB1.Count+BestRGB2.Count)<(BestRGB1X.Count+BestRGB2X.Count) then
   begin
    BestRGB1:=BestRGB1X;
    BestRGB2:=BestRGB2X;
    BestRGB1X.Count:=0;
    BestRGB2X.Count:=0;
   end;
  end;
  end;        }
//  FillReducedMaps(DD); //filling reduced color maps
  FillReducedMapsXM(DD); //filling reduced color maps
  FindBestRGBX16(Map16^,BestRGB1,BestRGB2,DD,0,0,0); //finding best matches in reduced color maps
  BestRGB1.DD:=DD;
  BestRGB2.DD:=DD;
     BestRGB1.RAD:=DD;
     BestRGB1.GAD:=DD;
     BestRGB1.BAD:=DD;
     BestRGB2.RAD:=DD;
     BestRGB2.GAD:=DD;
     BestRGB2.BAD:=DD;
  BestDiv:=DD;
 end;

{ with MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD] do
 if Ctr>0 then
 begin
    BestRGB1.RA:=R div Ctr;
    BestRGB1.GA:=G div Ctr;
    BestRGB1.BA:=B div Ctr;
 end else
 begin
    BestRGB1.RA:=BestRGB1.R;
    BestRGB1.GA:=BestRGB1.G;
    BestRGB1.BA:=BestRGB1.B;
 end;
 with MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD] do
 if Ctr>0 then
 begin
    BestRGB2.RA:=R div Ctr;
    BestRGB2.GA:=G div Ctr;
    BestRGB2.BA:=B div Ctr;
 end else
 begin
    BestRGB2.RA:=BestRGB1.R;
    BestRGB2.GA:=BestRGB1.G;
    BestRGB2.BA:=BestRGB1.B;
 end;}
{    BestRGB1.GA:=MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].G
             div MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].Ctr;
    BestRGB1.BA:=MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].B
             div MapRGB16[BestRGB1.R div DD,BestRGB1.G div DD,BestRGB1.B div DD].Ctr;
    BestRGB2.RA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].R
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;
    BestRGB2.GA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].G
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;
    BestRGB2.BA:=MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].B
             div MapRGB16[BestRGB2.R div DD,BestRGB2.G div DD,BestRGB2.B div DD].Ctr;}


// stbMain.Panels[1].Text:='0';
 SetProgress(0);

 RX:=BestRGB1.R; GX:=BestRGB1.G; BX:=BestRGB1.B; Ctr1:=BestRGB1.Count;
 RY:=BestRGB2.R; GY:=BestRGB2.G; BY:=BestRGB2.B; Ctr2:=BestRGB2.Count;

 RX:=BestRGB1.RA; GX:=BestRGB1.GA; BX:=BestRGB1.BA;
 RY:=BestRGB2.RA; GY:=BestRGB2.GA; BY:=BestRGB2.BA;


 try
  DD:=Round(BestDiv*StrToFloat(edTextFinalDelta.Text));
 except
  DD:=BestDiv;
 end;
//  DD1:=Round(BestRGB1.DD*StrToFloat(edTextFinalDelta.Text));
//  DD2:=Round(BestRGB1.DD*StrToFloat(edOutlineFinalDelta.Text));



{ s:='"Top" Colors ( '+IntToStr(BestDiv)+' ):';
 s:=s+#13#10+Format('R: %d, G: %d, B: %d, Count: %d',
                    [BestRGB1.R, BestRGB1.G, BestRGB1.B, BestRGB1.Count]);
 s:=s+#13#10+Format('RA: %d, GA: %d, BA: %d',
                    [BestRGB1.RA, BestRGB1.GA, BestRGB1.BA]);
 s:=s+#13#10+Format('R: %d, G: %d, B: %d, Count: %d',
                    [BestRGB2.R, BestRGB2.G, BestRGB2.B, BestRGB2.Count]);
 s:=s+#13#10+Format('RA: %d, GA: %d, BA: %d',
                    [BestRGB2.RA, BestRGB2.GA, BestRGB2.BA]);
 s:=s+#13#10+'Delta: '+ IntToStr(DD)+'; Total: '+IntToStr(TotalCtr);
 ShowMessage(s);}

 if sbAutoColorAnalyzis.Down then
 begin
   if ((RX+GX+BX)>(RY+GY+BY)) xor sbTextIsLighter.Down then
    begin
     BestRGBX:=BestRGB1;
     BestRGB1:=BestRGB2;
     BestRGB2:=BestRGBX;
    end;
     BestRGB1.RAD:=Min(255,Round(BestRGB1.RAD*MT));
     BestRGB1.GAD:=Min(255,Round(BestRGB1.GAD*MT));
     BestRGB1.BAD:=Min(255,Round(BestRGB1.BAD*MT));
     DD1:=BestRGB1.RAD;

     BestRGB2.RAD:=Min(255,Round(BestRGB2.RAD*MO));
     BestRGB2.GAD:=Min(255,Round(BestRGB2.GAD*MO));
     BestRGB2.BAD:=Min(255,Round(BestRGB2.BAD*MO));
     DD2:=BestRGB2.RAD;

     SetBoneTextDominator(BestRGB1.RA,BestRGB1.GA,BestRGB1.BA,BestRGB1.RAD,BestRGB1.GAD,BestRGB1.BAD);
     SetSkinOutlineDominator(BestRGB2.RA,BestRGB2.GA,BestRGB2.BA,BestRGB2.RAD,BestRGB2.GAD,BestRGB2.BAD);

{   if ((RX+GX+BX)>(RY+GY+BY)) xor sbTextIsLighter.Down then
    begin
//     SetSkinOutlineDominator(RX,GX,BX,DD1,DD1,DD1);
//     SetBoneTextDominator(RY,GY,BY,DD2,DD2,DD2);
//     SetSkinOutlineDominator(BestRGB1.RA,BestRGB1.GA,BestRGB1.BA,BestRGB1.RAD,BestRGB1.GAD,BestRGB1.BAD);
//     SetBoneTextDominator(BestRGB2.RA,BestRGB2.GA,BestRGB2.BA,BestRGB2.RAD,BestRGB2.GAD,BestRGB2.BAD);
     SetSkinOutlineDominator(BestRGB1.RA,BestRGB1.GA,BestRGB1.BA,
     Round(BestRGB1.RAD*MO),Round(BestRGB1.GAD*MO),Round(BestRGB1.BAD*MO));
     SetBoneTextDominator(BestRGB2.RA,BestRGB2.GA,BestRGB2.BA,
     Round(BestRGB2.RAD*MT),Round(BestRGB2.GAD*MT),Round(BestRGB2.BAD*MT));
    end
    else
    begin
//     SetSkinOutlineDominator(RY,GY,BY,DD2,DD2,DD2);
//     SetBoneTextDominator(RX,GX,BX,DD1,DD1,DD1);
     SetBoneTextDominator(BestRGB1.RA,BestRGB1.GA,BestRGB1.BA,
     Round(BestRGB1.RAD*MT),Round(BestRGB1.GAD*MT),Round(BestRGB1.BAD*MT));
     SetSkinOutlineDominator(BestRGB2.RA,BestRGB2.GA,BestRGB2.BA,
     Round(BestRGB2.RAD*MO),Round(BestRGB2.GAD*MO),Round(BestRGB2.BAD*MO));
    end;}

  btBuildMasksClick(Self);
 end;

 CreateDiffMask;
 ImageArrayToBitmap24(IADiff,ImageMask5.Picture.Bitmap);
 ImageMask5.Visible:=true;


 lbAnalyzeColor1.Color:=BX*256*256+GX*256+RX;
 lbAnalyzeColor1.Tag:=DD;
 lbAnalyzeColor1.Caption:=Format('R: %d'#13#10'G: %d'#13#10'B: %d'#13#10'Count: %d'#13#10'Div: %d'#13#10'Delta: %d',
                                  [RX, GX, BX, Ctr1, BestDiv, DD1]);

 if RX>127 then RX:=0 else RX:=255;
 if GX>127 then GX:=0 else GX:=255;
 if BX>127 then BX:=0 else BX:=255;
 lbAnalyzeColor1.Font.Color:=BX*256*256+GX*256+RX;

 lbAnalyzeColor2.Color:=BY*256*256+GY*256+RY;
 lbAnalyzeColor2.Tag:=DD;
//                    [BestRGB2.R, BestRGB2.G, BestRGB2.B, BestRGB2.Count]);
 lbAnalyzeColor2.Caption:=Format('R: %d'#13#10'G: %d'#13#10'B: %d'#13#10'Count: %d'#13#10'Div: %d'#13#10'Delta: %d',
                                  [RY, GY, BY, Ctr2, BestDiv, DD2]);
 if RY>127 then RY:=0 else RY:=255;
 if GY>127 then GY:=0 else GY:=255;
 if BY>127 then BY:=0 else BY:=255;
 lbAnalyzeColor2.Font.Color:=BY*256*256+GY*256+RY;



// Dispose(Map);
 Dispose(Map16);
 Dispose(Map16_2);
 SetLength(IADiff.Pixels,0);
end;

procedure TGlyphForm.stbMainDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var Percent: extended;  
begin
 try
  Percent:=StrToFloat(Panel.Text);
 except
  Percent:=0.0;
 end;
// if Percent=0 then Percent:=0.0001;
 StatusBar.Canvas.Brush.Color:=clBlue;

// StatusBar.Canvas.Rectangle(Rect.Left+Trunc((Rect.Right-Rect.Left)*(100-Percent)/100),Rect.Top,
 StatusBar.Canvas.Rectangle(Rect.Left,Rect.Top,
                            Rect.Right-Trunc((Rect.Right-Rect.Left)*(100-Percent)/100),
                            Rect.Bottom);
{ StatusBar.Canvas.Brush.Color:=clWhite;
 StatusBar.Canvas.Rectangle(Rect.Right,Rect.Top,
                            Rect.Right-Trunc((Rect.Right-Rect.Left)*(Percent)/100),
                            Rect.Bottom);}
end;

procedure TGlyphForm.lbAnalyzeColor2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var CL: TColor;
    R, G, B, RD, GD, BD: byte;
begin
   CL:=(Sender as TLabel).Color;
   R:= CL and $FF;
   G:= (CL shr 8) and $FF;
   B:= (CL shr 16) and $FF;
   RD:=(Sender as TLabel).Tag;//StrToIntDef(edFinalDelta.Text,64);
   GD:=RD; BD:=RD;
 if Button=mbRight then SetSkinOutlineDominator(R,G,B,RD,GD,BD);
 if Button=mbLeft then SetBoneTextDominator(R,G,B,RD,GD,BD);
end;

procedure TGlyphForm.SetSkinOutlineDominator;
var LastSelected, i: integer; Found: boolean;
begin
//  edRT.Text:=IntToStr(R);  edGT.Text:=IntToStr(G);  edBT.Text:=IntToStr(B);
  LastSelected:=ColorDomSelected;
  if not(ColorDoms[ColorDomSelected].ColorType=ctSkinOutline) then
  begin
   Found:=false;
   for i:=0 to Length(ColorDoms)-1 do
    if ColorDoms[i].ColorType=ctSkinOutline then
    begin
     Found:=true; break;
    end;
   if Found then ColorDomSelected:=i else
   begin
    SetLength(ColorDoms,Length(ColorDoms)+1);
    ColorDomSelected:=Length(ColorDoms)-1;
   end;
  end;
  ColorDoms[ColorDomSelected].R:=R;
  ColorDoms[ColorDomSelected].G:=G;
  ColorDoms[ColorDomSelected].B:=B;
  ColorDoms[ColorDomSelected].RD:={ColorDoms[LastSelected].}RD;
  ColorDoms[ColorDomSelected].GD:={ColorDoms[LastSelected].}GD;
  ColorDoms[ColorDomSelected].BD:={ColorDoms[LastSelected].}BD;
  ColorDoms[ColorDomSelected].ColorType:=ctSkinOutline;
  UpdateColorDominator;
end;

procedure TGlyphForm.AddSkinOutlineDominator;
var LastSelected, i: integer; Found: boolean;
begin
  SetLength(ColorDoms,Length(ColorDoms)+1);
  ColorDomSelected:=Length(ColorDoms)-1;
  ColorDoms[ColorDomSelected].R:=R;
  ColorDoms[ColorDomSelected].G:=G;
  ColorDoms[ColorDomSelected].B:=B;
  ColorDoms[ColorDomSelected].RD:={ColorDoms[LastSelected].}RD;
  ColorDoms[ColorDomSelected].GD:={ColorDoms[LastSelected].}GD;
  ColorDoms[ColorDomSelected].BD:={ColorDoms[LastSelected].}BD;
  ColorDoms[ColorDomSelected].ColorType:=ctSkinOutline;
  UpdateColorDominator;
end;

procedure TGlyphForm.AddBoneTextDominator;
var LastSelected, i: integer; Found: boolean;
begin
  SetLength(ColorDoms,Length(ColorDoms)+1);
  ColorDomSelected:=Length(ColorDoms)-1;
  ColorDoms[ColorDomSelected].R:=R;
  ColorDoms[ColorDomSelected].G:=G;
  ColorDoms[ColorDomSelected].B:=B;
  ColorDoms[ColorDomSelected].RD:={ColorDoms[LastSelected].}RD;
  ColorDoms[ColorDomSelected].GD:={ColorDoms[LastSelected].}GD;
  ColorDoms[ColorDomSelected].BD:={ColorDoms[LastSelected].}BD;
  ColorDoms[ColorDomSelected].ColorType:=ctBoneText;
  UpdateColorDominator;
end;

procedure TGlyphForm.SetBoneTextDominator;
var LastSelected, i: integer; Found: boolean;
begin
//  edRT.Text:=IntToStr(R);  edGT.Text:=IntToStr(G);  edBT.Text:=IntToStr(B);
  LastSelected:=ColorDomSelected;
  if not(ColorDoms[ColorDomSelected].ColorType=ctBoneText) then
  begin
   Found:=false;
   for i:=0 to Length(ColorDoms)-1 do
    if ColorDoms[i].ColorType=ctBoneText then
    begin
     Found:=true; break;
    end;
   if Found then ColorDomSelected:=i else
   begin
    SetLength(ColorDoms,Length(ColorDoms)+1);
    ColorDomSelected:=Length(ColorDoms)-1;
   end;
  end;
  ColorDoms[ColorDomSelected].R:=R;
  ColorDoms[ColorDomSelected].G:=G;
  ColorDoms[ColorDomSelected].B:=B;
  ColorDoms[ColorDomSelected].RD:={ColorDoms[LastSelected].}RD;
  ColorDoms[ColorDomSelected].GD:={ColorDoms[LastSelected].}GD;
  ColorDoms[ColorDomSelected].BD:={ColorDoms[LastSelected].}BD;
  ColorDoms[ColorDomSelected].ColorType:=ctBoneText;
  UpdateColorDominator;
end;

procedure TGlyphForm.btAutoPostClick(Sender: TObject);
var i: integer; HasFile: boolean; s: string;
    Bmp, Bmp2: TBitmap; 
begin
 //
 if (CurrentOCRLine<0) then exit;
 if (PreOCRList.Count<=CurrentOCRLine) then exit;

 Bmp:=TBitmap.Create;
 Bmp2:=TBitmap.Create;

 try
 i:=Max(0,CurrentOCRLine);
 while (i<PreOCRList.Count) do
 begin
  s:=PreOCRList[i];
  HasFile:=false;
  if FileExists(s) then begin OpenBitmap(s); HasFile:=true end;
  if not(HasFile) then s:=OpenList.InitialDir+s;
  if not(HasFile) then if  (FileExists(s)) then begin OpenBitmap(s); HasFile:=true end;
  if UpdateTimer.Interval>0 then while UpdateTimer.Enabled do Application.ProcessMessages
  else btBuildMasksXClick(Sender);

  if HasFile then
  begin
   s:=StringReplace(s,'.orig.','.post.',[rfIgnoreCase]);
   if Pos('.post.',s)=0 then s:=ChangeFileExt(s,'')+'.post.bmp';
   MaskToBitmapX(Mask1Bitmap,Bmp);
   Bmp2.Width:=Bmp.Width div 4;
   Bmp2.Height:=Bmp.Height div 4;
   StretchBlt(Bmp2.Canvas.Handle,0,0,Bmp2.Width,Bmp2.Height,
              Bmp.Canvas.Handle,0,0,Bmp.Width,Bmp.Height,SRCCOPY);
   Bmp2.SaveToFile(s);
  end;  
  inc(i);

 end;
 finally
// CurrentOCRLine:=i;
  Bmp.Free;
  Bmp2.Free;
 end;

end;

procedure TGlyphForm.edOCRItemChange(Sender: TObject);
var R: integer;
begin
 R:=StrToIntDef(edOCRItem.Text,0);
 if CurrentOCRLine<>R then CurrentOCRLine:=R;
end;

function TGlyphForm.GetRect24b(Bmp: TBitmap):TRect;
var IStart, IEnd: integer;
    Y, X, X1, X2, Y1, Y2: integer;
    PX: PByteArray;
    StartX, StartY: boolean;
begin
  X1:=Bmp.Width;
  X2:=0;
  Y2:=0;
  Y1:=Bmp.Height;
  StartY:=false;
  for Y:=0 to Bmp.Height-1 do
   begin
   PX:=Bmp.ScanLine[Y];
   StartX:=false;
   for X:=0 to Bmp.Width-1 do
    begin
     if PX[X*3]>100 then
     begin
      if not(StartX) then
      begin
       StartX:=true;
       if X1>X then X1:=X;
       if Y1>Y then Y1:=Y;
      end;
     end
     else
     begin
      if StartX then
      begin
       StartX:=false;
       if X2<X then X2:=X;
       if Y2<Y then Y2:=Y;
      end;
     end;

    end;
      if StartX then
      begin
       StartX:=false;
       if X2<X then X2:=X;
       if Y2<Y then Y2:=Y;
      end;

   end;


 Result.Left:=X1;
 Result.Right:=X2;
 Result.Top:=Y1;
 Result.Bottom:=Y2;

 Result.Left:=Max(0,Result.Left);
 Result.Top:=Max(0,Result.Top);
 Result.Right:=Min(Bmp.Width-1,Result.Right);
 Result.Bottom:=Min(Bmp.Height-1,Result.Bottom);
end;

function TGlyphForm.GetRect24b(Bmp, BmpX: TBitmap):TRect;
var IStart, IEnd: integer;
    Y, X, X1, X2, Y1, Y2: integer;
    PX, PXX: PByteArray;
    StartX, StartY: boolean;
begin
  X1:=Bmp.Width;
  X2:=0;
  Y2:=0;
  Y1:=Bmp.Height;
  BmpX.Width:=X1;
  BmpX.Height:=Y1;
  BmpX.PixelFormat:=pf8bit;

  StartY:=false;
  for Y:=0 to Bmp.Height-1 do
   begin
   PX:=Bmp.ScanLine[Y];
   PXX:=BmpX.ScanLine[Y];
   StartX:=false;
   for X:=0 to Bmp.Width-1 do
    begin
     if PX[X*3]>100 then PXX[X]:=CLR_MASK_MAIN else PXX[X]:=CLR_MASK_NONE; 
     if PX[X*3]>100 then
     begin
      if not(StartX) then
      begin
       StartX:=true;
       if X1>X then X1:=X;
       if Y1>Y then Y1:=Y;
      end;
     end
     else
     begin
      if StartX then
      begin
       StartX:=false;
       if X2<X then X2:=X;
       if Y2<Y then Y2:=Y;
      end;
     end;

    end;
      if StartX then
      begin
       StartX:=false;
       if X2<X then X2:=X;
       if Y2<Y then Y2:=Y;
      end;

   end;


 Result.Left:=X1;
 Result.Right:=X2;
 Result.Top:=Y1;
 Result.Bottom:=Y2;

 Result.Left:=Max(0,Result.Left);
 Result.Top:=Max(0,Result.Top);
 Result.Right:=Min(Bmp.Width-1,Result.Right);
 Result.Bottom:=Min(Bmp.Height-1,Result.Bottom);
end;

function TGlyphForm.TryAutoOCR;//(BmpX:TBitmap):string;
var i, j, X, Y, Ctr, Ctr1, Ctr2, ResM: integer; PX, PY: PByteArray;
    BM: Extended;
    FontTested, FC: string;
    str: string;
    Bmp, Bmp2: TBitmap;
    Res: TGlyphCompareResult;
    Rct: TRect;
    Clr: TColor;
    c: char;
    BestChar: char;
    BestCharMatch, HM: extended;
    BestCharHeight: integer;
    BestCharFont: string;
    CmpStr: string;
    AutoMatch, ManualMatch: extended;
    HDiffLimit, WDiffLimit: integer;
    PrevW, PrevH, HT: integer;

procedure TryString;
var i, X, Y: integer;
begin
 for i:=1 to Length(CmpStr) do
 begin
  c:=CmpStr[i];
  Str:=c;//BaseSymbols[i].Text;
  if CharSizeMaps[j-1].Data[c].HasData then HM:=1000/CharSizeMaps[j-1].Data[c].HX
  else HM:=1;
  SetTitle('Trying "'+c+'"');
  SetProgress(i*100/Length(CmpStr));
  inc(Ctr);
  begin
//   if lbTryFonts.Items.Count>1 then Bmp.Canvas.Font.Height:=Max(HT,BmpX.Height) else
   Bmp.Canvas.Font.Height:=Trunc(BmpX.Height*HM)-10;
   Rct:=Rect(0,0,0,0);
   PrevW:=0; PrevH:=0;
   while ((Rct.Bottom-Rct.Top)<(BmpX.Height-6))
   and (((Rct.Right-Rct.Left) div 2)<(BmpX.Width-6)) do

   begin
    Bmp.Canvas.Font.Height:=Bmp.Canvas.Font.Height+1;
    Bmp.Width:=0;
    if (Bmp.Canvas.TextWidth(Str)<>PrevW) or (Bmp.Canvas.TextHeight(Str)<>PrevH) then
    begin
     PrevW:=Bmp.Canvas.TextWidth(Str);
     PrevH:=Bmp.Canvas.TextHeight(Str);
     Bmp.Width:=PrevW;//BaseSymbols[i].IA.Width;
     Bmp.Height:=PrevH;//BaseSymbols[i].IA.Height;
     Bmp.Canvas.TextOut(1,1,Str);
     Rct:=GetRect24b(Bmp);
     SetTitle('Trying "'+c+'" - height '+IntToStr(Bmp.Canvas.Font.Height));
     Application.ProcessMessages;
    end;
   end;
  Bmp2.Width:=0;
  Bmp2.Width:=Max(BmpX.Width-2,Rct.Right-Rct.Left);
//  Bmp2.Height:=BaseSymbols[i].IA.Height-2;
  Bmp2.Height:=1;//Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top);
  PByteArray(Bmp2.ScanLine[0])[0]:=CLR_MASK_NONE;
  Clr:=Bmp2.Canvas.Pixels[0,0];
  Bmp2.Canvas.Brush.Color:=Clr;
  Bmp2.Width:=0;
//  Bmp2.Width:=Max(BaseSymbols[i].IA.Width-2,Rct.Right-Rct.Left)+4;
//  Bmp2.Height:=Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top)+4;
  Bmp2.Width:=Rct.Right-Rct.Left+4;
  Bmp2.Height:=Rct.Bottom-Rct.Top+4;
//  Bmp2.Height:=BaseSymbols[i].IA.Height-2;

//  for Y:=0 to Bmp.Height-1 do
  if ((Bmp.Canvas.Font.Height/HM)>=HT)
  or (IsDelimiter(''',.-`"',c,0)){GetStringTypeEx(LOCALE_SYSTEM_DEFAULT,CT_TYPE1,)} then
  if  (Abs(Bmp2.Width-BmpX.Width)<WDiffLimit)
  and (Abs(Bmp2.Height-BmpX.Height)<HDiffLimit) then
  BEGIN
  for Y:=Rct.Top to Rct.Bottom do
   begin
   PX:=Bmp.ScanLine[Y];
   PY:=Bmp2.ScanLine[Y+2-Rct.Top];
//   for X:=0 to Bmp.Width-1 do
   for X:=Rct.Left to Rct.Right do
    begin
     if PX[X*3]>100 then PY[X+2-Rct.Left]:=CLR_MASK_MAIN
     else PY[X+2-Rct.Left]:=CLR_MASK_NONE;
    end;
   end;
   Res:=CompareGlyphBitmaps(BmpX,Bmp2);
   BM:=BM+Res.BestMatch;
//   SetProgress((Ord('z')-Ord(c))*100/(Ord('z')-Ord('A')));
   if Res.BestMatch>=AutoMatch then
   begin
    Result:=str;
    stbMain.Hint:='Last AutoMatch - "'+str+'" with height of '+IntToStr(Bmp.Canvas.Font.Height);
    break;
   end;
   if (Res.BestMatch>BestCharMatch) then
   begin
    BestChar:=c;
    BestCharMatch:=Res.BestMatch;
    BestCharHeight:=Bmp.Canvas.Font.Height;
    BestCharFont:=FontTested;
   end;
  END;
  end;
 end;
end;

procedure TryStringItalic;
var i, X, Y: integer;
begin
 for i:=1 to Length(CmpStr) do
 begin
  c:=CmpStr[i];
  Str:=c;//BaseSymbols[i].Text;
  if CharSizeMaps[j-1].IData[c].HasData then HM:=1000/CharSizeMaps[j-1].IData[c].HX
  else HM:=1;
  SetTitle('Trying italic "'+c+'"');
  SetProgress(i*100/Length(CmpStr));
  inc(Ctr);
  begin
//   if lbTryFonts.Items.Count>1 then Bmp.Canvas.Font.Height:=Max(HT,BmpX.Height) else
   Bmp.Canvas.Font.Height:=Trunc(BmpX.Height*HM)-10;
   Rct:=Rect(0,0,0,0);
   PrevW:=0; PrevH:=0;
   while ((Rct.Bottom-Rct.Top)<(BmpX.Height-6))
   and (((Rct.Right-Rct.Left) div 2)<(BmpX.Width-6)) do

   begin
    Bmp.Canvas.Font.Height:=Bmp.Canvas.Font.Height+1;
    Bmp.Width:=0;
    if (Bmp.Canvas.TextWidth(Str)<>PrevW) or (Bmp.Canvas.TextHeight(Str)<>PrevH) then
    begin
     PrevW:=Bmp.Canvas.TextWidth(Str);
     PrevH:=Bmp.Canvas.TextHeight(Str);
     Bmp.Width:=PrevW;//BaseSymbols[i].IA.Width;
     Bmp.Height:=PrevH;//BaseSymbols[i].IA.Height;
     Bmp.Canvas.TextOut(1,1,Str);
     Rct:=GetRect24b(Bmp);
     SetTitle('Trying "'+c+'" - height '+IntToStr(Bmp.Canvas.Font.Height));
     Application.ProcessMessages;
    end;
   end;
  Bmp2.Width:=0;
  Bmp2.Width:=Max(BmpX.Width-2,Rct.Right-Rct.Left);
  Bmp2.Height:=1;//Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top);
  PByteArray(Bmp2.ScanLine[0])[0]:=CLR_MASK_NONE;
  Clr:=Bmp2.Canvas.Pixels[0,0];
  Bmp2.Canvas.Brush.Color:=Clr;
  Bmp2.Width:=0;
  Bmp2.Width:=Rct.Right-Rct.Left+4;
  Bmp2.Height:=Rct.Bottom-Rct.Top+4;

  if ((Bmp.Canvas.Font.Height/HM)>=HT)
  or (IsDelimiter(''',.-`"',c,0)){GetStringTypeEx(LOCALE_SYSTEM_DEFAULT,CT_TYPE1,)} then
  if  (Abs(Bmp2.Width-BmpX.Width)<WDiffLimit)
  and (Abs(Bmp2.Height-BmpX.Height)<HDiffLimit) then
  BEGIN
  for Y:=Rct.Top to Rct.Bottom do
   begin
   PX:=Bmp.ScanLine[Y];
   PY:=Bmp2.ScanLine[Y+2-Rct.Top];
//   for X:=0 to Bmp.Width-1 do
   for X:=Rct.Left to Rct.Right do
    begin
     if PX[X*3]>100 then PY[X+2-Rct.Left]:=CLR_MASK_MAIN
     else PY[X+2-Rct.Left]:=CLR_MASK_NONE;
    end;
   end;
   Res:=CompareGlyphBitmaps(BmpX,Bmp2);
   BM:=BM+Res.BestMatch;
//   SetProgress((Ord('z')-Ord(c))*100/(Ord('z')-Ord('A')));
   if Res.BestMatch>=AutoMatch then
   begin
    Result:=str;
    stbMain.Hint:='Last AutoMatch - "'+str+'" with height of '+IntToStr(Bmp.Canvas.Font.Height);
    break;
   end;
   if (Res.BestMatch>BestCharMatch) then
   begin
    BestChar:=c;
    BestCharMatch:=Res.BestMatch;
    BestCharHeight:=Bmp.Canvas.Font.Height;
    BestCharFont:=FontTested;
   end;
  END;
  end;
 end;
end;

begin
 Ctr1:=0; Ctr2:=0; Ctr:=0; BM:=0;

 Result:=REGION_UNKNOWN;
 AutoMatch:=StrToFloat(edAutoMatchThresh.Text);
 ManualMatch:=StrToFloat(edManualMatchThresh.Text);
 BestCharMatch:=0;

 Bmp:=TBitmap.Create;
 Bmp.PixelFormat:=pf24bit;
 Bmp2:=TBitmap.Create;
 Bmp2.PixelFormat:=pf8bit; //mask

 HDiffLimit:=6;
 WDiffLimit:=6;

 CmpStr:=edAutoRecognitionLine.Text;
 try
 HT:=StrToIntDef(edMinTextHeight.Text,40);
 Bmp.Canvas.Font.Color:=clWhite;
 Bmp.Canvas.Font.Style:=[];
 Bmp.Canvas.Brush.Color:=clBlack;

// for i:=0 to Length(BaseSymbols)-1 do
// for c:='A' to 'z' do
 j:=0;
while (j<lbTryFonts.Items.Count) do
begin
 FontTested:=Trim(lbTryFonts.Items[j]);//edAutoFontName.Text;//'Arial';
 Bmp.Canvas.Font.Name:=FontTested;// CreateCharSizeMap(FontTested);
 Inc(j);
 TryString;
end;


if (Result=REGION_UNKNOWN) then
if cbTryItalic.Checked then
begin
 j:=0; Bmp.Canvas.Font.Style:=[fsItalic];
while (j<lbTryFonts.Items.Count) do
 begin
  FontTested:=Trim(lbTryFonts.Items[j]);//edAutoFontName.Text;//'Arial';
  Bmp.Canvas.Font.Name:=FontTested;// CreateCharSizeMap(FontTested);
  Inc(j);
  TryStringItalic;
 end;
end;

if not sbDisableNewSymbols.Down then
if not(NoNew) then
if (Result=REGION_UNKNOWN) then
 if BestCharMatch>=ManualMatch then
 begin
    Bmp.Canvas.Font.Height:=BestCharHeight;
    Bmp.Canvas.Font.Name:=BestCharFont;
    Bmp.Width:=0;
    Str:=BestChar;
    if (Bmp.Canvas.TextWidth(Str)<>PrevW) or (Bmp.Canvas.TextHeight(Str)<>PrevH) then
    begin
     PrevW:=Bmp.Canvas.TextWidth(Str);
     PrevH:=Bmp.Canvas.TextHeight(Str);
     Bmp.Width:=PrevW;//BaseSymbols[i].IA.Width;
     Bmp.Height:=PrevH;//BaseSymbols[i].IA.Height;
     Bmp.Canvas.TextOut(1,1,Str);
     Rct:=GetRect24b(Bmp);
    end;
    Bmp2.Width:=0;
    Bmp2.Width:=Max(BmpX.Width-2,Rct.Right-Rct.Left);
    Bmp2.Height:=1;//Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top);
    PByteArray(Bmp2.ScanLine[0])[0]:=CLR_MASK_NONE;
    Clr:=Bmp2.Canvas.Pixels[0,0];
    Bmp2.Canvas.Brush.Color:=Clr;
    Bmp2.Width:=0;
    Bmp2.Width:=Rct.Right-Rct.Left+4;
    Bmp2.Height:=Rct.Bottom-Rct.Top+4;
  if  (Abs(Bmp2.Width-BmpX.Width)<WDiffLimit)
  and (Abs(Bmp2.Height-BmpX.Height)<HDiffLimit) then
  for Y:=Rct.Top to Rct.Bottom do
   begin
   PX:=Bmp.ScanLine[Y];
   PY:=Bmp2.ScanLine[Y+2-Rct.Top];
   for X:=Rct.Left to Rct.Right do
     if PX[X*3]>100 then PY[X+2-Rct.Left]:=CLR_MASK_MAIN
     else PY[X+2-Rct.Left]:=CLR_MASK_NONE;
   end;
   Res:=CompareGlyphBitmaps(BmpX,Bmp2);
   CompareResultToAddSymbolForm;
   if AddSymbolForm.ShowModal=mrOk then
   begin
     Result:=str;
     stbMain.Hint:='Last ManualMatch - "'+str+'" with height of '+IntToStr(Bmp.Canvas.Font.Height);
   end;
  end; 

 finally
  Bmp.Free;
  Bmp2.Free;
 end;
// ShowMessage('Similarity = '+FloatToStr(Ctr1*100/Ctr)+' %');
// if Ctr=0 then Ctr:=1;
// ShowMessage(Format('Average Similarity = %5.3f %%',[BM/Ctr]));
 SetProgress(0);
 SetTitle('');
end;

procedure TGlyphForm.btCheckFontMatchClick(Sender: TObject);
var i, j, X, Y, Ctr, Ctr1, Ctr2, ResM: integer; PX, PY: PByteArray;
    BM, BMM: Extended;
    BestFontName: string;
//    BestFontName2: string;
    FontTested: string;
    str: string;
    Bmp, Bmp2: TBitmap;
    Res: TGlyphCompareResult;
    Rct: TRect;
    Clr: TColor;
    HDiffLimit, WDiffLimit: integer;

begin
 OptimizeBaseSymbols;
 Ctr1:=0; Ctr2:=0; Ctr:=0; BM:=0; BMM:=0;
 FontTested:=edAutoFontNameX.Text;//'Arial';
 Bmp:=TBitmap.Create;
 Bmp.PixelFormat:=pf24bit;
 Bmp2:=TBitmap.Create;
 Bmp2.PixelFormat:=pf8bit; //mask
 try
 Bmp.Canvas.Font.Name:=FontTested;
 Bmp.Canvas.Font.Color:=clWhite;
 Bmp.Canvas.Brush.Color:=clBlack;

 HDiffLimit:=6;
 WDiffLimit:=6;

 if (Sender as TComponent).Tag=0 then
 for i:=0 to Length(BaseSymbols)-1 do
 begin
  Str:=BaseSymbols[i].Text;
//  Bmp.Canvas.Font.Height:=BaseSymbols[i].IA.Height-2;
  if (Str<>'') then
  if (BaseSymbols[i].IA.Height>0) then
  if (BaseSymbols[i].IA.Width>0) then
{  if (Ord(Str[1])>=Ord('A')) and (Ord(Str[1])<=Ord('z')) then}
  begin
   Bmp.Canvas.Font.Height:=BaseSymbols[i].IA.Height-6-8;//1;
   Rct:=Rect(0,0,0,0);
//  while Bmp.Canvas.TextHeight(Str)<(BaseSymbols[i].IA.Height-4)
  while (Rct.Bottom-Rct.Top)<(BaseSymbols[i].IA.Height-6)
   do
   begin
    Bmp.Canvas.Font.Height:=Bmp.Canvas.Font.Height+1;
    Bmp.Width:=0;
    Bmp.Width:=Bmp.Canvas.TextWidth(Str);//BaseSymbols[i].IA.Width;
    Bmp.Height:=Bmp.Canvas.TextHeight(Str);//BaseSymbols[i].IA.Height;
    Bmp.Canvas.TextOut(1,1,Str);
    Rct:=GetRect24b(Bmp);
   end;
  Bmp2.Width:=0;
  Bmp2.Width:=Max(BaseSymbols[i].IA.Width-2,Rct.Right-Rct.Left);

//  Bmp2.Height:=BaseSymbols[i].IA.Height-2;
  Bmp2.Height:=1;//Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top);
  PByteArray(Bmp2.ScanLine[0])[0]:=CLR_MASK_NONE;
  Clr:=Bmp2.Canvas.Pixels[0,0];
  Bmp2.Canvas.Brush.Color:=Clr;
  Bmp2.Width:=0;
  Bmp2.Width:=Rct.Right-Rct.Left+4;
  Bmp2.Height:=Rct.Bottom-Rct.Top+4;
  if  (Abs(Bmp2.Width-BaseSymbols[i].IA.Width)<WDiffLimit)
  and (Abs(Bmp2.Height-BaseSymbols[i].IA.Height)<HDiffLimit) then
  BEGIN
  for Y:=Rct.Top to Rct.Bottom do
   begin
   PX:=Bmp.ScanLine[Y];
   PY:=Bmp2.ScanLine[Y+2-Rct.Top];
   for X:=Rct.Left to Rct.Right do
    begin
     if PX[X*3]>100 then PY[X+2-Rct.Left]:=CLR_MASK_MAIN
     else PY[X+2-Rct.Left]:=CLR_MASK_NONE;
    end;
   end;
   Res:=CompareGlyphBitmaps(GetBaseSymbolBitmap(i),Bmp2);
   BM:=BM+Res.BestMatch;
   SetProgress(i*100/(Length(BaseSymbols)-1));
   inc(Ctr);
   if sbShowAutoFontCompareResults.Down then
   begin
    CompareResultToAddSymbolForm;
    AddSymbolForm.edText.Text:=BaseSymbols[i].Text;
    AddSymbolForm.edText.SelectAll;
    ResM:=AddSymbolForm.ShowModal;
    if ResM=mrAbort then break;
   end;
  END;
//   if Res.BestMatch>98 then inc(Ctr1);
  end;
 end
 else
 begin //finding best font
 j:=0; BMM:=0;
 while (j<lbTryFonts.Items.Count) do
 begin
 FontTested:=lbTryFonts.Items[j];//edAutoFontName.Text;//'Arial';
 Bmp.Canvas.Font.Name:=FontTested;
 Inc(j);
 for i:=0 to Length(BaseSymbols)-1 do
 begin
  Str:=BaseSymbols[i].Text;
  if (Str<>'') then
  if (BaseSymbols[i].IA.Height>0) then
  if (BaseSymbols[i].IA.Width>0) then
  begin
   Bmp.Canvas.Font.Height:=BaseSymbols[i].IA.Height;//1;
   Rct:=Rect(0,0,0,0);
  while ((Rct.Bottom-Rct.Top)<(BaseSymbols[i].IA.Height-6)) do
   begin
    Bmp.Canvas.Font.Height:=Bmp.Canvas.Font.Height+1;
    Bmp.Width:=0;
    Bmp.Width:=Bmp.Canvas.TextWidth(Str);//BaseSymbols[i].IA.Width;
    Bmp.Height:=Bmp.Canvas.TextHeight(Str);//BaseSymbols[i].IA.Height;
    Bmp.Canvas.TextOut(1,1,Str);
    Rct:=GetRect24b(Bmp);
    if (Rct.Bottom-Rct.Top)=0 then break;
   end;
  Bmp2.Width:=0;
  Bmp2.Width:=Max(BaseSymbols[i].IA.Width-2,Rct.Right-Rct.Left);

//  Bmp2.Height:=BaseSymbols[i].IA.Height-2;
  Bmp2.Height:=1;//Max(BaseSymbols[i].IA.Height-2,Rct.Bottom-Rct.Top);
  PByteArray(Bmp2.ScanLine[0])[0]:=CLR_MASK_NONE;
  Clr:=Bmp2.Canvas.Pixels[0,0];
  Bmp2.Canvas.Brush.Color:=Clr;
  Bmp2.Width:=0;
  Bmp2.Width:=Rct.Right-Rct.Left+4;
  Bmp2.Height:=Rct.Bottom-Rct.Top+4;
  if  (Abs(Bmp2.Width-BaseSymbols[i].IA.Width)<WDiffLimit)
  and (Abs(Bmp2.Height-BaseSymbols[i].IA.Height)<HDiffLimit) then
  BEGIN
  for Y:=Rct.Top to Rct.Bottom do
   begin
   PX:=Bmp.ScanLine[Y];
   PY:=Bmp2.ScanLine[Y+2-Rct.Top];
   for X:=Rct.Left to Rct.Right do
    begin
     if PX[X*3]>100 then PY[X+2-Rct.Left]:=CLR_MASK_MAIN
     else PY[X+2-Rct.Left]:=CLR_MASK_NONE;
    end;
   end;
   Res:=CompareGlyphBitmaps(GetBaseSymbolBitmap(i),Bmp2);
   BM:=BM+Res.BestMatch;
   SetProgress(i*100/(Length(BaseSymbols)-1));
   inc(Ctr);
   if sbShowAutoFontCompareResults.Down then
   begin
    CompareResultToAddSymbolForm;
    AddSymbolForm.edText.Text:=BaseSymbols[i].Text;
    AddSymbolForm.edText.SelectAll;
    ResM:=AddSymbolForm.ShowModal;
    if ResM=mrAbort then break;
   end;
  END;
//   if Res.BestMatch>98 then inc(Ctr1);
  end;
 end;
 if Ctr=0 then Ctr:=1;
 BM:=BM/Ctr;
 if (BM>BMM) then
 begin
  BestFontName:=FontTested;
  BMM:=BM;
 end;
 BM:=0;
 Ctr:=0;
 end;
 end;
 finally
  Bmp.Free;
  Bmp2.Free;
 end;
// ShowMessage('Similarity = '+FloatToStr(Ctr1*100/Ctr)+' %');
 if Ctr=0 then Ctr:=1;

 if (Sender as TCOmponent).Tag=0 then
 ShowMessage(Format('Average Similarity = %5.3f %%',[BM/Ctr]))
 else ShowMessage(Format('Average Similarity = %5.3f %%'#13#10'Best Font: %s',[BMM, BestFontName]));
 SetProgress(0);
end;

procedure TGlyphForm.btSortSymbolsClick(Sender: TObject);
var // SL:TStringList;
    I, J: integer;
    BS: TBaseSymbol;
begin
// SL:=TStringList.Create;
 OptimizeBaseSymbols;
 try
  for i:=0 to Length(BaseSymbols)-1 do
  if BaseSymbols[i].Text<>'' then
  for j:=i+1 to Length(BaseSymbols)-1 do
  if BaseSymbols[j].Text<>'' then
   if Ord(BaseSymbols[i].Text[1])>Ord(BaseSymbols[j].Text[1]) then
   begin
    BS:=BaseSymbols[i];
    BaseSymbols[i]:=BaseSymbols[j];
    BaseSymbols[j]:=BS;
   end;
 finally
//  SL.Free;
 end;
 tbsGlyphsShow(Sender);
end;

procedure TGlyphForm.SetTitle;
begin
// if Str<>'' then Self.Caption:='AVISubOCR v0.6 alpha - '+str
// else Self.Caption:='AVISubOCR v0.6 alpha';
 if Str<>'' then Self.Caption:='OCR - '+str
 else Self.Caption:='OCR';
end;

procedure TGlyphForm.sgAlphabetDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var c:char;
    W1, H1, W2, H2: integer;
begin
 sgAlphabet.Font.Name:=edAutoFontNameX.Text;
 if sgAlphabet.Objects[ACol, ARow]<>nil then
 with (Sender as TStringGrid).Canvas do
  begin
   Brush.Color:=clBlack;
   Font.Color:=clWhite;
  end
  else
  begin
   Brush.Color:=clWhite;
   Font.Color:=clBlack;
  end;
 with (Sender as TStringGrid).Canvas do
 begin;
  Font.Height:=20;
  Rectangle(Rect);
  C:=Chr(Min(255,ARow*32+ACol+32));
  W1:=TextWidth(c) div 2;
  H1:=TextHeight(c) div 2;
  W2:=(Rect.Right-Rect.Left) div 2;
  H2:=(Rect.Bottom-Rect.Top) div 2;
  TextOut(Rect.Left+W2-W1,Rect.Top + H2-H1,c);
 end;
end;

procedure TGlyphForm.sgAlphabetSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 CanSelect:=true;
 if sgAlphabet.Objects[ACol, ARow]<>nil then
  sgAlphabet.Objects[ACol, ARow]:=nil
  else sgAlphabet.Objects[ACol, ARow]:=Self;
 edAutoRecognitionLineChange(nil);
end;

procedure TGlyphForm.edAutoRecognitionLineChange(Sender: TObject);
var i,j: integer;
    s: string;
begin
 //
 if Sender<>nil then
 begin
  s:=edAutoRecognitionLine.Text;
  for j:=0 to 6 do
  for i:=0 to 31 do
  sgAlphabet.Objects[i, j]:=nil;
  for i:=1 to Length(s) do
    sgAlphabet.Objects[Ord(s[i]) mod 32, (Ord(s[i]) div 32)-1]:=Sender;
 end;
// if Sender=nil then
// begin
  s:='';
  if sbReverseAutoOrder.Down then
   for j:=6 downto 0 do
   for i:=31 downto 0 do
   if ((i+j<>0)) and (sgAlphabet.Objects[i, j]<>nil) then s:=s+Chr(Min(255,j*32+i+32))
   else
  else
  for j:=0 to 6 do
  for i:=0 to 31 do
   if (i+j<>0) and (sgAlphabet.Objects[i, j]<>nil) then s:=s+Chr(Min(255,j*32+i+32));
  if edAutoRecognitionLine.Text<>s then edAutoRecognitionLine.Text:=s;
// end
end;

procedure TGlyphForm.edAutoFontNameXChange(Sender: TObject);
begin
 sgAlphabet.Invalidate;
end;

procedure TGlyphForm.btClearTxtIgnoreClick(Sender: TObject);
begin
  ClearIgnores;
  OptimizeBaseSymbols;
end;

procedure TGlyphForm.clbAutoFontsCheckedClick(Sender: TObject);
var i, j, Sel: integer; s:string;
begin
//
{ Sel:=0;
 for i:=0 to clbAutoFontsChecked.Items.Count-1 do
 if clbAutoFontsChecked.Selected[i] then
 begin  Sel:=i; break; end;}

 lbTryFonts.Clear;

 for i:=0 to clbAutoFontsChecked.Items.Count-1 do
 if (clbAutoFontsChecked.Checked[i]) then lbTryFonts.Items.Add(clbAutoFontsChecked.Items[i]);

 SetLength(CharSizeMaps,lbTryFonts.Items.Count);
 for i:=0 to lbTryFonts.Items.Count-1 do
 begin
  ClearCharSizeMap(CharSizeMaps[i]);
  CreateCharSizeMap(Trim(lbTryFonts.Items[i]), CharSizeMaps[i]);
 end;

end;

procedure TGlyphForm.btAreaDiffMapXClick(Sender: TObject);
var i, X,Y, DD2: integer; BmpMask, BmpSrc: TBitmap;
    PX, PY, PX2, PY2: PByteArray;
    RP, GP, BP,
    RXP, GXP, BXP,
    RYP, GYP, BYP: ^byte;
    {RD, GD, BD,}
    R,G,B,
    RX, RY, BX, BY, GX, GY,
    RXD, GXD, BXD,
    RXD2, GXD2, BXD2,
    RYD, GYD, BYD,
    RYD2, GYD2, BYD2,
    MaxD, SHift: integer;
    IADiff: TImageArray;
    Ctr, PtrX: integer;
//    Ptr: Pointer;

begin

 IADiff.Width:=ImageOrig.Picture.Bitmap.Width;
 IADiff.Height:=ImageOrig.Picture.Bitmap.Height;
 SetLength(IADiff.Pixels,IADiff.Width*IADiff.Height);
 PtrX:=Integer(@IADiff.Pixels[0]);
 Ctr:=(IADiff.Width*IADiff.Height div 4);
// Ctr:=Integer(@IADiff.Pixels[0]);
// for X:=0 to IADiff.Width*IADiff.Height-1 do IADiff.Pixels[X]:=0;
{ asm
  push ecx
  push edx
  mov ecx, PtrX;
  mov edx, Ctr;
@RPT:
  mov [dword ptr ecx*4], 0
  inc ecx
  dec edx
  jnz @RPT
  pop edx
  pop ecx
 end;}

 ImageMask5.Picture.Bitmap.PixelFormat:=pf24bit;
 ImageMask5.Picture.Bitmap.Width:=ImageOrig.Picture.Bitmap.Width;
 ImageMask5.Picture.Bitmap.Height:=ImageOrig.Picture.Bitmap.Width;

{ GetDiffMap_SSE(PChar(ImageOrig.Picture.Bitmap.ScanLine[0]),
                PChar(ImageMask5.Picture.Bitmap.ScanLine[0]),
                IADiff.Width*IADiff.Height-30,3);}

 ImageMask5.Visible:=true;
 exit;               
// RD:=80; GD:=80; BD:=80;
{ RD:=StrToIntDef(edAnalyzeDiffLimit.Text,80);
 GD:=RD; BD:=RD;}

 Shift:=StrToIntDef(edAnalyzeShift.Text,4);//4;

// DD:=Max(16,StrToIntDef(edAnalyzeDivider.Text,16));//64; //16;
 MaxD:=0;

 with ImageOrig.Picture.Bitmap do
 for Y:=Shift to Height-1-Shift do
 begin
  PX:=ScanLine[Y];
  PY:=ScanLine[Y-Shift];
  PY2:=ScanLine[Y+Shift];
  for X:=Shift to Width-1-Shift do
  begin
   R:=PX[X*3+2]; G:=PX[X*3+1]; B:=PX[X*3];
   RX:=PX[(X-Shift)*3+2]; GX:=PX[(X-Shift)*3+1]; BX:=PX[(X-Shift)*3];
   RY:=PY[X*3+2]; GY:=PY[X*3+1]; BY:=PY[X*3];

   RXD:=abs(R-RX);   GXD:=abs(G-GX);   BXD:=abs(B-BX);
   RYD:=abs(R-RY);   GYD:=abs(G-GY);   BYD:=abs(B-BY);

   RX:=PX[(X+Shift)*3+2]; GX:=PX[(X+Shift)*3+1]; BX:=PX[(X+Shift)*3];
   RY:=PY2[X*3+2]; GY:=PY2[X*3+1]; BY:=PY2[X*3];

   RXD2:=abs(R-RX);   GXD2:=abs(G-GX);   BXD2:=abs(B-BX);
   RYD2:=abs(R-RY);   GYD2:=abs(G-GY);   BYD2:=abs(B-BY);

   IADiff.Pixels[Y*IADiff.Width+X]:=Min(255,(RXD2+RXD+RYD+RYD2+
                                             GXD2+GXD+GYD+GYD2+
                                             BXD2+BXD+BYD+BYD2) div 12);
   if IADiff.Pixels[Y*IADiff.Width+X]>MaxD then MaxD:=IADiff.Pixels[Y*IADiff.Width+X];
  end;
 end;

{var i, X,Y, DD2: integer; BmpMask, BmpSrc: TBitmap;
    PX, PY, PX2, PY2: PByteArray;
    RP, GP, BP,
    RXP, GXP, BXP,
    RYP, GYP, BYP: ^byte;}

 BmpMask:=ImageMask4.Picture.Bitmap;
 BmpSrc:=ImageOrig.Picture.Bitmap;
 BmpMask.Canvas.Brush.Color:=clWhite;

 BmpMask.Width:=0;
 BmpMask.PixelFormat:=pf24bit;

 BmpMask.Width:=BmpSrc.Width;
 BmpMask.Height:=BmpSrc.Height;

// DD2:=(DD div 2)+1;
// DD2:=DD-1;
// DD2:=StrToIntDef(edFinalDelta.Text,32);
 for Y:=0 to BmpSrc.Height-1 do
 begin
  PX:=BmpMask.ScanLine[Y];
  for X:=0 to BmpSrc.Width-1 do
  begin
   RP:=@PX[X*3+2];    GP:=@PX[X*3+1];    BP:=@PX[X*3];

   RP^:=Max(0,Min(255,255-IADiff.Pixels[Y*IADiff.Width+X]-MaxD));
   GP^:=RP^; BP^:=RP^;
  end;
 end;

 SetLength(IADiff.Pixels,0);


 ImageMask4.Visible:=true;


end;

procedure TGlyphForm.CreateCharSizeMap;
var i, j, X, Y, Ctr, Ctr1, Ctr2, ResM: integer; PX, PY: PByteArray;
    BM: Extended;
    str: string;
    Bmp, BmpX: TBitmap;
    Res: TGlyphCompareResult;
    Rct: TRect;
    Clr: TColor;
    c: char;
    BestChar: char;
    BestCharMatch: extended;
    BestCharHeight: integer;
    BestCharFont: string;
    CmpStr: string;
    HDiffLimit, WDiffLimit: integer;
    PrevW, PrevH, HT: integer;
begin
 Ctr1:=0; Ctr2:=0; Ctr:=0; BM:=0;

 Bmp:=TBitmap.Create;
 BmpX:=TBitmap.Create;
 Bmp.PixelFormat:=pf24bit;

 CmpStr:=edAutoRecognitionLine.Text;
 try
 HT:=StrToIntDef(edMinTextHeight.Text,40);
 Bmp.Canvas.Font.Color:=clWhite;
 Bmp.Canvas.Brush.Color:=clBlack;
 Bmp.Canvas.Font.Name:=FontName;
 Bmp.Canvas.Font.Height:=1000;
 Bmp.Canvas.Font.Style:=[];
 CharSizeMapX.FontName:=FontName;
 for i:=1 to Length(CmpStr) do
 begin
  c:=CmpStr[i];
  Str:=c;//BaseSymbols[i].Text;
//   Bmp.Canvas.Font.Height:=1;
    SetTitle('Preparing Font Data - '+FontName+' - '+c);
    SetProgress(i*100/Length(CmpStr));
    Rct:=Rect(0,0,0,0);
    PrevW:=0; PrevH:=0;
    Bmp.Width:=0;
    PrevW:=Bmp.Canvas.TextWidth(Str);
    PrevH:=Bmp.Canvas.TextHeight(Str);
    Bmp.Width:=PrevW;//BaseSymbols[i].IA.Width;
    Bmp.Height:=PrevH;//BaseSymbols[i].IA.Height;
    Bmp.Canvas.TextOut(1,1,Str);
    Rct:=GetRect24b(Bmp, BmpX);
    CharSizeMapX.Data[c].WX:=Rct.Right-Rct.Left;
    CharSizeMapX.Data[c].HX:=Rct.Bottom-Rct.Top;
    CharSizeMapX.Data[c].X1:=Rct.Left;
    CharSizeMapX.Data[c].Y1:=Rct.Top;
    CharSizeMapX.Data[c].X2:=Rct.Right;
    CharSizeMapX.Data[c].Y2:=Rct.Bottom;
    CharSizeMapX.Data[c].AreasCtr:=VolumeBlast(BmpX,0,CLR_MASK_MAIN, nil, @CharSizeMapX.Data[c].Areas, 0);
    CharSizeMapX.Data[c].HasData:=true;
 end;
 if cbTryItalic.Checked then
 begin
  Bmp.Canvas.Font.Style:=[fsItalic];
 for i:=1 to Length(CmpStr) do
 begin
  c:=CmpStr[i];
  Str:=c;//BaseSymbols[i].Text;
//   Bmp.Canvas.Font.Height:=1;
    SetTitle('Preparing Font Data - Italic '+FontName+' - '+c);
    SetProgress(i*100/Length(CmpStr));
    Rct:=Rect(0,0,0,0);
    PrevW:=0; PrevH:=0;
    Bmp.Width:=0;
    PrevW:=Bmp.Canvas.TextWidth(Str);
    PrevH:=Bmp.Canvas.TextHeight(Str);
    Bmp.Width:=PrevW;//BaseSymbols[i].IA.Width;
    Bmp.Height:=PrevH;//BaseSymbols[i].IA.Height;
    Bmp.Canvas.TextOut(1,1,Str);
    Rct:=GetRect24b(Bmp, BmpX);
    CharSizeMapX.IData[c].WX:=Rct.Right-Rct.Left;
    CharSizeMapX.IData[c].HX:=Rct.Bottom-Rct.Top;
    CharSizeMapX.IData[c].X1:=Rct.Left;
    CharSizeMapX.IData[c].Y1:=Rct.Top;
    CharSizeMapX.IData[c].X2:=Rct.Right;
    CharSizeMapX.IData[c].Y2:=Rct.Bottom;
    CharSizeMapX.IData[c].AreasCtr:=VolumeBlast(BmpX,0,CLR_MASK_MAIN, nil, @CharSizeMapX.IData[c].Areas, 0);
    CharSizeMapX.IData[c].HasData:=true;
  end;
 end;
 finally
 Bmp.Free;
 BmpX.Free;
 end;
 SetProgress(0);
 SetTitle('');
end;

procedure TGlyphForm.ClearCharSizeMap;
var c: char;
begin
 for c:=#0 to #255 do CharSizeMapX.Data[c].HasData:=false;
end;

procedure TGlyphForm.pbSymbolsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Start, i, TopHeight, TopWidth, MarginXY, WX, WY, WW, HH, NumX: integer;
    Str: string; BmpX: TBitmap;
    Res: integer;
begin

// sclGlyphScroll.Max:=Max(0,Length(Glyphs)-20);
 sclGlyphScroll.Max:=Max(0,Length(BaseSymbols)-20);
 Start:=sclGlyphScroll.Position;
 TopHeight:=0; TopWidth:=0;
 for i:=Start to Length(BaseSymbols)-1 do
  if BaseSymbols[i].IA.Width>TopWidth then TopWidth:=BaseSymbols[i].IA.Width;
 for i:=Start to Length(BaseSymbols)-1 do
  if BaseSymbols[i].IA.Height>TopHeight then TopHeight:=BaseSymbols[i].IA.Height;

 MarginXY:=20;
 TopWidth:=TopWidth+MarginXY*2;
 TopHeight:=TopHeight+MarginXY*2;
 WW:=pbSymbols.Width div TopWidth;
// HH:=Bmp.Height div TopHeight;

 NumX:=-100;
 for i:=Start to Length(BaseSymbols)-1 do
 begin
    //BmpX:=GetBaseSymbolBitmap(i);
    WX:=((i-Start) mod WW)*TopWidth;//((TopWidth div 2)-BmpX.Width);
    WY:=((i-Start) div WW)*TopHeight;
    if (WX<X) and (WX+TopWidth>X) then
    if (WY<Y) and (WY+TopHeight>Y) then
    begin NumX:=i; break; end;
 end;

 if NumX<0 then exit;
  
 if Button=mbRight then
 begin
  BmpX:=GetBaseSymbolBitmap(NumX);
  RefineSymbolForm.Image.Picture.Bitmap.Assign(BmpX);
  Res:=RefineSymbolForm.ShowModal;
  if Res=mrOk then
  begin
   if (BaseSymbols[NumX].UsesIA) then
    BaseSymbols[NumX].Bmp:=TBitmap.Create;
    BaseSymbols[NumX].Bmp.Assign(RefineSymbolForm.Image.Picture.Bitmap);
    BaseSymbols[NumX].UsesIA:=false;
   OptimizeBaseSymbols;
  end;
  tbsGlyphsShow(Self);
 end
 else
 if Button=mbLeft then
 begin

  SymbolSelected:=NumX;

  btSymbolCancelClick(Self);
  
{   CompareGlyphBitmaps(BmpX,BmpX);
   CompareResultToAddSymbolForm;
   AddSymbolForm.edText.Text:=BaseSymbols[NumX].Text;

  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=0;
  AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Brush.Color:=clWhite;
  AddSymbolForm.ImageContext.Picture.Bitmap.Width:=AddSymbolForm.ImageContext.Width;
  AddSymbolForm.ImageContext.Picture.Bitmap.Height:=AddSymbolForm.ImageContext.Height;
  AddSymbolForm.ImageContext.Picture.Bitmap.PixelFormat:=pf8bit;
  BitBlt(AddSymbolForm.ImageContext.Picture.Bitmap.Canvas.Handle,
         (AddSymbolForm.ImageContext.Width div 2)-(CompareBitmap1.Width div 2),
         (AddSymbolForm.ImageContext.Height div 2)-(CompareBitmap1.Height div 2),
         AddSymbolForm.ImageContext.Width,AddSymbolForm.ImageContext.Height,
  CompareBitmap1.Canvas.Handle,0,0,SRCCOPY);
//  with AddSymbolForm.ImageContext.Picture.Bitmap.Canvas do

   Res:=AddSymbolForm.ShowModal;

   if Res=mrOK then BaseSymbols[NumX].Text:=AddSymbolForm.edText.Text;}
  tbsGlyphsShow(Self);
 end;

end;

procedure TGlyphForm.edSymbolTextChange(Sender: TObject);
var IsChanged: boolean;
begin
 if SymbolSelected>=Length(BaseSymbols) then exit;
 IsChanged:=(edSymbolText.Text<>BaseSymbols[SymbolSelected].Text) or
            (BaseSymbols[SymbolSelected].IsItalic<>cbItalic.Checked) or
            (BaseSymbols[SymbolSelected].IsBold<>cbBold.Checked) or
            (BaseSymbols[SymbolSelected].IsUnderline<>cbUnderline.Checked);
 btSymbolOk.Enabled:=IsChanged;
 btSymbolCancel.Enabled:=btSymbolOk.Enabled;
end;

procedure TGlyphForm.btSymbolOKClick(Sender: TObject);
begin
 if SymbolSelected>=Length(BaseSymbols) then exit;
  BaseSymbols[SymbolSelected].Text:=edSymbolText.Text;
  BaseSymbols[SymbolSelected].IsItalic:=cbItalic.Checked;
  BaseSymbols[SymbolSelected].IsBold:=cbBold.Checked;
  BaseSymbols[SymbolSelected].IsUnderline:=cbUnderline.Checked;

end;

procedure TGlyphForm.btSymbolCancelClick(Sender: TObject);
var i: integer;
begin
 if SymbolSelected>=Length(BaseSymbols) then exit;

  Image1.Picture.Assign(GetBaseSymbolBitmap(SymbolSelected));
  edSymbolText.Text:=BaseSymbols[SymbolSelected].Text;
  cbItalic.Checked:=BaseSymbols[SymbolSelected].IsItalic;
  cbBold.Checked:=BaseSymbols[SymbolSelected].IsBold;
  cbUnderline.Checked:=BaseSymbols[SymbolSelected].IsUnderline;
  lbSymbolAreas.Caption:='';
  for i:=1 to BaseSymbols[SymbolSelected].AreaCount do
  lbSymbolAreas.Caption:=lbSymbolAreas.Caption+
        Format('(%d,%d)[%dx%d]'#13#10,
        [
         BaseSymbols[SymbolSelected].Areas[i].X1,
         BaseSymbols[SymbolSelected].Areas[i].Y1,
         BaseSymbols[SymbolSelected].Areas[i].X2-BaseSymbols[SymbolSelected].Areas[i].X1,
         BaseSymbols[SymbolSelected].Areas[i].Y2-BaseSymbols[SymbolSelected].Areas[i].Y1
         ]);

end;

function TGlyphForm.CheckBaseBands;
var i,j: integer;
//    BandBase: array of TStartStopIntCtr;
    AreaNum, GlyphNum,
    CtrX1, CtrX2, CtrX3, SameHeightCtr: array of integer;
    Thresh, SymbolHeight, X, Y: integer;
begin

 Result:=false;
 SetLength(TempRects,0);
 SetLength(AreaNum,0);
 SetLength(GlyphNum,0);
 for i:=0 to Length(GlyphData)-1 do
 for j:=1 to GlyphData[i].AreaCount do
 if GlyphData[i].Areas[j].AreaEnabled then
 begin
  AddTempRect(Rect(GlyphRects[i].Left+GlyphData[i].Areas[j].X1,
                   GlyphRects[i].Top+GlyphData[i].Areas[j].Y1,
                   GlyphRects[i].Left+GlyphData[i].Areas[j].X2,
                   GlyphRects[i].Top+GlyphData[i].Areas[j].Y2));
  SetLength(GlyphNum,Length(GlyphNum)+1);
  GlyphNum[Length(GlyphNum)-1]:=i;
  SetLength(AreaNum,Length(AreaNum)+1);
  AreaNum[Length(AreaNum)-1]:=j;
 end;

//  SetLength(BandBase,Length(TempRects));

  SetLength(CtrX1,Length(TempRects));
  SetLength(CtrX2,Length(TempRects));
  SetLength(CtrX3,Length(TempRects));
  SetLength(SameHeightCtr,Length(TempRects));

  for i:=0 to Length(TempRects)-1 do CtrX1[i]:=0;
  for i:=0 to Length(TempRects)-1 do CtrX2[i]:=0;
  for i:=0 to Length(TempRects)-1 do CtrX3[i]:=0;
  for i:=0 to Length(TempRects)-1 do SameHeightCtr[i]:=0;

  Thresh:=4;

  if Length(TempRects)<2 then exit;

  for i:=0 to Length(TempRects)-1 do
  for j:=0 to Length(TempRects)-1 do
  if i<>j then
  begin
   if abs(TempRects[i].Top-TempRects[j].Top)<=Thresh then Inc(CtrX1[i]);
   if abs(TempRects[i].Bottom-TempRects[j].Bottom)<=Thresh then Inc(CtrX2[i]);
   if (abs(TempRects[i].Top+((TempRects[i].Top - TempRects[i].Bottom) div 2)-TempRects[j].Bottom)<=Thresh)
   or (abs(TempRects[i].Top+((TempRects[i].Top - TempRects[i].Bottom) div 2)-TempRects[j].Top)<=Thresh)
   then Inc(CtrX3[i]);
   if ((abs(TempRects[i].Bottom-TempRects[i].Top)-abs(TempRects[j].Bottom-TempRects[j].Top))<Thresh)
   then Inc(SameHeightCtr[i]);
  end;

  SymbolHeight:=StrToIntDef(edMinTextHeight.Text,40);

  for i:=0 to Length(TempRects)-1 do
  if (CtrX3[i]<3) and (CtrX2[i]<3) and (CtrX1[i]<3) then
  if abs(TempRects[i].Bottom-TempRects[i].Top)>=SymbolHeight then
  begin
//      X:=GlyphRects[GlyphNum[i]].Left+GlyphData[GlyphNum[i]].Areas[AreaNum[i]].FX-1;
//      Y:=GlyphRects[GlyphNum[i]].Top+GlyphData[GlyphNum[i]].Areas[AreaNum[i]].FY-1;
//      AddTextIgnorePoint(Point(X,Y),true);
      RemoveArea(GlyphData[GlyphNum[i]].Areas[AreaNum[i]].GlobalAreaNum);//,GlyphData[GlyphNum[i]].Areas[AreaNum[i]].AreaNum,GlyphNum[i]);
      Result:=true;
  end;

  SetLength(CtrX1,0);
  SetLength(CtrX2,0);
  SetLength(CtrX3,0);
  SetLength(SameHeightCtr,0);
  SetLength(TempRects,0);
  SetLength(AreaNum,0);
  SetLength(GlyphNum,0);

end;

procedure TGlyphForm.FormShow(Sender: TObject);
begin
 //
 if Mask1Bitmap.Width<2 then exit;
 ModalResult:=0;
 UpdateTimer2.Enabled:=true;
 UpdateTimer2.Interval:=100;
end;

function TGlyphForm.ProcessBitmap;
begin
 //
 if Mask1Bitmap.Width<2 then exit;
 ModalResult:=0;
 UpdateTimer2.Enabled:=true;
 UpdateTimer2.Interval:=100;
// btBuildMaskXClick(Self);
 while ModalResult=0 do Application.ProcessMessages;
 Result:=ModalResult;
end;


procedure TGlyphForm.btOKClick(Sender: TObject);
begin
 ModalResult:=(Sender as TButton).ModalResult;
end;

procedure TGlyphForm.btSymbolDeleteClick(Sender: TObject);
begin
//
 if SymbolSelected>=Length(BaseSymbols) then exit;

 DeleteSymbol(SymbolSelected);
 btSymbolCancelClick(Self);
 tbsGlyphsShow(Self);
end;

procedure TGlyphForm.DeleteSymbol;
var i:integer;
begin
 if Num>=Length(BaseSymbols) then exit;

 if BaseSymbols[Num].UsesIA then SetLength(BaseSymbols[Num].IA.Pixels,0)
 else BaseSymbols[Num].Bmp.Free;
 BaseSymbols[Num].Text:='';
// FreeMem(BaseSymbols[Num]);

 for i:=Num to Length(BaseSymbols)-2 do BaseSymbols[i]:=BaseSymbols[i+1];
 SetLength(BaseSymbols,Length(BaseSymbols)-1);

end;

procedure TGlyphForm.sbCopyDominatorsFromMainClick(Sender: TObject);
var i:integer;
begin
{$IFDEF INSIDE_ASD}
 SetLength(ColorDoms,Length(MainForm.ColorDominators));
 for i:=0 to Length(MainForm.ColorDominators)-1 do
 begin
  ColorDoms[i].R:=MainForm.ColorDominators[i].R;
  ColorDoms[i].G:=MainForm.ColorDominators[i].G;
  ColorDoms[i].B:=MainForm.ColorDominators[i].B;

  ColorDoms[i].RD:=MainForm.ColorDominators[i].RD;
  ColorDoms[i].GD:=MainForm.ColorDominators[i].GD;
  ColorDoms[i].BD:=MainForm.ColorDominators[i].BD;

  case MainForm.ColorDominators[i].DomType of
   CT_SUBTITLE: ColorDoms[i].ColorType:=ctBoneText; 
   CT_EXTRA:    ColorDoms[i].ColorType:=ctOther;
   CT_ANTIALIAS: ColorDoms[i].ColorType:=ctMeatText;
   CT_OUTLINE: ColorDoms[i].ColorType:=ctSkinOutline;
   else ColorDoms[i].ColorType:=ctOther;
  end;
 end;

{$ENDIF INSIDE_ASD}
end;

procedure TGlyphForm.sbMoveUpClick(Sender: TObject);
var s: string; b: boolean;
begin
 s:=clbBuildMaskList.Items[clbBuildMaskList.ItemIndex];
 b:=clbBuildMaskList.Checked[clbBuildMaskList.ItemIndex];
 if clbBuildMaskList.ItemIndex<=0 then exit;
 clbBuildMaskList.Items.Exchange(clbBuildMaskList.ItemIndex,clbBuildMaskList.ItemIndex-1);
 clbBuildMaskList.ItemIndex:=clbBuildMaskList.ItemIndex-1;
end;

procedure TGlyphForm.sbMoveDownClick(Sender: TObject);
var s: string; b: boolean;
begin
 s:=clbBuildMaskList.Items[clbBuildMaskList.ItemIndex];
 b:=clbBuildMaskList.Checked[clbBuildMaskList.ItemIndex];
 clbBuildMaskList.Items.Exchange(clbBuildMaskList.ItemIndex,clbBuildMaskList.ItemIndex+1);
 clbBuildMaskList.ItemIndex:=clbBuildMaskList.ItemIndex+1;
end;

procedure TGlyphForm.AddMaskAction;
var s: string;
begin
 if Param=0 then s:=Format('[%.3d] %s',[integer(Action), cmbMaskActions.Items[Action] ])
 else s:=Format('[%.3d] (%.3d) %s',[integer(Action), Param, cmbMaskActions.Items[Action] ]);
 clbBuildMaskList.Items.Add(s);
 clbBuildMaskList.Checked[clbBuildMaskList.Items.Count-1]:=IsChecked;
 clbBuildMaskList.ItemEnabled[clbBuildMaskList.Items.Count-1]:=IsEnabled;
end;

procedure TGlyphForm.sbAddMaskActionClick(Sender: TObject);
begin
 AddMaskAction(cmbMaskActions.ItemIndex,StrToIntDef(edMaskActionParam.Text,0));
end;

procedure TGlyphForm.clbBuildMaskListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 cmbMaskActions.ItemIndex:=StrToIntDef(GetParam1(clbBuildMaskList.Items[clbBuildMaskList.ItemIndex]),0);
 edMaskActionParam.Text:=GetParam2(clbBuildMaskList.Items[clbBuildMaskList.ItemIndex]);
 if edMaskActionParam.Text='' then edMaskActionParam.Text:='0';
end;

procedure TGlyphForm.sbSetMaskActionClick(Sender: TObject);
var s: string;
begin

 if GetParam2(clbBuildMaskList.Items[clbBuildMaskList.ItemIndex])='' then
 s:=Format('[%.3d] %s',[cmbMaskActions.ItemIndex, cmbMaskActions.Items[cmbMaskActions.ItemIndex]])
 else s:=Format('[%.3d] (%.3d) %s',[cmbMaskActions.ItemIndex, StrToIntDef(edMaskActionParam.Text,0), cmbMaskActions.Items[cmbMaskActions.ItemIndex]] );
 clbBuildMaskList.Items[clbBuildMaskList.ItemIndex]:=s;
end;

procedure TGlyphForm.sbDeleteMaskActionClick(Sender: TObject);
begin
 clbBuildMaskList.Items.Delete(clbBuildMaskList.ItemIndex);
end;

procedure TGlyphForm.cmbPresetChange(Sender: TObject);
begin
//
 clbBuildMaskList.Items.Clear;
          AddMaskAction(CMD_TEXTMASK,0,true,false);
          AddMaskAction(CMD_OUTLINEMASK,0,true,false);
 CASE (cmbPreset.ItemIndex and $FF) OF
  0: begin

          AddMaskAction(CMD_ELIMINATEMINORTEXT);
//  AddMaskAction(CMD_GROW_TEXT,10);
//  AddMaskAction(CMD_GROW_OUTLINE,10);

          AddMaskAction(CMD_OUTLINETEXT);
          AddMaskAction(CMD_OUTLINEOUTLINE);

          AddMaskAction(CMD_EDGEFILLOUTLINE);

          AddMaskAction(CMD_ELIMINATEMINORTEXT);

          AddMaskAction(CMD_EDGELINETEXT);

          AddMaskAction(CMD_SUBTRACT_OUTLINE);
          AddMaskAction(CMD_MATCH_TO_OUTLINE,20);

          AddMaskAction(CMD_DIFFMASK,6064);
          AddMaskAction(CMD_GROW_DIFFMASK,10);
          AddMaskAction(CMD_REVERSE_SUBTRACT_DIFFMASK);
          AddMaskAction(CMD_IGNOREFILLTEXT);
          AddMaskAction(CMD_IGNOREFILLOUTLINE);
          AddMaskAction(CMD_OPENBLASTTEXT);
     end;
  1: begin

          AddMaskAction(CMD_ELIMINATEMINORTEXT);
          AddMaskAction(CMD_OUTLINETEXT);
          AddMaskAction(CMD_OUTLINEOUTLINE);

          AddMaskAction(CMD_EDGELINETEXT);
          AddMaskAction(CMD_OPENBLASTTEXT);

          AddMaskAction(CMD_MATCH_TO_OUTLINE,20);
          AddMaskAction(CMD_OPENBLASTTEXT);

          AddMaskAction(CMD_EDGEFILLOUTLINE);
          AddMaskAction(CMD_SUBTRACT_OUTLINE);

          AddMaskAction(CMD_ELIMINATEMINORTEXT);

          AddMaskAction(CMD_DIFFMASK,8064);
          AddMaskAction(CMD_GROW_DIFFMASK,10);
          AddMaskAction(CMD_REVERSE_SUBTRACT_DIFFMASK);
          AddMaskAction(CMD_IGNOREFILLTEXT);
          AddMaskAction(CMD_IGNOREFILLOUTLINE);
          AddMaskAction(CMD_OPENBLASTTEXT);
     end;
  2: begin
          AddMaskAction(CMD_ELIMINATEMINORTEXT);
          AddMaskAction(CMD_OUTLINETEXT);
          AddMaskAction(CMD_OUTLINEOUTLINE);

          AddMaskAction(CMD_EDGEFILLOUTLINE);
          AddMaskAction(CMD_SUBTRACT_OUTLINE);

          AddMaskAction(CMD_EDGELINETEXT);
          AddMaskAction(CMD_OPENBLASTTEXT);

          AddMaskAction(CMD_MATCH_TO_OUTLINE,20);
          AddMaskAction(CMD_OPENBLASTTEXT);

//          AddMaskAction(CMD_EDGEFILLOUTLINE);
//          AddMaskAction(CMD_SUBTRACT_OUTLINE);

          AddMaskAction(CMD_ELIMINATEMINORTEXT);

          AddMaskAction(CMD_DIFFMASK,8064);
          AddMaskAction(CMD_GROW_DIFFMASK,10);
          AddMaskAction(CMD_REVERSE_SUBTRACT_DIFFMASK);
          AddMaskAction(CMD_IGNOREFILLTEXT);
          AddMaskAction(CMD_IGNOREFILLOUTLINE);
          AddMaskAction(CMD_OPENBLASTTEXT);
     end;
  END;

end;

procedure TGlyphForm.sbDisableNewSymbolsClick(Sender: TObject);
begin
 sbIgnoreNewSmall.Enabled:=(Sender as TSpeedButton).Down;
 sbIgnoreAllNew.Enabled:=(Sender as TSpeedButton).Down;
end;

procedure TGlyphForm.cmbZoomChange(Sender: TObject);
begin
 ReAlign;
end;

end.
