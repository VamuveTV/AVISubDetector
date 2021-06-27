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
unit MyTypes1;

interface
  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, Buttons;// MPlayer, Video;

const CT_EXTRA    =  0; //Color Type - Extra
      CT_SUBTITLE =  1; //Color Type - Subtitle
      CT_TEXT =  1; //Color Type - Subtitle
      CT_OUTLINE =   2; //Color Type - Outline
      CT_OTHER =     3; // any other color not within these categories
      CT_ANTIALIAS = 4; //Color Type - AntiAliasing

type TFrameStat = record
                    DLC, MED, LBC, MBC, RMB, LMB: integer;
                    //RMB - RightMost Block, LMB - LeftMost Block
                    MaxSameLineCtr: integer; //MBC "trust" parameter
                    LBCCount: integer; //LBC "trust" parameter
                    BandCount: integer; //number of "detected" bands - fairly big chunks of "text"
                    HasData: boolean;
                  end;
      

type TImageArray = record
                    Width, Height: integer;
                    Pixels: array of byte;
                   end;
      

type TRGB24Count = record
               R,G,B: byte;
               Count: integer;
              end;
type TRGB24 = record
               R,G,B:byte;
              end;
      
type TColorDominator = record
               R,G,B:byte;
//               Deviation: integer;
               RD, GD, BD: integer; //acceptable diff
               DomType: byte;
              end;


const
        MaxUpdateItems = 300;
        MaxMMediaItems = 300;
        MaxScriptSource = 300;
        MaxTextSources = 300;

const WM_MAINUPDATE = WM_USER + 100;

  const
   MaxClasses = 200;
   MaxActors = 200;
   MaxGroups = 200;
   MaxNumericData = 9;
   pt = 0;
   px = 1;


  type
   TSubType = (SUB_FSB, SUB_SAMI, SUB_RT, SUB_SRT, SUB_SSA,
               SUB_JS, SUB_ZEG, SUB_S2K, SUB_TXT, SUB_SRTL, SUB_SRT_EXTENDED);

   TSubStyles = (ssKaraoke,ssPullUp);
   TSubStylesSet = set of TSubStyles;

   TClassesNumSet = 0..MaxClasses; //0 - Current
   TGroupsNumSet = 0..MaxGroups;
   TActorsNumSet = 0..MaxActors;

   TClassesSet = set of TClassesNumSet;

   TSelSpecial = record
                  SelStart, SelLength:integer; //positions in PlainText where selections starts
                  //actions, parameters and such should be added in near future
                 end;
   TTimeRegion = record
                  TimeStart, TimeEnd, TimeStatus:longint;
                 end; 

  TScriptItemValueTypes = (V_Numeric, V_Boolean, V_String, V_Other);                 

  type
   TScriptItemLink = record
                      Prev, Next: pointer; //previous and next ScriptItem in the same class
                    end;
    TScriptItemStatus = (_Text, _Derived, _Clear, _Action, _Other, _None);
    TScriptItemStatusSet = set of TScriptItemStatus;
    TScriptTextFlagSet=set of(variant, wrong );
    TVerticalAlign = (VAl_Bottom, VAl_Center, VAl_Top, VAl_Free); // default is bottom
    THorizontalAlign = (HAl_Left, HAl_Center, HAl_Right, HAl_Justify, HAl_Free); // default is center
    TSizeSuffix = 0..2; // for Font and Margin sizes (pt (0) or px (1) or none (2))

    TTextAligning = record
                        VAlign : TVerticalAlign;
                        HAlign : THorizontalAlign;
                       end;
  TMarginEnum = (Mg_Left, Mg_Right, Mg_Top, Mg_Bottom);
{  TSAMITextFormatting=record
        Margin:array[TMarginEnum] of integer;
//        MarginLeft, MarginRight, MarginTop, MarginBottom : integer; // margins
//        MarginLeftSuffix, MarginRightSuffix, MarginTopSuffix, MarginBottomSuffix : TSizeSuffix; // margins suffix - pt or px
        TextAlign : TTextAligning;
             Font : TFont;
//        TextColor: TColor; // text color - removed - now should be taken from FontSettings
        BGColor : TColor; // background color (0 should be threated later as transparent)
  end;}

  TSubTextFormatting = record
                        Margin:array[TMarginEnum] of integer;
                        VAlign   : TVerticalAlign;
                        HAlign   : THorizontalAlign;
                        FontName: TFontName;
                        Charset: TFontCharset;
                        FontStyles: TFontStyles;
                        SubStyles: TSubStylesSet;
                        TextColors: array[0..3] of TColor;
                        BGColor: TColor;
                        TextHeight: integer; //height
                        TextSize: integer; //Size (in Pt)
                        HasOpaque, HasOutline, HasShadow: boolean;
                       end;
  type

  TScriptItemFinder = class(TObject)
                       function GetInternalIndex:integer;
                       property Idx:integer read GetInternalIndex;
//                       property NextClassIdx:integer read NextInternalIndex;
//                       property SI:TScriptItem read GetScriptItemCopy;
//                       property RealSI:^TScriptItem read GetRealScriptItem;
//                       function GetScriptItem:TScriptItem;
//                       function GetRealScriptItem:^TScriptItem;
                       constructor Create(TrackUID:integer; LastInternalIndex: integer = -1);
                       public
                       UID:integer;
                       Next{InClass}, Prev{InClass}: TObject; //TScriptItemFinders for finding next and previous scriptitems in the same class (timewise)
                       InternalIndex:integer;
                       procedure FindInternalIndex;
                      end;

  TScriptItem=record
  // Basic Subtitle Data
    Time       : longint; // Starting time of subtitle in milliseconds
    Length     : longint; // The length of subtitle in milliseconds
    Line       : string;  // The actual subtitle text in more-or-less internal format - with <br>, <font>, <i> and so on
    ClassNum   : integer; // The number in registeres class array - Class feature inherited from SAMI format specification - allows to have several versions of the same script in one file (for example, to have several languages/translations included)
    ActorNum   : integer; // The number in registered actor array - identifier of one who actually "acts" here - makes sound, says a few words, cast a spell, or something like that; contained in Script Actor List
    UID        : integer; // Unique Subtitle IDentifier - used internally, do not change them in FSB file
    //-------Additional information
    TextFlag   : TScriptTextFlagSet; // Set of Pre-set statuswords :)
    Comment    : string;         // Subtitle Text Status/Editor Comment string (like: "Don't you think Lina is really cool here? ^_^" or "This is what they say but it doesn't make any sence!" :) )
    Status     : TScriptItemStatus;
    // Derived - text is derived from previous Text-Status Script Item as result of
    // script rendering (as an example, "karaoke" effects which recolor one
    // character at time can produce lots of Derived script items)
    GroupNum   : integer; //internally parsed; affects item
    // visibility (sample values are -1 (All) (usually for clear), 0 (Main) for main script (default), and
    // any other for other) - example: if ScriptItem with Clear status and non-Main group
    // is executed, only that group is cleared - Main group remain on screen
    Formatting : ^TSubTextFormatting; // if nil - default group, class, project (in that order)
    Edition    : integer; // AKA revision - number of times this subtitle was edited
    LastChange : TDateTime;
    ElementNum : longint; // this is string number when exporting from SSA, JS or SRT,
                          // internal SYNC number when exporting from SAMI
                          // or internal subtitle number when exproting from FSB
    ElementStart, ElementEnd: longint; //for tracking in _created_ scripts                      
    NumericData: array[0..MaxNumericData] of integer; // various variables
    Generated : boolean; //if ScriptItem was created as result of ScriptChecker
                         //or ScriptRendered, it is considered to be Program-Generated
//    ClassLinked: TScriptItemLink; //previous and next ScriptItem in the same class
    Selected:boolean; //whenever Script Item is selected for various purposes, this property becomes true
    Locked:boolean; //Locked ScriptItems cannot be changed or deleted
    Invisible:boolean; //Invisible ScriptItems are invisible while playing
    BlockNum: integer; //0 if non-block ScriptItem, >0 otherwise
    InternalIndex:integer;
    FINDER: TScriptItemFinder;
    Overlapping: boolean; //if ScriptItem is overlapping with other ScriptItem, they should be _united_ in View mode
{    procedure Create;
    procedure Assign(ValuesOf:TScriptItem);}
  end;

   TScriptItemValues =    (SI_UID, SI_Time, SI_Length, SI_Line, SI_Class, SI_Actor, SI_TextFlag,
    SI_Comment, SI_Status, SI_Group, SI_Formatting, SI_Edition,
    SI_LastChange, SI_ElementNum, SI_NumericData, SI_Generated,
    SI_Selected, SI_Locked, SI_Invisible, SI_Overlapping, SI_None);
   TScriptItemSaved = set of TScriptItemValues;
   TScriptItemValuesSet = set of TScriptItemValues;

const SI_Min = SI_UID;
      SI_Max = SI_None;

  type
        TScriptItemPointers = record
                                NextByTime,
                                PrevByTime,
                                NextByUID,
                                PrevByUID,
                                NextByClass,
                                PrevByClass,
                                NextByGroup,
                                PrevByGroup:^TScriptItem;
                               end;


type THTMLTagInfo = record
                     TagDefStart, TagDefEnd, TagZoneStart, TagZoneEnd: integer;
                     Name:string;
                     Closed:boolean; //ends with </TAG>, open otherwise
                    end;

type TUpdateEvents = (  {UpdateOn}Minimal, //nothing
                        InternalTimeChange, // when internal timer changes
                        NewCurrentScriptItemSelected, //Current script item changed (usually due to internal timer change)
                        CurrentScriptItemChange, //Current script item changed somewhere /start
                        SingleScriptItemChange, //Changes in any One Script Item
                        GroupChange,  //Changes in any One Group
                        ClassChange,  //Changes in any One Class
                        ScriptChange, //Changes in whole Script /end
                        SingleScriptItemSettingsChange, //when script item changes formatting
                        GroupSettingsChange, //when group changes formatting or name
                        ClassSettingsChange, //when class changes formatting or name
                        ProjectDefaultSettingsChange, // when project defaults change formatting
                        ClassAdded,
                        ClassDeleted,
                        GroupAdded,
                        ActorAdded,
                        GroupDeleted,
                        Specific,
                        All, //All Changed (on new project or script)
                        UpdateTop
                        );
        TUpdateEventsSet = set of TUpdateEvents;


        TUpdateReason = (UR_Added,
                        UR_Deleted,
                        UR_Changed,
                        UR_Selected,
                        UR_Any);
        TUpdateWhere = (UW_Internal_Timer,
                        UW_Class,
//                        UW_MyClass,
                        UW_ScriptItem,
//                        UW_MyScriptItem,
                        UW_Script,
                        UW_ScriptSources,
                        UW_MediaSources,
                        UW_Any);
//        TUpdateEventsSet = array[TUpdateReason] of set of TUpdateWhere;
//        TUpdateEventsSet = array[TUpdateWhere] of set of TUpdateReason;
//        TUpdateEvents = record
//                         Reason: set of TUpdateReason;
//                         Where: set of TUpdateWhere;
//                        end;




        type
        TUpdateHandle = integer;

        TUpdateItem = record
                    UpdateOnEvents : {set of }TUpdateEventsSet;
                   AcceptSingleUID : boolean; //if OnScriptChange/OnSingleScriptitemChange
                        CurrentUID : integer; //is true, only updates if Updates on ScriptItemChange if UID=Current UID passed to this UpdateItem
                 AcceptSingleClass : boolean;
                      CurrentClass : integer; //current class number if AcceptSingleClass
                    SelectedClasses: TClassesSet; //if not AcceptSingleClass
                  AcceptSingleGroup: boolean;

                     WUpdateHandle : HWND;
                        LastUpdate : integer;
                        Enabled    : boolean;
                       UpdateProc  : procedure of object;
                     New_SI_Select : procedure (SI:TScriptItem) of object;
                        SI_Changed : procedure (SI:TScriptItem) of object;
                      end;
        TUpdater = array[1..MaxUpdateItems] of TUpdateItem;

  type

  TSubtitleClassItem=record
        ID                 : string; // Class ID - like KRCC or RUCC or EnglishCC (those are extracted by ExtractClasses)
        Name               : string; // Class Name - example: Korean, Russian or English
        Language           : integer; // Language in Languages Array (en-US, fr-FR, kr-KR or ru-RU etc)
        Country            : integer; // Country in Countries Array (Russia (RU), USA (US) etc)
        samiType           : string; // Currently only CC should be entered here - this is SAMIType. You can also keep it blank.
        Formatting         : ^TSubTextFormatting; // The text format settings that OVERRIDE global project text format settings
        //unless they point to nil
        FontFamilies       : string; // additional font-family names
        FirstScriptItem,
        LastScriptItem : TScriptItemFinder; //first and last ScriptItems in class
        Overlapping        :boolean; //allows/contains time-overlapping ScriptItems (if false, only StartTime of ScriptItem should be taken into account and empty spaces should be filled with ClearScriptItems 
  end;

  TScriptActor=record
           Name: string; // Actor Identifier
        Classes: TClassesSet; // in which classes this actor exists
        Chained: byte; // to which (Actor) this actor is linked (for various translations)
  end;

  TScriptGroup=record
                Name : string;
             Classes : TClassesSet;
          Formatting : ^TSubTextFormatting;
        // The text format settings that OVERRIDE global project text format settings
        //and specific class format settings unless they point to nil
               end;

  TLanguageItem=record
                 Name:string;
             ISO639ID:string[2];
              Charset:TFontCharset;
                 end;

  TCountryItem=record
                 Name:string;
            ISO3166ID:string[2];
                 end;


{  type
  TScriptItem=record
    Time:integer;
    Length:integer;
    Line:string;
    PIClass:string;
    Actor : string;
    textFlag:ScriptTextFlag;
    UID:integer;
  end;}

 TSubWindowModes = (SUB_PLAIN_ONLY, SUB_PLAIN_EDITOR, SUB_EDITOR, SUB_VIEWER, SUB_ADD_TIMING);

// TScriptSelection = TScriptItem

implementation

uses UScript;
{
procedure TScriptItem.Create;
var i:integer;
begin
  Time:=-1;
  Length:=-1;
  Line:='No Script Loaded or Script Error';
  ClassNum:=0;
  ActorNum:=0;
  UID:=-1;
  textFlag:=[];
  Comment:='';
  Status:=_Clear;
  GroupNum:=0;
  Formatting:=nil;
  Edition:=0;
  LastChange:=Date+Time;
  ElementNum:=0;
  Generated:=false;
  Selected:=false;
  for i:=0 to MaxNumericData do NumericData[i]:=0;
end;

procedure TScriptItem.Assign(ValuesOf:TScriptItem);
var i:integer;
begin
  Time:=ValuesOf.Time;
  Length:=ValuesOf.Length;
  Line:=ValuesOf.Line;
  ClassNum:=ValuesOf.ClassNum;
  ActorNum:=ValuesOf.ActorNum;
  UID:=ValuesOf.UID;
  textFlag :=ValuesOf.textFlag;
  Comment:=ValuesOf.Comment;
  Status:=ValuesOf.Status;
  GroupNum:=ValuesOf.GroupNum;
  Formatting:=ValuesOf.Formatting;
  Edition:=ValuesOf.Edition;
  LastChange:=ValuesOf.LastChange;
  ElementNum:=ValuesOf.ElementNum;
  Generated:=ValuesOf.Generated;
  Selected:=ValuesOf.Selected;
  for i:=0 to MaxNumericData do NumericData[i]:=ValuesOf.NumericData[i];
end;}

function TScriptItemFinder.GetInternalIndex:integer;
begin
 if InternalIndex>=MainScript.Count then FindInternalIndex
 else if TScriptItem(MainScript.Items[InternalIndex]^).UID<>UID then
 //index is changed - finding
  FindInternalIndex;
  Result:=InternalIndex; //now we have right internal index
end;

procedure TScriptItemFinder.FindInternalIndex;
var i:integer;
begin
  i:=0;
  if (UID<=MainScript.MaxUID) then
  begin
  while (i<MainScript.Count) and not(TScriptItem(MainScript.Items[i]^).UID=UID) do inc(i);
  if (i<MainScript.Count) then InternalIndex:=i else InternalIndex:=0;
  end
  else Free;//UID=-1; //Error
end;

constructor TScriptItemFinder.Create(TrackUID:integer; LastInternalIndex: integer = -1);
begin
 UID:=TrackUID;
 if LastInternalIndex=-1 then FindInternalIndex
 else InternalIndex:=LastInternalIndex;
end;

{function TScriptItemFinder.GetScriptItem:TScriptItem;
begin
 Result:=TScriptItem(MainScript.Items[Idx]^);
end;

function TScriptItemFinder.GetRealScriptItem:^TScriptItem;
begin
 Result:=TScriptItem^(MainScript.Items[Idx]);
end;}


end.
