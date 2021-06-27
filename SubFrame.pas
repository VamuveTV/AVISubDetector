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
unit SubFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TSubtitleFrame = class(TFrame)
    sgLines: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddLine(Time, Frame: int64; Text, Other: string);
    procedure SetLine(Line, Time, Frame: int64; Text, Other: string);
  end;

implementation

{$R *.DFM}

procedure TSubtitleFrame.AddLine;
var i,j:integer;
begin
 sgLines.RowCount:=sgLines.RowCount+1;
 i:=sgLines.RowCount-2;
 while (i>0) and not(StrToIntDef(sgLines.Cells[1,i],-1)<Frame) do Dec(i);
 if (i=sgLines.RowCount-2) then SetLine(i+1,Time,Frame,Text,Other)
 else
 begin
  for j:=sgLines.RowCount-1 downto i+1 do
   sgLines.Rows[j]:=sgLines.Rows[j-1];
  SetLine(i,Time,Frame,Text,Other);
 end;

end;

procedure TSubtitleFrame.SetLine;
begin
 sgLines.Cells[0,Line]:=IntToStr(Time);
 sgLines.Cells[1,Line]:=IntToStr(Frame);
 sgLines.Cells[2,Line]:=Text;
 sgLines.Cells[3,Line]:=Other;
end;

end.
