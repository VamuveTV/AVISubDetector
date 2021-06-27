object ImageForm: TImageForm
  Left = 81
  Top = 154
  Width = 809
  Height = 543
  AutoSize = True
  Caption = 'Image'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 2
    Top = 36
    Width = 640
    Height = 480
    AutoSize = True
    OnMouseDown = Image1MouseDown
  end
  object SharpGraph: TPaintBox
    Left = 652
    Top = 36
    Width = 140
    Height = 477
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 33
    TabOrder = 0
    object sbGetFrameSample: TSpeedButton
      Left = 5
      Top = 5
      Width = 76
      Height = 22
      Hint = 'Загрузить кадр из BMP для проверки'
      Caption = 'Sample BMP'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbGetFrameSampleClick
    end
    object sbRestoreImage: TSpeedButton
      Left = 85
      Top = 5
      Width = 57
      Height = 22
      Hint = 'Восстановить исходный вид'
      GroupIndex = 4
      Down = True
      Caption = 'Original'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbRestoreImageClick
    end
    object sbZeroPoints: TSpeedButton
      Left = 253
      Top = 5
      Width = 52
      Height = 22
      Hint = 'Закрашивает белым пикселы, считающиеся в блоках "нулевыми"'
      GroupIndex = 4
      Caption = 'Influence'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZeroPointsClick
    end
    object sbCheckBlockLines: TSpeedButton
      Left = 149
      Top = 5
      Width = 65
      Height = 22
      Hint = 'Инвертирует "детектированые" блоки (для проверки)'
      GroupIndex = 4
      Caption = 'Check BV'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbCheckBlockLinesClick
    end
    object sbInvertLine: TSpeedButton
      Left = 221
      Top = 5
      Width = 23
      Height = 22
      Hint = 
        'Показывать "детектированые" блоки или "детектированые" линии (на' +
        'жатое)'
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = 'L'
      ParentShowHint = False
      ShowHint = True
    end
    object lbMBC: TLabel
      Left = 680
      Top = 8
      Width = 46
      Height = 13
      Caption = 'MBC=0/0'
    end
    object lbDLC: TLabel
      Left = 736
      Top = 8
      Width = 33
      Height = 13
      Caption = 'DLC=0'
    end
    object sbCheckBlockTopZero: TSpeedButton
      Left = 309
      Top = 5
      Width = 36
      Height = 22
      AllowAllUp = True
      GroupIndex = 94
      Caption = 'SQ'
      Enabled = False
    end
    object sbCheckColorDomination: TSpeedButton
      Left = 625
      Top = 21
      Width = 104
      Height = 22
      Hint = 'Проверяет доминирующие цвета в блоках'
      Caption = 'Color Domination'
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = sbCheckColorDominationClick
    end
    object sbRemainDominatingColors: TSpeedButton
      Left = 733
      Top = 21
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 142
      Caption = 'R'
      Visible = False
    end
    object sbViewSubstract: TSpeedButton
      Left = 349
      Top = 5
      Width = 68
      Height = 22
      Hint = 'разностная картина пикселов'
      GroupIndex = 4
      Caption = 'Substraction'
    end
    object sbAddDominatorColor: TSpeedButton
      Left = 607
      Top = 5
      Width = 42
      Height = 22
      Hint = 
        'Добавить "доминирующий" цвет субтитров (цвет выбирается кликом л' +
        'евой кнопки по картинке)'
      Caption = '+Dom'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbAddDominatorColorClick
    end
    object lbDominatorColor: TLabel
      Left = 520
      Top = 4
      Width = 33
      Height = 21
      AutoSize = False
      Color = clWhite
      ParentColor = False
    end
    object sbSetDominatorColor: TSpeedButton
      Left = 559
      Top = 5
      Width = 42
      Height = 22
      Hint = 
        'Изенить текущий "доминирующий" цвет субтитров (цвет выбирается к' +
        'ликом левой кнопки по картинке)'
      Caption = '=Dom'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbSetDominatorColorClick
    end
    object sbDominating: TSpeedButton
      Left = 424
      Top = 5
      Width = 41
      Height = 22
      Hint = 'оставляет только установленые доминирующие цвета'
      GroupIndex = 4
      Caption = '[Dom]'
    end
    object sbDominatingSharp: TSpeedButton
      Left = 472
      Top = 5
      Width = 41
      Height = 22
      Hint = 'Области с доминирующим цветом _и_ считающиеся острыми'
      GroupIndex = 4
      Caption = '<Dom>'
      ParentShowHint = False
      ShowHint = True
    end
  end
  object OpenBMP: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 120
    Top = 64
  end
end
