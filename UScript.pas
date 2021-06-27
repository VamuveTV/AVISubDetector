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
unit UScript;

interface
uses {contnrs,} classes, sysutils, comctrls,
  {Dialogs,} Graphics, MyTypes1, Windows, Math;


     function NextPos(SubStr:string;S:string; from:integer):integer;
     function NextPos2(SubStr:string;S:string; from:integer):integer;

  const
   MaxLanguages = 150;
   MaxCountries = 250;
   MaxUnfilledGap:integer = 250; //ms
   NoTime = -2147483646 div 4;
//   NoTime=0;

   DefaultClassID = 'CC0'; //'CC'+IntToStr(0);
   DefaultActorName = 'N/A';//'Default Actor';
   DefaultGroupName = 'MAIN';
   TextIsClearStr:string = '&nbsp;';
//   LineBreakStr:string   = '<BR>';

{$define NO_FANSUBBER}

  function StrToTimeMS(Str:string;ErrorRes:longint):longint;
  type
    TScript=class(TList)
  protected
//    SMITextStyle:TFont;
    CurrentIndex:integer;
    function GetCurrentUIDItem:TScriptItem;
    procedure SetCurrentUIDItem(item:TScriptItem);
  public
     LineBreakStr:string;
     FName:string;
     Width, Height, SubWidth, SubHeight: integer; //for rendering purposes for some formats
     SubRects: array of TRect; //bounds of subtitles

     UniteOrderForward: boolean; //used for uniting time-crossed subtitles - forward true is first = topmost and forward false is first = lowest
     UniteCrossedIfNeeded: boolean; //unite time-crossed subtitles for SAMI/SRT 
//     OnlyPClass:boolean;
     Log, ErrorLog:TStringList;
     TimeSlice:array of longint;
     TimeRegionsCnt:array of integer;
//     Classes:TStringList;
//     PClass:integer; // was string - now should be used as Classes[PClass].ID
     Classes:array[0..MaxClasses] of TSubtitleClassItem;
     ClassesCount:byte;
     Actors:array[0..MaxActors] of TScriptActor;
     ActorsCount:byte;
     Groups:array[0..MaxGroups] of TScriptGroup;
     GroupsCount:byte;
     Languages:array[0..MaxLanguages] of TLanguageItem;
     LanguagesCount:byte;
     Countries:array[0..MaxCountries] of TCountryItem;
     CountriesCount:byte;


     ActorsList, GroupsList, ClassesList, ScriptItemStatusList,
     LanguageNameList, CountryNameList,
     HAlignNameList, VAlignNameList:TStringList;

     ScriptItemValueNames: array[SI_Min..SI_Max] of string;
     ScriptItemValueTypes: array[SI_Min..SI_Max] of TScriptItemValueTypes;

     NoScriptItem, ClearScriptItem:TScriptItem;
     FirstTimedItem:integer; //first item with time>-1

     MaxUID:integer;

     CurrentUID:integer;

     Slice: array of longint;
     LastScriptIndexes: array of longint; //indexes for ScriptItem Start Points in last _created_ script (not _parsed_ script)

//     property TextStyle:TFont read SMITextStyle write SMITextStyle;
     property CurrentUIDItem:TScriptItem read GetCurrentUIDItem write SetCurrentUIDItem;

//     procedure AddLine(Time:longint; length:integer; line:string);//Добавка строки.
//     procedure Add(Itm:TScriptItem);
     constructor Create;
     destructor Free;
     procedure ClearFree;
     procedure PartialClearFree;
     procedure RemoveClears;
     procedure DeleteAndFree(Idx:integer);
     procedure CreateTimeSlices(AcceptStatus:TScriptItemStatusSet; ClassNum:integer=-1);//(TimeSlice:array of longint);

     procedure InitLanguages;
     procedure InitCountries;
     procedure InitScriptItemValueNames;
     procedure UpdateInternalIndex;
     procedure CreateSubRects(Cnv:TCanvas);


     procedure LoadFromFile(FileName:string);

     function CheckClassID(ID:string):integer;
     function CheckActorName(Name:string):integer;
     function CheckGroupName(Name:string):integer;
     function CheckForUID(CheckedUID:integer):boolean;
     procedure CheckOverlapping;
     function IsOverlappingClass(ClassNum:integer):boolean;

     function GetPlain(SubtitleType:TSubType; ClassNum:integer = -1):string;
     function GetPlainSRT:string;
     function GetPlainSAMI:string;
     function GetPlainTXT:string;
     function GetLinedSRT:string;

     function GetExtendedSRT:string; //SRT with tags allowed

     function GetSSA(SaveClassNum:integer=-1):string;
     function GetSlicedSAMI(SaveClassNum:integer=-1):string;
     function GetRegionCountAtTime(Time:integer):integer;

     procedure CheckFSBSRTData(var si:TScriptItem;s:string);

     function GetClassNByID(ID:string):integer;
     function GetActorNum(Name:string):integer;
     function GetActorByName(Name:string):integer;
     function GetGroupNumByName(Name:string):integer;
     function GetNewClassId:string;
     function GetNewUID:integer;
     function GetScriptItemValueName(Value:TScriptItemValues):string;
     function GetScriptItemValueType(Value:TScriptItemValues):TScriptItemValueTypes;
     function GetScriptItemValueFromName(Name:string):TScriptItemValues;
     function GetScriptItemValueStr(Value:TScriptItemValues; si:TScriptItem):string;
     function SetScriptItemValue(Value:TScriptItemValues; Str:string; var si:TScriptItem):boolean;

     procedure UpdateGroupFormatting(GroupNum:integer;FM:TSubTextFormatting;Name:string);
     procedure ClearFormatting;

     function GetFormattingForUID(UID:integer):TSubTextFormatting;
     function GetFormatting(si:TScriptItem):TSubTextFormatting;
     function IfNotDefaultScriptItemValue(Value:TScriptItemValues; si:TScriptItem):boolean;
     function GetTagValue(TagString, Value:string):string;
     procedure AddSimple(Time,Length:longint; Line:string);

     function GetStrAfterLast(FName:string;Last:char):string;
     function GetTagInfoAfter(Str1, TagName1:string; StrtPos:integer; Nested: boolean = TRUE):THTMLTagInfo;
//     function TimeMSToStr(Time, OutType:integer):string;
    function TimeMSToStr(Time:longint; OutType:integer=0; Delimeter:char=','):string;

//     procedure SaveAs(FileName:string;SubtitleType:TSubType);
     procedure SaveAs(FileName:string;SubtitleType:TSubType; ClassNum:integer = -1);
     procedure LoadSMI(FileName:string); // Загрузка  из SMI
     procedure LoadAdvancedSMI(FileName:string);
     procedure SaveSMI(FileName:string; SaveClassNum: integer = -1); // Сохранение в SMI
     procedure SaveSAMI(FileName:string; SaveClassNum: integer = -1); // Сохранение в SMI
//     procedure LoadSSA(FileName:string); // Загрузка  из SSA
     procedure LoadJS(FileName:string);  // Загрузка  из JS
     procedure SaveFSB(FileName:string; SaveClassNum: integer = -1);
     procedure SaveMinimalFSB(FileName:string; SaveClassNum: integer = -1);
     procedure SaveSRT(FileName:string; SaveClassNum: integer = -1);
     procedure SaveSSA(FileName:string; SaveClassNum: integer = -1);
     procedure SaveRT(FileName:string; SaveClassNum: integer = -1);
     procedure SaveS2K(FileName:string; SaveClassNum: integer = -1; SaveMode: integer = 1);
//     procedure LoadFSB(FileName:string);
     procedure CheckScript; // проверка приведения скрипта к внутреннему формату
     procedure LinkScript; // обновление внутриклассовых связей между ScriptItems
     function TextAttrToFontTag(Attr, DiscardAttr:TTextAttributes):string;
     function ColorToHexStr(Color:TColor):string;
     function FontCharsetToString(Charset:TFontCharset):string;
     function ColorStrToInt(Color:string):integer;
     procedure{function} FontTagToTextAttr(FontTag:string;var Base:TRichEdit);{:TTextAttributes;}
     function GetPlainPos(Line:string; LinePos:integer):integer;
     function GetPlainText(Line:string):string;
     function GetPlainLines(Line:string):string;
     function GetStrBetween(SubStr1, Substr2, Str:string; StartPos:integer):string;

     procedure ParseSSA(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
     procedure ParseFSB(res:TStringList);
     procedure ParseSRT(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
     procedure ParseJS(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
//     procedure ParseSMI(Sl1:TStringList; FileDateTime:TDateTime);
     procedure ParseTXT(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
     function CheckTXTTimedLine(Str:string; var si:TScriptItem):boolean;
     procedure ParseSAMI(Sl1:TStringList; FileDateTime:TDateTime);
     procedure ParseRT(Sl1:TStringList; ClassID:string; FileDateTime:TDateTime);
     procedure ParseZEG(SL1:TStringList; ClassID:string; FileDateTime:TDateTime);
     function GetFileType(FileName:string):TSubType;

     function ParseFSBScriptItemHeader(str:string; var si:TScriptItem):boolean;
     function StrToTimeMS(Str:string;ErrorRes:longint=-1; LineNumber: longint=-1):longint;
     procedure SSAOneStrToTimeCode(s:string;var si:TScriptItem);
     procedure SSAOneStringToScriptItem(Str:string; var si:TScriptItem);
     procedure GetSSAGroupFormat(FormatString:string);

     function MakeOneSRTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;
     function MakeOneSRTTimeText(StartTime, EndTime:longint; Str:string):string;
     function MakeLocalSRTSubtitle(si:TScriptItem; Num:integer = -1):string;
     function MakeOneExtendedSRTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;

     //SRT subtitle without any tags removed
     function MakeExtendedSRTSubtitle(si:TScriptItem; Num:integer = -1):string;

     function MakeOneSAMISubtitle(ClassNum:integer; StartTime:longint; Str:string):string;
     function MakeOneTXTSubtitle(Num,StartTime, EndTime:longint; Str:string):string;
     function MakeOneRTSubtitleS(StartTime:longint; Str:string):string;  //start only
     function MakeOneRTSubtitleSE(StartTime, EndTime:longint; Str:string):string; //start-end
     function SAMIHeaderForClassToStr(ClassNum:integer; FileName:String):string;
//     function MakeOneRTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;

     function SSATextToSAMIText(Str:string):string;
     procedure JSOneStringToScriptItem(Str:string; var si:TScriptItem);
     function FormattingToSSAStyle(Name:string;Fm:TSubTextFormatting):string;

     procedure ShiftTime(Shift:longint; ClassNum: integer = -1; OnlySelected: boolean = false);

     function NindexOf(List:TStringList; SubStr:string; CaseMatter:boolean):integer;
     function NextIndexOf(List:TStringList; SubStr:string; Start:integer; CaseMatter:boolean):integer;
//     function NextPos(SubStr:string;S:string; from:integer):integer;
//     function NextPos2(SubStr:string;S:string; from:integer):integer;

//     function ScriptItemToFSBStrs(IncludeWithStatus:TScriptItemStatusSet; Saved: TScriptItemSaved; si:TScriptItem):TStrings;
     procedure ScriptItemToFSBStrs(IncludeWithStatus:TScriptItemStatusSet;
                                   Saved: TScriptItemSaved; si:TScriptItem;
                                   var Strs:TStringList);
     function ScriptItemToSSADialogue(si:TScriptItem):string;                               
     function SAMIFormattingToStr(Formatting:TSubTextFormatting):string;
     function StrToSAMIFormatting(Str:string):TSubTextFormatting;
     function ClassesSetToIDStr(ClassesSet:TClassesSet):string;
     function IDStrToClassesSet(Str:string):TClassesSet;

     function IsWithin(Time, Start, Length:longint):boolean;
     function GetOverlap(Start1, Length1, Start2, Length2:longint):longint;

     function SaveCurrentSMI:boolean;
     function SaveCurrent:boolean;       // Сохраняет текущий скрипт в FSB
     function GetLinesSMI(SaveClassNum: integer = -1):TStringList;   // "Сохранение" SMI в TStringList
//     procedure SetTextStyle(font:TFont); // параметры для сохранения *.SMI
     procedure AddList(List:TList);           // Объединение списков

     function GetTextAtTime(Time:longint):string; // По времени возвращает строку текста
     function GetPlainTextAtTime(Time:longint):string; // По времени возвращает строку текста без форматирования
     function GetIdxAtTime(Time:longint;Num:integer=1):integer; // По времени индекс в Items[]
     function GetNextAtTime(Time:longint):integer; // Время когда "Выключится" видимый в данный момент субтитр
     function GetNextAtIndex(index:integer):integer;// Длина в Items[Index]
     function GetTextAtIndex(index:integer):string; // Текст в Items[Index]
     function GetPlainTextAtIndex(Index:integer):string; // Текст в Items[Index] без форматирования
     function GetTextFlagAtTime(Time:longint):TScriptTextFlagSet; // возвращает текстовый флаг.
     function IsValidIndex(Index:integer):boolean;

     function CountItems(Classes:TClassesSet;
                         Statuses:TScriptItemStatusSet;
                         StartTime:longint):integer; //returns number of specified items

     procedure ActivateSUBByUID(UID:integer);  // делает активным субтитр с данным UID

     procedure SetTextFlagAtTime(f:TScriptTextFlagSet; Time:longint); //

     procedure Add1(Time:longint; text:string);     // добавляет в Саб что-то куда-то...
     procedure Replace1(Time:longint; text:string);     // добавляет в Саб что-то куда-то...
     Function GetFirstClass:integer;                // возвращает номер первого существующего класса (то есть 1, если есть, и 0, если нет)
//     procedure GetSimpleClassesIDList(var Items :TStrings);   // возвращает список классID

//     function CreateListOf:TStringList;

     procedure UpdateTextFromList(Data:TStrings);   // Обновление текста из внешнего списка.
     procedure UpdateTimeFromList(Data:TStrings);   // Обновление стартов из внешнего списка.
     procedure TimeTextUpdate(TimeList:TStrings; TextList:TStrings; ClasList:TStrings; ActrList:TStrings);
     procedure MoveBy(dir:integer);               // сдвигает время начала для каждой строки на dir (+/-)
     procedure MoveClassBy(dir, ClassNum:integer);                // сдвигает время начала для каждой строки на dir (+/-)

     function GetNearestTime(Time:longint):integer;// возвращает ближайшее время скрипта для данного.
     function GetLastTime:longint; //возвращает время последней строки скрипта

     function GetGroupName(GroupNum:integer):string;
     function GetActorName(ActorNum:integer):string;
     function GetActorClasses(ActorNum:integer):TClassesSet; // in which classes this actor exists

     function GetClassName(ClassNum:integer):string;
     function GetClassID(ClassNum:integer):string;

     function GetScriptItemByUID(UID:integer):TScriptItem;
     procedure SetScriptItemByUID(UID:integer; si:TScriptItem);

     function GetScriptItemByTime(Time:longint;ClassNum:integer; AllowInvisible:boolean = false):TScriptItem;
     procedure CheckOneScriptItem(var si:TScriptItem);

     procedure AddScriptItemPtr(si:pointer);
     function ScriptItemDifferenceToLog(si1, si2:TScriptItem; ActionStr: string):boolean;
//     procedure ScriptItemDifferenceToLog(si1, si2:TScriptItem);

     function GetTimeAtIndex(index:integer):longint;// Время в Items[Index]
     procedure SetTimeAtIndex(index:integer; Time:Longint);

     function GetEndTimeAtIndex(index:integer):longint;// Конец в Items[Index]
     procedure SetEndTimeAtIndex(index:integer; EndTime:Longint);

     function GetLengthAtIndex(index:integer):longint;// Конец в Items[Index]
     procedure SetLengthAtIndex(index:integer; Length:Longint);

     function GetScriptItemAtIndex(index:integer):TScriptItem;
     procedure SetScriptItemAtIndex(index:integer; ScriptItem:TScriptItem);

     function IsTimed(si:TScriptItem):boolean;

     procedure LinearTimeTransform(StartTime1, EndTime1, StartTime2, EndTime2:longint; OnlyBetween: boolean = false);
     procedure SelectAll;
     procedure DeleteAndFreeSelected;

     property StartTime[Index:integer]:longint read GetTimeAtIndex write SetTimeAtIndex;
     property EndTime[Index:integer]:longint read GetEndTimeAtIndex write SetEndTimeAtIndex;
     property LengthTime[Index:integer]:longint read GetLengthAtIndex write SetLengthAtIndex;
     property _SI[Index:integer]:TScriptItem read GetScriptItemAtIndex write SetScriptItemAtIndex;


protected
     procedure ExtractClasses;
     procedure reUIDScript;
     function GetSavedByLevel(Level:integer):TScriptItemSaved;
     procedure UpdateActorsList;
     procedure UpdateGroupsList;
     procedure UpdateClassesList;

     procedure NotifyError(ErrorString:string);
     procedure NotifyWarning(WarningString:string);

  end;


var
  MainScript:TScript;
//  UPClass:string;
//  p:integer;

implementation


//uses ScriptSelection, Options, TextSourceViewU;
///
///  Для сортировки по возрастанию Time
///  используется строка
///  Sort(SortFuncTime);
///

function SortFuncTime(Item1, Item2: Pointer): Integer;
var
s1, s2:^TScriptItem;
begin
//
  s1 := Item1;
  s2 := Item2;
  Result:= (s1.Time - s2.Time);
  if Result=0 then  Result:=s1.UID-s2.UID;

end;


procedure TScript.AddScriptItemPtr(si:pointer);
begin
 if (si<>nil) then
 begin
 if TScriptItem(si^).ClassNum=0 then
 begin
  if ClassesCount>0 then TScriptItem(si^).ClassNum:=ClassesCount
  else TScriptItem(si^).ClassNum:=CheckClassID(GetNewClassID);
 end;
 if TScriptItem(si^).UID=-1 then TScriptItem(si^).UID:=GetNewUID;
 TScriptItem(si^).Line:=StringReplace(TScriptItem(si^).Line,#9,'',[rfReplaceAll]);
{ if (TScriptItem(si^).Time=-1) then TScriptItem(si^).Timed:=false
                               else TScriptItem(si^).Timed:=true;}
{$ifndef NO_FANSUBBER}
 if TScriptItem(si^).FINDER=nil then TScriptItem(si^).FINDER:=TScriptItemFinder.Create(TScriptItem(si^).UID, Count);
{$endif}
 Add(si);
 end;
end;

function TScript.GetStrAfterLast(FName:string;Last:char):string;
var i,j:integer;
begin
    i:=pos(Last,FName);
  repeat
   j:=pos(Last,copy(FName, i+1, Length(FName)-i));
   if j<>0 then i:=i+j;
  until j=0;
  //now i is position of the last dot - after dot there is an extension
  Result:=LowerCase(copy(FName, i+1, Length(FName)-i));
end;


function TScript.GetFormattingForUID(UID:integer):TSubTextFormatting;
var i:integer;
begin
Result:=Classes[0].Formatting^; //for NoScriptItem
if not(UID=-1) then
 for i:=0 to Count-1 do
  if (TScriptItem(Items[i]^).UID=UID) then
  begin
   Result:=GetFormatting(TScriptItem(Items[i]^));
   break;
  end;
end;

function TScript.GetFormatting(si:TScriptItem):TSubTextFormatting;
var i:integer;
begin
Result:=Classes[0].Formatting^; //for NoScriptItem
if not(si.UID=-1) then
 if not(si.Formatting=nil)
  then Result:=si.Formatting^
   else if not(Groups[si.GroupNum].Formatting=nil)
    then Result:=Groups[si.GroupNum].Formatting^
     else if not(Classes[si.ClassNum].Formatting=nil)
      then Result:=Classes[si.ClassNum].Formatting^
       else Result:=Classes[0].Formatting^; //default project formatting
end;

function TScript.GetScriptItemValueName(Value:TScriptItemValues):string;
begin
 Result:='';
 if Value<SI_None then Result:=ScriptItemValueNames[Value];
end;

function TScript.GetScriptItemValueFromName(Name:string):TScriptItemValues;
var i:TScriptItemValues;
begin
 Result:=SI_None;
 if (Uppercase(Name)='TEXT') then Result:=SI_Line;
 if (Uppercase(Name)='LINE') then Result:=SI_Line;
 if (Uppercase(Name)='LEN') then Result:=SI_Length;
 if (Uppercase(Name)='COMM') then Result:=SI_Comment;
 for i:=SI_Min to SI_Max do
  if Name=ScriptItemValueNames[i] then Result:=i;
 if Result=SI_None then
  for i:=SI_Min to SI_Max do
   if UpperCase(copy(Name, 1, 3))=UpperCase(copy(ScriptItemValueNames[i], 1, 3)) then
   begin
    Result:=i;
    break;
   end;

end;


function TScript.GetScriptItemValueStr(Value:TScriptItemValues; si:TScriptItem):string;
var i:integer;
begin
 Result:='';
 with si do
 case Value of
   SI_Time: Result:=IntToStr(Time);
   SI_UID: Result:=IntToStr(UID);
   SI_Length: Result:=IntToStr(Length);
   SI_Line: Result:=Line;
   SI_Class: Result:=Classes[ClassNum].ID;
   SI_Actor: Result:=Actors[ActorNum].Name;
   SI_TextFlag: begin
                Result:='';
                if (variant in TextFlag) then Result:=Result+'#variant';
                if (wrong in TextFlag) then Result:=Result+'#wrong';
                end;
   SI_Comment: Result:=Comment;
   SI_Status:  case Status of
                _Text:Result:='Text';
                _Derived:Result:='D-Text';
                _Clear:Result:='Clear';
                _Action:Result:='Action';
                _Other:Result:='Other';
//                default: Result:='N/A (?)';
                end;
   SI_Group: Result:=Groups[GroupNum].Name;
   SI_Formatting: if Formatting=nil then
                  begin
                    if not(Groups[GroupNum].Formatting=nil) then Result:='Group'
                    else if not(Classes[ClassNum].Formatting=nil)
                     then Result:='Class'
                      else Result:='Project' //default project formatting
          //we should give here either 'Group','Class' or 'Project" formatting is used
                  end
                  else Result:=SAMIFormattingToStr(Formatting^); //specific script item formatting
   SI_Edition: Result:=IntToStr(Edition);
   SI_LastChange: Result:=TimeToStr(LastChange)+' '+DateToStr(LastChange);
   SI_ElementNum: Result:=IntToStr(ElementNum);
   SI_NumericData: for i:=0 to MaxNumericData do Result:=Result+'#'+IntToStr(NumericData[i]); // possible
   SI_Generated: if (Generated) then Result:='Y' else Result:='N';
   SI_Selected: if (Selected) then Result:='Y' else Result:='N';
   SI_Locked: if (Locked) then Result:='Y' else Result:='N';
   SI_Invisible: if (Invisible) then Result:='Y' else Result:='N';
   SI_Overlapping: if (Overlapping) then Result:='Y' else Result:='N';
   //, SI_None);
 end;

end;


function TScript.SetScriptItemValue(Value:TScriptItemValues; Str:string; var si:TScriptItem):boolean;
var si_saved:TScriptItem; i,j,k,l:integer;
    log_strs:TStringList;
    siv:TScriptItemValues;
    s1,s2:string;
begin
if not(si.Locked and (Value<>SI_Locked)) then
begin
si_saved:=si;
Result:=true;
l:=Length(Str);
try
 with si do
 case Value of
   SI_Time: begin
              Time:=StrToTimeMS(Str);
            end;
   SI_UID: UID:=StrToInt(Str);
   SI_Length: Length:=StrToTimeMS(Str);
   SI_Line: Line:=Str;
   SI_Class: begin
                ClassNum:=GetClassNByID(Str);
                if (ClassNum=-1) then ClassNum:=CheckClassID(Str);
             end;
   SI_Actor: ActorNum:=CheckActorName(Str);
   SI_TextFlag:begin
                if (Pos('#variant',Str)<>0) then TextFlag:=TextFlag+[variant];
                if (Pos('#wrong',Str)<>0) then TextFlag:=TextFlag+[wrong];
               end;
   SI_Comment: Comment:=Str;
   SI_Status:
        begin
          i:=ScriptItemStatusList.IndexOf(Str);
          if i<>-1 then si.Status:=TScriptItemStatus(i) else Result:=false;
         end;
   SI_Group: GroupNum:=GetGroupNumByName(Str);
   SI_Formatting: begin
                   if (Str='Group') or (Str='Class') or (Str='Project') then
                   begin
                      if (Formatting<>nil) then Dispose(Formatting);
                   end
                   else
                   begin
//                    if (Formatting=nil) then New(Formatting);
//                    Formatting^:=StrToSAMIFormatting(Str);
                   end;
                  end;
   SI_Edition: Edition:=StrToInt(Str);
   SI_LastChange: LastChange:=StrToDate(copy(Str, pos(' ', Str), pos(' ', Str)+15))
                                +StrToTime(copy(Str, 1, pos(' ', Str)));
   SI_ElementNum: ElementNum:=StrToInt(Str);
   SI_Generated: If (Str='Y') then Generated:=true else Generated:=false;
   SI_Selected: If (Str='Y') then Selected:=true else Selected:=false;
   SI_Locked: If (Str='Y') then Locked:=true else Locked:=false;
   SI_Invisible: If (Str='Y') then Invisible:=true else Invisible:=false;
   SI_Overlapping: If (Str='Y') then Overlapping:=true else Overlapping:=false;
   SI_NumericData:
    begin
      k:=0;
      i:=Pos('#', Str);
      j:=i + Pos('#', Copy(Str, i+1, l ) );
       if j=i then j:=l+1; //last item
      repeat
       NumericData[k]:=StrToInt(Copy(Str, i+1, j-i-1));
       i:=j;
       j:=i+Pos('#', Copy(Str, i+1, l));
       if j=i then j:=l+1; //last item
       inc(k);
      until (k>MaxNumericData) or (i=j);
      //Result:='N/A (yet)'; // possible
    end;
   //, SI_None);
 end;
except
 on EConvertError do
 begin
  Result:=false;
  NotifyError('Failed to Set Value ('+GetScriptItemValueName(Value)+
              ')="'+Str+'" for ScriptItem (UID:'+IntToStr(si.UID)+', Class:'+
              GetClassID(si.ClassNum)+');');
 end;

end;

if not(Result) then si:=si_saved
else
if ScriptItemDifferenceToLog(si_saved, si, 'ИЗМЕНЕН') then
begin
// si.Edition:=si.Edition+1;
{$ifndef NO_FANSUBBER}
 TScriptItem(Items[si.Finder.Idx]^):=si;
{$endif}

//! MainForm.NotifySingleScriptItem(si.FINDER);
// si_old:=MainScript.GetScriptItemByUID(si.UID);
// if si.FINDER<>nil then si_old:=TScriptItem(MainScript.Items[si.FINDER.Idx]^);
end;
//  MainScript.SetScriptItemByUID(si.UID, si);
end;

end;



function TScript.CountItems(Classes:TClassesSet;
                    Statuses:TScriptItemStatusSet;
                    StartTime:longint):integer; //returns number of specified items
var i:integer; si:^TScriptItem;
begin
Result:=0;
 for i:=0 to Count-1 do
 begin
  si:=Items[i];
  if ((si^.ClassNum in Classes) and (si^.Status in Statuses))
     and not(si^.Time<StartTime) then inc(Result);
 end;
end;


function TScript.ClassesSetToIDStr(ClassesSet:TClassesSet):string;
var i:TClassesNumSet;
begin
 Result:='';
 for i:=1 to ClassesCount do
  if (i in ClassesSet) then Result:=Result+Classes[i].ID+' ';
 if (0 in ClassesSet) then Result:=Result+'Current';
end;

function TScript.IDStrToClassesSet(Str:string):TClassesSet;
var i:byte;
begin
 Result:=[];
 for i:=1 to ClassesCount do
  if pos(Classes[i].ID+' ', Str)<>0 then Result:=Result+[i];
 if pos('Current',Str)<>0 then Result:=Result+[0];
end;



function TScript.GetNewUID:integer;
begin
 inc(MaxUID);
 if (MaxUID<>-1) then Result:=MaxUID
 else Result:=0;// here we should find first empty block of UIDs... but i don't think UIDs can come to such numbers
end;


function TScript.GetNewClassID:string;
var i,j,k:integer;
begin
 if (ClassesCount < MaxClasses) then
 begin
  j:=0;
  for k:=1 to ClassesCount do
  for i:=1 to ClassesCount do
  if (Classes[i].ID='CC'+IntToStr(j)) then inc(j);
  Result:='CC'+IntToStr(j);
//  CheckClassID(Result); //we can automatically add class, but now this is disabled
 end
 else
 begin
  Result:=Classes[1].ID; //if no more classes can be created, they are added to FIRST class... but this is non-advisable
  //CHANGE!
//  MessageBox('New Class cannot be added - Classes limit reached! Please Select Existing Class Handle to continue');
//  Result:=Classes[ExistingClassSelector].ID;
 end;
end;

function TScript.GetGroupName(GroupNum:integer):string;
begin
if (GroupNum<GroupsCount) then Result:=Groups[GroupNum].Name
   else Result:='Default';//Groups[0].Name; //MAIN group
end;

function TScript.GetActorName(ActorNum:integer):string;
begin
if not(ActorNum>ActorsCount) then Result:=Actors[ActorNum].Name
   else Result:=DefaultActorName;
end;

function TScript.GetActorNum(Name:string):integer;
var i:integer;
begin
Result:=0;
for i:=0 to ActorsCount do if (Actors[i].Name=Name) then Result:=i;
end;

function TScript.GetGroupNumByName(Name:string):integer;
var i:integer;
begin
Result:=0;
 for i:=0 to GroupsCount do if (Groups[i].Name=Name) then Result:=i;
end;


function TScript.GetActorClasses(ActorNum:integer):TClassesSet; // in which classes this actor exists
begin
 if not(ActorNum>ActorsCount) then Result:=Actors[ActorNum].Classes
 else Result:=[]; //empty
end;

function TScript.GetClassName(ClassNum:integer):string;
begin
 if not(ClassNum>ClassesCount) then Result:=Classes[ClassNum].Name
 else Result:=Classes[0].Name;
end;

function TScript.GetClassID(ClassNum:integer):string;
begin
 if not(ClassNum>ClassesCount) then Result:=Classes[ClassNum].ID
 else Result:=Classes[0].ID;
end;


procedure TScript.UpdateActorsList;
var i:integer;
begin
  //updating ActorsList
 ActorsList.Clear;
 for i:=0 to ActorsCount do ActorsList.Add(Actors[i].Name);
end;
procedure TScript.UpdateGroupsList;
var i:integer;
begin
 //updating GroupsList
 GroupsList.Clear;
 for i:=0 to GroupsCount do GroupsList.Add(Groups[i].Name);
end;
procedure TScript.UpdateClassesList;
var i:integer;
begin
 //updating ClassesList
 ClassesList.Clear;
 for i:=0 to ClassesCount do ClassesList.Add(Classes[i].ID);
end;

procedure TScript.LinkScript; // обновление внутриклассовых связей между ScriptItems
var i,j:integer; FindFirst:boolean; prev_si, si:^TScriptItem;
begin
{$ifndef NO_FANSUBBER}
for j:=1 to ClassesCount do //here we expect that Items is sorted by time from lowest to highest, with Length<>-1 (either gotten from script or created by checker)
 begin
 FindFirst:=false;
 for i:=0 to Count-1 do
   if (TScriptItem(Items[i]^).ClassNum=j) then
    if not(FindFirst) then
    begin
     prev_si:=Items[i];
//     prev_si.ClassLinked.Prev:=nil;
     prev_si^.FINDER.Prev:=nil;
     Classes[j].FirstScriptItem:=prev_si^.FINDER;
     FindFirst:=true;
    end
     else
    begin
     si:=Items[i];
//     si^.ClassLinked.Prev:=prev_si;
//     prev_si^.ClassLinked.Next:=si;
     si^.FINDER.Prev:=prev_si^.FINDER;
     prev_si^.FINDER.Next:=si^.FINDER;
     prev_si:=Items[i];
    end;
// if si<>nil then si.ClassLinked.Next:=nil;
 if si<>nil then if si.FINDER<>nil then si.FINDER.Next:=nil;
 Classes[j].LastScriptItem:=si.FINDER;
 end;
{$endif}
end;


procedure TScript.CheckScript;
var i,j, k, OldCount:integer;prev_si, si, si_add:^TScriptItem; FindFirst:boolean;
begin


if Count>0 then
begin
 Capacity:=Count*2;

for i:=0 to Count-1 do //setting highest UID
 if (TScriptItem(Items[i]^).UID > MaxUID) then MaxUID:=TScriptItem(Items[i]^).UID;

for i:=0 to Count-1 do
 begin
 if (TScriptItem(Items[i]^).UID=-1) then TScriptItem(Items[i]^).UID:=GetNewUID;
 if (TScriptItem(Items[i]^).Line=TextIsClearStr) then TScriptItem(Items[i]^).Status:=_Clear;
{$ifndef NO_FANSUBBER}
 if (TScriptItem(Items[i]^).FINDER=nil) then TScriptItem(Items[i]^).FINDER:=TScriptItemFinder.Create(TScriptItem(Items[i]^).UID);
{$endif}

 end;

FirstTimedItem:=Count;

Sort(SortFuncTime);

OldCount:=Count;

for j:=1 to ClassesCount do
begin
 i:=0;
 while (i<Count) do
 begin
  if TScriptItem(Items[i]^).ClassNum=j then
  if TScriptItem(Items[i]^).Time>-1 then
  begin
  if TScriptItem(Items[i]^).Time=0 then
  begin
   if (i<FirstTimedItem) then FirstTimedItem:=i;
   i:=Count;
  end
  else
  begin
{    //creating 0-time clear
    new(si_add);
    si_add^:=TScriptItem(Items[i]^);
    si_add^.Line:=TextIsClearStr;
    si_add^.Status:=_Clear;
    si_add^.Comment:='[SCGF]';//'ScriptChecker Gap filler';
    si_add^.Length:=si_add^.Time-1;
    si_add^.Time:=0;
    si_add^.Generated:=true;
    si_add^.UID:=GetNewUID;}
{$ifndef NO_FANSUBBER}
{    si_add^.FINDER:=TScriptItemFinder.Create(si_add^.UID);}
{$endif}
{    AddScriptItemPtr(si_add);}
    FirstTimedItem:=i;
    i:=Count; //breaking while
  end;
  end;
  inc(i);
 end;
end;

if not(OldCount=Count) then Sort(SortFuncTime);

prev_si:=Items[0];

// setting length
for j:=1 to ClassesCount do //here we expect that Items is sorted by time from lowest to highest, some with Length=-1 (not defined yet)
 for i:=0 to Count-1 do
  if (TScriptItem(Items[i]^).ClassNum=j) and
  ((TScriptItem(Items[i]^).Time>-1) and (TScriptItem(Items[i]^).Length<0))
   then
  begin
    prev_si:=Items[i];
    k:=i+1;
    while (k<Count) and (prev_si^.Length<0) do
    begin
     si:=Items[k];
     if (si^.ClassNum=j) and (si^.Time>prev_si^.Time)
     then prev_si^.Length:=si^.Time-prev_si^.Time{-1};
     inc(k);
    end;
    if (k>Count) then prev_si.Length:=MaxUnfilledGap;
  end; //end if

OldCount:=Count;

//creating clears
{
for j:=1 to ClassesCount do //here we expect that Items is sorted by time from lowest to highest, with Length<>-1 (either gotten from script or created by checker)
 begin //here we add "clear" items into script when needed
 FindFirst:=false;
 for i:=0 to OldCount-1 do
  if ((TScriptItem(Items[i]^).ClassNum=j) and (TScriptItem(Items[i]^).Time>-1))
  and ((TScriptItem(Items[i]^).Status=_Text) or (TScriptItem(Items[i]^).Status=_Clear))
  then
  begin
   if not(FindFirst) then
   begin
    prev_si:=Items[i];
    FindFirst:=true;
   end
   else
   begin
    si:=Items[i];
    if (si^.Status=_Text) or (si^.Status=_Clear) then
    begin
    if (si^.Time-(prev_si^.Time+prev_si^.Length))>MaxUnfilledGap then //Gap in ms
     begin
       new(si_add);
       si_add^:=prev_si^;
       si_add^.Line:=TextIsClearStr;
       si_add^.Status:=_Clear;
       si_add^.Comment:='[SCGF]';//'ScriptChecker Gap filler';
       si_add^.Time:=prev_si^.Time+prev_si^.Length;
       si_add^.Length:=si^.Time-si_add^.Time;
       si_add^.Generated:=true;
       si_add^.UID:=GetNewUID;}
{$ifndef NO_FANSUBBER}
{       si_add^.FINDER:=TScriptItemFinder.Create(si_add^.UID);}
{$endif}
{       AddScriptItemPtr(si_add);
     end;
    prev_si:=si;
    end;
    end;
   end;
 end;
}
{ i:=0;
 while (i<Count) do
 begin
  si:=Items[i];
  if not(si^.Locked) then
  if (si.Status=_Clear) and (si.Length<MaxUnfilledGap) then
  begin
   if si^.FINDER<>nil then si^.FINDER.Free;
   Delete(i);
  end
  else inc(i);
 end;}

 Sort(SortFuncTime);
 si:=Items[Count-1];

{ if not(si^.Generated) and not(si^.Status=_Clear)then
 begin
  new(si_add);
  si_add^:=prev_si^;
  si_add^.UID:=GetNewUID;
  si_add^.Line:=TextIsClear;
  si_add^.Status:=_Clear;
  si_add^.Comment:='[SCGF] Final clear';//'ScriptChecker Gap filler';
  si_add^.Time:=prev_si^.Time+prev_si^.Length+MaxUnfilledGap;
  si_add^.Length:=si^.Time-si_add^.Time;
  if (si_add^.Length<=0) then si_add^.Length:=MaxUnfilledGap;
  si_add^.Generated:=true;
  si_add^.FINDER:=TScriptItemFinder.Create(si_add^.UID);
  AddScriptItemPtr(si_add);
 end;}


 for i:=0 to Count-1 do
  if TScriptItem(Items[i]^).Time>-1 then
  begin
   FirstTimedItem:=i;
   break;
  end;

  if TScriptItem(Items[Count-1]^).Length<0 then
   TScriptItem(Items[Count-1]^).Length:=Max(500, Length(GetPlainText(TScriptItem(Items[Count-1]^).Line))*50); 

  UpdateInternalIndex;

  LinkScript;

  CheckOverlapping;

  UpdateActorsList;
  UpdateGroupsList;
  UpdateClassesList;

//!  MainForm.UpdateEvent([ScriptChange],0); //MainScript uses Main handle for updates
end;
end;

{procedure TScript.GetSimpleClassesIDList(var Items:TStrings);   // возвращает список классID
var i:integer;
begin
Items.Clear;
for i:=1 to ClassesCount do Items.Add(Classes[i].ID);
end;}

procedure TScript.UpdateInternalIndex;
var i:integer; SelCnt:integer;
begin
 SelCnt:=0;
 for i:=0 to Count-1 do
  begin
    TScriptItem(Items[i]^).InternalIndex:=i;
{$ifndef NO_FANSUBBER}
    if (TScriptItem(Items[i]^).FINDER<>nil) then
    TScriptItem(Items[i]^).FINDER.InternalIndex:=i;
{$endif}
    if TScriptItem(Items[i]^).Selected then inc(SelCnt);
  end;
//! ScriptSelector.SelectionCtr:=SelCnt;
//! ScriptSelector.SelUpdate;
end;

function TScript.GetClassNByID(ID:string):integer;
var i:integer;
begin
 Result:=-1;
 for i:=1 to ClassesCount do
  if (Classes[i].ID=ID) then
    Result:=i;
end;

function TScript.GetActorByName(Name:string):integer;
var i:integer;
begin
 Result:=0;
 for i:=1 to ActorsCount do
  if (Actors[i].Name=Name) then
    Result:=i;
end;


function TScript.CheckClassID(ID:string):integer;
{this procedure checks if specified ClassID already exist,
 and, if so, returns pointer to "registered" ClassID string;
 if specified ClassID is not registered, then new class is
 created is Classes array and pointer to that ClassID is returned}
 var i:integer;
begin
 Result:=-1;
 for i:=0 to ClassesCount do
  if (Classes[i].ID=ID) then
   begin
    Result:=i;
   end;
 if (Result=-1) then
  begin
   //creating new Script Classes instance
   inc(ClassesCount);
   Classes[ClassesCount].ID:=ID;
   Classes[ClassesCount].Name:=ID+'_'+IntToStr(ClassesCount);
   Classes[ClassesCount].Language:=0; // default language
   Classes[ClassesCount].samiType:='CC';
   if not(Classes[ClassesCount].Formatting=nil) then
   FreeMem(Classes[ClassesCount].Formatting); //class existed but wasn't properly deleted
   Result:=ClassesCount;
   UpdateClassesList;
//!   MainForm.UpdateEvent([ClassAdded], 0);
  end;
end;

function TScript.CheckActorName(Name:string):integer;
{this procedure checks if specified Actor Name already exist,
 and, if so, returns pointer to "registered" Actor Name string;
 if specified Actor Name is not registered, then new class is
 created is Actors array and pointer to that Actor Name is returned}
 var i:integer;
begin
 Result:=-1;
 for i:=0 to ActorsCount do
  if (Actors[i].Name=Name) then
   begin
    Result:=i;
   end;
 if (Result=-1) then
  begin
   //creating new Actor instance
   inc(ActorsCount);
   Actors[ActorsCount].Name:=Name;
   Actors[ActorsCount].Classes:=[0..MaxClasses];
   Actors[ActorsCount].Chained:=ActorsCount;
   Result:=ActorsCount;
   UpdateActorsList;
//!   MainForm.UpdateEvent([ActorAdded], 0);
  end;
end;

function TScript.CheckGroupName(Name:string):integer;
 var i:integer;
begin
 Result:=-1;
 for i:=0 to GroupsCount do
  if (Groups[i].Name=Name) then
   begin
    Result:=i;
   end;
 if (Result=-1) then
  begin
   //creating new Group instance
   inc(GroupsCount);
    Groups[GroupsCount].Name:=Name;
    Groups[GroupsCount].Classes:=[0..MaxClasses];
    try
    if not(Groups[GroupsCount].Formatting=nil) then
     FreeMem(Groups[GroupsCount].Formatting);
    except
     Groups[GroupsCount].Formatting:=nil;
    end;
   Result:=GroupsCount;
   UpdateGroupsList;
//!   MainForm.UpdateEvent([GroupAdded],0);
  end;

end;

procedure TScript.ExtractClasses;
{var
i,j:integer;
s:string;
flag:boolean;}
begin
{  for i:=0 to Count-1 do
  begin
    CheckClassID(TScriptItem(Items[i]^).ClassID));
  end;}
{  s :='Classes :';
  for i:=1 to ClassesCount do
    s := s + #13#10 + Classes[i].ID;
  ShowMessage(s);}
end;

function TScript.GetScriptItemByTime(Time:longint;ClassNum:integer; AllowInvisible:boolean = false):TScriptItem;
var i:integer; si:^TScriptItem;
begin
 Result:=ClearScriptItem;
 Result.ClassNum:=ClassNum;
 Result.Time:=Time;
 Result.Length:=MaxUnfilledGap;
// i:=Count;
// while not(i=0) do
 for i:=FirstTimedItem to Count-1 do
 begin
  si:=Items[i];
  if (si^.ClassNum=ClassNum) then
  if (((si^.Time<Time) and (si^.Time+si^.Length>Time))
     or(si^.Time=Time)) then
   if not(si^.Invisible) or (AllowInvisible) then
   begin
    Result:=si^;
    if (si^.Time=Time) then break;
   end;
 end;
end;


constructor TScript.Create;
var i:integer; st:TScriptItemStatus;
begin

  MaxUID:=0;
  LineBreakStr := '<BR>';
  fName := '';
//  OnlyPClass:=false;
  if Log<>nil then Log.free;
  Log := TStringList.create;
  ErrorLog := TStringList.create;

  UniteOrderForward:=true;
  UniteCrossedIfNeeded:=true;
//!  SMITextStyle := TFont.Create;

  ClassesCount:=0;
  Classes[0].ID:='Current';
  Classes[0].Name:='Project Defaults';
  Classes[0].Language:=0;
  Classes[0].samiType:='CC';
  New(Classes[0].Formatting);

   Classes[0].Formatting^.Margin[Mg_Left]:=0;
   Classes[0].Formatting^.Margin[Mg_Right]:=0;
   Classes[0].Formatting^.Margin[Mg_Top]:=0;
   Classes[0].Formatting^.Margin[Mg_Bottom]:=0;

//   Classes[0].Formatting^.MarginLeftSuffix:=px;
//   Classes[0].Formatting^.MarginRightSuffix:=px;
//   Classes[0].Formatting^.MarginTopSuffix:=px;
//   Classes[0].Formatting^.MarginBottomSuffix:=px;

//   Classes[0].Formatting^.TextColor:=clYellow;
   Classes[0].Formatting^.BGColor:=clBlack;
   Classes[0].Formatting^.VAlign:=VAl_Bottom;
   Classes[0].Formatting^.HAlign:=HAl_Center;

//   Classes[0].Formatting^.Font:=TFont.Create;
   Classes[0].Formatting^.Charset:=1; //DEFAULT_CHARSET
//   SetLength(Classes[0].Formatting^.TextColors, 1);
//   SetLength(Classes[0].Formatting^.TextColors, 3);
   Classes[0].Formatting^.TextColors[0]:=clYellow;
   Classes[0].Formatting^.TextColors[1]:=clOlive;
   Classes[0].Formatting^.TextColors[2]:=clBlue;
   Classes[0].Formatting^.TextSize:=14; //18 pt
   Classes[0].Formatting^.FontName:='MS Sans serif';
   Classes[0].Formatting^.FontStyles:=[];//fsBold, fsItalic, fsUnderline, fsStrikeOut
   Classes[0].Formatting^.SubStyles:=[];//ssKaraoke, ssPullUp

//   Classes[0].Formatting^.TextAlign.
//        TextAlign : TTextAligning;
//        FontSettings: TFont;
//        FontFamilies : string; // additional font-family names
//        TextColor: TColor; // background color (0 should be threated later as transparent)
//        BGColor : TColor; // same for background color

  ActorsCount:=0;
  Actors[0].Name:=DefaultActorName;
  Actors[0].Classes:=[0..MaxClasses];
  Actors[0].Chained:=0; //chained by self

  GroupsCount:=0;
  Groups[0].Name:=DefaultGroupName;
  Groups[0].Classes:=[1..MaxClasses];

  NoScriptItem.Time:=NoTime;
  NoScriptItem.Length:=NoTime;
  NoScriptItem.Line:='No Script Loaded or Script Error';
  NoScriptItem.ClassNum:=0;
  NoScriptItem.ActorNum:=CheckActorName(DefaultActorName);
  NoScriptItem.UID:=-1;
  NoScriptItem.textFlag :=[];
  NoScriptItem.Comment:='';
  NoScriptItem.Status:=_Clear;
  NoScriptItem.GroupNum:=0;
  NoScriptItem.Formatting:=nil;
  NoScriptItem.Edition:=0;
  NoScriptItem.LastChange:=Date+Time();
  NoScriptItem.ElementNum:=0;
  NoScriptItem.Generated:=false;
  NoScriptItem.Selected:=false;
  NoScriptItem.Locked:=false;
  NoScriptItem.Invisible:=false; //should be true, but then i should also set it false for every succesfully parsed ScriptItem... and Invisible aren't so common yet...
  NoScriptItem.Overlapping:=false; //this one is updated in CheckScript


  for i:=0 to MaxNumericData do NoScriptItem.NumericData[i]:=0;

  ClearScriptItem:=NoScriptItem;
  ClearScriptItem.Line:='';
  ClearScriptItem.Invisible:=false;


 ActorsList:=TStringList.Create;
 GroupsList:=TStringList.Create;
 ClassesList:=TStringList.Create;
 ScriptItemStatusList:=TStringList.Create;

//     TScriptItemStatus = (_Text, _Derived, _Clear, _Action, _Other);
 for st:=_Text to _Other do
 begin
  NoScriptItem.Status:=st;
  ScriptItemStatusList.Add(GetScriptItemValueStr(SI_Status, NoScriptItem));
 end;


  UpdateActorsList;
  UpdateGroupsList;
  UpdateClassesList;

 InitLanguages;
 InitCountries;
 InitScriptItemValueNames;

 HAlignNameList:=TStringList.Create;
 VAlignNameList:=TStringList.Create;
 HAlignNameList.Add('Left');
 HAlignNameList.Add('Center');
 HAlignNameList.Add('Right');
 HAlignNameList.Add('Justify');
 HAlignNameList.Add('Free');
// HAlignNameList.Add('Left'); //justify not yet supported
 VAlignNameList.Add('Bottom');
 VAlignNameList.Add('Center');
 VAlignNameList.Add('Top');
 HAlignNameList.Add('Free');

 Width:=320;
 Height:=240;
 SubWidth:=Width;
 SubHeight:=40;

end;



function TScript.NindexOf(List:TStringList; SubStr:string; CaseMatter:boolean):integer;
var i:integer;
begin
i:=0;
  result := -1;
  while (i < List.count) and (Result = -1) do
  begin
    if CaseMatter then begin
      if pos(Substr, List.strings[i]) > 0 then Result := i;
    end else
      if pos(Lowercase(Substr), Lowercase(List.strings[i])) > 0 then Result := i;
    inc(i);
  end;
end;

function TScript.NextIndexOf(List:TStringList; SubStr:string; Start:integer; CaseMatter:boolean):integer;
var i:integer;
begin
i:=Start+1;
  result := -1;
  while (i < List.count) and (Result = -1) do
  begin
    if CaseMatter then begin
      if pos(Substr, List.strings[i]) > 0 then Result := i;
    end else
      if pos(Lowercase(Substr), Lowercase(List.strings[i])) > 0 then Result := i;
    inc(i);
  end;
end;

function {TScript.}NextPos2(SubStr:string;S:string; from:integer):integer;
var
s1:string;
i,j:integer;
begin
{   s1:=copy(s, from+1, Length(s)-from);
//   s:=s1;
   i:=pos(SubStr, S1)+from;
  if (i <= from) then Result:=0//-1
  else
//  if (from>0) and (i>0) then i:=i-1;
  Result:=i;
}
  Result:=0;
  if (from<=0) then i:=1 else i:=from;
  j:=1;
  while not(i>Length(S)) and not(j>Length(SubStr)) do
  begin
   if (S[i]=SubStr[j]) then Inc(j) else j:=1;
   inc(i);
  end;
  if (j>Length(SubStr)) then Result:=i-j+1;
end;

function {TScript.}NextPos(SubStr:string;S:string; from:integer):integer;
var
s1:string;
i:integer;
begin
   s1:=copy(s, from+1, Length(s)-from);
//   s:=s1;
   i:=pos(SubStr, S1)+from;
   if (from>0) and (i>0) then i:=i-1;
  if (i <= from) then Result:=0//-1
  else Result:=i;
end;


///
///  Load SMI
///

procedure TScript.LoadAdvancedSMI(FileName:string);
var
 time, time1, {ScrLine,} i, max, p:integer;
 {text,klass, id,} s, s1 : string;
 Sl:TStringList;
 si:^TScriptItem;
 continue:boolean;

//
// тоже что и pos, но ищет не от начала, а от i-ого сисмвола
//

///
///  Поиск в заданном списке TStringsList строки содержащей
///  заданную подстроку
///  С/без различия регистра.
///


function GetNextTag(Src:string):string;
var i1,i2:integer;
begin
  if p < Length(src) then
  begin
//    fillChar(Src, p, 'x' );
    i1:=NextPos('<', Src, p); //should be checked after NextPos change
    i2:=NextPos('>', Src, i1);
    if ( i1 <> 0) and (i2 <> 0) then
      Result:=copy(Src, i1, i2-i1) //returns <tag>
    else result:='';
    p:=i2+1;
  end else Result:='';
end;


begin
 Sl:=TStringList.Create;
try
 continue:=true;
 Sl.LoadFromFile(FileName);
except
 Continue:=false;
 NotifyError('Failed to Open SAMI File "'+filename+'"');
end;
if Continue then
begin
  FName:=FileName;
  i:=0;
//  time:=0;
  time1:=0;

  new(si);
  si^:=NoScriptItem;
{
  si.Time:=0;
  si.length:=0;
  si.line:='START' ;
  si.ClassID:='DUMMY';
 }
  max:=length(sl.Text);
  p:=0;

  while (LowerCase(s) <> 'body' )and(i<max) do
  begin
    s:=GetNextTag(sl.Text);
    i:=p;
  end;

  while (LowerCase(s) <> '/body' )and(i<max) do
  begin
    s:=GetNextTag(sl.Text);

    if ((p-Length(s)-2-i) > 2) and (time1 > 0) then
    begin
      s1:=copy(sl.text, i, p-Length(s)-2-i);
      s1:=TRIM(s1);
      if s1 <> '' then si^.line:=si^.line+s1;
      if LowerCase(s) = 'br' then si.line:=si.line+'<BR>' ;
    end;// of test on new text

    if (pos('sync start=' , LowerCase(s)) > 0) then begin
      s1:=copy(s,  pos('=', s)+1, pos('ms', LowerCase(s))-pos('=', s)-1);
      if s1 = '' then s1:=copy(s,  pos('=', s)+1, Length(s)-pos('=', s));
      if s1 = '' then time:=time1 else time:=StrToInt(s1);
      if (time1 <> time) then
      begin
        if ( time1>0 ) then
        AddScriptItemPtr(si);
        new(si);
        si.Time:=time;
        time1:=time;
      end;
    end;// of SYNC Start handling;

//    if (pos('p class=' , LowerCase(s)) > 0) then
    if (pos('p' , LowerCase(s)) > 0) then
    begin
    if (pos('class=', Lowercase(s)) > 0) then
    begin
      si.ClassNum:=CheckClassID(copy(s, pos('=' , s)+1, length(s)-pos('=' , s)));//wrong, should be rewritten; assumes that class is the last property of <P> tag
      if Length(si.line) > 0 then si.line:=si.line + '<BR>' ;
    end// of P CLASS handling; should be rewritten with AddClass procedure}
    else si.ClassNum:=CheckClassID(DefaultClassID);
    end;

    i:=p;
  end;// of THIS tag processing
  Sl.Destroy;

end;// after exception
end;

procedure TScript.LoadSMI(FileName:string);
var
Sl1 :TStringList;
i, j, p, p1:integer;
s:string;
Item:^TScriptItem;
OldTime:longint;
{flag:boolean;}
begin
//
  FName:=FileName;
  Sl1 := TStringList.Create;
  Sl1.LoadFromFile(fileName);
  p := NindexOf(Sl1, 'SYNC', false);
  Oldtime := 0;
  Clear;
  Capacity:=Sl1.Count;
  // Найдена первая строка с SYNC - первая строка саба.
  // Так что пока такие есть...
  while p >-1 do
  begin
    new(Item);
    i := pos('=', LowerCase(Sl1.Strings[p]));           //  находим время
    j := pos('ms', LowerCase(Sl1.Strings[p]));          //  синхронизации.
    s:=copy(Sl1.Strings[p], i+1, j-i-1);                //
    Item.Time := StrToInt(s);                           //
    if OldTime <> 0 then Item.Length := Item.Time - OldTime;
    OldTime := Item.Time;
    i := pos('class=', Lowercase(Sl1.Strings[p]));      //находим класс строки
    if (i>0) then // we have class, parsing
    begin
    j := i+5;                   //
    repeat inc(j);
    until (Sl1.Strings[p][j] = '>') or (Sl1.Strings[p][j] = ' '); // находим  конец описания
    Item.ClassNum:=CheckClassID(copy(Sl1.Strings[p], i+6, j-i-6)); // класса строки и думаем что это начало текста
    end
    else Item.ClassNum:=CheckClassID(DefaultClassID); //we don't have class, default is assumed

    if not(Sl1.Strings[p][j] = '>') then  // находим конец тега <p>
    repeat inc(j); until (Sl1.Strings[p][j] = '>');

//    if (PClass = '*') or (PClass = s) then                 // проверка на "подходимость" (disabled as we load all classes at once now)
    begin
      s:=copy(Sl1.Strings[p], j+1, Length(Sl1.Strings[p])-j);
      p1:=p;
       repeat
         inc(p);
         if (p < Sl1.Count) and (pos('<sync ', LowerCase(Sl1.Strings[p])) = 0) and (pos('</body>', LowerCase(Sl1.Strings[p])) = 0)
         then begin
           s:=s+'##'+Sl1.Strings[p]; //Carriage return in sami file
         end;
       until (pos('<sync ', LowerCase(Sl1.Strings[p])) <> 0) or (p>Sl1.Count) or (pos('</body>', LowerCase(Sl1.Strings[p])) > 0);
      p:=p1;

      SetLength(Item.Line, length(s));
      Item.Line:=s;
//      SetLength(item.ClassID, length(copy(Sl1.Strings[p], i+6, j-i-6)));
//      item.ClassID:=copy(Sl1.Strings[p], i+6, j-i-6);
// ClassID extraction should be rewritten
//      Item.UID:=GetNewUID;
      AddScriptItemPtr(Item);
    end;
//    Sl1.Strings[p] := 'A';

    p := NextIndexOf(Sl1, 'SYNC', p, false);
  end;
  ExtractClasses;
  reUIDScript;
end;

{
procedure TScript.ParseSMI(Sl1:TStringList; FileDateTime:TDateTime);
var
i, j, p, p1, Element:integer;
s:string;
Item:^TScriptItem;
begin
  p := NindexOf(Sl1, 'SYNC', false);
//  Oldtime := 0;
  Element := 0;
  // Найдена первая строка с SYNC - первая строка саба.
  // Так что пока такие есть...
  while p >-1 do
  begin
    new(Item);
    Item^:=NoScriptItem;
    i := pos('start=', LowerCase(Sl1.Strings[p]));              //  находим время
    j := NextPos('ms', LowerCase(Sl1.Strings[p]), i);           //  синхронизации.
    if (j=0) or (j>NextPos('>',LowerCase(Sl1.Strings[p]), i))
    then j:=NextPos('>',LowerCase(Sl1.Strings[p]), i);
//    if (j=0) or (j>NextPos(' ',LowerCase(Sl1.Strings[p]), i))
//    then j:=NextPos(' ',LowerCase(Sl1.Strings[p]), i);
    s:=copy(Sl1.Strings[p], i+6, j-i-5);                //
//    s:=AnsiExtractQuotedStr(s, '"');
//    s:=AnsiExtractQuotedStr(s, '''');
    if (s<>'>') then Item.Time := StrToTimeMS(s);                           //
//    if OldTime <> 0 then Item.Length := Item.Time - OldTime;
//    OldTime := Item.Time;
    i := pos('class=', Lowercase(Sl1.Strings[p]));      //находим класс строки
    if (i=0) then repeat inc(p); i := pos('class=', Lowercase(Sl1.Strings[p])); until (i>0);
    if (i>0) then // we have class, parsing
    begin
    j := i+5;                   //
    repeat inc(j);
    until (Sl1.Strings[p][j] = '>') or (Sl1.Strings[p][j] = ' '); // находим  конец описания
    Item.ClassNum:=CheckClassID(copy(Sl1.Strings[p], i+6, j-i-6)); // класса строки и думаем что это начало текста
    end
    else Item.ClassNum:=CheckClassID(DefaultClassID); //we don't have class, default is assumed

    if not(Sl1.Strings[p][j] = '>') then  // находим конец тега <p>
    repeat inc(j); until (Sl1.Strings[p][j] = '>');

//    if (PClass = '*') or (PClass = s) then                 // проверка на "подходимость" (disabled as we load all classes at once now)
    begin
      s:=copy(Sl1.Strings[p], j+1, Length(Sl1.Strings[p])-j);
      p1:=p;
       repeat
         inc(p);
         if (p < Sl1.Count) and (pos('<sync ', LowerCase(Sl1.Strings[p])) = 0) and (pos('</body>', LowerCase(Sl1.Strings[p])) = 0)
         then begin
//           s:=s+'##'+Sl1.Strings[p]; //Carriage return in sami file
         end;
       until (pos('<sync ', LowerCase(Sl1.Strings[p])) <> 0) or (p>Sl1.Count) or (pos('</body>', LowerCase(Sl1.Strings[p])) > 0);
      p:=p1;

      SetLength(Item.Line, length(s));
      Item.Line:=s;
      Item.Comment:='[SAMI1]';
      Item.LastChange:=FileDateTime;
      Item.ElementNum:=Element;
      Item.Status:=_Text;
      inc(Element);
//      SetLength(item.ClassID, length(copy(Sl1.Strings[p], i+6, j-i-6)));
//      item.ClassID:=copy(Sl1.Strings[p], i+6, j-i-6);
// ClassID extraction should be rewritten
//      Item.UID:=GetNewUID;
      Item^.Line:=StringReplace(Item^.Line,'<BR>',LineBreakStr,[rfReplaceAll,rfIgnoreCase]);
      AddScriptItemPtr(Item);
    end;
//    Sl1.Strings[p] := 'A';

    p := NextIndexOf(Sl1, 'SYNC', p, false);
  end;
  CheckScript;
end;
}
procedure TScript.ParseSAMI(Sl1:TStringList; FileDateTime:TDateTime);
var s, s_sync_tag, s_sync, s_p_tag, s_p, ssl:string; NoCLASSString:string;
    i, Element:integer; SYNCTag, PTag: THTMLTagInfo;
    si:^TScriptItem;
begin
 i:=0;
 ssl:=SL1.Text;
 NoCLASSString:=GetNewClassId;
 Element:=0;
 SYNCTag:=GetTagInfoAfter(ssl, 'SYNC', i, FALSE);
 si:=nil;
 while (SYNCTag.TagDefStart>0) do
 begin
//  i:=Pos('<SYNC', Uppercase(ssl));
 new(si);
 si^:=NoScriptItem;

 s_sync_tag:=Copy(ssl, SYNCTag.TagDefStart, SYNCTag.TagDefEnd-SYNCTag.TagDefStart);
 s_sync:=Copy(ssl, SYNCTag.TagZoneStart, SYNCTag.TagZoneEnd-SYNCTag.TagZoneStart);

 PTag:=GetTagInfoAfter(s_sync, 'P', 0, FALSE);
 s_p_tag:=Copy(s_sync, PTag.TagDefStart, PTag.TagDefEnd-PTag.TagDefStart);
 s_p:=Copy(s_sync, PTag.TagZoneStart, PTag.TagZoneEnd-PTag.TagZoneStart);

 s:=GetTagValue(s_p_tag, 'CLASS');
 if (s='') then si.ClassNum:=CheckClassID(NoCLASSString)
 else si^.ClassNum:=CheckClassID(s);

 s:=GetTagValue(s_sync_tag, 'Start');
 if (s='') then si^.Time:=NoTime else
 if (Pos('MS', UpperCase(s))>0) then
  si.Time:=StrToTimeMS(Trim(StringReplace(s, 'ms', '', [rfReplaceAll, rfIgnoreCase])))
 else si.Time:=StrToTimeMS(Trim(s));
 s_p:=StringReplace(s_p, #13, '',[rfReplaceAll, rfIgnoreCase]);
 s_p:=StringReplace(s_p, #10, '',[rfReplaceAll, rfIgnoreCase]);
 {if (UpperCase(LineBreakStr)<>'<BR>') then}
    s_p:=StringReplace(s_p, '<BR>', LineBreakStr,[rfReplaceAll, rfIgnoreCase]); //including case of <br> for simplicity - since i fail to find all cases where rfIgnoreCase is omitted when converting backward
 si^.Line:=Trim(s_p);
 if (Trim(GetPlainLines(si^.Line))='') or
  (Trim(GetPlainLines(si^.Line))=TextIsClearStr)
  or (Trim(GetPlainLines(si^.Line))='&nbsp;')
  then si^.Line:=TextIsClearStr; //no need for formatting if nothing is visible within string


 si^.Comment:='[SAMI]';
 si^.LastChange:=FileDateTime;
 si^.ElementNum:=Element;
 inc(Element);
 si^.Status:=_Text;

 AddScriptItemPtr(si);
 i:=SYNCTag.TagZoneEnd;
 SYNCTag:=GetTagInfoAfter(ssl, 'SYNC', i-2, FALSE);

 end;
 if not(si=nil) then
 begin
 si^.Line:=StringReplace(si^.Line,'</TABLE>','',[rfIgnoreCase,rfReplaceAll]);
 si^.Line:=StringReplace(si^.Line,'</BODY>','',[rfIgnoreCase,rfReplaceAll]);
 si^.Line:=StringReplace(si^.Line,'</SAMI>','',[rfIgnoreCase,rfReplaceAll]);
 if (Trim(GetPlainLines(si^.Line))='') or
  (Trim(GetPlainLines(si^.Line))=TextIsClearStr)
  or (Trim(GetPlainLines(si^.Line))='&nbsp;')
  then si^.Line:=TextIsClearStr; //no need for formatting if nothing is visible within string

 CheckScript;
 end;
end;

procedure TScript.ParseRT(Sl1:TStringList; ClassID:string; FileDateTime:TDateTime);
var s, s_time_tag, s_time, ssl:string; NoCLASSString:string;
    i, Element:integer; TimeTag{, PTag}: THTMLTagInfo;
    si:^TScriptItem;
begin
 i:=0;
 NoCLASSString:=ClassId;
 Element:=0;
 ssl:=SL1.Text;
 TimeTag:=GetTagInfoAfter(ssl, 'TIME', i, FALSE);
 while (TimeTag.TagDefStart>0) do
 begin
//  i:=Pos('<SYNC', Uppercase(ssl));
 new(si);
 si^:=NoScriptItem;

 s_time_tag:=Copy(ssl, TimeTag.TagDefStart, TimeTag.TagDefEnd-TimeTag.TagDefStart);
 s_time:=Copy(ssl, TimeTag.TagZoneStart, TimeTag.TagZoneEnd-TimeTag.TagZoneStart);

 s:=GetTagValue(s_time_tag, 'begin');
 if (s='') then si.Time:=NoTime
 else si^.Time:=StrToTimeMS(s);

 s:=GetTagValue(s_time_tag, 'end');
 if (s='') then si^.Length:=NoTime else si^.Length:=StrToTimeMS(s)-si^.Time;

 s_time:=StringReplace(s_time, #13, '',[rfReplaceAll, rfIgnoreCase]);
 s_time:=StringReplace(s_time, #10, '',[rfReplaceAll, rfIgnoreCase]);
 s_time:=StringReplace(s_time, '<clear/>', '',[rfReplaceAll, rfIgnoreCase]);
 si^.Line:=Trim(s_time);
 if si^.Line='' then si^.Line:=TextIsClearStr;

 si^.ClassNum:=CheckClassID(NoClassString);
 si^.Comment:='[SMIL/RT]';
 si^.LastChange:=FileDateTime;
 si^.ElementNum:=Element;
 inc(Element);
 si^.Status:=_Text;

 s:=Trim(GetPlainLines(si^.Line));
 if (s='') or (s=TextIsClearStr) or (s='&nbsp;')
  then si^.Line:=TextIsClearStr; //no need for formatting if nothing is visible within string

 AddScriptItemPtr(si);
 i:=TimeTag.TagZoneEnd;
 TimeTag:=GetTagInfoAfter(ssl, 'TIME', i, FALSE);
 end;
 CheckScript;
end;


///
///  Save SMI
///

procedure TScript.SaveSMI(FileName:string; SaveClassNum: integer = -1);
var
Sl:TStringList;
ofn:string;
t:string;
i:integer;
begin
  if FileName = ''  then
  begin
  ofn:=FName;
  SetLength(FName, Length(FName)-3);
  FName := FName + 'smi' ;
  end;
  Sl:=GetLinesSMI(SaveClassNum);
  Sl.Insert(0, '--></Style></HEAD><BODY>');
  Sl.Insert(0, '#LargePrn {Name:Large Print; font-size:20pt;}');
  Sl.Insert(0, '#SMLPrn {Name:Small Print; font-size:10pt;}');
  Sl.Insert(0, '#STDPrn {Name:Standard Print;}');
  t:='';
  for i:=1 to ClassesCount do
  if (i=SaveClassNum) or (SaveClassNum<0) then
  begin
  t := '.'+Classes[i].ID+' { Name: '+Classes[i].Name+'; ';
//  t := '.'+Classes[i].ID+' { Name: Converted Script; ';
  if Classes[i].Language<>0 then
  begin
   t:=t+'Language: '+Languages[Classes[i].Language].ISO639ID+'-'+
  Countries[Classes[i].Country].ISO3166ID+'; ';
  end;
  if Classes[i].Formatting<>nil then t:=t+SAMIFormattingToStr(Classes[i].Formatting^);
  t:=t+'}';
  Sl.Insert(0, t);
  end;
//  Sl.Insert(0, '.KRCC {Name:Русский; lang:ru; SAMIType:Cyr;}');
//  Sl.Insert(0, 'font-weight:normal; color:white;}');
//  Sl.Insert(0, 'text-align:center; font-size:15pt; font-family:Tahoma;');

  t:= 'font-weight:';
  if (FALSE){(fsBold in SMITextStyle.Style)} then
   t:=t+'bold;'  else t:=t+'normal;';
  t:=t+' color:';
//  case SMITextStyle.color of
//    clYellow: t:=t+'yellow;}';
//    clWhite:  t:=t+'white;}';
//    clGreen:  t:=t+'green:}';
//    clRed:    t:=t+'red:}';
//    clBlue:   t:=t+'blue;}';
//  else
//    t:=t+'yellow; }';
//  end;
  t:=t+'yellow; }';
  Sl.Insert(0,  t);

  Sl.Insert(0, 'text-align:center; font-size: 18pt; font-family: Arial, Tahoma, sans-serif, serif;' );

  Sl.Insert(0, 'P {margin-left:1pt; margin-right:1pt; margin-bottom:1pt; margin-top:1pt;');
  Sl.Insert(0, '<!--');
  Sl.Insert(0, '<STYLE TYPE="text/css">');
  Sl.Insert(0, '<Title>' + ExtractFileName(FName)+'</Title>');
  Sl.Insert(0, '-->');
  Sl.Insert(0, '(c) 2001 by Watson');
  Sl.Insert(0, 'Created with FanSubber By Watson And Shalcker.');
  Sl.Insert(0, '<!--');
  Sl.Insert(0, '<SAMI> <HEAD>');
  Sl.Add('</BODY></SAMI>');
  if FileName = '' then Sl.SaveToFile(FName)
  else Sl.SaveToFile(FileName);
//  if Length(FileName)>0 then GetLinesSMI.SaveToFile(FileName);

  if FileName = '' then FName:=ofn;
end;

///
///   Create TStringList in SMI format from this TList.
///

function TScript.GetLinesSMI(SaveClassNum: integer = -1):TStringList;
var
i, i1:integer;
s:string;
s1:^TScriptItem;
begin
  Result := TStringList.Create;
  For i:=0 to Count-1 do
  if (TScriptItem(items[i]^).Time>-1) then
  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  if (TScriptItem(items[i]^).Status in [_Text, _Clear]) then
  begin
    s1:=items[i];
    s:='<SYNC Start=';
    s:=s+IntToStr(s1^.Time);
    s:=s+'ms><P Class=';
    s:=s+GetClassID(s1.ClassNum);
    s:=s+'>';
    s:=s+StringReplace(s1.Line,'##',#13#10,[rfReplaceAll]);
{    while pos('##', s1.line) >0 do begin
      i1:=pos('##', s1.line);
      s1.Line[i1]:=#13;
      s1.Line[i1+1]:=#10;
    end;
    s:=s+s1.Line;
}

    Result.add(s);
  end;
end;

procedure TScript.SaveSAMI(FileName:string; SaveClassNum: integer = -1); // Сохранение в SMI
var
Sl:TStringList;
s1:^TScriptItem;
ofn:string;
t,s:string;
i:integer;
begin
{  if FileName = ''  then
  begin
  ofn:=FName;
  SetLength(FName, Length(FName)-3);
  FName := FName + 'smi' ;
  end;}
  SL:=TStringList.Create;
  Sl.Add('<SAMI><HEAD>');
  Sl.Add('<!--');
{$ifndef NO_FANSUBBER}
  Sl.Add('Created with FanSubber By Watson And Shalcker.');
  Sl.Add('(c) 2001-2002 by Watson and Shalcker');
{$else}
  Sl.Add('Created with ScriptConverter By Watson And Shalcker.');
  Sl.Add('(c) 2001-2002 by Watson and Shalcker');
{$endif}
  Sl.Add('-->');
  Sl.Add('<Title>' + ExtractFileName(FileName)+'</Title>');
  Sl.Add('<STYLE TYPE="text/css">');
  Sl.Add('<!--');
  Sl.Add('P {margin-left:1pt; margin-right:1pt; margin-bottom:1pt; margin-top:1pt;');
  Sl.Add('text-align:center; font-size: 18pt; font-family: Arial, Tahoma, sans-serif, serif;' );
  t:= 'font-weight:';
  if (FALSE){(fsBold in SMITextStyle.Style)} then
   t:=t+'bold;'  else t:=t+'normal;';
  t:=t+' color:';
  t:=t+'yellow; }';
  Sl.Add(t);

  t:='';
  for i:=1 to ClassesCount do
  if (i=SaveClassNum) or (SaveClassNum<0) then
  begin
  t := '.'+Classes[i].ID+' { Name: '+Classes[i].Name+'; ';
  if Classes[i].Language<>0 then
  begin
   t:=t+'Language: '+Languages[Classes[i].Language].ISO639ID+'-'+
  Countries[Classes[i].Country].ISO3166ID+'; ';
  end;
  if Classes[i].Formatting<>nil then t:=t+SAMIFormattingToStr(Classes[i].Formatting^);
  t:=t+'}';
  Sl.Add(t);
  end;
  Sl.Add('#STDPrn {Name:Standard Print;}');
  Sl.Add('#LargePrn {Name:Large Print; font-size:20pt;}');
  Sl.Add('#SmallPrn {Name:Small Print; font-size:10pt;}');
  Sl.Add('--></Style></HEAD><BODY>');

  For i:=0 to Count-1 do
  if (TScriptItem(items[i]^).Time>-1) then
  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  if (TScriptItem(items[i]^).Status in [_Text, _Clear]) then
  begin
    s1:=items[i];
    s:='<SYNC Start=';
    s:=s+IntToStr(s1^.Time);
    s:=s+'ms><P Class=';
    s:=s+GetClassID(s1.ClassNum);
    s:=s+'>';
    s:=s+StringReplace(s1.Line,'##',#13#10,[rfReplaceAll]);
    SL.Add(s);
  end;

    s:='<SYNC Start=';
    s:=s+IntToStr(s1^.Time+s1^.Length);
    s:=s+'ms><P Class=';
    s:=s+GetClassID(s1.ClassNum);
    s:=s+'>'+TextIsClearStr;
    SL.Add(s);
  Sl.Add('</BODY></SAMI>');

//  if FileName = '' then Sl.SaveToFile(FName)
  Sl.SaveToFile(FileName);
//  if Length(FileName)>0 then GetLinesSMI.SaveToFile(FileName);

//  if FileName = '' then FName:=ofn;

end;

//
// Объединение спсков
//
procedure TScript.AddList(List:TList);
var
s:^TScriptItem;
i:integer;
begin
 for i:=0 to List.count-1 do
 begin
   s:=List.items[i];
   Add(s);
 end;
 Sort(SortFuncTime);
//
end;


function TScript.GetScriptItemAtIndex(Index:integer):TScriptItem;
begin
 if (IsValidIndex(Index)) then Result := TScriptItem(Items[index]^);
end;

procedure TScript.SetScriptItemAtIndex(index:integer; ScriptItem:TScriptItem);
begin
 if (IsValidIndex(Index)) then TScriptItem(Items[index]^):=ScriptItem;
end;


function TScript.GetLengthAtIndex(Index:integer):integer;
begin
 if (IsValidIndex(Index)) then Result := TScriptItem(Items[index]^).Length;
end;

procedure TScript.SetLengthAtIndex(index:integer; Length:Longint);
begin
 if (IsValidIndex(Index)) then TScriptItem(Items[index]^).Length:=Length;
end;


function TScript.GetEndTimeAtIndex(Index:integer):integer;
begin
 if (IsValidIndex(Index)) then Result := TScriptItem(Items[index]^).Time + TScriptItem(Items[index]^).Length;
end;

procedure TScript.SetEndTimeAtIndex(index:integer; EndTime:Longint);
begin
 if (IsValidIndex(Index)) then TScriptItem(Items[index]^).Length:=EndTime-TScriptItem(Items[index]^).Time;
end;

///
/// Возвращает Время из элемента в строке Index
///

function TScript.GetTimeAtIndex(Index:integer):integer;
begin
  if (IsValidIndex(Index)) then Result := TScriptItem(Items[index]^).Time
  else Result:=-1;
end;

procedure TScript.SetTimeAtIndex(index:integer; Time:Longint);
begin
 if (IsValidIndex(Index)) then TScriptItem(Items[index]^).Time:=Time;
end;

function TScript.IsValidIndex(Index:integer):boolean;
begin
 Result:=(Index < Count) and (index>-1);
end;
///
/// Возвращает Текст из элемента в строке Index
///

function TScript.GetTextAtIndex(Index:integer):string;
var
  s1:^TScriptItem;
  i:integer;
  s:string;
begin
  if (IsValidIndex(Index)) then
//  and (TScriptItem(Items[index]^).ClassNum = MainForm.CurrentClass) then
  begin
  s1:=Items[Index];
  Result:=s1.Line;
  end else Result:='';
  while pos('<br>', lowercase(Result)) > 0 do
  begin
    i:=pos('<br>', lowercase(Result));
    s:=copy(Result, i+4, length(Result)-i-3);
    result[i] := #13;
    result[i+1] := #10;
    Result:=copy(Result, 0, i+1) + s;
  end;
  if LowerCase(Result) = TextIsClearStr then Result:='';
  CurrentIndex:=index;
end;

///
/// По времени в ms возвращается текст, который отображается в это время
///

function TScript.GetTextAtTime(Time:longint):string;
//var
//i:integer;
begin
//
{  i:=0;
  while ((i < Count)
  and (GetTimeAtIndex(i) < Time))
   do inc(i);
  dec(i);}
  Result:=GetTextAtIndex(GetIdxAtTime(Time));
end;

///
/// Заменяет текст, отображаемый во время Time
///

procedure Tscript.Replace1(Time:longint; Text:string);
var
s:^TScriptItem;
i,oi:integer;
os, s1:string;
begin
//  i:=GetTimeAtIndex(Time);
  i:=GetIdxAtTime(Time);
  s:=Items[i];
  os:=s.Line;
  oi:=i;
  i:=0;
  if Length(text) <> 0 then
  while i < Length(Text) do begin
    if Text[i] = #13 then begin
      s1:=copy(Text, 0, i-1);
      Text:=s1 + '<BR>' + copy(text, i+2, Length(Text)-i-1);
    end;
    inc(i);
 end else
   text:=TextIsClearStr;
  SetLength(s.Line, Length(text));
  s.Line := text;
  Log.Insert(0, '' );
  Log.Insert(0, 'Was:['+IntToStr(TScriptItem(Items[oi]^).Time)+']:"'+s.Line+'"' );
  Log.Insert(0, 'Now:['+IntToStr(s.Time)+']:"'+os+'"' );
//  Log.add('Было:['+IntToStr(s.Time)+']:"'+os+'"' );
//  Log.add('Замена на:['+IntToStr(TScriptItem(Items[oi]^).Time)+']:"'+s.Line+'"');
//  Log.Add('');
  Items[oi]:=s;
end;

///
///  Добавляет в список строку и сортирует его
///

procedure TScript.Add1(Time:longint; Text:string);
var
i:integer;
s:^TScriptItem;
s1:string;
begin
  new(s);
  s.Time:=time;
//  s.line:=Text;

// CHANGE!!!
//  if PClass = '*' then s.ClassID:='KRCC' else s.ClassID:=PClass;
  s.Length:=Length(text)*40;
  if Length(text) > 0 then begin
    Text:=StringReplace(Text, #13#10, LineBreakStr, [rfReplaceAll,rfIgnoreCase]);
    Text:=StringReplace(Text, #13, LineBreakStr, [rfReplaceAll,rfIgnoreCase]);
    Text:=StringReplace(Text, #10, LineBreakStr, [rfReplaceAll,rfIgnoreCase]);
    s.Line:=Text;
  end
  else s.Line:=TextIsClearStr;
  s.textFlag := [];
  AddScriptItemPtr(s);
//  Log.add('Добавлено:['+IntToStr(s.Time)+']:"'+s.Line+'"');
//  Log.Add('');
    Log.Add('');
    Log.Add('Added:['+IntToStr(s.Time)+']:"'+s.Line+'"' );

//  CheckScript;
//  Sort(SortFuncTime);
end;

function TScript.GetFirstClass:integer;
begin
  if ClassesCount=0 then Result:=0 else Result:=1;
end;

function TScript.GetIdxAtTime;//(Time:longint):integer;
var
i, ip, Ctr:integer;
flag:boolean;
begin
//
if (Count>0) then
begin
  i:=0; ip:=0;
  flag:=true;
{  if time > TScriptItem(Items[Count-1]^).Time then
  begin
     flag:=false;
     ip:=Count-1;
  end;}
  Ctr:=0;
  while (i<Count) and (Ctr<Num)  do
  begin
   if IsWithin(Time,TScriptItem(Items[i]^).Time,TScriptItem(Items[i]^).Length) then inc(Ctr);
   inc(i);
  end;
   if (Ctr=Num) then Result:=i-1 else Result:=-1;
end else Result:=-1;
{  while (i < Count) and Flag do
  begin
    begin
      if GetTimeAtIndex(i) > Time then
        flag:=false else
        ip := i;
    end;
    inc(i);
  end;
//  if (ip=Count-1) then
   flag:=not(IsWithin(Time,TScriptItem(Items[ip]^).Time,TScriptItem(Items[ip]^).Length));
{
  while ((i < Count)
  and (GetTimeAtIndex(i) <= Time))
   do inc(i);
  if (i < Count) then
    while (TScriptItem(items[i]^).ClassID <> PClass) do dec(i);

   if not flag then Result:=ip else Result:=-1;
   if not flag then CurrentIndex:=ip else CurrentIndex:=0;
end else Result:=0;}
end;

function TScript.GetNextAtIndex(index:integer):integer;
begin
  result:=TScriptItem(Items[index]^).Length;
end;

function TScript.GetNextAtTime(Time:longint):integer;
var i:integer;
begin
  i:=GetIdxAtTime(time)+1;
  if i < Count then
  Result:=TScriptItem(Items[i]^).Length + TScriptItem(Items[i]^).Time
  else Result:=0;
end;


procedure TScript.UpdateTextFromList(Data:TStrings);
var i:integer;
s:^TScriptItem;
begin
  i:=1;
  Capacity:=Data.Count;
  while i < Data.Count do
  begin
    s:=Items[i-1];
    SetLength(s.line, length(Data.Strings[i]));
    s.Line:=Data.Strings[i];
    Items[i-1]:=s;
    inc(i);
  end;
end;

procedure TScript.UpdateTimeFromList(Data:TStrings);
var i:integer;
s:^TScriptItem;
begin
  i:=1;
  Capacity:=Data.Count;
  while i < Data.Count do
  begin
    s:=Items[i-1];
    s.Time:=StrToInt(Data.Strings[i]);
    Items[i-1]:=s;
    inc(i);
  end;
end;

procedure TScript.TimeTextUpdate(TimeList:TStrings; TextList:TStrings; ClasList:TStrings; ActrList:TStrings);
var i:integer;
s:^TScriptItem;
begin
  i:=1;
  Clear;
  Capacity:=Textlist.Count;
  while i < TextList.Count do
  begin
    new(s);
//    s:=Items[i-1];
    s.Time:=StrToInt(TimeList.Strings[i]);
    s.Line:=TextList.Strings[i];
    //Change!!! required
    s.ClassNum:=CheckClassID(ClasList.Strings[i]);
//    s.Actor:=ActrList.Strings[i]; 2 Change!
//    Items[i-1]:=s;
    AddScriptItemPtr(s);
    inc(i);
  end;
end;


function TScript.StrToTimeMS;//(Str:string;ErrorRes:longint):longint;
var h,m,s,comma, len, Hr, Mi, Sc, Ms, i, err1: longint;
begin
 // string for this function should look like HH:MM:SS.MS, MM:SS.MS, SS.MS or MS
 // example is '0:00:0.12' (120 ms), '1:01.215' (61215 ms), '0.1' (100 ms), '100' (100 ms)
//      h:=0; m:=0; s:=0;
      Trim(Str);
//      Hr:=0; Mi:=0; Sc:=0; Ms:=NoTime; // if this is not timestring, then -1 will be returned
      Hr:=0; Mi:=0; Sc:=0; Ms:=ErrorRes; // if this is not timestring, then -1 will be returned

      h:=pos(':', str);
      len:=Length(str);
      m:=h+pos(':', copy(str, h+1, len-h)); if m=h then m:=0;
      err1:=m+pos(':', copy(str, m+1, len-m)); if err1=m then err1:=0; //erronous variant - hh:mm:ss:ms
      if (m<>0) then
       begin
        s:=m+pos('.', copy(str, m+1, len-m)); if s=m then s:=0;
        comma:=m+pos(',', copy(str, m+1, len-m)); if comma=m then comma:=0;
       end
       else
       begin
        if (h<>0) then
        begin
        s:=h+pos('.', copy(str, h+1, len-h)); if s=h then s:=0;
        comma:=h+pos(',', copy(str, h+1, len-h)); if comma=h then comma:=0;
        end
        else
        begin
         s:=pos('.', str);
         comma:=pos(',', str);
        end;
       end;
       if (s=0) and (comma<>0) then s:=comma;
       if (s=0) and (comma=0) and (err1>0) then s:=err1;

 try
      if ((h<>0) and (m<>0)) and (s<>0) //HH:MM:SS.MS
       then
       begin
//      Hr:=StrToInt(copy(str, 1, h-1));
        Hr:=StrToIntDef(copy(str, 1, h-1),0);
//        Mi:=StrToInt(copy(str, h+1, m-h-1));
        Mi:=StrToIntDef(copy(str, h+1, m-h-1),0);
//        Sc:=StrToInt(copy(str, m+1, s-m-1));
        Sc:=StrToIntDef(copy(str, m+1, s-m-1),0);
        if (len-s)>2 then
//        Ms:=StrToInt(copy(str, s+1, 3))
        Ms:=StrToIntDef(copy(str, s+1, 3),-1)
//        else Ms:=StrToInt(copy(str, s+1, len-s));
        else Ms:=StrToIntDef(copy(str, s+1, len-s),-1);
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h<>0) and (m=0)) and (s<>0) //MM:SS.MS
       then
       begin
        Mi:=StrToInt(copy(str, 1, h-1));
        Sc:=StrToInt(copy(str, h+1, s-h-1));
        if (len-s)>2 then
        Ms:=StrToInt(copy(str, s+1, 3))
        else Ms:=StrToInt(copy(str, s+1, len-s));
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h=0) and (m=0)) and (s<>0) //SS.MS
       then
       begin
        Sc:=StrToInt(copy(str, 1, s-1));
        if (len-s)>2 then
        Ms:=StrToInt(copy(str, s+1, 3))
        else Ms:=StrToInt(copy(str, s+1, len-s));
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h<>0) and (m=0)) and (s=0) //MM:SS
      then
      begin
        Mi:=StrToInt(copy(str, 1, h-1));
        Sc:=StrToInt(copy(str, h+1, len-h));
        Ms:=0;
      end;

      if ((h<>0) and (m<>0)) and (s=0) //MM:SS
      then
      begin
        Hr:=StrToInt(copy(str, 1, h-1));
        Mi:=StrToInt(copy(str, h+1, m-h-1));
        Sc:=StrToInt(copy(str, m+1, len-m));
        Ms:=0;
      end;

      if ((h=0) and (m=0)) and (s=0) then Ms:=StrToIntDef(str,NoTime);//MS
 except
  on EConvertError do begin
//   Hr:=0; Mi:=0; Sc:=0; Ms:=NoTime; // if this is not timestring, then -1 will be returned
   Hr:=0; Mi:=0; Sc:=0; Ms:=ErrorRes; // if this is not timestring, then -1 will be returned
   if (LineNumber>-1) then NotifyError('Line '+IntToStr(LineNumber)+': Cannot convert "'+Str+'" to Time Value: Assigning '+IntToStr(ErrorRes))
   else NotifyError('Cannot convert "'+Str+'" to Time Value: Assigning '+IntToStr(ErrorRes));
  end;
 end;
 if (err1>0) then
  if (LineNumber>-1) then NotifyWarning('Line '+IntToStr(LineNumber)+': '+Str+' is not valid TimeString - assuming HH:MM:SS:MS')
  else NotifyWarning(Str+' is not valid TimeString - assuming HH:MM:SS:MS');
 Result:=Hr*60*60*1000+Mi*60*1000+Sc*1000+Ms;
end;


function TScript.SSATextToSAMIText(Str:string):string;

function SSAFntToFontTag(str:string):string;
var i,j:integer; s_tmp, stmp2:string;
begin
 {\fnHeidelberg\fs36\c&HDFCF9F&}
 Result:='<FONT';
 s_tmp:='';

 i:=Pos('\fn',LowerCase(str));
 j:=NextPos2('\',str,i);
 if j=0 then
 begin
 j:=Length(str);
 if i>0 then s_tmp:=s_tmp+' FACE="'+copy(str, i+3, j-i-2)+'"';
 end
 else
 if i>0 then s_tmp:=s_tmp+' FACE="'+copy(str, i+3, j-i-3)+'"';

 i:=Pos('\fs',LowerCase(str));
 j:=NextPos2('\',str,i);
 if j=0 then
 begin
 j:=Length(str);
 if i>0 then s_tmp:=s_tmp+' SIZE="'+copy(str, i+3, j-i-2)+'"';
 end
 else  if i>0 then s_tmp:=s_tmp+' SIZE="'+copy(str, i+3, j-i-3)+'"';

 i:=Pos('\c&h',LowerCase(str));
 j:=NextPos('&',str,i+4);
 if j=0 then j:=Length(str);
 stmp2:=copy(str, i+4, j-i-3);
 stmp2:=copy(stmp2, 5, 2)+copy(stmp2, 3, 2)+copy(stmp2, 1, 2);
 if i>0 then s_tmp:=s_tmp+' COLOR="#'+stmp2+'"';

 Result:=Result+s_tmp+'>';

 if (Result='<FONT>') then Result:='';

 i:=Pos('\i1',LowerCase(str)); if i>0 then Result:=Result+'<I>';
 i:=Pos('\i0',LowerCase(str)); if i>0 then Result:=Result+'</I>';

 i:=Pos('\b1',LowerCase(str)); if i>0 then Result:=Result+'<B>';
 i:=Pos('\b0',LowerCase(str)); if i>0 then Result:=Result+'</B>';

// s_tmp:=StringReplace(LowerCase(str), '\fn', ' FACE="', []);
end;

var s1,s2,s3:string; i,j:integer;
begin
 s1:='';
 j:=1;
 i:=Pos('\n', LowerCase(Str));
 while i>0 do
 begin
  s1:=s1+copy(Str, j, i-j)+LineBreakStr;
  j:=i+2;
  i:=NextPos2('\n', LowerCase(Str), j-1); //CHeck!
 end;
 s1:=s1+copy(Str, j, Length(Str));
// s1:='';
 j:=0;
 s2:=GetStrBetween('{','}',s1,j);
 {\fnHeidelberg\fs36\c&HDFCF9F&}
 while s2<>'' do
 begin
  s3:=SSAFntToFontTag(s2);
  s1:=StringReplace(s1, '{'+s2+'}', s3, []);
  s2:=GetStrBetween('{','}',s1,0);
 end;
 Result:=s1; //TEMP!!!
end;

procedure TScript.SSAOneStrToTimeCode(s:string;var si:TScriptItem);
var j,k: integer;
begin
 si.Length:=NoTime;
 si.Time:=NoTime;

 j:=pos(',',s);
 k:=j+pos(',',copy(s, j+1, Length(s)-j));
 try
 if (k>j+1) then si.Time:=StrToTimeMS(copy(s,j+1,k-j-1),-1,si.ElementNum) else si.Time:=NoTime;
 except
  on EConvertError do si.Time:=NoTime;
 end;
 j:=k+pos(',',copy(s, k+1, Length(s)-k));
 if (j<>k) and (j>k+1) then si.Length:=StrToTimeMS(copy(s,k+1,j-k-1)) else si.Length:=NoTime;
 if {(si.Length>-1) and }(si.Time<si.Length) then si.Length:=si.Length-si.Time;
end;

procedure TScript.SSAOneStringToScriptItem(Str:string; var si:TScriptItem);
var i,j, CommaCounter:integer; s:string;

procedure NonParsedString;
begin
       si.Status := _Other;
       si.Comment:='SSA: Non-Parsed Line';
       si.Time:=NoTime; //maybe i'll add "previous time" to maintain string order... then again, maybe not
       si.Length:=NoTime;
       si.ActorNum:=0; // all non-parsed strings are added as default actor
       si.GroupNum:=0; // and MAIN group
       si.Line:=str;
//       si.Edition:=0;
end;

// the following can be changed in si: Line, Time, Length, GroupNum, ActorNum, NumericData0-3, Status, Comment
begin
 if ((pos('dialogue:', LowerCase(Str)) <> 0) or
      (pos('comment:', Lowercase(Str)) <> 0)) then
     begin
      CommaCounter:=0;
      SSAOneStrToTimeCode(str, si);
      if si.Time<>NoTime then
      begin
//Dialogue: iMarked=0,j0:00:02.75,i0:00:04.25,j*Default,iNAME,j0000,i0000,j0000,i,jВ этом
      i:=pos('marked=',LowerCase(str));
      if (pos('marked=1',LowerCase(str))>0) then si.Selected:=TRUE;
      j:=pos(',',str); if j<>0 then inc(CommaCounter);
        try
      if j>i then si.NumericData[0]:=StrToInt(copy(str, i+7, j-i-7)); //Number after Marked=
      i:=j+pos(',', copy(str, j+1, Length(str)-j)); if i<>j then inc(CommaCounter);
      //skipping start-time since it is already parsed in SSAOneStrToTimeCode
      j:=i+pos(',', copy(str, i+1, Length(str)-i)); if j<>i then inc(CommaCounter);
      //skipping end-time since it is already parsed in SSAOneStrToTimeCode
      i:=j+pos(',', copy(str, j+1, Length(str)-j)); if i<>j then inc(CommaCounter);
      //parsing group (SSA Style parameter)
      s:=copy(str, j+1, i-j-1);
      if (LowerCase(s)='*default') then s:=DefaultGroupName;
      if (LowerCase(s)='default') then s:=DefaultGroupName;
      si.GroupNum:=CheckGroupName(s);

      //parsing Actor
      j:=i+pos(',', copy(str, i+1, Length(str)-i)); if j<>i then inc(CommaCounter);
      s:=copy(str, i+1, j-i-1);
      if (s='') or (pos('default',LowerCase(s))<>0) then s:=DefaultActorName;
      si.ActorNum:=CheckActorName(s);

      //parsing MarginLeft
      i:=j+pos(',', copy(str, j+1, Length(str)-j)); if i<>j then inc(CommaCounter);
      if (i-j)>1 then si.NumericData[1]:=StrToInt(copy(str, j+1, i-j-1));

      // Parsing MarginRight
      j:=i+pos(',', copy(str, i+1, Length(str)-i)); if j<>i then inc(CommaCounter);
      if (j-i)>1 then si.NumericData[2]:=StrToInt(copy(str, i+1, j-i-1));

      //parsing MarginVertical (MarginBottom?)
      i:=j+pos(',', copy(str, j+1, Length(str)-j)); if i<>j then inc(CommaCounter);
      if (i-j)>1 then si.NumericData[3]:=StrToInt(copy(str, j+1, i-j-1));

      j:=i+pos(',', copy(str, i+1, Length(str)-i)); if j<>i then inc(CommaCounter);
      if (j-i)=1 then i:=j;//No SSA "Effect", but ,, before text is present (this is sign of SSA format version... maybe i should use it somewhere...)
      inc(i);
        except
          on EConvertError do begin
           NotifyError('Failed to parse SSA string "'+Str+'" (error on "," '+IntToStr(CommaCounter)+') - adding as "Other"');
           CommaCounter:=0; //there was an error somewhere, and it means that string wasn't sucessfully parsed
          end
        end;

      if (CommaCounter>7) then
      begin
         s:=SSATextToSAMIText(copy(Str, i, Length(Str)-i+1)); //if any "Effect" is present, it'll be added to text... but who cares?
         si.Status:=_Text;
         si.Comment:='SSA: ';
         if (pos('dialogue:', LowerCase(Str))<>0) then
         begin
          si.Comment:=si.Comment+'Dialogue';
         end;
         if (pos('comment:', LowerCase(Str))<>0) then
         begin
          si.Comment:=si.Comment+'Comment';
          si.Status:=_Other;
         end;
         si.Line:=s;
      end
      else NonParsedString;
      end;
     end
     else NonParsedString;

end;

procedure TScript.GetSSAGroupFormat(FormatString:string);
var i:integer; GroupNum: integer; s, Name:string; FM:TSubTextFormatting;
begin
//Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, TertiaryColour, BackColour, Bold, Italic, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, AlphaLevel, Encoding
//Style: RON,,0,16777215,65535,8388736,0,0,0,0,30,10,6,0,0,0,0,0
 if (pos('Style:', FormatString)>0)
 then
 begin
  Name:=Trim(GetStrBetween(':', ',', FormatString, 0));
  if (Name<>'') {and (Pos('default',LowerCase(s))=0)} then
  begin

  i:=NextPos2(',', FormatString,0);
  try
   with FM {Groups[GroupNum].Formatting^} do
   begin
   //FontName
   s:=GetStrBetween(',',',', FormatString, i-1);
   FontName:=s;

   //FontSize
   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   if  (s<>'') then TextSize:=StrToInt(s) else TextSize:=0;

   //Primary Color
   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
//   if (Length(TextColors)<3) then SetLength(TextColors, 3);
   If (s<>'') then TextColors[0]:=StrToInt(s);

   //SecondaryColour
   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   If (s<>'') then TextColors[1]:=StrToInt(s);

   //TertiaryColour
   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   If (s<>'') then TextColors[2]:=StrToInt(s);

   //BackColour
   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   If (s<>'') then BGColor:=StrToIntDef(s,Classes[0].Formatting^.BGColor);

   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   if (StrToIntDef(s,0)>0) then FontStyles:=FontStyles+[fsBold] else FontStyles:=FontStyles-[fsBold];

   i:=NextPos2(',', FormatString, i);
   s:=GetStrBetween(',',',', FormatString, i-1);
   if (StrToIntDef(s,0)>0) then FontStyles:=FontStyles+[fsItalic] else FontStyles:=FontStyles-[fsItalic];

   i:=NextPos2(',', FormatString, i); //borderstyle
   i:=NextPos2(',', FormatString, i); //Outline
   i:=NextPos2(',', FormatString, i); //shadow
   i:=NextPos2(',', FormatString, i); //AlignMent
   s:=GetStrBetween(',',',', FormatString, i-1);
   case StrToIntDef(s,2) of
    1: begin VAlign:=VAl_Bottom; HAlign:=HAl_Left; end;
    2: begin VAlign:=VAl_Bottom; HAlign:=HAl_Center; end;
    3: begin VAlign:=VAl_Bottom; HAlign:=HAl_Right; end;
    4: begin VAlign:=VAl_Center; HAlign:=HAl_Left; end;
    5: begin VAlign:=VAl_Center; HAlign:=HAl_Center; end;
    6: begin VAlign:=VAl_Center; HAlign:=HAl_Right; end;
    7: begin VAlign:=VAl_Top; HAlign:=HAl_Left; end;
    8: begin VAlign:=VAl_Top; HAlign:=HAl_Center; end;
    9: begin VAlign:=VAl_Top; HAlign:=HAl_Right; end;
   end;
   i:=NextPos2(',', FormatString, i); //MarginL
   Margin[mg_Left]:=StrToIntDef(GetStrBetween(',',',', FormatString, i-1),5);
   i:=NextPos2(',', FormatString, i); //MarginR
   Margin[mg_Right]:=StrToIntDef(GetStrBetween(',',',', FormatString, i-1),5);
   i:=NextPos2(',', FormatString, i); //MarginV
   Margin[mg_Top]:=StrToIntDef(GetStrBetween(',',',', FormatString, i-1),5);
   Margin[mg_Bottom]:=StrToIntDef(GetStrBetween(',',',', FormatString, i-1),5);

  if (Pos('default',LowerCase(Name))=0) then
  begin
   GroupNum:=CheckGroupName(s);
   if (Groups[GroupNum].Formatting=nil) then New(Groups[GroupNum].Formatting);
   Groups[GroupNum].Formatting^:=FM;
  end
  else Classes[0].Formatting^:=FM;

   //Bold,
   //Italic,
   //BorderStyle,                     5
   //Outline,
   //Shadow,
   //Alignment,
   //MarginL,
   //MarginR,
   //MarginV,
   //AlphaLevel,
   //Encoding

   end;
  except
   NotifyError('Error processing SSA Group Formatting: '+FormatString);
   if Groups[GroupNum].Formatting<>nil then Dispose(Groups[GroupNum].Formatting);
   Groups[GroupNum].Formatting:=nil;
  end;
  end
  else //Default Script Style
  begin
   //not parsed (yet)
  end;

 end;

end;

procedure TScript.ParseSSA(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
var
i:integer;
si:^TScriptItem;
begin
//  Clear;//No need to clear main script - we are only adding items
    i:=0;
    while (i<Ls.Count) do
     if Pos('[v4 styles]',LowerCase(Ls[i]))=0 then inc(i)
     else break;
    if (i=Ls.Count) then
    begin
     NotifyWarning('SSA File does not have [v4 Styles] Section: SSA v3 Assumed');
    end
    else
      while (Pos('[',Ls[i+1])=0)and(i<Ls.Count-1) do
      begin
       GetSSAGroupFormat(Ls[i+1]);
       inc(i);
      end;
{      i:=0; //SSA v3 doesn't has sections...
      while (i<Ls.Count-1) do
      begin
       GetSSAGroupFormat(Ls[i+1]);
       inc(i);
      end;}


    i:=0;
    while (i<Ls.Count) do
    if (Pos('[Events]',Ls.Strings[i])=0) then inc(i)
    else break;
    if (i=Ls.Count) then
    begin
     NotifyError('SSA file does not have [Events] section');
     i:=0; //still try to parse
    end;
    while (i<Ls.Count) do
    begin
     if ((pos('dialogue:', LowerCase(Ls[i])) <> 0) or
      (pos('comment:', Lowercase(Ls[i])) <> 0)) then
      begin
       New(si);
       si^:=NoScriptItem;
       si^.ClassNum:=CheckClassID(ClassID); //if there is no such class, it is created.
       si^.UID:=-1; // request for new UID when checking (there is no UIDs in SSA files)
       si^.Edition:=0;
       si^.LastChange:=FileDateTime;
       si^.ElementNum:=i;
       SSAOneStringToScriptItem(Ls.Strings[i], si^);
// the following can be changed in SSAOneStringToScriptItem: Line, Time, Length, GroupNum, ActorNum, NumericData0-3, Status, Comment
       AddScriptItemPtr(si);
      end;
     inc(i);
     end;
  CheckScript;
end;

procedure TScript.ParseSRT(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
var
i,j, step:integer; s:string;
si:^TScriptItem;
begin
if (LS.Count)>0 then
begin
    i:=0; step:=0;
    New(si);
    si^:=NoScriptItem;
        si^:=NoScriptItem;
        si^.ActorNum:=0; // all non-parsed strings are added as default actor
        si^.GroupNum:=0; //MAIN group by default
        si^.ClassNum:=CheckClassID(ClassID); //if there is no such class, it is created.
        si^.UID:=-1; // request for new UID when checking (there is no UIDs in SRT files)
        si^.Edition:=0;
        si^.LastChange:=FileDateTime;
    repeat
       s:=Ls.Strings[i];
       if (Length(s)<>0) then
       begin
       inc(step);
try
       if (step=1) then si.ElementNum:=StrToInt(Trim(s));
except
  on EConvertError do begin
   si.ElementNum:=-1;
   NotifyWarning(s+' is not a valid SRT subtitle number');
  end;
end;
       if (step=2) then
        begin
        s:=StringReplace(s,'  ',#2,[rfReplaceAll]);
        s:=StringReplace(s,#2,' ',[rfReplaceAll]);
        si.Time:=StrToTimeMS( copy(s,1,pos(' ',s)-1), -1, i ); //with line numbers
//        si.Length:=StrToTimeMS(Trim(copy(s,pos('-->',s)+3, Length(s))))-si.Time; //'-->X
        j:=NextPos2(' ',s,pos('-->',s)+4);
        if (j>0) then si.Length:=StrToTimeMS(Trim(copy(s,pos('-->',s)+3, j-pos('-->',s)-3)),-1,i)-si.Time
        else si.Length:=StrToTimeMS(Trim(copy(s,pos('-->',s)+3, Length(s))),-1,i)-si.Time; //'-->X
        CheckFSBSRTData(si^,s);
        end;
       if (step>2) then
        if (si.Line<>NoScriptItem.Line) then si.Line:=si.Line+LineBreakStr+Trim(s)
        else si.Line:=Trim(s);
       end
       else //if string = ''
       begin
        si^.Status := _Text;
        if (si^.Line<>'') then si^.Comment:='Parsed string from SRT file'
        else
        begin
         si^.Comment:='Empty?! string from SRT file. Error.';
         NotifyWarning('Line '+IntToStr(i)+': *Empty* subtitle found while parsing SRT File');
        end;
        if not(si^.Line=NoScriptItem.Line) then AddScriptItemPtr(si)
        else Dispose(si);
        New(si);
        si^:=NoScriptItem;
        si^.ActorNum:=0; // all non-parsed strings are added as default actor
        si^.GroupNum:=0; //MAIN group by default
        si^.ClassNum:=CheckClassID(ClassID); //if there is no such class, it is created.
        si^.UID:=-1; // request for new UID when checking (there is no UIDs in SRT files)
        si^.Edition:=0;
        si^.LastChange:=FileDateTime;
        step:=0;
       end;
      inc(i);
    until (i=Ls.Count);
  Dispose(si);//since last new si is not added to TList
  CheckScript;
end;
//  Sort(SortFuncTime); //Sorted in CheckScript
end;


procedure TScript.MoveBy(dir:integer);
var
si:^TScriptItem;
i:integer;
begin
  for i:=0 to Count-1 do
  begin
    si:=items[i];
    si.Time:=si.time+dir;
//    items[i]:=si;
  end;
end;

procedure TScript.MoveClassBy(dir, ClassNum:integer);  // сдвигает время начала для каждой строки на dir (+/-)
var
si:^TScriptItem;
i:integer;
begin
  for i:=0 to Count-1 do
  begin
    si:=items[i];
    if (si^.ClassNum=ClassNum) then si^.Time:=si^.Time+Dir;
//    items[i]:=si;
  end;
end;

function TScript.SaveCurrentSMI:boolean;
begin
Result:=false;
  if FName <> '' then begin
    SaveSMI(FName);
    result:=true;
  end;
end;

procedure TScript.LoadJS(FileName:string);
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.LoadFromFile(FileName);
  ParseJS(SL, GetNewClassId, FileAge(FileName));
  sl.Free;
end;

procedure TScript.JSOneStringToScriptItem;
var i,j,k,l:integer;
Marks:array[1..6] of integer;
s2,s3:string;
begin
//Example:
//0:00:40.50 0:00:45.10 D0 {Koji} It was the summer of my fifth grade when that person suddenly appeared before my eyes.
if (Length(Str)>0) then
begin
    si.Comment:='[JS';
    j:=1;
    for k:=1 to 6 do
    begin
          while(Str[j]=' ')and(j<Length(Str)) do inc(j);
          Marks[k]:=j;
          while(not(Str[j]=' '))and(j<Length(Str)) do inc(j);
    end;
    k:=1; //Start Time
    s2:=Trim(copy(Str,Marks[k],Marks[k+1]-Marks[k]));
    si.Time:=StrToTimeMS(s2,-1,si.ElementNum);

    inc(k);//k=2 //End Time
    s2:=Trim(copy(Str,Marks[k],Marks[k+1]-Marks[k]));
    si.Length:=StrToTimeMS(s2,-1,si.ElementNum)-si.Time;

    inc(k);//k=3 //JACOSub Special Formatting/Grouping/Etc string
    s2:=Trim(copy(Str,Marks[k],Marks[k+1]-Marks[k]));
    si.Comment:=si.Comment+'('+s2+')';

//    inc(k);//k=4 //getting actor name
//    s2:=Trim(copy(Str,Marks[k],Length(Str){}));
    s3:=Trim(GetStrBetween('{','}',Str,0));
    if not(s3='') then if Length(s3)>0 then si.ActorNum:=CheckActorName(s3);

    s2:=Trim(copy(Str,Pos('}',Str)+1, Length(Str))); //Getting text line (right after actor)
    s2:=StringReplace(s2,'\n',LineBreakStr,[rfReplaceAll,rfIgnoreCase]);
    si.Line:=s2;

    si.Comment:=si.Comment+']'

{Old JS Parsing
   k:=$FFFFF;
   si.Comment:='[JS:';
   for j:=0 to 9 do
   begin
      i:=Pos(IntToStr(j),Str);  //finding first number
      if (i>0) and (k>i) then k:=i;
   end;
   if (k<$FFFF) then
   begin
      i:=NextPos(' ',Str, k);
      si.Time:=StrToTimeMS(copy(Str,k,i-k));
      l:=$FFFF;
      for j:=0 to 9 do
      begin
       k:=NextPos(IntToStr(j),Str,i);  //finding next number
       if (k>0) and (l>k) then l:=k;
      end;
      i:=NextPos(' ',Str, l); //CHECK!
      si.Length:=StrToTimeMS(copy(Str, l-1, i-l))-si.Time;

      k:=Pos('{', Str);
      l:=Pos('}{', Str);
      if (k-i>2) then
       begin
        si.Comment:=si.Comment+'['+copy(Str, i+1, Pos('{',Str)-i-1)+']';
       end;
      if (l-k-1)>0 then si.ActorNum:=CheckActorName(copy(Str, k+1, l-k-1))
       else si.ActorNum:=0; //N/A
      si.Line:=copy(Str, l+2, Length(Str)-l);
      si.Comment:=si.Comment+'Parsed'];
   end;}
end;
end;

// Загрузка  из JS
procedure TScript.ParseJS(Ls:TStringList; ClassID:string; FileDateTime:TDateTime);
var
 i:integer;
 si:^TScriptItem;
begin
  for i:=0 to Ls.Count-1 do
  begin
    if (Length(Ls.Strings[i]) > 0) then
    begin
    new(si);
    si^:=NoScriptItem;
    si^.ClassNum:=CheckClassID(ClassID);
    si^.LastChange:=FileDateTime;
    si^.Status:=_Text;
    si^.ElementNum:=i;
    if (Ls.Strings[i][1] <> '#') then
    begin
      JSOneStringToScriptItem(Ls.Strings[i], si^);
      AddScriptItemPtr(si);
    end
    else
    begin
     si^.Status:=_Other;
     si^.Line:=Ls.Strings[i];
     si^.Comment:='[JS: Comment]';
     AddScriptItemPtr(si);
    end;
    end;
  end;
 CheckScript;
end;

procedure TScript.ParseZEG(SL1:TStringList; ClassID:string; FileDateTime:TDateTime);
var i,k:integer;
j,p2:integer;
si:^TScriptItem;
s,s2,s3:string;
Stime:integer;
Marks:array[1..6] of integer;
begin
  try
    for i:=0 to SL1.Count-1 do
    begin
//Example:
//E 1 0:00:34.10 0:00:40.62 TOP {}  Nora Inu Anime\n
//Sub Visible?

 if (Length(SL1.Strings[i])>0) then
      if SL1.Strings[i][1] = 'E' then
      begin
        s:=SL1.Strings[i];
        new(si);
        si^:=NoScriptItem;
        si^.Status:=_Text;
        j:=2;

        for k:=1 to 6 do
        begin
          while(s[j]=' ')and(j<Length(s)) do inc(j);
          Marks[k]:=j;
          while(not(s[j]=' '))and(j<Length(s)) do inc(j);
        end;

        k:=1;
         s2:=Trim(copy(s,Marks[k],Marks[k+1]-Marks[k]));
//        try
//         j:=StrToInt(s2);
//        finally
//         if (j=0) then si^.Invisible:=true;
//        end;

        inc(k);//k=2 //Start Time
        s2:=Trim(copy(s,Marks[k],Marks[k+1]-Marks[k]));
        si^.Time:=StrToTimeMS(s2,-1,i);
        inc(k);//k=3 //End Time
        s2:=Trim(copy(s,Marks[k],Marks[k+1]-Marks[k]));
        si^.Length:=StrToTimeMS(s2,-1,i)-si^.Time;

        inc(k);//k=4 //getting group name
        s2:=Trim(copy(s,Marks[k],Marks[k+1]-Marks[k]));
        if not(UpperCase(s2)='DEFAULT') then
        if not(UpperCase(s2)='*DEFAULT') then si^.GroupNum:=CheckGroupName(s2);

        inc(k);//k=5 //getting actor name
        s2:=Trim(copy(s,Marks[k],Marks[k+1]-Marks[k]));
        s3:=Trim(GetStrBetween('{','}',s2,0));
        if not(s3='{}') then if Length(s3)>0 then si.ActorNum:=CheckActorName(s3);

        inc(k);//k=6 //getting text line
        s2:=Trim(copy(s,Marks[k],Length(s)));
        s2:=StringReplace(s2,'\n',LineBreakStr,[rfReplaceAll,rfIgnoreCase]);
        si^.Line:=s2;

        si.ClassNum := CheckClassID(ClassID);
//        si.Actor := copy(copy(s2, 1, pos(':', s2)-1), pos(' ', copy(s2, 1, pos(':', s2)-1))+1, 1000);
        si.UID := GetNewUID;
        AddScriptItemPtr(si);
    end;
    end;
  except
  end;
  CheckScript;
end;

function TScript.GetNearestTime(Time:longint):integer;
var i:integer;
begin
   i:=GetTimeAtIndex(GetIdxAtTime(time));
   if abs(i-time) < abs(GetTimeAtIndex(GetIdxAtTime(time)+1) - time)
   then
     Result:=GetTimeAtIndex(GetIdxAtTime(time))
   else
     Result:=GetTimeAtIndex(GetIdxAtTime(time)+1);
end;

function TScript.GetLastTime:longint;
begin
 if (Count>0) then Result:=TScriptItem(Items[Count-1]^).Time
  else Result:=0;
// GetTimeAtIndex(Count-1);
end;

function TScript.GetPlainTextAtTime(Time:longint):string;
var
si:^TScriptItem;
begin
  si:=Items[GetIdxAtTime(Time)];
  Result:=GetPlainText(si.Line);
end;

function TScript.GetPlainTextAtIndex(Index:integer):string;
var
si:^TScriptItem;
begin
  si:=Items[Index];
  Result:=GetPlainText(si.Line);
end;

function TScript.GetSavedByLevel(Level:integer):TScriptItemSaved;
begin
 Result:=[SI_Min..SI_Max]; //UID-None;
 if (Level=-1) then Result:=[SI_Min..SI_Max];
 if (Level=0) then Result:=[SI_Time, SI_Length, SI_Line, SI_Class, SI_Group]
end;

function TScript.SAMIFormattingToStr(Formatting:TSubTextFormatting):string;
begin
//N/A
//Formatting.
 Result:='';
 with Formatting do
 begin
  Result:=Result+Format('margin: %d %d %d %d',[Margin[MG_Left], Margin[MG_Right], Margin[MG_Bottom], Margin[MG_Top]]);
  Result:=Result+'; text-align: '+HAlignNameList.Strings[ord(HAlign)];
  Result:=Result+'; background-color: #'+IntToHex(BGColor, 6);
  try
  Result:=Result+'; color: #'+IntToHex(TextColors[0], 6);
  except
  end;
 end;
end;

function TScript.StrToSAMIFormatting(Str:string):TSubTextFormatting;
begin
//N/A - not yet implemented - Returns default project settings
Result:=Classes[0].Formatting^;
end;


function TScript.IfNotDefaultScriptItemValue(Value:TScriptItemValues; si:TScriptItem):boolean;
var i:integer;
begin
Result:=true;
with si do
 case Value of
   SI_Time: if(Time=NoTime) then Result:=false;
   SI_UID: if (UID=-1) then Result:=false;
   SI_Length: if (Length=NoTime) then Result:=false;
   SI_Line: if (Line='') then Result:=false;
   SI_Class: if (ClassNum=0) then Result:=false;
   SI_Actor: if (ActorNum=0) then Result:=false;
   SI_TextFlag: if (TextFlag=[]) then Result:=false;
   SI_Comment: if (Comment='') then Result:=false;
   SI_Status: if (Status=_Text) then Result:=false; //there is no _default_ status
   SI_Group: if (GroupNum=0) then Result:=false;
   SI_Formatting: if (Formatting=nil) then Result:=false;
   SI_Edition: if (Edition=0) then Result:=false;
   SI_LastChange: if (LastChange=NoScriptItem.LastChange) then Result:=false; //there was no _default_ last change date
   SI_ElementNum: if ElementNum=0 then Result:=false;
   SI_NumericData:
                begin
                Result:=false;
                for i:=0 to MaxNumericData do
                        if NumericData[i]<>0 then Result:=true;
                end;
   SI_Generated: if not(Generated) then Result:=false;
   SI_Selected: if not(Selected) then Result:=false;
   SI_Locked: if not(Locked) then Result:=false;
   SI_Invisible: if not(Invisible) then Result:=false;
   SI_Overlapping: if not(Overlapping) then Result:=false;
   //, SI_None);
 end;

end;


procedure TScript.ScriptItemToFSBStrs(IncludeWithStatus:TScriptItemStatusSet;
                                     Saved: TScriptItemSaved; si:TScriptItem;
                                     var Strs:TStringList);
var s2:string; is1:TScriptItemValues;
begin
//  Result.Clear; //should be cleared before passing to function if needed - function only adds
  if (si.Status in IncludeWithStatus) then
  with si do
  begin
    s2:={#13#10}'[#';
    case Status of
    _Text:
         begin
           s2:=s2+'SUB';
         end;
    _Other:
         begin
           s2:=s2+'OTHER';
         end;
    _Action:
         begin
           s2:=s2+'ACTION';
         end;
       _Clear:
         begin
           s2:=s2+'CLEAR';
         end;
       _Derived:
         begin
           s2:=s2+'DSUB';
         end;
       end;
       s2:=s2+']';
//       UID is added in item header (#SUB=UID, #OTHER=UID etc)
//       s2:=s2 + '=' + IntToStr(UID) +']'; //'[#SUB=UID]'
       Strs.Add(s2);
       for is1:=SI_Min to SI_Max do
       begin
        if not(is1=SI_Status) then //already included status in header
        if not(is1=SI_None) then //no need for a '=' string
        if (is1 in Saved) then
         if IfNotDefaultScriptItemValue(is1, si) then
          Strs.Add(GetScriptItemValueName(is1)+'='+GetScriptItemValueStr(is1, si));
       end;
  end
  else ;//Result not changed
end;

procedure TScript.SaveFSB(FileName:string; SaveClassNum: integer = -1);
var i:integer;
res, res_tmp:TStringList;
si:TScriptItem;
//s:string;
SaveLevel:integer;
begin
  SaveLevel:=-1; // all; should be recieved from CurrentProject property of MainForm
  res:=TStringList.Create;
  res_tmp:=TStringList.Create;
  res.add('[#STARTING FanSubber script]');
  res.add('ScriptCount=' + IntToStr(count-1));
  res.Add('Level='+IntToStr(SaveLevel));
  res.Add(#13#10);
  FName:=FileName; //CHANGE! get Filename from MainForm.CurrentProject.FSBFileName property, or better just prepare file here and save it in MainForm.CurrentProject.Save
  for i:=0 to Count-1 do
  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  begin
    si:=TScriptItem(items[i]^);

    res_tmp.Clear;
    if not(si.Generated)
{$ifndef NO_FANSUBBER}
     or (OptionsForm.cbSaveGenerated.Checked)
{$endif}
    then
    begin
    ScriptItemToFSBStrs([_Text, _Derived, _Other, _Action, _Clear],
                        GetSavedByLevel(SaveLevel), si,
                        res_tmp);
    res.AddStrings(res_tmp);
    res.Add('');
    end;

  end;
  res.add(#13#10'[#END OF FSB FILE]'#13#10);
  res.SaveToFile(FileName);
  res.free;
  res_tmp.free;
end;

procedure TScript.SaveMinimalFSB(FileName:string; SaveClassNum: integer = -1);
var i:integer;
res, res_tmp:TStringList;
si:TScriptItem;
SaveLevel:integer;
begin
  res:=TStringList.Create;
  res_tmp:=TStringList.Create;
  res.add('[#STARTING FanSubber script]');
  res.add('Minimal=true');
  res.Add(#13#10);
  for i:=0 to Count-1 do
  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  begin
    si:=TScriptItem(items[i]^);

    res_tmp.Clear;
    if not(si.Generated) then
    ScriptItemToFSBStrs([_Text],
                        GetSavedByLevel(-1), si,
                        res_tmp);
    res.AddStrings(res_tmp);
    res.Add('');
  end;
  res.add(#13#10'[#END OF FSB FILE]'#13#10);
  res.SaveToFile(FileName);
  res.free;
  res_tmp.free;
end;



function TScript.ParseFSBScriptItemHeader(str:string; var si:TScriptItem):boolean;
var sub, dsub, other, clear, action, old:integer;
begin
 sub := pos('[#SUB', UpperCase(str));
 dsub := pos('[#DSUB', UpperCase(str));
 other := pos('[#OTHER', UpperCase(str));
 clear := pos('[#CLEAR', UpperCase(str));
 action := pos('[#ACTION', UpperCase(str));
 old := pos('[#', str);

 Result:=(sub>0) or (dsub>0) or (other>0) or (clear>0) or (action>0) or (old>0);

 if (old < 3) then si.Status:=_Text; // old FSB script item starts with ' [#NUMBER]'
 if (action <> 0) then si.Status:=_Action else
 if (clear <> 0) then si.Status:=_Clear else
 if (other <> 0) then si.Status:=_Other else
 if (dsub <> 0) then si.Status:=_Derived else
 if (sub <> 0) then si.Status:=_Text;// else
 //if nothing of above, nothing is changed
 {
 if ((old=0) or (old>2)) then Result:=false
 else
 begin
  Result:=true;
  sub:=1+pos('=',str);
  dsub:=1+pos('#',str);
  clear:=pos(']',str);
  try
  if (sub>dsub) then si.UID:=StrToInt(copy(str, sub, clear-sub))
  else
  begin
   si.UID:=StrToInt(copy(str, dsub, clear-dsub));
   si.ElementNum:=si.UID; //old FSBs
  end;
  except
   si.UID:=-1;
  end;
 end;
 }
end;


procedure TScript.ParseFSB(res:TStringList);
var i, j:integer;
si:^TScriptItem;
si_tmp:TScriptItem;
name, text, DefaultClass:string;
NameVal:TScriptItemValues;
begin
  //we should parse FSB header here, but i'll implement this in future
  //ParseFSBHeader(res);
  DefaultClass:=Res.Values['ScriptClass'];
  if DefaultClass='' then DefaultClass:=GetNewClassId;
  si:=nil;
  si_tmp:=NoScriptItem;

  j:=1;
  repeat
  inc(j); //finding start of ScriptItems
  until (j>Res.Count-1) or ( ((((pos('[#SUB',res.Strings[j])<>0) or (pos('[#DSUB',res.Strings[j])<>0))
  or (((pos('[#OTHER',res.Strings[j])<>0) or(pos('[#ACTION',res.Strings[j])<>0) )))
  or (pos('[#CLEAR',res.Strings[j])<>0)) or (pos('[#SCRIPT',res.Strings[j])<>0) )
  or ((pos('[#',res.Strings[j])<3) and (pos('[#',res.Strings[j])<>0)); // string is '[#' or ' [#' (old FSB)
//  for i:=j to res.Count do

  i:=j;
  if (i<Res.Count) then
  repeat
  if (pos('[#END', res.Strings[i]) <> 1)
  then
  begin
    if (pos('[#',res.Strings[i])<3) then //0 included
    begin
    if (ParseFSBScriptItemHeader(res.Strings[i], si_tmp)) then
     begin
       if (si<>nil) then
       begin
        if (CheckForUID(si^.UID)) then si^.UID:=GetNewUID;
        if si^.ClassNum=NoScriptItem.ClassNum then si^.ClassNum:=CheckClassID(DefaultClass);
        AddScriptItemPtr(si);
       end;
       New(si);
       si^:=si_tmp;
       si_tmp:=NoScriptItem;
     end
    else
    if (si<>nil) then
    if (pos('=', res.Strings[i])<>0) then
     begin //if not header and has =, then this must be subtitle information
      name:=trim(copy(res.Strings[i], 0, pos('=', res.Strings[i])-1));
      text:=trim(copy(res.Strings[i], pos('=', res.Strings[i])+1, length(res.Strings[i]) - pos('=', res.Strings[i])));
      if (UpperCase(Name)='BLOCK') then
      begin
//       LoadFSBBlockAt(si.Time,text);
       si.Line:='Block Not Loaded: '+text;
      end
      else
      //name:=UpperCase(name);
      begin
      NameVal:=GetScriptItemValueFromName(name);
//     function GetScriptItemValueFromName(Name:string):TScriptItemValues;
//     function GetScriptItemValueStr(Value:TScriptItemValues; si:TScriptItem):string;
//     function SetScriptItemValue(Value:TScriptItemValues; Str:string; var si:TScriptItem):boolean;

      if NameVal<>SI_Line then SetScriptItemValue(NameVal, text, si^)
      else
       if si^.Line<>NoScriptItem.Line then si^.Line:=si^.Line+LineBreakStr+text
       else si^.Line:=text;
      end;
     end;
    end
  end  
  else i:=res.Count+1; //if encountered '[#END...'

//      end;
   inc(i);
  until (i>res.Count-1);//end of parsing cycle
  if (si<>nil) then
  begin
   AddScriptItemPtr(si);
  end;
//  ExtractClasses;
//  reUIDScript;
  CheckScript;
end;


function TScript.SaveCurrent:boolean;
begin
Result:=false;
  if FName <> '' then begin
    SaveFSB(FName);
    result:=true;
  end;
end;

function TScript.GetTextFlagAtTime(Time:longint):TScriptTextFlagSet;
begin
  Result:=TScriptItem(Items[GetIdxAtTime(time)]^).TextFlag;
end;

procedure TScript.SetTextFlagAtTime(f:TScriptTextFlagSet; Time:longint);
begin
  TScriptItem(Items[GetIdxAtTime(time)]^).TextFlag := f;
end;

procedure TScript.reUIDScript;
var i:integer;
begin
  for i:=0 to Count - 1 do
  begin
    TScriptItem(items[i]^).UID:=i;
  end;
end;

function TScript.GetCurrentUIDItem:TScriptItem;
begin
  if (CurrentIndex>-1) then
  Result:=TScriptItem(items[CurrentIndex]^)
  else Result:=NoScriptItem;

end;

procedure TScript.SetCurrentUIDItem(item:TScriptItem);
begin
 if (CurrentIndex>-1) then TScriptItem(items[CurrentIndex]^):=item;
end;

procedure TScript.ActivateSUBByUID(UID:integer);
var i:integer;
begin
  i:=0;
  while i < Count-1 do
  begin
    if TScriptItem(items[i]^).UID  = UID then
      begin
        CurrentIndex := i;
        i:= Count+10;
      end;
  end;
end;

function TScript.GetScriptItemByUID(UID:integer):TScriptItem;
var i:integer;
begin
 Result:=NoScriptItem;
 if UID<>-1 then
  for i:=0 to Count-1 do
  if (TScriptItem(Items[i]^).UID=UID)
   then
   begin
    Result:=TScriptItem(Items[i]^);
    break;
   end;
end;

procedure TScript.SetScriptItemByUID(UID:integer; si:TScriptItem);
var i:integer;
begin
 for i:=0 to Count-1 do
  if (TScriptItem(Items[i]^).UID=UID)
   then
   begin
    TScriptItem(Items[i]^):=si;
    break;
   end;
end;

procedure TScript.InitLanguages;
procedure AddLanguage(ID, Name:string; Charset:TFontCharset);
begin
 if (LanguagesCount<MaxLanguages) then inc(LanguagesCount);
 Languages[LanguagesCount].Name:=Name;
 Languages[LanguagesCount].ISO639ID:=ID;
 Languages[LanguagesCount].Charset:=Charset;
end;

var Language:TLanguageItem; i,j:integer; s:string;
begin

Languages[0].Name:='Default';
Languages[0].ISO639ID:='';
Languages[0].Charset:=1; //DEFAULT_CHARSET

Languages[1].Name:='Symbols';
Languages[1].ISO639ID:='';
Languages[1].Charset:=2; //SYMBOL_CHARSET


LanguagesCount:=1;

AddLanguage('aa','Afar', 1);
AddLanguage('ab','Abkhazian', 1);
AddLanguage('af','Afrikaans', 1);
AddLanguage('am','Amharic', 1);
AddLanguage('ar','Arabic', 178); //Arabic Charset
AddLanguage('as','Assamese', 1);
AddLanguage('ay','Aymara', 1);
AddLanguage('az','Azerbaijani', 1);

AddLanguage('ba','Bashkir', 1);
AddLanguage('be','Byelorussian', 1);
AddLanguage('bg','Bulgarian', 1);
AddLanguage('bh','Bihari', 1);
AddLanguage('bi','Bislama', 1);
AddLanguage('bn','Bengali; Bangla', 1);
AddLanguage('bo','Tibetan', 1);
AddLanguage('br','Breton', 1);

AddLanguage('ca','Catalan', 1);
AddLanguage('co','Corsican', 1);
AddLanguage('cs','Czech', 1);
AddLanguage('cy','Welsh', 1);

AddLanguage('da','Danish', 1);
AddLanguage('de','German', 1);
AddLanguage('dz','Bhutani', 1);

AddLanguage('el','Greek', 161); //GREEK_CHARSET
AddLanguage('en','English', 1);
AddLanguage('eo','Esperanto', 1);
AddLanguage('es','Spanish', 1);
AddLanguage('et','Estonian', 1);
AddLanguage('eu','Basque', 1);

AddLanguage('fa','Persian', 1);
AddLanguage('fi','Finnish', 1);
AddLanguage('fj','Fiji', 1);
AddLanguage('fo','Faroese', 1);
AddLanguage('fr','French', 1);
AddLanguage('fy','Frisian', 1);

AddLanguage('ga','Irish', 1);
AddLanguage('gd','Scots Gaelic', 1);
AddLanguage('gl','Galician', 1);
AddLanguage('gn','Guarani', 1);
AddLanguage('gu','Gujarati', 1);

AddLanguage('ha','Hausa', 1);
AddLanguage('he','Hebrew', 177); //HEBREW_CHARSET
AddLanguage('hi','Hindi', 1);
AddLanguage('hr','Croatian', 1);
AddLanguage('hu','Hungarian', 1);
AddLanguage('hy','Armenian', 1);

AddLanguage('ia','Interlingua', 1);
AddLanguage('id','Indonesian', 1);
AddLanguage('ie','Interlingue', 1);
AddLanguage('ik','Inupiak', 1);
AddLanguage('is','Icelandic', 1);
AddLanguage('it','Italian', 1);
AddLanguage('iu','Inuktitut', 1);

AddLanguage('ja','Japanese', 128); //Japanese SHIFT-Jis
AddLanguage('jw','Javanese', 1);

AddLanguage('ka','Georgian', 1);
AddLanguage('kk','Kazakh', 1);
AddLanguage('kl','Greenlandic', 1);
AddLanguage('km','Cambodian', 1);
AddLanguage('kn','Kannada', 1);
AddLanguage('ko','Korean', 129); //HANGEUL_CHARSET (Korean - Wansung)
AddLanguage('ks','Kashmiri', 1);
AddLanguage('ku','Kurdish', 1);
AddLanguage('ky','Kirghiz', 1);

AddLanguage('la','Latin', 1);
AddLanguage('ln','Lingala', 1);
AddLanguage('lo','Laothian', 1);
AddLanguage('lt','Lithuanian', 1);
AddLanguage('lv','Latvian, Lettish', 1);

AddLanguage('mg','Malagasy', 1);
AddLanguage('mi','Maori', 1);
AddLanguage('mk','Macedonian', 1);
AddLanguage('ml','Malayalam', 1);
AddLanguage('mn','Mongolian', 1);
AddLanguage('mo','Moldavian', 1);
AddLanguage('mr','Marathi', 1);
AddLanguage('ms','Malay', 1);
AddLanguage('mt','Maltese', 1);
AddLanguage('my','Burmese', 1);

AddLanguage('na','Nauru', 1);
AddLanguage('ne','Nepali', 1);
AddLanguage('nl','Dutch', 1);
AddLanguage('no','Norwegian', 1);

AddLanguage('oc','Occitan', 1);
AddLanguage('om','Oromo (Afan)', 1);
AddLanguage('or','Oriya', 1);

AddLanguage('pa','Punjabi', 1);
AddLanguage('pl','Polish', 1);
AddLanguage('ps','Pashto, Pushto', 1);
AddLanguage('pt','Portuguese', 1);

AddLanguage('qu','Quechua', 1);

AddLanguage('rm','Rhaeto-Romance', 1);
AddLanguage('rn','Kirundi', 1);
AddLanguage('ro','Romanian', 1);
AddLanguage('ru','Russian', 204); //RUSSIAN_CHARSET
AddLanguage('rw','Kinyarwanda', 1);

AddLanguage('sa','Sanskrit', 1);
AddLanguage('sd','Sindhi', 1);
AddLanguage('sg','Sangho', 1);
AddLanguage('sh','Serbo-Croatian', 1);
AddLanguage('si','Sinhalese', 1);
AddLanguage('sk','Slovak', 1);
AddLanguage('sl','Slovenian', 1);
AddLanguage('sm','Samoan', 1);
AddLanguage('sn','Shona', 1);
AddLanguage('so','Somali', 1);
AddLanguage('sq','Albanian', 1);
AddLanguage('sr','Serbian', 1);
AddLanguage('ss','Siswati', 1);
AddLanguage('st','Sesotho', 1);
AddLanguage('su','Sundanese', 1);
AddLanguage('sv','Swedish', 1);
AddLanguage('sw','Swahili', 1);

AddLanguage('ta','Tamil', 1);
AddLanguage('te','Telugu', 1);
AddLanguage('tg','Tajik', 1);
AddLanguage('th','Thai', 222); //THAI_CHARSET
AddLanguage('ti','Tigrinya', 1);
AddLanguage('tk','Turkmen', 1);
AddLanguage('tl','Tagalog', 1);
AddLanguage('tn','Setswana', 1);
AddLanguage('to','Tonga', 1);
AddLanguage('tr','Turkish', 162); //TURKISH_CHARSET
AddLanguage('ts','Tsonga', 1);
AddLanguage('tt','Tatar', 1);
AddLanguage('tw','Twi', 1);

AddLanguage('ug','Uighur', 1);
AddLanguage('uk','Ukrainian', 1);
AddLanguage('ur','Urdu', 1);
AddLanguage('uz','Uzbek', 1);

AddLanguage('vi','Vietnamese', 163); //VIETNAMESE_CHARSET
AddLanguage('vo','Volapuk', 1);

AddLanguage('wo','Wolof', 1);

AddLanguage('xh','Xhosa', 1);

AddLanguage('yi','Yiddish', 1);
AddLanguage('yo','Yoruba', 1);

AddLanguage('za','Zhuang', 1);
AddLanguage('zh','Chinese', 134); //GB2312_CHARSET  134 Simplified Chinese characters (mainland china).

AddLanguage('zu','Zulu', 1);

for i:=2 to LanguagesCount do
for j:=2 to LanguagesCount do
 if Languages[i].Name[1]<Languages[j].Name[1] then
 begin
  Language:=Languages[i];
  Languages[i]:=Languages[j];
  Languages[j]:=Language;
 end;

LanguageNameList:=TStringList.Create;
LanguageNameList.Add(Languages[0].Name);
LanguageNameList.Add(Languages[1].Name);

for i:=2 to LanguagesCount do
 begin
  s:=Languages[i].Name+' ('+Languages[i].ISO639ID+')';
  if Languages[i].Charset<>1 then s:=s+' *';
  LanguageNameList.Add(s);
 end;

end;

procedure TScript.InitCountries;
procedure AddCountry(Name, ID:string);
begin
 if (CountriesCount<MaxCountries) then inc(CountriesCount);
 Countries[CountriesCount].Name:=Name;
 Countries[CountriesCount].ISO3166ID:=ID;
end;
var i:integer;
begin

Countries[0].Name:='Any';
Countries[0].ISO3166ID:='';

AddCountry('AFGHANISTAN','AF');
AddCountry('ALBANIA','AL');
AddCountry('ALGERIA','DZ');
AddCountry('AMERICAN SAMOA','AS');
AddCountry('ANDORRA','AD');
AddCountry('ANGOLA','AO');
AddCountry('ANGUILLA','AI');
AddCountry('ANTARCTICA','AQ');
AddCountry('ANTIGUA AND BARBUDA','AG');
AddCountry('ARGENTINA','AR');
AddCountry('ARMENIA','AM');
AddCountry('ARUBA','AW');
AddCountry('AUSTRALIA','AU');
AddCountry('AUSTRIA','AT');
AddCountry('AZERBAIJAN','AZ');
AddCountry('BAHAMAS','BS');
AddCountry('BAHRAIN','BH');
AddCountry('BANGLADESH','BD');
AddCountry('BARBADOS','BB');
AddCountry('BELARUS','BY');
AddCountry('BELGIUM','BE');
AddCountry('BELIZE','BZ');
AddCountry('BENIN','BJ');
AddCountry('BERMUDA','BM');
AddCountry('BHUTAN','BT');
AddCountry('BOLIVIA','BO');
AddCountry('BOSNIA AND HERZEGOWINA','BA');
AddCountry('BOTSWANA','BW');
AddCountry('BOUVET ISLAND','BV');
AddCountry('BRAZIL','BR');
AddCountry('BRITISH INDIAN OCEAN TERRITORY','IO');
AddCountry('BRUNEI DARUSSALAM','BN');
AddCountry('BULGARIA','BG');
AddCountry('BURKINA FASO','BF');
AddCountry('BURUNDI','BI');
AddCountry('CAMBODIA','KH');
AddCountry('CAMEROON','CM');
AddCountry('CANADA','CA');
AddCountry('CAPE VERDE','CV');
AddCountry('CAYMAN ISLANDS','KY');
AddCountry('CENTRAL AFRICAN REPUBLIC','CF');
AddCountry('CHAD','TD');
AddCountry('CHILE','CL');
AddCountry('CHINA','CN');
AddCountry('CHRISTMAS ISLAND','CX');
AddCountry('COCOS (KEELING) ISLANDS','CC');
AddCountry('COLOMBIA','CO');
AddCountry('COMOROS','KM');
AddCountry('CONGO','CG');
AddCountry('COOK ISLANDS','CK');
AddCountry('COSTA RICA','CR');
AddCountry('COTE D''IVOIRE','CI');
AddCountry('CROATIA (local name: Hrvatska)','HR');
AddCountry('CUBA','CU');
AddCountry('CYPRUS','CY');
AddCountry('CZECH REPUBLIC','CZ');
AddCountry('DENMARK','DK');
AddCountry('DJIBOUTI','DJ');
AddCountry('DOMINICA','DM');
AddCountry('DOMINICAN REPUBLIC','DO');
AddCountry('EAST TIMOR','TP');
AddCountry('ECUADOR','EC');
AddCountry('EGYPT','EG');
AddCountry('EL SALVADOR','SV');
AddCountry('EQUATORIAL GUINEA','GQ');
AddCountry('ERITREA','ER');
AddCountry('ESTONIA','EE');
AddCountry('ETHIOPIA','ET');
AddCountry('FALKLAND ISLANDS (MALVINAS)','FK');
AddCountry('FAROE ISLANDS','FO');
AddCountry('FIJI','FJ');
AddCountry('FINLAND','FI');
AddCountry('FRANCE','FR');
AddCountry('FRANCE, METROPOLITAN','FX');
AddCountry('FRENCH GUIANA','GF');
AddCountry('FRENCH POLYNESIA','PF');
AddCountry('FRENCH SOUTHERN TERRITORIES','TF');
AddCountry('GABON','GA');
AddCountry('GAMBIA','GM');
AddCountry('GEORGIA','GE');
AddCountry('GERMANY','DE');
AddCountry('GHANA','GH');
AddCountry('GIBRALTAR','GI');
AddCountry('GREECE','GR');
AddCountry('GREENLAND','GL');
AddCountry('GRENADA','GD');
AddCountry('GUADELOUPE','GP');
AddCountry('GUAM','GU');
AddCountry('GUATEMALA','GT');
AddCountry('GUINEA','GN');
AddCountry('GUINEA-BISSAU','GW');
AddCountry('GUYANA','GY');
AddCountry('HAITI','HT');
AddCountry('HEARD AND MC DONALD ISLANDS','HM');
AddCountry('HONDURAS','HN');
AddCountry('HONG KONG','HK');
AddCountry('HUNGARY','HU');
AddCountry('ICELAND','IS');
AddCountry('INDIA','IN');
AddCountry('INDONESIA','ID');
AddCountry('IRAN (ISLAMIC REPUBLIC OF)','IR');
AddCountry('IRAQ','IQ');
AddCountry('IRELAND','IE');
AddCountry('ISRAEL','IL');
AddCountry('ITALY','IT');
AddCountry('JAMAICA','JM');
AddCountry('JAPAN','JP');
AddCountry('JORDAN','JO');
AddCountry('KAZAKHSTAN','KZ');
AddCountry('KENYA','KE');
AddCountry('KIRIBATI','KI');
AddCountry('KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF','KP');
AddCountry('KOREA, REPUBLIC OF','KR');
AddCountry('KUWAIT','KW');
AddCountry('KYRGYZSTAN','KG');
AddCountry('LAO PEOPLE''S DEMOCRATIC REPUBLIC','LA');
AddCountry('LATVIA','LV');
AddCountry('LEBANON','LB');
AddCountry('LESOTHO','LS');
AddCountry('LIBERIA','LR');
AddCountry('LIBYAN ARAB JAMAHIRIYA','LY');
AddCountry('LIECHTENSTEIN','LI');
AddCountry('LITHUANIA','LT');
AddCountry('LUXEMBOURG','LU');
AddCountry('MACAU','MO');
AddCountry('MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF','MK');
AddCountry('MADAGASCAR','MG');
AddCountry('MALAWI','MW');
AddCountry('MALAYSIA','MY');
AddCountry('MALDIVES','MV');
AddCountry('MALI','ML');
AddCountry('MALTA','MT');
AddCountry('MARSHALL ISLANDS','MH');
AddCountry('MARTINIQUE','MQ');
AddCountry('MAURITANIA','MR');
AddCountry('MAURITIUS','MU');
AddCountry('MAYOTTE','YT');
AddCountry('MEXICO','MX');
AddCountry('MICRONESIA, FEDERATED STATES OF','FM');
AddCountry('MOLDOVA, REPUBLIC OF','MD');
AddCountry('MONACO','MC');
AddCountry('MONGOLIA','MN');
AddCountry('MONTSERRAT','MS');
AddCountry('MOROCCO','MA');
AddCountry('MOZAMBIQUE','MZ');
AddCountry('MYANMAR','MM');
AddCountry('NAMIBIA','NA');
AddCountry('NAURU','NR');
AddCountry('NEPAL','NP');
AddCountry('NETHERLANDS','NL');
AddCountry('NETHERLANDS ANTILLES','AN');
AddCountry('NEW CALEDONIA','NC');
AddCountry('NEW ZEALAND','NZ');
AddCountry('NICARAGUA','NI');
AddCountry('NIGER','NE');
AddCountry('NIGERIA','NG');
AddCountry('NIUE','NU');
AddCountry('NORFOLK ISLAND','NF');
AddCountry('NORTHERN MARIANA ISLANDS','MP');
AddCountry('NORWAY','NO');
AddCountry('OMAN','OM');
AddCountry('PAKISTAN','PK');
AddCountry('PALAU','PW');
AddCountry('PANAMA','PA');
AddCountry('PAPUA NEW GUINEA','PG');
AddCountry('PARAGUAY','PY');
AddCountry('PERU','PE');
AddCountry('PHILIPPINES','PH');
AddCountry('PITCAIRN','PN');
AddCountry('POLAND','PL');
AddCountry('PORTUGAL','PT');
AddCountry('PUERTO RICO','PR');
AddCountry('QATAR','QA');
AddCountry('REUNION','RE');
AddCountry('ROMANIA','RO');
AddCountry('RUSSIAN FEDERATION','RU');
AddCountry('RWANDA','RW');
AddCountry('SAINT KITTS AND NEVIS','KN');
AddCountry('SAINT LUCIA','LC');
AddCountry('SAINT VINCENT AND THE GRENADINES','VC');
AddCountry('SAMOA','WS');
AddCountry('SAN MARINO','SM');
AddCountry('SAO TOME AND PRINCIPE','ST');
AddCountry('SAUDI ARABIA','SA');
AddCountry('SENEGAL','SN');
AddCountry('SEYCHELLES','SC');
AddCountry('SIERRA LEONE','SL');
AddCountry('SINGAPORE','SG');
AddCountry('SLOVAKIA (Slovak Republic)','SK');
AddCountry('SLOVENIA','SI');
AddCountry('SOLOMON ISLANDS','SB');
AddCountry('SOMALIA','SO');
AddCountry('SOUTH AFRICA','ZA');
AddCountry('SPAIN','ES');
AddCountry('SRI LANKA','LK');
AddCountry('ST. HELENA','SH');
AddCountry('ST. PIERRE AND MIQUELON','PM');
AddCountry('SUDAN','SD');
AddCountry('SURINAME','SR');
AddCountry('SVALBARD AND JAN MAYEN ISLANDS','SJ');
AddCountry('SWAZILAND','SZ');
AddCountry('SWEDEN','SE');
AddCountry('SWITZERLAND','CH');
AddCountry('SYRIAN ARAB REPUBLIC','SY');
AddCountry('TAIWAN, PROVINCE OF CHINA','TW');
AddCountry('TAJIKISTAN','TJ');
AddCountry('TANZANIA, UNITED REPUBLIC OF','TZ');

CountryNameList:=TStringList.Create;
for i:=0 to CountriesCount do
  CountryNameList.Add(Countries[i].Name+' ['+Countries[i].ISO3166ID+']');

end;

procedure TScript.InitScriptItemValueNames;
procedure SetVN{ValueName}(i:TScriptItemValues; Name:string; V_Type:TScriptItemValueTypes);
begin
 ScriptItemValueNames[i]:=Name;
 ScriptItemValueTypes[i]:=V_Type;
end;
var i:TScriptItemValues;
begin

 for i:=SI_Min to SI_Max do SetVN(i,'Unnamed', V_Other);
 SetVN(SI_Time,'Time', V_Numeric);
 SetVN(SI_UID,'UID', V_Numeric);
 SetVN(SI_Length,'Length', V_Numeric);
 SetVN(SI_Line,'Text', V_String);
 SetVN(SI_Class,'Class', V_String);
 SetVN(SI_Actor,'Actor', V_String);
 SetVN(SI_TextFlag,'Flag', V_String);
 SetVN(SI_Comment,'Comment', V_String);
 SetVN(SI_Status,'Status', V_String);
 SetVN(SI_Group, 'Group', V_String);
 SetVN(SI_Formatting, 'Format', V_String);
 SetVN(SI_Edition, 'Revision', V_Numeric);
 SetVN(SI_LastChange, 'LastChanged', V_String);
 SetVN(SI_ElementNum, 'ElementNumber', V_Numeric);
 SetVN(SI_NumericData, 'NumericData', V_String);
 SetVN(SI_Generated, 'Generated', V_Boolean);
 SetVN(SI_Selected, 'Selected', V_Boolean);
 SetVN(SI_Locked, 'Locked', V_Boolean);
 SetVN(SI_Invisible, 'Invisible', V_Boolean);
 SetVN(SI_Overlapping, 'Overlapping', V_Boolean);
 SetVN(SI_None, 'None', V_Other);

end;

procedure TScript.CheckOneScriptItem(var si:TScriptItem);
begin
with si do
begin
 if (UID=-1) then si.UID:=GetNewUID;
// if (si.Time=-1) then

end;

end;

function TScript.TextAttrToFontTag(Attr, DiscardAttr:TTextAttributes):string;
//var i:integer;
begin
Result:='<FONT';
with Attr do
begin
 if Color<>DiscardAttr.Color then Result:=Result+' COLOR="#'+ColorToHexStr(Color)+'"';
 if CharSet<>DiscardAttr.Charset then
  Result:=Result+' CHARSET="'+FontCharSetToString(Charset)+'"';
 if Size<>DiscardAttr.Size then
  Result:=Result+' SIZE="'+IntToStr(Size)+'pt"';
// Height (px)
 if Name<>DiscardAttr.Name then
  Result:=Result+' FACE="'+Name+'"';
//              Pitch
//              Protected
//              Style (sorry, style is not in font tag... yet)
end;
Result:=Result+'>';
if Result='<FONT>' then Result:=''; //nothing within tag - tag discarded
end;

function FindFirstPosOfCharBefore(subchar:char; str:string; psn: integer):integer;
var i:integer; Found:boolean;
begin
Found:=false;
 for i:=psn downto 1 do
  if str[i]=subchar then
  begin
   Found:=true;
   break;
  end;
 if not(Found) then Result:=0 else Result:=i;
end;

function FindFirstPosOfCharAfter(subchar:char; str:string; psn: integer):integer;
var i:integer; Found:boolean;
begin
Found:=false;
 for i:=psn to Length(str) do
  if str[i]=subchar then
  begin
   Found:=true;
   break;
  end;
 if not(Found) then Result:=Length(str) else Result:=i;
end;

procedure{function} TScript.FontTagToTextAttr(FontTag:string;var Base:TRichEdit);//:TTextAttributes;
var s1, s2:string; i, j, t, StartOfTagValue, EndOfTagValue, EndOfValueName, StartOfValueName:integer;
begin
// Result:=Base;
 j:=Pos('=',FontTag);
 while (j>1) do
 begin
  StartOfValueName:=FindFirstPosOfCharBefore(' ', FontTag, j)+1;
  EndOfValueName:=j-1;
  if FontTag[j+1]='"' then
   begin
    StartOfTagValue:=j+2;
    EndOfTagValue:=FindFirstPosOfCharAfter('"', FontTag, j+2);
   end
  else
   begin
    StartOfTagValue:=j+1;
    EndOfTagValue:=j+1;
    while not(IsDelimiter(' >', FontTag, EndOfTagValue)) and (EndOfTagValue<Length(FontTag))
    do Inc(EndOfTagValue);
//    if FindFirstPosOfCharAfter(' ', FontTag, j)<FindFirstPosOfCharAfter('', FontTag, j)
//    EndOfTagValue:=FindFirstPosOfCharAfter(' ', FontTag, j);
   end;
  s1:=copy(FontTag, StartOfValueName, EndOfValueName-StartOfValueName+1);
  s2:=copy(FontTag, StartOfTagValue, EndOfTagValue-StartOfTagValue);
  s1:=UpperCase(s1);
//  if (CompareStr(UpperCase(s1),'COLOR')=0) then
  if (s1='COLOR') then
   begin
    Base.SelAttributes.Color:=ColorStrToInt(s2);
   end;
//  if (CompareStr(UpperCase(s1),'CHARSET')=0) then
//  if (UpperCase(s1)='CHARSET') then
  if (s1='CHARSET') then
   begin
    if IdentToCharset(s2+'_CHARSET', t) then
     Base.SelAttributes.Charset:=t;
   end;
//  if (CompareStr(UpperCase(s1),'SIZE')=0) then
//  if (UpperCase(s1)='SIZE') then
  if (s1='SIZE') then
   begin
    t:=Pos('pt', LowerCase(s2));
    if t>0 then
      Base.SelAttributes.Size:=StrToInt(copy(s2,1,Length(s2)-t))
     else
     begin
      t:=Pos('px', LowerCase(s2));
      if t>0 then Base.SelAttributes.Height:=StrToInt(copy(s2,1,Length(s2)-t))
      else Base.SelAttributes.Size:=StrToInt(s2);
     end;
   end;
//  if (CompareStr(UpperCase(s1),'FACE')=0) then
//  if (UpperCase(s1)='FACE') then
  if (s1='FACE') then
            Base.SelAttributes.Name:=s2;

  i:=EndOfTagValue+1;
  j:=NextPos2('=', FontTag, i);
 end;
end;

function TScript.ColorToHexStr(Color:TColor):string;
begin
 Result:=Copy(Format ('%.6x', [Color]), 5, 2) +
              Copy(Format ('%.6x', [Color]), 3, 2) +
              Copy(Format ('%.6x', [Color]), 1, 2);
end;

function TScript.FontCharsetToString(Charset:TFontCharset):string;
var s1:string;
begin
 if not(CharsetToIdent(CharSet, s1)) then Result:='';
 if pos('_CHARSET',UpperCase(s1))<>0 then
  Result:=Result+copy(s1, 1, pos('_CHARSET',UpperCase(s1))-1);
end;

function TScript.ColorStrToInt(Color:string):integer;
var t:integer;
begin
 Result:=clWhite;
 if LowerCase(Color)='aqua' then Result:=clAqua;
 if LowerCase(Color)='black' then Result:=clBlack;
 if LowerCase(Color)='blue' then Result:=clBlue;
 if LowerCase(Color)='purple' then Result:=clPurple;
 if LowerCase(Color)='darkgray' then Result:=clDkGray;
 if LowerCase(Color)='fuchsia' then Result:=clFuchsia;
 if LowerCase(Color)='gray' then Result:=clGray;
 if LowerCase(Color)='green' then Result:=clGreen;
 if LowerCase(Color)='lime' then Result:=clLime;
 if LowerCase(Color)='lightgray' then Result:=clLtGray;
 if LowerCase(Color)='maroon' then Result:=clMaroon;
 if LowerCase(Color)='navy' then Result:=clNavy;
 if LowerCase(Color)='olive' then Result:=clOlive;
 if LowerCase(Color)='red' then Result:=clRed;
 if LowerCase(Color)='silver' then Result:=clSilver;
 if LowerCase(Color)='teal' then Result:=clTeal;
 if LowerCase(Color)='yellow' then Result:=clYellow;

 if LowerCase(Color)='white' then Result:=clWhite
 else
 if (Result=clWhite) then
 begin
  try
 if Color[1]='#' then t:=1 else t:=0;
    if t=1 then Result:=StrToInt('0x'+copy(Color, 5+t, 2)
                        +copy(Color, 3+t, 2)
                        +copy(Color, 1+t, 2))
        else Result:=StrToInt(Color);
  except
   on EConvertError do
   begin
    Result:=clWhite;
    NotifyError(Color+' is not a valid color - assuming White');
   end;
  end;
 end;

end;

//function TScript.GetTagInfoAfter(Str1, TagName1:string; StrtPos:integer):THTMLTagInfo;
function TScript.GetTagInfoAfter(Str1, TagName1:string; StrtPos:integer; Nested: boolean = TRUE):THTMLTagInfo;
var i,j,k,l, ctr:integer; tx, ts:string;
begin
{type THTMLTagInfo = record
                     TagDefStart, TagDefEnd, TagZoneStart, TagZoneEnd: integer;
                     Name:string;
                    end;}
tx:=LowerCase(Str1);
ts:=LowerCase(TagName1);
i:=NextPos2('<'+ts, tx, StrtPos);
{if i<>0 then} Result.TagDefStart:=i;
j:=NextPos2('>', tx, i+1);
Result.TagDefEnd:=j;
Result.TagZoneStart:=j+1;
//j:=i; //???
k:=0;
ctr:=0;
if Nested then //can be <TAG> 1 <TAG> 2 </TAG> 3 </TAG> and these cases should be handled correctly
begin
 l:=NextPos2('<'+ts, tx, j);
 k:=NextPos2('</'+ts, tx, j);

 if k=0 then Result.TagZoneEnd:=Length(tx)+1
 else
  begin
   if (k<l) or (l=0) then
    begin
     Result.TagZoneEnd:=k{+3+Length(ts)}; //position BEFORE - X</TAG>
    end
    else
    begin
{     inc(ctr);}
     repeat
//     j:=l+1;
     l:=NextPos2('<'+ts, tx, l);
     k:=NextPos2('</'+ts, tx, k);
{     if (l<k) or (l=0) then dec(ctr);
     if (l>k) then inc(ctr);}
     until (k=0) or (k<l) or (l=0);
     if k=0 then Result.TagZoneEnd:=Length(tx)
     else {k<l} Result.TagZoneEnd:=k{+3+Length(ts)}; //position BEFORE - X</TAG>
    end;
  end;
end
else
begin
 l:=NextPos2('<'+ts, tx, j);
 if (l>0) then Result.TagZoneEnd:=l
 else Result.TagZoneEnd:=Length(tx);
end;
 Result.Name:=ts;
end;

function TScript.GetPlainPos(Line:string; LinePos:integer):integer;
var InTag:boolean; i:integer;
begin
 Result:=0;
 InTag:=false;
 if not(LinePos>Length(Line)) then
 for i:=1 to LinePos do
  begin
   if (i<LinePos) and not(InTag) and (Line[i]='<') then InTag:=true;
   if not(InTag) then inc(Result);
   if (InTag) and (Line[i]='>') then InTag:=false;
  end
 else
  Result:=Length(Line)+1;
end;

function TScript.GetPlainText(Line:string):string;
var InTag:boolean; i:integer;
begin
 Result:='';
 InTag:=false;
 i:=1;
 while (i<Length(Line)+1) do
 begin
   if not(InTag) and (Line[i]='<') then InTag:=true;
   if not(InTag) then Result:=Result+Line[i];
   if (InTag) and (Line[i]='>') then InTag:=false;
   inc(i);
 end;
end;

function TScript.GetPlainLines(Line:string):string;
var InTag:boolean; i:integer; s:string;
begin
 Result:='';
 InTag:=false;
 s:=StringReplace(Line,LineBreakStr,#13#10,[rfReplaceAll,rfIgnoreCase]);
 for i:=1 to Length(s) do
  begin
   if not(InTag) and (s[i]='<') then
    begin
     InTag:=true;
{      if (Pos(UpperCase(copy(Line, i, Length(LineBreakStr))), UpperCase(LineBreakStr))>0) then
          Result:=Result+#13#10;}
    end;
   if not(InTag) then Result:=Result+s[i];
   if (InTag) and (s[i]='>') then InTag:=false;
  end;
end;


function TScript.GetStrBetween(SubStr1, Substr2, Str:string; StartPos:integer):string;
var i,j:integer;
begin
 i:=NextPos2(SubStr1, Str, StartPos);
 j:=NextPos2(SubStr2, Str, i);
 if (i>0) and (j>0) then
  Result:=copy(Str, i+1, j-i-1)
 else Result:='';
end;

function TScript.TimeMSToStr(Time:longint; OutType:integer=0; Delimeter:char=','):string;
var t1, t2, t3, t4:integer;
begin
 case OutType of
  0: Result:=IntToStr(Time); //ms
  1: Result:=IntToStr(Time div 1000) + Delimeter + Format('%3.3d',[Time mod 1000]);
  2:
     begin
      t1:=Time div 60000;
      t2:=(Time - t1*60000) div 1000;
      t3:=(Time - t1*60000) - t2*1000;
//      Result:=IntToStr(t1)+':'+IntToStr(t2)+'.'+IntToStr(t3);
      Result:=Format('%2.2d:%2.2d%s%3.3d', [t1,t2,Delimeter, t3]);
     end;
  3:
     begin
      t1:=Time div (60000*60);
      t2:=(Time - t1*60000*60) div 60000;
      t3:=(Time - t1*60000*60 - t2*60000) div 1000;
      t4:=(Time - t1*60000*60 - t2*60000 - t3*1000);
//      Result:=IntToStr(t1)+':'+IntToStr(t2)+':'+IntToStr(t3)+'.'+IntToStr(t4);
      Result:=Format('%2.2d:%2.2d:%2.2d%s%3.3d', [t1, t2, t3, Delimeter, t4]);
     end;
  4: //SSA output 0:00:00.00
     begin
      t1:=Time div (60000*60);
      t2:=(Time - t1*60000*60) div 60000;
      t3:=(Time - t1*60000*60 - t2*60000) div 1000;
      t4:=(Time - t1*60000*60 - t2*60000 - t3*1000) div 10;
//      Result:=IntToStr(t1)+':'+IntToStr(t2)+':'+IntToStr(t3)+'.'+IntToStr(t4);
      Result:=Format('%1.1d:%2.2d:%2.2d%s%2.2d', [t1, t2, t3, Delimeter, t4]);
     end;
 end;
end;

procedure TScript.SaveSRT(FileName:string; SaveClassNum: integer = -1);
var i, p:integer;
t1, t2, t3:integer;
st1, st2:string;
tmpText:TStringList;
begin
 p:=1;
 tmpText:=TStringList.Create;
 for i:=0 to Count-1 do begin
   if (TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
   if (TScriptItem(Items[i]^).Line <> TextIsClearStr) then
   if (TScriptItem(Items[i]^).Time>0) then
   if (TScriptItem(Items[i]^).Status = _Text) then
   begin
     tmpText.Add(IntToStr(p));
     inc(p);
       st1:=TimeMSToStr(TScriptItem(Items[i]^).Time, 3);
       st2:=TimeMSToStr(TScriptItem(Items[i]^).Time+TScriptItem(Items[i]^).Length, 3);

     tmpText.Add(st1+' --> '+st2);
     tmpText.Add(StringReplace(Trim(StringReplace(GetPlainText(GetTextAtIndex(i)),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase])),
                 '&quot;','"',[rfReplaceAll,rfIgnoreCase]));
     tmpText.Add('');
   end;
 end;
 tmpText.SaveToFile(FileName);
 tmpText.free();
end;

procedure TScript.SaveRT(FileName:string; SaveClassNum: integer = -1);
var
i:integer;
dest:TStringList;
tm, tm2:integer;
begin
  dest := TStringList.Create;
  dest.add('<window type="generic" duration="' + TimeMSToStr(GetLastTime,3,'.') + '" width="'+IntToStr(SubWidth)+'" height="'+IntToStr(SubHeight)+'" bgcolor="#000000" wordwrap="true" />');
  dest.add('<font face="Arial Cyr" color="#'+ColorToHexStr(Classes[0].Formatting^.TextColors[0])+'" size="3">');
//  Classes[0].Formatting^.TextColors[0]
  dest.add('<center>');

  for i:=0 to Count-1 do
  if (TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  begin
//    if (TScriptItem(Items[i]^).PIClass = PClass) or (PClass = '*')
//         then
     if (TScriptItem(Items[i]^).Status in [_Text, _Clear]) then
         begin
         tm := TScriptItem(Items[i]^).time;
         tm2 := TScriptItem(Items[i]^).Time+TScriptItem(Items[i]^).Length;
         if tm > 0 then
         begin
//           dest.add(Format('<time begin="%2.2d:%2.2d.%1d"><clear/>%s',
//           [tm div 60000, (tm div 1000) mod 60, (tm mod 1000) div 100,  TScriptItem(Items[i]^).Line]));
//           dest.add(Format('<time begin="%s" end="%s"><clear/>%s', [TimeMSToStr(tm, 3, '.'), TimeMSToStr(tm2, 3, '.'),  TScriptItem(Items[i]^).Line]));
             dest.add(MakeOneRTSubtitleSE(tm, tm2,TScriptItem(Items[i]^).Line));
//             dest.add(MakeOneRTSubtitleS(tm,TScriptItem(Items[i]^).Line));
//             dest.add(MakeOneRTSubtitleS(tm2,'&nbsp;'));

//           tm := TScriptItem(Items[i]^).time+TScriptItem(Items[i]^).Length;
//           dest.add(Format('<time begin="%2.2d:%2.2d.%1d"><clear/>&nbsp;',
//           [tm div 60000, (tm div 1000) mod 60, (tm mod 1000) div 100]));
//           dest.add(Format('<time begin="%s"><clear/>&nbsp;', [TimeMSToStr(tm, 3, '.')]));

         end;
//      dest.add('<time begin="' + msToMS(TScriptItem(Items[i]^).Time) + '"><clear/> '+ TScriptItem(Items[i]^).Line);
//      dest.add('<time begin="' + msToMS(TScriptItem(Items[i]^).Time+TScriptItem(Items[i]^).Length) + '"><clear/> &nbsp;');
              end;
  end;
//  dest.add(Format('<time begin="%s"><clear/>&nbsp;', [TimeMSToStr(TScriptItem(Items[i-1]^).time+TScriptItem(Items[i-1]^).Length, 3, '.')]));
  dest.add('</center>');
  dest.add('</window>');
  dest.SaveToFile(FileName);
end;

function TScript.CheckForUID(CheckedUID:integer):boolean;
var i:integer;
begin
 Result:=false;
 i:=0;
 if (CheckedUID>MaxUID) then
 begin
  Result:=false;
  MaxUID:=CheckedUID;
 end
 else
 while (i<Count) and not(Result) do
 begin
  Result:=(TScriptItem(Items[i]^).UID=CheckedUID);
  inc(i);
 end;
end;

procedure TScript.ClearFree;
var i:integer; SI:^TScriptItem;
begin
 i:=0;
 while (i<Count) do DeleteAndFree(i);
// inherited Clear;
 for i:=1 to ClassesCount-1 do //retaining formatting for 0 class (defaults)
  if Classes[i].Formatting<>nil then
  begin
//   SetLength(Classes[i].Formatting^.TextColors,0);
   Dispose(Classes[i].Formatting);
   Classes[i].Formatting:=nil;
  end;
 for i:=0 to GroupsCount-1 do
  if Groups[i].Formatting<>nil then
  begin
  try
   Dispose(Groups[i].Formatting);
  finally
   Groups[i].Formatting:=nil;
  end;
  end;
 Clear;
 ActorsCount:=0;
 ClassesCount:=0;
 GroupsCount:=0;
 ErrorLog.Clear;
 Log.Clear;
 ActorsList.Clear;
 GroupsList.Clear;
 ClassesList.Clear;
 SetLength(TimeSlice,0);
 SetLength(TimeRegionsCnt,0);
 
end;

procedure TScript.PartialClearFree;
var i:integer; SI:^TScriptItem;
begin
 i:=0;
 while (i<Count) do DeleteAndFree(i);
// inherited Clear;
{ for i:=1 to ClassesCount-1 do //retaining formatting for 0 class (defaults)
  if Classes[i].Formatting<>nil then
  begin
   SetLength(Classes[i].Formatting^.TextColors,0);
   Dispose(Classes[i].Formatting);
   Classes[i].Formatting:=nil;
  end;
 for i:=0 to GroupsCount-1 do
  if Groups[i].Formatting<>nil then
  begin
   Dispose(Groups[i].Formatting);
   Groups[i].Formatting:=nil;
  end;
 Clear;
 ActorsCount:=0;
 ClassesCount:=0;
 GroupsCount:=0;}
 ErrorLog.Clear;
 Log.Clear;
{ ActorsList.Clear;
 GroupsList.Clear;
 ClassesList.Clear;}
end;


procedure TScript.DeleteAndFree(Idx:integer);
var si:^TScriptItem;
begin
 if (Count>Idx) then
 begin
  si:=Items[Idx];
  si^.Line:='';
  si^.Comment:='';
  Delete(Idx);
{$ifndef NO_FANSUBBER}
  if si^.FINDER<>nil then FreeAndNil(si^.FINDER);// si^.FINDER.Free;
{$endif}
  Dispose(si);
  si:=nil;
 end;
end;

destructor TScript.Free;
var i:integer;
begin
 ClearFree;
 ActorsList.Free;
 GroupsList.Free;
 ClassesList.Free;
  if Classes[0].Formatting<>nil then //destroy default formatting when destroying script
  begin
//   SetLength(Classes[0].Formatting^.TextColors,0);
   Dispose(Classes[0].Formatting);
   Classes[0].Formatting:=nil;
  end;
 ScriptItemStatusList.Free;
 LanguageNameList.Free;
 CountryNameList.Free;
 HAlignNameList.Free;
 VAlignNameList.Free;
 ErrorLog.Free;
 Log.Free;
 SetLength(SubRects,0);
 SetLength(LastScriptIndexes,0);
// inherited Free;
end;

procedure TScript.CheckOverlapping;
var i,j:integer; si1, si2:^TScriptItem;
begin
{$ifndef NO_FANSUBBER}
 for j:=1 to ClassesCount do
 begin
  i:=0;
  while (i<Count) do
  begin
   if TScriptItem(Items[i]^).ClassNum=j then
   if TScriptItem(Items[i]^).Time>-1 then
   if TScriptItem(Items[i]^).Finder.Next<>nil then
   begin
    si1:=Items[i];
    si2:=Items[(si1.Finder.Next as TScriptItemFinder).Idx];
//    if TScriptItem(Items[TScriptItem(Items[i]^).Finder.Next.Idx]^).Time<
    if (si1^.Status<>_Clear) then
    if (si2^.Status<>_Clear) then //maybe this one should be checked... maybe not...
    if (si2^.Time>=si1^.Time) and (si2^.Time<=si1^.Time+si1^.Length-5) then
{    if (si2^.Time<=si1^.Time+si1^.Length-MaxUnfilledGap) then}
    begin
     si1^.Overlapping:=true;
     si2^.Overlapping:=true;
    end
    else
    begin
     si1^.Overlapping:=false;
//     si2^.Overlapping:=false;
    end;
   end
   else TScriptItem(Items[i]^).Overlapping:=false;
  inc(i);
  end;
 end;
{$endif}
end;

function TScript.IsWithin(Time, Start, Length:longint):boolean;
begin
 Result:=(Time>=Start) and (Time<=Start+Length);
end;

//returns true if they differ, false otherwise
function TScript.ScriptItemDifferenceToLog(si1, si2:TScriptItem; ActionStr: string):boolean;
var log_strs:TStringList;
    i:TScriptItemValues;
    s1, s2:string;
begin
 log_strs:=TStringList.Create;

 if (si1.UID<>-1) and (si1.FINDER<>nil) then //only applies to existing script items
 if (si2.UID<>-1) and (si2.FINDER<>nil) then
 for i:=SI_Min to SI_Max do
 begin
  s1:=GetScriptItemValueStr(i, si1);
  s2:=GetScriptItemValueStr(i, si2);
  if s1<>s2 then
   begin
    if (log_strs.Count=0) then
    begin
     log_strs.Add('['+TimeToStr(Time)+' '+DateToStr(Date)+']');
     log_strs.Add(ActionStr+' Script Item в '+IntToStr(si1.Time)+' (UID:'+IntToStr(si1.UID)+')');
    end;
    log_strs.Add('Различается:'+GetScriptItemValueName(i));
    log_strs.Add('Было :'+GetScriptItemValueStr(i, si1));
    log_strs.Add('Стало:'+GetScriptItemValueStr(i, si2));
   end;
 end;
// else ShowMessage('Cannot CHANGE Inexistant Script Item - use ADD.');
 if (log_strs.Count>0) then
 begin
  log_strs.Add('');
  Log.AddStrings(log_strs);
//!  TextSourceView.LogUpdate;
  Result:=true;
 end
 else Result:=false;
 log_strs.free;

end;

function TScript.GetTagValue(TagString, Value:string):string;
var i,j,k:integer; s:string;
begin
 s:='';
 i:=Pos(UpperCase(Value+'='), UpperCase(TagString));
 Result:='';
 if (i>0) then
 begin
  j:=i+Length(Value)+1; //next character after =
  k:=j;
  if (TagString[j]='"') or (TagString[j]='''')
  then //Uses brackets - including everything between brackets
  begin
   Result:=copy(TagString, j+1, NextPos2(TagString[j], TagString, j) - j -1);
   if (Result='') then //no matching brackets - probably misplaced "
   begin
   inc(k); //skipping erroneus bracket
   while not(IsDelimiter(' >"''/', TagString, k))do
   begin
    Result:=Result+TagString[k];
    inc(k);
    if (k>Length(TagString)) then break;
   end;
   end;
  end
  else
   while not(IsDelimiter(' >"''/', TagString, k))do
   begin
    Result:=Result+TagString[k];
    inc(k);
    if (k>Length(TagString)) then break;
   end;
 end;
// else Result:='';
end;

function TScript.GetScriptItemValueType(Value:TScriptItemValues):TScriptItemValueTypes;
begin
 Result:=V_Other;
 if Value<SI_None then Result:=ScriptItemValueTypes[Value];
end;

//procedure TScript.ParseLineAs(Line:string; StringType:integer);

procedure TScript.NotifyError(ErrorString:string);
begin
 ErrorLog.Add(TimeToStr(Time)+': Error: '+ErrorString);
end;

procedure TScript.NotifyWarning(WarningString:string);
begin
 ErrorLog.Add(TimeToStr(Time)+': Warning: '+WarningString);
end;

function TScript.GetOverlap(Start1, Length1, Start2, Length2:longint):longint;
begin
 if (IsWithin(Start2, Start1, Length1) and IsWithin(Start2+Length2, Start1, Length1))
 then Result:=Length2 //fits entirely
 else
 if (IsWithin(Start2, Start1, Length1) and not(IsWithin(Start2+Length2, Start1, Length1)))
 then Result:=abs(Start2-(Start1+Length1)) //starting portion fits
 else
 if (not(IsWithin(Start2, Start1, Length1)) and (IsWithin(Start2+Length2, Start1, Length1)))
 then Result:=abs((Start2+Length2)-Start1) //ending portion fits
 else Result:=0; //does not fits
 if (Result=0) then
 begin
  if (IsWithin(Start1, Start2, Length2) and IsWithin(Start1+Length1, Start2, Length2))
  then Result:=Length1 //fits entirely
  else
  if (IsWithin(Start1, Start2, Length2) and not(IsWithin(Start1+Length1, Start2, Length2)))
  then Result:=abs(Start1-(Start2+Length2)) //starting portion fits
  else
  if (not(IsWithin(Start1, Start2, Length2)) and (IsWithin(Start1+Length1, Start2, Length2)))
  then Result:=abs((Start1+Length1)-Start2) //ending portion fits
  else Result:=0; //does not fits
 end;

end;

procedure TScript.CreateTimeSlices;//(TimeSlice:array of longint);
var i,j,k,KillCnt:integer; TmpLInt:longint; TR:TTimeRegion;// TimeSlice:array of longint;
begin
//     procedure CreateTimeSlices(AcceptStatus:TScriptItemStatusSet, ClassNum =-1);//(TimeSlice:array of longint);

SetLength(TimeSlice, Count*2+1); //make it so that TimeSlice[0] is always 0

for i:=0 to Length(TimeSlice)-1 do TimeSlice[i]:=0;

 i:=0;
 while (i<Count) do
 begin
 if not(TScriptItem(Items[i]^).Time<0) then //items below zero are not included
 if (TScriptItem(Items[i]^).Status in AcceptStatus) then
 if not(ClassNum>0) or (TScriptItem(Items[i]^).ClassNum=ClassNum) then
 if not(TScriptItem(Items[i]^).Invisible) then
  begin
   TimeSlice[i*2+1]:=StartTime[i];
   TimeSlice[i*2+2]:=EndTime[i];
  end;
  inc(i);
 end;
 //we will have zeroes for non-included items, but they'll be removed as duplicates

 //TimeSlice is filled, and we don't need anything else from Script

 i:=0; KillCnt:=0;
 while(i<Length(TimeSlice)) do
 begin
 j:=i+1;
 while(j<Length(TimeSlice)-KillCnt) do
 begin
   if not(TimeSlice[j]<0) then
   if (TimeSlice[j]=TimeSlice[i]) then
  //removing duplicate items
   begin
    for k:=j to Length(TimeSlice)-2-KillCnt do TimeSlice[k]:=TimeSlice[k+1];
    inc(KillCnt);
//    SetLength(TimeSlice,Length(TimeSlice)-1);
   end
   else inc(j)
   else inc(j);
 end;
 inc(i);
 end;

 SetLength(TimeSlice,Length(TimeSlice)-KillCnt);

//slice without duplicates created
//now performing sort
 for i:=0 to Length(TimeSlice)-1 do
 for j:=0 to Length(TimeSlice)-2 do
  if (TimeSlice[j]>TimeSlice[j+1]) then
  begin
   TmpLInt:=TimeSlice[j];
   TimeSlice[j]:=TimeSlice[j+1];
   TimeSlice[j+1]:=TmpLInt;
  end;

//region blend (for small regions) should be performed on higher level
//as ScriptItem properties should be taken into consideration
 SetLength(TimeRegionsCnt, Length(TimeSlice)-1);

 for i:=0 to Length(TimeRegionsCnt)-1 do TimeRegionsCnt[i]:=0;

 i:=0;
 while(i<Count) do
 begin
 if not(TScriptItem(Items[i]^).Time<0) then //items below zero are not included
 if (TScriptItem(Items[i]^).Status in AcceptStatus) then
 if not(ClassNum>0) or (TScriptItem(Items[i]^).ClassNum=ClassNum) then
 if not(TScriptItem(Items[i]^).Invisible) then
 begin
  j:=0;
  while(j<Length(TimeSlice)-1) do
  begin
   TR.TimeStart:=TimeSlice[j];
   TR.TimeEnd:=TimeSlice[j+1];
    if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart,
                  TScriptItem(Items[i]^).Time, TScriptItem(Items[i]^).Length)>5 then //5 ms is just arbitrary value for testing purposes
                  inc(TimeRegionsCnt[j]);
   inc(j);
  end;
 end;
 inc(i);
 end;

end;

procedure TScript.SaveAs(FileName:string;SubtitleType:TSubType; ClassNum:integer=-1);
var TR, LastTR:TTimeRegion; i,j,k, Num, FirstActive:integer; Str, FinalStr:string; FileStream:TFileStream;
begin
 FinalStr:='';
 case SubtitleType of
 SUB_SRT_EXTENDED,
  SUB_SRT:{if ClassesCount=1 then }
          begin //сохранение с учетом перекрытия
          Num:=1;
          if (UniteCrossedIfNeeded) then
          begin
           CreateTimeSlices([_Text,_Derived], ClassNum);
           if (Length(TimeSlice)>1) then
           begin
            for j:=0 to Length(TimeSlice)-2 do
            begin
             TR.TimeStart:=TimeSlice[j];
             TR.TimeEnd:=TimeSlice[j+1];
            if (TR.TimeEnd-TR.TimeStart>5) then
            begin
             Str:='';
             for FirstActive:=0 to Count-1 do
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart,
                            TScriptItem(Items[FirstActive]^).Time, TScriptItem(Items[FirstActive]^).Length)>5
              then break;

             for i:=FirstActive to Count-1 do
             begin
              if (TScriptItem(Items[i]^).Time>TR.TimeEnd) then break;//since everything is sorted by Time, there can be no items beyond this point that can fit
              if not(ClassNum>0) or (TScriptItem(Items[i]^).ClassNum=ClassNum) then
              if (TScriptItem(Items[i]^).Status in [_Text, _Derived]) then
              if not(TScriptItem(Items[i]^).Invisible) then
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart, TScriptItem(Items[i]^).Time, TScriptItem(Items[i]^).Length)>5 then //5 ms is just arbitrary value for testing purposes
              if (SubtitleType=SUB_SRT) then
              begin
              if (UniteOrderForward) then Str:=Str+GetPlainLines(_SI[i].Line)+#13#10
                                     else Str:=GetPlainLines(_SI[i].Line)+#13#10+Str;
              end
              else
              if (SubtitleType=SUB_SRT_EXTENDED) then
              if (UniteOrderForward) then Str:=Str+_SI[i].Line+#13#10
                                     else Str:=_SI[i].Line+#13#10+Str;
             end;
             Str:=StringReplace(Str,TextIsClearStr,'',[rfReplaceAll,rfIgnoreCase]);
             Str:=Trim(Str);
             if (Str<>'') then
             begin

              if (SubtitleType=SUB_SRT) then
              FinalStr:=FinalStr+MakeOneSRTSubtitle(Num,TR.TimeStart,TR.TimeEnd,Str);
              if (SubtitleType=SUB_SRT_EXTENDED) then
              FinalStr:=FinalStr+MakeOneExtendedSRTSubtitle(Num,TR.TimeStart,TR.TimeEnd,Str);
              //if next region is non-zero then TimeEnd should be 1 ms short of next region... just in case
              inc(Num);
             end;
            end;
            end;
            end
            else
            for i:=0 to Count-1 do
            begin
             Str:=GetPlainLines(TScriptItem(Items[i]^).Line);
             Str:=StringReplace(Str,TextIsClearStr,'',[rfReplaceAll,rfIgnoreCase]);
             Str:=Trim(Str);
             if (Str<>'') then
             begin
              FinalStr:=FinalStr+MakeOneSRTSubtitle(Num,StartTime[i],EndTime[i],Str);
              inc(Num);
             end;
            end;
            FinalStr:=StringReplace(FinalStr,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
            FinalStr:=StringReplace(FinalStr,#9,'',[rfReplaceAll]);
            FinalStr:=Trim(FinalStr)+#13#10#13#10; //final SRT empty line
            try
            FileStream:=TFileStream.Create(FileName, fmCreate);
            FileStream.Write(PChar(FinalStr)^, Length(FinalStr));
            FileStream.Free;
            except
            end;
           end;
          end;
  SUB_SAMI:begin //сохранение с учетом перекрытия
           CreateTimeSlices([_Text,_Derived], ClassNum);
           FinalStr:=GetSlicedSAMI(ClassNum);

           if (Length(TimeSlice)>1) then
           begin
           { FinalStr:=SAMIHeaderForClassToStr(ClassNum, FileName);
            for j:=0 to Length(TimeSlice)-2 do
            begin
             TR.TimeStart:=TimeSlice[j];
             TR.TimeEnd:=TimeSlice[j+1];
            if (TR.TimeEnd-TR.TimeStart>5) then
            begin
             Str:='';
             for FirstActive:=0 to Count-1 do
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart,
                            TScriptItem(Items[FirstActive]^).Time, TScriptItem(Items[FirstActive]^).Length)>5
              then break;

             for i:=FirstActive to Count-1 do
             begin
              if (TScriptItem(Items[i]^).Time>TR.TimeEnd) then break;//since everything is sorted by Time, there can be no items beyond this point that can fit
              if not(ClassNum>0) or (TScriptItem(Items[i]^).ClassNum=ClassNum) then
              if (TScriptItem(Items[i]^).Status in [_Text, _Derived, _Clear]) then
              if not(TScriptItem(Items[i]^).Invisible) then
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart, TScriptItem(Items[i]^).Time, TScriptItem(Items[i]^).Length)>5 then //5 ms is just arbitrary value for testing purposes
              if (Length(Str)>0) then Str:=Str+'<BR>'+(TScriptItem(Items[i]^).Line)
               else Str:=(TScriptItem(Items[i]^).Line);
             end;
             Str:=Trim(Str);
             if (Str<>'') then
             begin
              FinalStr:=FinalStr+MakeOneSAMISubtitle(ClassNum,TR.TimeStart,Str)+#13#10;
              LastTR:=TR;
             end
             else FinalStr:=FinalStr+MakeOneSAMISubtitle(ClassNum,TR.TimeStart,TextIsClearStr)+#13#10;
            end;
            end;
            FinalStr:=FinalStr+MakeOneSAMISubtitle(ClassNum,LastTR.TimeEnd,TextIsClearStr)+#13#10;
            FinalStr:=StringReplace(FinalStr,#9,'',[rfReplaceAll]);
            FinalStr:=StringReplace(FinalStr,' <BR>','<BR>',[rfReplaceAll, rfIgnoreCase]);
            FinalStr:=FinalStr+'</BODY></SAMI>';//final SAMI Lines
           }
            try
            FileStream:=TFileStream.Create(FileName, fmCreate);
            FileStream.Write(PChar(FinalStr)^, Length(FinalStr));
            FileStream.Free;
            except
            end;
           end;

          end;
  SUB_TXT:begin //сохранение с учетом перекрытия
           CreateTimeSlices([_Text,_Derived], ClassNum);
           if (Length(TimeSlice)>1) then
           begin
            FinalStr:='';
            for j:=0 to Length(TimeSlice)-2 do
            begin
             TR.TimeStart:=TimeSlice[j];
             TR.TimeEnd:=TimeSlice[j+1];
            if (TR.TimeEnd-TR.TimeStart>5) then
            begin
             Str:='';
             for FirstActive:=0 to Count-1 do
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart,
                            TScriptItem(Items[FirstActive]^).Time, TScriptItem(Items[FirstActive]^).Length)>5
              then break;

             for i:=FirstActive to Count-1 do
             begin
              if (TScriptItem(Items[i]^).Time>TR.TimeEnd) then break;//since everything is sorted by Time, there can be no items beyond this point that can fit
              if not(ClassNum>0) or (TScriptItem(Items[i]^).ClassNum=ClassNum) then
              if (TScriptItem(Items[i]^).Status in [_Text, _Derived, _Clear]) then
              if not(TScriptItem(Items[i]^).Invisible) then
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart, TScriptItem(Items[i]^).Time, TScriptItem(Items[i]^).Length)>5 then //5 ms is just arbitrary value for testing purposes
              if (Length(Str)>0) then Str:=Str+'<BR>'+(TScriptItem(Items[i]^).Line)
               else Str:=(TScriptItem(Items[i]^).Line);
             end;
             Str:=Trim(Str);
             if (Str<>'') then
             begin
              FinalStr:=FinalStr+MakeOneTXTSubtitle(ClassNum,TR.TimeStart, TR.TimeEnd,Str)+#13#10;
             end;
            end;
            end;
            FinalStr:=StringReplace(FinalStr,#9,'',[rfReplaceAll]);
            try
            FileStream:=TFileStream.Create(FileName, fmCreate);
            FileStream.Write(PChar(FinalStr)^, Length(FinalStr));
            FileStream.Free;
            except
            end;
           end;
          end;
  SUB_S2K: try SaveS2K(FileName,ClassNum); except end;
  SUB_SSA: try SaveSSA(FileName,ClassNum); except end;
  SUB_RT:  try SaveRT(FileName,ClassNum); except end;

 end;
end;

function TScript.MakeOneSRTTimeText(StartTime, EndTime:longint; Str:string):string;
var s, time_str:string;
begin
 s:=Trim(StringReplace(GetPlainText(Str),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
 s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll,rfIgnoreCase]);
 while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
 s:=Trim(s);

 if (StartTime<0) then time_str:='Нет времени начала'
                   else time_str:=TimeMSToStr(StartTime, 3);
 time_str:=time_str+' --> ';
 if (EndTime<0) then time_str:=time_str+'Нет времени конца'
                   else time_str:=time_str+TimeMSToStr(EndTime, 3);

 if (s='') then s:=' ';

 Result:=time_str+#13#10+s+#13#10#13#10;
{ Result:=IntToStr(Num)+#13#10+
         TimeMSToStr(StartTime, 3)+' --> '+TimeMSToStr(EndTime, 3)+#13#10+
         s+#13#10+#13#10;}
end;

function TScript.MakeOneSRTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;
//var s, time_str:string;
begin
{ s:=Trim(StringReplace(GetPlainText(Str),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
 s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll]);
 while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
 s:=Trim(s);

 if (StartTime<0) then time_str:='Нет времени начала'
                   else time_str:=TimeMSToStr(StartTime, 3);
 time_str:=time_str+' --> ';
 if (EndTime<0) then time_str:=time_str+'Нет времени конца'
                   else time_str:=time_str+TimeMSToStr(EndTime, 3);

 if (s='') then s:=' ';

// Result:=IntToStr(Num)+#13#10+time_str+#13#10+s+#13#10#13#10;
}
 Result:=IntToStr(Num)+#13#10+MakeOneSRTTimeText(StartTime,EndTime,Str);
{ Result:=IntToStr(Num)+#13#10+
         TimeMSToStr(StartTime, 3)+' --> '+TimeMSToStr(EndTime, 3)+#13#10+
         s+#13#10+#13#10;}
end;

function TScript.MakeOneExtendedSRTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;
var s, time_str:string;
begin
 s:=Trim(StringReplace(Str,TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
 s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll,rfIgnoreCase]);
 while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
 s:=Trim(s);

 if (StartTime<0) then time_str:='Нет времени начала'
                   else time_str:=TimeMSToStr(StartTime, 3);
 time_str:=time_str+' --> ';
 if (EndTime<0) then time_str:=time_str+'Нет времени конца'
                   else time_str:=time_str+TimeMSToStr(EndTime, 3);

 if (s='') then s:=' ';

 Result:=IntToStr(Num)+#13#10+time_str+#13#10+s+#13#10#13#10;
end;


function TScript.MakeOneSAMISubtitle(ClassNum:integer; StartTime:longint; Str:string):string;
var s:string;
begin
 if ClassNum<0 then ClassNum:=1;
 {if LineBreakStr<>'<BR>' then} s:=StringReplace(Str,LineBreakStr,'<BR>',[rfReplaceAll,rfIgnoreCase]);{ else s:=Str;}
 if (s='') or (s=TextIsClearStr) then s:='&nbsp;';
 if not(StartTime=-1) then
 Result:='<SYNC Start='+IntToStr(StartTime)+'ms><P class='+Classes[ClassNum].ID+
         '>'+s
 else
 Result:='<SYNC><P class='+Classes[ClassNum].ID+
         '>'+s;

end;

function TScript.MakeOneRTSubtitleSE(StartTime, EndTime:longint; Str:string):string;
begin
 Str:=StringReplace(Str,LineBreakStr,'<BR>',[rfReplaceAll,rfIgnoreCase]);
 Result:=Format('<time begin="%s" end="%s"><clear/>%s', [TimeMSToStr(StartTime, 3, '.'), TimeMSToStr(EndTime, 3, '.'),  Str])
end;

function TScript.MakeOneRTSubtitleS(StartTime:longint; Str:string):string;
begin
 Str:=StringReplace(Str,LineBreakStr,'<BR>',[rfReplaceAll,rfIgnoreCase]);
 Result:=Format('<time begin="%s"><clear/>%s', [TimeMSToStr(StartTime, 3, '.'),  Str])
end;

function TScript.MakeOneTXTSubtitle(Num, StartTime, EndTime:longint; Str:string):string;
var s:string;
begin
 s:=Trim(StringReplace(GetPlainText(Str),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
// Result:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll])+#13#10;

// Result:=IntToStr(StartTime)+'.'+IntToStr(EndTime-StartTime)+'. '+StringReplace(s,LineBreakStr,' ',[rfReplaceAll]);
 Result:=IntToStr(StartTime)+'.'+IntToStr(EndTime-StartTime)+'. '+s;
{ Result:=s;
// while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
{ if not(s='') then}
{ begin
 s:='#'+IntToStr(Num)+'/'+IntToStr(StartTime)+'/'+IntToStr(EndTime)+#13#10+
    StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll])+#13#10;}
{ if (StartTime<0) then  Result:='#Нетаймированая строка'+#13#10+
         s+#13#10
 else
 Result:='# Начало: '+TimeMSToStr(StartTime, 3)+' Конец:'+TimeMSToStr(EndTime, 3)+#13#10+
         s+#13#10;}
{ end;}
// else Result:='# Ничего до '+TimeMSToStr(EndTime, 3)+#13#10;
 //#Num1/StartTime1/EndTime1
 //text1
 //text1
 //#Num2/StartTime2/EndTime2
 //text2
{ Result:=s;}
end;


function TScript.SAMIHeaderForClassToStr(ClassNum:integer;FileName:string):string;
var SL:TStringList; t:string; i:integer;
begin
if ClassesCount>0 then
begin
  SL:=TStringList.Create;
  Sl.Add('<SAMI><HEAD>');
  Sl.Add('<!--');
{$ifndef NO_FANSUBBER}
  Sl.Add('Created with FanSubber By Watson And Shalcker.');
  Sl.Add('(c) 2001-2002 by Watson and Shalcker');
{$else}
  Sl.Add('Created with Simple FanSubber By Watson And Shalcker.');
  Sl.Add('(c) 2001-2003 by Watson and Shalcker');
{$endif}
  Sl.Add('-->');
  Sl.Add('<Title>' + ExtractFileName(FileName)+'</Title>');
  Sl.Add('<STYLE TYPE="text/css">');
  Sl.Add('<!--');
//  Sl.Add('P {margin-left:1pt; margin-right:1pt; margin-bottom:1pt; margin-top:1pt;');
  Sl.Add('P {margin-left:'+IntToStr(Classes[0].Formatting^.Margin[mg_Left])+'px; margin-right:'+IntToStr(Classes[0].Formatting^.Margin[mg_Right])+'pt; margin-bottom:'+IntToStr(Classes[0].Formatting^.Margin[mg_Bottom])+'pt; margin-top:'+IntToStr(Classes[0].Formatting^.Margin[mg_Top])+'pt;');
  Sl.Add('text-align:center; font-size: '+IntToStr(Classes[0].Formatting^.TextSize)+'pt; font-family: '+Classes[0].Formatting^.FontName+',Arial, Tahoma, sans-serif, serif;' );
  t:= 'font-weight:';

  if (fsBold in Classes[0].Formatting^.FontStyles) then
//  if (FALSE){(fsBold in SMITextStyle.Style)} then
   t:=t+'bold;'  else t:=t+'normal;';
  t:=t+' color: #';
  t:=t+ColorToHexStr(Classes[0].Formatting^.TextColors[0])+'; }';

//  t:=t+'yellow; }';
  Sl.Add(t);

  t:='';
  for i:=1 to ClassesCount do
  if (i=ClassNum) or (ClassNum<0) then
  begin
  t := '.'+Classes[i].ID+' { Name: '+Classes[i].Name+'; ';
  if Classes[i].Language<>0 then
  begin
   t:=t+'Language: '+Languages[Classes[i].Language].ISO639ID+'-'+
  Countries[Classes[i].Country].ISO3166ID+'; ';
  end;
  if Classes[i].Formatting<>nil then t:=t+SAMIFormattingToStr(Classes[i].Formatting^);
  t:=t+'}';
  Sl.Add(t);
  end;
  Sl.Add('#STDPrn {Name:Standard Print;}');
  Sl.Add('#LargePrn {Name:Large Print; font-size:'+IntToStr(Round(Classes[0].Formatting^.TextSize*1.5))+'pt;}');
  Sl.Add('#SmallPrn {Name:Small Print; font-size:'+IntToStr(Trunc(Classes[0].Formatting^.TextSize/1.5))+'pt;}');
  Sl.Add('--></Style></HEAD><BODY>');
  Result:=SL.Text;
  SL.Free;
end else Result:='';
end;


function TScript.IsOverlappingClass(ClassNum:integer):boolean;
begin
 Result:=false; //Temporary!
end;

procedure TScript.LoadFromFile(FileName:string);
var SL:TStringList; Num:integer;
begin
 SL:=TStringList.Create;
 Num:=ClassesCount;
 try
 SL.LoadFromFile(FileName);
   if (UpperCase(ExtractFileExt(FileName))='.SSA') then ParseSSA(SL, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName)))
   else
   if (UpperCase(ExtractFileExt(FileName))='.SRT') then ParseSRT(SL, 'SRT'+IntToStr(Num), FileDateToDateTime(FileAge(FileName)))
   else
   if (UpperCase(ExtractFileExt(FileName))='.RT') then ParseRT(SL, 'RT'+IntToStr(Num), FileDateToDateTime(FileAge(FileName)))
   else
   if (UpperCase(ExtractFileExt(FileName))='.FSB') then ParseFSB(SL{, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName))})
   else
   if (UpperCase(ExtractFileExt(FileName))='.SMI') then ParseSAMI(SL, FileDateToDateTime(FileAge(FileName)))
   else
   if (UpperCase(ExtractFileExt(FileName))='.ZEG') then ParseZEG(SL, 'ZEG'+IntToStr(Num), FileDateToDateTime(FileAge(FileName)))
   else
   if (UpperCase(ExtractFileExt(FileName))='.JS') then ParseJS(SL, 'JS'+IntToStr(Num), FileDateToDateTime(FileAge(FileName)))
   else ParseTXT(SL,'TXT'+IntToStr(Num),  FileDateToDateTime(FileAge(FileName)));
//   if (UpperCase(ExtractFileExt(FileName))='.S2K') then MainScript.ParseS2K(SL{, 'SSA'+IntToStr(Num), FileDateToDateTime(FileAge(FileName))});
 except
 end;
 SL.Free;
end;

function TScript.GetPlainSRT:string;
//creates SRT from ScriptItems without any checking
var i, p:integer;
t1, t2, t3:integer;
st1, st2:string;
begin
 p:=1;
 st1:='';
 SetLength(LastScriptIndexes,Count+1);
 LastScriptIndexes[0]:=0; //only true for SRT where ScriptItems start from first line
 for i:=0 to Count-1 do begin
//   if (TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
   if (TScriptItem(Items[i]^).Line <> TextIsClearStr) then
   if (Trim(TScriptItem(Items[i]^).Line) <> '') then
//   if (TScriptItem(Items[i]^).Time>0) then
   if (TScriptItem(Items[i]^).Status = _Text) then
//   if (IsTimed(TScriptItem(Items[i]^))) then
   begin
{     st1:=st1+MakeOneSRTSubtitle(p,TScriptItem(Items[i]^).Time,
     TScriptItem(Items[i]^).Time+TScriptItem(Items[i]^).Length,
     TScriptItem(Items[i]^).Line);}
     st1:=st1+MakeLocalSRTSubtitle(TScriptItem(Items[i]^),p);
     LastScriptIndexes[p]:=Length(st1);
     TScriptItem(Items[i]^).ElementStart:=LastScriptIndexes[p-1];
     TScriptItem(Items[i]^).ElementEnd:=LastScriptIndexes[p]-2;
     inc(p);
//     st1:=StringReplace(Trim(StringReplace(GetPlainText(GetTextAtIndex(i)),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase])),
//                 '&quot;','"',[rfReplaceAll,rfIgnoreCase]);
//     st1:=StringReplace(st1,LineBreakStr,#13#10,[rfReplaceAll]);
//     while (Pos(#13#10#13#10,st1)>0) do st1:=StringReplace(st1,#13#10#13#10, #13#10,[]);
   end
 end;
 st1:=st1+#13#10;
 Result:=st1;
end;

function TScript.GetExtendedSRT:string;
//creates SRT from ScriptItems without any checking
var i, p:integer;
t1, t2, t3:integer;
st1, st2:string;
begin
 p:=1;
 st1:='';
 SetLength(LastScriptIndexes,Count+1);
 LastScriptIndexes[0]:=0; //only true for SRT where ScriptItems start from first line
 for i:=0 to Count-1 do begin
   if (TScriptItem(Items[i]^).Line <> TextIsClearStr) then
   if (Trim(TScriptItem(Items[i]^).Line) <> '') then
   if (TScriptItem(Items[i]^).Status = _Text) then
   begin
     st1:=st1+MakeExtendedSRTSubtitle(TScriptItem(Items[i]^),p);
     LastScriptIndexes[p]:=Length(st1);
     TScriptItem(Items[i]^).ElementStart:=LastScriptIndexes[p-1];
     TScriptItem(Items[i]^).ElementEnd:=LastScriptIndexes[p]-2;
     inc(p);
   end
 end;
 st1:=st1+#13#10;
 Result:=st1;
end;

function TScript.GetPlainSAMI:string;
//creates SAMI body from ScriptItems without any checking
var i:integer;
s:string;
s1, prev_si:^TScriptItem;
begin
Result:='<BODY>'#13#10;
prev_si:=nil;
if (Count>0) then
begin
  s:='';
  For i:=0 to Count-1 do
//  if (TScriptItem(items[i]^).Time>-1) then
//  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
  if (TScriptItem(items[i]^).Status in [_Text, _Clear]) then
  begin
    s1:=items[i];
    if (prev_si<>nil) then
     if (prev_si^.Status=_Text) and (s1^.Status=_Text) then
     if (IsTimed(prev_si^)) then
      if (prev_si^.Time+prev_si^.Length<s1^.Time-5) then
       s:=s+MakeOneSAMISubtitle(s1^.ClassNum,prev_si^.Time+prev_si^.Length,TextIsClearStr)+#13#10;
    s:=s+MakeOneSAMISubtitle(s1^.ClassNum,s1^.Time,s1^.Line)+#13#10;
    prev_si:=s1;
//    s:=s+StringReplace(s1.Line,'##',#13#10,[rfReplaceAll]);
  end;
    if (s1^.Time+s1^.Length>0) then
       s:=s+MakeOneSAMISubtitle(s1^.ClassNum,s1^.Time+s1^.Length,TextIsClearStr)+#13#10;
 Result:=Result+s;
end;
Result:=Result+'</BODY>';
end;

function TScript.GetPlain(SubtitleType:TSubType; ClassNum:integer = -1):string;
begin
 case SubtitleType of
  SUB_SRT: Result:=GetPlainSRT;
  SUB_SAMI: Result:=GetPlainSAMI;
  SUB_TXT: Result:=GetPlainTXT;
  SUB_SRTL: Result:=GetLinedSRT;
 end;
end;

function TScript.GetPlainTXT:string;
//creates SAMI body from ScriptItems without any checking
var i,p:integer;
s:string;

s1:^TScriptItem;
begin
if (Count>0) then
begin
//  s:='#Начало текста'#13#10;
  s:='';
  p:=1;
  For i:=0 to Count-1 do
//  if (TScriptItem(items[i]^).Time>-1) then
//  if (TScriptItem(items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
//  if (TScriptItem(items[i]^).Status in [_Text, _Clear]) then
  if (TScriptItem(items[i]^).Status=_Text) then
  begin
    s1:=items[i];
    s:=s+MakeOneTXTSubtitle(p,s1.Time, s1.Time+s1.Length, s1.Line);
    s:=s+#13#10;
    inc(p);
  end;
// s:=s+'#Конец текста';
 Result:=s;
end;
end;

function TScript.GetFileType(FileName:string):TSubType;
var s:string;
begin
 s:=LowerCase(ExtractFileExt(FileName));
 if (s='.srt') then Result:=SUB_SRT else
 if (s='.smi') or (s='.sami') then Result:=SUB_SAMI else
 if (s='.s2k') then Result:=SUB_S2K else
 if (s='.ssa') then Result:=SUB_SSA else
 Result:=SUB_TXT; //if everything else fails...
end;

function TScript.IsTimed(si:TScriptItem):boolean;
begin
 Result:=(si.Time>-1);
end;

procedure TScript.RemoveClears;
var i:integer;
begin
 i:=0;
 while(i<Count) do
 begin
  if (TScriptItem(Items[i]^).Status=_Clear)
  or (Trim(GetPlainText(TScriptItem(Items[i]^).Line))='')
  then DeleteAndFree(i)
  else inc(i);
 end;
end;

// ParseTXT(SL,'TXT'+IntToStr(Num),  FileDateToDateTime(FileAge(FileName)));
procedure TScript.ParseTXT;
var si:^TScriptItem; i:integer;
begin
 i:=0;
 while (i<Ls.Count) do
 begin
  New(si);
  si^:=NoScriptItem;
  si^.Comment:='[TXT]';
  si^.LastChange:=FileDateTime;
  si^.ElementNum:=i;
  si^.Status:=_Text;
  if not(CheckTXTTimedLine(Ls[i],si^)) then
  begin
   si^.Time:=NoTime;
   si^.Length:=0;
   si^.Line:=Ls[i];
  end;
  if (si^.Line<>'') then AddScriptItemPtr(si) else Dispose(si);
  inc(i);
 end;
end;

function TScript.CheckTXTTimedLine(Str:string; var si:TScriptItem):boolean;
var Finished,Stop, FirstDelimeter:boolean; i, Value:longint;
begin
// Result:=false;
 Stop:=false;
 FirstDelimeter:=true;
 Finished:=false;
 i:=1; Value:=0;
 while not(Stop) and not(Finished) do
 begin
  if (IsDelimiter('0123456789',Str,i)) then
  begin
   Value:=Value*10;
   case Str[i] of
//    '0': Value:=Value+1;
    '1': Value:=Value+1;
    '2': Value:=Value+2;
    '3': Value:=Value+3;
    '4': Value:=Value+4;
    '5': Value:=Value+5;
    '6': Value:=Value+6;
    '7': Value:=Value+7;
    '8': Value:=Value+8;
    '9': Value:=Value+9;
   end;
  end
  else
  if (IsDelimiter('.,',Str,i)) then
  begin
   if (i>1) then
   begin
    if (FirstDelimeter) then
    begin
     FirstDelimeter:=false;
     si.Time:=Value;
     Value:=0;
    end
    else
    begin
     si.Length:=Value;
     si.Line:=Copy(Str,i+2,Length(Str));
     Finished:=true;
    end;
   end else Stop:=true; //i=1 - string starts with . - stop
  end else Stop:=true; //not a 0123456789 or ,. - stop
  inc(i);
 end;
 Result:=Finished;
end;

procedure TScript.ShiftTime(Shift:longint; ClassNum: integer = -1; OnlySelected: boolean = false);
//procedure TScript.ShiftTime(Shift:longint);
var i:integer; si:^TScriptItem;
begin
 i:=0;
 while (i<Count) do
 begin
 si:=Items[i];
 if (si^.ClassNum=ClassNum) or (ClassNum=-1) then
  if (si^.Selected) or not(OnlySelected) then
   si^.Time:=si^.Time+Shift;
 inc(i);
 end;
end;

procedure TScript.LinearTimeTransform;
var Shift: longint; Transform:extended; i:integer; t:longint;
    ST1,ST2,ET1,ET2:extended;
begin
 Shift:=StartTime2-StartTime1;
 TransForm:=(EndTime2-StartTime2)/(EndTime1-StartTime1); //210 - 10 / 110 - 10 = 2
 ET1:=EndTime1;
 ET2:=EndTime2;
 ST1:=StartTime1;
 ST2:=StartTime2;
 if not(OnlyBetween) then
 begin
  for i:=0 to Count-1 do
   begin
    t:=TScriptItem(Items[i]^).Time;
    t:=Trunc(((t-ST1)*(ET2-ST1)/(ET1-ST1))+ST2);
    TScriptItem(Items[i]^).Time:=t;
    t:=TScriptItem(Items[i]^).Length;
    t:=Trunc(t*(ET2-ST2)/(ET1-ST1));
    TScriptItem(Items[i]^).Length:=t;
   end;
 end
 else
 begin
  for i:=0 to Count-1 do
  if IsWithin(TScriptItem(Items[i]^).Time,StartTime1,EndTime1-StartTime1) then
   begin
    t:=TScriptItem(Items[i]^).Time;
    t:=Trunc(((t-ST1)*(ET2-ST1)/(ET1-ST1))+ST2);
    TScriptItem(Items[i]^).Time:=t;
    t:=TScriptItem(Items[i]^).Length;
    t:=Trunc(t*(ET2-ST2)/(ET1-ST1));
    TScriptItem(Items[i]^).Length:=t;
   end;
 end;
 {
procedure TTimeAdjuster.btLinearTimeTransformClick(Sender: TObject);
var i:integer; t:longint;
begin
 try
 TS1:=StrToFloat(edTS1.Text);
 TS2:=StrToFloat(edTS2.Text);
 TE1:=StrToFloat(edTE1.Text);
 TE2:=StrToFloat(edTE2.Text);
 finally
 for i:=0 to MainScript.Count-1 do
  if TScriptItem(MainScript.Items[i]^).Selected then
   begin
//    TScriptItem(MainScript.Items[i]^).Time:=TScriptItem(MainScript.Items[i]^).Time-Step;
//    TScriptItem(MainScript.Items[i]^).Length:=TScriptItem(MainScript.Items[i]^).Length+Step;
    t:=TScriptItem(MainScript.Items[i]^).Time;
    t:=Trunc(((t-TS1)*(TE2-TS2)/(TE1-TS1))+TS2);
    TScriptItem(MainScript.Items[i]^).Time:=t;
    t:=TScriptItem(MainScript.Items[i]^).Length;
    t:=Trunc(t*(TE2-TS2)/(TE1-TS1));
    TScriptItem(MainScript.Items[i]^).Length:=t;
//    TScriptItem(MainScript.Items[i]^).Time:=t;
   end;
   MainForm.UpdateEvent([ScriptChange],0); //MainScript uses Main handle for updates
 end;
end;
}

end;

procedure TScript.AddSimple;
var si:^TScriptItem;
begin
 New(si);
 si^:=NoScriptItem;
 si.Line:=Line;
 si.Time:=Time;
 si.Length:=Length;
 si.Comment:='';
 si.ActorNum:=0;
 si.ClassNum:=ClassesCount;
 si.Status:=_Text;
 AddScriptItemPtr(si);
end;


{
procedure SaveSASAMI(FileName:string; var ScriptList:TScriptList; wid, hei:integer);
var
j,i:integer;
dest, lines:TStringList;
ps, oldps:integer;
s:string;
sADD:integer;
begin
  dest := TStringList.Create;
  lines := TStringList.Create;

  dest.Add(';Set.Slot=1');
  dest.Add(';Set.Time.Delay=15000');
  dest.Add(';Set.Alpha.End=256');
  dest.Add(';Set.Alpha.Start=256');
  dest.Add(';Set.Alpha.Step=-30');
  dest.Add(';Set.Font.Bold=0');
     ps:=ScriptList.ScriptFont.Font.Color;
     s:=intToHEX(ps, 6);
     s:=copy(s, 5, 2) + copy(s, 3, 2) + copy(s, 1,2);
     dest.Add(';Set.Font.Color=#'+s);
  dest.Add(';Set.Font.Outline.Color=#00101010');
  dest.Add(';Set.Font.Outline2.Color=#01101010');
  dest.Add(';Set.Font.Size='+IntToStr(ScriptList.ScriptFont.Font.size));
  dest.Add(';Set.Font.Face='+ScriptList.ScriptFont.Font.Name);
  dest.Add(';Buffer.Push=1');

  with ScriptList do
  for i:=0 to Count-1 do
  if Items[i].visible then
  begin

    dest.Add(';Buffer.Pop=1');
    dest.Add(';Set.Time.Start='+IntToStr(items[i].Time));
    dest.Add(';Set.Time.Delay='+IntToStr(items[i].Length));
    dest.Add(';Set.Start.Position.x=' + IntToStr(Wid div 2));
    dest.Add(';Set.End.Position.x=' + IntToStr(Wid div 2));
    lines.Text:=Items[i].line;
    for j:=0 to lines.Count-1 do
    begin

    if Items[i].inBlock then
    begin
     if (BlocksList.values[Items[i].BlockName + '.FontName'] <> '') and
        (BlocksList.values[Items[i].BlockName + '.FontName'] <>
          ScriptList.ScriptFont.Font.Name) then
     dest.Add(';Set.Font.Face='+
       BlocksList.values[Items[i].BlockName + '.FontName']);

     if (BlocksList.values[Items[i].BlockName + '.FontSize'] <> '') and
        (BlocksList.values[Items[i].BlockName + '.FontSize'] <>
          IntToStr(ScriptList.ScriptFont.Font.Size)) then
     dest.Add(';Set.Font.Size='+
        BlocksList.values[Items[i].BlockName + '.FontSize']);

     ps:=StrToIntDef(
        BlocksList.values[Items[i].BlockName + '.FontColor'], DefaultScriptFontColor);
     if ps <> ScriptList.ScriptFont.Font.Color then begin
       s:=intToHEX(ps, 6);
       s:=copy(s, 5, 2) + copy(s, 3, 2) + copy(s, 1,2);
       dest.Add(';Set.Font.Color=#'+s);
     end;
    end;

    sADD:=3;

//    dest.Add(';Set.Start.Position.x=' + IntToStr(Wid div 2));
//    dest.Add(';Set.End.Position.x=' + IntToStr(Wid div 2));
    dest.Add(';Set.Start.Position.y='+ IntToStr(Hei - (lines.count-j)*abs(ScriptList.ScriptFont.Font.Height-sADD) -abs(ScriptList.ScriptFont.Font.Height)*2));
    if sitTitrUp in Items[i].ItemType then begin
     if lines.Count > 1 then
      dest.Add(';Set.End.Position.y='+IntToStr((j-lines.Count)*abs(ScriptList.ScriptFont.Font.Height-sADD)))
     end
    else
    dest.Add(';Set.End.Position.y=' + IntToStr(Hei - (lines.count-j)*abs(ScriptList.ScriptFont.Font.Height-sADD) -abs(ScriptList.ScriptFont.Font.Height)*2));
    Dest.Add(lines.Strings[j]);
    end;

  end;
  dest.SaveToFile(FileName);
  freeAndNil(dest);
  freeAndNil(lines);
end;
}

procedure TScript.SaveS2K;
var
j,i, def_x_c, x_c, def_y_c, y_c:integer;
dest, lines:TStringList;
ps, oldps:integer;
s:string;
DefColor:TColor;
sADD, Wid, Hei, LinesHeight:integer;
SF:TSubTextFormatting;
begin
  dest := TStringList.Create;
  lines := TStringList.Create;

  Wid:=Width;
  Hei:=Height;
  dest.Add(';Env.Movie.Width='+IntToStr(Width));
  dest.Add(';Env.Movie.Height='+IntToStr(Height));

  dest.Add(';Set.Slot=1');
  dest.Add(';Set.Time.Delay=500');
  dest.Add(';Set.Alpha.End=256');
  dest.Add(';Set.Alpha.Start=256');
  dest.Add(';Set.Alpha.Step=-30');
  if (fsBold in Classes[0].Formatting^.FontStyles) then dest.Add(';Set.Font.Bold=1')
  else dest.Add(';Set.Font.Bold=0');

  def_x_c:=-1000; //set x position for every subtitle
  if (SaveMode>1) then
  if Classes[0].Formatting^.HAlign=HAl_Center then
  begin
     def_x_c:=Wid div 2;
     dest.Add(';Set.Start.Position.x=' + IntToStr(def_x_c));
     dest.Add(';Set.End.Position.x=' + IntToStr(def_x_c));
  end;

  def_y_c:=-1000; //set y position for every subtitle
  if (SaveMode>2) then
  if Classes[0].Formatting^.VAlign=VAl_Bottom then
  begin
     def_y_c:=(Hei - abs(Classes[0].Formatting^.TextHeight) - Classes[0].Formatting^.Margin[Mg_Bottom]  + Classes[0].Formatting^.TextHeight div 2);
     dest.Add(';Set.Start.Position.y='+ IntToStr(def_y_c));
     dest.Add(';Set.End.Position.y='+ IntToStr(def_y_c));
  end;

     DefColor:=Classes[0].Formatting^.TextColors[0];
//     ps:=ScriptList.ScriptFont.Font.Color;
     s:=IntToHEX(DefColor, 6);
     s:=copy(s, 5, 2) + copy(s, 3, 2) + copy(s, 1,2);
     dest.Add(';Set.Font.Color=#'+s);
  dest.Add(';Set.Font.Outline.Color=#00101010');
  dest.Add(';Set.Font.Outline2.Color=#01101010');
//  dest.Add(';Set.Font.Size='+IntToStr(ScriptList.ScriptFont.Font.size));
//  dest.Add(';Set.Font.Face='+ScriptList.ScriptFont.Font.Name);
  dest.Add(';Set.Font.Size='+IntToStr(Classes[0].Formatting^.TextSize));
//  dest.Add(';Set.Font.Size='+IntToStr(Classes[0].Formatting^.TextHeight));
  dest.Add(';Set.Font.Face='+Classes[0].Formatting^.FontName);
  dest.Add(';Buffer.Push=1');

//  with ScriptList do
  for i:=0 to Count-1 do
//  if Items[i].visible then
  if not(_SI[i].Invisible) then
  if (_SI[i].Status=_Text) then
  if (_SI[i].ClassNum=SaveClassNum) or (SaveClassNum<0) then
  begin
    dest.Add('');
    dest.Add(';Buffer.Pop=1');
    dest.Add(';Set.Time.Start='+IntToStr(_SI[i].Time));
    dest.Add(';Set.Time.Delay='+IntToStr(_SI[i].Length-5));
    SF:=GetFormatting(_SI[i]);
    if (SF.TextColors[0]<>DefColor) then
    begin
     s:=IntToHEX(SF.TextColors[0], 6);
     s:=copy(s, 5, 2) + copy(s, 3, 2) + copy(s, 1,2);
     dest.Add(';Set.Font.Color=#'+s);
    end;
    if (SF.FontName<>Classes[0].Formatting^.FontName) then dest.Add(';Set.Font.Face='+SF.FontName);

    if (Length(SubRects)>0) then
    case SF.HAlign of
     HAl_Left: begin //these require line preprocessing
                x_c:=((SubRects[i].Right-SubRects[i].Left) div 2)+SF.Margin[mg_Left];
               end;
     HAl_Right:begin
                x_c:=Width-((SubRects[i].Right-SubRects[i].Left) div 2)-SF.Margin[mg_Right];
               end;
     HAl_Center:begin
                 x_c:=Wid div 2;
                end;
    end
    else x_c:=Wid div 2;
    if (x_c<>def_x_c) then //excluding unnecessary entries
    begin
     dest.Add(';Set.Start.Position.x=' + IntToStr(x_c));
     dest.Add(';Set.End.Position.x=' + IntToStr(x_c));
    end;
    lines.Text:=GetPlainLines(_SI[i].Line);// StringReplace(_SI[i].Line,LineBreakStr,#13#10,[rfReplaceAll]);
    LinesHeight:=SF.TextHeight*Lines.Count;

    for j:=lines.Count-1 downto 0 do //first line goes first since it doesn't needs y position in most cases
    begin
    sADD:=3;


    case SF.VAlign of
     VAl_Bottom, VAl_Free: begin
                  y_c:=(Hei - (lines.count-j)*abs(Classes[0].Formatting^.TextHeight)) - SF.Margin[Mg_Bottom]  + SF.TextHeight div 2;
//                  dest.Add(';Set.Start.Position.y='+ IntToStr((Hei - (lines.count-j)*abs(Classes[0].Formatting^.TextHeight)) - SF.Margin[Mg_Bottom]  + SF.TextHeight div 2));
//                  dest.Add(';Set.End.Position.y='+ IntToStr((Hei - (lines.count-j)*abs(Classes[0].Formatting^.TextHeight))    - SF.Margin[Mg_Bottom]  + SF.TextHeight div 2));
                 end;
     VAl_Top: begin y_c:=(j*abs(SF.TextHeight))  + SF.Margin[Mg_Top] + SF.TextHeight div 2;
//                  dest.Add(';Set.Start.Position.y='+ IntToStr((j*abs(SF.TextHeight))  + SF.Margin[Mg_Top] + SF.TextHeight div 2));
//                  dest.Add(';Set.End.Position.y='+ IntToStr((j*abs(SF.TextHeight)) + SF.Margin[Mg_Top]  + SF.TextHeight div 2));
                 end;
     VAl_Center: begin y_c:=(Hei div 2) - ((lines.count)*abs(SF.TextHeight) div 2) + j*SF.TextHeight  + SF.TextHeight div 2;
//                  dest.Add(';Set.Start.Position.y='+ IntToStr((Hei div 2) - ((lines.count)*abs(SF.TextHeight) div 2) + j*SF.TextHeight  + SF.TextHeight div 2 ));
//                  dest.Add(';Set.End.Position.y='+ IntToStr((Hei div 2) - ((lines.count)*abs(SF.TextHeight) div 2) + j*SF.TextHeight   + SF.TextHeight div 2 ));
                 end;
    end;
    if (y_c<>def_y_c) then //excluding unnecessary entries
    begin
     dest.Add(';Set.Start.Position.y=' + IntToStr(y_c));
     dest.Add(';Set.End.Position.y=' + IntToStr(y_c));
    end;

{    if sitTitrUp in Items[i].ItemType then begin
     if lines.Count > 1 then
      dest.Add(';Set.End.Position.y='+IntToStr((j-lines.Count)*abs(ScriptList.ScriptFont.Font.Height-sADD)))
     end
    else
    dest.Add(';Set.End.Position.y=' + IntToStr(Hei - (lines.count-j)*abs(ScriptList.ScriptFont.Font.Height-sADD) -abs(ScriptList.ScriptFont.Font.Height)*2));
}
    Dest.Add(lines.Strings[j]);
    end;

   end;
  dest.SaveToFile(FileName);
  freeAndNil(dest);
  freeAndNil(lines);
end;

function TScript.GetLinedSRT;
//creates SRT from ScriptItems without any checking
var i, p:integer;
t1, t2, t3:integer;
st1, st2:string;
begin
 p:=1;
 st1:='';
 for i:=0 to Count-1 do begin
//   if (TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
   if (TScriptItem(Items[i]^).Line <> TextIsClearStr) then
   if (Trim(TScriptItem(Items[i]^).Line) <> '') then
//   if (TScriptItem(Items[i]^).Time>0) then
   if (TScriptItem(Items[i]^).Status = _Text) then
//   if (IsTimed(TScriptItem(Items[i]^))) then
   begin
{     st1:=st1+MakeOneSRTTimeText(TScriptItem(Items[i]^).Time,
     TScriptItem(Items[i]^).Time+TScriptItem(Items[i]^).Length,
     TScriptItem(Items[i]^).Line);}
     st1:=st1+MakeLocalSRTSubtitle(TScriptItem(Items[i]^));

//     st1:=StringReplace(Trim(StringReplace(GetPlainText(GetTextAtIndex(i)),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase])),
//                 '&quot;','"',[rfReplaceAll,rfIgnoreCase]);
//     st1:=StringReplace(st1,LineBreakStr,#13#10,[rfReplaceAll]);
//     while (Pos(#13#10#13#10,st1)>0) do st1:=StringReplace(st1,#13#10#13#10, #13#10,[]);
   end
 end;
 st1:=st1+#13#10;
 Result:=st1;
end;

procedure TScript.CheckFSBSRTData(var si:TScriptItem;s:string);
begin
 if pos('G:',s)>0 then //G:0000 - only this way 
 begin
  si.GroupNum:=StrToInt(Trim(GetStrBetween('[',']',s,pos('G:',s)+1)));
//  si.GroupNum:=StrToInt(Trim(copy(s,pos('G:',s)+2,4)));
 end;
 if pos('A:',s)>0 then //G:0000 - only this way 
 begin
  si.ActorNum:=CheckActorName(Trim(GetStrBetween('[',']',s,pos('A:',s)+1)))
 end;
end;

function TScript.MakeLocalSRTSubtitle;
var s,time_str:string;
begin
//
 s:=Trim(StringReplace(GetPlainText(si.Line),TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
 s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll,rfIgnoreCase]);
 while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
 s:=Trim(s);

 if (si.Time<0) then time_str:='Нет времени начала'
                   else time_str:=TimeMSToStr(si.Time, 3);
 time_str:=time_str+' --> ';
 if (si.Time+si.Length<0) then time_str:=time_str+'Нет времени конца'
                   else time_str:=time_str+TimeMSToStr(si.Time+si.Length, 3);
 if si.GroupNum>0 then time_str:=time_str+' G:['+IntToStr(si.GroupNum)+']';
{ if (si.GroupNum<10) then time_str:=time_str+' G:000'+IntToStr(si.GroupNum)
 else
 if (si.GroupNum<100) then time_str:=time_str+' G:00'+IntToStr(si.GroupNum)
 else
 if (si.GroupNum<1000) then time_str:=time_str+' G:0'+IntToStr(si.GroupNum)
 else time_str:=time_str+' G:'+IntToStr(si.GroupNum);}
// time_str:=time_str+' G:'+Format('%04u',[si.GroupNum]);
 if si.ActorNum>0 then time_str:=time_str+' A:['+Actors[si.ActorNum].Name+']';
// if si.ClassNum>0 then time_str:=time_str+' C:'+Format('%04u',[si.GroupNum]);

 if (s='') then s:=' ';

 if (Num>-1) then
 Result:=IntToStr(Num)+#13#10+time_str+#13#10+s+#13#10#13#10
 else Result:=time_str+#13#10+s+#13#10#13#10;

end;

function TScript.MakeExtendedSRTSubtitle(si:TScriptItem; Num:integer = -1):string;
var s,time_str:string;
begin
//
 s:=Trim(StringReplace(si.Line,TextIsClearStr,'', [rfReplaceAll, rfIgnoreCase]));
 s:=StringReplace(s,'&quot;','"',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,LineBreakStr,#13#10,[rfReplaceAll,rfIgnoreCase]);
 while (Pos(#13#10#13#10,s)>0) do s:=StringReplace(s,#13#10#13#10,#13#10,[rfReplaceAll]);
 s:=Trim(s);

 if (si.Time<0) then time_str:='Нет времени начала'
                   else time_str:=TimeMSToStr(si.Time, 3);
 time_str:=time_str+' --> ';
 if (si.Time+si.Length<0) then time_str:=time_str+'Нет времени конца'
                   else time_str:=time_str+TimeMSToStr(si.Time+si.Length, 3);
 if (s='') then s:=' ';

 if (Num>-1) then
 Result:=IntToStr(Num)+#13#10+time_str+#13#10+s+#13#10#13#10
 else Result:=time_str+#13#10+s+#13#10#13#10;

end;



procedure TScript.SelectAll;
var i:integer;
begin
 for i:=0 to Count-1 do TScriptItem(Items[i]^).Selected:=true;
end;

procedure TScript.DeleteAndFreeSelected;
var i:integer;
begin
i:=0;
 while (i<Count) do
 begin
  if TScriptItem(Items[i]^).Selected then DeleteAndFree(i)
  else inc(i);
 end;
end;

procedure TScript.SaveSSA;
var SL:TStringList; i:integer;
begin
 SL:=TStringList.Create;
 try
{  SL.Add('[Script Info]');
  SL.Add('; This is a Sub Station Alpha v4 script.');
  SL.Add('; For Sub Station Alpha info and downloads,');
  SL.Add('; go to http://www.eswat.demon.co.uk/');
  SL.Add('; or email kotus@eswat.demon.co.uk');
  SL.Add('; ----------------------------------');
  SL.Add('; This script created or converted');
  SL.Add('; with Simple FanSubber v1.0');
  SL.Add('; For information email to bat@etel.ru');
//  SL.Add('Title:
//Original Script: RAnMA
//Original Translation: Boris Ivanov
//Original Editing: Alex Lapshin
//Original Timing: Alex Lapshin
//Synch Point: Нет синхронизации и тайм-кода
//  SL.Add('Synch Point: 0');
    SL.Add('ScriptType: v4.00');
    SL.Add('Collisions: Normal');
    SL.Add('PlayResY: '+IntToStr(Height));
    SL.Add('Timer: 100,0000');
    SL.Add('');
    SL.Add('[V4 Styles]');
    SL.Add('Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, TertiaryColour, BackColour, '+
           'Bold, Italic, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, AlphaLevel, Encoding');
//    SL.Add('
    //Style: Default,Arial,20,65535,65535,65535,-2147483640,-1,0,1,3,0,2,30,30,20,0,0
    SL.Add(FormattingToSSAStyle('Default',Classes[0].Formatting^));
    for i:=1 to GroupsCount do
    if (Groups[i].Formatting<>nil) then
     SL.Add(FormattingToSSAStyle(Groups[i].Name,Groups[i].Formatting^));
    SL.Add('');
    SL.Add('[Events]');
    for i:=0 to Count-1 do
    if (Items[i]<>nil) then
    if (TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0) then
    SL.Add(ScriptItemToSSADialogue(TScriptItem(Items[i]^)));
    SL.Add('');}
    SL.Text:=GetSSA(SaveClassNum);
    SL.SaveToFile(FileName);
 finally
 SL.Free;
 end;

end;

function TScript.FormattingToSSAStyle;
var i:integer;
begin
 Result:='Style: '+Name+',';
 with Fm do
 begin
//    SL.Add('Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, TertiaryColour, BackColour,
//Bold, Italic, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, AlphaLevel, Encoding');
  Result:=Result+FontName+',';
  Result:=Result+IntToStr(TextSize)+',';
  Result:=Result+IntToStr(TextColors[0])+','+IntToStr(TextColors[1])+','+IntToStr(TextColors[2])+','+IntToStr(BGColor)+',';
  if (fsBold in FontStyles) then Result:=Result+'1,' else Result:=Result+'0,';
  if (fsItalic in FontStyles) then Result:=Result+'1,' else Result:=Result+'0,';
  Result:=Result+'0,'; //BorderStyle
  Result:=Result+'2,'; //Outline
  Result:=Result+'3,'; //Shadow
  i:=0;
  case HAlign of
   HAl_Left: i:=i+1;
   HAl_Center: i:=i+2;
   HAl_Right: i:=i+3;
  end;
  case VAlign of
//   VAl_Bottom, VAl_Free: i:=i+0;
   Val_Center: i:=i+8;
   VAl_Top: i:=i+4;
  end;
  Result:=Result+IntToStr(i)+',';
  Result:=Result+IntToStr(Margin[mg_Left])+','+IntToStr(Margin[mg_Right])+',';
  case VAlign of
   VAl_Bottom,VAl_Free: Result:=Result+IntToStr(Margin[mg_Bottom])+',';
   VAl_Top,VAl_Center: Result:=Result+IntToStr(Margin[mg_Top])+',';
  end;
  Result:=Result+'0,204';
 end;
end;

function TScript.ScriptItemToSSADialogue;
var s:string;
begin
 Result:='';
 if (si.Status=_Text) then Result:='Dialogue'
 else Result:='Comment';
 Result:=Result+': Marked=';
 if not(si.Selected) then Result:=Result+'0' else Result:=Result+'1';
 Result:=Result+',';
 Result:=Result+TimeMSToStr(si.Time,4,'.')+',';
 Result:=Result+TimeMSToStr(si.Time+si.Length,4,'.')+',';
 if (si.GroupNum=0) then Result:=Result+'Default,'
 else Result:=Result+Groups[si.GroupNum].Name+',';
 if (si.ActorNum>0) then Result:=Result+GetActorName(si.ActorNum)+','
 else Result:=Result+',';
 Result:=Result+'0000,0000,0000,'; //no individual Margins/Effects (yet)
 if (ssKaraoke in GetFormatting(si).SubStyles) then Result:=Result+'Karaoke'
 else Result:=Result+',';
 //!!+
 s:='';
 s:=StringReplace(si.Line,'<I>','{\i1}',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,'</I>','{\i0}',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,'<B>','{\b1}',[rfReplaceAll,rfIgnoreCase]);
 s:=StringReplace(s,'</B>','{\b0}',[rfReplaceAll,rfIgnoreCase]);

// if not(Trim(GetPlainText(StringReplace(s,LineBreakStr,'\n',[rfReplaceAll])))='') then
 Result:=Result+Trim(GetPlainText(StringReplace(s,LineBreakStr,'\n',[rfReplaceAll,rfIgnoreCase])));
// else Result:='';
//Dialogue: Marked=0,0:00:05.00,0:00:07.00,*Default,Лина,0000,0000,0000,,Я там, где кишат монстры,\nчтобы их победить!

end;

function TScript.GetSSA;
var SL:TStringList; i:integer;
begin
 Result:='';
 SL:=TStringList.Create;
 try
  SL.Add('[Script Info]');
  SL.Add('; This is a Sub Station Alpha v4 script.');
  SL.Add('; For Sub Station Alpha info and downloads,');
  SL.Add('; go to http://www.eswat.demon.co.uk/');
  SL.Add('; or email kotus@eswat.demon.co.uk');
  SL.Add('; ----------------------------------');
  SL.Add('; This script is created or converted');
  SL.Add('; with Simple FanSubber v1.0');
  SL.Add('; For information email to bat@etel.ru');
//  SL.Add('Title:
//Original Script: RAnMA
//Original Translation: Boris Ivanov
//Original Editing: Alex Lapshin
//Original Timing: Alex Lapshin
//Synch Point: Нет синхронизации и тайм-кода
//  SL.Add('Synch Point: 0');
    SL.Add('ScriptType: v4.00');
    SL.Add('Collisions: Normal');
    SL.Add('PlayResY: '+IntToStr(Height));
    SL.Add('Timer: 100,0000');
    SL.Add('');
    SL.Add('[V4 Styles]');
    SL.Add('Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, TertiaryColour, BackColour, '+
           'Bold, Italic, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, AlphaLevel, Encoding');
//    SL.Add('
    //Style: Default,Arial,20,65535,65535,65535,-2147483640,-1,0,1,3,0,2,30,30,20,0,0
    SL.Add(FormattingToSSAStyle('Default',Classes[0].Formatting^));
    for i:=1 to GroupsCount do
    if (Groups[i].Formatting<>nil) then
     SL.Add(FormattingToSSAStyle(Groups[i].Name,Groups[i].Formatting^));
    SL.Add('');
    SL.Add('[Events]');
    SL.Add('Format: Marked, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text');
    for i:=0 to Count-1 do
    if (Items[i]<>nil) then
    if ((TScriptItem(Items[i]^).ClassNum=SaveClassNum) or (SaveClassNum<0))
        and (TScriptItem(Items[i]^).Status=_Text) then
     SL.Add(ScriptItemToSSADialogue(TScriptItem(Items[i]^)));
    SL.Add('');
    Result:=SL.Text;
 finally
 SL.Free;
 end;

end;

procedure TScript.UpdateGroupFormatting;
begin
  Groups[GroupNum].Name:=Name;
  if Groups[GroupNum].Formatting=nil then New(Groups[GroupNum].Formatting);
  Groups[GroupNum].Formatting^:=FM;
  if GroupsCount<GroupNum then GroupsCount:=GroupNum;
end;

procedure TScript.ClearFormatting;
var p:pointer; i:integer;
begin
 for i:=0 to GroupsCount do
  if Groups[i].Formatting<>nil then
  begin
   p:=Groups[i].Formatting;
   Groups[i].Formatting:=nil;
   try
    Dispose(p);
   except
   end;
  end;
 GroupsCount:=0;
end;

function TScript.GetSlicedSAMI;
var FinalStr,Str:string; var i, j, FirstActive:integer; LastTR, TR:TTimeRegion;
begin
 FinalStr:='';
           if (Length(TimeSlice)<2) then CreateTimeSlices([_Text,_Derived]);
           if (Length(TimeSlice)>1) then
           begin
            FinalStr:=SAMIHeaderForClassToStr(SaveClassNum, FName);
            for j:=0 to Length(TimeSlice)-2 do
            begin
             TR.TimeStart:=TimeSlice[j];
             TR.TimeEnd:=TimeSlice[j+1];
            if (TR.TimeEnd-TR.TimeStart>5) then
            begin
             Str:='';
             for FirstActive:=0 to Count-1 do
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart,
                            TScriptItem(Items[FirstActive]^).Time, TScriptItem(Items[FirstActive]^).Length)>5
              then break;

             for i:=FirstActive to Count-1 do
             begin
              if (TScriptItem(Items[i]^).Time>TR.TimeEnd) then break;//since everything is sorted by Time, there can be no items beyond this point that can fit
              if not(SaveClassNum>0) or (TScriptItem(Items[i]^).ClassNum=SaveClassNum) then
              if (TScriptItem(Items[i]^).Status in [_Text, _Derived, _Clear]) then
              if not(TScriptItem(Items[i]^).Invisible) then
              if GetOverlap(TR.TimeStart, TR.TimeEnd-TR.TimeStart, TScriptItem(Items[i]^).Time, TScriptItem(Items[i]^).Length)>5 then //5 ms is just arbitrary value for testing purposes
              if (Length(Str)>0) then
              begin
               if (UniteOrderForward) then Str:=Str+'<BR>'+(TScriptItem(Items[i]^).Line)
                                      else Str:=(TScriptItem(Items[i]^).Line)+'<BR>'+Str;
              end 
               else Str:=(TScriptItem(Items[i]^).Line);
             end;
             Str:=Trim(Str);
             if (Str<>'') then
             begin
              FinalStr:=FinalStr+MakeOneSAMISubtitle(SaveClassNum,TR.TimeStart,Str)+#13#10;
              LastTR:=TR;
             end
             else if (TR.TimeStart>0) then FinalStr:=FinalStr+MakeOneSAMISubtitle(SaveClassNum,TR.TimeStart,TextIsClearStr)+#13#10;
            end;
            end;
            FinalStr:=FinalStr+MakeOneSAMISubtitle(SaveClassNum,LastTR.TimeEnd,TextIsClearStr)+#13#10;
            FinalStr:=StringReplace(FinalStr,#9,'',[rfReplaceAll]);
            FinalStr:=StringReplace(FinalStr,' <BR>','<BR>',[rfReplaceAll, rfIgnoreCase]);
            FinalStr:=FinalStr+'</BODY></SAMI>';//final SAMI Lines
 end;           
 Result:=FinalStr;           
end;

function TScript.GetRegionCountAtTime;
var i:integer;
begin
 Result:=0;
 if TimeRegionsCnt<>nil then
 for i:=0 to Length(TimeSlice)-2 do
 begin
  if (Time>=TimeSlice[i]) and (Time<TimeSlice[i+1]) then
  begin
   Result:=TimeRegionsCnt[i];
   break;
  end;
 end;
end;

procedure TScript.CreateSubRects(Cnv:TCanvas); //with canvas for determining TextExtents
var i, j, k, x1, y1, x2, y2, SubHeight, SubWidth, LineCnt:integer;
    SF:TSubTextFormatting;
    s:string;
    SL:TStringList;
begin

 SL:=TStringList.Create;
try
 SetLength(SubRects,Count);
 Cnv.Font.Height:=Classes[0].Formatting^.TextHeight;
 i:=0;
 while i<Count do
 begin
  SF:=GetFormatting(_SI[i]);

  Cnv.Font.Height:=SF.TextHeight;
  Cnv.Font.Name:=SF.FontName;
  Cnv.Font.Style:=SF.FontStyles;
  //counting lines
  s:=_SI[i].Line;
{  LineCnt:=1; //one line by default
  j:=1;
  k:=1;
  while (j<Length(s)+1) do
  begin
   if (LineBreakStr[k]=s[j]) then inc(k);
   if (k=Length(LineBreakStr)+1) then begin inc(LineCnt); k:=1; end;
   inc(j);
  end;}

  SubHeight:=LineCnt*SF.TextHeight;
  SL.Text:=GetPlainLines(s);
  LineCnt:=SL.Count;

  j:=0;
  SubWidth:=0;
  while (j<SL.Count) do
  begin
   k:=Cnv.TextWidth(SL[j]);
   if (k>SubWidth) then SubWidth:=k;
   inc(j);
  end;

  case SF.VAlign of
   VAl_Bottom: begin y1:=Height-SubHeight-SF.Margin[Mg_Bottom]; y2:=Height-SF.Margin[mg_Bottom]; end;
   VAl_Center: begin y1:=(Height-SubHeight) div 2; y2:=(Height+SubHeight) div 2; end;
   VAl_Top: begin y1:=0+SF.Margin[Mg_Top]; y2:=y1+SubHeight+SF.Margin[Mg_Top];  end;
  end;  

  case SF.HAlign of
   HAl_Left: begin x1:=0+SF.Margin[mg_Left]; x2:=SubWidth+SF.Margin[mg_Left]; end;
   HAl_Center: begin x1:=(Width-SubWidth) div 2; x2:=(Width+SubWidth) div 2; end;
   HAl_Right: begin x1:=Width-SubWidth-SF.Margin[mg_Right]; x2:=Width-SF.Margin[mg_Right]; end;
  end;
  
  SubRects[i]:=Rect(x1,y1,x2,y2);
  inc(i);
 end;
finally
 SL.Free;
end;
end;


function StrToTimeMS(Str:string;ErrorRes:longint):longint;
var h,m,s,comma, len, Hr, Mi, Sc, Ms, i, err1: longint;
begin
 // string for this function should look like HH:MM:SS.MS, MM:SS.MS, SS.MS or MS
 // example is '0:00:0.12' (120 ms), '1:01.215' (61215 ms), '0.1' (100 ms), '100' (100 ms)
//      h:=0; m:=0; s:=0;
      Trim(Str);
      Hr:=0; Mi:=0; Sc:=0; Ms:=ErrorRes; // if this is not timestring, then -1 will be returned

      h:=pos(':', str);
      len:=Length(str);
      m:=h+pos(':', copy(str, h+1, len-h)); if m=h then m:=0;
      err1:=m+pos(':', copy(str, m+1, len-m)); if err1=m then err1:=0; //erronous variant - hh:mm:ss:ms
      if (m<>0) then
       begin
        s:=m+pos('.', copy(str, m+1, len-m)); if s=m then s:=0;
        comma:=m+pos(',', copy(str, m+1, len-m)); if comma=m then comma:=0;
       end
       else
       begin
        if (h<>0) then
        begin
        s:=h+pos('.', copy(str, h+1, len-h)); if s=h then s:=0;
        comma:=h+pos(',', copy(str, h+1, len-h)); if comma=h then comma:=0;
        end
        else
        begin
         s:=pos('.', str);
         comma:=pos(',', str);
        end;
       end;
       if (s=0) and (comma<>0) then s:=comma;
       if (s=0) and (comma=0) and (err1>0) then s:=err1;

 try
      if ((h<>0) and (m<>0)) and (s<>0) //HH:MM:SS.MS
       then
       begin
        Hr:=StrToIntDef(copy(str, 1, h-1),0);
        Mi:=StrToIntDef(copy(str, h+1, m-h-1),0);
        Sc:=StrToIntDef(copy(str, m+1, s-m-1),0);
        if (len-s)>2 then
        Ms:=StrToIntDef(copy(str, s+1, 3),-1)
        else Ms:=StrToIntDef(copy(str, s+1, len-s),-1);
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h<>0) and (m=0)) and (s<>0) //MM:SS.MS
       then
       begin
        Mi:=StrToInt(copy(str, 1, h-1));
        Sc:=StrToInt(copy(str, h+1, s-h-1));
        if (len-s)>2 then
        Ms:=StrToInt(copy(str, s+1, 3))
        else Ms:=StrToInt(copy(str, s+1, len-s));
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h=0) and (m=0)) and (s<>0) //SS.MS
       then
       begin
        Sc:=StrToInt(copy(str, 1, s-1));
        if (len-s)>2 then
        Ms:=StrToInt(copy(str, s+1, 3))
        else Ms:=StrToInt(copy(str, s+1, len-s));
        case ( len - s) of
         2: Ms:=Ms*10; // .XX
         1: Ms:=Ms*100;// .X
        end;
       end;

      if ((h<>0) and (m=0)) and (s=0) //MM:SS
      then
      begin
        Mi:=StrToInt(copy(str, 1, h-1));
        Sc:=StrToInt(copy(str, h+1, len-h));
        Ms:=0;
      end;

      if ((h<>0) and (m<>0)) and (s=0) //MM:SS
      then
      begin
        Hr:=StrToInt(copy(str, 1, h-1));
        Mi:=StrToInt(copy(str, h+1, m-h-1));
        Sc:=StrToInt(copy(str, m+1, len-m));
        Ms:=0;
      end;

      if ((h=0) and (m=0)) and (s=0) then Ms:=StrToIntDef(str,NoTime);//MS
 except
  on EConvertError do begin
   Hr:=0; Mi:=0; Sc:=0; Ms:=ErrorRes; // if this is not timestring, then ErrorRes will be returned
  end;
 end;
 Result:=Hr*60*60*1000+Mi*60*1000+Sc*1000+Ms;
end;

end.
