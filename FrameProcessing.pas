unit FrameProcessing;


interface
uses MyTypes1, SysUtils, Windows, Math, Classes;

type
   TASDFrameProcessor = class
   public
    BandRects: array of TRect;
    constructor Create;
    destructor Done;
    procedure Init(Width, Height, Margin: integer);
//    procedure ProcessImage(Image:Pointer; var FrameStats: TFrameStat; HelpMap: pointer = nil);
    function ProcessImage(Image:Pointer; HelpMap: pointer = nil):TFrameStat;
    procedure ClearBandRects;
    procedure AddBandRect(x1,y1,x2,y2,margin: integer);
    procedure OptimizeBandRects;
    function IsFrameSubtitled(FrameNowStat: TFrameStat):boolean;
    procedure SettingsFromStringList(SL:TStringList);
   private
     LineBlockCount:array of integer;
     OldLineBlockCount:array of integer;
     BlockPattern:array of integer; //BlockNum, LineNum BlockValue (sharpness)
{     ColorDominators: array of TColorDominator; //TRGB24; //dominating colors for subtitle detection}

    LineCountNeeded: integer;
    Offs, BlockSize, BlockMinimum, CenterWeight,
    MinLineBlockNum, MaxLineBlockCountDiff,
    FrameWidth, FrameHeight, BandMargin,
    ImageCutBottom, ImageCutTop,
    DropRed, DropBlue, DropGreen, DropSum,
    {DominatorDeviation, DominatorMultiply,}
    MaxSameLineVal, MaxSameLineCtr: integer;

//    ImageWidth, ImageHeight: integer;

{    IsDominatorMultiply, IsDominatorMaxSharpness, IsNonDominatorIgnore,}
    CentralDomination, CheckYDiff, FullLineSubPic,
    IsDropRed, IsDropBlue, IsDropGreen, IsDropSum
    : boolean;

     function CheckLineBlock16SharpX(var PXLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
     function CheckLineBlock16SharpXY(var PXLine, PYLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
{     function CheckLineBlock16SharpXWithDominators(var PXLine:PByteArray; BlockX, BlockY, Offs:integer):longint;
     function CheckLineBlock16SharpXYWithDominators(var PXLine, PYLine:PByteArray; BlockX, BlockY, Offs:integer):longint;}
   end;

implementation

constructor TASDFrameProcessor.Create;
begin
// FullLineSubPic:=cbFullLineSubPic.Checked;
end;

destructor TASDFrameProcessor.Done;
begin
     SetLength(BandRects,0);
     SetLength(LineBlockCount,0);
     SetLength(OldLineBlockCount,0);
     SetLength(BlockPattern,0);
{     SetLength(ColorDominators,0);}
end;

procedure TASDFrameProcessor.Init;
begin
 FrameWidth:=Width;
 FrameHeight:=Height;
 BandMargin:=Margin;
end;

procedure TASDFrameProcessor.SettingsFromStringList;
var i, j:integer; R,G,B: byte; s, str:string;
begin
 //settings
 begin
  try
//   SL.Values['Version']:='AVISubDetector v'+VersionString;
{   s:=SL.Values['Coverage'];
   if s='5' then sbOneFifth.Down:=true
   else if s='3' then sbImageOneThird.Down:=true
   else if s='2' then sbHalf.Down:=true
   else if s='1' then sbImageFull.Down:=true
   else begin sbImageQuarter.Down:=true; s:='4'; end;
   edCutFromTop.Text:=SL.Values['CutTop'];
   edCutFromBottom.Text:=SL.Values['CutBottom'];
   if (edCutFromTop.Text='') then
   begin
    edCutFromTop.Text:=IntToStr((100-(100 div StrToInt(s))));
    edCutFromBottom.Text:=IntToStr(1);
   end;}

{ MainForm.IsTrackMaxBlockCount:=false;
// MaxDropOut:=100;
 MainForm.Offs:=tbSharpOffset.Position;
 MainForm.LineBlockNumDetection:=false;
 MainForm.BlockSize:=StrToIntDef(edBlockSize.Text,16);

 MainForm.MinLineBlockNum:=StrToIntDef(edLineBlockMinimum.Text, 3);}

// MainForm.BlockMinimum:=StrToIntDef(edBlockValue.Text, 200); //difference in total of 16 points (for black-white stripes it is _maximum_ of 765*16=12240)
   BlockMinimum:=StrToIntDef(SL.Values['BlockValue'],200);
// MainForm.MinLineBlockNum:=StrToIntDef(edLineBlockMinimum.Text, 3);
   MinLineBlockNum:=StrToIntDef(SL.Values['BlockCount'],3);
   LineCountNeeded:=StrToIntDef(SL.Values['LineCount'],5);
{   IsCheckLineNumber:=
 MainForm.IsCheckLineNumber:=cbCheckLineNumber.Checked;
 MainForm.LineNumberChangeThreshold:=StrToIntDef(Trim(edLineNumberChangeThreshold.Text),5);
 MainForm.LineCountNeeded:=StrToIntDef(Trim(edLineCountNeeded.Text), 5); }


{   if SL.Values['BlockSize']<>'' then edBlockSize.Text:=SL.Values['BlockSize'];
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
   DropRed:=StrToIntDef(SL.Values['DR'],100);
   IsDropRed:=not(SL.Values['DR']='');
   DropGreen:=StrToIntDef(SL.Values['DG'],100);
   IsDropGreen:=not(SL.Values['DG']='');
   DropBlue:=StrToIntDef(SL.Values['DB'],100);
   IsDropBlue:=not(SL.Values['DB']='');
   DropSum:=StrToIntDef(SL.Values['DS'],100);
   IsDropSum:=not(SL.Values['DS']='');

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

  NoUpdate:=false;
//   PanelSettingsToData(Self);}
  finally
  end;
 end;

end;

FUNCTION TASDFrameProcessor.ProcessImage;
var i, j, k, SelSharp, Y, Pix, Pix_Offs, LineCtr, OldLineCtr, SameLineCtr, LinesChangedCtr, SharpXTmp:longint; LineMarked, BlockSharp, PrevBlockSharp: boolean;
    SharpBlockSum:longint; LastLineIsSharp: boolean;
    RightMostAvg, LeftMostAvg, LineRMB, LineLMB{, LineMostCtr}: integer;
    Image_Line,Image_Line2:PByteArray;
    BandLeft, BandRight, BandTop, BandBottom: integer;
    {BandMargin,} ImageSharpSum: integer;
    SharpLines, MaxBlockCount, MaxSameLineCtr: integer;
    SharpLinesAvg: extended;
//    BlockSize, BlockMinimum, CenterWeight: integer;
    LBCLinesOlder, LBCLines, LBCCount: integer; //LBC debugging values
//   Image:=Pointer(Integer(pbmi)+pbmi^.biSize);
begin
 LBCLines:=0; LBCCount:=0;
{ BlockSize:=MainForm.BlockSize;
 BlockMinimum:=MainForm.BlockMinimum;
 CenterWeight:=MainForm.CenterWeight;}
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
 LineRMB:=0; LineLMB:=(FrameWidth); Y:=0;
 BandLeft:=FrameWidth; BandRight:=0;
 BandTop:=FrameHeight; BandBottom:=0;
// BandMargin:=MainForm.SubPicMargin;
 ClearBandRects;
 // for Y:=(FrameHeight div 3)*2 to FrameHeight-5 do
 // for Y:=0 to (FrameHeight div ImagePartial)-1 do //checking lower part of image
// for Y:={MainForm.}ImageCutBottom to ({AVIFile.}FrameHeight-{MainForm.}ImageCutTop)-1 do //checking lower part of image
 for Y:=0 to FrameHeight-1 do
 begin
  PrevBlockSharp:=false;  LineCtr:=0; SharpBlockSum:=0;
    Image_Line:=Pointer(Integer(Image)+Y*3*FrameWidth);
  LineRMB:=0; LineLMB:=(FrameWidth);
  // -------- LINE PARAMETERS CHECK -------------
  for i:=0 to (FrameWidth div BlockSize)-2 do
  BEGIN
    if CheckYDiff or ((Y-Offs)<0) then
    begin
     if (Y-Offs)>=0 then Image_Line2:=Pointer(Integer(Image)+(Y-Offs)*3*FrameWidth);
     if (Y-Offs)>=0 then SharpXTmp:=CheckLineBlock16SharpXY(Image_Line,Image_Line2,i*BlockSize,Y,Offs)
     else SharpXTmp:=CheckLineBlock16SharpX(Image_Line,i*BlockSize,Y,Offs);
    end
    else SharpXTmp:=CheckLineBlock16SharpX(Image_Line,i*BlockSize,Y,Offs);
//    BlockPattern[i,Y]:=SharpXTmp; //storing for later use
    if not(SharpXTmp<=BlockMinimum) then
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
   END; //end of block-for
   // ------ END OF LINE PARAMETERS CHECK ------

   {MainForm.}LineBlockCount[Y]:=LineCtr;
   if LineCtr>{MainForm.}MinLineBlockNum then
   begin

    if (LastLineIsSharp) then
    begin {Inc(LineMostCtr); <=> SharpLines} Inc(RightMostAvg,LineRMB); Inc(LeftMostAvg,LineLMB); end;

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

    if (LastLineIsSharp) then //if final line was still sharp
    begin
     if (LineLMB<BandLeft) then BandLeft:=LineLMB;
     if (LineRMB>BandRight) then BandRight:=LineRMB;
     if (BandTop>Y) then BandTop:=Y;
     if (BandBottom<Y) then BandBottom:=Y;
     AddBandRect(BandLeft*BlockSize,FrameHeight-BandTop,BandRight*BlockSize+BlockSize-1,FrameHeight-BandBottom, BandMargin);
    end;

 if Length(BandRects)>0 then OptimizeBandRects;

   if (SharpLines>0) then SharpLinesAvg:=SharpLinesAvg/SharpLines else SharpLinesAvg:=0;

   Result.DLC:=SharpLines;
   Result.MED:=Trunc(SharpLinesAvg*10);
   Result.MBC:=MaxSameLineVal;
   Result.LBC:=LBCLines;
   Result.BandCount:=Length(BandRects);
   if (SharpLines>0) then
   begin
    Result.RMB:=Trunc((RightMostAvg*BlockSize)/SharpLines);
    Result.LMB:=Trunc((LeftMostAvg*BlockSize)/SharpLines);
    Result.MaxSameLineCtr:=MaxSameLineCtr;
    Result.LBCCount:=LBCCount;
   end else
   begin
    Result.RMB:=0;
    Result.LMB:=0;
    Result.MaxSameLineCtr:=0;
    Result.LBCCount:=0;
   end;
   Result.HasData:=true;

{ if not(IsFrameSubtitled(FrameStats)) then
 begin
  MaxSameLineVal:=0;
  MaxSameLineCtr:=0;
  LBCCount:=0;
 end;}
end;

PROCEDURE TASDFrameProcessor.ClearBandRects;
begin
 SetLength(BandRects,0);
end;

PROCEDURE TASDFrameProcessor.AddBandRect;
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
  if FullLineSubPic then
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

PROCEDURE TASDFrameProcessor.OptimizeBandRects;
var i, j: integer; x1,x2,y1,y2: integer;

Procedure MergeBandRects(n1,n2: integer);
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

FUNCTION TASDFrameProcessor.IsFrameSubtitled;
begin
 Result:=(FrameNowStat.DLC>LineCountNeeded);
end;

FUNCTION TASDFrameProcessor.CheckLineBlock16SharpX;//(var PXLine:PByteArray; BlockX, BlockY:integer):integer;
var i, X, Pix, Pix_offs, ValR, ValG, ValB:longint;
//    R1,G1,B1, R2, B2, G2: byte; Variance1, Variance2: integer;
//    HasDominator, IsDominator1, IsDominator2: boolean;
    SharpXRedTmp, SharpXBlueTmp, SharpXGreenTmp: integer;
begin
//  PX:=Image.Picture.Bitmap.ScanLine[Y];
//  X:=BlockX+BlockY*FrameWidth*3; //for 24bit frames
  X:=BlockX; //for 24bit frames
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;

// if not(IsDominatorMultiply or IsDominatorMaxSharpness or IsNonDominatorIgnore) then
 begin
  for i:=0 to BlockSize-1 do
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
end; 
// else

FUNCTION TASDFrameProcessor.CheckLineBlock16SharpXY;//(var PXLine, PYLine:PByteArray; BlockX, BlockY:integer):integer;
var i, j, X, Pix, Pix_offs, ValR, ValG, ValB:longint;
    R1,G1,B1, R2, B2, G2: byte; Variance1, Variance2: integer;
    HasDominator, IsDominator1, IsDominator2: boolean;
    SharpXRedTmp, SharpXBlueTmp, SharpXGreenTmp: integer;
begin
//  PX:=Image.Picture.Bitmap.ScanLine[Y];  X:=BlockX+BlockY*FrameWidth*3; //for 24bit frames
  X:=BlockX; //for 24bit frames
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;
//  if (X+15+Offs<FrameWidth) then

// if not(IsDominatorMultiply or IsDominatorMaxSharpness or IsNonDominatorIgnore) then
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
end;

{FUNCTION TASDFrameProcessor.CheckLineBlock16SharpXWithDominators;//(var PXLine:PByteArray; BlockX, BlockY:integer):integer;
var i, j, X, Pix, Pix_offs, ValR, ValG, ValB:longint;
    R1,G1,B1, R2, B2, G2: byte; Variance1, Variance2: integer;
    HasDominator, IsDominator1, IsDominator2: boolean;
    SharpXRedTmp, SharpXBlueTmp, SharpXGreenTmp: integer;
begin
  X:=BlockX; //for 24bit frames
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;

 begin
  HasDominator:=false;
  for i:=0 to BlockSize-1 do
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

FUNCTION TASDFrameProcessor.CheckLineBlock16SharpXYWithDominators;//(var PXLine, PYLine:PByteArray; BlockX, BlockY:integer):integer;
var i, j, X, Pix, Pix_offs, ValR, ValG, ValB:longint;
    R1,G1,B1, R2, B2, G2: byte; Variance1, Variance2: integer;
    HasDominator, IsDominator1, IsDominator2: boolean;
    SharpXRedTmp, SharpXBlueTmp, SharpXGreenTmp: integer;
begin
//  PX:=Image.Picture.Bitmap.ScanLine[Y];  X:=BlockX+BlockY*FrameWidth*3; //for 24bit frames
  X:=BlockX; //for 24bit frames
  SharpXRedTmp:=0;
  SharpXBlueTmp:=0;
  SharpXGreenTmp:=0;
// else
 begin
  HasDominator:=false;
  for i:=0 to BlockSize-1 do
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
end;}

end.
