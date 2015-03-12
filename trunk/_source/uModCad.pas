unit uModCad;

(*******************************************************************************
             ...::: ARTHUS SISTEMAS NFe:::...

 Programadores......: WILIANS.

 Tester.............:
 Função do Módulo...: Tela Padrao para cadastros
 Data de Criação....: 20/11/2009 -- 20:30
 Observações........:
 20/11/2009 - WILL - Criação e codificação.

*******************************************************************************)


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Wwdbigrd, Wwdbgrid, StdCtrls, Mask, RzEdit, AdvOfficePager,
  AdvGlowButton, ExtCtrls, TFlatPanelUnit, Rotinas, DB, DBAccess, MyAccess,
  MemDS, DrdDataSet, RzButton, RzRadChk, RzSpnEdt, DBGrids, JvExDBGrids,
  JvDBGrid, RzTabs, AdvToolBar, AdvToolBarStylers;

type

  TFrmModCad = class(TForm)
    FlatPanel1: TFlatPanel;
    QryBusca: TDRDQuery;
    DSBusca: TMyDataSource;
    QryMaster: TDRDQuery;
    pnlCabecalho: TPanel;
    pnlTitulo: TPanel;
    imgTitulo: TImage;
    lblStatus: TLabel;
    lblPesquisa: TLabel;
    DBAdvGlowButton4: TDBAdvGlowButton;
    DBAdvGlowButton3: TDBAdvGlowButton;
    DBAdvGlowButton2: TDBAdvGlowButton;
    DBAdvGlowButton1: TDBAdvGlowButton;
    SpbBusca: TAdvGlowButton;
    SpbDelete: TAdvGlowButton;
    SpbEditar: TAdvGlowButton;
    SpbPrint: TAdvGlowButton;
    SpbLimpap: TAdvGlowButton;
    SpbCancelar: TAdvGlowButton;
    SpbSalvar: TAdvGlowButton;
    sbpMax: TAdvGlowButton;
    SpbSair: TAdvGlowButton;
    TabPages: TRzPageControl;
    TbShTela: TRzTabSheet;
    TbShTabela: TRzTabSheet;
    TblOcorrencia: TJvDBGrid;
    PnlCustomGrid: TPanel;
    lblFixColuna: TLabel;
    SpEdtFixCol: TRzSpinEdit;
    CbxSalvGrid: TRzCheckBox;
    CbxZebrado: TRzCheckBox;
    procedure SpbCancelarClick(Sender: TObject);
    procedure SpbLimpapClick(Sender: TObject);
    procedure SpbEditarClick(Sender: TObject);
    procedure SpbDeleteClick(Sender: TObject);
    procedure SpbPrintClick(Sender: TObject);
    procedure SpbBuscaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbpMaxClick(Sender: TObject);
    procedure SpbSairClick(Sender: TObject);
    procedure QryBuscaAfterOpen(DataSet: TDataSet);
    procedure QryBuscaAfterClose(DataSet: TDataSet);
    procedure QryBuscaAfterScroll(DataSet: TDataSet);
    procedure SpbSalvarClick(Sender: TObject);
  private
    { Private declarations }
    BSalvGrid: Boolean;
  public
    { Public declarations }
  end;

var
  FrmModCad: TFrmModCad;

implementation

uses
  uDM;

{$R *.dfm}

(*******************************************************************************
                     PARTE FIXA DO FORMULARIO
         Todo Código nesta parte é fixo, se alterado deve ser copiado
              para todos os forms q foram herdados por ele.

*******************************************************************************)

procedure TFrmModCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TFrmModCad.FormCreate(Sender: TObject);
begin
// Buscar imagens dos botoes no Main.
{    SpbBusca.Glyph        := FrmMain.SpbBusca.Glyph;
    spbLimpap.Glyph       := FrmMain.SpbLimpap.Glyph;
    SpbEditar.Glyph       := FrmMain.SpbEditar.Glyph;
    SpbSalvar.Glyph       := FrmMain.SpbSalvar.Glyph;
    SpbCancelar.Glyph     := FrmMain.SpbCancelar.Glyph;
    SpbDelete.Glyph       := FrmMain.SpbDelete.Glyph;
    SpbSair.Glyph         := FrmMain.SpbSair.Glyph;
    SpbPrint.Glyph        := FrmMain.SpbPrint.Glyph;
}
// Sempre alinha o form filho ao canto superior. - MDIForms
  if WindowState <> wsMaximized then
    SetBounds(0, 0, Width, Height);
    BSalvGrid           := False;

end;



procedure TFrmModCad.FormDestroy(Sender: TObject);
begin
   FrmDestroy(self);
end;

procedure TFrmModCad.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
// Rotina que controla as teclas de atalho pressionadas...
  case key of                                                 //F1   112
    122:if SpbBusca.Enabled     then SpbBusca.Click; //F11    //F2   113
    116:if SpbLimpap.Enabled    then SpbLimpap.Click;//F5     //F3   114
    113:if SpbEditar.Enabled    then SpbEditar.Click; //F2    //F4   115
    115:if SpbCancelar.Enabled  then SpbCancelar.Click;//F4   //F5   116
    114:if SpbSalvar.Enabled    then SpbSalvar.Click;//F3     //F6   117
    119:if SpbPrint.Enabled     then SpbPrint.Click;//F8      //F7   118
     46:if SpbDelete.Enabled    then SpbDelete.Click;         //F8   119
    120:if SpbSair.Enabled      then SpbSair.Click;//F9       //F9   120
 end;                                                        //F10   121
end;                                                         //F11   122

procedure TFrmModCad.FormShow(Sender: TObject);
begin
    TabPages.ActivePageIndex := 0;
    FrmCreate(self);
    FocoNoPrimeiro(Self);

end;

procedure TFrmModCad.QryBuscaAfterClose(DataSet: TDataSet);
begin
    lblPesquisa.Font.Color := clWindowText;
    lblStatus.Caption      := 'Inserir/Pesquisar';
    lblPesquisa.Caption    := 'Arthus Sistemas';
end;

procedure TFrmModCad.QryBuscaAfterOpen(DataSet: TDataSet);
begin 
  lblStatus.Caption    := 'Pesquisa Ativada';
  if QryBusca.RecordCount  = 1 then
  begin
    lblPesquisa.Caption := intZero(QryBusca.RecordCount, 2) + ' registro encontrado';
    lblPesquisa.Font.Color := clWindowText;
    end else
    begin
      lblPesquisa.Caption := intZero(QryBusca.RecordCount, 2) + ' registros encontrados';
      lblPesquisa.Font.Color := clRed;
  end;
end;

procedure TFrmModCad.QryBuscaAfterScroll(DataSet: TDataSet);
begin
  //
end;

procedure TFrmModCad.sbpMaxClick(Sender: TObject);
begin
  if WindowState = wsNormal then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TFrmModCad.SpbBuscaClick(Sender: TObject);
begin
  if SpbBusca.Visible = false then
     Abort;

end;

procedure TFrmModCad.SpbCancelarClick(Sender: TObject);
begin
// Ativa pagina Pesquisa
    TabPages.ActivePageIndex := 0;
// Desabilita todos os campos.
    DesabilitaCampos(Self);
// Move o foco para o primeiro objeto tag 1000 á 1500.
    lblStatus.Caption    := 'Pesquisa Ativa'; 
end;

procedure TFrmModCad.SpbDeleteClick(Sender: TObject);
begin
  if SpbDelete.Visible = false then
     Abort;
  //
end;

procedure TFrmModCad.SpbEditarClick(Sender: TObject);
begin
  if SpbEditar.Visible = false then
    Abort;
    TabPages.ActivePageIndex := 0;
// Habilita os campos que não são chaves tags [1000 á 1500]
    HabilitaCampos(self, True);
    FocoNoSegundo(self);
    lblStatus.Caption    := 'Modo Edição';
end;

procedure TFrmModCad.SpbLimpapClick(Sender: TObject);
begin
    TabPages.ActivePageIndex := 0;
    QryBusca.Close;
    Limpacampos(self);
    HabilitaCampos(Self, False);

end;

procedure TFrmModCad.SpbPrintClick(Sender: TObject);
begin
   if SpbPrint.Visible = false then
      Abort;
end;

procedure TFrmModCad.SpbSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmModCad.SpbSalvarClick(Sender: TObject);
begin
  if SpbSalvar.Visible = false then
     Abort;
  //
end;

end.
