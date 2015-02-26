unit MyDBGrid;

(*************************************************************************
  ----------------------------------------------------
  Autor.: Eduardo Silva dos Santos -- DRD SISTEMAS
  Data..: 10.04.2007
  e-mail: eduardo.drd@gmail.com
  ----------------------------------------------------


  Versão 1.02    14.08.2007
    - Adicionada a function GetClientRect: TRect; override; para redimensionar o desenho do rodapé.


  Versão 1.01    25.05.2007
    - Agora o TMyBDGrid  descende do TCRDBGrid da CoreLab
    - Adicionada a propriedade AutoFormatFloatFields, para formatar automaticamento campos float.
    - Adicionada a propriedade ColorOfSortedColumn, para definir a cor da coluna selecionada para ordenar os registros


  Versão 1.00    10.04.2007
    - Criado o TMyDBGrid descendente do TDBGrid.


****************************************************************************)

interface

uses
  Windows, Messages, Classes, Controls, Forms, Graphics, StdCtrls, SysUtils, Grids, DBGrids, ExtCtrls, FlatSB,
  CommCtrl,CRGrid, DB;

type
  TMyDBGrid = class(TCRDBGrid)
  private
    { Private declarations }
    FBorderColor: TColor;
    FFormatFloatFields: boolean;
    FFormatOfFloatFields: string;
    FColorOfSortedColumn:TColor;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure CMSysColorChange (var Message: TMessage);
    procedure CMParentColorChanged (var Message: TWMNoParams);
    procedure RedrawBorder (const Clip: HRGN);
    procedure KeyDown(var Key: Word;Shift: TShiftState); override;
    procedure TitleClick(Column: TColumn); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: integer;Column: TColumn; State: TGridDrawState); override;

  protected
    { Protected declarations }
    function GetClientRect: TRect; override;

  public
    { Public declarations }
    constructor Create (AOwner: TComponent); override;
    procedure Focar;

  published
    { Published declarations }
    Property BorderColor:TColor read FBorderColor write FBorderColor Default $008396A0;
    Property ColorOfSortedColumn:TColor read FColorOfSortedColumn write FColorOfSortedColumn Default $00CEFFFF;
    property FormatFloatFields: boolean read FFormatFloatFields write FFormatFloatFields default True;
    property FormatOfFloatFields: string read FFormatOfFloatFields write FFormatOfFloatFields;
    property OnKeyDown;
    property OnTitleClick;

  end;

procedure Register;


implementation



constructor TMyDBGrid.Create (AOwner: TComponent);
begin
   inherited Create(AOwner);
   Ctl3D        := False;
   ParentCtl3D  := False;
   FixedColor   := $00C5D6D9;
   FBorderColor := $008396A0;
   AutoSize     := False;
   ShowHint     := True;
   Options      := [dgTitles,dgColLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgCancelOnExit];
//   OptionsEx    := OptionsEx + [dgeEnableSort,dgeLocalFilter,dgeLocalSorting];
   ReadOnly     := True;
   FFormatFloatFields     := True;
   FColorOfSortedColumn   := $00CEFFFF;
   FFormatOfFloatFields   := '#,#0.00';

end;

procedure TMyDBGrid.WMNCPaint (var Message: TMessage);
begin
   inherited;
   RedrawBorder(HRGN(Message.WParam));

end;

function TMyDBGrid.GetClientRect: TRect;
begin
   Result := inherited GetClientRect;
   if dgRowLines in options then
    Inc(Result.Bottom);

   if [dgeSummary,dgeRecordCount] * OptionsEx <> [] then begin
    Result.Bottom := Result.Bottom + 18; //para suprimir a barra do rodapé desenhada no CRGRID.PAS
    Dec( Result.Bottom ,DefaultRowHeight );
   end;

end;

procedure TMyDBGrid.CMSysColorChange (var Message: TMessage);
begin
   RedrawBorder(0);

end;

procedure TMyDBGrid.KeyDown(var Key: Word;Shift: TShiftState);
begin
   if (Shift = [ssCtrl]) and (Key = 46) then  //Desativar o Ctrl + Delete
    Key := 0;
   inherited KeyDown(Key,Shift);

end;

procedure TMyDBGrid.CMParentColorChanged (var Message: TWMNoParams);
begin
   RedrawBorder(0);

end;

procedure TMyDBGrid.TitleClick(Column: TColumn);
var
 str     : String;
 nCount  : Integer;
begin
   try
     for nCount := 0 to Columns.Count - 1 do
      if Columns[ nCount ].FieldName <> Column.FieldName then
       if (Columns[ nCount ].Font.Color <> clRed) then begin
        Columns[ nCount ].Font.Color := clBlack;
        Columns[ nCount ].Color      := clWhite;
       end;

     if Column.Font.Color <> clRed then begin
      Column.Font.Color := clBlue;
      Column.Color      := FColorOfSortedColumn;
     end;

   except
     Columns[ 0 ].Font.Color := clBlue;
     if Column.Font.Color <> clRed then begin
      Column.Font.Color := clBlack;
      Column.Color      := clWhite;
     end;
   end;

   inherited TitleClick(Column);

end;

procedure TMyDBGrid.RedrawBorder (const Clip: HRGN);
var
  DC: HDC;
  R: TRect;
  BtnFaceBrush, WindowBrush, FocusBrush: HBRUSH;
begin
   DC := GetWindowDC(Handle);
   try
     GetWindowRect(Handle, R);
     OffsetRect( R, -R.Left, -R.Top);
     BtnFaceBrush    := CreateSolidBrush(ColorToRGB(FBorderColor));
     WindowBrush     := CreateSolidBrush(ColorToRGB( Color  ));
     FocusBrush      := CreateSolidBrush(ColorToRGB( Color  ));

     if (not(csDesigning in ComponentState) and (Focused or (not(Screen.ActiveControl is TMyDBGRID)))) then begin { Focus }
       FrameRect(DC, R, BtnFaceBrush);
       InflateRect(R, -1, -1);
       FrameRect(DC, R, FocusBrush);
       InflateRect(R, 0, 0);
       FrameRect(DC, R, FocusBrush);
       if ScrollBars = ssBoth then
         FillRect(DC, Rect(R.Right - 17, R.Bottom - 17, R.Right - 1, R.Bottom - 1), FocusBrush);

     end else begin { non Focus }
       FrameRect(DC, R, BtnFaceBrush);
       InflateRect(R, -1, -1);
       FrameRect(DC, R, WindowBrush);
       InflateRect( R, 0, 0);
       FrameRect(DC, R, WindowBrush);
       if ScrollBars = ssBoth then
         FillRect(DC, Rect(R.Right - 17, R.Bottom - 17, R.Right - 1, R.Bottom - 1), WindowBrush);
     end;

   finally
     ReleaseDC(Handle, DC);
   end;
   DeleteObject(WindowBrush);
   DeleteObject(BtnFaceBrush);
   DeleteObject(FocusBrush);
   
end;

procedure TMyDBGrid.DrawColumnCell(const Rect: TRect; DataCol: integer;Column: TColumn; State: TGridDrawState);
begin
   if Assigned( Column.Field ) then
    if (Column.Field.DataType in [ftFloat]) and FFormatFloatFields then
     TFloatField( Column.Field ).DisplayFormat := FFormatOfFloatFields;
   inherited;

end;

procedure TMyDBGrid.Focar;
begin
   if CanFocus then
    SetFocus;
    
end;

procedure Register;
begin
   RegisterComponents('ARTHUS', [TMyDBGrid]);

end;

end.
