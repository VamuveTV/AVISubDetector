object AdjustmentForm: TAdjustmentForm
  Left = 216
  Top = -11
  Width = 638
  Height = 737
  Caption = 'Adjust Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pbFrame: TPaintBox
    Left = 0
    Top = 0
    Width = 630
    Height = 100
    Align = alTop
    OnPaint = pbFramePaint
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 100
    Width = 630
    Height = 72
    Align = alTop
    Caption = 'Sample AVI'
    Constraints.MinWidth = 630
    TabOrder = 0
    object sbGoToFrame: TSpeedButton
      Left = 440
      Top = 41
      Width = 47
      Height = 22
      Caption = 'Go To:'
      OnClick = sbGoToFrameClick
    end
    object sbNextKF: TSpeedButton
      Left = 357
      Top = 42
      Width = 60
      Height = 22
      Caption = 'Next KF'
      OnClick = sbNextKFClick
    end
    object sbPrevKF: TSpeedButton
      Left = 293
      Top = 42
      Width = 60
      Height = 22
      Caption = 'Prev KF'
      OnClick = sbPrevKFClick
    end
    object lbFrameNow: TLabel
      Left = 96
      Top = 48
      Width = 113
      Height = 13
      AutoSize = False
      Caption = 'Frame: 0'
    end
    object btOpenAVI: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Open AVI'
      TabOrder = 0
      OnClick = btOpenAVIClick
    end
    object tbFrames: TTrackBar
      Left = 88
      Top = 16
      Width = 527
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Max = 100
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbFramesChange
    end
    object edGoFrame: TEdit
      Left = 496
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object btOpenImage: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Open Bitmap'
      TabOrder = 3
      OnClick = btOpenImageClick
    end
  end
  object gbCrop: TGroupBox
    Left = 0
    Top = 217
    Width = 630
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
      OnPaint = pbCropPaint
    end
    object tbCropTop: TTrackBar
      Left = 72
      Top = 18
      Width = 543
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
      OnChange = tbCropTopChange
    end
    object tbCropBottom: TTrackBar
      Left = 72
      Top = 42
      Width = 543
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
      OnChange = tbCropTopChange
    end
  end
  object gbDrop: TGroupBox
    Left = 0
    Top = 297
    Width = 630
    Height = 207
    Align = alTop
    Caption = 'Drop Values'
    Constraints.MinWidth = 630
    TabOrder = 2
    object sbRD: TSpeedButton
      Left = 8
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
      Left = 8
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
      Left = 8
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
      Width = 31
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
      Left = 352
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
      Width = 145
      Height = 22
      GroupIndex = 52
      Caption = 'Color Difference'
      OnClick = tbShiftChange
    end
    object sbBWDiffPreview: TSpeedButton
      Left = 480
      Top = 168
      Width = 137
      Height = 22
      GroupIndex = 52
      Caption = 'Black && White'
      OnClick = tbShiftChange
    end
    object sbRevColorDiffPreview: TSpeedButton
      Left = 208
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
    object tbDropRed: TTrackBar
      Left = 40
      Top = 66
      Width = 585
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
      Left = 40
      Top = 90
      Width = 585
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
      Left = 40
      Top = 112
      Width = 585
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
      Left = 40
      Top = 138
      Width = 585
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
      Width = 609
      Height = 17
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = 'Shift: 1 Red: 000 Blue 000 Green: 000 Sum: 000'
      TabOrder = 4
    end
    object tbShift: TTrackBar
      Left = 40
      Top = 37
      Width = 585
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
    Top = 504
    Width = 630
    Height = 129
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
      Top = 114
      Width = 633
      Height = 9
      OnMouseDown = pbDropMouseDown
      OnMouseUp = pbDropMouseUp
      OnPaint = pbBlockPaint
    end
    object sbInvBlockPreview: TSpeedButton
      Left = 159
      Top = 90
      Width = 169
      Height = 22
      GroupIndex = 53
      Caption = 'Inverted Blocks'
      OnClick = tbShiftChange
    end
    object sbColorBlockPreview: TSpeedButton
      Left = 336
      Top = 90
      Width = 169
      Height = 22
      GroupIndex = 53
      Down = True
      Caption = 'Colored Blocks'
      OnClick = tbShiftChange
    end
    object sbEdgeBlockPreview: TSpeedButton
      Left = 512
      Top = 92
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
    object tbBlockSum: TTrackBar
      Left = 80
      Top = 15
      Width = 545
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
      Width = 543
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
      Width = 543
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
  end
  object gbLinePreview: TGroupBox
    Left = 0
    Top = 633
    Width = 630
    Height = 55
    Align = alTop
    Caption = 'Lines'
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
  object gbSettings: TGroupBox
    Left = 0
    Top = 172
    Width = 630
    Height = 45
    Align = alTop
    Caption = 'Settings'
    TabOrder = 5
    object sbCopyFromMain: TSpeedButton
      Left = 8
      Top = 16
      Width = 193
      Height = 22
      Caption = 'Copy From Main'
      OnClick = sbCopyFromMainClick
    end
    object SpeedButton1: TSpeedButton
      Left = 440
      Top = 15
      Width = 193
      Height = 22
      Caption = 'Copy To Main'
      OnClick = SpeedButton1Click
    end
  end
  object OpenAviFile: TOpenDialog
    Filter = 'AVI and AviSynth files|*.avi;*.avs'
    Left = 240
    Top = 80
  end
  object OpenBMP: TOpenPictureDialog
    Left = 272
    Top = 80
  end
end
