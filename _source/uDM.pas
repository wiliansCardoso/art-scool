unit uDM;

(*******************************************************************************
             ...::: ARTHUS SISTEMAS :::...

 Programadores......: Wilians Cardoso.

 Tester.............:
 Função do Módulo...: Data Modulo Global
 Data de Criação....: 26/02/2015 -- 14:30
 Observações........:
 26/02/2015 - WILL - Ajustes e inserçao de funçoes globais inicial.
 26/02/2015 - WILL - Inserçao de variaveis globais de tela de pesquisas.
 26/02/2015 - WILL - Criação da   proc/conectaBD().
*******************************************************************************)

interface

uses
  SysUtils, Classes, CheckCPF, ImgList, Controls, DB, DBAccess, MyAccess,
  Forms, MemData, Inifiles, Dialogs, windows, MemDS, DrdDataSet;

type
  TDmGlobal = class(TDataModule)
    MyConnecPai: TMyConnection;
    ImgGrids: TImageList;
    ImgListNovo: TImageList;
    CheckCPF1: TCheckCPF; 
    DRDQuery1: TDRDQuery;
    procedure MyConnecPaiConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure MyConnecPaiError(Sender: TObject; E: EDAError; var Fail: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ini_Config:Tinifile;
    procedure BeginTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;
    procedure RecriaSQLQry(var Qry: TDRDQuery);
    procedure LimpaSQLQry(var Qry: TDRDQuery);
    procedure CriaSQLQry(var Qry: TDRDQuery);      
  end;

var
  SerialHD,Senha_Arq:String;
  DmGlobal: TDmGlobal;

implementation

{$R *.dfm}

procedure TDmGlobal.MyConnecPaiConnectionLost(Sender: TObject;
  Component: TComponent; ConnLostCause: TConnLostCause;
  var RetryMode: TRetryMode);
begin
   Application.ProcessMessages;
   Application.MessageBox('O Servidor está fora do ar, aguarde alguns instantes e click em "OK" para tentar novamente.'
   ,'Erro',mb_ok+mb_iconwarning);
   RetryMode := rmReconnectExecute;
   Application.ProcessMessages;
end;

procedure TDmGlobal.MyConnecPaiError(Sender: TObject; E: EDAError;
  var Fail: Boolean);
begin
   if E.ErrorCode = 2003 then begin
    Fail := False;
    Application.MessageBox('Não foi possível conectar ao servidor, ' +#13+
    'aguarde alguns instantes, click em "OK" e tente novamente.'
    ,'Erro',mb_ok+mb_iconwarning);
   end else
    Fail := True;
end;

Procedure TDmGlobal.BeginTransaction;
begin
   MyConnecPai.ExecSQL( 'Start transaction;', []);

end;

Procedure TDmGlobal.RollBackTransaction;
begin
   MyConnecPai.ExecSQL( 'Rollback;', []);

end;

Procedure TDmGlobal.CommitTransaction;
begin
   MyConnecPai.ExecSQL( 'Commit;', []);

end;

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
//
end;

procedure TDmGlobal.RecriaSQLQry(var Qry: TDRDQuery);
begin
  Qry := nil;
  Qry.Free;
  Qry := TDRDQuery.Create(nil);
  Qry.Connection := MyConnecPai;
end;

procedure TDmGlobal.LimpaSQLQry(var Qry: TDRDQuery);
begin
  Qry := nil;
  Qry.Free;
end;

procedure TDmGlobal.CriaSQLQry(var Qry: TDRDQuery);
begin
  Qry := TDRDQuery.Create(nil);
  Qry.Connection := MyConnecPai;
end;


end.
