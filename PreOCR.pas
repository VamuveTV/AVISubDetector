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
unit PreOCR;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Math;

type TPreOCREntry = record
                     EntryIndex: integer;
                     FrameIndex: integer;
                     BaseIndex: integer; //SaveCtr
                     BaseY1, BaseY2: integer; //position occupied on base image
                     BandRect: TRect; //"original" rect
                    end;
     TRGB  = record R,G,B:byte; end;                

type
  TPreOCRFrame = class(TForm)
    gbSettings: TGroupBox;
    scrlbImage: TScrollBox;
    PreOCRImage: TImage;
    PostPreOCRImage: TImage;
    sbClearData: TSpeedButton;
    sbSaveCurrent: TSpeedButton;
    cbAddFrameData: TCheckBox;
    cbAutoscroll: TCheckBox;
    stCurrentStats: TStaticText;
    InfoPanel: TPanel;
    stInfo: TStaticText;
    sbShowPost: TSpeedButton;
    ColorDialog: TColorDialog;
    lbColorX: TLabel;
    lbColorT: TLabel;
    lbColorO: TLabel;
    lbColorNone: TLabel;
    sbShowInfo: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure sbClearDataClick(Sender: TObject);
    procedure sbSaveCurrentClick(Sender: TObject);
    procedure PreOCRImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbShowPostClick(Sender: TObject);
    procedure lbColorXClick(Sender: TObject);
    procedure sbShowInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SaveCtr: integer;
  public
    { Public declarations }
    MainPicture: TBitmap;
    PostPicture: TBitmap;
    HeightLimit: integer;
    PosSelected: integer;
    PostColorScheme:array[0..4] of TRGB;
    Entries: array of TPreOCREntry;

    function AddSubPicture(Bmp:TBitmap; FrameNum: integer = -1; Rect: pointer = nil):string;
    procedure Init;
    procedure FormDestroy;
    procedure PerformClearSave;
    procedure PerformPartialSave;
    procedure SaveEntryList;
    procedure ClearData;
    procedure MarkSelected;
    function HasEntry(Entry:TPreOCREntry):boolean;
    procedure PostProcess(Bmp:TBitmap);// Entry: TPreOCREntry);
    procedure ColorBlast(Bmp:TBitmap);// replaces each color with it's "type" representation 
    procedure UpdatePostColors;
  end;

  var  PreOCRFrame: TPreOCRFrame;

implementation

uses Unit1, MyTypes1, GlyphForm;

{$R *.DFM}

function TPreOCRFrame.HasEntry;
var i:integer;
begin
 Result:=false;
 for i:=0 to Length(Entries)-1 do
 begin
  if Entries[i].FrameIndex=Entry.FrameIndex then
  if (Entries[i].BandRect.Left=Entry.BandRect.Left) then
  if (Entries[i].BandRect.Top=Entry.BandRect.Top) then
  if (Entries[i].BandRect.Right=Entry.BandRect.Right) then
  if (Entries[i].BandRect.Bottom=Entry.BandRect.Bottom) then
   Result:=true;
 end;

end;

//procedure TPreOCRFrame.AddSubPicture;
function TPreOCRFrame.AddSubPicture;
var x1, y1: integer; sn:string; NewEntry:TPreOCREntry;
begin
 Result:='';
 MarkSelected;
 if MainPicture.Width<Bmp.Width then MainPicture.Width:=Bmp.Width;
// try
  y1:=MainPicture.Height;

  with NewEntry do
  begin
   FrameIndex:=FrameNum;
   EntryIndex:=Length(Entries);
//   BaseIndex:=SaveCtr;
//   BaseY1:=y1;
//   BaseY2:=MainPicture.Height+Bmp.Height;
   if Rect<>nil then BandRect:=TRect(Rect^)
   else begin BandRect.Left:=-1; end;
  end;
  
  If not(HasEntry(NewEntry)) then
  begin
   if ((MainPicture.Height + Bmp.Height) > HeightLimit) then begin PerformClearSave; y1:=0; end;

   if (MainPicture.Height < HeightLimit) then
   begin
    try
     if cbAddFrameData.Checked then MainPicture.Height:=MainPicture.Height + 20
     else MainPicture.Height:=MainPicture.Height+Bmp.Height+2;
    except
     PerformClearSave; y1:=0;
     if cbAddFrameData.Checked then MainPicture.Height:=MainPicture.Height + 20
     else MainPicture.Height:=MainPicture.Height+Bmp.Height+2;
    end; 
   end;
//  If not(HasEntry(NewEntry)) then
  begin
   SetLength(Entries,Length(Entries)+1);
   NewEntry.BaseIndex:=SaveCtr;
   NewEntry.BaseY1:=y1;
   NewEntry.BaseY2:=MainPicture.Height-1;
   Entries[Length(Entries)-1]:=NewEntry;
  end;

  if MainForm.cbSaveIndividualSubpictures.Checked then
  begin
   sn:=ExtractFileName(MainForm.CurrentAVI);
   sn:=ChangeFileExt(sn,'');
   sn:=sn+'.orig.'+Format('%.5d',[Length(Entries)-1]){IntToStr(Length(Entries)-1)}+'.bmp';
   sn:=MainForm.GetSubPictSaveDir+sn;
   sn:=StringReplace(sn,'\\','\',[rfReplaceAll]);
   try
   Bmp.SaveToFile(sn);
   Result:=sn;
   except
   Result:='Failed to Save Bitmap';
   end;
  end;
  if MainForm.cbSaveIndividualPostSubpictures.Checked then
  begin
          PostPicture.Width:=Bmp.Width;
          PostPicture.Height:=Bmp.Height;
          PostPicture.PixelFormat:=pf24bit;
          PostPicture.Canvas.Draw(0,0,Bmp);
          if MainForm.cbPostMode.ItemIndex=0 then MainForm.PreprocessImage2(PostPicture,0,0,Bmp.Width-1,Bmp.Height-1)
          else if MainForm.cbPostMode.ItemIndex=1 then ColorBlast(PostPicture)
          else
          if MainForm.sbOCRProcessing.Down then GlyphForm1.MaskToBitmap(GlyphForm1.Mask1Bitmap,PostPicture)
          else begin
           GlyphForm1.SetBitmap(PostPicture);
           GlyphForm1.btBuildMasksXClick(Self);
           GlyphForm1.MaskToBitmap(GlyphForm1.Mask1Bitmap,PostPicture);
          end;
           sn:=ExtractFileName(MainForm.CurrentAVI);
           sn:=ChangeFileExt(sn,'');
           sn:=sn+'.post.'+Format('%.5d',[Length(Entries)-1]){IntToStr(Length(Entries)-1)}+'.bmp';
           sn:=MainForm.GetSubPictSaveDir+sn;
           sn:=StringReplace(sn,'\\','\',[rfReplaceAll]);
           try
            PostPicture.SaveToFile(sn);
            if MainForm.cbSaveIndividualPostSubpictures.Checked
               and not(MainForm.cbSaveIndividualSubpictures.Checked) then
                    Result:=sn;
           except
           end;
  end;

  if cbAddFrameData.Checked then
  begin

   MainPicture.Canvas.Font.Height:=18;
   with Entries[Length(Entries)-1] do
   MainPicture.Canvas.TextOut(10,y1+1,
            Format('Frame %.6d XL=%.3d YT=%.3d XR=%.3d YB=%.3d - N=%.3d Y1=%.4d Y2=%.4d',
            [FrameIndex, BandRect.Left, BandRect.Top,
             BandRect.Right, BandRect.Bottom, BaseIndex, BaseY1, BaseY2]));
   BitBlt(MainPicture.Canvas.Handle,0,y1+21,Bmp.Width,Bmp.Height,Bmp.Canvas.Handle,0,0,SRCCOPY);
  end
  else BitBlt(MainPicture.Canvas.Handle,0,y1+1,Bmp.Width,Bmp.Height,Bmp.Canvas.Handle,0,0,SRCCOPY);
  
 end;
{  with Entries[Length(Entries)-1] do
  begin
  end;}



// PreOCRImage.Picture.Bitmap.Assign(MainPicture);
// finally
  if cbAutoscroll.Checked then scrlbImage.VertScrollBar.Position:=scrlbImage.VertScrollBar.Range;
// end;
 PostPreOCRImage.Left:=PreOCRImage.Left+MainPicture.Width+5;
 PostPreOCRImage.Top:=PreOCRImage.Top;
 MarkSelected;
 stCurrentStats.Caption:=' '+IntToStr(Length(Entries))+' subpictures found';
end;

procedure TPreOCRFrame.Init;
begin
// MainPicture:=TBitmap.Create;
 MainPicture:=PreOCRImage.Picture.Bitmap;
 PostPicture:=PostPreOCRImage.Picture.Bitmap;
// PostPicture:=TBitmap.Create;
 PreOCRImage.Picture.Bitmap.Height:=0;
 MainPicture.PixelFormat:=pf24bit;
 PostPicture.PixelFormat:=pf24bit;

 HeightLimit:=6000;
 SaveCtr:=0;
 PosSelected:=-1;

 PostColorScheme[0].R:=255;
 PostColorScheme[0].G:=255;
 PostColorScheme[0].B:=255;

 PostColorScheme[1].R:=0; //text
 PostColorScheme[1].R:=0;
 PostColorScheme[1].R:=0;

 PostColorScheme[2].R:=128; //outline
 PostColorScheme[2].G:=128;
 PostColorScheme[2].B:=128;

 PostColorScheme[3].R:=255; //3 is "empty" (unused) color
 PostColorScheme[3].G:=255;
 PostColorScheme[3].B:=255;

 PostColorScheme[4].R:=128; //4 is "antialiasing" color
 PostColorScheme[4].G:=255;
 PostColorScheme[4].B:=128;

 UpdatePostColors;

end;

procedure TPreOCRFrame.FormDestroy;
begin
// MainPicture.Free;
// PostPicture.Free;
 ClearData;
end;

procedure TPreOCRFrame.PerformClearSave;
var sn: string;
begin
 if Length(Entries)=0 then exit; 
 sn:=ExtractFileName(MainForm.CurrentAVI);
 sn:=ChangeFileExt(sn,'');
 sn:=sn+'.'+Format('%.4d',[SaveCtr]){IntToStr(SaveCtr)}+'.bmp';
// sn:=MainForm.edSaveBMPPath.Text+'\'+sn;
 sn:=MainForm.GetSubPictSaveDir+sn;
 sn:=StringReplace(sn,'\\','\',[rfReplaceAll]);
 MarkSelected;
 if MainForm.cbSaveProjectSubPics.Checked then MainPicture.SaveToFile(sn);
 MarkSelected;
 MainPicture.Height:=0;
 Inc(SaveCtr);
// PosSelected
 SaveEntryList;
end;

procedure TPreOCRFrame.PerformPartialSave;
var sn: string;
begin
 if Length(Entries)=0 then exit; 
 sn:=ExtractFileName(MainForm.CurrentAVI);
 sn:=ChangeFileExt(sn,'');
// sn:=sn+'.'+IntToStr(SaveCtr)+'.bmp';
 sn:=sn+'.'+Format('%.4d',[SaveCtr]){IntToStr(SaveCtr)}+'.bmp';
// sn:=MainForm.edSaveBMPPath.Text+'\'+sn;
   sn:=MainForm.GetSubPictSaveDir+sn;
 sn:=StringReplace(sn,'\\','\',[rfReplaceAll]);
 MarkSelected;
 if MainForm.cbSaveProjectSubPics.Checked then MainPicture.SaveToFile(sn);
 MarkSelected;
 SaveEntryList;
// MainPicture.Height:=0; Inc(SaveCtr);
end;

procedure TPreOCRFrame.SaveEntryList;
var i: integer; SL: TStringList;
var sn: string;
begin
 sn:=ExtractFileName(MainForm.CurrentAVI);
 sn:=ChangeFileExt(sn,'');
 sn:=sn+'.lst';
// sn:=MainForm.edSaveBMPPath.Text+'\'+sn;
   sn:=MainForm.GetSubPictSaveDir+sn;
 sn:=StringReplace(sn,'\\','\',[rfReplaceAll]);
 SL:=TStringList.Create;
 try
 for i:=0 to Length(Entries)-1 do
  with Entries[i] do
  if not(BandRect.Left=-1) then
     SL.Add(Format('F=%.6d;I=%.3d;N=%.3d;Y1=%.4d;Y2=%.3d;XL=%.3d;YT=%.3d;XR=%.3d;YB=%.3d;',
            [FrameIndex, EntryIndex, BaseIndex, BaseY1, BaseY2,
             BandRect.Left, BandRect.Top,
             BandRect.Right, BandRect.Bottom]))
{type TPreOCREntry = record
                     EntryIndex: integer;
                     FrameIndex: integer;
                     BaseIndex: integer; //SaveCtr
                     BaseY1, BaseY2: integer; //position occupied on base image
                     BandRect: TRect; //"original" rect
                    end;}

{     SL.Add(IntToStr(FrameIndex)+';N='+IntToStr(BaseIndex)+
         ';Y1='+IntToStr(BaseY1)+';Y2='+IntToStr(BaseY2)+';'
         +'XL='+IntToStr();}
  else
     SL.Add(Format('%.6d;N=%.3d;Y1=%.4d;Y2=%.4d',
                 [FrameIndex, BaseIndex, BaseY1, BaseY2]));
{  SL.Add(IntToStr(FrameIndex)+';N='+IntToStr(BaseIndex)+
         ';Y1='+IntToStr(BaseY1)+';Y2='+IntToStr(BaseY2)+';');}
  SL.SaveToFile(sn);       
 finally
 SL.Free;
 end;
end;

procedure TPreOCRFrame.sbClearDataClick(Sender: TObject);
begin
 ClearData;
end;

procedure TPreOCRFrame.ClearData;
begin
 SetLength(Entries,0);
 MainPicture.Height:=0;
 MainPicture.Width:=0;
 SaveCtr:=0;
 stCurrentStats.Caption:=' '+IntToStr(Length(Entries))+' subpictures found';
end;

procedure TPreOCRFrame.sbSaveCurrentClick(Sender: TObject);
begin
 PerformPartialSave;
end;

procedure TPreOCRFrame.PreOCRImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
 if Button=mbLeft then
 begin
{  MainPicture.Canvas.Pen.Mode:=pmNot;

  if (PosSelected>-1) and (PosSelected<Length(Entries))then
    if (SaveCtr=Entries[PosSelected].BaseIndex) then
    with Entries[PosSelected] do
    begin
     MainPicture.Canvas.MoveTo(0,BaseY1);
     MainPicture.Canvas.LineTo(BandRect.Right - BandRect.Left, BaseY1);
     MainPicture.Canvas.MoveTo(0,BaseY2);
     MainPicture.Canvas.LineTo(BandRect.Right - BandRect.Left, BaseY2);
    end;}
    MarkSelected;
  if (Y>=MainPicture.Height) then exit;  
  for i:=Length(Entries)-1 downto 0 do
   if (Y>Entries[i].BaseY1) and (Y<Entries[i].BaseY2) then break;
  PosSelected:=i;
  with Entries[i] do
  if not(BandRect.Left=-1) then
     stInfo.Caption:=(Format('Frame %.6d -- Index %.3d -- N=%.3d, Y1=%.4d,Y2=%.3d -- x1,y1=%.3d,%.3d -- x2,y2=%.3d,%.3d',
            [FrameIndex, EntryIndex, BaseIndex, BaseY1, BaseY2,
             BandRect.Left, BandRect.Top,
             BandRect.Right, BandRect.Bottom]));

    MarkSelected;
 end;
end;

procedure TPreOCRFrame.MarkSelected;
begin
  if (PosSelected>-1) and (PosSelected<Length(Entries))then
    if (SaveCtr=Entries[PosSelected].BaseIndex) then
    with Entries[PosSelected] do
    begin
     MainPicture.Canvas.Pen.Mode:=pmNot;
     MainPicture.Canvas.MoveTo(0,BaseY1);
     MainPicture.Canvas.LineTo(MainPicture.Width {BandRect.Right - BandRect.Left}, BaseY1);
     MainPicture.Canvas.MoveTo(0,BaseY2);
     MainPicture.Canvas.LineTo(MainPicture.Width {BandRect.Right - BandRect.Left}, BaseY2);
    end;
end;

procedure TPreOCRFrame.PostProcess;
var j, X, Y, Pix, Variance1, Variance2: integer; R, G, B, R1, G1, B1, R2, G2, B2: byte;
    PXLine, PXC, PY, PXB: PByteArray; Y1, Y2, HT, WT: integer;
begin
//
// if IsPreprocess then
//- for Y:=ImageCutBottom to (FrameHeight-ImageCutTop)-1 do //checking lower part of image
// Y1:=FrameHeight-ImageCutBottom-1;
// Y2:=ImageCutTop;
// Y1:=Min(FrameHeight-ImageCutBottom-1,ImageCutTop);
// Y2:=Max(FrameHeight-ImageCutBottom-1,ImageCutTop);
 HT:=Bmp.Height; WT:=Bmp.Width;
 Y1:=0; Y2:=HT-1;
 for Y:=Y1 to Y2 do
 begin
  PXLine:=Bmp.ScanLine[Y];
  for X:=0 to BMP.Width-1 do//to BlockSize-1 do //  for X:=0 to W-1 do
  begin
   Pix:=X*3;
   R1:=PXLine[Pix+2];   G1:=PXLine[Pix+1];   B1:=PXLine[Pix];
//   R2:=127; G2:=127; B2:=127; //default
      R2:=PostColorScheme[3].R;
      G2:=PostColorScheme[3].G;
      B2:=PostColorScheme[3].B;
   for j:=0 to Length(MainForm.ColorDominators)-1 do
   begin
{      Variance1:=Abs(R1-MainForm.ColorDominators[j].R)+
                 Abs(G1-MainForm.ColorDominators[j].G)+
                 Abs(B1-MainForm.ColorDominators[j].B);
//     if Variance1<MainForm.DominatorDeviation then
     if Variance1<MainForm.ColorDominators[j].Deviation then}
     if (MainForm.IsMatchingColor(R1,G1,B1,MainForm.ColorDominators[j])) then
     begin
//      if MainForm.IsReplaceAll then
      if MainForm.IsReplaceAll or (MainForm.ColorDominators[j].DomType>0) then
      begin
       R2:=PostColorScheme[MainForm.ColorDominators[j].DomType].R;
       G2:=PostColorScheme[MainForm.ColorDominators[j].DomType].G;
       B2:=PostColorScheme[MainForm.ColorDominators[j].DomType].B;
      end
      else
      begin
       R2:=MainForm.ColorDominators[j].R; //R1
       G2:=MainForm.ColorDominators[j].G; //G1
       B2:=MainForm.ColorDominators[j].B; //B1
      end;
      break;
     end;
   end;
//   if MainForm.IsReplaceAll then
   begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
{   else if R2<>32 then
    begin PXLine[Pix+2]:=R2; PXLine[Pix+1]:=G2; PXLine[Pix]:=B2; end
    else begin PXLine[Pix+2]:=R1; PXLine[Pix+1]:=G1; PXLine[Pix]:=B1; end;}
  end;
 end;
 if MainForm.IsPreKillStray then
  for j:=1 to MainForm.PreKillStrayRepeat do
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
       if (PXC[(X+1)*3+2]<>127) and (PXC[(X-1)*3+2]<>127) {and (PXC[(X+1)*3+2]<>PXC[(X-1)*3+2])} then
//         then begin PXC[X*3+2]:=PXC[(X+1)*3+2]; PXC[X*3+1]:=PXC[(X+1)*3+2]; PXC[X*3]:=PXC[(X+1)*3+2]; end;
        begin
         if (PXC[(X+1)*3+2]=255) and (PXC[(X-1)*3+2]=255) then begin PXC[X*3+2]:=255; PXC[X*3+1]:=255; PXC[X*3]:=255; end
         else begin PXC[X*3+2]:=0; PXC[X*3+1]:=0; PXC[X*3]:=0; end; //actually it should be 0 if any of two surrounding is 0 and 255 otherwise
        end;
       if (Y>0) and (Y<HT-1) then
       if (PY[X*3+2]<>127) and (PXB[X*3+2]<>127) {and (PXB[X*3+2]<>PY[X*3+2])} then
       begin
//         then begin PXC[X*3+2]:=PXB[X*3+2]; PXC[X*3+1]:=PXB[X*3+1]; PXC[X*3]:=PXB[X*3]; end;
         if (PY[X*3+2]=255) and (PXB[X*3+2]=255) then begin PXC[X*3+2]:=255; PXC[X*3+1]:=255; PXC[X*3]:=255; end
         else begin PXC[X*3+2]:=0; PXC[X*3+1]:=0; PXC[X*3]:=0; end; //it should be 0 if any of two surrounding is 0 and 255 otherwise
       end;
      end;
     end;
 end; 
end;

procedure TPreOCRFrame.sbShowPostClick(Sender: TObject);
begin
 if sbShowPost.Down then
 begin
  PostPicture.Width:=MainPicture.Width;
  PostPicture.Height:=MainPicture.Height;
  PostPicture.Canvas.Draw(0,0,MainPicture);
  ColorBlast(PostPicture);
//  PostProcess(PostPicture);
 end;
 PostPreOCRImage.Visible:=sbShowPost.Down;
end;

procedure TPreOCRFrame.lbColorXClick(Sender: TObject);
var CL:integer; R,G,B:byte;
begin
 ColorDialog.Color:=(Sender as TLabel).Color;
 if ColorDialog.Execute then
 begin
  CL:=ColorDialog.Color;
  R:=(CL and $FF);
  G:=(CL and $FF00) shr 8;
  B:=(CL and $FF0000) shr 16;
  PostColorScheme[(Sender as TLabel).Tag].R:=R;
  PostColorScheme[(Sender as TLabel).Tag].G:=G;
  PostColorScheme[(Sender as TLabel).Tag].B:=B;
  UpdatePostColors;
 end;
end;

procedure TPreOCRFrame.UpdatePostColors;
var i, R,G,B:byte; lb:TLabel;
begin
 for i:=0 to Length(PostColorScheme)-1 do
 begin
  R:=PostColorScheme[i].R;
  G:=PostColorScheme[i].G;
  B:=PostColorScheme[i].B;
  case i of
  0: lb:=lbColorX;//.Color:=B*256*256+G*256+R;
  1: lb:=lbColorT;
  2: lb:=lbColorO;
  3: lb:=lbColorNone;
  end;
  lb.Color:=B*256*256+G*256+R;
  if (B>128) then B:=0 else B:=255;
  if (G>128) then G:=0 else G:=255;
  if (R>128) then R:=0 else R:=255;
  lb.Font.Color:=B*256*256+G*256+R;
 end;
{  R:=MainForm.ColorDominators[MainForm.DominatorSelected].R;
  G:=MainForm.ColorDominators[MainForm.DominatorSelected].G;
  B:=MainForm.ColorDominators[MainForm.DominatorSelected].B;
  lbColorDominator.Color:=B*256*256+G*256+R;
  lbDominatorRGB.Caption:='R:'+IntToStr(R)+' G:'+IntToStr(G)+' B:'+IntToStr(B);

  if (B>128) then B:=0 else B:=255;
  if (G>128) then G:=0 else G:=255;
  if (R>128) then R:=0 else R:=255;
  lbColorDominator.Font.Color:=B*256*256+G*256+R;}
 
end;

procedure TPreOCRFrame.sbShowInfoClick(Sender: TObject);
begin
// sbShowInfo.Down:=not(sbShowInfo.Down);
 InfoPanel.Visible:=sbShowInfo.Down;
end;

procedure TPreOCRFrame.ColorBlast;
var BmpX: TBitmap; X,Y, n:integer; PX, PXC: PByteArray;
    PV, PV1, PV2, Pass: byte;

function GetColorNum(R,G,B: byte):integer; //returns dominating color number if any or -1 otherwise
var c, Variance:integer;
begin
 Result:=-1;
   for c:=0 to Length(MainForm.ColorDominators)-1 do
   begin
{      Variance:=Abs(R-MainForm.ColorDominators[c].R)+
                 Abs(G-MainForm.ColorDominators[c].G)+
                 Abs(B-MainForm.ColorDominators[c].B);
     if Variance<MainForm.ColorDominators[C].Deviation then}
     if MainForm.IsMatchingColor(R,G,B,MainForm.ColorDominators[C]) then
     begin
      Result:=c; break;
     end;
   end;
end;

function CheckPixelAntiAliased(X,Y, Thresh:Integer; Mode:byte=0):byte;
var i,j:integer; PPX: PByteArray; PPV: byte;
//    OutlineSignX, OutlineSignY, TextSignX, TextSignY:
    Counters: array[0..8,1..4] of integer; //direction 0 is for "total" counter
    Distances: array[0..8,1..4] of integer; //lowest distance to certain "type"
    Dir, PType: byte;
    Dist: integer;
//     of record  NoColor, OutLine, Text, AntiAlias: integer; end;
function GetDir(XD,YD: integer):byte;
begin
 Result:=1; //for X=0 Y=0
      if (XD=0) and (YD>0) then Result:=1
 else if (XD>0) and (YD>0) then Result:=2
 else if (XD>0) and (YD=0) then Result:=3
 else if (XD>0) and (YD<0) then Result:=4
 else if (XD=0) and (YD<0) then Result:=5
 else if (XD<0) and (YD<0) then Result:=6
 else if (XD<0) and (YD=0) then Result:=7
 else if (XD<0) and (YD>0) then Result:=8;
// else ShowMessage('Error For X:'+IntToStr(XD)+', Y:'+IntToStr(YD));
 //pairs are 1-5, 2-6, 3-7, 4-8 
{ else if (XD<0) and (YD>=0) then Result:=2
 else if (XD<0) and (YD<0) then Result:=3
 else if (XD>=0) and (YD<0) then Result:=4; //temp}
end;

begin
 Result:=128; //still "no color"

 for i:=0 to 8 do for j:=1 to 4 do Counters[i,j]:=0;
 Dist:=Thresh*Thresh*2+10;
 for i:=0 to 8 do for j:=1 to 4 do Distances[i,j]:=Dist;

 for i:=Max(0,Y-Thresh) to Min(BmpX.Height-1,Y+Thresh) do
 begin
  PPX:=BmpX.ScanLine[i];
  for j:=Max(0,X-Thresh) to Min(BmpX.Width-1,X+Thresh) do
  begin
   Dir:=GetDir(X-j,Y-i);
   PPV:=PPX[j];
   case PPV of
    CT_OTHER: PType:=3; //Inc(Counters[Dir,3]);
    CT_ANTIALIAS: PType:=4; //Inc(Counters[Dir,4]);
    CT_OUTLINE: PType:=2; //Inc(Counters[Dir,2]);
    CT_TEXT: PType:=1; //Inc(Counters[Dir,1]);
    else PType:=3; //Inc(Counters[Dir,3]);
   end;
   Inc(Counters[Dir,PType]);
   Inc(Counters[0,PType]);
   
   Dist:=(X-j)*(X-j)+(Y-i)*(Y-i);
   if Dist>0 then
   begin
    if (Dist<Distances[Dir,PType]) then Distances[Dir,PType]:=Dist;
    if (Dist<Distances[0,PType]) then Distances[0,PType]:=Dist;
   end;
  end; //end for j
 end; //end for i
{ if ((Counters[1,1]>0) and (Counters[3,2]>0))
 or ((Counters[3,1]>0) and (Counters[1,2]>0))
 or ((Counters[2,1]>0) and (Counters[4,2]>0))
 or ((Counters[4,1]>0) and (Counters[2,2]>0))}
 if Mode=0 then
 begin
  if PV=128 then //replacing "no color" with antialiasing when applicable
  if ((Counters[1,1]>0) and (Counters[5,2]>0) and (Distances[1,2]>Distances[1,1]))
  or ((Counters[2,1]>0) and (Counters[6,2]>0) and (Distances[2,2]>Distances[2,1]))
  or ((Counters[3,1]>0) and (Counters[7,2]>0) and (Distances[3,2]>Distances[3,1]))
  or ((Counters[4,1]>0) and (Counters[8,2]>0) and (Distances[4,2]>Distances[4,1]))
  or ((Counters[5,1]>0) and (Counters[1,2]>0) and (Distances[5,2]>Distances[5,1]))
  or ((Counters[6,1]>0) and (Counters[2,2]>0) and (Distances[6,2]>Distances[6,1]))
  or ((Counters[7,1]>0) and (Counters[3,2]>0) and (Distances[7,2]>Distances[7,1]))
  or ((Counters[8,1]>0) and (Counters[4,2]>0) and (Distances[8,2]>Distances[8,1]))
  then Result:=CT_ANTIALIAS;

{  if PV=128 then
  begin
   if (Distances[0,2]<=Thresh) and
      ((Distances[0,1]>Distances[0,2]) and (Counters[0,1]>0))
      then Result:=0; //"enhance" outline
  end;}

  if PV=CT_OUTLINE then
   if (Counters[0,1]=0)
   then Result:=CT_OTHER //remove outline if there is no text color around
   else Result:=CT_OUTLINE;

  if PV=CT_TEXT then
   if (Counters[0,2]=0) and (Distances[0,1]>1)
   then Result:=CT_OTHER //remove text if there is no outline color around and no other text around
   else Result:=CT_TEXT;
  end;

  if (Mode=2) then
  begin
   if PV<>CT_TEXT then
   begin
   if (Distances[0,1]<=2) then Result:=CT_ANTIALIAS
   else Result:=CT_OTHER;
   end else Result:=CT_TEXT;
  end;

  if (Mode=3) then
  begin
   if PV=CT_OTHER then
   begin
   if (Distances[0,4]<=2) then Result:=0
   else Result:=CT_OTHER;
   end else Result:=PV;
//   end else Result:=255;
  end;

end;

begin // ------------ Start of ColorBlast ---------------------- // 
 BmpX:=TBitmap.Create;
 BmpX.PixelFormat:=pf8bit;
 BmpX.Width:=Bmp.Width;
 BmpX.Height:=Bmp.Height;
 for Y:=0 to Bmp.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y];
  PXC:=Bmp.ScanLine[Y];
  for X:=0 to Bmp.Width-1 do
  begin
   n:=GetColorNum(PXC[X*3+2],PXC[X*3+1],PXC[X*3]);
   if (n>=0) then
   begin
    case MainForm.ColorDominators[n].DomType of
     0: PX[X]:=CT_OTHER;   //-64+n; // "ignored"
     1: PX[X]:=CT_TEXT;//-n; //text
     2: PX[X]:=CT_OUTLINE;//+n;   //outline
     3: PX[X]:=CT_OTHER;   //+64+n; //"empty"
     else PX[X]:=CT_OTHER;
    end;
   end
   else PX[X]:=CT_OTHER; //indicates "no" dominating color
  end;
 end;

 //ColorBlast Mode 2 - removing all non-text pixels,
 //creating 1-pixel "antialiasing" around,
 //then creating 1-pixel outline around antialiasing
 for Pass:=0 to 2 do
 for Y:=0 to BmpX.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y];
  for X:=0 to BmpX.Width-1 do
  begin
   PV:=PX[X];
   case Pass of
    0: if PV=CT_TEXT then PV:=CheckPixelAntialiased(X,Y,1); //eliminating stray "text"
    1: if (PV<>CT_TEXT) then PV:=CheckPixelAntialiased(X,Y,5,2);
    2: if (PV=CT_OTHER) then PV:=CheckPixelAntialiased(X,Y,5,3);
   end; 
   PX[X]:=PV;
  end;
 end; 

 //ColorBlast Mode 1
{ for Pass:=0 to 2 do
 for Y:=0 to BmpX.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y];
  for X:=0 to BmpX.Width-1 do
  begin
   PV:=PX[X];
    case Pass of
    2: if PV=128 then PV:=CheckPixelAntialiased(X,Y,5);
    1: begin
        if PV=0 then PV:=CheckPixelAntialiased(X,Y,3); //eliminating stray "outline"
        if PV=128 then PV:=CheckPixelAntialiased(X,Y,1); //eliminating stray "outline"
       end;
    0: if PV=255 then PV:=CheckPixelAntialiased(X,Y,3); //eliminating stray "text"
    end;
    PX[X]:=PV;
//     if  then     //128+64;
  end;
 end;}
 for Y:=0 to BmpX.Height-1 do
 begin
  PX:=BmpX.ScanLine[Y];
  for X:=0 to BmpX.Width-1 do
  begin
   PV:=PX[X];
    case PV of
     CT_OUTLINE: PV:=0;
     CT_OTHER: PV:=8;
     CT_ANTIALIAS: PV:=7;
     CT_TEXT: PV:=19; //32
     else PV:=64;
    end;
    PX[X]:=PV;
  end;
 end;
// BmpX.Palette
// Canvas.FloodFill
// BmpX.SaveToFile('res.bmp');
 Bmp.Canvas.Draw(0,0,BmpX);
 BmpX.Free;
end;

procedure TPreOCRFrame.FormCreate(Sender: TObject);
begin
 Init;
end;

end.
