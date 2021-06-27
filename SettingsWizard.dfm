object SettingsWizardForm: TSettingsWizardForm
  Left = 121
  Top = 102
  Width = 597
  Height = 459
  Caption = 'AVISubDetector Settings Wizard'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox2: TPaintBox
    Left = 8
    Top = 8
    Width = 401
    Height = 329
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 589
    Height = 432
    ActivePage = tbsStep4
    Align = alClient
    TabOrder = 0
    object tbsStep1: TTabSheet
      Caption = 'Step 1'
      object pbFrame: TPaintBox
        Left = 0
        Top = 0
        Width = 401
        Height = 329
      end
      object tbFrames: TTrackBar
        Left = 0
        Top = 336
        Width = 401
        Height = 25
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
      object Memo1: TMemo
        Left = 408
        Top = 0
        Width = 169
        Height = 329
        Lines.Strings = (
          'Pick frame containing subtitle'
          'and press Next')
        ReadOnly = True
        TabOrder = 1
      end
      object btNext1: TButton
        Left = 408
        Top = 336
        Width = 169
        Height = 65
        Caption = 'Next ->'
        TabOrder = 2
      end
    end
    object tbsStep2: TTabSheet
      Caption = 'Step 2'
      ImageIndex = 1
      object PaintBox1: TPaintBox
        Left = 0
        Top = 0
        Width = 401
        Height = 329
      end
      object Memo2: TMemo
        Left = 408
        Top = 0
        Width = 169
        Height = 329
        Lines.Strings = (
          'Crop redudant parts of image'
          'and press Next')
        ReadOnly = True
        TabOrder = 0
      end
      object Button1: TButton
        Left = 408
        Top = 336
        Width = 169
        Height = 65
        Caption = 'Next ->'
        TabOrder = 1
      end
      object tbCropTop: TTrackBar
        Left = 0
        Top = 336
        Width = 401
        Height = 25
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
      object tbCropBottom: TTrackBar
        Left = 0
        Top = 360
        Width = 401
        Height = 25
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 3
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
    end
    object tbsStep3: TTabSheet
      Caption = 'Step 3'
      ImageIndex = 2
      object PaintBox3: TPaintBox
        Left = 0
        Top = 0
        Width = 401
        Height = 329
      end
      object Memo3: TMemo
        Left = 408
        Top = 0
        Width = 169
        Height = 329
        Lines.Strings = (
          'Adjust "noise reduction" settings '
          'until you will see subtitle outline'
          'and press Next')
        ReadOnly = True
        TabOrder = 0
      end
      object Button2: TButton
        Left = 408
        Top = 336
        Width = 169
        Height = 65
        Caption = 'Next ->'
        TabOrder = 1
      end
      object TrackBar1: TTrackBar
        Left = 80
        Top = 336
        Width = 321
        Height = 25
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
      object ComboBox1: TComboBox
        Left = 8
        Top = 336
        Width = 73
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          'R/G/B'
          'Sum'
          'R'
          'G'
          'B')
      end
    end
    object tbsStep4: TTabSheet
      Caption = 'Step 4'
      ImageIndex = 3
      object PaintBox4: TPaintBox
        Left = 0
        Top = 0
        Width = 401
        Height = 329
      end
      object Memo4: TMemo
        Left = 408
        Top = 0
        Width = 169
        Height = 329
        Lines.Strings = (
          'Adjust "block" settings until'
          'until you will see more or less'
          'solid line on subtitle, set'
          'line count to value equal'
          'or less to height of resulting line'
          'and press Save')
        ReadOnly = True
        TabOrder = 0
      end
      object Button3: TButton
        Left = 408
        Top = 336
        Width = 169
        Height = 65
        Caption = 'Next ->'
        TabOrder = 1
      end
      object TrackBar2: TTrackBar
        Left = 80
        Top = 336
        Width = 321
        Height = 25
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
      object ComboBox2: TComboBox
        Left = 8
        Top = 336
        Width = 73
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          'R/G/B'
          'Sum'
          'R'
          'G'
          'B')
      end
    end
  end
end
