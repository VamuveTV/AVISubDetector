object PreOCRFrame: TPreOCRFrame
  Left = 238
  Top = 113
  Width = 443
  Height = 277
  Align = alClient
  Caption = 'PreOCR'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object InfoPanel: TPanel
    Left = 0
    Top = 203
    Width = 435
    Height = 47
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    Visible = False
    object stInfo: TStaticText
      Left = 2
      Top = 2
      Width = 431
      Height = 43
      Align = alClient
      TabOrder = 0
    end
  end
  object gbSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 435
    Height = 89
    Align = alTop
    Caption = 'Settings'
    TabOrder = 0
    object sbClearData: TSpeedButton
      Left = 436
      Top = 16
      Width = 89
      Height = 33
      Caption = 'Clear Data'
      OnClick = sbClearDataClick
    end
    object sbSaveCurrent: TSpeedButton
      Left = 8
      Top = 14
      Width = 153
      Height = 33
      Caption = 'Save Current Data'
      OnClick = sbSaveCurrentClick
    end
    object sbShowPost: TSpeedButton
      Left = 248
      Top = 14
      Width = 137
      Height = 33
      AllowAllUp = True
      GroupIndex = 91
      Caption = 'Show Postprocessed'
      OnClick = sbShowPostClick
    end
    object lbColorX: TLabel
      Left = 114
      Top = 51
      Width = 30
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = 'X'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 30
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      OnClick = lbColorXClick
    end
    object lbColorT: TLabel
      Tag = 1
      Left = 154
      Top = 51
      Width = 30
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = 'T'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 30
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      OnClick = lbColorXClick
    end
    object lbColorO: TLabel
      Tag = 2
      Left = 194
      Top = 51
      Width = 30
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = 'O'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 30
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      OnClick = lbColorXClick
    end
    object lbColorNone: TLabel
      Tag = 3
      Left = 234
      Top = 51
      Width = 30
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 30
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      OnClick = lbColorXClick
    end
    object sbShowInfo: TSpeedButton
      Left = 176
      Top = 14
      Width = 65
      Height = 33
      AllowAllUp = True
      GroupIndex = 17
      Caption = 'Show Info'
      OnClick = sbShowInfoClick
    end
    object SpeedButton1: TSpeedButton
      Left = 272
      Top = 56
      Width = 113
      Height = 22
      Visible = False
    end
    object cbAddFrameData: TCheckBox
      Left = 434
      Top = 51
      Width = 153
      Height = 17
      Caption = 'Add frame data to images'
      TabOrder = 0
      Visible = False
    end
    object cbAutoscroll: TCheckBox
      Left = 8
      Top = 48
      Width = 105
      Height = 17
      Caption = 'Autoscroll to new'
      TabOrder = 1
    end
    object stCurrentStats: TStaticText
      Left = 2
      Top = 70
      Width = 100
      Height = 17
      Caption = ' 0 subpictures found'
      TabOrder = 2
    end
  end
  object scrlbImage: TScrollBox
    Left = 0
    Top = 89
    Width = 435
    Height = 114
    Align = alClient
    TabOrder = 1
    object PreOCRImage: TImage
      Left = 0
      Top = 0
      Width = 399
      Height = 129
      AutoSize = True
      Center = True
      OnMouseDown = PreOCRImageMouseUp
    end
    object PostPreOCRImage: TImage
      Left = 56
      Top = 0
      Width = 399
      Height = 161
      AutoSize = True
      Center = True
      Visible = False
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 312
    Top = 16
  end
end
