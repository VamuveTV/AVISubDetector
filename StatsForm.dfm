object StatForm: TStatForm
  Left = 71
  Top = 138
  Width = 832
  Height = 480
  Caption = 'Stats'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pbMainGraph: TPaintBox
    Left = 0
    Top = 105
    Width = 824
    Height = 137
    Align = alTop
    OnMouseDown = pbMainGraphMouseDown
    OnMouseMove = pbMainGraphMouseMove
    OnMouseUp = pbMainGraphMouseUp
    OnPaint = pbMainGraphPaint
  end
  object pbDiffGraph: TPaintBox
    Left = 0
    Top = 245
    Width = 824
    Height = 208
    Align = alClient
    OnMouseDown = pbMainGraphMouseDown
    OnMouseMove = pbMainGraphMouseMove
    OnMouseUp = pbMainGraphMouseUp
    OnPaint = pbMainGraphPaint
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 242
    Width = 824
    Height = 3
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object TCheckListBox
    Left = 8
    Top = 8
    Width = 345
    Height = 89
    ItemHeight = 13
    Items.Strings = (
      'Detected Line Count (DLC) Graph'
      'Average number of blocks per detected line (MED) Graph'
      'Maxmimum Block Count (MBC) Graph'
      'Line Count with equal number of blocks (LBC) Graph'
      'Leftmost Block/pixel (LMB)'
      'Rightmost Block/pixel (RMB)')
    TabOrder = 0
  end
  object pnlStatsControls: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 105
    Align = alTop
    TabOrder = 1
    object stCurrentFrameStats: TStaticText
      Left = 552
      Top = 1
      Width = 128
      Height = 103
      Align = alRight
      AutoSize = False
      Caption = 'Current Frame'
      Color = clWhite
      ParentColor = False
      TabOrder = 0
    end
    object stLastChangedFrame: TStaticText
      Left = 680
      Top = 1
      Width = 143
      Height = 103
      Align = alRight
      AutoSize = False
      Caption = 'Last Changed Frame'
      Color = clWhite
      ParentColor = False
      TabOrder = 1
    end
    object stLocalMax: TStaticText
      Left = 427
      Top = 1
      Width = 125
      Height = 103
      Align = alRight
      AutoSize = False
      Caption = 'Graph Maximums'
      Color = clWhite
      ParentColor = False
      TabOrder = 2
    end
    object clbShowGraphs: TCheckListBox
      Left = 8
      Top = 8
      Width = 345
      Height = 89
      ItemHeight = 13
      Items.Strings = (
        'Detected Line Count (DLC) Graph'
        'Average number of blocks per detected line (MED) Graph'
        'Maxmimum Block Count (MBC) Graph'
        'Line Count with equal number of blocks (LBC) Graph'
        'Leftmost Block/pixel (LMB)'
        'Rightmost Block/pixel (RMB)')
      TabOrder = 3
      OnClick = pbMainGraphPaint
    end
  end
end
