unit uSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvShapeButton, RzPrgres, StdCtrls, ExeInfo, jpeg, RzLabel,
  pngimage, DateUtils, AdvReflectionLabel;

type
  TFrmSplash = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label1: TLabel;
    p: TRzProgressBar;
    Label3: TLabel;
    Label4: TLabel;
    Tempo: TTimer;
    Image2: TImage;
    ExeInfo1: TExeInfo;
    Img_Natal: TImage;
    lblVersao: TAdvReflectionLabel;
    lb_total: TRzLabel;
    procedure Button1Click(Sender: TObject);
    procedure TempoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;
  i : integer;

implementation

uses
  uMain, uDM;

{$R *.dfm}

procedure TFrmSplash.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFrmSplash.FormShow(Sender: TObject);
begin
 Img_Natal.Visible   := (MonthOf( Date ) = 12 );
 label2.caption      := ExeInfo1.fileVersion;
end;

procedure TFrmSplash.TempoTimer(Sender: TObject);
begin
  I := I + 5;
  P.percent := P.percent + 5;
  if (P.percent mod 5) = 0 then
  begin
    if label1.Font.Color  = clWHITE then
       label1.FoNT.Color := clGray
    else
      label1.Font.Color := clWHITE;
  end;
  if P.percent = 100 then
  begin
    label1.Caption      := 'SISTEMA CARREGADO COM SUCESSO!';
  end;
  if I = 120 then Close;
end;

end.
