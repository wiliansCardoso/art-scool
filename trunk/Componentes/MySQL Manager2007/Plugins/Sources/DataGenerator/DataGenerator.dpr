library DataGenerator;

uses
  SysUtils,
  Classes,
  MyIntf,
  Forms,
  Windows,
  PluginF in 'PluginF.pas' {PluginForm},
  ProgressF in 'ProgressF.pas' {fmProgressDlg},
  StrConsts in 'StrConsts.pas';

{$R *.RES}

var OldHandle: THandle;

procedure plugin_execute(ExecInfo: PplExecInfo; Intf: TMyManagerInterface); stdcall;
var PF : TPluginForm;
begin
  OldHandle := Application.Handle;
  Application.Handle := TApplication(Intf.MyManagerApplication).Handle;
  PF := TPluginForm.Create(TApplication(Intf.MyManagerApplication));
  try
    PF.Intf := Intf;
    PF.ShowModal;
  finally
    PF.Free;
  end;
  Application.Handle := OldHandle;
end;

procedure get_plugin_info(PluginInfo: pointer); stdcall;
begin
  with PMyManagerPluginInfo(PluginInfo)^ do begin
    PluginName := PChar(sDataGenerator);
    Description := PChar(sPluginDescription);
    MenuCaption := PChar('&' + sDataGenerator);
    PlaceOnToolbar := true;
    UnloadAfterExecute := true;
  end;
end;

procedure plugin_options_execute(Intf : TMyManagerInterface); stdcall;
begin
  //
end;

exports
  plugin_execute,
  get_plugin_info,
  plugin_options_execute;

end.
