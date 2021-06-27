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
unit SymbolAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TAddSymbolForm = class(TForm)
    Splitter1: TSplitter;
    gbNewSymbol: TGroupBox;
    edText: TEdit;
    btAddNew: TButton;
    btIgnore: TButton;
    Splitter2: TSplitter;
    gbBestMatch: TGroupBox;
    btNoAdd: TButton;
    btRefine: TButton;
    lbMatchInfo: TLabel;
    scrlbNewSymbol: TScrollBox;
    ImageSymbol: TImage;
    scrlbBestMatch: TScrollBox;
    ImageBestMatch: TImage;
    scrlbBestDiff: TScrollBox;
    ImageBestMatchDiff: TImage;
    cbItalic: TCheckBox;
    cbBold: TCheckBox;
    cbUnderline: TCheckBox;
    btPause: TButton;
    btUseFullRect: TButton;
    ContextScroll: TScrollBox;
    ImageContext: TImage;
    procedure edTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddSymbolForm: TAddSymbolForm;

implementation

{$R *.DFM}

procedure TAddSymbolForm.edTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_RETURN then
  if ([ssAlt] = Shift) then ModalResult:=mrYes
  else ModalResult:=mrOk;
end;

procedure TAddSymbolForm.FormShow(Sender: TObject);
begin
// if (ImageContext.
 ImageSymbol.Width:=117;//scrlbNewSymbol.Width-4;
 ImageBestMatch.Width:=181;//scrlbBestMatch.Width-4;
 ImageBestMatchDiff.Width:=181;//scrlbBestDiff.Width-4;
 ImageSymbol.Height:=117;//scrlbNewSymbol.Height-4;
 ImageBestMatch.Height:=117;//scrlbBestMatch.Height-4;
 ImageBestMatchDiff.Height:=117;//scrlbBestDiff.Height-4;
 
 with ImageSymbol do
 if Picture.Bitmap.Width>Width then Width:=Picture.Bitmap.Width;
 with ImageBestMatch do
 if Picture.Bitmap.Width>Width then Width:=Picture.Bitmap.Width;
 with ImageBestMatchDiff do
 if Picture.Bitmap.Width>Width then Width:=Picture.Bitmap.Width;

 with ImageSymbol do
 if Picture.Bitmap.Height>Height then Height:=Picture.Bitmap.Height;
 with ImageBestMatch do
 if Picture.Bitmap.Height>Height then Height:=Picture.Bitmap.Height;
 with ImageBestMatchDiff do
 if Picture.Bitmap.Height>Height then Height:=Picture.Bitmap.Height;

 edText.SetFocus;
end;

end.
