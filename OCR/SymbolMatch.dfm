object SymbolMatchForm: TSymbolMatchForm
  Left = 300
  Top = 183
  Width = 509
  Height = 536
  Caption = 'SymbolMatchForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageDiff1: TImage
    Left = 8
    Top = 256
    Width = 209
    Height = 113
    Center = True
  end
  object ReducedMatch1: TImage
    Left = 232
    Top = 288
    Width = 113
    Height = 65
  end
  object ReducedMatch2: TImage
    Left = 352
    Top = 288
    Width = 113
    Height = 65
  end
  object lbNum1: TLabel
    Left = 232
    Top = 64
    Width = 36
    Height = 13
    Caption = 'lbNum1'
  end
  object lbNum2: TLabel
    Left = 232
    Top = 184
    Width = 36
    Height = 13
    Caption = 'lbNum2'
  end
  object btFullMatch: TButton
    Left = 8
    Top = 480
    Width = 105
    Height = 25
    Caption = 'bt&FullMatch'
    ModalResult = 1
    TabOrder = 0
  end
  object TextData: TStaticText
    Left = 8
    Top = 384
    Width = 425
    Height = 81
    AutoSize = False
    Caption = 'TextData'
    TabOrder = 1
  end
  object btPartialMatch: TButton
    Left = 120
    Top = 480
    Width = 105
    Height = 25
    Caption = 'bt&PartialMatch'
    ModalResult = 6
    TabOrder = 2
  end
  object btElementMatch: TButton
    Left = 232
    Top = 480
    Width = 105
    Height = 25
    Caption = 'bt&ElementMatch'
    ModalResult = 7
    TabOrder = 3
  end
  object btNoMatch: TButton
    Left = 344
    Top = 480
    Width = 75
    Height = 25
    Caption = 'bt&NoMatch'
    ModalResult = 5
    TabOrder = 4
  end
  object edGlyphText1: TEdit
    Left = 232
    Top = 8
    Width = 105
    Height = 21
    TabOrder = 5
    OnChange = btAddGlyphTextClick
  end
  object btAddGlyphText: TButton
    Left = 232
    Top = 32
    Width = 105
    Height = 25
    Caption = 'Add New'
    TabOrder = 6
    OnClick = btAddGlyphTextClick
  end
  object cbItalic: TCheckBox
    Left = 360
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Italic'
    TabOrder = 7
  end
  object cbBold: TCheckBox
    Left = 360
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Bold'
    TabOrder = 8
  end
  object cbUnderline: TCheckBox
    Left = 360
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Underline'
    TabOrder = 9
  end
  object edGlyphText2: TEdit
    Left = 232
    Top = 128
    Width = 105
    Height = 21
    TabOrder = 10
    OnChange = btAddGlyphText2Click
  end
  object cbItalic2: TCheckBox
    Left = 360
    Top = 128
    Width = 97
    Height = 17
    Caption = 'Italic'
    TabOrder = 11
  end
  object cbBold2: TCheckBox
    Left = 360
    Top = 144
    Width = 97
    Height = 17
    Caption = 'Bold'
    TabOrder = 12
  end
  object cbUnderline2: TCheckBox
    Left = 360
    Top = 160
    Width = 97
    Height = 17
    Caption = 'Underline'
    TabOrder = 13
  end
  object btAddGlyphText2: TButton
    Left = 232
    Top = 152
    Width = 105
    Height = 25
    Caption = 'Add New'
    TabOrder = 14
    OnClick = btAddGlyphText2Click
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 8
    Width = 217
    Height = 121
    TabOrder = 15
    object ImageMatch1: TImage
      Left = 2
      Top = 2
      Width = 209
      Height = 113
      Center = True
      Stretch = True
    end
  end
  object ScrollBox2: TScrollBox
    Left = 8
    Top = 135
    Width = 217
    Height = 121
    TabOrder = 16
    object ImageMatch2: TImage
      Left = 2
      Top = 2
      Width = 209
      Height = 113
      Center = True
      Stretch = True
    end
  end
end
