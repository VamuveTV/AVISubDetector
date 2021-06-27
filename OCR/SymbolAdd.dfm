object AddSymbolForm: TAddSymbolForm
  Left = 258
  Top = 0
  Width = 608
  Height = 490
  Caption = 'AddSymbolForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 460
    Width = 600
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Splitter2: TSplitter
    Left = 145
    Top = 161
    Width = 3
    Height = 299
    Cursor = crHSplit
  end
  object gbNewSymbol: TGroupBox
    Left = 0
    Top = 161
    Width = 145
    Height = 299
    Align = alLeft
    Caption = 'gbNewSymbol'
    TabOrder = 0
    object edText: TEdit
      Left = 8
      Top = 152
      Width = 129
      Height = 21
      TabOrder = 0
      OnKeyUp = edTextKeyUp
    end
    object btAddNew: TButton
      Left = 8
      Top = 200
      Width = 129
      Height = 25
      Caption = '&Add New Symbol'
      ModalResult = 1
      TabOrder = 1
    end
    object btIgnore: TButton
      Left = 8
      Top = 272
      Width = 129
      Height = 25
      Cancel = True
      Caption = 'I&gnore'
      ModalResult = 5
      TabOrder = 2
    end
    object btNoAdd: TButton
      Left = 8
      Top = 224
      Width = 129
      Height = 25
      Caption = '&Match without Adding'
      ModalResult = 6
      TabOrder = 3
    end
    object btRefine: TButton
      Left = 8
      Top = 248
      Width = 129
      Height = 25
      Caption = 'REMOVE'
      ModalResult = 2
      TabOrder = 4
    end
    object scrlbNewSymbol: TScrollBox
      Left = 8
      Top = 16
      Width = 129
      Height = 129
      TabOrder = 5
      object ImageSymbol: TImage
        Left = 4
        Top = 4
        Width = 117
        Height = 117
        Center = True
      end
    end
    object cbItalic: TCheckBox
      Left = 8
      Top = 176
      Width = 33
      Height = 17
      Caption = '&I'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 6
    end
    object cbBold: TCheckBox
      Left = 48
      Top = 176
      Width = 33
      Height = 17
      Caption = '&B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
    end
    object cbUnderline: TCheckBox
      Left = 88
      Top = 176
      Width = 33
      Height = 17
      Caption = '&U'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
  end
  object gbBestMatch: TGroupBox
    Left = 148
    Top = 161
    Width = 452
    Height = 299
    Align = alClient
    Caption = 'gbBestMatch'
    TabOrder = 1
    object lbMatchInfo: TLabel
      Left = 8
      Top = 152
      Width = 433
      Height = 73
      AutoSize = False
      Caption = 'lbMatchInfo'
    end
    object scrlbBestMatch: TScrollBox
      Left = 8
      Top = 16
      Width = 217
      Height = 129
      TabOrder = 0
      object ImageBestMatch: TImage
        Left = 4
        Top = 4
        Width = 205
        Height = 117
        Center = True
      end
    end
    object scrlbBestDiff: TScrollBox
      Left = 232
      Top = 16
      Width = 217
      Height = 129
      TabOrder = 1
      object ImageBestMatchDiff: TImage
        Left = 4
        Top = 4
        Width = 205
        Height = 117
        Center = True
      end
    end
    object btPause: TButton
      Left = 152
      Top = 240
      Width = 297
      Height = 57
      Caption = '&PAUSE'
      ModalResult = 3
      TabOrder = 2
    end
    object btUseFullRect: TButton
      Left = 8
      Top = 240
      Width = 137
      Height = 57
      Caption = 'Use &Full Rect'
      Enabled = False
      ModalResult = 10
      TabOrder = 3
    end
  end
  object ContextScroll: TScrollBox
    Left = 0
    Top = 0
    Width = 600
    Height = 161
    Align = alTop
    TabOrder = 2
    object ImageContext: TImage
      Left = 0
      Top = 0
      Width = 598
      Height = 153
      AutoSize = True
    end
  end
end
