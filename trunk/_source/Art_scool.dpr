program Art_scool;

uses
  Forms,
  Dialogs,
  Windows,
  Controls,
  SysUtils,
  Messages,
  Classes,
  uMain in 'uMain.pas' {FrmMain},
  uDM in 'uDM.pas' {DmGlobal: TDataModule},
  UnitDeclaracoes in 'UnitDeclaracoes.pas',
  crypto1 in 'crypto1.pas',
  Rotinas in 'Rotinas.pas',
  URichMenu in 'URichMenu.pas',
  uSplash in 'uSplash.pas' {FrmSplash};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ART_SCOOL';
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.MainFormOnTaskbar := True;
    Frmsplash.showmodal;
    Application.ProcessMessages;
    Application.Run ;
end.
