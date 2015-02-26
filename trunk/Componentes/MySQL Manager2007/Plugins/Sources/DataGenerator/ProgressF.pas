unit ProgressF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

const
  WM_QIMPORT_PROGRESS = WM_USER + 1;

  QIP_STATE = 1;
  QIP_ERROR = 2;
  QIP_IMPORT = 3;
  QIP_COMMIT = 4;
  QIP_FINISH = 5;
  QIP_ROWCOUNT = 6;

type

  TfmProgressDlg = class(TForm)
    buCancel: TButton;
    paInfo: TPanel;
    Bevel1: TBevel;
    prGenerator: TProgressBar;
    laGenerated: TLabel;
    Bevel2: TBevel;
    laGeneratedValue: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    laState: TLabel;
    laStateValue: TLabel;
    Bevel5: TBevel;
    laTime: TLabel;
    laTimeValue: TLabel;
    Bevel6: TBevel;
    Timer: TTimer;
    laPercent: TLabel;
    procedure buCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
  private
    FStopped: boolean;
    FTime: TDateTime;
    function GetRecordCount: integer;
    procedure SetRecordCount(const Value: integer);
    procedure SetValue(const Value: integer);
    function GetValue: integer;
    function GetDone: boolean;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartProgress;
    procedure StopProgress;
    property RecordCount: integer read GetRecordCount write SetRecordCount;
    property Stopped: boolean read FStopped;
    property Done: boolean read GetDone;
    property Value: integer read GetValue write SetValue;
  end;

var
  Fm: TfmProgressDlg;
  InProgress: boolean;

procedure ShowProgress(RecCount: integer);
procedure StopProgress;

implementation

uses StrConsts;

procedure ShowProgress(RecCount: integer);
begin
  if not InProgress then begin
    Fm := TfmProgressDlg.Create(Application);
    Fm.RecordCount := RecCount;
    Fm.StartProgress();
  end else
    Fm.BringToFront();
end;

procedure StopProgress;
begin
  if InProgress then Fm.Close();
end;

{$R *.DFM}

{ TfmProgressDlg }

function TfmProgressDlg.GetDone: boolean;
begin
  Result := prGenerator.Position = prGenerator.Max;
end;

function TfmProgressDlg.GetRecordCount: integer;
begin
  Result := prGenerator.Max;
end;

function TfmProgressDlg.GetValue: integer;
begin
  Result := prGenerator.Position;
end;

procedure TfmProgressDlg.SetRecordCount(const Value: integer);
begin
  prGenerator.Max := Value;
end;

procedure TfmProgressDlg.SetValue(const Value: integer);
begin
  prGenerator.Position := Value;
  laGeneratedValue.Caption := IntToStr(Value);
  laPercent.Caption := IntToStr((Value * 100) div prGenerator.Max) + ' %';
  if Done then begin
    Caption := sGenerated;
    laStateValue.Caption := sDone;
    buCancel.Caption := sClose;
    Timer.Enabled := False;
  end;
end;

procedure TfmProgressDlg.StartProgress;
begin
  Caption := sGenerating;
  laStateValue.Caption := sGenerating;
  Show();
  BringToFront();
  buCancel.Caption := sCancel;
  FTime := 0;
  laTimeValue.Caption := FormatDateTime('h:nn:ss', FTime);
  Timer.Enabled := True;
end;

procedure TfmProgressDlg.StopProgress;
begin
  Caption := sGenerated;
  laStateValue.Caption := sInterrupted;
  buCancel.Caption := sClose;
  FStopped := True;
  Timer.Enabled := False;
end;

procedure TfmProgressDlg.buCancelClick(Sender: TObject);
begin
  if not Done and not Stopped
    then StopProgress()
    else Close();
end;

procedure TfmProgressDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

constructor TfmProgressDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InProgress := True;
end;

destructor TfmProgressDlg.Destroy;
begin
  InProgress := False;
  inherited Destroy();
end;

procedure TfmProgressDlg.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if Assigned(Owner) and (Owner is TForm) then
    with Params do
    begin
      Style := Style or ws_Overlapped;
      WndParent := (Owner as TForm).Handle;
    end;
end;

procedure TfmProgressDlg.TimerTimer(Sender: TObject);
begin
  FTime := FTime + 0.00001;
  laTimeValue.Caption := FormatDateTime('h:nn:ss', FTime);
end;

initialization
  InProgress := False;
end.
