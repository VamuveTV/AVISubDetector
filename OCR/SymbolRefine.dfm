object RefineSymbolForm: TRefineSymbolForm
  Left = 221
  Top = 104
  Width = 658
  Height = 481
  Caption = 'Click on removed regions and press OK'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object clbAreas: TCheckListBox
    Left = 385
    Top = 0
    Width = 265
    Height = 454
    OnClickCheck = clbAreasClickCheck
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 454
    Align = alLeft
    TabOrder = 1
    object AreaScroll: TScrollBox
      Left = 0
      Top = 0
      Width = 385
      Height = 385
      TabOrder = 0
      object Image: TImage
        Left = 0
        Top = 8
        Width = 369
        Height = 369
        AutoSize = True
        OnMouseUp = ImageMouseUp
      end
    end
    object btOk: TButton
      Left = 5
      Top = 387
      Width = 169
      Height = 65
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
    object btCancel: TButton
      Left = 182
      Top = 388
      Width = 193
      Height = 65
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
