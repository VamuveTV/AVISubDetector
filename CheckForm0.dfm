object CheckForm: TCheckForm
  Left = 253
  Top = 89
  Width = 650
  Height = 614
  Caption = 'CheckForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MainImage: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
  end
  object gbCheckData: TGroupBox
    Left = 0
    Top = 482
    Width = 642
    Height = 105
    Align = alBottom
    Caption = 'Checks'
    TabOrder = 0
    object sbTransfer: TSpeedButton
      Left = 8
      Top = 16
      Width = 65
      Height = 22
      Caption = 'Transfer'
      OnClick = sbTransferClick
    end
    object sbColorsUsed: TSpeedButton
      Left = 8
      Top = 48
      Width = 65
      Height = 22
      Caption = 'ColorSpace'
      OnClick = sbColorsUsedClick
    end
  end
end
