object PluginForm: TPluginForm
  Left = 166
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Test Data Generator'
  ClientHeight = 420
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 29
    Width = 634
    Height = 9
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Label2: TLabel
    Left = 351
    Top = 6
    Width = 48
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Table:'
  end
  object Label15: TLabel
    Left = 8
    Top = 395
    Width = 217
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Num&ber of records to be generated'
  end
  object lFields: TLabel
    Left = 8
    Top = 40
    Width = 337
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'No fields'
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 352
    Top = 40
    Width = 289
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'No field'
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  object lv: TListView
    Left = 8
    Top = 64
    Width = 337
    Height = 321
    Checkboxes = True
    Columns = <
      item
        Caption = 'Field Name'
        Width = 200
      end
      item
        AutoSize = True
        Caption = 'Type'
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
    OnChange = lvChange
  end
  object Panel2: TPanel
    Left = 353
    Top = 59
    Width = 289
    Height = 326
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 5
    object gbIntCon: TGroupBox
      Left = 0
      Top = 460
      Width = 289
      Height = 57
      Align = alTop
      Caption = ' Integer Constraints  '
      TabOrder = 0
      Visible = False
      object Label5: TLabel
        Left = 11
        Top = 14
        Width = 45
        Height = 13
        Caption = 'M&in Value'
      end
      object Label6: TLabel
        Left = 162
        Top = 14
        Width = 49
        Height = 13
        Caption = 'Ma&x Value'
      end
      object seMinInt: TSpinEdit
        Left = 11
        Top = 29
        Width = 121
        Height = 22
        AutoSize = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnExit = seMinIntExit
      end
      object seMaxInt: TSpinEdit
        Left = 161
        Top = 29
        Width = 121
        Height = 22
        AutoSize = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnExit = seMinIntExit
      end
    end
    object gbStrCon: TGroupBox
      Left = 0
      Top = 590
      Width = 289
      Height = 100
      Align = alTop
      Caption = ' String Constraints  '
      TabOrder = 1
      Visible = False
      object Label7: TLabel
        Left = 150
        Top = 20
        Width = 56
        Height = 13
        Caption = 'Ma&x Length'
      end
      object Label3: TLabel
        Left = 13
        Top = 20
        Width = 52
        Height = 13
        Caption = 'M&in Length'
      end
      object Label13: TLabel
        Left = 13
        Top = 50
        Width = 50
        Height = 13
        Caption = '&Start Char'
      end
      object Label14: TLabel
        Left = 14
        Top = 74
        Width = 44
        Height = 13
        Caption = '&End Char'
      end
      object cbStartChar: TComboBox
        Left = 76
        Top = 46
        Width = 109
        Height = 21
        Style = csDropDownList
        DropDownCount = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        OnChange = cbStartCharChange
        OnExit = stringExit
      end
      object cbEndChar: TComboBox
        Left = 76
        Top = 70
        Width = 109
        Height = 21
        Style = csDropDownList
        DropDownCount = 20
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        OnChange = cbEndCharChange
        OnExit = stringExit
      end
      object seLen1: TSpinEdit
        Left = 76
        Top = 16
        Width = 70
        Height = 22
        AutoSize = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnExit = stringExit
      end
      object seLen2: TSpinEdit
        Left = 212
        Top = 16
        Width = 70
        Height = 22
        AutoSize = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnExit = stringExit
      end
    end
    object gbDatCon: TGroupBox
      Left = 0
      Top = 57
      Width = 289
      Height = 92
      Align = alTop
      Caption = ' Date Constraints  '
      TabOrder = 2
      Visible = False
      object Label8: TLabel
        Left = 12
        Top = 19
        Width = 42
        Height = 13
        Caption = 'M&in Date'
      end
      object Label9: TLabel
        Left = 12
        Top = 43
        Width = 46
        Height = 13
        Caption = 'Ma&x Date'
      end
      object deMinDate: TDateTimePicker
        Left = 77
        Top = 16
        Width = 205
        Height = 21
        CalAlignment = dtaLeft
        Date = 37538.6898390162
        Time = 37538.6898390162
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
        OnExit = DateExit
      end
      object deMaxDate: TDateTimePicker
        Left = 77
        Top = 40
        Width = 205
        Height = 21
        CalAlignment = dtaLeft
        Date = 37538.6898401852
        Time = 37538.6898401852
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
        OnExit = DateExit
      end
      object deIncludeTime: TCheckBox
        Left = 12
        Top = 66
        Width = 97
        Height = 17
        Caption = 'In&clude Time'
        TabOrder = 2
        OnClick = deIncludeTimeClick
      end
    end
    object gbLink: TGroupBox
      Left = 0
      Top = 149
      Width = 289
      Height = 91
      Align = alTop
      Caption = ' Get from table  '
      TabOrder = 4
      Visible = False
      object Label10: TLabel
        Left = 55
        Top = 68
        Width = 89
        Height = 13
        Caption = 'N&umber of records'
      end
      object Label11: TLabel
        Left = 13
        Top = 20
        Width = 26
        Height = 13
        Caption = '&Table'
      end
      object Label12: TLabel
        Left = 13
        Top = 44
        Width = 22
        Height = 13
        Caption = '&Field'
      end
      object cbLinkTable: TComboBox
        Left = 59
        Top = 15
        Width = 185
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbLinkTableChange
      end
      object cbLinkField: TComboBox
        Left = 59
        Top = 39
        Width = 185
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbLinkFieldChange
      end
      object seNumRec: TSpinEdit
        Left = 148
        Top = 63
        Width = 96
        Height = 22
        AutoSize = False
        MaxValue = 2147483647
        MinValue = 1
        TabOrder = 2
        Value = 100
      end
    end
    object gbList: TGroupBox
      Left = 0
      Top = 240
      Width = 289
      Height = 128
      Align = alTop
      Caption = ' Get From List  '
      TabOrder = 5
      Visible = False
      object lvList: TMemo
        Left = 6
        Top = 15
        Width = 268
        Height = 107
        TabOrder = 0
        OnExit = lvListExit
      end
    end
    object gbFltCon: TGroupBox
      Left = 0
      Top = 368
      Width = 289
      Height = 92
      Align = alTop
      Caption = ' Float Constraints '
      TabOrder = 6
      Visible = False
      object Label16: TLabel
        Left = 8
        Top = 40
        Width = 26
        Height = 13
        Caption = 'Di&gits'
      end
      object Label17: TLabel
        Left = 8
        Top = 64
        Width = 42
        Height = 13
        Caption = '&Precision'
      end
      object fltFixed: TCheckBox
        Left = 8
        Top = 16
        Width = 145
        Height = 14
        Caption = 'Fi&xed float number'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = fltFixedClick
      end
      object fltDigits: TSpinEdit
        Left = 64
        Top = 36
        Width = 100
        Height = 22
        AutoSize = False
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnExit = FloatExit
      end
      object fltPrecision: TSpinEdit
        Left = 64
        Top = 60
        Width = 100
        Height = 22
        AutoSize = False
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnExit = FloatExit
      end
    end
    object gbTimeCon: TGroupBox
      Left = 0
      Top = 517
      Width = 289
      Height = 73
      Align = alTop
      Caption = ' Time Constraints  '
      TabOrder = 7
      Visible = False
      object Label18: TLabel
        Left = 12
        Top = 19
        Width = 41
        Height = 13
        Caption = 'M&in Time'
        FocusControl = tmMinTime
      end
      object Label19: TLabel
        Left = 12
        Top = 43
        Width = 45
        Height = 13
        Caption = 'Ma&x Time'
        FocusControl = tmMaxTime
      end
      object tmMinTime: TDateTimePicker
        Left = 80
        Top = 16
        Width = 81
        Height = 21
        CalAlignment = dtaLeft
        Date = 36741
        Time = 36741
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 0
        OnExit = TimeExit
      end
      object tmMaxTime: TDateTimePicker
        Left = 80
        Top = 40
        Width = 81
        Height = 21
        CalAlignment = dtaLeft
        Date = 36741.9999884259
        Time = 36741.9999884259
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 1
        OnExit = TimeExit
      end
    end
    object rgGenType: TRadioGroup
      Left = 0
      Top = 0
      Width = 289
      Height = 57
      Align = alTop
      Caption = ' Data Generation Type  '
      ItemIndex = 0
      Items.Strings = (
        'Generate &randomly'
        'Get from &list')
      TabOrder = 3
      Visible = False
      OnClick = rgGenTypeClick
    end
  end
  object cbDatabases: TComboBox
    Left = 68
    Top = 3
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbDatabasesChange
  end
  object cb: TComboBox
    Left = 402
    Top = 3
    Width = 240
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbChange
  end
  object buGenerate: TButton
    Left = 485
    Top = 392
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = '&Generate'
    TabOrder = 3
    OnClick = buGenerateClick
  end
  object buClose: TButton
    Left = 566
    Top = 392
    Width = 75
    Height = 24
    Cursor = crHandPoint
    Caption = '&Close'
    TabOrder = 6
    OnClick = buCloseClick
  end
  object seNumGen: TSpinEdit
    Left = 229
    Top = 392
    Width = 116
    Height = 22
    AutoSize = False
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 2
    Value = 100
  end
end
