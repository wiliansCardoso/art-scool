unit uMain;


(*******************************************************************************
             ...::: ARTHUS SISTEMAS :::...

 Programadores......: Wilians Cardoso.

 Tester.............:
 Função do Módulo...: Modulo Principal do Sistema ( Main )
 Data de Criação....: 24/02/2015 -- 15:00
 Observações........:
 24/02/2015 - WILL - Inicio da codificação.

*******************************************************************************)


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, ExtCtrls, RzPanel, ExeInfo, ScktComp, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvPreviewMenu, AdvPreviewMenuStylers, AdvOfficeHint,
  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, AdvToolBar, AdvToolBarStylers,
  AdvShapeButton, AdvGlowButton, jpeg, ImgList, Menus, IniFiles, ActnList,
  uNitdeclaracoes, URichMenu, StdCtrls, ComCtrls, RzCommon

   {$IFDEF VER150}
    ,XPMan
  {$ENDIF}
  {$IFDEF VER160}
    ,XPMan
  {$ENDIF}
  {$IFDEF VER170}
    ,XPMan
  {$ENDIF}
  ;

Const
  //***** TIPO VERSAO ******
  // Compilação : apenas final ex: 1.0[Siglas]0.XX
  //      0 ...  99  Alfa a
  //    101 ... 199  Beta ß
  //    200 ... 299  Release Candidate ©
  //    300 ... 399  Final Release ƒ
  TipoVer = ' ß ';
  DB_Version = 01;

Type
  (* Informacoes temporarias do EMITENTE *)
  TEmitente = record
    CNPJ: String;
    IE: String;
    RazaoSocial: String;
    NomeFantasia: String;
    Fone: String;
    CEP: String;
    Logradouro: String;
    Numero: String;
    Complemento: String;
    Bairro: String;
    CodCidade: String;
    Cidade: String;
    UF: String;
    //17/08 - WILL
  (* Informacoes temporarias para parte FISCAL DE NFes *)    
    emit_crt: integer;
    emit_csosn: integer;
    emit_pis: Currency;
    emit_cofins: Currency;
    emit_icns: Currency;
  end;
  (* Informacoes temporarias da CONFIGURACAO DO SISTEMA *)
  TConfiguracao = record
    EmpresaNome: String;      // Nome da empresa contratada
    EmpresaCodigo: integer;   // Código
    UsuarioNome: String;      // NOme do usuario logado
    UsuarioCodigo: integer;   // Código usuario logado
    UsuarioNivel: integer;    // Nivel do usuario logado
    Data: TDate;
    DataCaixa: String;        // Data do caixa.
    Enterportab: Boolean;     // Se troca enter por tab
    Administrador: Boolean;   // Se Usuario é admnistrador
    NomeSoftware: string;     // Nome do sistema
    SloganSoftware: string;   // Slogan do sistema
    Versao: string;           // versao do sistema
    Registrado: boolean;      // Registrado ou não
    RazaoSocial: String;      // razao do registrado
    NomeFantasia: String;     // nome fantasia do registrado
    Telefone: String;         // telefone
    Responsavel: String;      // nome do responsavel na loja do registrado

  (* Informacoes temporarias da CONFIGURACAO DO SISTEMA *)
    Autenticado: boolean;     // Sistema está autenticado?
    NomArqCONF: String;       // Nome arquivo de configuraçao
    DirInstalacao:String;     // Dir de instalaçao do sistema
    ServAutent:String;        // servidor de autenticação do sistema
    ServPorta: Integer;       // Porta do servidor de aut.
    DirInst:String;           // Dir Instalaçao temporario
    IniCOnfig:TInifile;       // Var para uso em abertura de inis
  (* Informacoes temporarias da LICENÇA DO SISTEMA * COMPOEN NA CHAVE ****)
    Licenca: String;          // Nr da licença
    Modulos: integer;         // Nr. de modulos
    ModulosC: String;         // modulos temporarios
    Pdvs: Integer;            // Nr. PDVS
    DiaVencimento : Integer;  // Dia vencimento do boleto cliente
  (* Informacoes temporarias dos MODULOS DA APLICAÇAO *)
    ModBASE: String;          // Modulos basicos
    ModNFE:  String;          // Modulos da NFe
    ModRES1: String;          // Movimentos
    ModRES2: String;          // Vendas Ordem de Servicos
    ModRES3: String;          // Compras
    ModFin:  String;          // Modulos do Financeiro
//    ModRes4: String;          // RESERVADOOOOOOOOOOOOOOOOOOOOOOOO
    ModRES5: String;          // PDV
    MODRES6: String;          // Venda Balcao
    MODRES7: String;          // Caixa Central
    MODRES8: String;          // Multi Caixa
    MODRES9: String;          // Pet-Shop
    MODRES10:String;          // Granja
    MODFISC:String;           // Módulo FISCAL
    MODSPEDF: String;         // SPED Fiscal/ pis/COfins
    MODSPEDC: String;         // SPED Contabil
    MODCHEQ: String;          // CONTROLE DE CHEQUES
    MODADMF: String;          // ADMINISTRACAO FINANCEIRA
    MODCCRED: String;         // CONTROLE DE CARTOES DE CREDITO
    MODCONV: String;          // CONTROLE DE CONVENIOS
    MODSION: String;          // CONTROLE DAS SINCRONIAS ONLINES DE CHEQUES
    MODBXML: String;          // CONTROLE PARA BAIXAR XML DIRETO DA SEFAZ.
    MODECRED: String;         // CONTROLE INTEGRACAO DO ECRED.
    MODMDFE: String;          // MANIFESTACAO DO DESTINATARIO ELETRONICA.
    //----  L1371
  (* Informacoes temporarias dos LINKS DE PUBLICIDADES *)
    LinkPublicidade1: integer; // publicidade 1
    LinkPublicidade2: integer; // publicidade 2
    Emitente: TEmitente;
   (* DIRETORIOS DAS FOTOS DO SISTEMA *)
    Path_fotos_clientes: String;
    Path_fotos_produtos: String;
    Path_fotos_Empresa : String;
    Path_fotos_Animais : String;

  end;


  TFrmMain = class(TForm)
    AdvMain: TAdvToolBarPager;
    PageCadastro: TAdvPage;
    AdvShapeButton1: TAdvShapeButton;
    AdvQuickAccessToolBar1: TAdvQuickAccessToolBar;
    AdvGlowMenuButton5: TAdvGlowMenuButton;
    AdvGlowButton9: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton11: TAdvGlowButton;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvOfficeHint1: TAdvOfficeHint;
    MenuMain: TAdvPreviewMenu;
    AdvPreviewMenuOfficeStyler1: TAdvPreviewMenuOfficeStyler;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    ClientSocket: TClientSocket;
    ExeInfo1: TExeInfo;
    StatusBar1: TRzStatusBar;
    StsBarMensag: TRzMarqueeStatus;
    RzClockStatus1: TRzClockStatus;
    pnUsuario: TRzGlyphStatus;
    pnDtaFinanceiro: TRzGlyphStatus;
    pnVersao: TRzStatusPane;
    pnLoja: TRzGlyphStatus;
    Panel1: TPanel;
    MDITab: TAdvOfficeMDITabSet;
    ImgFiscalR: TImage;
    imgtoolbar: TImageList;
    ImageToolBar: TImageList;
    ImgMenu: TImageList;
    PopMenuQuick: TPopupMenu;
    Cascata1: TMenuItem;
    LadoaLado1: TMenuItem;
    Arranje1: TMenuItem;
    Minimizartodas1: TMenuItem;
    N1: TMenuItem;
    FecharTodas1: TMenuItem;
    ActionList1: TActionList;
    ActAluno: TAction;
    AdvToolBar1: TAdvToolBar;
    AdvGlowButton1: TAdvGlowButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ActAlunoExecute(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Arquivo: TextFile;
    MensagLicenca: string;
    FlgExpirado: Boolean;
    Ini_config  :TIniFile;
  //  Ini_Update  :TIniFile;
    arq_backup  :String;
    procedure EnviaString;    
  public
    { Public declarations }
    Ini_configBD :TIniFile;
    Configuracao :TConfiguracao;
    Emitente     :TEmitente;
    Funcao       :TFuncoes;
    procedure ConectaBD(const cabini:String);
    procedure MsgTick(Mensag: string; Pause: Boolean);
    function DataDeCriacao(Arquivo: string): string;

    
  Const
     Path_reports = 'Reports\';
     Path_gmaps   = 'Arquivos\';

  end;
 
var
  FrmMain: TFrmMain;
  resta, restaDias : String; //Var compoem os dias restantes da chave.  

implementation

uses
  uDM;

{$R *.dfm}

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if application.messagebox(PChar('Deseja realmente sair do ' +
     #13 + Configuracao.NomeSoftware + '?'),
     'Atenção', MB_IconInformation + MB_YESNO) = idNo then
    Abort;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FrmMain.MDIChildCount > 0 then
  begin
    Application.MessageBox(PAnsiChar(Configuracao.NomeSoftware +
      ' não será finalizado enquanto ' +
      'todas as telas estiverem abertas'),
      'AVISO - Telas Abertas', MB_ICONWARNING + MB_OK);
    CanClose := False;
    Exit;
  end
  else
  begin
    FrmMain.Menu := nil;
    if DmGlobal.MyConnecPai.Connected then
    DmGlobal.MyConnecPai.Connected := False;
    CanClose := True;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
 var
  Passivo: String;
  Terminal: String;
begin
//==============================================================================================
// 30/08/2011 - WILL - Create totalmente mudado para aceitar leitura do .INF na conecção
//                     do banco de dados e validaçao do servidor de autenticação.
//==============================================================================================

  // Variaveis de Ambiente                                                               
  DateSeparator               := '/';
  ShortDateFormat             := 'dd/mm/yyyy'; //Manipula data do sistema para formato convencional.
  //Application.OnHint          := MostraHint;
//  Configuracao.Versao         := Copy(ExeInfo1.fileVersion,1,3)+Copy(ExeInfo1.fileVersion,4,8)+TipoVer;
  Configuracao.Versao         := ExeInfo1.fileVersion +TipoVer;
  Configuracao.NomeSoftware   := 'ARTHUS SCOOL';
  Configuracao.SloganSoftware := 'ARTHUS Sistemas - Seguranca e Simplicidade Visando Resultados';
  Configuracao.NomArqCONF     := 'ART_SCL.INF';  // nome arquivo configuraçoes
  Arq_backup                  := 'ART_SCL.SQL';  // nome arquivo de backup.
  //VERIFICA RESOLUÇÃO DO VIDEO
  if (Screen.Width = 1024) and (screen.Height = 768) then
  begin
    Width  := 1024;
    Height := 738;
  end;
  // Testa existencia do arquivo de configurações.
  if not FileExists( Configuracao.DirInst + Configuracao.NomArqCONF ) then
  begin
    Beep;
    FrmMain.WindowState          := wsMinimized;
    MessageDlg('Não foi possível encontrar o arquivo de configuração.' + #13 +
               'Favor, contacte o seu Administrador de Sistemas ou'    + #13 +
               ' ' + #13 +
               ' Suporte tecnico: (18)8132-8265         ' + #13 +
               '                    MSN: suporte1@wpsistemas.com' + #13 +
               ' ' , mtError, [mbOk], 0);
    Application.Terminate;
    exit;
  end;
  Configuracao.DirInst := ExtractFilePath(GetModuleName(HInstance));
//
//  *****************************
//
  Ini_configBD         := TIniFile.Create( Configuracao.DirInst + Configuracao.NomArqCONF  );
  //Conecta o banco de acordo com o arquivo de configuração .INF
  ConectaBD('BD');
  //
//  AtualizaBanco( DmGlobal.MyConnecPai ); //Atualiza o banco de Dados antes de tudo.

  //Configura o socket de autenticação das licenças
  Ini_config  := TIniFile.Create( Configuracao.DirInst + Configuracao.NomArqCONF);
  try
    Configuracao.ServAutent := Ini_config.ReadString( 'SRV', 'Servidor', '' );
    Configuracao.ServPorta  := Ini_config.ReadInteger('SRV', 'Porta'   , 0  );
  Finally
    Ini_config.Free;
  end;
  try
    //---- Ativando aqui será ativo o esquema de licença com autenticaçao no servidor.
    ClientSocket.Active  := False;
    ClientSocket.Host    := Configuracao.ServAutent;
    ClientSocket.Address := Configuracao.ServAutent;
    ClientSocket.Port    := Configuracao.ServPorta;
    ClientSocket.Active  := True;
  except
    MessageDlg('Servidor Autenticação não encontrado ou desativado.' + #13 +
              'Comunique o suporte tecnico.', mtError, [mbOk], 0);
   Application.Terminate;
   Exit;
    end;


end;


procedure TFrmMain.FormShow(Sender: TObject);
var
  pt: tpoint;
  x : string;
  Inifile: Tinifile;
begin
    Configuracao.DataCaixa     := DateToStr(now);
    Configuracao.UsuarioNome   := 'MASTER';
   // Configuracao.UsuarioNivel  := DmGlobal.QryLogin.FieldByName('NIVEL' ).AsInteger;
  //  Configuracao.UsuarioCodigo := DmGlobal.QryLogin.FieldByName('COD_USUARIO' ).AsInteger;
    pnVersao.Caption           := Configuracao.Versao;
    pnUsuario.Caption          := Configuracao.UsuarioNome;
    pnDtaFinanceiro.Caption    := 'Dta Financeiro: '+DateToStr(now);
    Configuracao.Path_fotos_clientes := 'Fotos\C';
    Configuracao.Path_fotos_produtos := 'Fotos\P';
    Configuracao.Path_fotos_Empresa  := 'Fotos\E';
    Configuracao.Path_fotos_Animais  := 'Fotos\A';

    pnDtaFinanceiro.Caption    := 'Dta.Finaceiro: '+Configuracao.DataCaixa;
    //01/09/2011 - WILL - Mostra texto de expiraçao da chave...
    MsgTick('', True);
    if MensagLicenca <> '' then
      MsgTick(MensagLicenca, False);

  // colocar o cursor do mouse no canto da tela para nao interferir nos botoes
  getcursorpos(pt);
  pt.x := Width;
  pt.y := Height;
  SetCursorPos(pt.x,pt.y);
  if pt.x>=screen.width-1 then setcursorpos(0,pt.y);
  if pt.y>=screen.height-1 then setcursorpos(pt.x,0);
  //
  //---- Ativando aqui será ativo o esquema de licença com autenticaçao no servidor.
 // LerConfiguracao;
  //---- fim
  AtualizaVarRichMenu;
  Inifile                 := Tinifile.create(Extractfilepath(Application.exename) + Configuracao.NomArqCONF);
  Inifile.free;
  FrmMain.Caption         := configuracao.NomeSoftware+' » '+
  configuracao.NomeFantasia + ' (Loja '+ IntToStr(configuracao.EmpresaCodigo)+
                      ' - '+FrmMain.Configuracao.Emitente.Cidade+'-'+FrmMain.Configuracao.Emitente.UF+' )';
  pnLoja.Caption          := 'LOJA'+ IntToStr(configuracao.EmpresaCodigo);
  //--Informa o slogan e adiciona os dias da licença e a data da ultima compilação.

  if RestaDias = '' then
    AdvMain.Caption.Caption := configuracao.SloganSoftware+
    ' - Ult.Comp: '+DataDeCriacao(Extractfilepath(Application.exename)+'ART_SCOOL.EXE')
  else
    AdvMain.Caption.Caption := configuracao.SloganSoftware+
    ' - '+RestaDias+'D - Ultima Compilação: '+DataDeCriacao(Extractfilepath(Application.exename)+'ART_NFE.EXE');
    AdvMain.ActivePageIndex := 0;
  //  TmrAbreFormsIniciais.Enabled := True;
      
  end;

  
procedure TFrmMain.ActAlunoExecute(Sender: TObject);
begin
/////////////
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EnviaString;
end;

procedure TFrmMain.EnviaString;
begin
  ClientSocket.Socket.SendText('ƒÄART3À‰EARTÜ‰EìÁïARTé¹');
end;

procedure TFrmMain.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  FrmMain.WindowState := wsMinimized;
  Application.messagebox(Pchar('Não Foi possivel conectar-se ao servidor de autenticação!' + #13 +
  Funcao.MensagemErroSocket(ErrorCode)),'Sem conecção', MB_ICONWARNING + MB_OK);
  ErrorCode := 0;
  Application.Terminate;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  SerialHD := Funcao.DescriptSerialHD(Socket.ReceiveText);
  if SerialHD = '##CHAVE_INVALIDA##' then begin
    Application.MessageBox('Chave de Retorno inválida!','Atenticação',MB_OK+MB_ICONWARNING);
    Application.Terminate;
  end;
end;

procedure TFrmMain.ConectaBD(const cabini:String);
begin
   DMGlobal.MyConnecPai.Disconnect;
   Try
    with DmGlobal.MyConnecPai do
    begin
      Pooling                  := True;
      LoginPrompt              := False;
      Options.DisconnectedMode := True;
      Options.LocalFailover    := True;
      Username := Ini_configBD.ReadString( cabini, 'UserName', '' );
      Password := Ini_configBD.ReadString( cabini, 'Password', '' );
      Server   := Ini_configBD.ReadString( cabini, 'Server'  , '' );
      Database := Ini_configBD.ReadString( cabini, 'Database', '' );
//    Password := CriptoV2( Config.IniCOnfig.ReadString( 'cabini, 'Password', '' ), False );
      Port     := Ini_configBD.ReadInteger(cabini, 'Porta'   , 0  );
      Connect;
    end;
   except
    on E:Exception do begin
    MessageDlg('Erro de conexão ao banco de dados Online. ' + #13 +
               'Favor, contacte o seu Administrador de Sistemas ou'    + #13 +
               ' ' + #13 +
               ' Suporte tecnico: (18)9 8132-8265         ' + #13 +
               '                    MSN: suporte1@arthussistemas.com' + #13 +
               ' ' +#13+
               E.Message , mtError, [mbOk], 0);
    Application.Terminate;
    exit;

   end;

  end;
  Ini_configBD.Free;
end;


procedure TFrmMain.MsgTick(Mensag: string; Pause: Boolean);
begin
  StsBarMensag.Caption := Mensag;
  StsBarMensag.Scrolling := not Pause;
  StsBarMensag.ScrollType := Funcao.iif(Pause, stNone, stRightToLeft);
  if Pause then
  begin
    StsBarMensag.FillColor := $00F9E7D2;
    StsBarMensag.Font.Color := clBlack;
  end
  else
  begin
    StsBarMensag.FillColor := clRed;
    StsBarMensag.Font.Color := clWhite;
  end;
end;

//Funçao para pegar a data da Ultima alteraçao do arquivo.
function TFrmMain.DataDeCriacao(Arquivo: string): string;
var
  FHandle: integer;
begin
  FHandle := FileOpen(Arquivo, 0);
  try
    Result := DateToStr(FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;

end;

end.
