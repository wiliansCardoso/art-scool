unit Rotinas;


interface

uses
   Shellapi, Windows, SysUtils, Classes, Controls, Forms, Winsock, Dialogs, Graphics,
   MaskUtils, inifiles, Printers, TypInfo, Consts, Messages, CommDlg, StdCtrls, ExtActns,
   DateUtils, Math, ExtCtrls, Variants, Registry, DB, MyDACVcl, JvMemoryDataset,
   Menus, Buttons, JPEG, TLHelp32, Wwdbgrid, AdvOfficePager, JvDBLookup,
   PsAPI,  DBCtrls, RzCmboBx, JvToolEdit, RzSpnEdt,JvBaseEdits, Spin,
   WinHelpViewer, //Esse unit é necessária pq se a property HelpContext <> 0 e o user pressionar F1 gera uma exception por nao possuir help
   DrdDataSet, Mask, RzEdit, RzRadGrp, RzRadChk, Wwdbcomb, JvExControls,
   AdvMemo, AdvGroupBox, AdvOfficeButtons, AdvSpin, AdvPanel, RzButton, RzDTP,
   JvCombobox;
type
   Float       = Extended; // our type for float arithmetic
// Estado do form nas aplicaçoes.
   TStateForm  = ( sfEdit, sfInsert, sfBrowse, sfWait, sfFind );
// Estado do FormVenda.. (******* Atençao uso Apenas no form Venda *********)
   TStateFormV = ( vLivre, vAberto, vFechado, vVendendo, vRecebendo, vFind );


{$IFDEF Win32} //our type for integer functions, Int_ is ever 32 bit 
   Int_       = Integer;
{$ELSE}
   Int_       = Longint;
{$ENDIF}

const
  { Low floating point value }
   FLTZERO: Float = 0.00000001;
   ZERO = '0';
   BLANK = #32;

   function  Confirma(cMessage:String;yesno:integer = 0):boolean;
   Procedure Aviso( cMessage:String);
   procedure AlinhaMenuItemDireita(MMenu: TMainMenu; MenuItem: TMenuItem);
   function  sysColorDepth: Integer; { 06.08.96 sb }
   function  OS_MaiorQue256Cores: Boolean;
   procedure MontaSQLX(Tipo: char; var ValWhere: string; Campo: string; Valor,
             ValExit: variant; Condicao: string; Qry: TDRDQuery);
   function  MontaSQL(Tipo: char; var ValWhere: string; Campo: string; Valor:
             variant; Condicao: string): string;
   function  StringToSQLLike(Value: string): string;
   function  StringToSQLEqual(Value: string): string;
   function  IntegerToSQL(Value: LongInt): string;
   function  DateToSQL(Condicao: string; Value: TDateTime): string;
   function  strPos(const aSubstr, S: string; aOfs: Integer): Integer;
   function  SimNao(Verdadeiro: Boolean): char;
   function  SimNaoB(SN: String): Boolean;   
   function  SimNaoToSQL(Value: boolean): string;
   procedure LimpaCampos(FrmPai: Tform);
   procedure DesabilitaCampos(FrmPai: Tform);
   procedure habilitaCampos(FrmPai: Tform; Edicao: Boolean);
   procedure FocoNoPrimeiro(FrmPai: Tform);
   procedure FocoNoSegundo(FrmPai: Tform);   
   procedure FrmDestroy(FrmPai: Tform);
   procedure FrmCreate(FrmPai: Tform);   
//   Procedure FormWait(lShow:Boolean = true; Msg:String = ''; RedMsg:Boolean = False );
//   function  Janela( msg:string ; bt:Boolean = false ):Integer;
   function  FloatToSQL(Value: Extended): string;
   function  fltRound(P: Float; Decimals: Integer): Float;
   function  intPow(Base, Expo: Integer): Int_;
   function  intPow10(Exponent: Integer): Int_;
   function  fltEqualZero(P: Float): Boolean;
   function  FloatToSQL3(Value: Extended): string;
   function  DigitoCPF(const Identificacao: string): string;
   function  CheckCNPJ(xCNPJ: String):Boolean;

   Function  TrocaVirgulaPorPonto(Valor: String):String;    

   function  iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
   function  EPar(Numero: longInt): Boolean;
   function  GeraDigitoEAN(Cod: string; Num: word): string;
   function  ValidaEAN(Cod: string; Num: word; var CodEAN: string): Boolean;
   function  ValidaCGC(xCNPJ: string): Boolean;
   function  ValidaCPF(num: string): Boolean;


   function  SoNumero(Texto: string): string;
   function  IntZero(a: Int_; Len: Integer): string;
   function  strPadZeroL(const S: string; Len: Integer): string;
   function  strPadChL(const S: string; C: Char; Len: Integer): string;
   function  strTrim(const S: string): string;
   function  strTrimChR(const S: string; C: Char): string;
   function  strTrimChL(const S: string; C: Char): string;
   function  strMake(C: Char; Len: Integer): string;
   function  DelChars(const S: string; Chr: Char): string;
   function  FormataTipoCategoria(Tipo: Word): string;   
   function  StrZero(nValue, nLenght: Integer): String;
   function  GetComputerNameFunc : string;
   function  dateMonth(D: TDateTime): Integer;
   function  strPadChR(const S: string; C: Char; Len: Integer): string;
   function  GetEnvVarValue(const VarName: string): string;
   function IsInteger(TestaString: String) : boolean;
   procedure logNFe(situacao,codpar,tppar,nf,srnf,status,codLoja:Integer; recib,key,usr,motivo,protocolo,xml:string);


implementation

uses uDM;


//Proc para gravaçao no log de NFe..
procedure logNFe(situacao,codpar,tppar,nf,srnf,status,codLoja:Integer;
                           recib,key,usr,motivo,protocolo,xml:string);
var
  QryLogNfe: TDRDQuery;
begin
    DmGlobal.CriaSQLQry(QryLogNfe);
    with QryLogNfe do
    Try
      Close;
      SQL.Clear;
      SQL.Add('Insert Into tab_log_nfe  ');
      SQL.Add('(COD_PARCEIRO,TIPO_PARCEIRO,NUM_NF,NUM_SERIE_NF, ');
      SQL.Add('RECIBO,NUM_CHAVE_ACESSO,DTA_ALTERACAO,DTA_INCLUSAO,USUARIO, ');
      SQL.Add('COD_STATUS,MOTIVO,COD_LOJA,PROTOCOLO,SITUACAO,XML) ');
      SQL.Add(' Values ');
      SQL.Add('(:COD_PARCEIRO,:TIPO_PARCEIRO,:NUM_NF,:NUM_SERIE_NF, ');
      SQL.Add(':RECIBO,:NUM_CHAVE_ACESSO,:DTA_ALTERACAO,:DTA_INCLUSAO,:USUARIO, ');
      SQL.Add(':COD_STATUS,:MOTIVO,:COD_LOJA,:PROTOCOLO,:SITUACAO,:XML) ');
      Parambyname('COD_PARCEIRO'    ).AsInteger := codpar;
      Parambyname('TIPO_PARCEIRO'   ).AsInteger := tppar;
      Parambyname('NUM_NF'          ).AsInteger := nf;
      Parambyname('NUM_SERIE_NF'    ).AsInteger := srnf;
      Parambyname('RECIBO'          ).AsString  := recib;
      Parambyname('NUM_CHAVE_ACESSO').AsString  := key;
      Parambyname('DTA_ALTERACAO'   ).AsDate    := now;;
      Parambyname('DTA_INCLUSAO'    ).AsDate    := now;
      Parambyname('USUARIO'         ).AsString  := usr;
      Parambyname('COD_STATUS'      ).AsInteger := status;
      Parambyname('SITUACAO'        ).AsInteger := Situacao;
      Parambyname('MOTIVO'          ).AsString  := motivo;
      Parambyname('COD_LOJA'        ).AsInteger := codLoja;
      Parambyname('PROTOCOLO'       ).AsString  := protocolo;
      ParamByname('XML'             ).AsBlob    := xml;
      Execute;
  finally
    Close;
    DmGlobal.LimpaSQLQry(QryLogNfe);
  end;
end;



function IsInteger(TestaString: String) : boolean;
begin
  try
    StrToInt(TestaString);
  except
  On EConvertError do result := False;
  else
  result := True;
  end;
end;


function GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;


{Consiste CGC}

function ValidaCGC(xCNPJ: string): Boolean;
var
  d1, d4, xx, nCount, fator,
    resto, digito1, digito2: Integer;
  Check: string;
begin
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(xCNPJ) - 2 do
  begin
    if Pos(Copy(xCNPJ, nCount, 1), '/-.') = 0 then
    begin
      if xx < 5 then
      begin
        fator := 6 - xx;
      end
      else
      begin
        fator := 14 - xx;
      end;
      d1 := d1 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      if xx < 6 then
      begin
        fator := 7 - xx;
      end
      else
      begin
        fator := 15 - xx;
      end;
      d4 := d4 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - resto;
  end;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - resto;
  end;
  Check := IntToStr(Digito1) + IntToStr(Digito2);
  if Check <> copy(xCNPJ, succ(length(xCNPJ) - 2), 2) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

{Consiste CPF}

function ValidaCPF(num: string): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  try
    n1 := StrToInt(num[1]);
    n2 := StrToInt(num[2]);
    n3 := StrToInt(num[3]);
    n4 := StrToInt(num[4]);
    n5 := StrToInt(num[5]);
    n6 := StrToInt(num[6]);
    n7 := StrToInt(num[7]);
    n8 := StrToInt(num[8]);
    n9 := StrToInt(num[9]);
    d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9
      + n1 * 10;
    d1 := 11 - (d1 mod 11);
    if d1 >= 10 then
      d1 := 0;
    d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9
      + n2 * 10 + n1 * 11;
    d2 := 11 - (d2 mod 11);
    if d2 >= 10 then
      d2 := 0;
    calculado := inttostr(d1) + inttostr(d2);
    digitado := num[10] + num[11];
    if calculado = digitado then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

function strPadChR(const S: string; C: Char; Len: Integer): string;
begin
  Result := S;
  while Length(Result) < Len do
    Result := Result + C;
end;

//Pega nome do computador.
function GetComputerNameFunc : string;
var ipbuffer : string;
      nsize : dword;
begin
   nsize := 255;
   SetLength(ipbuffer,nsize);
   if GetComputerName(pchar(ipbuffer),nsize) then
      result := ipbuffer;
end;

//Insere zeros (clipper)
function StrZero(nValue, nLenght: Integer): String;
begin
  Result := IntToStr(nValue);
  while Length(Result) < nLenght do
    Result := '0' + Result;

end;

//Exibe uma tela de Confirmação
function Confirma(cMessage:String; yesno:integer = 0):boolean;
begin
   Result := MessageDlg( 'Confirmação: ' + cMessage, mtConfirmation, [mbyes, mbno], 0 ) = MrYes;

end;

//Exibe uma tela de Aviso
Procedure Aviso( cMessage:String);
begin
   MessageDlg( 'Aviso: ' + cMessage, mtInformation, [mbok],0);

end;

Function TrocaVirgulaPorPonto(Valor: String):String;
Var i : Integer;
Begin
  If Valor <> '' Then
  Begin
     For i := 0 To Length(Valor) Do
     Begin
        If Valor[i] = '.' Then
        Begin              Valor[i]:= ',';
     End
    Else
  If Valor[i] = ',' Then
  Begin
     Valor[i] := '.';
  End;
 End;
     Result := Valor;
 End;
End;

function dateMonth(D: TDateTime): Integer;
var
  Year, Month, Day: Word;
begin
  DecodeDate(D, Year, Month, Day);
  Result := Month;
end;

procedure AlinhaMenuItemDireita(MMenu: TMainMenu; MenuItem: TMenuItem);
var
  mii: TMenuItemInfo;
  MainMenu: hMenu;
  Buffer: array[0..79] of Char;
begin
  MainMenu := MMenu.Handle;
  mii.cbSize := SizeOf(mii);
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer);
  GetMenuItemInfo(MainMenu, MenuItem.Command, False, mii);
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  SetMenuItemInfo(MainMenu, MenuItem.Command, False, mii);
end;


function OS_MaiorQue256Cores: Boolean;
var
  QtdeCores: Integer;
begin
  QtdeCores := sysColorDepth;

  Result := (QtdeCores > 256) or (QtdeCores = 1);
    
end;

function sysColorDepth: Integer;
var
  aDC: hDC;
begin
  aDC := 0;
  try
    aDC := GetDC(0);
    Result := 1 shl (GetDeviceCaps(aDC, PLANES) * GetDeviceCaps(aDC,
      BITSPIXEL));
  finally
    ReleaseDC(0, aDC);
  end;
end;

function MontaSQL(Tipo: char; var ValWhere: string; Campo: string; Valor:
  variant; Condicao: string): string;
begin
(* Legenda de Tipos:               |  Condicao:
   C = Caracter                    |    L : Like
   N = Númerico                    |    = : Igual
   D = Data                        |    > : Maior
   I = Inteiro                     |    < : Menor
   B = Boolean                     |   <= : Menor e igual
   E = Extended (03 casas)         |   >= : Maior e igual
*)
  if strPos(';', Valor, 1) > 0 then
  begin
    MessageDlg('A pesquisa não pode ter caracter "ponto e vírgula".', mtInformation, [mbok], 0);
    Abort;
  end;
  if strPos('''', Valor, 1) > 0 then
  begin
    MessageDlg('A pesquisa não pode ter caracter "aspas simples".', mtInformation, [mbok], 0);
    Abort;
  end;

  if strPos('%', Valor, 2) > 1 then
  begin
  MessageDlg('A pesquisa não pode ter identificador ''%'' entre caracteres.', mtInformation, [mbok], 0);
    Abort;
  end;

  if ValWhere = '' then
    Result := ' WHERE '
  else
    Result := ' AND ';
  case Tipo of
    'D': Result := Result + Campo + DateToSQL(Condicao, Valor);
    'C': if Condicao = 'L' then
         Result := Result + Campo + StringToSQLLike(Valor)
      else
         Result := Result + Campo + StringToSQLEqual(Valor);
    'I': Result := Result + Campo + IntegerToSQL(Valor);
    'N': Result := Result + Campo + FloatToSQL(Valor);
//    'E': Result := Result + Campo + FloatToSQL3(Valor);
    'B': Result := Result + Campo + SimNaoToSQL(Valor);
//    'U': Result := Result + Campo + ' IS NULL ';
  end;
  //
  ValWhere := Result;
end;

procedure MontaSQLX(Tipo: char; var ValWhere: string; Campo: string; Valor,
  ValExit: variant; Condicao: string; Qry: TDRDQuery);
begin
(* Legenda de Tipos:           |  Condicao:
   C = Caracter                |    L : Like
   N = Númerico                |    = : Igual
   D = Data                    |    > : Maior
   I = Inteiro                 |    < : Menor
   B = Boolean                 |   <= : Menor e igual
   E = Extended (03 casas)     |   >= : Maior e igual
                                   IN : Dentro
*)
  if Valor = ValExit then
    Exit;

  if strPos(';', Valor, 1) > 0 then
  begin
    MessageDlg('Não permitido caracter "ponto e vírgula" na pesquisa.',
      mtWarning, [mbOk], 0);
    Abort;
  end;
  if strPos('''', Valor, 1) > 0 then
  begin
    MessageDlg('Não permitido caracter "aspas simples" na pesquisa.', mtWarning,
      [mbOk], 0);
    Abort;
  end;

  if strPos('%', Valor, 2) > 1 then
  begin
    MessageDlg('Não permitido identificador ''%'' entre caracteres.', mtWarning,
      [mbOk], 0);
    Abort;
  end;
  //
  if ValWhere = '' then
    ValWhere := ' WHERE '
  else
    ValWhere := ' AND ';
  case Tipo of
    'D': ValWhere := ValWhere + Campo + DateToSQL(Condicao, Valor);
    'C': if Condicao = 'L' then
        ValWhere := ValWhere + Campo + StringToSQLLike(Valor)
      else
        ValWhere := ValWhere + Campo + StringToSQLEqual(Valor);
    'I': ValWhere := ValWhere + Campo + IntegerToSQL(Valor);
    'N': ValWhere := ValWhere + Campo + FloatToSQL(Valor);
    'E': ValWhere := ValWhere + Campo + FloatToSQL3(Valor);
    'B': if Condicao = 'IN' then
        ValWhere := ValWhere + Campo + ' IN (' + QuotedStr('S') + ',' +
          QuotedStr('N') + ')'
      else
        ValWhere := ValWhere + Campo + SimNaoToSQL(Valor);
    //'B': ValWhere := ValWhere + Campo + SimNaoToSQL(Valor);
//    'U': ValWhere := ValWhere + Campo + ' IS NULL ';
  end;
  //
  Qry.SQL.Add(ValWhere);
end;

function FloatToSQL3(Value: Extended): string;
begin
  DecimalSeparator := '.';
  Result := ' = ' + FormatFloat('0.00#', fltRound(Value, 3));
  DecimalSeparator := ',';
end;

function StringToSQLLike(Value: string): string;
begin
  if (Value[1] = '%') then
    Result := ' LIKE ''' + Value + '%'''
  else
  begin
      Result := ' LIKE ''' + Value + '%''';
  end;

end;

function FltRound(P: Float; Decimals: Integer): Float;
var
  Factor: LongInt;
  Help: Float;
begin
  Factor := IntPow10(Decimals);
  if P < 0 then
    Help := -0.5
  else
    Help := 0.5;
  Result := Int(P * Factor + Help) / Factor;
  if fltEqualZero(Result) then
    Result := 0.00;
end;

function IntPow(Base, Expo: Integer): Int_;
var
  Loop: Word;
begin
  Result := 1;
  for Loop := 1 to Expo do
    Result := Result * Base;
end;

function IntPow10(Exponent: Integer): Int_;
begin
  Result := IntPow(10, Exponent);
end;

function FltEqualZero(P: Float): Boolean;
begin
  Result := (P >= -FLTZERO) and (P <= FLTZERO); { 29.10.96 wmc }
end;

function DateToSQL(Condicao: string; Value: TDateTime): string;
begin                                                   { 01/08/2008  wmc}
  Result := ' ' + Condicao + ' ' + '''' + FormatDateTime('yyyy/mm/dd', Value) +
    '''';
end;

function StringToSQLEqual(Value: string): string;
begin
  Result := ' = ''' + Value + '''';
end;

function IntegerToSQL(Value: LongInt): string;
begin
  Result := ' = ' + IntToStr(Value);
end;

function FloatToSQL(Value: Extended): string;
begin
  DecimalSeparator := '.';
  Result := ' = ' + FormatFloat('0.00', fltRound(Value, 2));
  DecimalSeparator := ',';
end;

function strPos(const aSubstr, S: string; aOfs: Integer): Integer;
begin
  Result := Pos(aSubStr, Copy(S, aOfs, (Length(S) - aOfs) + 1));
  if (Result > 0) and (aOfs > 1) then
    Inc(Result, aOfs - 1);
end;

function SimNaoToSQL(Value: boolean): string;
begin
  Result := ' = ''' + SimNao(Value) + '''';
end;

function SimNao(Verdadeiro: Boolean): char;
begin
  if Verdadeiro then
    Result := 'S'
  else
    Result := 'N';
end;

function SimNaoB(SN: String): Boolean;
begin
  if SN = 'S' then
    result := True;
  if SN = 'N' then
    result := False;
end;

function IntZero(a: Int_; Len: Integer): string;
begin
  Result := strPadZeroL(IntToStr(a), Len);
end;

function strPadZeroL(const S: string; Len: Integer): string;
begin
  Result := strPadChL(strTrim(S), ZERO, Len);
end;

function strPadChL(const S: string; C: Char; Len: Integer): string;
begin
  Result := S;
  while Length(Result) < Len do
    Result := C + Result;
end;

function strTrim(const S: string): string;
begin
  Result := StrTrimChR(StrTrimChL(S, BLANK), BLANK);
end;

function strTrimChL(const S: string; C: Char): string;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[1] = C) do
    Delete(Result, 1, 1);
end;

function strTrimChR(const S: string; C: Char): string;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[Length(Result)] = C) do
    Delete(Result, Length(Result), 1);
end;

function strMake(C: Char; Len: Integer): string;
begin
  Result := strPadChL('', C, Len);
end;

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
  begin
    if Result[I] = Chr then
      Delete(Result, I, 1);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Função:
//    limpaCampos
// Objetivo:
//    Limpar os campos dos formularios
// Parâmetro:
//    não há, usa se Limpacampos(self)
// Retorno:
//
////////////////////////////////////////////////////////////////////////////////
procedure LimpaCampos(FrmPai: Tform);
var
  X: Integer;
begin
  with FrmPai do
    for X := 0 to ComponentCount - 1 do
      begin
      if Components[X] is TAdvOfficePager then //Leva as pages para primeira pagina.
         TAdvOfficePager(Components[X]).ActivePageIndex :=0;
{ Edits.. }
     if Components[X] is TMaskEdit then TMaskEdit(Components[X]).Text := '';
     if Components[X] is TEdit then TEdit(Components[X]).Clear;
     if TComponent(Components[x]).Tag <> 8100 then
       if Components[X] is TRzNumericEdit then TRzNumericEdit(Components[X]).Value := 0;
     if TComponent(Components[x]).Tag <> 8200 then
       if Components[X] is TRzEdit then TRzEdit(Components[X]).Text := '';
     if Components[X] is TRzMaskEdit then TRzMaskEdit(Components[X]).Text := '';
     if Components[X] is TRzDateTimeEdit then TRzDateTimeEdit(Components[X]).Text := '';
     if Components[X] is TAdvSpinEdit then TAdvSpinEdit(Components[X]).Value := 0;
     if Components[X] is TRzSpinEdit then TRzSpinEdit(Components[X]).Value := 0;
     if Components[X] is TSpinEdit then if TSpinEdit(Components[X]).Tag <> 1001 then TSpinEdit(Components[X]).Value := 0;
     if Components[X] is TJvCalcEdit then TJvCalcEdit(Components[X]).Value := 0;
    // if Components[X] is TRxCalcEdit then TRxCalcEdit(Components[X]).Value :=0;
     
{Combos..}
	   if Components[X] is TJvComboBox then TJvComboBox(Components[X]).Text := 'Nenhum';
	   if Components[X] is TComboBox then TComboBox(Components[X]).ItemIndex := 0;
	   if Components[X] is TRzComboBox then TRzComboBox(Components[X]).Text := '';
	   if Components[X] is TJvComboEdit then TJvComboEdit(Components[X]).Text  := '';
     if Components[X] is TWwdbcomboBox then TWwdbcomboBox(Components[X]).Value :=  '';
//     if Components[X] is TJvDBLookupCombo then TJvDBLookupCombo(Components[X]).Value :=
//                         TJvDBLookupCombo(Components[X]).EmptyValue;
{radios..}
     if Components[X] is TRadioGroup then TRadioGroup(Components[X]).ItemIndex := -1;
     if Components[X] is TRzRadioGroup then TRzRadioGroup(Components[X]).ItemIndex := -1;
     if Components[X] is TAdvOfficeRadioGroup then TAdvOfficeRadioGroup(Components[X]).ItemIndex := -1;
{Checkeds..}
     if Components[X] is TCheckBox then TCheckBox(Components[X]).Checked := False;
     if Components[X] is TRzCheckBox then TRzCheckBox(Components[X]).Checked := False;
     if Components[X] is TAdvOfficeRadioButton then TAdvOfficeRadioButton(Components[X]).Checked := False;
     if Components[X] is TRzCheckBox then TRzCheckBox(Components[X]).Checked := False;

{Datas..}
{ WIlians - 15/05/2010 **** tratamento para Datas que nao podem ser limpas****}
{ Wilians - 21/05/2010 **** tratamento para Cheks que nao podem ser limpos****}
   if TComponent(Components[x]).Tag <> 7600 then
    begin
//***********DATAS
      if TComponent(Components[x]).Tag <> 7500 then
        if Components[X] is TJvDateEdit then TJvDateEdit(Components[X]).Date := 0.0;

      if TComponent(Components[x]).Tag <> 7500 then
        if Components[X] is TRzDateTimeEdit then TRzDateTimeEdit(Components[X]).Clear;
    end;
//***********
      if TComponent(Components[x]).Tag <> 1150 then
        if Components[X] is TJvDBLookupCombo then TJvDBLookupCombo(Components[X]).Value :=
                            TJvDBLookupCombo(Components[X]).EmptyValue;

      if TComponent(Components[x]).Tag <> 6500 then
        if Components[X] is TAdvOfficeCheckBox then TAdvOfficeCheckBox(Components[X]).Checked:= True;

      if TComponent(Components[x]).Tag = 0 then
        if Components[X] is TAdvOfficeCheckBox then TAdvOfficeCheckBox(Components[X]).Checked := False;
//***********CHECKS
{Memos}
        if Components[X] is TMemo then TMemo(Components[X]).Text := '';
        if Components[X] is TAdvMemo then TAdvMemo(Components[X]).Lines.Clear;
    end;

end;

////////////////////////////////////////////////////////////////////////////////
// Função:
//    DesabilitaCampos
// Objetivo:
//    Desabilita os campos dos formularios
// Parâmetro:
//    não há, usa se DesabilitaCampos(self)
// Retorno:
//
////////////////////////////////////////////////////////////////////////////////
procedure DesabilitaCampos(FrmPai: Tform);
var
  X: Integer;
begin
  with FrmPai do
    for X := 0 to ComponentCount - 1 do
      begin
{ Edits.. }
        if Components[X] is TEdit then TEdit(Components[X]).Readonly  := True;
        if Components[X] is TMaskEdit then TMaskEdit(Components[X]).Readonly := True;
        if Components[X] is TRzNumericEdit then TRzNumericEdit(Components[X]).ReadOnly := True;

        if Components[X] is TRzMaskEdit then TRzMaskEdit(Components[X]).ReadOnly := True;
        if Components[X] is TrzDateTimeEdit then TrzDateTimeEdit(Components[X]).Readonly := True;
        if TComponent(Components[x]).Tag <> 6500 then        
        if Components[X] is TJvDateEdit then TJvDateEdit(Components[X]).ReadOnly:= True;
        if Components[X] is TAdvSpinEdit then TAdvSpinEdit(Components[X]).ReadOnly := True;
        if Components[X] is TRzSpinEdit then TRzSpinEdit(Components[X]).ReadOnly := True;
        if Components[X] is TSpinEdit then TSpinEdit(Components[X]).ReadOnly := True;
        if Components[X] is TJvCalcEdit then TJvCalcEdit(Components[X]).ReadOnly := True;
      //  if Components[X] is TRxCalcEdit then TRxCalcEdit(Components[X]).ReadOnly := True;
{Grids}
        if Components[X] is TwwDBGrid then TwwDBGrid(Components[X]).ReadOnly := True;
{Datas}
        if Components[X] is TRzDateTimePicker then TRzDateTimePicker(Components[X]).Enabled := False;
{Combos..}
	    if Components[X] is TJvComboBox then TJvComboBox(Components[X]).Enabled  := False;
	    if Components[X] is TRzComboBox then TRzComboBox(Components[X]).Enabled  := False;
	    if Components[X] is TComboBox then TComboBox(Components[X]).Enabled  := False;
	    if Components[X] is TRzComboBox then TRzComboBox(Components[X]).Enabled  := False;
      if Components[X] is TJvDBLookupCombo then TJvDBLookupCombo(Components[X]).Enabled := False;
{radios..}
      if Components[X] is TRadioGroup then TRadioGroup(Components[X]).Enabled := False;
      if Components[X] is TRzRadioGroup then TRzRadioGroup(Components[X]).Enabled := False;
      if Components[X] is TRzCheckGroup then TRzCheckGroup(Components[X]).Enabled := False;
      if Components[X] is TAdvOfficeRadioGroup then TAdvOfficeRadioGroup(Components[X]).Enabled := False;
      if Components[X] is TAdvOfficeRadioButton then TAdvOfficeRadioButton(Components[X]).Enabled := False;
{Checkeds..}
{ **** tratamento para check das paginas de consulta ****}
      if TComponent(Components[x]).Tag <> 6500 then begin
      if Components[X] is TAdvOfficeCheckBox then TAdvOfficeCheckBox(Components[X]).Enabled := False;end;
      if Components[X] is TCheckBox then TCheckBox(Components[X]).Enabled := False;
      if Components[X] is TRzCheckBox then TRzCheckBox(Components[X]).Enabled := False;
{Memos}
      if Components[X] is TMemo then TMemo(Components[X]).Readonly := True;
      if Components[X] is TAdvMemo then TAdvMemo(Components[X]).Readonly := True;
//Arima - 14/03/2011
{Panels}
      if Components[X] is TAdvPanel then begin
        if (TComponent(Components[X]).Tag = 1000) then
           TAdvPanel(Components[X]).Enabled := False;
      end;
      if Components[X] is TRzEdit then begin
        if (TComponent(Components[X]).Tag <> 2020) then
        TRzEdit(Components[X]).ReadOnly := True;
      end;


    end;
end;

////////////////////////////////////////////////////////////////////////////////
// Função:
//    habilitaCampos
// Objetivo:
//    habilita os campos dos formularios
// Parâmetro:
//    usa se HabilitaCampos(self, True)
//    onde true para travar chaves primarias nas ediçoes
//    e false para nao travar.
// Retorno:
//
////////////////////////////////////////////////////////////////////////////////
procedure habilitaCampos(FrmPai: Tform; Edicao: Boolean);
var
  X: Integer;
begin
  with FrmPai do
    for X := 0 to ComponentCount - 1 do
    begin
{ Edits.. }
    if Components[X] is TEdit           then TEdit(Components[X]).Readonly:= False;
    if Components[X] is TRzNumericEdit  then TRzNumericEdit(Components[X]).Readonly := False;
    if Components[X] is TMaskEdit       then TMaskEdit(Components[X]).Readonly := False;
    if Components[X] is TMaskEdit       then TMaskEdit(Components[X]).Readonly := False;
    if Components[X] is TRzEdit         then TRzEdit(Components[X]).Readonly  := False;
    if Components[X] is TRzMaskEdit     then TRzMaskEdit(Components[X]).Readonly := False;
    if Components[X] is TrzDateTimeEdit then TrzDateTimeEdit(Components[X]).Readonly := False;
    if Components[X] is TJvDateEdit     then TJvDateEdit(Components[X]).ReadOnly := False;
    if Components[X] is TAdvSpinEdit    then TAdvSpinEdit(Components[X]).ReadOnly := False;
    if Components[X] is TRzSpinEdit     then TRzSpinEdit(Components[X]).ReadOnly := False;
    if Components[X] is TSpinEdit       then TSpinEdit(Components[X]).ReadOnly := False;
    if Components[X] is TJvCalcEdit     then TJvCalcEdit(Components[X]).ReadOnly := False;
   // if Components[X] is TRxCalcEdit     then TRxCalcEdit(Components[X]).ReadOnly := False;

{Grids}
    if Components[X] is TwwDBGrid    then TwwDBGrid(Components[X]).ReadOnly := False;
{Datas}
    if Components[X] is TRzDateTimePicker then TRzDateTimePicker(Components[X]).Enabled := True;
{Combos..}
    if Components[X] is TJvComboBox then TJvComboBox(Components[X]).Enabled  := True;
	  if Components[X] is TRzComboBox  then TRzComboBox(Components[X]).Enabled := True;
   	if Components[X] is TComboBox    then TComboBox(Components[X]).Enabled := True;
   	if Components[X] is TRzComboBox  then TRzComboBox(Components[X]).Enabled := True;
    if TComponent(Components[x]).Tag <> 1150 then
    if Components[X] is TJvDBLookupCombo then TJvDBLookupCombo(Components[X]).Enabled := True;
//        if Components[X] is TJvComboBox then
//          TJvComboBox(Components[X]).Enabled           := True;
//	    if Components[X] is TJvComboBox then
//         TJvComboBox(Components[X]).Enabled            := True;

{radios..}
    if Components[X] is TRadioGroup then TRadioGroup(Components[X]).Enabled  := True;
    if Components[X] is TRzRadioGroup then TRzRadioGroup(Components[X]).Enabled := True;
    if Components[X] is TRzCheckGroup then TRzCheckGroup(Components[X]).Enabled := True;
    if Components[X] is TAdvOfficeRadioGroup then TAdvOfficeRadioGroup(Components[X]).Enabled := True;
    if Components[X] is TAdvOfficeRadioButton then TAdvOfficeRadioButton(Components[X]).Enabled := True;
{Checkeds..}
{WIlians - 04/06/2010
  **** tratamento para check das paginas de consulta ****}
    if TComponent(Components[x]).Tag <> 6500 then
    begin
      if Components[X] is TCheckBox then TCheckBox(Components[X]).Enabled  := True;
      if Components[X] is TAdvOfficeCheckBox then TAdvOfficeCheckBox(Components[X]).Enabled := True;
      if Components[X] is TRzCheckBox then TRzCheckBox(Components[X]).Enabled := True;

{Datas}
{ WIlians - 15/05/2010
 **** tratamento para Datas que nao podem ser Editadas****}
      if TComponent(Components[x]).Tag <> 7500 then
//        if Components[X] is TJvDateEdit then
//           TJvDateEdit(Components[X]).Readonly     := False;
{ WIlians - 23/07/2010
 **** tratamento para Edits do JVcalc que nao podem ser Editadas****}
//      if TComponent(Components[x]).Tag = 7500 then
//        if Components[X] is TJvCalcEdit then
//          TJvCalcEdit(Components[X]).Readonly          := true;
{Memos}
      if Components[X] is TMemo then TMemo(Components[X]).Readonly := False;
      if Components[X] is TAdvMemo then TAdvMemo(Components[X]).Readonly := False;
//Arima - 14/03/2011
{Panels}
      if Components[X] is TAdvPanel then begin
        if (TComponent(Components[X]).Tag = 1000) then TAdvPanel(Components[X]).Enabled := True;
      end;

      if edicao then begin
{Trata as chaves primarias com tag 1000 á 1500}
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TEdit then TEdit(Components[X]).Readonly := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TrZEdit then TrZEdit(Components[X]).Readonly := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TMaskEdit then TMaskEdit(Components[X]).Readonly := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TRzNumericEdit then TRzNumericEdit(Components[X]).Readonly := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TRzMaskEdit then TRzMaskEdit(Components[X]).Readonly := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TJvDBLookupCombo then TJvDBLookupCombo(Components[X]).Enabled     := False;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TJvCalcEdit then TJvCalcEdit(Components[X]).Readonly     := True;
      if (TComponent(Components[X]).Tag >= 1000) and (TComponent(Components[X]).Tag <= 1500) then
       if Components[X] is TEdit then TEdit(Components[X]).Readonly     := True;
      end;
{      if (TComponent(Components[X]).Tag >= 1000) and
        (TComponent(Components[X]).Tag <= 1500) then
          if Components[X] is TEdit then TEdit(Components[X]).Readonly     := True;
      if (TComponent(Components[X]).Tag >= 1000) and
        (TComponent(Components[X]).Tag <= 1500) then
          if Components[X] is TRzNumericEdit then TRzNumericEdit(Components[X]).Readonly := True;
     }
    end;
  end;
end;

//POEM EM FOCO NO PRIMEIRO OBJETO.
procedure FocoNoPrimeiro(FrmPai: Tform);
var
  X,PrimObj: Integer;
begin
  PrimObj := 1000;
  with FrmPai do
  try
    for X := 0 to ComponentCount - 1 do
      if TComponent(Components[X]).Tag = PrimObj then
      begin
        if Components[X] is TEdit then
//          if TEdit(Components[X]).Readonly then
             TEdit(Components[X]).SelectAll
          else
             FocoNoSegundo(FrmPai);  //Inc(PrimObj)

        if Components[X] is TRzNumericEdit then
//          if TRzNumericEdit(Components[X]).Readonly then
             TRzNumericEdit(Components[X]).SelectAll
          else
             FocoNoSegundo(FrmPai); //Inc(PrimObj)

        if Components[X] is TRzMaskEdit then
//          if TRzMaskEdit(Components[X]).Readonly then
             TRzMaskEdit(Components[X]).SelectAll
          else
             FocoNoSegundo(FrmPai); //Inc(PrimObj)

         end;
     except
    Exit;
  end;

end;

//POEM EM FOCO NO SEGUNDO OBJETO.
procedure FocoNoSegundo(FrmPai: Tform);
var
  X,SegObj: Integer;
begin
  SegObj := 3001;
  with FrmPai do
  try
    for X := 0 to ComponentCount - 1 do
      if TComponent(Components[X]).Tag = SegObj then
      begin
        if Components[X] is TEdit then
          if TEdit(Components[X]).Readonly then
             TEdit(Components[X]).SelectAll
          else
             Inc(SegObj);

        if Components[X] is TRzMaskEdit then
//          if TRzMaskEdit(Components[X]).Readonly then
             TRzMaskEdit(Components[X]).SelectAll
          else
             Inc(SegObj);

        if Components[X] is TRzNumericEdit then
          if TRzNumericEdit(Components[X]).Readonly then
             Inc(SegObj)
          else
             TRzNumericEdit(Components[X]).SelectAll;

//        if Components[X] is TNumBerEdit then
//          if TNumBerEdit(Components[X]).Readonly then
 //            Inc(SegObj)
 //         else
 //            TNumBerEdit(Components[X]).SelectAll;

         end;
     except
    Exit;
  end;
end;

// FECHA QUERYS DO FORM.
procedure FrmDestroy(FrmPai: Tform);
var
  i: Integer;
begin
  with FrmPai do
    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TDRDQuery) then
         (Components[i] as TDRDQuery).Close;

      if (Components[i] is TJvMemoryData) then
         (Components[i] as TJvMemoryData).Close;

    end;
end;

// ABRE QUERYS DO FORM.
procedure FrmCreate(FrmPai: Tform);
var
  i: Integer;
begin
  with FrmPai do
    for i := 0 to ComponentCount - 1 do
    begin
      if TComponent(Components[i]).Tag = 5000 then
      begin
      if (Components[i] is TDRDQuery) then
         (Components[i] as TDRDQuery).Open;

      if (Components[i] is TJvMemoryData) then
         (Components[i] as TJvMemoryData).Open;

    end;
    end;
end;

function FormataTipoCategoria(Tipo: Word): string;
begin
  case Tipo of
    0: Result := '+';
    1: Result := '-';
    2: Result := '±';
  end;
end;

//FUNCAO IIF (CLLIPER)
function iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
begin
  if Condicao then
    Result := Verdadeiro
  else
    Result := falso;
end;

{

// MONTA JANELA PADRAO
function Janela( msg:string ; bt:Boolean = false ):Integer;
begin
     FrmMsg := TFrmMsg.Create(Application);
     FrmMsg.LblMsg.Caption := msg;
  if bt then begin
     FrmMsg.BT2.Visible         := true;
     FrmMsg.ImgConfirma.Visible := true;
     FrmMsg.LblTitulo.Caption   := 'Confirmação';
  end;
  if not bt then begin
     FrmMsg.BT1.Visible         := true;
     FrmMsg.ImgAviso.Visible    := true;
     FrmMsg.LblTitulo.Caption   := 'Aviso';
   end;
     FrmMsg.Refresh;
     result := FrmMsg.ShowModal;
end;

// MONTA JANELA FORMWAIT (janela de espera ).
Procedure FormWait(lShow:Boolean = true; Msg:String = ''; RedMsg:Boolean = False );
begin
   try
    if lShow then begin
     if Application.FindComponent( 'FrmWait' ) = nil then
        Application.CreateForm(TFrmWait, FrmWait);
     if RedMsg then
       FrmWait.LblMsg.Font.Color := clRed;
       FrmWait.LblMsg.Caption    := Msg;
       Application.ProcessMessages;
       FrmWait.Show;
      Application.ProcessMessages;
    end else begin
     if assigned( FrmWait ) then
        FreeAndNil( FrmWait );
    end;
   except
  end;
end;

}
{*******************************************************************************
FUNÇÃO PARA VALIDAR O NÚMERO DO CNPJ.
*******************************************************************************}
function CheckCNPJ(xCNPJ: String):Boolean;
Var
  d1,d4,xx,nCount,fator,resto,digito1,digito2 : Integer;
   Check : String;
begin
d1 := 0;
d4 := 0;
xx := 1;
for nCount := 1 to Length( xCNPJ )-2 do
    begin
    if Pos( Copy( xCNPJ, nCount, 1 ), '/-.' ) = 0 then
    begin
    if xx < 5 then
    begin
    fator := 6 - xx;
    end
    else
   begin
   fator := 14 - xx;
   end;
   d1 := d1 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
   if xx < 6 then
    begin
    fator := 7 - xx;
   end
   else
   begin
   fator := 15 - xx;    end;
   d4 := d4 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
   xx := xx+1;
   end;
   end;
   resto := (d1 mod 11);
   if resto < 2 then
   begin
   digito1 := 0;
   end
   else
   begin
   digito1 := 11 - resto;
   end;
   d4 := d4 + 2 * digito1;
   resto := (d4 mod 11);
   if resto < 2 then
    begin
    digito2 := 0;
   end
   else
    begin
    digito2 := 11 - resto;
   end;
    Check := IntToStr(Digito1) + IntToStr(Digito2);
   if Check <> copy(xCNPJ,succ(length(xCNPJ)-2),2) then
    begin
    Result := False;
   end
   else
    begin
    Result := True;
   end;
 end;

// DIGITO DO CPF
function DigitoCPF(const Identificacao: string): string;
var
  i, code: Integer;
  d2: array[1..12] of Integer;
  DF4, DF5, DF6, RESTO1, Pridig, Segdig: Integer;
  Pridig2, Segdig2: string;
  Texto: string;
begin
  Texto := '';
  Texto := Copy(Identificacao, 1, 3);
  Texto := Texto + Copy(Identificacao, 4, 3);
  Texto := Texto + Copy(Identificacao, 7, 3);
  Texto := Texto + Copy(Identificacao, 10, 2);
  for i := 1 to 9 do
    Val(texto[i], D2[i], Code);
  DF4 := 0;
  for i := 1 to 9 do
    DF4 := DF4 + (D2[i] * (11 - I));
  { DF4 := 10 * D2[1] + 9 * D2[2] + 8 * D2[3] + 7 * D2[4] + 6 * D2[5] + 5 * D2[6] + 4 * D2[7] +3 * D2[8] + 2 * D2[9];}
  DF5 := DF4 div 11;
  DF6 := DF5 * 11;
  Resto1 := DF4 - DF6;
  if (Resto1 = 0) or (Resto1 = 1) then
    Pridig := 0
  else
    Pridig := 11 - Resto1;
  for i := 1 to 9 do
    Val(Texto[i], D2[i], Code);
  DF4 := 11 * D2[1] +
    10 * D2[2] +
    9 * D2[3] +
    8 * D2[4] +
    7 * D2[5] +
    6 * D2[6] +
    5 * D2[7] +
    4 * D2[8] +
    3 * D2[9] +
    2 * Pridig;
  DF5 := DF4 div 11;
  DF6 := DF5 * 11;
  Resto1 := DF4 - DF6;
  if (Resto1 = 0) or (Resto1 = 1) then
    Segdig := 0
  else
    Segdig := 11 - Resto1;
    Str(Pridig, Pridig2);
    Str(Segdig, Segdig2);
    Result := Pridig2 + SegDig2;
end;

// VALIDA EAN
function ValidaEAN(Cod: string; Num: word; var CodEAN: string): Boolean;
var
  CodTemp: string;
begin
  CodTemp := '';
  CodEAN := Cod;
  Result := False;
  if (Length(Cod) > Num) then
    Exit;
  if Length(Cod) = Num then
  begin
    CodTemp := GeraDigitoEAN(Copy(Cod, 1, Num - 1), Num);
    if copy(Cod, Num, 1) <> CodTemp then
      Exit;
    CodEAN := Cod;
  end;
  if Length(Cod) < Num then
  begin
    CodTemp := GeraDigitoEAN(copy(strPadZeroL(Cod, Num), 1, Num - 1), Num);
    if copy(strPadZeroL(Cod, Num), Num, 1) <> CodTemp then
      Exit;
    CodEAN := strPadZeroL(Cod, Num);
  end;
  Result := True;
end;

// GERA DIGITO DE CONTROLE CODIGO EAN
function GeraDigitoEAN(Cod: string; Num: word): string;
var
  Tot1, Tot2, Tot3: LongInt;
  I: Integer;
  CodRef: string;
  Digito: Integer;
begin
  Tot1 := 0;
  Tot2 := 0;
  CodRef := strPadZeroL(Cod, Num - 1);
  for I := 1 to (Num - 1) do
  begin
    if EPar(I) then
      Tot1 := Tot1 + StrToInt(CodRef[i])
    else
      Tot2 := Tot2 + StrToInt(CodRef[i]);
  end;
  Tot1 := Trunc(Tot1 * 3);
  Tot3 := Tot1 + Tot2;
  Digito := trunc(10 * (int(Tot3 / 10.0) + 1) - Tot3);
  if Digito = 10 then
    Digito := 0;
  Result := IntToStr(Digito);
end;

function EPar(Numero: longInt): Boolean;
begin
  Result := False;
  if Numero = 0 then
    Result := True
  else if Numero = 1 then
    Result := False
  else if Numero = 2 then
    Result := True
  else if Numero = 3 then
    Result := False
  else if Numero = 4 then
    Result := True
  else if Numero = 5 then
    Result := False
  else if Numero = 6 then
    Result := True
  else if Numero = 7 then
    Result := False
  else if Numero = 8 then
    Result := True
  else if Numero = 9 then
    Result := False
  else if Numero = 10 then
    Result := True
  else if Numero = 11 then
    Result := False
  else if Numero = 12 then
    Result := True
  else if Numero = 13 then
    Result := False
end;

function SoNumero(Texto: string): string;
var
  Ind, inum: Integer;
  TmpRet, TesteTxt: string;
  numero: array[0..9] of string;
begin
  for inum := 0 to 9 do
    numero[inum] := IntToStr(inum);

  TmpRet := '';
  for Ind := 1 to Length(Texto) do
  begin
    TesteTxt := Copy(Texto, Ind, 1);
    for inum := 0 to 9 do
    begin
      if TESTETXT = numero[inum] then
        //if  IsDigit(Copy(Texto,Ind,1)) then
      begin
        TmpRet := TmpRet + Copy(Texto, Ind, 1);
      end;
    end;
  end;
  Result := TmpRet;
end;

{// VALIDA CGC
function ValidaCGC(xCNPJ: string): Boolean;
var
  d1, d4, xx, nCount, fator,
    resto, digito1, digito2: Integer;
  Check: string;
begin
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(xCNPJ) - 2 do
  begin
    if Pos(Copy(xCNPJ, nCount, 1), '/-.') = 0 then
    begin
      if xx < 5 then
      begin
        fator := 6 - xx;
      end
      else
      begin
        fator := 14 - xx;
      end;
      d1 := d1 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      if xx < 6 then
      begin
        fator := 7 - xx;
      end
      else
      begin
        fator := 15 - xx;
      end;
      d4 := d4 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - resto;
  end;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - resto;
  end;
  Check := IntToStr(Digito1) + IntToStr(Digito2);
  if Check <> copy(xCNPJ, succ(length(xCNPJ) - 2), 2) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;}

{// VALIDA CPF
function ValidaCPF(num: string): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  try
    n1 := StrToInt(num[1]);
    n2 := StrToInt(num[2]);
    n3 := StrToInt(num[3]);
    n4 := StrToInt(num[4]);
    n5 := StrToInt(num[5]);
    n6 := StrToInt(num[6]);
    n7 := StrToInt(num[7]);
    n8 := StrToInt(num[8]);
    n9 := StrToInt(num[9]);
    d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9
      + n1 * 10;
    d1 := 11 - (d1 mod 11);
    if d1 >= 10 then
      d1 := 0;
    d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9
      + n2 * 10 + n1 * 11;
    d2 := 11 - (d2 mod 11);
    if d2 >= 10 then
      d2 := 0;
    calculado := inttostr(d1) + inttostr(d2);
    digitado := num[10] + num[11];
    if calculado = digitado then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end; }

end.
