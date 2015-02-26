unit PluginF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, MyIntf, Spin;

type

  PTestField = ^TTestField;
  TTestField = record
    Name      : string;
    FieldType : integer;
    FieldScale : integer;
    Precision : integer;
    FixedFloat: boolean;
    MinValue  : integer;
    MaxValue  : integer;
    MinLength : integer;
    MaxLength : integer;
    Length    : integer;
    MinDate   : TDateTime;
    MaxDate   : TDateTime;
    MinTime   : TTime;
    MaxTime   : TTime;
    TimeInc   : boolean;
    StartChar : integer;
    EndChar   : integer;
    GenType   : integer;
    LinkTable : string;
    LinkField : string;
    RecNums   : integer;
    Values    : array of string;
    List      : TStringList;
    NumRecs   : integer;
  end;

  TPluginForm = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    lFields: TLabel;
    lv: TListView;
    Panel2: TPanel;
    gbIntCon: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    gbStrCon: TGroupBox;
    Label7: TLabel;
    Label3: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    gbDatCon: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    gbLink: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    gbList: TGroupBox;
    lvList: TMemo;
    Label4: TLabel;
    gbFltCon: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    gbTimeCon: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    tmMinTime: TDateTimePicker;
    tmMaxTime: TDateTimePicker;
    cbDatabases: TComboBox;
    cb: TComboBox;
    deMinDate: TDateTimePicker;
    deMaxDate: TDateTimePicker;
    deIncludeTime: TCheckBox;
    fltFixed: TCheckBox;
    rgGenType: TRadioGroup;
    cbLinkTable: TComboBox;
    cbLinkField: TComboBox;
    cbStartChar: TComboBox;
    cbEndChar: TComboBox;
    buGenerate: TButton;
    buClose: TButton;
    seMinInt: TSpinEdit;
    seMaxInt: TSpinEdit;
    seLen1: TSpinEdit;
    seLen2: TSpinEdit;
    seNumRec: TSpinEdit;
    fltDigits: TSpinEdit;
    fltPrecision: TSpinEdit;
    seNumGen: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure cbChange(Sender: TObject);
    procedure cbDatabasesChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure rgGenTypeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvListEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure cbStartCharChange(Sender: TObject);
    procedure cbEndCharChange(Sender: TObject);
    procedure cbLinkTableChange(Sender: TObject);
    procedure cbLinkFieldChange(Sender: TObject);
    procedure buGenerateClick(Sender: TObject);
    procedure buCloseClick(Sender: TObject);
    procedure seMinIntExit(Sender: TObject);
    procedure stringExit(Sender: TObject);
    procedure DateExit(Sender: TObject);
    procedure TimeExit(Sender: TObject);
    procedure FloatExit(Sender: TObject);
    procedure lvListExit(Sender: TObject);
    procedure deIncludeTimeClick(Sender: TObject);
    procedure fltFixedClick(Sender: TObject);
  private
    FDatabaseIndex : integer;
    FTableName : string;
    FInsertFields : TStringList;
    FIntf: TMyManagerInterface;
    FGenStrings: TStrings;
    procedure FillDatabases;
    procedure FillTables;
    procedure FillFields;
    procedure ClearFields;
    procedure SetDatabaseIndex(const Value: integer);
    procedure SetTableName(const Value: string);
    function GetMinValue(iFType, iFScale : integer) : integer;
    function GetMaxValue(iFType, iFScale : integer) : integer;
    procedure ShowTestFieldInfo(PTF : PTestField);
    procedure FillInsertFields;
    function GetInsertSQL : string;
    function GenerateDate(FieldInfo: PTestField): TDateTime;
    function GenerateTime(FieldInfo: PTestField): TTime;
    function GenerateInteger(FieldInfo: PTestField): Integer;
    function GenerateString(FieldInfo: PTestField): string;
    function GenerateNumeric(FieldInfo: PTestField): Extended;
    function GenerateFloat(FieldInfo: PTestField): Double;
    function GenerateEnum(FieldInfo: PTestField): string;
    function GetStringFromList(FieldInfo: PTestField): string;
    function GetRandomInteger(MinValue, MaxValue : integer): integer;
    function FormatIdentifier(const Ident: string; DBIndex: integer): string;
  public
    property Intf : TMyManagerInterface read FIntf write FIntf;
    property DatabaseIndex : integer read FDatabaseIndex write SetDatabaseIndex;
    property TableName : string read FTableName write SetTableName;
  end;

var
  PluginForm: TPluginForm;

implementation

uses Math, Dialogs, ProgressF, StrConsts;

{$R *.DFM}

procedure TPluginForm.FormShow(Sender: TObject);
begin
  FillDatabases;
  FillTables;
end;

procedure TPluginForm.cbChange(Sender: TObject);
begin
  TableName := cb.Text;
  lFields.Caption := TableName;
end;

procedure TPluginForm.FillDatabases;
var
  i, DBCount : integer;
  DBName, DBAlias : string;
begin
  cbDatabases.Clear;
  DBCount := FIntf.DatabasesCount;
  for i := 0 to pred(DBCount) do
    if FIntf.DatabaseActive(i) then
    begin
      DBName := String(FIntf.DatabaseName(i));
      DBAlias := String(FIntf.DatabaseAlias(i));
      cbDatabases.Items.AddObject(DBAlias + ' [' + DBName + ']',TObject(i));
    end;
  if cbDatabases.Items.Count > 0 then
  begin
    cbDatabases.ItemIndex := 0;
    cbDatabasesChange(nil);
  end;
end;

procedure TPluginForm.FillTables;
var
  Tables : TMMITablesList;
  i, TCount : integer;
  TI : TMMITableInfo;
begin
  cb.Items.Clear;
  Tables := FIntf.GetTables(DatabaseIndex,TCount);
  try
    for i := 0 to pred(TCount) do
    begin
      FIntf.FetchTableInfo(Tables,i,TI);
      cb.Items.Add(String(TI.TableName));
    end;
    cb.ItemIndex := 0;
    cbChange(nil);
    cbLinkTable.Items.Assign(cb.Items);
  finally
    FIntf.FreeTables(Tables);
  end;
end;

procedure TPluginForm.cbDatabasesChange(Sender: TObject);
begin
  buGenerate.Enabled := cbDatabases.ItemIndex > -1;
  if cbDatabases.ItemIndex > -1
    then DatabaseIndex := Integer(cbDatabases.Items.Objects[cbDatabases.ItemIndex]);
end;


procedure TPluginForm.FillFields;
var
  Fields : TMMITableFields;
  i, FCount : integer;
  FI : TMMIFieldInfo;
  liTemp : TListItem;
  PTF : PTestField;
begin
  Screen.Cursor := crSQLWait;
  lv.Items.BeginUpdate;
  ClearFields;
  try
    Fields := FIntf.FieldsOfTable(DatabaseIndex, PChar(TableName), FCount);
    try
      for i := 0 to pred(FCount) do
      begin
        FIntf.FieldInfo(Fields,i,FI);
        liTemp := lv.Items.Add;
        liTemp.Caption := String(FI.FieldName);
        liTemp.SubItems.Add(String(FI.TypeAsString));
        New(PTF);
        with PTF^ do begin
          Name := liTemp.Caption;
          Length := FI.FieldSize;
          FieldType := FI.FieldType;
          FieldScale := FI.FieldPrecision;
          MinValue  := GetMinValue(FieldType, FieldScale);
          MaxValue  := GetMaxValue(FieldType, FieldScale);
          MinLength := 0;
          MaxLength := Length;
          MinDate   := Date - 30;
          MaxDate   := Date + 30;
          MinTime   := tmMinTime.Time;
          MaxTime   := tmMaxTime.Time;
          TimeInc   := FALSE;
          StartChar := 32;
          EndChar   := 127;
          GenType   := 0;
          LinkTable := '';
          LinkField := '';
          RecNums   := 0;
          List := nil;
        end;
        liTemp.Data := PTF;
      end;
    finally
      FIntf.FreeTableFields(Fields);
    end;
  finally
    lv.Items.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TPluginForm.SetDatabaseIndex(const Value: integer);
begin
  if FDatabaseIndex <> Value then
  begin
    FDatabaseIndex := Value;
    if FDatabaseIndex >= 0 then
      FillTables
    else
      cb.Items.Clear;
  end;
end;

procedure TPluginForm.SetTableName(const Value: string);
begin
  FTableName := Value;
  if TableName <> '' then
    FillFields;
end;

procedure TPluginForm.Button2Click(Sender: TObject);
begin
  cb.Free;
end;

procedure TPluginForm.FormCreate(Sender: TObject);
var
  i : integer;
begin
  Randomize;
  FInsertFields := TStringList.Create;
  FGenStrings := TStringList.Create;
  FDatabaseIndex := -1;
  FTableName := '';
  for i := 32 to 255 do
  begin
    cbStartChar.Items.Add(Chr(i)+ ' (' + IntToStr(i) + ')');
    cbEndChar.Items.Add(Chr(i)+ ' (' + IntToStr(i) + ')');
  end;
  cbDatabasesChange(nil);
end;

procedure TPluginForm.lvChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if Assigned(lv.Selected) then
  begin
    if not rgGenType.Visible then
      rgGenType.Visible := PTestField(lv.Selected.Data)^.FieldType <> mftEnum;
    Label4.Caption := Trim(cb.Text) + '.' + lv.Selected.Caption + ' - ' +
                      lv.Selected.SubItems[0];
    ShowTestFieldInfo(PTestField(lv.Selected.Data));
  end
  else
    rgGenType.Visible := FALSE;
end;

procedure TPluginForm.rgGenTypeClick(Sender: TObject);
begin
  if Assigned(lv.Selected) then begin
    PTestField(lv.Selected.Data)^.GenType := rgGenType.ItemIndex;
    ShowTestFieldInfo(PTestField(lv.Selected.Data));
  end;
end;

procedure TPluginForm.ClearFields;
var
  i : integer;
begin
  for i := 0 to pred(lv.Items.Count) do
  begin
    if Assigned(PTestField(lv.Items[i].Data)^.List) then
      PTestField(lv.Items[i].Data)^.List.Free;
    Dispose(lv.Items[i].Data);
  end;
  lv.Items.Clear;
end;

procedure TPluginForm.FormDestroy(Sender: TObject);
begin
  ClearFields;
  FGenStrings.Free;
  FInsertFields.Free;
end;

function TPluginForm.GetMaxValue(iFType, iFScale : integer) : integer;
begin
  case iFType of
    mftTinyInt   : Result := 127;
    mftSmallInt  : Result := 32767;
    mftMediumInt : Result := 8388607;
    mftInteger,
    mftBigInt    : Result := High(Integer);
    else Result := 0;
  end;
end;

function TPluginForm.GetMinValue(iFType, iFScale : integer) : integer;
begin
  case iFType of
    mftTinyInt   : Result := -128;
    mftSmallInt  : Result := -32768;
    mftMediumInt : Result := -8388608;
    mftInteger,
    mftBigInt    : Result := Low(Integer);
    else Result := 0;  
  end;
end;

procedure TPluginForm.ShowTestFieldInfo(PTF: PTestField);
var
  bGenRandomly : boolean;
begin

  bGenRandomly := (PTF^.GenType = 0);

  rgGenType.OnClick := nil;
  rgGenType.ItemIndex := PTF^.GenType;
  rgGenType.OnClick := rgGenTypeClick;

  gbIntCon.Visible := (PTF^.FieldType in [mftTinyInt, mftSmallInt,
    mftMediumInt, mftInteger, mftBigInt]) and bGenRandomly;
  gbStrCon.Visible := (PTF^.FieldType in [mftChar, mftVarChar]) and bGenRandomly;
  gbDatCon.Visible := (PTF^.FieldType in [mftDate, mftDateTime,
    mftTimestamp]) and bGenRandomly;
  gbFltCon.Visible := (PTF^.FieldType in [mftFloat, mftDouble, mftDecimal])
    and bGenRandomly;
  gbTimeCon.Visible := (PTF^.FieldType in [mftTime]) and bGenRandomly;
  gbList.Visible   := (rgGenType.ItemIndex = 1) or (PTF^.FieldType = mftEnum);


  if gbFltCon.Visible then begin
    fltFixed.Checked := PTF^.FixedFloat;
    fltDigits.Value := PTF^.Length;
    fltPrecision.Value := PTF^.Precision;
  end;

  if gbIntCon.Visible then begin
    seMinInt.Value := PTF^.MinValue;
    seMaxInt.Value := PTF^.MaxValue;
  end;

  if gbStrCon.Visible then begin
    seLen1.Value := PTF^.MinLength;
    seLen2.Value := PTF^.MaxLength;
    cbStartChar.ItemIndex := PTF^.StartChar - 32;
    cbEndChar.ItemIndex := PTF^.EndChar - 32;
  end;

  if gbDatCon.Visible then begin
    deIncludeTime.Checked := PTF^.TimeInc;
    deIncludeTime.Enabled := PTF^.FieldType <> mftDate;
    if PTF^.TimeInc then begin
      deMinDate.DateTime := PTF^.MinDate;
      deMaxDate.DateTime := PTF^.MaxDate;
    end
    else begin
      deMinDate.Date := PTF^.MinDate;
      deMaxDate.Date := PTF^.MaxDate;
    end;
  end;

  if gbTimeCon.Visible then begin
    tmMinTime.Time := PTF^.MinTime;
    tmMaxTime.Time := PTF^.MaxTime;
  end;

  if gbList.Visible then begin
    if not Assigned(PTF^.List) then
       PTF^.List := TStringList.Create;
    lvList.Lines.Text := PTF^.List.Text;
  end;
end;


procedure TPluginForm.lvListEdited(Sender: TObject; Item: TListItem; var S: String);
begin
  PTestField(lv.Selected.Data)^.List[Item.Index] := S;
end;

procedure TPluginForm.cbStartCharChange(Sender: TObject);
begin
  if cbStartChar.ItemIndex > cbEndChar.ItemIndex then
  begin
     cbEndChar.ItemIndex := cbStartChar.ItemIndex;
     PTestField(lv.Selected.Data)^.EndChar := cbStartChar.ItemIndex + 32;
  end;
  PTestField(lv.Selected.Data)^.StartChar := cbStartChar.ItemIndex + 32;
end;

procedure TPluginForm.cbEndCharChange(Sender: TObject);
begin
  if cbEndChar.ItemIndex < cbStartChar.ItemIndex then
  begin
     cbStartChar.ItemIndex := cbEndChar.ItemIndex;
     PTestField(lv.Selected.Data)^.StartChar := cbEndChar.ItemIndex + 32;
  end;
  PTestField(lv.Selected.Data)^.EndChar := cbEndChar.ItemIndex + 32;
end;

procedure TPluginForm.cbLinkTableChange(Sender: TObject);
begin
  if cbLinkTable.ItemIndex <> -1 then
     PTestField(lv.Selected.Data)^.LinkTable := cbLinkTable.Text;
end;

procedure TPluginForm.cbLinkFieldChange(Sender: TObject);
var
  iNumRecs : integer;
  Tr : TMMITransaction;
  Q : TMMIQuery;
  SQL : string;
begin
  if cbLinkField.ItemIndex <> -1 then
  begin
    Tr := FIntf.CreateTransaction(DatabaseIndex);
    Q := FIntf.CreateQuery(DatabaseIndex,Tr);
    try
      SQL := 'SELECT COUNT(*) AS TOTALRECS FROM ' + FormatIdentifier(
        cbLinkTable.Text, FDatabaseIndex) + ' ' +
        'WHERE NOT (' + FormatIdentifier(cbLinkField.Text,
        FDatabaseIndex) + ' IS NULL)';
      FIntf.SetQuerySQL(Q, PChar(SQL));
      FIntf.ExecQuery(Q);
      iNumRecs := Integer(FIntf.GetFieldByIndex(Q,0));
      seNumRec.MaxValue := iNumRecs;
      seNumRec.Value := Min(100,iNumRecs);
      FIntf.CommitTransaction(Tr);
    finally
      FIntf.FreeQuery(Q);
      FIntf.FreeTransaction(Tr);
    end;
  end;
end;

procedure TPluginForm.FillInsertFields;
var
  i : integer;
begin
  FInsertFields.Clear;
  for i := 0 to pred(lv.Items.Count) do
    if lv.Items[i].Checked then
      FInsertFields.AddObject(lv.Items[i].Caption, lv.Items[i].Data);
end;

function TPluginForm.GetInsertSQL: string;
var
  i : integer;
  InsPart, ValPart : string;
begin
  Result := '';
  if FInsertFields.Count = 0 then
    Exit;
  InsPart := '';
  ValPart := '';
  for i := 0 to pred(FInsertFields.Count) do
  begin
    InsPart := InsPart + FormatIdentifier(FInsertFields[i],
      FDatabaseIndex);
    ValPart := ValPart + ':P' + IntToStr(i);
    if i <> pred(FInsertFields.Count) then
    begin
      InsPart := InsPart + ', ';
      ValPart := ValPart + ', ';
    end;
  end;
  Result := 'INSERT INTO ' + FormatIdentifier(TableName,
    FDatabaseIndex) + ' (' + InsPart + ') ' +
    'VALUES (' + ValPart + ');';
end;

procedure TPluginForm.buGenerateClick(Sender: TObject);
var
  SQL : string;
  Q : TMMIQuery;
  Tr : TMMITransaction;
  RecNum, i, k, Index : integer;
  Val : variant;
  PTF : PTestField;
begin
  Screen.Cursor := crSQLWait;
  try
    Enabled := False;
    try
      RecNum := Trunc(seNumGen.Value);
      FillInsertFields;
      if FInsertFields.Count = 0 then begin
        FIntf.ErrorMessage(PChar(sThereNoFieldsSelected));
        Exit;
      end;
      SQL := GetInsertSQL;
      Tr := FIntf.CreateTransaction(DatabaseIndex);
      try
        Q := FIntf.CreateQuery(DatabaseIndex, Tr);
        try
          FIntf.SetQuerySQL(Q, PChar(SQL));
          FIntf.StartTransaction(Tr);
          ShowProgress(RecNum);
          for i := 1 to RecNum do begin
            Application.ProcessMessages();
            if Fm.Done or Fm.Stopped then Break;
            FGenStrings.Clear();
            for k := 0 to FInsertFields.Count - 1 do begin
              PTF := PTestField(FInsertFields.Objects[k]);
              if not Assigned(PTF) then Continue;

              case PTF^.FieldType of
                mftTinyInt,
                mftSmallInt,
                mftMediumInt,
                mftInteger,
                mftBigInt : Val := GenerateInteger(PTF);

                mftFloat,
                mftDouble,
                mftDecimal : begin
                  if PTF^.FixedFloat
                    then Val := GenerateFloat(PTF)
                    else Val := GenerateNumeric(PTF);
                end;

                mftChar,
                mftVarChar,
                mftTinyBlob,
                mftBlob,
                mftMediumBlob,
                mftLongBlob,
                mftTinyText,
                mftText,
                mftMediumText,
                mftLongText :
                  begin
                    Index := FGenStrings.Add(GenerateString(PTF));
                    Val := FGenStrings[Index];
                  end;

                mftDate: Val := GenerateDate(PTF);
                mftTime: Val := GenerateTime(PTF);

                mftDateTime,
                mftTimestamp:
                  Val := GenerateDate(PTF);

                mftEnum:
                  Val := GenerateEnum(PTF);
              else
                Val := Null;
              end;
              FIntf.SetTypedParam(Q, k, PTF^.FieldType, Val);
            end;
            try
              if not FIntf.ExecQuery(Q) then begin
                StopProgress();
                Exit;
              end;
            finally
              FIntf.CloseQuery(Q);
            end;
            Fm.Value := i;
          end;
          FIntf.CommitTransaction(Tr);
        finally
          FGenStrings.Clear();
          FIntf.FreeQuery(Q);
        end;
      finally
        FIntf.FreeTransaction(Tr);
      end;
    finally
      Enabled := True;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TPluginForm.GenerateDate(FieldInfo: PTestField): TDateTime;
var
  Tmp: string;
begin
  with FieldInfo^ do begin
    case GenType of
      1: { Get from list } begin
        Tmp := GetStringFromList(FieldInfo);
        try
          if TimeInc then
            Result := StrToDateTime(Tmp)
          else
            Result := StrToDate(Tmp);
        except
          Result := 0;
        end;
      end;
      else { Get random } begin
        Result := Random(Trunc(MaxDate)-Trunc(MinDate)) + Trunc(MinDate);
        if TimeInc
          then Result := Result + Random;
      end;
    end;
  end;
end;

function TPluginForm.GenerateTime(FieldInfo: PTestField): TTime;
var
  MinM, MaxM, ResM: word;
  Hours, Min, Sec, MSec: word;
  Tmp: string;
begin
  with FieldInfo^ do begin
    case GenType of
      1: begin
        Tmp := GetStringFromList(FieldInfo);
        try
          Result := StrToTime(Tmp);
        except
          Result := 0;
        end;
      end;
      else begin
        DecodeTime(MinTime, Hours, Min, Sec, MSec);
        MinM := Hours * 3600 + Min * 60 + Sec;
        DecodeTime(MaxTime, Hours, Min, Sec, MSec);
        MaxM := Hours * 3600 + Min * 60 + Sec;

        ResM := Random(MaxM - MinM) + MinM;
        Hours := ResM div 3600;
        Min := (ResM - 3600 * Hours) div 60;
        Sec := (ResM - 3600 * Hours - 60 * Min);
        Result := EncodeTime(Hours, Min, Sec, 0);
      end;
    end;
  end;
end;

function TPluginForm.GenerateFloat(FieldInfo: PTestField): Double;
var
  Tmp: string;
begin
  with FieldInfo^ do begin
    case GenType of
      1: begin
        Tmp := GetStringFromList(FieldInfo);
        try
          Result := StrToFloat(Tmp);
        except
          Result := 0;
        end;
      end;
      else Result := Random * Power(10, Length - 1);
    end;
  end;
end;

function TPluginForm.GenerateInteger(FieldInfo: PTestField): Integer;
var Tmp: string;
begin
  with FieldInfo^ do begin
    case GenType of
      1: begin
        Tmp := GetStringFromList(FieldInfo);
        Result := StrToIntDef(Tmp, 0);
      end;
      else Result := GetRandomInteger(MinValue, MaxValue);
    end;
  end;
end;

function TPluginForm.GenerateNumeric(FieldInfo: PTestField): Extended;
var Tmp: string;
begin
  with FieldInfo^ do begin
    case GenType of
      1: begin
        Tmp := GetStringFromList(FieldInfo);
        try
          Result := StrToFloat(Tmp);
        except
          Result := 0;
        end;
      end;
      else Result := Random * Power(10, Length - 1);
    end;
  end;
end;

function TPluginForm.GenerateString(FieldInfo: PTestField): string;
var
  i, iLength, iChar : integer;
begin
  with FieldInfo^ do begin
    case GenType of
      1: Result := GetStringFromList(FieldInfo);
      else begin
        Result := '';
        iLength := GetRandomInteger(MinLength, MaxLength);
        for i := 0 to iLength - 1 do begin
          iChar := GetRandomInteger(StartChar, EndChar);
          Result := Result + Chr(iChar);
        end;
      end;
    end;
  end;
end;

procedure TPluginForm.buCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TPluginForm.seMinIntExit(Sender: TObject);
begin
  with PTestField(lv.Selected.Data)^ do begin
    MinValue := seMinInt.Value;
    MaxValue := seMaxInt.Value;
  end;
end;

procedure TPluginForm.stringExit(Sender: TObject);
begin
  with PTestField(lv.Selected.Data)^ do begin
    MinLength := seLen1.Value;
    MaxLength := seLen2.Value;
    StartChar := cbStartChar.ItemIndex + 32;
    EndChar := cbEndChar.ItemIndex + 32;
  end;
end;

procedure TPluginForm.DateExit(Sender: TObject);
begin
  with PTestField(lv.Selected.Data)^ do begin
    if TimeInc then begin
      MinDate := deMinDate.DateTime;
      MaxDate := deMaxDate.DateTime;
    end
    else begin
      MinDate := deMinDate.Date;
      MaxDate := deMaxDate.Date;
    end;
  end;
end;

procedure TPluginForm.TimeExit(Sender: TObject);
begin
  with PTestField(lv.Selected.Data)^ do begin
    MinTime := tmMinTime.Time;
    MaxTime := tmMaxTime.Time;
  end;
end;

procedure TPluginForm.FloatExit(Sender: TObject);
begin
  with PTestField(lv.Selected.Data)^ do begin
    Length := fltDigits.Value;
    Precision := fltPrecision.Value;
  end;
end;

procedure TPluginForm.lvListExit(Sender: TObject);
begin
  PTestField(lv.Selected.Data)^.List.Text := lvList.Lines.Text;
end;

function TPluginForm.GetStringFromList(FieldInfo: PTestField): string;
var
  I: Integer;
begin
  if Assigned(FieldInfo^.List) and (FieldInfo^.List.Count > 0) then begin
    I := Random(FieldInfo^.List.Count);
    Result := FieldInfo^.List[I];
  end;
end;

function TPluginForm.GetRandomInteger(MinValue,
  MaxValue: integer): integer;
begin
  Result := Random(MaxValue - MinValue) + MinValue;
end;

procedure TPluginForm.deIncludeTimeClick(Sender: TObject);
begin
  if deIncludeTime.Checked then begin
    deMinDate.DateTime := PTestField(lv.Selected.Data)^.MinDate;
    deMaxDate.DateTime := PTestField(lv.Selected.Data)^.MaxDate;
  end
  else begin
    deMinDate.Date := PTestField(lv.Selected.Data)^.MinDate;
    deMaxDate.Date := PTestField(lv.Selected.Data)^.MaxDate;
  end;
  with PTestField(lv.Selected.Data)^ do
    TimeInc := deIncludeTime.Checked;
end;

procedure TPluginForm.fltFixedClick(Sender: TObject);
begin
  fltDigits.Enabled := not fltFixed.Checked;
  fltPrecision.Enabled := not fltFixed.Checked;

  with PTestField(lv.Selected.Data)^ do begin
    Precision := fltPrecision.Value;
    Length := fltDigits.Value;
    FixedFloat := fltFixed.Checked;
  end;
end;

function TPluginForm.FormatIdentifier(const Ident: string; DBIndex: integer): string;
var
  S: string;
begin
  Result := Ident;
  if Trim(Ident) = '' then Exit;

  S := Ident;
  S := String(FIntf.FormatIdentifier(PChar(S), DBIndex));
  Result := S;
end;

function TPluginForm.GenerateEnum(FieldInfo: PTestField): string;
begin
  Result := GetStringFromList(FieldInfo);
end;

end.
