unit uCadProfessores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uModCad, DB, DBAccess, MyAccess, MemDS, DrdDataSet, RzButton,
  RzRadChk, StdCtrls, Mask, RzEdit, RzSpnEdt, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, RzTabs, AdvGlowButton, ExtCtrls, TFlatPanelUnit, Rotinas;

    const
      _cChavePri  = 'COD_PROFESSORES';          // Chave primaria.
      _cBD        = 'TAB_PROFESSORES';          // Nome Tabela    

type
  TFrmCadProfessores = class(TFrmModCad)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure SpbLimpapClick(Sender: TObject);
    procedure SpbCancelarClick(Sender: TObject);
  private
    { Private declarations }
    FStateForm:TStateForm;
    procedure StateCheck(FState:TStateForm);
    property StateForm:TStateForm read FStateForm write StateCheck;      
  public
    { Public declarations }
  end;

var
  FrmCadProfessores: TFrmCadProfessores;

implementation

{$R *.dfm}

procedure TFrmCadProfessores.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
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

procedure TFrmCadProfessores.FormDestroy(Sender: TObject);
begin
  inherited;
  FrmCadProfessores:= nil;
end;

procedure TFrmCadProfessores.SpbCancelarClick(Sender: TObject);
begin
  StateForm  := sfBrowse;
  inherited;

end;

procedure TFrmCadProfessores.SpbLimpapClick(Sender: TObject);
begin
  StateForm := sfInsert;
  inherited;

end;

procedure TFrmCadProfessores.StateCheck(FState: TStateForm);
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

end.
