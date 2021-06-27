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
unit SymbolMatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, GlyphForm;

type
  TSymbolMatchForm = class(TForm)
    ImageDiff1: TImage;
    btFullMatch: TButton;
    TextData: TStaticText;
    ReducedMatch1: TImage;
    ReducedMatch2: TImage;
    btPartialMatch: TButton;
    btElementMatch: TButton;
    btNoMatch: TButton;
    edGlyphText1: TEdit;
    btAddGlyphText: TButton;
    cbItalic: TCheckBox;
    cbBold: TCheckBox;
    cbUnderline: TCheckBox;
    edGlyphText2: TEdit;
    cbItalic2: TCheckBox;
    cbBold2: TCheckBox;
    cbUnderline2: TCheckBox;
    btAddGlyphText2: TButton;
    lbNum1: TLabel;
    lbNum2: TLabel;
    ScrollBox1: TScrollBox;
    ImageMatch1: TImage;
    ScrollBox2: TScrollBox;
    ImageMatch2: TImage;
    procedure FormShow(Sender: TObject);
    procedure btAddGlyphTextClick(Sender: TObject);
    procedure btAddGlyphText2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NumTop, NumBottom: integer; //numbers
    NumTopText, NumBottomText: ^string;
    Mode: byte;
  end;

var
  SymbolMatchForm: TSymbolMatchForm;

implementation

{$R *.DFM}

procedure TSymbolMatchForm.FormShow(Sender: TObject);
{var X,Y:integer;}
begin
{ ReducedMatch1.Picture.Bitmap.Width:=ImageMatch1.Picture.Bitmap.Width div 4;
 ReducedMatch2.Picture.Bitmap.Width:=ImageMatch2.Picture.Bitmap.Width div 4;
 ReducedMatch1.Picture.Bitmap.Height:=ImageMatch1.Picture.Bitmap.Height div 4;
 ReducedMatch2.Picture.Bitmap.Height:=ImageMatch2.Picture.Bitmap.Height div 4;

 for Y:=0 to ImageMatch1.Picture.Bitmap.Height do}
 case Mode of
 0: begin
     NumTopText:=@GlyphForm1.Glyphs[NumTop].Equals;
     NumBottomText:=@GlyphForm1.Glyphs[NumBottom].Equals;
    end;
 1: begin
     NumTopText:=@GlyphForm1.BaseSymbols[NumTop].Text;
     NumBottomText:=@GlyphForm1.BaseSymbols[NumBottom].Text;
    end;
 end;
 if Mode<2 then
 begin
  edGlyphText1.Text:=NumTopText^;
  edGlyphText2.Text:=NumBottomText^;
  lbNum1.Caption:=IntToStr(NumTop);
  lbNum2.Caption:=IntToStr(NumBottom);
  ImageMatch1.Stretch:=(ImageMatch1.Width<ImageMatch1.Picture.Width);
  ImageMatch2.Stretch:=(ImageMatch2.Width<ImageMatch2.Picture.Width);
 end; 

end;

procedure TSymbolMatchForm.btAddGlyphTextClick(Sender: TObject);
begin
 NumTopText^:=edGlyphText1.Text;

end;

procedure TSymbolMatchForm.btAddGlyphText2Click(Sender: TObject);
begin
 NumBottomText^:=edGlyphText2.Text;
end;

procedure TSymbolMatchForm.FormCreate(Sender: TObject);
begin
 Mode:=0;
end;

end.
