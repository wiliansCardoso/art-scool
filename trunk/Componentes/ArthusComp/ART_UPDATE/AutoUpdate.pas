{
Componente   AutoUpdate
=======================
Autor        - Ricardo Alves Carvalho
               ricardo.alves@fazenda.mg.gov.br
               ricardo@dbquester.com
               ricardoc@larnet.com.br

=======================
Versão       - 18/05/2009
Adaptação para Delphi 2009 com a colaboração de
José Ricardo Aviles - jraviles@stiware.com.br


=======================
Versão       - 12/05/2008
Linguagem    - Delphi 2007 / Indy 10
Distribuição - Free, sem garantias

Novidades desta versão:
=======================
1 - Inclusão da diretiva INDY_10. Para compilar para a versão 9 do Indy,
    (até Delphi 7) basta remover o DEFINE correspondente.
2 - Propriedade AutoNeedVersionControl. Ajustando para True, o próprio
    componente faz o controle de versão incluindo um arquivo com a estensão
    ".ver" no servidor de FTP, não sendo necessário a criação de um handler
    para o evento OnNeedVersion.
3 - Propriedade Compact. Ajustando para True, o componente irá compactar o
    executável no Deploy e descompactar no Update.
4 - Melhorias internas no Deploy e no frmAtualizando.

Incrível coincidência: Só agora percebi que a data de atualização coincide
                       com a data da primeira versão, porém dois anos depois.

=======================
Versão       - 12/05/2006
Linguagem    - Delphi 2006 / Indy 10
Distribuição - Free, sem garantias

Funcionamento:
==============
1 - Habilitar a inclusão de informações de versão (Project/Options)
2 - Configurar as propriedades do FTP
3 - Criar um handler para o evento OnNeedVersion. Este handler deve
    informar qual a versão mais atual do programa, tipicamente bus-
    cando esta informação no banco de dados.
4 - Opcionalmente, criar um handler para o evento OnNeedDeploy.
    Este evento ocorre quando a versão atual é mais recente que
    a informada no evento OnNeedVersion e pode ser utilizada para
    chamar o método Deploy (envia a versão para o FTP) do
    componente.
5 - Opcionalmente, criar um handler para o evento OnCompareVersions.
    Dados dois identificadores de versão, este handler deve
    informar se iguais ou qual é a mais recente. Se a comparação for
    a padrão (1.0.0.0), o handler é desnecessário.

Exemplo de utilização:
======================

procedure Tdm.IBDatabase1AfterConnect(Sender: TObject);
begin
  aup1.UpdateMessage :=
    'Há uma nova versão do ' +
    Application.Title + ' disponível.'#13#10 +
    'A atualização automática será iniciada.';
  aup1.Execute;
end;

procedure Tdm.aup1NeedVersion(Sender: TObject; var DeployVersion: String);
begin
  qryVersao.Close;
  qryVersao.ParamByName('NOME').AsString := ExtractFileName(ParamStr(0));
  qryVersao.Open;
  if qryVersao.IsEmpty then
    raise Exception.Create(
      'O software não está na lista de atualização automática'
    );
  DeployVersion := qryVersao.FieldByName('VERSAO').AsString;
  qryVersao.Close;
end;

procedure Tdm.aup1NeedDeploy(Sender: TObject);
begin
  Deploy;
end;

procedure Tdm.Deploy;
begin
  if MessageDlg('Fazer deploy do ' + Application.Title + '?'#13#10#13#10 +
  'Atenção: Lembre-se de salvar o projeto antes do deploy!',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with TfrmSenha.Create(Self) do
    try
      if not ((ShowModal = mrOK) and (Edit1.Text = 'senha_do_admin')) then
        Exit;
    finally
      Free;
    end;
    aup1.Deploy;
    sqlUpVersao.ParamByName('NOME').AsString := ExtractFileName(ParamStr(0));
    sqlUpVersao.ParamByName('VERSAO').AsString := aup1.ExeVersion;
    sqlUpVersao.ExecQuery;
    sqlUpVersao.Transaction.CommitRetaining;
  end;
end;
}

unit AutoUpdate;

interface

uses
  Classes, SysUtils, Windows, Forms, Dialogs, Controls, IdFTP, IdAntiFreeze,
  unAtualizando, IdFTPCommon, IdComponent, IdAntiFreezeBase, ZLib;

type
  TCompareVersions = procedure(Sender: TObject;
    ExeVersion, DeployVersion: string; var DeployIsLatest: Integer) of object;

  TNeedVersion = procedure (Sender: TObject;
    var DeployVersion: string) of object;

  {$DEFINE INDY_10}
  {$IFDEF VER190}
    {$DEFINE WIDE_STRING}
  {$ENDIF}
  {$IFDEF VER200}
    {$DEFINE WIDE_STRING}
  {$ENDIF}

  TAutoUpdate = class(TComponent)
  private
    FOptionalUpdate: Boolean;
    FFTPHost: string;
    FFTPUser: string;
    FUpdateMessage: string;
    FFTPPassword: string;
    FOnCompareVersions: TCompareVersions;
    FOnNeedVersion: TNeedVersion;
    FOnNeedDeploy: TNotifyEvent;
    FFTPDir: string;
    FFTPPassive: Boolean;
    BytesToTransfer: LongWord;
    FAutoNeedVersionControl: boolean;
    FCompact: boolean;
    procedure SetFTPHost(const Value: string);
    procedure SetFTPPassword(const Value: string);
    procedure SetFTPUser(const Value: string);
    procedure SetUpdateMessage(const Value: string);
    procedure SetOnCompareVersions(const Value: TCompareVersions);
    procedure SetOnNeedDeploy(const Value: TNotifyEvent);
    procedure SetOnNeedVersion(const Value: TNeedVersion);
    procedure SetOptionalUpdate(const Value: Boolean);
    procedure SetFTPDir(const Value: string);
    procedure SetFTPPassive(const Value: Boolean);
    procedure FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      {$IFNDEF INDY_10} const {$ENDIF}
      AWorkCountMax: {$IFDEF WIDE_STRING} Int64 {$ELSE} Integer {$ENDIF});
    procedure FTPWork(Sender: TObject; AWorkMode: TWorkMode;
      {$IFNDEF INDY_10} const {$ENDIF}
      AWorkCount: {$IFDEF WIDE_STRING} Int64 {$ELSE} Integer {$ENDIF});
    procedure SetAutoNeedVersionControl(const Value: boolean);
    procedure SetCompact(const Value: boolean);
    procedure StatusVersion(var i: Integer);
  protected
    Client: TIdFTP;
    AntiFreeze: TIdAntiFreeze;
    procedure Update;
    function GetVersaoServidor: string;
    procedure GetClientInstance;
  public
    procedure Execute;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Deploy;
    function FTPAvailable: boolean;
    class function ExeVersion: string;
  published
    property FTPHost: string read FFTPHost write SetFTPHost;
    property FTPUser: string read FFTPUser write SetFTPUser;
    property FTPPassword: string read FFTPPassword write SetFTPPassword;
    property FTPDir: string read FFTPDir write SetFTPDir;
    property FTPPassive: Boolean read FFTPPassive write SetFTPPassive;
    property UpdateMessage: string read FUpdateMessage write SetUpdateMessage;
    property OptionalUpdate: Boolean read FOptionalUpdate write SetOptionalUpdate;
    property AutoNeedVersionControl: boolean
      read FAutoNeedVersionControl write SetAutoNeedVersionControl;
    property Compact: boolean read FCompact write SetCompact;
    // eventos
    property OnNeedVersion: TNeedVersion
      read FOnNeedVersion write SetOnNeedVersion;
    property OnCompareVersions: TCompareVersions
      read FOnCompareVersions write SetOnCompareVersions;
    property OnNeedDeploy: TNotifyEvent
      read FOnNeedDeploy write SetOnNeedDeploy;
  end;

  procedure Register;

var
  frmAtualizando: TfrmAtualizando;

implementation

procedure Register;
begin
  RegisterComponents('ARTHUS', [TAutoUpdate]);
end;

{$WARN SYMBOL_PLATFORM OFF}

function VersaoExe: String;
type
  PFFI = ^vs_FixedFileInfo;
var
  F       : PFFI;
  Handle  : Dword;
  Len     : Longint;
  Data    : Pchar;
  Buffer  : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
  Arquivo : String;
begin
  Arquivo  := Application.ExeName;
  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
     Data:=StrAlloc(Len+1);
     if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
     begin
        VerQueryValue(Data, '\',Buffer,Tamanho);
        F := PFFI(Buffer);
        Result := Format('%d.%d.%d.%d',
                         [HiWord(F^.dwFileVersionMs),
                          LoWord(F^.dwFileVersionMs),
                          HiWord(F^.dwFileVersionLs),
                          Loword(F^.dwFileVersionLs)]
                        );
     end;
     StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

function CompareVersion(UmaVersao, OutraVersao: String): Shortint;
var
  a, b, i, j: byte;
begin
  i := pos('.', UmaVersao);
  if i = 0 then
    a := StrToInt(UmaVersao)
  else
    a := StrToInt(copy(UmaVersao, 1, i-1));

  j := pos('.', OutraVersao);
  if j = 0 then
    b := StrToInt(OutraVersao)
  else
    b := StrToInt(copy(OutraVersao, 1, j-1));

  if a <> b then
  begin
    if a > b then
      result := 1
    else
      result := -1;
  end
  else if i = 0 then
      result := 0
  else
    result := CompareVersion(
      copy(UmaVersao,   i+1, length(UmaVersao)),
      copy(OutraVersao, j+1, length(OutraVersao))
    );
end;

function GetTmpDir: string;
var
  pc: PChar;
begin
  pc := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH, pc);
  Result := string(pc);
  StrDispose(pc);
end;

function GetTmpFileName(ext: string): string;
var
  pc: PChar;
begin
  pc := StrAlloc(MAX_PATH + 1);
  GetTempFileName(PChar(GetTmpDir), 'EZC', 0, pc);
  Result := string(pc);
  Result := ChangeFileExt(Result, ext);
  StrDispose(pc);
end;

function FileLength(FileName: string): integer;
var
  f: File of byte;
  oldMode: integer;
begin
  oldMode := FileMode;
  AssignFile(f, FileName);
  try
    FileMode := fmOpenRead;
    Reset(f);
    result := FileSize(f);
  finally
    CloseFile(f);
    FileMode := oldMode;
  end;
end;

procedure Descompactar(Compactado: TFileName; DirDestino: AnsiString);
resourcestring
  EDecompressionErrorMessage = 'Arquivo %s corrompido';
var
  FileOutName, FileOutFullName: AnsiString;
  FileIn, FileOut: TFileStream;
  Zip: TDecompressionStream;
  NumArquivos, I, Len, Size: Integer;
  Fim: Byte;
begin
  if DirDestino = '' then
    DirDestino := GetCurrentDir;
  FileIn := TFileStream.Create(
              Compactado,
              fmOpenRead and fmShareExclusive
            );
  Zip := TDecompressionStream.Create(FileIn);
  Zip.Read(NumArquivos, SizeOf(Integer));
  try
    for I := 0 to NumArquivos - 1 do
    begin
      Zip.Read(Len, SizeOf(Integer));
      SetLength(FileOutName, Len);
      Zip.Read(FileOutName[1], Len);
      Zip.Read(Size, SizeOf(Integer));

      FileOutFullName := IncludeTrailingPathDelimiter(DirDestino) + FileOutName;
      ForceDirectories(ExtractFileDir(FileOutFullName));
      FileOut := TFileStream.Create(
                   FileOutFullName,
                   fmCreate or fmShareExclusive
                 );
      try
        FileOut.CopyFrom(Zip, Size);
      finally
        FileOut.Free;
      end;
      Zip.Read(Fim, SizeOf(Byte));
      if Fim <> 0 then
        raise Exception.CreateFmt(EDecompressionErrorMessage, [Compactado]);
    end;
  finally
    Zip.Free;
    FileIn.Free;
  end;
end;


{ TAutoUpdate }

constructor TAutoUpdate.Create(AOwner: TComponent);
begin
  inherited;
  UpdateMessage :=
    'Há uma nova versão do aplicativo disponível.'#13 +
    'A atualização automática será iniciada.';
end;

procedure TAutoUpdate.Execute;
var
  i: integer;
  botoes: TMsgDlgButtons;
begin
  StatusVersion(i);
  if i > 0 then
  begin
    botoes := [mbOK];
    if OptionalUpdate then
      Include(botoes, mbCancel);
    if MessageDlg(UpdateMessage, mtInformation, botoes, 0) = mrOk then
      Update;
  end
  else if (i < 0) and Assigned(FOnNeedDeploy) then
    FOnNeedDeploy(Self);
end;

procedure TAutoUpdate.SetFTPHost(const Value: string);
begin
  FFTPHost := Value;
end;

procedure TAutoUpdate.SetFTPPassword(const Value: string);
begin
  FFTPPassword := Value;
end;

procedure TAutoUpdate.SetFTPUser(const Value: string);
begin
  FFTPUser := Value;
end;

procedure TAutoUpdate.SetUpdateMessage(const Value: string);
begin
  FUpdateMessage := Value;
end;

procedure TAutoUpdate.StatusVersion(var i: Integer);
var
  VersaoServidor: string;
  VersaoExecutavel: string;
begin
  if (not Assigned(FOnNeedVersion)) and (not AutoNeedVersionControl) then
    raise Exception.Create(
      'O manipulador do evento OnNeedVersion é obrigatório.'
    );

  if AutoNeedVersionControl then
    VersaoServidor := GetVersaoServidor
  else
  begin
    VersaoServidor := '';
    FOnNeedVersion(Self, VersaoServidor);
    if VersaoServidor = '' then
      raise Exception.Create('Versão disponível inválida (vazia).');
  end;

  VersaoExecutavel := VersaoExe;
  if VersaoExecutavel = '' then
    VersaoExecutavel := '1.0.0.0';
  i := CompareVersion(VersaoServidor, VersaoExecutavel);
  if Assigned(FOnCompareVersions) then
    FOnCompareVersions(Self, VersaoExecutavel, VersaoServidor, i);
end;

procedure TAutoUpdate.SetOnCompareVersions(const Value: TCompareVersions);
begin
  FOnCompareVersions := Value;
end;

procedure TAutoUpdate.SetOnNeedDeploy(const Value: TNotifyEvent);
begin
  FOnNeedDeploy := Value;
end;

procedure TAutoUpdate.SetOnNeedVersion(const Value: TNeedVersion);
begin
  FOnNeedVersion := Value;
end;

procedure TAutoUpdate.SetOptionalUpdate(const Value: Boolean);
begin
  FOptionalUpdate := Value;
end;

procedure TAutoUpdate.Update;
var
  tempFile, NomeExe, batchName, NomeDos, TmpDir: AnsiString;
  lista: TStringList;
  existe: Boolean;
begin
  GetClientInstance;
  // verificar disponibilidade do arquivo no servidor
  NomeExe := ExtractFileName(Application.ExeName);
  if Compact then
    NomeExe := ChangeFileExt(NomeExe, '.zib');

  lista := TStringList.Create;
  frmAtualizando := TfrmAtualizando.Create(Self);
  try
    Client.TransferType := ftASCII;
    Client.List(lista, NomeExe, False);
    existe := (lista.Count > 0) and
              (UpperCase(lista[0]) = UpperCase(NomeExe));
    if not existe then
      raise Exception.Create('Arquivo não disponível no servidor FTP.');

    // Exibir transferência para o usuário
    Client.TransferType := ftBinary;
    BytesToTransfer := Client.Size(NomeExe);
    frmAtualizando.Show;

    // baixar arquivo temporário
    TmpDir := GetTmpDir;
    tempFile := TmpDir + ChangeFileExt(NomeExe, '.tmp');
    Client.Get(NomeExe, tempFile, True);
    Client.Disconnect;
    if not FileExists(tempFile) then
      exit;

    if Compact then
    begin
      frmAtualizando.Message := 'Descompactando...';
      Descompactar(tempFile, TmpDir);
      NomeExe := ChangeFileExt(tempFile, '.exe');
      DeleteFile(pchar(tempFile));
      tempFile := NomeExe;
    end;

    // criar bath e sobrepor exe
    NomeDos := ExtractShortPathName(ParamStr(0));
    lista.Clear;
    batchname := GetTmpFileName('.bat');
    FileSetAttr(ParamStr(0), 0);
    lista.Add(':Label1');
    lista.Add('@echo off');
    lista.Add('del ' + NomeDos);
    lista.Add('if Exist ' + NomeDos + ' goto Label1');
    lista.Add('Move ' + tempFile + ' ' + NomeDos);
    lista.Add('Call ' + NomeDos);
    lista.Add('del ' + batchname);

    lista.SaveToFile(batchname);
    ChDir(TmpDir);
    WinExec(PAnsiChar(batchname), SW_HIDE);
  finally
    lista.Free;
    FreeAndNil(frmAtualizando);
    Application.Terminate;
  end;
end;

destructor TAutoUpdate.Destroy;
begin
  if Client <> nil then
  begin
    Client.Free;
    AntiFreeze.Free;
  end;
  inherited;
end;

procedure TAutoUpdate.SetAutoNeedVersionControl(const Value: boolean);
begin
  FAutoNeedVersionControl := Value;
end;

procedure TAutoUpdate.SetCompact(const Value: boolean);
begin
  FCompact := Value;
end;

procedure TAutoUpdate.SetFTPDir(const Value: string);
begin
  FFTPDir := Value;
end;

procedure TAutoUpdate.SetFTPPassive(const Value: Boolean);
begin
  FFTPPassive := Value;
end;

procedure TAutoUpdate.FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  {$IFNDEF INDY_10} const {$ENDIF}
  AWorkCountMax: {$IFDEF WIDE_STRING} Int64 {$ELSE} Integer {$ENDIF});
begin
  if AWorkCountMax > 0 then
    frmAtualizando.Max := AWorkCountMax
  else
    frmAtualizando.Max := BytesToTransfer;
end;

function TAutoUpdate.FTPAvailable: boolean;
begin
  try
    GetClientInstance;
    result := True;
  except;
    result := False;
  end;
end;

procedure TAutoUpdate.FTPWork(Sender: TObject; AWorkMode: TWorkMode;
  {$IFNDEF INDY_10} const {$ENDIF}
  AWorkCount: {$IFDEF WIDE_STRING} Int64 {$ELSE} Integer {$ENDIF});
begin
  frmAtualizando.Position := AWorkCount;
end;

procedure TAutoUpdate.Deploy;
var
  NomeExe, VersaoExecutavel, FileVer: AnsiString;
  sl: TStringList;
  i: Integer;
  b: Byte;

  stream: TFileStream;
  zip: TCompressionStream;
  memory: TMemoryStream;
  putstream: TStream;
begin
  GetClientInstance;
  NomeExe := Application.ExeName;

  frmAtualizando := TfrmAtualizando.Create(Self);
  stream := TFileStream.Create(NomeExe, fmShareDenyNone);
  memory := TMemoryStream.Create;
  try
    stream.Position := 0;
    NomeExe := ExtractFileName(NomeExe);
    frmAtualizando.Show;
    if Compact then
    begin
      frmAtualizando.Message := 'Compactando...';
      zip := TCompressionStream.Create(clMax, memory);
      try
        i := 1;
        zip.Write(i, SizeOf(Integer));
        i := Length(NomeExe);
        zip.Write(i, SizeOf(Integer));
        zip.Write(NomeExe[1], i);
        i := stream.Size;
        zip.Write(i, SizeOf(Integer));
        zip.CopyFrom(stream, i);
        b := 0;
        zip.Write(b, SizeOf(Byte));
      finally
        zip.Free;
      end;
      NomeExe := ChangeFileExt(NomeExe, '.zib');
      putstream := memory;
    end
    else
      putstream := stream;

    BytesToTransfer := putstream.Size;
    frmAtualizando.Message := 'Enviando...';
    Client.TransferType := ftBinary;
    Client.Put(putstream, NomeExe);

    if AutoNeedVersionControl then
    begin
      frmAtualizando.Message := 'Atualizando versão...';
      sl := TStringList.Create;
      try
        VersaoExecutavel := VersaoExe;
        if VersaoExecutavel = '' then
          VersaoExecutavel := '1.0.0.0';
        FileVer := VersaoExecutavel + '.ver';
        memory.Size := 0;
        sl.SaveToStream(memory);
        BytesToTransfer := memory.Size;
        try
          Client.List(sl, '*.ver', False);
        except
          // não há *.ver no servidor
        end;
        for i := 0 to sl.Count - 1 do
          Client.Delete(sl[i]);
        Client.Put(memory, ExtractFileName(FileVer));
        frmAtualizando.Message := 'Pronto';
      finally
        sl.Free;
      end;
    end;
    Client.Disconnect;
  finally
    memory.Free;
    stream.Free;
    FreeAndNil(frmAtualizando);
  end;
  ShowMessage('Deploy finalizado.');
end;

procedure TAutoUpdate.GetClientInstance;
begin
  if Client = nil then
  begin
    if FTPHost = '' then
      raise Exception.Create('FTPHost não definido');
    AntiFreeze         := TIdAntiFreeze.Create(Self);
    Client             := TIdFTP.Create(Self);
    Client.OnWorkBegin := FTPWorkBegin;
    Client.OnWork      := FTPWork;
    Client.Host        := FTPHost;
    Client.Username    := FTPUser;
    Client.Password    := FTPPassword;
    Client.Passive     := FTPPassive;
  end;
  if not Client.Connected then
    Client.Connect;
  if not Client.Connected then
    raise Exception.Create('Erro na conexão com o servidor de FTP');
  if FTPDir <> '' then
    Client.ChangeDir(FTPDir);
end;

class function TAutoUpdate.ExeVersion: string;
begin
  result := VersaoExe;
end;

function TAutoUpdate.GetVersaoServidor: string;
var
  lista: TStringList;
begin
  result := '0.0.0.0';
  GetClientInstance;
  frmAtualizando := TfrmAtualizando.Create(Self);
  lista := TStringList.Create;
  try
    try
      Client.TransferType := ftASCII;
      Client.List(lista, '*.ver', False);
      if lista.Count > 0 then
        result := ChangeFileExt(lista[0], '');
    except
      // nada a fazer
    end;
  finally
    lista.Free;
    FreeAndNil(frmAtualizando);
  end;
end;

end.

