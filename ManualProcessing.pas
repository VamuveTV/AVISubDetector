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
unit ManualProcessing;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TManualProcessingForm = class(TForm)
    pbSubtitle: TPaintBox;
    SubMemoX: TMemo;
    Panel1: TPanel;
    btIgnoreSub: TButton;
    btIgnoreChange: TButton;
    btAccept: TButton;
    btSkipFrame: TButton;
    btPause: TButton;
    btStop: TButton;
    Panel3: TPanel;
    sbItalic: TSpeedButton;
    sbBold: TSpeedButton;
    sbUnderline: TSpeedButton;
    lbInfo: TLabel;
    cbShowFullFrame: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbSubtitlePaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbShowFullFrameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btAcceptClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LocalBitmap: TBitmap;
    SubText: string;
  end;

var
  ManualProcessingForm: TManualProcessingForm;

implementation

uses Unit1, AviFile;

{$R *.DFM}

procedure TManualProcessingForm.FormCreate(Sender: TObject);
begin
 LocalBitmap:=TBitmap.Create;
end;

procedure TManualProcessingForm.FormDestroy(Sender: TObject);
begin
 LocalBitmap.Free;
end;

procedure TManualProcessingForm.pbSubtitlePaint(Sender: TObject);
begin
 BitBlt(pbSubtitle.Canvas.Handle,0,0,
        LocalBitmap.Width,
        LocalBitmap.Height,
        LocalBitmap.Canvas.Handle,0,0,SRCCOPY);
end;

procedure TManualProcessingForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if ([ssAlt]=Shift) then
 begin
  if (Key=VK_SPACE) then ModalResult:=mrCancel else
  if (Key=VK_RETURN) then ModalResult:=mrOk else
  if (Key=65) then ModalResult:=mrOk else
  if (Key=67) then ModalResult:=mrCancel else
  if (Key=83) then ModalResult:=mrIgnore else
  if (Key=78) then ModalResult:=mrRetry else
  if (Key=80) then ModalResult:=mrAbort;
//  else if (Key<>18) then ShowMessage(IntToStr(Key));
  if ModalResult<>mrNone then Key:=0;
 end;
end;

procedure TManualProcessingForm.cbShowFullFrameClick(Sender: TObject);
begin
//
 MainForm.cbFullFramePreview.Checked:=cbShowFullFrame.Checked;
     
     LocalBitmap.Width:=FrameWidth;
     if MainForm.cbFullFramePreview.Checked then LocalBitmap.Height:=FrameHeight
     else LocalBitmap.Height:=FrameHeight - MainForm.ImageCutTop - MainForm.ImageCutBottom; //(FrameHeight div ImagePartial);
     if MainForm.cbFullFramePreview.Checked then Top:=Top - MainForm.ImageCutTop - MainForm.ImageCutBottom
     else Top:=Top + MainForm.ImageCutTop + MainForm.ImageCutBottom; //(FrameHeight div ImagePartial);

     BitBlt(LocalBitmap.Canvas.Handle,0,0,FrameWidth,LocalBitmap.Height,{MainForm.}AviFile.ImageSaved.Canvas.Handle,0,FrameHeight-(LocalBitmap.Height),SRCCOPY);
     pbSubtitle.Height:=LocalBitmap.Height+2;

     AutoSize:=false;
     ClientWidth:=FrameWidth;
     AutoSize:=true;

     if pbSubtitle.Width<>FrameWidth then pbSubtitle.Width:=FrameWidth;


end;

procedure TManualProcessingForm.FormShow(Sender: TObject);
begin
 cbShowFullFrame.Checked:=MainForm.cbFullFramePreview.Checked;
end;

procedure TManualProcessingForm.btAcceptClick(Sender: TObject);
begin
//
 SubText:=SubMemoX.Text;
 if sbItalic.Down then SubText:='<I>'+SubText+'</I>'; 
 if sbBold.Down then SubText:='<B>'+SubText+'</B>';
 if sbUnderline.Down then SubText:='<U>'+SubText+'</U>'; 
end;

procedure TManualProcessingForm.FormHide(Sender: TObject);
begin
 SubText:=SubMemoX.Text;
 if sbItalic.Down then SubText:='<I>'+SubText+'</I>';
 if sbBold.Down then SubText:='<B>'+SubText+'</B>';
 if sbUnderline.Down then SubText:='<U>'+SubText+'</U>';
end;

end.
