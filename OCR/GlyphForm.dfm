object GlyphForm: TGlyphForm
  Left = 83
  Top = 98
  Width = 890
  Height = 617
  Caption = 'Glyph Recognition for AviSubDetector v0.6beta'
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
  object MaimPage: TPageControl
    Left = 0
    Top = 0
    Width = 882
    Height = 552
    ActivePage = tbsMain
    Align = alClient
    TabOrder = 0
    object tbsMain: TTabSheet
      Caption = 'Main'
      object scrlImages: TScrollBox
        Left = 0
        Top = 201
        Width = 874
        Height = 323
        Align = alClient
        TabOrder = 0
        object ImageOrig: TImage
          Left = 2
          Top = 8
          Width = 640
          Height = 77
          Center = True
          Visible = False
          OnMouseMove = ImageOrigMouseMove
          OnMouseUp = ImageOrigMouseUp
        end
        object ImageMask2: TImage
          Left = 2
          Top = 174
          Width = 639
          Height = 80
          Center = True
          Visible = False
          OnMouseUp = ImageMask2MouseUp
        end
        object ImageMask3: TImage
          Left = 2
          Top = 88
          Width = 639
          Height = 80
          Center = True
          Visible = False
          OnMouseDown = ImageMask3MouseDown
          OnMouseMove = ImageMaskXMouseMove
          OnMouseUp = ImageMask3MouseUp
        end
        object ImageMask4: TImage
          Left = 2
          Top = 262
          Width = 639
          Height = 80
          Center = True
          Visible = False
          OnMouseUp = ImageMask2MouseUp
        end
        object ImageMask5: TImage
          Left = 2
          Top = 306
          Width = 639
          Height = 80
          Center = True
          Visible = False
          OnMouseUp = ImageMask2MouseUp
        end
      end
      object gbSettings: TGroupBox
        Left = 0
        Top = 0
        Width = 874
        Height = 201
        Align = alTop
        Caption = 'gbSettings'
        TabOrder = 1
        object sbPause: TSpeedButton
          Left = 728
          Top = 64
          Width = 129
          Height = 73
          AllowAllUp = True
          GroupIndex = 3124
          Caption = 'PAUSE'
        end
        object btClearTxtIgnore: TButton
          Left = 592
          Top = 64
          Width = 121
          Height = 25
          Caption = 'Clear Ignore-Points'
          TabOrder = 0
          OnClick = btClearTxtIgnoreClick
        end
        object btLoad: TButton
          Left = 592
          Top = 24
          Width = 257
          Height = 33
          Caption = 'Load Training Sample'
          TabOrder = 1
          OnClick = btLoadClick
        end
        object btAddGlyphs: TButton
          Left = 592
          Top = 112
          Width = 121
          Height = 25
          Caption = 'OCR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btAddGlyphsClick
        end
        object stGlyphText: TMemo
          Left = 656
          Top = 144
          Width = 201
          Height = 49
          TabOrder = 3
          WordWrap = False
        end
        object PageControl1: TPageControl
          Left = 2
          Top = 15
          Width = 455
          Height = 184
          ActivePage = tbsClearing
          Align = alLeft
          TabOrder = 4
          object tbsClearing: TTabSheet
            Caption = 'Clearing Settings'
            ImageIndex = 1
            object Panel4: TPanel
              Left = 0
              Top = 0
              Width = 447
              Height = 41
              Align = alTop
              TabOrder = 0
              object Label17: TLabel
                Left = 296
                Top = 16
                Width = 33
                Height = 13
                Caption = 'Preset:'
              end
              object cmbPreset: TComboBox
                Left = 336
                Top = 12
                Width = 97
                Height = 21
                Hint = 'Text/Outline Mask Creation Presets'
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
                OnChange = cmbPresetChange
                Items.Strings = (
                  'Base Preset'
                  'Alternative Base'
                  'Without outline fill')
              end
              object tlbPreset: TToolBar
                Left = 4
                Top = 6
                Width = 280
                Height = 29
                Align = alNone
                Caption = 'tlbPreset'
                EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
                EdgeOuter = esNone
                Images = ImageListX
                TabOrder = 1
                object tlbUp: TToolButton
                  Left = 0
                  Top = 2
                  Caption = 'tlbUp'
                  ImageIndex = 0
                  OnClick = sbMoveUpClick
                end
                object tlbDown: TToolButton
                  Left = 23
                  Top = 2
                  Caption = 'tlbDown'
                  ImageIndex = 1
                  OnClick = sbMoveDownClick
                end
                object ToolButton1: TToolButton
                  Left = 46
                  Top = 2
                  Caption = 'ToolButton1'
                  ImageIndex = 2
                  OnClick = sbSetMaskActionClick
                end
                object edMaskActionParam: TEdit
                  Left = 69
                  Top = 2
                  Width = 41
                  Height = 22
                  TabOrder = 0
                  Text = '0'
                end
                object cmbMaskActions: TComboBox
                  Left = 110
                  Top = 2
                  Width = 113
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 1
                  Items.Strings = (
                    'No Action'
                    'Build Text Mask'
                    'Build Outline Mask'
                    'Remove Open Areas from Text Mask'
                    'Fill from Edges in Outline Mask'
                    'Eliminate One-Pixel objects in Text Mask'
                    'Enclose Text Mask'
                    'Enclose Outline Mask'
                    '*Match Text Mask to Outline Mask (Maximum Distance)'
                    '*Grow Text Mask (Passes)'
                    '*Grow Outline Mask (Passes)'
                    'Subtract Outline Mask from Text Mask'
                    'Draw Open-Edge Line on Text Mask'
                    'Apply Ignore-Fill points for Text Mask'
                    'Apply Ignore-Fill points for Outline Mask'
                    '*Build Diff Mask (Distance = div 1000, Min Diff = mod 1000) '
                    '*Grow Diff Mask (Passes)'
                    
                      'Reverse Subtract Diff Mask from Text Mask (and open affected are' +
                      'a) ')
                end
                object ToolButton3: TToolButton
                  Left = 223
                  Top = 2
                  Caption = 'ToolButton3'
                  ImageIndex = 4
                  OnClick = sbAddMaskActionClick
                end
                object ToolButton2: TToolButton
                  Left = 246
                  Top = 2
                  Caption = 'ToolButton2'
                  ImageIndex = 3
                  OnClick = sbDeleteMaskActionClick
                end
              end
            end
            object clbBuildMaskList: TCheckListBox
              Left = 0
              Top = 41
              Width = 447
              Height = 115
              Align = alClient
              ItemHeight = 13
              TabOrder = 1
              OnMouseUp = clbBuildMaskListMouseUp
            end
          end
          object tbsRects: TTabSheet
            Caption = 'Symbol Rects'
            ImageIndex = 5
            object sbSubRectRefine: TSpeedButton
              Left = 8
              Top = 8
              Width = 89
              Height = 49
              AllowAllUp = True
              GroupIndex = 44
              Down = True
              Caption = 'Refine Rects'
              OnClick = btBuildMasksClick
            end
            object Label10: TLabel
              Left = 112
              Top = 16
              Width = 79
              Height = 13
              Caption = 'Minumum Width:'
            end
            object Label11: TLabel
              Left = 112
              Top = 40
              Width = 82
              Height = 13
              Caption = 'Minumum Height:'
            end
            object Label13: TLabel
              Left = 240
              Top = 40
              Width = 104
              Height = 13
              Caption = 'Minimum Area (pixels):'
            end
            object Label14: TLabel
              Left = 88
              Top = 70
              Width = 106
              Height = 13
              Caption = 'Minumum Text Height:'
            end
            object Label12: TLabel
              Left = 240
              Top = 16
              Width = 114
              Height = 13
              Caption = 'Max Diacritics Distance:'
            end
            object edMinWidth: TEdit
              Left = 198
              Top = 13
              Width = 33
              Height = 21
              TabOrder = 0
              Text = '8'
            end
            object edUniteVerticalLimit: TEdit
              Left = 358
              Top = 13
              Width = 35
              Height = 21
              TabOrder = 1
              Text = '12'
            end
            object edMinVolume: TEdit
              Left = 360
              Top = 37
              Width = 33
              Height = 21
              Hint = 'Minimum Volume required'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              Text = '60'
            end
            object edMinHeight: TEdit
              Left = 198
              Top = 36
              Width = 33
              Height = 21
              TabOrder = 3
              Text = '8'
            end
            object edMinTextHeight: TEdit
              Left = 200
              Top = 64
              Width = 33
              Height = 21
              Hint = 'Minimum Text Height'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              Text = '40'
            end
          end
          object tbsOCRSettings: TTabSheet
            Caption = 'OCR Settings'
            ImageIndex = 2
            object Label1: TLabel
              Left = 13
              Top = 11
              Width = 86
              Height = 13
              Caption = 'Required Similarity'
            end
            object Label2: TLabel
              Left = 148
              Top = 11
              Width = 8
              Height = 13
              Caption = '%'
            end
            object Label3: TLabel
              Left = 16
              Top = 109
              Width = 76
              Height = 13
              Caption = 'Space Distance'
            end
            object Label4: TLabel
              Left = 148
              Top = 35
              Width = 8
              Height = 13
              Caption = '%'
            end
            object Label5: TLabel
              Left = 148
              Top = 107
              Width = 26
              Height = 13
              Caption = 'pixels'
            end
            object Label6: TLabel
              Left = 16
              Top = 133
              Width = 82
              Height = 13
              Caption = 'Interline Distance'
            end
            object Label7: TLabel
              Left = 148
              Top = 131
              Width = 26
              Height = 13
              Caption = 'pixels'
            end
            object Label8: TLabel
              Left = 8
              Top = 59
              Width = 76
              Height = 26
              Alignment = taCenter
              Caption = 'Compare'#13#10'"Enhancement"'
            end
            object sbBestMatchSearch: TSpeedButton
              Left = 168
              Top = 8
              Width = 73
              Height = 22
              Hint = 'Always perform full search for best match'
              AllowAllUp = True
              GroupIndex = 307
              Down = True
              Caption = 'Best Match'
              ParentShowHint = False
              ShowHint = True
            end
            object sbBeepOnNewSymbol: TSpeedButton
              Left = 168
              Top = 56
              Width = 73
              Height = 30
              Hint = 'Beep on New Symbol'
              AllowAllUp = True
              GroupIndex = 632
              Down = True
              Caption = 'Beep on New'
              ParentShowHint = False
              ShowHint = True
            end
            object edAutoMatchThresh: TEdit
              Left = 104
              Top = 7
              Width = 41
              Height = 21
              TabOrder = 0
              Text = '98.5'
            end
            object edManualMatchThresh: TEdit
              Left = 104
              Top = 32
              Width = 41
              Height = 21
              TabOrder = 1
              Text = '80.1'
            end
            object edSpaceSize: TEdit
              Left = 104
              Top = 104
              Width = 41
              Height = 21
              TabOrder = 2
              Text = '24'
            end
            object edLineSize: TEdit
              Left = 104
              Top = 128
              Width = 41
              Height = 21
              TabOrder = 3
              Text = '30'
            end
            object edCompareEnhancement: TEdit
              Left = 104
              Top = 63
              Width = 41
              Height = 21
              TabOrder = 4
              Text = '3'
            end
            object GroupBox1: TGroupBox
              Left = 256
              Top = 8
              Width = 185
              Height = 137
              Caption = 'Multipass elimination'
              TabOrder = 5
              object sbEliminateIntersectingMatch: TSpeedButton
                Left = 8
                Top = 62
                Width = 169
                Height = 22
                AllowAllUp = True
                GroupIndex = 205
                Caption = 'Intersecting with letter regions'
              end
              object sbEliminateIntersectingXMatch: TSpeedButton
                Left = 8
                Top = 39
                Width = 169
                Height = 22
                AllowAllUp = True
                GroupIndex = 206
                Caption = 'Below and above letters'
              end
              object sbEliminateInsideMatch: TSpeedButton
                Left = 8
                Top = 16
                Width = 169
                Height = 22
                AllowAllUp = True
                GroupIndex = 207
                Down = True
                Caption = 'Inside letter regions'
              end
              object sbEliminateOutsideOfBand: TSpeedButton
                Left = 8
                Top = 110
                Width = 169
                Height = 22
                AllowAllUp = True
                GroupIndex = 219
                Caption = 'Outside of base bands'
              end
              object sbStrikeLine: TSpeedButton
                Left = 8
                Top = 83
                Width = 169
                Height = 22
                AllowAllUp = True
                GroupIndex = 229
                Caption = 'Lines around known letters'
              end
            end
          end
          object tbsAnalyze: TTabSheet
            Caption = 'Auto Color'
            ImageIndex = 3
            object lbAnalyzeColor1: TLabel
              Left = 16
              Top = 64
              Width = 81
              Height = 81
              Alignment = taCenter
              AutoSize = False
              Color = clWhite
              ParentColor = False
              OnMouseUp = lbAnalyzeColor2MouseUp
            end
            object lbAnalyzeColor2: TLabel
              Left = 112
              Top = 64
              Width = 81
              Height = 81
              Alignment = taCenter
              AutoSize = False
              Color = clBlack
              ParentColor = False
              OnMouseUp = lbAnalyzeColor2MouseUp
            end
            object sbFullColorSearch: TSpeedButton
              Left = 144
              Top = 8
              Width = 41
              Height = 22
              Hint = 'Full Search (slow)'
              AllowAllUp = True
              GroupIndex = 901
              Down = True
              Caption = 'FULL'
            end
            object sbHalfShift: TSpeedButton
              Left = 96
              Top = 8
              Width = 41
              Height = 22
              AllowAllUp = True
              GroupIndex = 903
              Down = True
              Caption = '+1/2'
            end
            object sbTextIsLighter: TSpeedButton
              Left = 272
              Top = 8
              Width = 121
              Height = 22
              Hint = 'If pressed, Darker color out of two best becomes Outline'
              AllowAllUp = True
              GroupIndex = 906
              Down = True
              Caption = 'Text Color is Lighter'
              ParentShowHint = False
              ShowHint = True
            end
            object sbModeX: TSpeedButton
              Left = 200
              Top = 8
              Width = 57
              Height = 22
              AllowAllUp = True
              GroupIndex = 1052
              Caption = 'Mode X'
            end
            object Label15: TLabel
              Left = 208
              Top = 64
              Width = 120
              Height = 13
              Caption = 'Text Difference Multiplier:'
            end
            object Label16: TLabel
              Left = 200
              Top = 92
              Width = 132
              Height = 13
              Caption = 'Outline Difference Multiplier:'
            end
            object btAnalyze: TButton
              Left = 16
              Top = 8
              Width = 73
              Height = 25
              Caption = 'Analyze'
              TabOrder = 0
              OnClick = btAnalyzeClick
            end
            object edAnalyzeDivider: TEdit
              Left = 144
              Top = 40
              Width = 41
              Height = 21
              Hint = 'Maximum colorspace reduction delta'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Text = '64'
            end
            object edAnalyzeShift: TEdit
              Left = 16
              Top = 40
              Width = 41
              Height = 21
              Hint = 'Distance between pixels checked for difference'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              Text = '6'
            end
            object edAnalyzeDiffLimit: TEdit
              Left = 72
              Top = 40
              Width = 41
              Height = 21
              Hint = 
                'Minimum Difference to be counted - increase for High-contrast su' +
                'btitles, decrease for low-contrast'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              Text = '100'
            end
            object edTextFinalDelta: TEdit
              Left = 336
              Top = 60
              Width = 49
              Height = 21
              Hint = 'Multiplier for final Text ColorMask delta (best colors)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              Text = '1.0'
            end
            object btAreaDiffMapX: TButton
              Left = 208
              Top = 120
              Width = 179
              Height = 25
              Caption = 'btAreaDiffMapX'
              TabOrder = 5
              OnClick = btAreaDiffMapXClick
            end
            object edOutlineFinalDelta: TEdit
              Left = 336
              Top = 88
              Width = 49
              Height = 21
              Hint = 'Multiplier for final Outline ColorMask delta (best colors)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              Text = '1.0'
            end
          end
          object tbsColors: TTabSheet
            Caption = 'Colors'
            object sbGrowOutlineMatch: TSpeedButton
              Left = 224
              Top = 32
              Width = 105
              Height = 22
              AllowAllUp = True
              GroupIndex = 701
              Caption = 'Grow Outline Match'
            end
            object sbGrowTextMatch: TSpeedButton
              Left = 224
              Top = 8
              Width = 105
              Height = 22
              AllowAllUp = True
              GroupIndex = 700
              Caption = 'Grow Text Match'
            end
            object lbColorX: TLabel
              Left = 16
              Top = 8
              Width = 80
              Height = 80
              Alignment = taCenter
              AutoSize = False
              Caption = 'Tb'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 40
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              OnMouseUp = lbColorXMouseUp
            end
            object sbPrevClr: TSpeedButton
              Tag = -1
              Left = 16
              Top = 88
              Width = 23
              Height = 22
              Caption = '<'
              OnClick = sbNextClrClick
            end
            object sbNextClr: TSpeedButton
              Tag = 1
              Left = 72
              Top = 88
              Width = 23
              Height = 22
              Caption = '>'
              OnClick = sbNextClrClick
            end
            object sbDeleteClr: TSpeedButton
              Left = 16
              Top = 112
              Width = 81
              Height = 22
              Caption = 'DELETE'
              OnClick = sbDeleteClrClick
            end
            object lbClrSel: TLabel
              Left = 39
              Top = 92
              Width = 33
              Height = 13
              Alignment = taCenter
              AutoSize = False
              Caption = '1/2'
            end
            object sbSetDominator: TSpeedButton
              Left = 104
              Top = 88
              Width = 89
              Height = 22
              Caption = 'SET'
              OnClick = sbSetDominatorClick
            end
            object sbQuarterPel: TSpeedButton
              Left = 224
              Top = 64
              Width = 81
              Height = 22
              AllowAllUp = True
              GroupIndex = 61
              Down = True
              Caption = 'Quarter Pixels'
            end
            object sbReduceColors: TSpeedButton
              Left = 224
              Top = 112
              Width = 89
              Height = 22
              Caption = 'Reduce Colors'
              Enabled = False
            end
            object sbCopyDominatorsFromMain: TSpeedButton
              Left = 104
              Top = 112
              Width = 89
              Height = 22
              Caption = 'Copy From Main'
              OnClick = sbCopyDominatorsFromMainClick
            end
            object edRT: TEdit
              Left = 104
              Top = 12
              Width = 41
              Height = 21
              TabOrder = 0
              Text = '175'
              OnChange = edRTChange
            end
            object edRDT: TEdit
              Left = 152
              Top = 12
              Width = 41
              Height = 21
              TabOrder = 3
              Text = '100'
              OnChange = edRTChange
            end
            object edBDT: TEdit
              Left = 152
              Top = 60
              Width = 41
              Height = 21
              TabOrder = 5
              Text = '100'
              OnChange = edRTChange
            end
            object edGDT: TEdit
              Left = 152
              Top = 36
              Width = 41
              Height = 21
              TabOrder = 4
              Text = '100'
              OnChange = edRTChange
            end
            object edBT: TEdit
              Left = 104
              Top = 60
              Width = 41
              Height = 21
              TabOrder = 2
              Text = '175'
              OnChange = edRTChange
            end
            object edGT: TEdit
              Left = 104
              Top = 36
              Width = 41
              Height = 21
              TabOrder = 1
              Text = '175'
              OnChange = edRTChange
            end
            object btReduceColors: TButton
              Left = 312
              Top = 86
              Width = 89
              Height = 25
              Caption = 'btReduceColors'
              TabOrder = 6
              Visible = False
              OnClick = btReduceColorsClick
            end
            object edColorDecimator: TEdit
              Left = 320
              Top = 112
              Width = 41
              Height = 21
              Enabled = False
              TabOrder = 7
              Text = '16'
            end
            object edGrowText: TEdit
              Left = 336
              Top = 8
              Width = 33
              Height = 21
              TabOrder = 8
              Text = '2'
            end
            object edGrowOutline: TEdit
              Left = 336
              Top = 32
              Width = 33
              Height = 21
              TabOrder = 9
              Text = '2'
            end
            object btQuarterPel: TButton
              Left = 312
              Top = 62
              Width = 75
              Height = 25
              Caption = 'btQuarterPel'
              TabOrder = 10
              Visible = False
              OnClick = btQuarterPelClick
            end
          end
          object tbsBatchProcessing: TTabSheet
            Caption = 'List'
            ImageIndex = 4
            object btLoadList: TButton
              Left = 88
              Top = 24
              Width = 201
              Height = 33
              Caption = 'Load Bitmap List'
              TabOrder = 0
              OnClick = btLoadListClick
            end
            object btStart: TButton
              Left = 88
              Top = 64
              Width = 73
              Height = 25
              Caption = 'Start'
              Enabled = False
              TabOrder = 1
              OnClick = btStartClick
            end
            object edOCRItem: TEdit
              Left = 176
              Top = 67
              Width = 33
              Height = 21
              Enabled = False
              TabOrder = 2
              Text = '0'
              OnChange = edOCRItemChange
            end
            object btNext: TButton
              Left = 216
              Top = 64
              Width = 73
              Height = 25
              Caption = 'Next'
              Enabled = False
              TabOrder = 3
              OnClick = btNextClick
            end
            object btAutoPost: TButton
              Left = 88
              Top = 96
              Width = 201
              Height = 25
              Hint = 'Automatic Postprocessing'
              Caption = 'Auto-Post'
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = btAutoPostClick
            end
          end
        end
        object btBuildMasksX: TButton
          Left = 592
          Top = 88
          Width = 73
          Height = 25
          Caption = 'Build Masks'
          TabOrder = 5
          OnClick = btBuildMasksXClick
        end
        object edUpdateDelay: TEdit
          Left = 664
          Top = 88
          Width = 49
          Height = 21
          Hint = 'Build Masks Update Delay (in milliseconds)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Text = '100'
        end
        object btOK: TButton
          Left = 592
          Top = 144
          Width = 57
          Height = 49
          Caption = 'OK'
          ModalResult = 1
          TabOrder = 7
          OnClick = btOKClick
        end
        object Panel3: TPanel
          Left = 457
          Top = 15
          Width = 126
          Height = 184
          Align = alLeft
          TabOrder = 8
          object sbTryAutoOCRSearch: TSpeedButton
            Left = 8
            Top = 56
            Width = 110
            Height = 25
            AllowAllUp = True
            GroupIndex = 1007
            Down = True
            Caption = 'AUTO-SEARCH'
          end
          object sbAutoColorAnalyzis: TSpeedButton
            Left = 8
            Top = 8
            Width = 110
            Height = 25
            Hint = 'Automatically assign analyzis results as text and outline colors'
            AllowAllUp = True
            GroupIndex = 1002
            Down = True
            Caption = 'AUTO-COLOR'
            ParentShowHint = False
            ShowHint = True
          end
          object sbAutoOCR: TSpeedButton
            Left = 8
            Top = 32
            Width = 110
            Height = 25
            AllowAllUp = True
            GroupIndex = 1001
            Down = True
            Caption = 'AUTO-OCR'
          end
          object sbDisableNewSymbols: TSpeedButton
            Left = 5
            Top = 100
            Width = 116
            Height = 20
            Hint = 
              'stop asking for new symbols - either smaller then Minimum Text H' +
              'eight (useful once you typed dots and other small punctuation ma' +
              'rks) or ANY'
            AllowAllUp = True
            GroupIndex = 876
            Caption = 'REMOVE Unknown'
            ParentShowHint = False
            ShowHint = True
            OnClick = sbDisableNewSymbolsClick
          end
          object sbIgnoreNewSmall: TSpeedButton
            Left = 5
            Top = 122
            Width = 60
            Height = 17
            GroupIndex = 1111
            Down = True
            Caption = 'Small'
            Enabled = False
          end
          object sbIgnoreAllNew: TSpeedButton
            Left = 61
            Top = 122
            Width = 60
            Height = 17
            GroupIndex = 1111
            Caption = 'ALL'
            Enabled = False
          end
          object cmbZoom: TComboBox
            Left = 8
            Top = 152
            Width = 113
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbZoomChange
            Items.Strings = (
              'Fit 1 Vertically'
              'Fit 2 Vertically'
              'Fit 3 Vertically'
              'Fit 4 Vertically'
              'Fit 5 Vertically'
              'Zoom: x1/8'
              'Zoom: x1/4'
              'Zoom: x1/2'
              'Zoom: x1'
              'Zoom: x2'
              'Zoom: x4'
              'Zoom: x8')
          end
        end
      end
    end
    object tbsGlyphs: TTabSheet
      Caption = 'Symbols'
      ImageIndex = 1
      OnShow = tbsGlyphsShow
      object pbSymbols: TPaintBox
        Left = 153
        Top = 49
        Width = 705
        Height = 475
        Align = alClient
        OnMouseUp = pbSymbolsMouseUp
        OnPaint = tbsGlyphsShow
      end
      object gbGlyph1: TGroupBox
        Left = 0
        Top = 0
        Width = 874
        Height = 49
        Align = alTop
        Caption = 'Symbol 1'
        TabOrder = 0
        object btReduceSimilar: TButton
          Left = 600
          Top = 16
          Width = 121
          Height = 25
          Caption = 'btReduceSimilar'
          TabOrder = 0
          Visible = False
        end
        object edGlyphDir: TEdit
          Left = 136
          Top = 16
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'C:\TEMP\ASDGlyph'
        end
        object btSaveGlyphs: TButton
          Left = 8
          Top = 16
          Width = 121
          Height = 25
          Caption = 'Save Symbols'
          TabOrder = 2
          OnClick = btSaveGlyphsClick
        end
        object btOptimizeBase: TButton
          Left = 728
          Top = 16
          Width = 121
          Height = 25
          Caption = 'btOptimizeBase'
          TabOrder = 3
          Visible = False
          OnClick = btOptimizeBaseClick
        end
        object btLoadBaseGlyphs: TButton
          Left = 264
          Top = 16
          Width = 121
          Height = 25
          Caption = 'Load Symbols'
          TabOrder = 4
          OnClick = btLoadBaseGlyphsClick
        end
        object btSortSymbols: TButton
          Left = 392
          Top = 16
          Width = 75
          Height = 25
          Caption = 'SORT'
          TabOrder = 5
          OnClick = btSortSymbolsClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 49
        Width = 153
        Height = 475
        Align = alLeft
        TabOrder = 1
        object Image1: TImage
          Left = 8
          Top = 8
          Width = 137
          Height = 137
          Center = True
        end
        object lbSymbolAreas: TLabel
          Left = 8
          Top = 216
          Width = 137
          Height = 73
          AutoSize = False
        end
        object edSymbolText: TEdit
          Left = 8
          Top = 168
          Width = 137
          Height = 21
          TabOrder = 0
          OnChange = edSymbolTextChange
        end
        object btSymbolOK: TButton
          Left = 8
          Top = 192
          Width = 65
          Height = 25
          Caption = 'Save'
          Enabled = False
          TabOrder = 1
          OnClick = btSymbolOKClick
        end
        object btSymbolCancel: TButton
          Left = 88
          Top = 192
          Width = 57
          Height = 25
          Caption = 'Cancel'
          Enabled = False
          TabOrder = 2
          OnClick = btSymbolCancelClick
        end
        object cbItalic: TCheckBox
          Left = 9
          Top = 148
          Width = 33
          Height = 17
          Caption = '&I'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 3
          OnClick = edSymbolTextChange
        end
        object cbBold: TCheckBox
          Left = 61
          Top = 148
          Width = 33
          Height = 17
          Caption = '&B'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = edSymbolTextChange
        end
        object cbUnderline: TCheckBox
          Left = 113
          Top = 148
          Width = 33
          Height = 17
          Caption = '&U'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = edSymbolTextChange
        end
        object btSymbolDelete: TButton
          Left = 8
          Top = 288
          Width = 137
          Height = 25
          Caption = 'Delete'
          TabOrder = 6
          OnClick = btSymbolDeleteClick
        end
      end
      object sclGlyphScroll: TScrollBar
        Left = 858
        Top = 49
        Width = 16
        Height = 475
        Align = alRight
        Kind = sbVertical
        Max = 1
        PageSize = 7
        TabOrder = 2
        OnChange = sclGlyphScrollChange
      end
    end
    object tbsOCRResult: TTabSheet
      Caption = 'OCR Results'
      ImageIndex = 2
      OnShow = tbsOCRResultShow
      object sgOCRResults: TStringGrid
        Left = 0
        Top = 41
        Width = 872
        Height = 483
        Align = alClient
        ColCount = 2
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        GridLineWidth = 3
        Options = [goVertLine, goHorzLine, goRangeSelect]
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 872
        Height = 41
        Align = alTop
        TabOrder = 1
        object btSaveList: TButton
          Left = 432
          Top = 8
          Width = 417
          Height = 25
          Caption = 'Save List'
          TabOrder = 0
          OnClick = btSaveListClick
        end
      end
    end
    object tbsAutoFontSettings: TTabSheet
      Caption = 'Auto Search'
      ImageIndex = 3
      object lbTrySymbols: TLabel
        Left = 16
        Top = 220
        Width = 60
        Height = 13
        Caption = 'Try Symbols:'
      end
      object sbShowAutoFontCompareResults: TSpeedButton
        Left = 344
        Top = 272
        Width = 137
        Height = 22
        AllowAllUp = True
        GroupIndex = 1001
        Down = True
        Caption = 'Show Compare Results'
      end
      object Label9: TLabel
        Left = 8
        Top = 244
        Width = 121
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Try Fonts:'
      end
      object sbReverseAutoOrder: TSpeedButton
        Left = 728
        Top = 216
        Width = 73
        Height = 22
        AllowAllUp = True
        GroupIndex = 204
        Down = True
        Caption = 'Reverse Order'
      end
      object sgAlphabet: TStringGrid
        Left = 8
        Top = 24
        Width = 807
        Height = 181
        ColCount = 32
        DefaultColWidth = 24
        FixedCols = 0
        RowCount = 7
        FixedRows = 0
        Options = [goVertLine, goHorzLine]
        TabOrder = 0
        OnDrawCell = sgAlphabetDrawCell
        OnSelectCell = sgAlphabetSelectCell
      end
      object edAutoRecognitionLine: TEdit
        Left = 88
        Top = 216
        Width = 625
        Height = 21
        TabOrder = 1
        Text = 
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789?-' +
          '=!@#$%'
        OnChange = edAutoRecognitionLineChange
      end
      object edAutoFontNameX: TEdit
        Left = 344
        Top = 243
        Width = 97
        Height = 21
        TabOrder = 2
        Text = 'Arial'
        OnChange = edAutoFontNameXChange
      end
      object btCheckFontMatch: TButton
        Left = 144
        Top = 240
        Width = 193
        Height = 25
        Hint = 'Check Font Matching for know letters'
        Caption = 'Check Font Match'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btCheckFontMatchClick
      end
      object clbAutoFontsChecked: TCheckListBox
        Left = 144
        Top = 304
        Width = 193
        Height = 217
        OnClickCheck = clbAutoFontsCheckedClick
        ItemHeight = 13
        TabOrder = 4
      end
      object lbTryFonts: TListBox
        Left = 8
        Top = 280
        Width = 121
        Height = 241
        ItemHeight = 13
        TabOrder = 5
      end
      object btCheckBestMatch: TButton
        Tag = 1
        Left = 144
        Top = 272
        Width = 193
        Height = 25
        Hint = 'Find Font with best match to known symbols'
        Caption = 'Check Font Match'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = btCheckFontMatchClick
      end
      object cbTryItalic: TCheckBox
        Left = 8
        Top = 264
        Width = 121
        Height = 17
        Caption = 'Try Italic version'
        TabOrder = 7
      end
    end
  end
  object stbMain: TStatusBar
    Left = 0
    Top = 571
    Width = 882
    Height = 19
    Panels = <
      item
        Width = 500
      end
      item
        Style = psOwnerDraw
        Text = '0.0001'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = False
    OnDrawPanel = stbMainDrawPanel
  end
  object stTempText: TStaticText
    Left = 0
    Top = 552
    Width = 882
    Height = 19
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    TabOrder = 2
  end
  object OpenList: TOpenDialog
    Filter = 
      'All Supported|*.srt;*.lst|Bitmap List (*.LST)|*.lst|SubRip (*.SR' +
      'T)|*.srt'
    Left = 224
    Top = 248
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 276
    Top = 248
  end
  object OpenSymbolList: TOpenDialog
    Filter = 'Symbol List|*.sym'
    Left = 220
    Top = 296
  end
  object UpdateTimer: TTimer
    Enabled = False
    OnTimer = UpdateTimerTimer
    Left = 412
    Top = 16
  end
  object SaveSymbols: TSaveDialog
    Filter = 'Symbol List (*.sym)|*.sym'
    Left = 276
    Top = 296
  end
  object ImageListX: TImageList
    Left = 444
    Top = 72
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008080800000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000008000000080000000800000008000
      000080000000FFFFFF0080000000800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007FFFFF008000000080000000800000008000
      000080000000FFFFFF00800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000FFFFFF008000
      000080000000FFFFFF00800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000008000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000800000008000000080000000FFFF
      FF0080000000FFFFFF0080000000800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007FFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007FFFFF00800000008000000080000000FFFF
      FF0080000000FFFFFF00800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000800000008000
      0000FFFFFF00FFFFFF00800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000008000000080000000800000008000
      0000FFFFFF00FFFFFF0080000000800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000008000000080000000800000008000
      000080000000FFFFFF0080000000800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007FFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007FFFFF008000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000007FFFFF00800000007FFFFF008000
      00007FFFFF00800000007FFFFF00800000007FFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF000300000003000000FF00000006000000
      7C000000FFFFFFFF7F0000007F800000FFFFFBFFFF0000007000000078000000
      FF0000006000000000000000FFFFFBFFFFFFFFFFFFFFFFFFFFFFC1FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBFFFFFFFFFFFFFFFFFF
      FFFFEBFFFFFFFFFFFC3FFFFFFC3FFFFFFFFFFFFFF87FFFFFFC3FFFFFFFFFEBFF
      FC3FFFFF01FFFFFFFC3FF3FFFF3FFFFFFC3FFFFF00FFFFFFFC3FFFFF03FFFFFF
      8001FFFFFFFFF3FF8001FFFF3FFFFFFF8001FBFFFF0000008001000000000000
      FC3F20009F130001FC3F2000FFFFFFFFFC3FFC3FFC3FFFFFFC3F8001FC3FFC3F
      FC3FFC3F80018001FFFFFC3FFC3FFC3FFFFFFFFFFFFFFFFFF00FFE7FFFFFFFFF
      F00FFC3FFFFFFFFFF00FF81FFFFFFFFFF00FF00F843BFFFFF00FE007F5FBFFFF
      F00FC003F5FB8001F00F8001F5FB80018001F00F847B8001C003F00FBDFB8001
      E007F00FBDFBFFFFF00FF00F8420FFFFF81FF00FFFFFFFFFFC3FF00FFFFFFFFF
      FE7FF00FFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object UpdateTimer2: TTimer
    Tag = 4
    Enabled = False
    OnTimer = UpdateTimerTimer
    Left = 500
    Top = 16
  end
end
