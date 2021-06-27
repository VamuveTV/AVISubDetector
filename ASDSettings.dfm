object ASDSettingsFrame: TASDSettingsFrame
  Left = 194
  Top = 92
  Width = 755
  Height = 579
  Align = alClient
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 104
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Subtitle:'
  end
  object PaintBox1: TPaintBox
    Left = 152
    Top = 16
    Width = 33
    Height = 33
    Color = clWhite
    ParentColor = False
  end
  object pnlPreviewSet: TPanel
    Left = 0
    Top = 0
    Width = 747
    Height = 49
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 41
      Height = 13
      Caption = 'Preview:'
    end
    object Label2: TLabel
      Left = 8
      Top = 28
      Width = 41
      Height = 13
      Caption = 'Settings:'
    end
    object cbFullFrame: TCheckBox
      Left = 72
      Top = 8
      Width = 73
      Height = 17
      Caption = 'Full Frame'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbFullFrameClick
    end
    object cbCropFramePv: TCheckBox
      Left = 144
      Top = 8
      Width = 44
      Height = 17
      Caption = 'Crop'
      TabOrder = 1
      OnClick = cbFullFrameClick
    end
    object cbDiffFramePv: TCheckBox
      Left = 248
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Drop'
      TabOrder = 2
      OnClick = cbFullFrameClick
    end
    object cbBlockFramePv: TCheckBox
      Left = 296
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Blocks'
      TabOrder = 3
      OnClick = cbFullFrameClick
    end
    object cbLineFramePv: TCheckBox
      Left = 352
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Lines'
      TabOrder = 4
      OnClick = cbFullFrameClick
    end
    object cbCrop: TCheckBox
      Left = 144
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Crop'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbLineClick
    end
    object cbDrop: TCheckBox
      Left = 248
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Drop'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = cbLineClick
    end
    object cbBlock: TCheckBox
      Left = 296
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Blocks'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = cbLineClick
    end
    object cbLine: TCheckBox
      Left = 352
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Lines'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = cbLineClick
    end
    object cbAllText: TCheckBox
      Left = 72
      Top = 24
      Width = 57
      Height = 17
      Caption = 'All (text)'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = cbLineClick
    end
    object cbFloatingPreview: TCheckBox
      Left = 9463
      Top = 8
      Width = 97
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Floating Preview'
      TabOrder = 10
      OnClick = cbFloatingPreviewClick
    end
    object cbColorPv: TCheckBox
      Left = 192
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Colors'
      TabOrder = 11
      OnClick = cbFullFrameClick
    end
    object cbColor: TCheckBox
      Left = 192
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Colors'
      TabOrder = 12
      OnClick = cbLineClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 49
    Width = 747
    Height = 360
    VertScrollBar.Position = 163
    Align = alClient
    DockSite = True
    TabOrder = 1
    object pbFrame: TPaintBox
      Left = 0
      Top = -118
      Width = 727
      Height = 100
      Align = alTop
      DragKind = dkDock
      OnEndDock = pbFrameEndDock
      OnMouseDown = pbFrameMouseDown
      OnPaint = pbFramePaint
    end
    object GroupBox3: TGroupBox
      Left = 0
      Top = -163
      Width = 727
      Height = 45
      Align = alTop
      Caption = 'Sample'
      Constraints.MinWidth = 630
      TabOrder = 0
      object lbFrameNow: TLabel
        Left = 352
        Top = 24
        Width = 113
        Height = 13
        AutoSize = False
        Caption = 'Frame: 0'
      end
      object btOpenImage: TButton
        Left = 8
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Open Bitmap'
        TabOrder = 0
        OnClick = btOpenImageClick
      end
      object btSaveBitmap: TButton
        Left = 96
        Top = 16
        Width = 113
        Height = 25
        Caption = 'Save Preview Bitmap'
        TabOrder = 1
        OnClick = btSaveBitmapClick
      end
      object btSaveAVIBitmap: TButton
        Left = 217
        Top = 16
        Width = 113
        Height = 25
        Caption = 'Save Original Frame'
        TabOrder = 2
        OnClick = btSaveAVIBitmapClick
      end
    end
    object gbCrop: TGroupBox
      Left = 0
      Top = -18
      Width = 727
      Height = 80
      Align = alTop
      Caption = 'Crop Settings'
      Constraints.MinWidth = 630
      TabOrder = 1
      object lbCropTop: TLabel
        Left = 8
        Top = 24
        Width = 65
        Height = 13
        AutoSize = False
        Caption = 'Top (0%)'
      end
      object lbCropBottom: TLabel
        Left = 8
        Top = 48
        Width = 65
        Height = 13
        AutoSize = False
        Caption = 'Bottom (0%)'
      end
      object pbCrop: TPaintBox
        Left = 5
        Top = 72
        Width = 625
        Height = 9
        OnMouseDown = pbCropMouseDown
        OnPaint = pbCropPaint
      end
      object tbCropTop: TTrackBar
        Left = 72
        Top = 18
        Width = 10635
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 100
        Orientation = trHorizontal
        Frequency = 1
        Position = 75
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbCropBottom: TTrackBar
        Left = 72
        Top = 42
        Width = 10635
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 100
        Orientation = trHorizontal
        Frequency = 1
        Position = 1
        SelEnd = 0
        SelStart = 0
        TabOrder = 1
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
    end
    object gbDrop: TGroupBox
      Left = 0
      Top = 320
      Width = 727
      Height = 207
      Align = alTop
      Caption = 'Drop Values'
      Constraints.MinWidth = 630
      TabOrder = 2
      object sbRD: TSpeedButton
        Left = 32
        Top = 64
        Width = 31
        Height = 22
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        Caption = 'R'
        OnClick = tbShiftChange
      end
      object sbGD: TSpeedButton
        Left = 32
        Top = 88
        Width = 31
        Height = 22
        AllowAllUp = True
        GroupIndex = 2
        Down = True
        Caption = 'G'
        OnClick = tbShiftChange
      end
      object sbBD: TSpeedButton
        Left = 32
        Top = 112
        Width = 31
        Height = 22
        AllowAllUp = True
        GroupIndex = 3
        Down = True
        Caption = 'B'
        OnClick = tbShiftChange
      end
      object sbDSum: TSpeedButton
        Left = 8
        Top = 136
        Width = 57
        Height = 22
        AllowAllUp = True
        GroupIndex = 4
        Down = True
        Caption = 'Sum'
        OnClick = tbShiftChange
      end
      object Label3: TLabel
        Left = 8
        Top = 42
        Width = 24
        Height = 13
        Caption = 'Shift:'
      end
      object pbDrop: TPaintBox
        Left = 8
        Top = 192
        Width = 633
        Height = 9
        OnMouseDown = pbDropMouseDown
        OnMouseUp = pbDropMouseUp
        OnPaint = pbDropPaint
      end
      object sbGrayScaleDiffPreview: TSpeedButton
        Left = 336
        Top = 168
        Width = 121
        Height = 22
        GroupIndex = 52
        Caption = 'Grayscale'
        OnClick = tbShiftChange
      end
      object sbColorDiffPreview: TSpeedButton
        Left = 56
        Top = 168
        Width = 129
        Height = 22
        GroupIndex = 52
        Caption = 'Color Difference'
        OnClick = tbShiftChange
      end
      object sbBWDiffPreview: TSpeedButton
        Left = 464
        Top = 168
        Width = 137
        Height = 22
        GroupIndex = 52
        Caption = 'Black && White'
        OnClick = tbShiftChange
      end
      object sbRevColorDiffPreview: TSpeedButton
        Left = 192
        Top = 168
        Width = 137
        Height = 22
        GroupIndex = 52
        Down = True
        Caption = 'Reverse Color Difference'
        OnClick = tbShiftChange
      end
      object Label4: TLabel
        Left = 8
        Top = 171
        Width = 41
        Height = 13
        Caption = 'Preview:'
      end
      object sbYDiff: TSpeedButton
        Left = 264
        Top = 16
        Width = 89
        Height = 22
        Hint = 'Has no actual effect in real processing now!'
        AllowAllUp = True
        GroupIndex = 71
        Caption = 'Check Y-Diff'
        ParentShowHint = False
        ShowHint = True
        OnClick = tbShiftChange
      end
      object sbShowSubPicRect: TSpeedButton
        Left = 648
        Top = 168
        Width = 73
        Height = 22
        AllowAllUp = True
        GroupIndex = 243
        Down = True
        Caption = 'Subpic Rect'
      end
      object sbRGBD: TSpeedButton
        Left = 8
        Top = 64
        Width = 23
        Height = 72
        AllowAllUp = True
        GroupIndex = 15
        Caption = 'R'#13#10'G'#13#10'B'
      end
      object tbDropRed: TTrackBar
        Left = 64
        Top = 66
        Width = 10642
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 255
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbDropGreen: TTrackBar
        Left = 64
        Top = 90
        Width = 10642
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 255
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 1
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbDropBlue: TTrackBar
        Left = 64
        Top = 112
        Width = 10642
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 255
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbDropSum: TTrackBar
        Left = 64
        Top = 138
        Width = 10642
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Max = 765
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 3
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object stDropSettings: TStaticText
        Left = 8
        Top = 16
        Width = 249
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'Shift: 1 Red: 000 Blue 000 Green: 000 Sum: 000'
        TabOrder = 4
      end
      object tbShift: TTrackBar
        Left = 40
        Top = 37
        Width = 10666
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 5
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
        OnChange = tbShiftChange
      end
    end
    object gbBlock: TGroupBox
      Left = 0
      Top = 527
      Width = 727
      Height = 150
      Align = alTop
      Caption = 'Blocks'
      Constraints.MinWidth = 630
      TabOrder = 3
      object lbBlockVal: TLabel
        Left = 8
        Top = 18
        Width = 73
        Height = 13
        AutoSize = False
        Caption = 'Value (200)'
      end
      object lbBlockCount: TLabel
        Left = 8
        Top = 42
        Width = 73
        Height = 13
        AutoSize = False
        Caption = 'Count (3)'
      end
      object pbBlock: TPaintBox
        Left = 8
        Top = 138
        Width = 633
        Height = 9
        OnMouseDown = pbDropMouseDown
        OnMouseUp = pbDropMouseUp
        OnPaint = pbBlockPaint
      end
      object sbInvBlockPreview: TSpeedButton
        Left = 87
        Top = 114
        Width = 169
        Height = 22
        GroupIndex = 53
        Caption = 'Inverted Blocks'
        OnClick = tbShiftChange
      end
      object sbColorBlockPreview: TSpeedButton
        Left = 256
        Top = 114
        Width = 169
        Height = 22
        GroupIndex = 53
        Down = True
        Caption = 'Colored Blocks'
        OnClick = tbShiftChange
      end
      object sbEdgeBlockPreview: TSpeedButton
        Left = 432
        Top = 114
        Width = 105
        Height = 22
        AllowAllUp = True
        GroupIndex = 59
        Down = True
        Caption = 'Show Block Edges'
        OnClick = tbShiftChange
      end
      object lbBlockSize: TLabel
        Left = 8
        Top = 66
        Width = 73
        Height = 13
        AutoSize = False
        Caption = 'Size (16)'
      end
      object sbUseBlockOverlap: TSpeedButton
        Left = 544
        Top = 114
        Width = 65
        Height = 22
        AllowAllUp = True
        Caption = 'Overlap'
        Enabled = False
        Visible = False
      end
      object sbCenterWeight: TSpeedButton
        Left = 8
        Top = 88
        Width = 65
        Height = 22
        AllowAllUp = True
        GroupIndex = 17
        Down = True
        Caption = 'CenterW'
      end
      object tbBlockSum: TTrackBar
        Left = 80
        Top = 15
        Width = 10626
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 4000
        Orientation = trHorizontal
        Frequency = 1
        Position = 200
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbBlockCount: TTrackBar
        Left = 80
        Top = 42
        Width = 10626
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 3
        SelEnd = 0
        SelStart = 0
        TabOrder = 1
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbBlockSize: TTrackBar
        Left = 79
        Top = 65
        Width = 10626
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Max = 64
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 16
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbCenterWeight: TTrackBar
        Left = 80
        Top = 89
        Width = 10626
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Max = 32
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 2
        SelEnd = 0
        SelStart = 0
        TabOrder = 3
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
    end
    object gbLine: TGroupBox
      Left = 0
      Top = 677
      Width = 727
      Height = 55
      Align = alTop
      Caption = 'Lines'
      Constraints.MinWidth = 630
      TabOrder = 4
      object pbLine: TPaintBox
        Left = 8
        Top = 40
        Width = 633
        Height = 9
        OnMouseDown = pbDropMouseDown
        OnMouseUp = pbDropMouseUp
        OnPaint = pbLinePaint
      end
      object sbInvLinePreview: TSpeedButton
        Left = 87
        Top = 14
        Width = 169
        Height = 22
        GroupIndex = 54
        Down = True
        Caption = 'Inverted Lines'
        OnClick = tbShiftChange
      end
      object sbColorLinePreview: TSpeedButton
        Left = 264
        Top = 14
        Width = 169
        Height = 22
        GroupIndex = 54
        Caption = 'Colored Lines'
        OnClick = tbShiftChange
      end
    end
    object gbColorDom: TGroupBox
      Left = 0
      Top = 62
      Width = 727
      Height = 178
      Align = alTop
      Caption = 'Color Domination'
      TabOrder = 5
      object pbPostCrop: TPaintBox
        Left = 7
        Top = 107
        Width = 697
        Height = 65
        OnPaint = pbPostCropPaint
      end
      object lbColorX: TLabel
        Left = 25
        Top = 67
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
        OnClick = lbColorXClick
      end
      object lbColorT: TLabel
        Tag = 1
        Left = 24
        Top = 35
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
        OnClick = lbColorXClick
      end
      object lbColorO: TLabel
        Tag = 2
        Left = 80
        Top = 35
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
        OnClick = lbColorXClick
      end
      object lbColorNone: TLabel
        Tag = 3
        Left = 80
        Top = 67
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
        OnClick = lbColorXClick
      end
      object Label19: TLabel
        Left = 8
        Top = 16
        Width = 137
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'PreProcessing Colors'
      end
      object cbPreprocess: TCheckBox
        Left = 104
        Top = 0
        Width = 145
        Height = 17
        Caption = 'Use Color Preprocessing'
        TabOrder = 0
        OnClick = tbShiftChange
      end
      object cbColorDomReplaceAll: TCheckBox
        Left = 264
        Top = 0
        Width = 113
        Height = 17
        Caption = 'Replace all colors'
        TabOrder = 1
        Visible = False
        OnClick = tbShiftChange
      end
      object cbKillStrayGray: TCheckBox
        Left = 400
        Top = 0
        Width = 121
        Height = 17
        Caption = 'Remove Stray Gray'
        Enabled = False
        TabOrder = 2
        Visible = False
        OnClick = tbShiftChange
      end
      object edPreKillStrayRepeat: TEdit
        Left = 528
        Top = 0
        Width = 33
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 3
        Text = '4'
        Visible = False
        OnChange = tbShiftChange
      end
      object cbPreX: TCheckBox
        Left = 56
        Top = 72
        Width = 17
        Height = 17
        TabOrder = 4
        OnClick = tbShiftChange
      end
      object cbPreT: TCheckBox
        Left = 56
        Top = 40
        Width = 17
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = tbShiftChange
      end
      object cbPreO: TCheckBox
        Left = 112
        Top = 40
        Width = 17
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = tbShiftChange
      end
      object cbPreOther: TCheckBox
        Left = 112
        Top = 72
        Width = 17
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = tbShiftChange
      end
      object pnlColorText: TPanel
        Left = 218
        Top = 15
        Width = 487
        Height = 90
        BevelInner = bvLowered
        TabOrder = 8
        object sbPrevDominator: TSpeedButton
          Left = 16
          Top = 16
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = sbPrevDominatorClick
        end
        object lbColorDominator: TLabel
          Left = 48
          Top = 16
          Width = 41
          Height = 41
          Alignment = taCenter
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 40
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          OnClick = lbColorDominatorClick
        end
        object sbNextDominator: TSpeedButton
          Left = 96
          Top = 16
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = sbNextDominatorClick
        end
        object sbDeleteDominator: TSpeedButton
          Left = 96
          Top = 40
          Width = 23
          Height = 22
          Caption = '-'
          OnClick = sbDeleteDominatorClick
        end
        object sbAddDominator: TSpeedButton
          Left = 16
          Top = 40
          Width = 23
          Height = 22
          Caption = '+'
          Enabled = False
          OnClick = PanelSettingsToData
        end
        object lbCurrentDominator: TLabel
          Left = 48
          Top = 56
          Width = 41
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '1/1'
        end
        object lbDominatorRGB: TLabel
          Left = 16
          Top = 72
          Width = 105
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'R: 255 G:255 B:255'
        end
        object Label20: TLabel
          Left = 136
          Top = 20
          Width = 11
          Height = 13
          Caption = 'R:'
        end
        object Label21: TLabel
          Left = 136
          Top = 44
          Width = 11
          Height = 13
          Caption = 'G:'
        end
        object Label22: TLabel
          Left = 136
          Top = 68
          Width = 10
          Height = 13
          Caption = 'B:'
        end
        object Label23: TLabel
          Left = 192
          Top = 44
          Width = 27
          Height = 13
          Caption = 'GDiff:'
        end
        object Label24: TLabel
          Left = 192
          Top = 68
          Width = 26
          Height = 13
          Caption = 'BDiff:'
        end
        object Label25: TLabel
          Left = 192
          Top = 20
          Width = 27
          Height = 13
          Caption = 'RDiff:'
        end
        object Label10: TLabel
          Left = 8
          Top = 0
          Width = 273
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'Separation by subtitle color (Shift-LMB on Crop preview)'
        end
        object Label11: TLabel
          Left = 328
          Top = 12
          Width = 71
          Height = 13
          Hint = 
            'Accepted deviation from dominating color to be still considered ' +
            'dominating (as sum of absolute differences by R,G,B)'
          Caption = 'Def. Deviation:'
          FocusControl = edDominatorColorVariation
          ParentShowHint = False
          ShowHint = True
        end
        object edDomR: TEdit
          Left = 152
          Top = 16
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '0'
          OnChange = tbShiftChange
        end
        object edDomG: TEdit
          Left = 152
          Top = 40
          Width = 33
          Height = 21
          TabOrder = 1
          Text = '0'
          OnChange = tbShiftChange
        end
        object edDomB: TEdit
          Left = 152
          Top = 64
          Width = 33
          Height = 21
          TabOrder = 2
          Text = '0'
          OnChange = tbShiftChange
        end
        object edDomRD: TEdit
          Left = 224
          Top = 16
          Width = 33
          Height = 21
          TabOrder = 3
          Text = '30'
          OnChange = tbShiftChange
        end
        object edDomGD: TEdit
          Left = 224
          Top = 40
          Width = 33
          Height = 21
          TabOrder = 4
          Text = '30'
          OnChange = tbShiftChange
        end
        object edDomBD: TEdit
          Left = 224
          Top = 64
          Width = 33
          Height = 21
          TabOrder = 5
          Text = '30'
          OnChange = tbShiftChange
        end
        object cbDominatorMode1: TCheckBox
          Left = 328
          Top = 32
          Width = 153
          Height = 17
          Hint = 
            'Blocks not containing any of dominating colors are ignored (get ' +
            'value of 0)'
          Caption = 'Ignore blocks without color'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = PanelSettingsToData
        end
        object cbDominatorMode2: TCheckBox
          Left = 328
          Top = 48
          Width = 153
          Height = 17
          Hint = 
            'Any transition to and from dominating color gets maximum absolut' +
            'e difference rating'
          Caption = 'Assign maximum value'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = PanelSettingsToData
        end
        object cbDominatorMode3: TCheckBox
          Left = 328
          Top = 64
          Width = 81
          Height = 17
          Hint = 
            'Sum of absolute differences for blocks containing dominating col' +
            'ors is multiplied by set value'
          Caption = 'Multiply by'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = PanelSettingsToData
        end
        object edDominatorMode3: TEdit
          Left = 408
          Top = 64
          Width = 65
          Height = 21
          Enabled = False
          TabOrder = 9
          Text = '10'
          OnChange = PanelSettingsToData
        end
        object edDominatorColorVariation: TEdit
          Left = 408
          Top = 8
          Width = 65
          Height = 21
          Hint = 
            'Acceptable deviation from dominating color as sum of absolute R,' +
            'G,B differences from dominating color (default)'
          TabOrder = 10
          Text = '15'
          OnChange = PanelSettingsToData
        end
      end
    end
    object gbTemporalDiff: TGroupBox
      Left = 0
      Top = 240
      Width = 727
      Height = 80
      Align = alTop
      Caption = 'Temporal Settings'
      Constraints.MinWidth = 630
      TabOrder = 6
      Visible = False
      object Label26: TLabel
        Left = 8
        Top = 24
        Width = 65
        Height = 13
        AutoSize = False
        Caption = 'Top (0%)'
      end
      object Label27: TLabel
        Left = 8
        Top = 48
        Width = 65
        Height = 13
        AutoSize = False
        Caption = 'Bottom (0%)'
      end
      object pbTemporalDiff: TPaintBox
        Left = 5
        Top = 72
        Width = 625
        Height = 9
        OnMouseDown = pbCropMouseDown
        OnPaint = pbCropPaint
      end
      object tbFramesUsed: TTrackBar
        Left = 72
        Top = 18
        Width = 10635
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 100
        Orientation = trHorizontal
        Frequency = 1
        Position = 75
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
      object tbTemporalDelta: TTrackBar
        Left = 72
        Top = 42
        Width = 10635
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Max = 100
        Orientation = trHorizontal
        Frequency = 1
        Position = 1
        SelEnd = 0
        SelStart = 0
        TabOrder = 1
        ThumbLength = 15
        TickMarks = tmBottomRight
        TickStyle = tsAuto
        OnChange = tbShiftChange
      end
    end
  end
  object gbDetectionSettings: TGroupBox
    Left = 0
    Top = 409
    Width = 747
    Height = 143
    Align = alBottom
    Caption = 'Detection Settings'
    Color = clBtnFace
    ParentColor = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    object lbDrop: TLabel
      Left = 120
      Top = 41
      Width = 121
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Drop Differences Below'
      Color = clWhite
      ParentColor = False
    end
    object Label5: TLabel
      Left = 248
      Top = 32
      Width = 65
      Height = 13
      Hint = 
        'Небходимая сумма модулей разностей между пикселами в блоке для "' +
        'подозрения" существования в нём субтитра'
      AutoSize = False
      Caption = 'Block Value:'
      ParentShowHint = False
      ShowHint = True
    end
    object Label7: TLabel
      Left = 248
      Top = 76
      Width = 65
      Height = 13
      AutoSize = False
      Caption = 'Block Count:'
    end
    object sbImageFull: TSpeedButton
      Tag = 1
      Left = 8
      Top = 16
      Width = 31
      Height = 22
      Hint = 'Check complete image'
      GroupIndex = 5
      Caption = 'Full'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbImageFullClick
    end
    object sbHalf: TSpeedButton
      Tag = 2
      Left = 8
      Top = 40
      Width = 33
      Height = 22
      Hint = 'Check only lower half of image'
      GroupIndex = 5
      Caption = '1/2'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbImageFullClick
    end
    object sbImageOneThird: TSpeedButton
      Tag = 3
      Left = 8
      Top = 64
      Width = 33
      Height = 22
      Hint = 'Check only lower 1/3 of image'
      GroupIndex = 5
      Caption = '1/3'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbImageFullClick
    end
    object sbImageQuarter: TSpeedButton
      Tag = 4
      Left = 8
      Top = 88
      Width = 33
      Height = 22
      Hint = 'Check only lower 1/4 of image'
      GroupIndex = 5
      Down = True
      Caption = '1/4'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbImageFullClick
    end
    object sbOneFifth: TSpeedButton
      Tag = 5
      Left = 8
      Top = 112
      Width = 33
      Height = 22
      Hint = 'Check only lower 1/5 of image'
      GroupIndex = 5
      Caption = '1/5'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbImageFullClick
    end
    object Label8: TLabel
      Left = 248
      Top = 98
      Width = 65
      Height = 13
      AutoSize = False
      Caption = 'Line Count:'
    end
    object Label9: TLabel
      Left = 376
      Top = 16
      Width = 185
      Height = 13
      Hint = 'Отслеживание изменений субтитров'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tracking Changes'
      Color = clWhite
      ParentColor = False
    end
    object Label12: TLabel
      Left = 608
      Top = 107
      Width = 31
      Height = 13
      Caption = 'frames'
    end
    object Label13: TLabel
      Left = 92
      Top = 36
      Width = 8
      Height = 13
      Caption = '%'
    end
    object Label14: TLabel
      Left = 92
      Top = 76
      Width = 8
      Height = 13
      Caption = '%'
    end
    object Label15: TLabel
      Left = 48
      Top = 16
      Width = 44
      Height = 13
      Caption = 'Crop Top'
    end
    object Label16: TLabel
      Left = 48
      Top = 56
      Width = 58
      Height = 13
      Caption = 'Crop Bottom'
    end
    object Label17: TLabel
      Left = 248
      Top = 54
      Width = 65
      Height = 13
      Hint = 
        'Небходимая сумма модулей разностей между пикселами в блоке для "' +
        'подозрения" существования в нём субтитра'
      AutoSize = False
      Caption = 'Block Size:'
      ParentShowHint = False
      ShowHint = True
    end
    object Label18: TLabel
      Left = 552
      Top = 123
      Width = 54
      Height = 13
      Caption = 'frames long'
      Visible = False
    end
    object edDropLow: TEdit
      Left = 128
      Top = 120
      Width = 33
      Height = 21
      Hint = 'Drop sum to zero if difference is less then set value'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '100'
      OnChange = PanelSettingsToData
    end
    object edBlockValue: TEdit
      Left = 320
      Top = 28
      Width = 33
      Height = 21
      Hint = 
        'Minimum sum of absolute differences between pixels to consider b' +
        'lock "sharp" (absolute maximum for black-and-white vertical stri' +
        'pes is 12240)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '200'
      OnChange = PanelSettingsToData
    end
    object tbSharpOffset: TTrackBar
      Left = 120
      Top = 16
      Width = 57
      Height = 25
      Hint = 'Distance between pixels checked for absolute difference (1-4)'
      Max = 5
      Min = 1
      Orientation = trHorizontal
      ParentShowHint = False
      Frequency = 1
      Position = 1
      SelEnd = 0
      SelStart = 0
      ShowHint = True
      TabOrder = 2
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = PanelSettingsToData
    end
    object cbCentralDomination: TCheckBox
      Left = 248
      Top = 120
      Width = 65
      Height = 17
      Hint = 
        'Central double-blocks are considered to have twice as much weigh' +
        't as others (for detecting small subtitles)'
      Caption = 'CenterW'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 3
      OnClick = PanelSettingsToData
    end
    object edDropGreen: TEdit
      Left = 128
      Top = 77
      Width = 33
      Height = 21
      Hint = 
        'Drop green part of sum to zero if difference is less then set va' +
        'lue'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '100'
      OnChange = PanelSettingsToData
    end
    object cbDropRed: TCheckBox
      Left = 168
      Top = 56
      Width = 57
      Height = 17
      Caption = 'Red'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = PanelSettingsToData
    end
    object cbDropGreen: TCheckBox
      Left = 168
      Top = 79
      Width = 57
      Height = 17
      Caption = 'Green'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = PanelSettingsToData
    end
    object cbDropBlue: TCheckBox
      Left = 168
      Top = 102
      Width = 57
      Height = 17
      Caption = 'Blue'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = PanelSettingsToData
    end
    object edDropBlue: TEdit
      Left = 128
      Top = 99
      Width = 33
      Height = 21
      Hint = 
        'Drop blue part of sum to zero if difference is less then set val' +
        'ue'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Text = '100'
      OnChange = PanelSettingsToData
    end
    object edDropRed: TEdit
      Left = 128
      Top = 56
      Width = 33
      Height = 21
      Hint = 
        'Drop red part of sum to zero if difference is less then set valu' +
        'e'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '100'
      OnChange = PanelSettingsToData
    end
    object cbDropSum: TCheckBox
      Left = 168
      Top = 121
      Width = 57
      Height = 17
      Caption = 'Sum'
      TabOrder = 10
      OnClick = PanelSettingsToData
    end
    object edLineBlockMinimum: TEdit
      Left = 320
      Top = 72
      Width = 33
      Height = 21
      Hint = 'Minumum number of double-blocks in line to consider it "sharp"'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      Text = '3'
      OnChange = PanelSettingsToData
    end
    object cbCheckMaxLineBlocks: TCheckBox
      Left = 479
      Top = 32
      Width = 41
      Height = 17
      Hint = 
        'Detect change using maximum number of blocks in line as change c' +
        'riteria'
      Caption = 'MBC'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnClick = PanelSettingsToData
    end
    object cbCheckLineNumber: TCheckBox
      Left = 376
      Top = 34
      Width = 41
      Height = 17
      Hint = 
        'Detection of subtitle change by rapid changes of Detected Line C' +
        'ount'
      Caption = 'DLC'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 13
      OnClick = PanelSettingsToData
    end
    object edLineNumberChangeThreshold: TEdit
      Left = 432
      Top = 32
      Width = 33
      Height = 21
      Hint = 'Track number of sharp double-lines as change criteria'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Text = '5'
      OnChange = PanelSettingsToData
    end
    object edLineCountNeeded: TEdit
      Left = 320
      Top = 94
      Width = 33
      Height = 21
      Hint = 
        'Minimum number of double-lines required to consider frame as con' +
        'taining subtitle'
      HideSelection = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Text = '5'
      OnChange = PanelSettingsToData
    end
    object edMaxLineBlockDiff: TEdit
      Left = 528
      Top = 30
      Width = 33
      Height = 21
      Hint = 'Track maximum number of blocks in line as change criteria'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Text = '1'
      OnChange = PanelSettingsToData
    end
    object cbCheckLineAvg: TCheckBox
      Left = 376
      Top = 83
      Width = 47
      Height = 17
      Hint = 
        'Detection of subtitle change as changes of average number of blo' +
        'cks per detected line'
      Caption = 'MED'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      OnClick = PanelSettingsToData
    end
    object edLineAvgThreshold: TEdit
      Left = 432
      Top = 80
      Width = 33
      Height = 21
      Hint = 
        'Track 10*(number of double-blocks in sharp lines)/(number of sha' +
        'rp lines) [average number of blocks per sharp line] as change cr' +
        'iteria'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      Text = '20'
      OnChange = PanelSettingsToData
    end
    object btSaveSettings: TButton
      Left = 572
      Top = 43
      Width = 75
      Height = 25
      Hint = 'Save setting into file'
      Caption = 'Save Settings'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      OnClick = btSaveSettingsClick
    end
    object btLoadSettings: TButton
      Left = 572
      Top = 16
      Width = 75
      Height = 25
      Hint = 'Load Settings from File'
      Caption = 'Load Settings'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 20
      OnClick = btLoadSettingsClick
    end
    object edLBCLimiter: TEdit
      Left = 528
      Top = 54
      Width = 33
      Height = 21
      Hint = 
        'Track maximum number of lines with same double-block count as ch' +
        'ange criteria (value in () is block count)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      Text = '5'
      OnChange = PanelSettingsToData
    end
    object cbCheckBlockLines: TCheckBox
      Left = 479
      Top = 56
      Width = 41
      Height = 17
      Hint = 
        'Detection of subtitle change as change of number of lines with s' +
        'ame number of blocks'
      Caption = 'LBC'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      OnClick = PanelSettingsToData
    end
    object cbNoSingleFrame: TCheckBox
      Left = 376
      Top = 105
      Width = 201
      Height = 17
      Hint = 'Limit minimal distance between changes'
      Caption = 'Skip change if distance is less then '
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 23
      OnClick = PanelSettingsToData
    end
    object edMinimalFrameDistance: TEdit
      Left = 568
      Top = 103
      Width = 33
      Height = 21
      Hint = 'Minimum distance between consecutive changes'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 24
      Text = '5'
      OnChange = PanelSettingsToData
    end
    object edCutFromTop: TEdit
      Left = 48
      Top = 32
      Width = 41
      Height = 21
      TabOrder = 25
      Text = '75'
      OnChange = PanelSettingsToData
    end
    object edCutFromBottom: TEdit
      Left = 48
      Top = 72
      Width = 41
      Height = 21
      TabOrder = 26
      Text = '1'
      OnChange = PanelSettingsToData
    end
    object edBlockSize: TEdit
      Left = 320
      Top = 50
      Width = 33
      Height = 21
      Hint = 'Block size (in pixels)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 27
      Text = '16'
      OnChange = PanelSettingsToData
    end
    object edCenterWeight: TEdit
      Left = 319
      Top = 117
      Width = 33
      Height = 21
      Hint = '"Weight" added to double-blocks in the center'
      HideSelection = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 28
      Text = '2'
      OnChange = PanelSettingsToData
    end
    object edLRMBLimit: TEdit
      Left = 432
      Top = 56
      Width = 33
      Height = 21
      Hint = 'Width change threshold (in pixels)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 29
      Text = '20'
      OnChange = PanelSettingsToData
    end
    object cbCheckLeftRightMost: TCheckBox
      Left = 376
      Top = 59
      Width = 57
      Height = 17
      Hint = 
        'Leftmost/Rightmost Block - Detection of subtitle change as chang' +
        'es of "average" subtitle width (in pixels)'
      Caption = 'L/RMB'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 30
      OnClick = PanelSettingsToData
    end
    object cbYDiff: TCheckBox
      Left = 184
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Y Diff'
      TabOrder = 31
      OnClick = PanelSettingsToData
    end
    object cbPeakProtection: TCheckBox
      Left = 376
      Top = 121
      Width = 129
      Height = 17
      Hint = 'Ignore peaks'
      Caption = 'Ignore Peaks less then '
      ParentShowHint = False
      ShowHint = True
      TabOrder = 32
      Visible = False
      OnClick = PanelSettingsToData
    end
    object edPeakSize: TEdit
      Left = 512
      Top = 119
      Width = 33
      Height = 21
      Hint = 'Minimum distance between consecutive changes'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 33
      Text = '3'
      Visible = False
      OnChange = PanelSettingsToData
    end
  end
  object OpenAviFile: TOpenDialog
    Filter = 'AVI and AviSynth files|*.avi;*.avs'
    Left = 440
    Top = 16
  end
  object OpenBMP: TOpenPictureDialog
    Left = 472
    Top = 16
  end
  object dlgSavePicture: TSavePictureDialog
    Left = 504
    Top = 16
  end
  object OpenConfig: TOpenDialog
    Filter = 'SubDetector Settings file|*.sdt|All Files|*.*'
    Left = 537
    Top = 16
  end
  object SaveConfig: TSaveDialog
    Filter = 'SubDetector Settings file|*.sdt|All Files|*.*'
    Left = 608
    Top = 8
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 568
    Top = 16
  end
end
