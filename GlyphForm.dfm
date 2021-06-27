object GlyphForm: TGlyphForm
  Left = 171
  Top = 128
  Width = 815
  Height = 585
  Caption = 'GlyphForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object ImageMask1: TImage
    Left = 4
    Top = 92
    Width = 640
    Height = 69
  end
  object ImageOrig: TImage
    Left = 4
    Top = 4
    Width = 640
    Height = 77
    OnMouseUp = ImageOrigMouseUp
  end
  object ImageMask2: TImage
    Left = 5
    Top = 169
    Width = 636
    Height = 80
  end
  object ImageMask3: TImage
    Left = 5
    Top = 257
    Width = 636
    Height = 80
  end
  object CheckListBox1: TCheckListBox
    Left = 646
    Top = 0
    Width = 161
    Height = 348
    Align = alRight
    ItemHeight = 13
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 453
    Width = 807
    Height = 105
    Align = alBottom
    Caption = 'GroupBox1'
    TabOrder = 1
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 497
      Height = 49
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object Button1: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = 'btAccept'
      TabOrder = 1
    end
    object Button2: TButton
      Left = 96
      Top = 72
      Width = 75
      Height = 25
      Caption = 'btNone'
      TabOrder = 2
    end
    object Button3: TButton
      Left = 424
      Top = 72
      Width = 75
      Height = 25
      Caption = 'btLoad'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 348
    Width = 807
    Height = 105
    Align = alBottom
    Caption = 'GroupBox2'
    TabOrder = 2
    object edRDT: TEdit
      Left = 128
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '30'
    end
    object edRT: TEdit
      Left = 80
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '255'
    end
    object edRO: TEdit
      Left = 264
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 6
      Text = '0'
    end
    object edGO: TEdit
      Left = 264
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object edGT: TEdit
      Left = 80
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '255'
    end
    object edBT: TEdit
      Left = 80
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '255'
    end
    object edBO: TEdit
      Left = 264
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 8
      Text = '0'
    end
    object edBDT: TEdit
      Left = 128
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '30'
    end
    object edGDT: TEdit
      Left = 128
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '30'
    end
    object btBuildMasks: TButton
      Left = 424
      Top = 24
      Width = 75
      Height = 25
      Caption = 'btBuildMasks'
      TabOrder = 9
      OnClick = btBuildMasksClick
    end
    object btQuarterPel: TButton
      Left = 424
      Top = 56
      Width = 75
      Height = 25
      Caption = 'btQuarterPel'
      TabOrder = 10
      OnClick = btQuarterPelClick
    end
    object edRDO: TEdit
      Left = 312
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 11
      Text = '30'
    end
    object edGDO: TEdit
      Left = 312
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 12
      Text = '30'
    end
    object edBDO: TEdit
      Left = 312
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 13
      Text = '30'
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 432
    Top = 128
  end
end
