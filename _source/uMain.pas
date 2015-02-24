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
  AdvShapeButton, AdvGlowButton, jpeg, ImgList, Menus, IniFiles

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
  TipoVer = ' FR ';
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
    BarBase1: TAdvToolBar;
    AdvGlowMenuButton1: TAdvGlowMenuButton;
    BarBase2: TAdvToolBar;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowMenuButton6: TAdvGlowMenuButton;
    BarBasePromo: TAdvToolBar;
    AdvGlowMenuButton9: TAdvGlowMenuButton;
    AdvToolBar4: TAdvToolBar;
    AdvGlowMenuButton19: TAdvGlowMenuButton;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Arquivo: TextFile;
    MensagLicenca: string;
    FlgExpirado: Boolean;
    Ini_config  :TIniFile;
  //  Ini_Update  :TIniFile;
    arq_backup  :String;

  protected
    { Protected declarations }
    Ini_configBD :TIniFile;
    Configuracao :TConfiguracao;
    Emitente     :TEmitente;
    
  Const
     Path_reports = 'Reports\';
     Path_gmaps   = 'Arquivos\';

  end;
    

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if application.messagebox(PChar('Deseja realmente sair do ' +
     #13 + Configuracao.NomeSoftware + '?'),
     'Atenção', MB_IconInformation + MB_YESNO) = idNo then
    Abort;
end;

end.
