object ColorControlFrame: TColorControlFrame
  Left = 0
  Top = 0
  Width = 746
  Height = 626
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object scrlbColorControl: TScrollBox
    Left = 0
    Top = 44
    Width = 746
    Height = 582
    Align = alClient
    TabOrder = 0
    object pbScatterPlotRG: TPaintBox
      Tag = 1
      Left = 16
      Top = 184
      Width = 256
      Height = 256
      Hint = 'X-Red Y-Green'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotRGPaint
    end
    object pbScatterPlotGB: TPaintBox
      Tag = 2
      Left = 280
      Top = 184
      Width = 256
      Height = 256
      Hint = 'X-Green Y-Blue'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotGBPaint
    end
    object pbScatterPlotBG: TPaintBox
      Tag = 3
      Left = 542
      Top = 184
      Width = 256
      Height = 256
      Hint = 'X-Blue Y-Green'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotBGPaint
    end
    object pbScatterPlotBR: TPaintBox
      Tag = 6
      Left = 542
      Top = 445
      Width = 256
      Height = 256
      Hint = 'X-Blue Y-Red'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotBRPaint
    end
    object pbScatterPlotGR: TPaintBox
      Tag = 5
      Left = 280
      Top = 445
      Width = 256
      Height = 256
      Hint = 'X-Green Y-Red'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotGRPaint
    end
    object pbScatterPlotRB: TPaintBox
      Tag = 4
      Left = 16
      Top = 445
      Width = 256
      Height = 256
      Hint = 'X-Red Y-Blue'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = pbScatterPlotRGMouseDown
      OnPaint = pbScatterPlotRBPaint
    end
    object tbR: TTrackBar
      Left = 8
      Top = 32
      Width = 600
      Height = 25
      Max = 255
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object tbG: TTrackBar
      Left = 8
      Top = 48
      Width = 600
      Height = 25
      Max = 255
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 2
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object tbB: TTrackBar
      Left = 8
      Top = 64
      Width = 600
      Height = 25
      Max = 255
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 3
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object btAnalyze: TButton
      Tag = 1
      Left = 16
      Top = 0
      Width = 113
      Height = 25
      Caption = '*Color Map*'
      TabOrder = 0
      OnClick = btAnalyzeClick
      OnKeyDown = btAnalyzeKeyDown
    end
    object tbLimit: TTrackBar
      Left = 8
      Top = 160
      Width = 600
      Height = 25
      Max = 500
      Min = 1
      Orientation = trHorizontal
      Frequency = 1
      Position = 1
      SelEnd = 0
      SelStart = 0
      TabOrder = 5
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object tbDev: TTrackBar
      Left = 8
      Top = 88
      Width = 600
      Height = 25
      Max = 255
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 4
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object btAnalyzeDrop: TButton
      Tag = 2
      Left = 136
      Top = 0
      Width = 113
      Height = 25
      Caption = 'Difference Map'
      TabOrder = 6
      OnClick = btAnalyzeClick
      OnKeyDown = btAnalyzeKeyDown
    end
    object tbRD: TTrackBar
      Left = 8
      Top = 104
      Width = 600
      Height = 25
      Hint = 'Acceptable Difference in Red Channel'
      Max = 255
      Orientation = trHorizontal
      ParentShowHint = False
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 7
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object tbGD: TTrackBar
      Left = 8
      Top = 120
      Width = 600
      Height = 25
      Hint = 'Acceptable Difference in Green Channel'
      Max = 255
      Orientation = trHorizontal
      ParentShowHint = False
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 8
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
    object tbBD: TTrackBar
      Left = 8
      Top = 136
      Width = 600
      Height = 25
      Hint = 'Acceptable Difference in Blue Channel'
      Max = 255
      Orientation = trHorizontal
      ParentShowHint = False
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 9
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbRChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 746
    Height = 44
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object pbDominators: TPaintBox
      Left = 2
      Top = 2
      Width = 742
      Height = 39
      Align = alTop
      OnMouseDown = pbDominatorsMouseDown
      OnPaint = pbDominatorsPaint
    end
  end
end
