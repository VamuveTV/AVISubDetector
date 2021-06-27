object Form2: TForm2
  Left = 287
  Top = 81
  Width = 650
  Height = 623
  Caption = 'Active Preview Setup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
  end
  object Panel: TPanel
    Left = 0
    Top = 480
    Width = 642
    Height = 116
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 0
    object tbFrames: TTrackBar
      Left = 8
      Top = 8
      Width = 625
      Height = 25
      Max = 100000
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
    object PageControl1: TPageControl
      Left = 8
      Top = 32
      Width = 625
      Height = 81
      ActivePage = TabSheet1
      TabOrder = 1
      object TabSheet1: TTabSheet
        Hint = 'Image preprocessing (before subtitle detection)'
        Caption = 'Preprocessing'
        ParentShowHint = False
        ShowHint = True
        object cbSharpenPreprocess: TCheckBox
          Left = 8
          Top = 0
          Width = 81
          Height = 17
          Caption = 'Sharpen'
          Enabled = False
          TabOrder = 0
        end
        object cbDropRed: TCheckBox
          Left = 488
          Top = 0
          Width = 129
          Height = 17
          Hint = 'Sum of Absolute Differences for Red Channel'
          Caption = 'Red SAD Threshold'
          TabOrder = 1
        end
        object CheckBox1: TCheckBox
          Left = 488
          Top = 16
          Width = 129
          Height = 17
          Hint = 'Sum of Absolute Differences for Green Channel'
          Caption = 'Green SAD Threshold'
          TabOrder = 2
        end
        object CheckBox2: TCheckBox
          Left = 488
          Top = 32
          Width = 129
          Height = 17
          Hint = 'Sum of Absolute Differences for Blue Channel'
          Caption = 'Blue SAD Threshold'
          TabOrder = 3
        end
      end
      object TabSheet2: TTabSheet
        Hint = 'Basic block settings'
        Caption = 'Blocks'
        ImageIndex = 1
        object Label1: TLabel
          Left = 8
          Top = 0
          Width = 57
          Height = 13
          Alignment = taCenter
          Caption = 'Block Value'
        end
        object Label2: TLabel
          Left = 7
          Top = 21
          Width = 58
          Height = 13
          Alignment = taCenter
          Caption = 'Block Count'
        end
        object Label3: TLabel
          Left = 7
          Top = 37
          Width = 51
          Height = 13
          Alignment = taCenter
          Caption = 'Line Count'
        end
        object TrackBar1: TTrackBar
          Left = 87
          Top = 0
          Width = 481
          Height = 20
          Max = 120
          Orientation = trHorizontal
          Frequency = 1
          Position = 2
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          ThumbLength = 10
          TickMarks = tmBottomRight
          TickStyle = tsAuto
        end
        object TrackBar2: TTrackBar
          Left = 87
          Top = 21
          Width = 481
          Height = 20
          Max = 30
          Min = 1
          Orientation = trHorizontal
          Frequency = 1
          Position = 3
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          ThumbLength = 10
          TickMarks = tmBottomRight
          TickStyle = tsAuto
        end
        object TrackBar3: TTrackBar
          Left = 87
          Top = 37
          Width = 481
          Height = 20
          Max = 30
          Min = 1
          Orientation = trHorizontal
          Frequency = 1
          Position = 5
          SelEnd = 0
          SelStart = 0
          TabOrder = 2
          ThumbLength = 10
          TickMarks = tmBottomRight
          TickStyle = tsAuto
        end
      end
      object TabSheet3: TTabSheet
        Hint = 'Subtitle change detection'
        Caption = 'Changes'
        ImageIndex = 2
      end
      object TabSheet4: TTabSheet
        Hint = 'Temporal subtitle separation'
        Caption = 'Temporal'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
      end
      object TabSheet5: TTabSheet
        Caption = 'Colors'
        ImageIndex = 4
      end
      object TabSheet6: TTabSheet
        Caption = 'Auto Profiling'
        ImageIndex = 5
      end
    end
  end
end
