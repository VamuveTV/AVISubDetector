object ManualProcessingForm: TManualProcessingForm
  Left = 163
  Top = 236
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Manual Subtitle Control'
  ClientHeight = 267
  ClientWidth = 632
  Color = clBtnFace
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pbSubtitle: TPaintBox
    Left = 0
    Top = 0
    Width = 632
    Height = 105
    Align = alTop
    OnPaint = pbSubtitlePaint
  end
  object SubMemoX: TMemo
    Left = 0
    Top = 105
    Width = 632
    Height = 89
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 225
    Width = 632
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Constraints.MaxHeight = 370
    TabOrder = 1
    object btIgnoreSub: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = 'No &Subtitle'
      ModalResult = 5
      TabOrder = 0
    end
    object btIgnoreChange: TButton
      Left = 88
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Not &Changed'
      ModalResult = 2
      TabOrder = 1
    end
    object btAccept: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Accept Text'
      ModalResult = 1
      TabOrder = 2
      OnClick = btAcceptClick
    end
    object btSkipFrame: TButton
      Left = 264
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Skip to &Next Frame'
      ModalResult = 4
      TabOrder = 3
    end
    object btPause: TButton
      Left = 466
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&PAUSE'
      ModalResult = 3
      TabOrder = 4
    end
    object btStop: TButton
      Left = 546
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'STOP'
      ModalResult = 8
      TabOrder = 5
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 194
    Width = 632
    Height = 31
    Align = alTop
    TabOrder = 2
    object sbItalic: TSpeedButton
      Left = 10
      Top = 5
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 11
      Caption = '&I'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object sbBold: TSpeedButton
      Left = 41
      Top = 5
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 12
      Caption = '&B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sbUnderline: TSpeedButton
      Left = 73
      Top = 5
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 13
      Caption = '&U'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object lbInfo: TLabel
      Left = 104
      Top = 8
      Width = 337
      Height = 13
      AutoSize = False
      Caption = 'Subtitle Information'
    end
    object cbShowFullFrame: TCheckBox
      Left = 514
      Top = 8
      Width = 105
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Show Full Frame'
      TabOrder = 0
      OnClick = cbShowFullFrameClick
    end
  end
end
