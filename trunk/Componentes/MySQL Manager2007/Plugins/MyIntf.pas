unit MyIntf;

interface

uses Windows;

{---------------------------------------------------------
  Each Plugin have to export three function:
  get_plugin_info - getting information about plugin,
    menu items captions, edited object's type etc.,
  plugin_options_execute - options dialog for Plugin (if needed)
  plugin_execute - launch Plugin

  More sopthisticated Plugins can include
  three additional function. They allow Plugin to be included
  as pages TabControl (rather then Modal dialog).
  These functions have to named as
  plugin_create_controls - called during creating object editor
  plugin_destroy_controls - called to destry object editor
  plugin_refresh_controls - called when user activate page
    which was created by Plugin.
 ---------------------------------------------------------}

const
  { MySQL Fields Types }
  mftTinyInt = 0;
  mftSmallInt = 1;
  mftMediumInt = 2;
  mftInteger = 3;
  mftBigInt = 4;
  mftFloat = 5;
  mftDouble = 6;
  mftDecimal = 7;
  mftDate = 8;
  mftDateTime = 9;
  mftTimestamp = 10;
  mftTime = 11;
  mftYear = 12;
  mftChar = 13;
  mftVarChar = 14;
  mftTinyBlob = 15;
  mftBlob = 16;
  mftMediumBlob = 17;
  mftLongBlob = 18;
  mftTinyText = 19;
  mftText = 20;
  mftMediumText = 21;
  mftLongText = 22;
  mftEnum = 23;
  mftSet = 24;

type

  { Execution information }
  PplExecInfo = ^TplExecInfo;
  TplExecInfo = record
    DBIndex: Integer;
    ObjectName: PChar;
    ObjectEditor: pointer; // TForm ascendent
    Reserved: pointer;
  end;

  TMyObjectEditor = (oeNone, oeTable, oeFunction, oeColumn, oeIndex, oeForeignKey);
  TMyObjectEditors = set of TMyObjectEditor;

  { Plugin information }
  PMyManagerPluginInfo = ^TMyManagerPluginInfo;
  TMyManagerPluginInfo = record
    PluginName, Description: PChar;
    IsCommonTool: boolean;
    { Is Plugin common tool or serve to control specific objects}
    PluginObjectEditors: TMyObjectEditors;
    { Processed objects' types }
    MenuCaption: PChar;
    MenuShortCut: word;
    OptionsMenuCaption: PChar;
    OptionsMenuShortCut: word;
    PluginKind: word;
    { If IsCommonTool = false, (Plugin is object editor) then
      this parameter specify kind of editor appearance
      0 - menu item
      1 - add tab to object editor. In this case MenuCaption
          will represent tab caption
    }

    HasOptions: boolean;
    { Specified has Plugin options dialog or not }
    PlaceOnToolbar: boolean;
    { Put button on Toolbar or not }
    UnloadAfterExecute: boolean;
    { Unload plugin after execute or not }
  end;

  { MyManager objects lists }
  TMMITablesList = Pointer;
  TMMITableFields = Pointer;
  TMMIQuery = Pointer;
  TMMITransaction = Pointer;

  { Information about table }
  TMMITableInfo = record
    TableName: PChar;
    TableType: WORD;
    Comment: PChar;
    AutoIncrement: integer;
    AvgRowLength: integer;
    CheckSum: boolean;
    DelayKeyWrite: boolean;
    MaxRows: integer;
    MinRows: integer;
    PackKeys: boolean;
    RowFormat: WORD;
    Union: PChar;
    TypeAsString: PChar;
  end;

  { Information about field of table }
  TMMIFieldInfo = record
    FieldName: PChar;
    FieldPos: WORD;
    FieldType: WORD;
    FieldSize: WORD;
    FieldPrecision: integer; // <= 0
    DefValue: PChar;
    { Field Flags }
    NotNull: boolean;
    AutoIncrement: boolean;
    Binary: boolean;
    Unsigned: boolean;
    ZeroFill: boolean;
    PrimaryKey: boolean;
    Unique: boolean;
    TypeAsString: PChar;
  end;

  { Database functions }
  TDatabasesCount = function : integer;
  TDatabaseAlias = function(DBIndex : integer) : PChar;
  TDatabaseName = function(DBIndex : integer) : PChar;
  TDatabaseActive = function(DBIndex : integer) : boolean;
  TOpenDatabase = function(DBIndex : integer) : integer;
  TCloseDatabase = function(DBIndex : integer) : integer;
  TFormatIdentifier = function(Identifier: PChar; DBIndex: integer): PChar;

  { Table and fields functions }
  TGetTables = function(DBIndex : integer; var TablesCount : integer) : TMMITablesList;
  TFetchTableInfo = function(Tables : TMMITablesList; Index : Integer; var Info : TMMITableInfo) : integer;
  TFreeTables = procedure(Tables : TMMITablesList);
  TFieldsOfTable = function(DBIndex : integer; TableName : PChar; var FieldsCount : integer) : TMMITableFields;
  TFieldInfo = function(Fields : TMMITableFields; Index : integer; var Info : TMMIFieldInfo) : integer;
  TFreeTableFields = procedure(Fields : TMMITableFields);

  { Transaction functions }
  TCreateTransaction = function(DBIndex : integer) : TMMITransaction;
  TStartTransaction = procedure(Transaction : TMMITransaction);
  TCommitTransaction = procedure(Transaction : TMMITransaction);
  TRollbackTransaction = procedure(Transaction : TMMITransaction);
  TFreeTransaction = procedure(Transaction : TMMITransaction);

  { Query functions }
  TCreateQuery = function(DBIndex : integer; Transaction : TMMITransaction) : TMMIQuery;
  TSetQuerySQL = procedure(Query : TMMIQuery; SQL : PChar);
  TExecQuery = function(Query : TMMIQuery): boolean;
  TParamCheck = procedure(Query : TMMIQuery; ParamCheck : boolean);
  TSetParam = procedure(Query : TMMIQuery; ParamIndex : integer; ParamValue : Variant);
  TSetTypedParam = procedure(Query : TMMIQuery; ParamIndex, ParamType : integer; ParamValue : Variant);
  TGetFieldByName = function(Query : TMMIQuery; FieldName : PChar) : variant;
  TGetFieldByIndex = function(Query : TMMIQuery; FieldIndex : integer) : variant;
  TQueryEof = function(Query : TMMIQuery) : boolean;
  TQueryNext = procedure(Query : TMMIQuery);
  TQueryFirst = procedure(Query : TMMIQuery);
  TQueryLast = procedure(Query : TMMIQuery);
  TQueryPrior = procedure(Query : TMMIQuery);
  TFreeQuery = procedure(Query : TMMIQuery);
  TCloseQuery = procedure(Query : TMMIQuery);
  TClearParams = procedure(Query : TMMIQuery);

  { Controls and Forms functions }
  TCreateChildForm = function (FormCaption: PChar): pointer; // TForm
  { Create and get handle of form that will controlled by
  WindowManager. Not implemented }

  TGetComponentByName = function (Form: pointer; Name: PChar): pointer;

  TErrorMessage = procedure (Caption: PChar);
  TInfoMessage = procedure (Caption: PChar);

  { Plugin interface }
  TMyManagerInterface = record
    MyManagerApplication: pointer;
    DatabasesCount : TDatabasesCount;
    DatabaseAlias : TDatabaseAlias;
    DatabaseName : TDatabaseName;
    DatabaseActive : TDatabaseActive;
    FormatIdentifier: TFormatIdentifier;

    OpenDatabase : TOpenDatabase;
    CloseDatabase : TCloseDatabase;

    GetTables : TGetTables;
    FetchTableInfo : TFetchTableInfo;
    FreeTables : TFreeTables;

    FieldsOfTable : TFieldsOfTable;
    FieldInfo : TFieldInfo;
    FreeTableFields : TFreeTableFields;

    CreateTransaction : TCreateTransaction;
    StartTransaction : TStartTransaction;
    CommitTransaction : TCommitTransaction;
    RollbackTransaction : TRollbackTransaction;
    FreeTransaction : TFreeTransaction;

    CreateQuery : TCreateQuery;
    SetQuerySQL : TSetQuerySQL;
    ExecQuery : TExecQuery;
    ParamCheck : TParamCheck;
    SetParam : TSetParam;
    SetTypedParam: TSetTypedParam;
    GetFieldByName : TGetFieldByName;
    GetFieldByIndex : TGetFieldByIndex;
    QueryEof : TQueryEof;
    QueryNext : TQueryNext;
    QueryFirst : TQueryFirst;
    QueryLast : TQueryLast;
    QueryPrior : TQueryPrior;
    FreeQuery : TFreeQuery;
    CloseQuery: TCloseQuery;

    ErrorMessage: TErrorMessage;
    InfoMessage: TInfoMessage;
  end;

  TGetPluginInfoProc = procedure(PluginInfo: PMyManagerPluginInfo); stdcall;
  TPluginOptionsExecuteProc = procedure(Intf : TMyManagerInterface); stdcall;
  TPluginExecuteProc = procedure(ExecInfo: PplExecInfo; Intf : TMyManagerInterface); stdcall;

  TPluginCreateControlsProc = procedure(ExecInfo: PplExecInfo; Intf : TMyManagerInterface; Parent: pointer); stdcall;
  TPluginDestroyControlsProc = procedure(ExecInfo: PplExecInfo; Intf : TMyManagerInterface; Parent: pointer); stdcall;
  TPluginRefreshControlsProc = procedure(ExecInfo: PplExecInfo; Intf : TMyManagerInterface; Parent: pointer); stdcall;

implementation

end.
