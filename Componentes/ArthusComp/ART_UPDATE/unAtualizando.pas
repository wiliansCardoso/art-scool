unit unAtualizando;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls;

type
  TfrmAtualizando = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMessage: string;
    procedure SetMax(const Value: integer);
    procedure SetPosition(const Value: integer);
    procedure SetMessage(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Max: integer write SetMax;
    property Position: integer write SetPosition;
    property Message: string read FMessage write SetMessage;
  end;

implementation

{$R *.dfm}

procedure TfrmAtualizando.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Caption := Application.Title;
end;

procedure TfrmAtualizando.FormDestroy(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmAtualizando.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TfrmAtualizando.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAtualizando.SetMax(const Value: integer);
begin
  //Gauge1.MaxValue := Value;
  ProgressBar1.Max := Value;
end;

procedure TfrmAtualizando.SetMessage(const Value: string);
begin
  FMessage := Value;
  Label1.Caption := FMessage;
  Application.ProcessMessages;
end;

procedure TfrmAtualizando.SetPosition(const Value: integer);
begin
  //Gauge1.Progress := Value;
  ProgressBar1.Position := Value;
  Application.ProcessMessages;
end;

end.
