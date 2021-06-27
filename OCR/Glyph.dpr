program Glyph;

uses
  Forms,
  GlyphForm in 'GlyphForm.pas',
  SymbolAdd in 'SymbolAdd.pas' {AddSymbolForm},
  SymbolRefine in 'SymbolRefine.pas' {RefineSymbolForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.HintHidePause:=100000;
  Application.HintPause:=250;
 
  Application.CreateForm(TGlyphForm, GlyphForm1);
  Application.CreateForm(TAddSymbolForm, AddSymbolForm);
  Application.CreateForm(TRefineSymbolForm, RefineSymbolForm);
  Application.Run;
end.
