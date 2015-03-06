unit uCadAlunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uModCad, DB, DBAccess, MyAccess, MemDS, DrdDataSet, RzButton,
  RzRadChk, StdCtrls, Mask, RzEdit, RzSpnEdt, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, RzTabs, AdvGlowButton, ExtCtrls, TFlatPanelUnit, Rotinas;

    const
      _cChavePri  = 'COD_ALUNOS';          // Chave primaria.
      _cBD        = 'TAB_ALUNOS';          // Nome Tabela  

type
  TFrmCadAlunos = class(TFrmModCad)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure SpbEditarClick(Sender: TObject);
    procedure SpbCancelarClick(Sender: TObject);
    procedure SpbLimpapClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    BSalvGrid: Boolean;
    FStateForm:TStateForm;
    procedure StateCheck(FState:TStateForm);
    property StateForm:TStateForm read FStateForm write StateCheck;       
  public
    { Public declarations }
  end;

var
  FrmCadAlunos: TFrmCadAlunos;

implementation

{$R *.dfm}

procedure TFrmCadAlunos.FormShow(Sender: TObject);
begin
  StateForm := sfInsert;
  inherited;
  TabPages.ActivePageIndex := 0;
end;

procedure TFrmCadAlunos.SpbCancelarClick(Sender: TObject);
begin
  StateForm  := sfBrowse;
  inherited;

end;

procedure TFrmCadAlunos.SpbEditarClick(Sender: TObject);
begin
  StateForm := sfEdit;
  inherited;

end;

procedure TFrmCadAlunos.SpbLimpapClick(Sender: TObject);
begin
  StateForm := sfInsert;
  inherited;

end;

procedure TFrmCadAlunos.StateCheck(FState: TStateForm);
begin
// Rotina que controla o Estado dos botões...
    FStateForm            := FState;
    SpbBusca.Enabled      := FState in [sfInsert];
    SpbEditar.Enabled     := FState =  Sfbrowse;
    spbLimpap.Enabled     := FState in [sfInsert,sfBrowse];
    SpbSalvar.Enabled     := FState in [SfEdit,SfInsert];
    SpbCancelar.Enabled   := FState in [SfEdit];
    SpbDelete.Enabled     := FState =  sfBrowse;
  //  TabBusca.TabVisible   := FState in [sfBrowse,SfEdit];
    SpbPrint.Enabled      := FState =  sfBrowse;
  //  SpbBuscaRF.Enabled    := FsTate in [SfEdit,SfInsert];
end;

procedure TFrmCadAlunos.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
   if (StateForm in [SfEdit]) then
   begin
     Canclose := False;
      MessageDlg( 'Existe dados pendentes em "' + Caption + '".' + #13 +
              'Cancele ou Termine o Procedimento.' , mtInformation, [mbok], 0);
     end else
     Canclose := True;
end;

procedure TFrmCadAlunos.FormDestroy(Sender: TObject);
begin
  inherited;
  FrmCadAlunos:= nil;
end;

end.
