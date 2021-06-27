program AVISubDetector;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  UScript in 'UScript.pas',
  ManualProcessing in 'ManualProcessing.pas' {ManualProcessingForm},
  AVIFile in 'AviFile.pas',
  ColorControl in 'ColorControl.pas' {ColorControlFrame: TFrame},
  GlyphForm in 'OCR\GlyphForm.pas' {GlyphForm},
  SymbolAdd in 'OCR\SymbolAdd.pas' {AddSymbolForm},
  SymbolRefine in 'OCR\SymbolRefine.pas' {RefineSymbolForm},
  StatsForm in 'StatsForm.pas' {StatForm},
  PreOCR in 'PreOCR.pas' {PreOCRFrame},
  ASDSettings in 'ASDSettings.pas' {frmASDSettings},
  StatThread in 'StatThread.pas',
  FrameProcessing in 'FrameProcessing.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AVISubDetector v0.6.x.xBeta';
  Application.HintHidePause:=100000;
  Application.HintPause:=250;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TManualProcessingForm, ManualProcessingForm);
  Application.CreateForm(TGlyphForm, GlyphForm1);
  Application.CreateForm(TAddSymbolForm, AddSymbolForm);
  Application.CreateForm(TRefineSymbolForm, RefineSymbolForm);
  Application.CreateForm(TStatForm, StatForm);
  Application.CreateForm(TPreOCRFrame, PreOCRFrame);
  Application.CreateForm(TASDSettingsFrame, frmASDSettings);
  Application.Run;
end.
