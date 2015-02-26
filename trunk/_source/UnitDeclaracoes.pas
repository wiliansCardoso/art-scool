unit UnitDeclaracoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, XPStyleActnCtrls, ActnList, ActnMan,
  StdActns, ComCtrls, ToolWin, ActnCtrls, ActnMenus, StdCtrls,
  jpeg, DB, DBCtrls, Mask, Grids, inifiles, Crypto1,
  StdStyleActnCtrls, Winsock, SqlTimSt, DBClient, UrlMon, ShellApi;

type
  Float = Extended; { our type for float arithmetic }

  const
  BLANK = #32;
  _ZERO = '0';
  {$IFDEF MSWINDOWS}
  GPathDelim = '\'; {do not localize}
  {$ELSE}
  GPathDelim = '/'; {do not localize}
  {$ENDIF}
  { Low floating point value }
  FLTZERO: Float = 0.00000001;  

  //Inicio Constantes usadas na funÁ„o ValorPorExtenso
  Centenas: array[1..9] of string[12]=('cem','duzentos','trezentos','quatrocentos',
                                       'quinhentos','seiscentos','setecentos',
                                       'oitocentos','novecentos');
  Dezenas : array[2..9] of string[10]=('vinte','trinta','quarenta','cinquenta',
                                       'sessenta','setenta','oitenta','noventa');
  Dez     : array[0..9] of string[10]=('dez','onze','doze','treze','quatorze',
                                       'quinze','dezesseis','dezessete',
                                       'dezoito','dezenove');
  Unidades: array[1..9] of string[10]=('um','dois','trÍs','quatro','cinco',
                                       'seis','sete','oito','nove');
  MoedaSingular = 'real';
  MoedaPlural   = 'reais';
  CentSingular  = 'centavo';
  CentPlural    = 'centavos';
  MilhaoSingular= 'milh„o';
  MilhaoPlural  = 'milhıes';
  BilhaoSingular= 'bilh„o';
  BilhaoPlural  = 'bilhıes';
  Zero          = 'zero';
  //Fim Constantes usadas na funÁ„o ValorPorExtenso

  type
  {$IFDEF Win32} { our type for integer functions, Int_ is ever 32 bit }
  Int_ = Integer;
  {$ELSE}
  Int_ = Longint;
  {$ENDIF}

  TChars = set of Char;
  TRGBArray = array[Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

  TFuncoes = class
  public
//Funcoes
    function AnoBiSexto(Ano: Integer): Boolean;
    function DiasPorMes(Ano, Mes: Integer): Integer;
    function DownloadArquivo(Arquivo, Destino: string): Boolean;
    function Arredondar(Valor: Double; Dec: Integer): Double;
    function DiasEntreDatas(dataini, datafin: string): integer;
    function NumeroSerialHD: String;
    function ProximoDiaUtil(dData: TDateTime): TSQLTimeStamp;
    function RetornaIP: string;
    function RetornaIdadeAtual(Nasc: TDate): Integer;
    function VerificaCGC(num: string): boolean;
    function VerificaCPF(num: string): boolean;
    function NomeComputador: string; //pega o nome do computador
    function Cripta(Action, Src: String): String;
    function DataExtenso(Data: TDateTime; tipo: integer): String;
    function ValorPorExtenso(Valor: double):string;
    function strPadR(const S: string; Len: Integer): string;
    function strPadC(const S: string; Len: Integer): string;
    function strPadZeroL(const S: string; Len: Integer): string;
    function strPadZeroR(const S: string; Len: Integer): string;
    function strPadChL(const S: string; C: Char; Len: Integer): string;
    function strPadChR(const S: string; C: Char; Len: Integer): string;
    function strPadChC(const S: string; C: Char; Len: Integer): string;
    function strPadL(const S: string; Len: Integer): string;
    function strTrim(const S: string): string;
    function strTrimA(const S: string): string;
    function strTrimChA(const S: string; C: Char): string;
    function strTrimChL(const S: string; C: Char): string;
    function strTrimChR(const S: string; C: Char): string;
    function getinstalldir: string;
    function slash(value: string): string;
    function GPathSep: string;
    function intZero(a: Int_; Len: Integer): string;
    function dateDay(D: TDateTime): Integer;
    function Split(aValue: string; aDelimiter: Char): TStringList;
    function DescriptSerialHD(Text: string): string;
    function MensagemErroSocket(Erro: Integer): string;
    {$IFDEF Win32}
    function iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
    {$ENDIF}
    function EPar(Numero: longInt): Boolean;
    function GeraDigitoEAN(Cod: string; Num: word): string;
    function ValidaEAN(Cod: string; Num: word; var CodEAN: string): Boolean;
    function DelChars(const S: string; Chr: Char): string;
    function TruncaFrac(Valor: Currency; Casa: SmallInt): Currency;
    function CalculaICMS(Valor, ICMS, Reducao: Double; TipoTrib: Word; Perc, Trunca:
    Boolean): Double;
    function fltRound(P: Float; Decimals: Integer): Float;
    function intPow10(Exponent: Integer): Int_;
    function intPow(Base, Expo: Integer): Int_;
    function fltEqualZero(P: Float): Boolean;
    function CalculaTabelaLiquido(Tabela, Val_Desc, Per_Desc, Val_Acr, Per_Acr: Currency;
    Acr_Bruto: string): Currency;
    function BaseCalculoReducao(Valor, Reducao: Double): Currency;    
    function somenteNumero(sNum:string):string;
    function TestaCnpj(xCNPJ: String):Boolean;
    function ChecaEstado(Dado : string) : boolean;
    function zerarcodigo(codigo:string;qtde:integer):string;
    function SimNaoBooStr(Verdadeiro: string): Boolean;
    function strLeft(const S: string; Len: Integer): string;
    function AnsiLength(const s: string): integer;
    function TrimChar(texto: string; delchar: char): string;
    function txt_justifica(texto : string; qtde_caracteres : integer; caracter : string; tipo:string) : string;
    function tiraacento ( str: String ): String;
    function CalculaDigEAN13(Cod:String):String;

//Procedures
//    procedure MudarComEnter(var Msg: TMsg; var Handled: Boolean);
    procedure OrdenaClientDataSet(CDS: TClientDataSet; Campo: TField);
    procedure AbreUrl(Url:String;frm:Tform);
    procedure AbreUrlPublicidade(NumPub: integer; frm:tform);
    procedure Fotografa(NomeArq : String; qld : integer; MaxWidth: Integer);
  published
  protected
  private
  end;

implementation


{$IFDEF Win32}

function TFuncoes.CalculaDigEAN13(Cod:String):String;
function Par(Cod:Integer):Boolean;
begin
Result:= Cod Mod 2 = 0 ;
end;
var
  i,
  SomaPar,
  SomaImpar:Integer;
begin
  SomaPar:=0;
  SomaImpar:=0;
  for i:=1 to 12 do
  if Par(i) then
     SomaPar:=SomaPar+StrToInt(Cod[i])
  else
     SomaImpar:=SomaImpar+StrToInt(Cod[i]);

  SomaPar:=SomaPar*3;
  i:=0;
  while i < (SomaPar+SomaImpar) do Inc(i,10);
  Result:=IntToStr(i-(SomaPar+SomaImpar));
end;

function TFuncoes.txt_justifica(texto : string; qtde_caracteres : integer; caracter : string; tipo:string) : string;
begin
   texto := tiraacento(texto);
   if tipo = 'E' then
   begin
     while length(texto) < qtde_caracteres do texto := caracter+texto;
     while length(texto) > qtde_caracteres do delete(texto,(qtde_caracteres + 1), 1);
   end;
   if tipo = 'D' then
   begin
     while length(texto) < qtde_caracteres do texto := texto+caracter;
     while length(texto) > qtde_caracteres do delete(texto,(qtde_caracteres + 1), 1);
   end;
   if tipo = 'C' then
   begin
     if (qtde_caracteres mod 2) <> 0 then qtde_caracteres := qtde_caracteres - 1;
     while length(texto) < qtde_caracteres do texto := caracter+texto+caracter;
     while length(texto) > qtde_caracteres do delete(texto,(qtde_caracteres + 1), 1);
   end;
   result := texto;
end;

function TFuncoes.tiraacento ( str: String ): String;
var
i: Integer;
begin
for i := 1 to Length ( str ) do
case str[i] of
'Ë': str[i] := 'e';
'Ï': str[i] := 'i';
'˘': str[i] := 'u';
'Ó': str[i] := 'i';
'˚': str[i] := 'u';
'·': str[i] := '†';//
'È': str[i] := 'Ç';//
'Ì': str[i] := '°';//
'Û': str[i] := '¢';//
'˙': str[i] := '£';//
'‡': str[i] := 'Ö';//
'Ú': str[i] := 'ï';//
'‚': str[i] := 'É';//
'Í': str[i] := 'à';//
'Ù': str[i] := 'ì';//
'‰': str[i] := 'Ñ';//
'Î': str[i] := 'â';//
'Ô': str[i] := 'ã';//
'ˆ': str[i] := 'î';//
'¸': str[i] := 'Å';//
'„': str[i] := 'Ü';//
'ı': str[i] := 'o';
'Ò': str[i] := '§';//
'Á': str[i] := 'á';//
'¡': str[i] := 'A';
'…': str[i] := 'ê';//
'Õ': str[i] := 'I';
'”': str[i] := 'O';
'⁄': str[i] := 'U';
'¿': str[i] := 'A';
'»': str[i] := 'E';
'Ã': str[i] := 'I';
'“': str[i] := 'O';
'Ÿ': str[i] := 'U';
'¬': str[i] := 'è';
' ': str[i] := 'E';
'Œ': str[i] := 'I';
'‘': str[i] := 'O';
'€': str[i] := 'U';
'ƒ': str[i] := 'A';
'À': str[i] := 'E';
'œ': str[i] := 'I';
'÷': str[i] := 'O';
'‹': str[i] := 'ö';//
'√': str[i] := 'A';
'’': str[i] := 'O';
'—': str[i] := '•';//
'«': str[i] := 'Ä';//
'™': str[i] := '¶';//
'∫': str[i] := 'ß';//
end;
Result := str;
end;


function TFuncoes.iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
begin
  if Condicao then
    Result := Verdadeiro
  else
    Result := falso;
end;
{$ENDIF}

function TFuncoes.SimNaoBooStr(Verdadeiro: string): Boolean;
begin
  if (Verdadeiro = 'T') or (Verdadeiro = 'S') then
    Result := True
  else
    Result := False;
end;

function TFuncoes.AnsiLength(const s: string): integer;
//
// Retorna o tamanho da string independente do seu tipo (Shortstring, Ansistring, Widstring...)
//
var
  p, q: pchar;
begin
  Result := 0;
  p := PChar(s);
  q := p + Length(s);
  while p < q do begin
    inc(Result);
    if p^ in LeadBytes then
      inc(p, 2)
    else
      inc(p);
  end;
end;

function TFuncoes.TrimChar(texto: string; delchar: char): string;
var
  S: string;
  begin
    S := texto;
    while Pos(delchar,S) > 0 do
      Delete(S,Pos(delchar,S),1);
    Result := S;
end;


function TFuncoes.strLeft(const S: string; Len: Integer): string;
begin
  Result := Copy(S, 1, Len);
end;


function TFuncoes.zerarcodigo(codigo:string;qtde:integer):string;
begin
  while length(codigo) < qtde do codigo := '0'+codigo;
  result := codigo;
end;

function TFuncoes.somenteNumero(sNum:string):string;
var s1, s2: string;
    i: Integer;
begin
     s1 := snum;
     s2 := '';
     for i := 1 to Length(s1) do
          if s1[i] in ['0'..'9'] then
               s2 := s2 + s1[i];
     result:=s2;
end;

function TFuncoes.TestaCnpj(xCNPJ: String):Boolean;
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

 function TFuncoes.ChecaEstado(Dado : string) : boolean;
const
  Estados = 'SPMGRJRSSCPRESDFMTMSGOTOBASEALPBPEMARNCEPIPAAMAPFNACRRROEX';
var
  Posicao : integer;
begin
Result := true;
if Dado <> '' then
  begin
  Posicao := Pos(UpperCase(Dado),Estados);
  if (Posicao = 0) or ((Posicao mod 2) = 0) then
  begin
  Result := false;
  end;
  end;
end;

function TFuncoes.GeraDigitoEAN(Cod: string; Num: word): string;
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

function TFuncoes.ValidaEAN(Cod: string; Num: word; var CodEAN: string): Boolean;
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

function TFuncoes.CalculaICMS(Valor, ICMS, Reducao: Double; TipoTrib: Word; Perc, Trunca: Boolean): Double;
var
  Imposto: Double;
begin
  Result := 0;
  if TipoTrib in [0, 2] then // Normal e ReduÁ„o
  begin
    Imposto := fltRound(ICMS * (1 - Reducao / 100), 2);
    case Perc of
      True: if Trunca then
          Result := TruncaFrac(Imposto, 2)
        else
          Result := fltRound(Imposto, 2);
      False: if Trunca then // Valor
          Result := TruncaFrac(Valor * (Imposto / 100), 2)
        else
          Result := fltRound(Valor * (Imposto / 100), 2);
    end;
  end;
end;

function TFuncoes.BaseCalculoReducao(Valor, Reducao: Double): Currency;
var
  BC: Double;
begin
  BC := Valor - (Valor * (Reducao / 100));
  Result := fltRound(BC, 2);
end;

function TFuncoes.CalculaTabelaLiquido(Tabela, Val_Desc, Per_Desc,
  Val_Acr, Per_Acr: Currency; Acr_Bruto: string): Currency;
var
  Desconto, Acrescimo: Currency;
begin
  Desconto := Val_Desc + ((Tabela * Per_Desc) / 100);
  if Acr_Bruto = 'S' then
    Acrescimo := Val_Acr + ((Tabela * Per_Acr) / 100)
  else
    Acrescimo := Val_Acr + (((Tabela - Desconto) * Per_Acr) / 100);
  Result := (Tabela - Desconto + Acrescimo);
end;

function TFuncoes.TruncaFrac(Valor: Currency; Casa: SmallInt): Currency;
var
  i, Mult: Integer;
begin
  Mult := 1;
  for i := 1 to Casa do
    Mult := Mult * 10;
  Result := (Trunc(Valor * Mult) / Mult);
end;

function TFuncoes.FltRound(P: Float; Decimals: Integer): Float;
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

function TFuncoes.IntPow(Base, Expo: Integer): Int_;
var
  Loop: Word;
begin
  Result := 1;
  for Loop := 1 to Expo do
    Result := Result * Base;
end;

function TFuncoes.IntPow10(Exponent: Integer): Int_;
begin
  Result := IntPow(10, Exponent);
end;

function TFuncoes.DelChars(const S: string; Chr: Char): string;
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

function TFuncoes.FltEqualZero(P: Float): Boolean;
begin
  Result := (P >= -FLTZERO) and (P <= FLTZERO); { 29.10.96 sb }
end;

function TFuncoes.EPar(Numero: longInt): Boolean;
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

function TFuncoes.NomeComputador : String;
var
  lpBuffer : PChar;
  nSize : DWord;
  const Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
  begin
    nSize := Buff_Size;
    lpBuffer := StrAlloc(Buff_Size);
    GetComputerName(lpBuffer,nSize);
    Result := String(lpBuffer);
    StrDispose(lpBuffer);
end;

function TFuncoes.DescriptSerialHD(Text: string): string;
var
  texto: string;
  stringtext: TStrings;
begin
  if Copy(text, 1, 3) = 'WIN' then
    Result := Decrypt1(Copy(text, 4, Length(text)));
  stringtext := nil;
  if Copy(text, 1, 8) = 'SerialNo' then // LINUX
  begin
    try
      stringtext := TStringList.Create;
      stringtext := Split(text, #0);
      texto := trim(stringtext.Strings[0]);
      texto := Copy(texto, Length('SerialNo') + 2, Length(texto));
      texto := Copy(texto, 1, Length(texto) - 3);
    finally
      stringtext.Free;
    end;
    Result := Decrypt1(Encrypt1(texto));
  end;
end;

function TFuncoes.Split(aValue: string; aDelimiter: Char): TStringList;
var
  X: Integer;
  S: string;
begin
  //  if Result = nil then
  Result := TStringList.Create;
  Result.Clear;
  S := '';
  for X := 1 to Length(aValue) do
  begin
    if aValue[X] <> aDelimiter then
      S := S + aValue[X]
    else
    begin
      Result.Add(S);
      S := '';
    end;
  end;
  if S <> '' then
    Result.Add(S);
end;

function TFuncoes.dateDay(D: TDateTime): Integer;
var
  Year, Month, Day: Word;
begin
  DecodeDate(D, Year, Month, Day);
  Result := Day;
end;

function TFuncoes.IntZero(a: Int_; Len: Integer): string;
begin
  Result := strPadZeroL(IntToStr(a), Len);
end;

{returns install directory of EXE using this library}
{example: getinstalldir = 'C:\PROGRAM FILES\BORLAND\DELPHI\DEMOS\'}
function TFuncoes.getinstalldir: string;
begin
  result := slash(extractfiledir(paramstr(0)));
end;

{ensures that value has '\' as last character (for directory strings)}
function TFuncoes.slash(value: string): string;
begin
  if (value[length(value)] <> GPathSep) then
    result := value + GPathSep
  else
    result := value;
end;

function TFuncoes.GPathSep: string;
begin
  Result := GPathDelim;
end;

procedure TFuncoes.Fotografa(NomeArq : String; qld : integer; MaxWidth: Integer);

  procedure SmoothResize(Src, Dst: TBitmap);
  var
    x, y: Integer;
    xP, yP: Integer;
    xP2, yP2: Integer;
    SrcLine1, SrcLine2: pRGBArray;
    t3: Integer;
    z, z2, iz2: Integer;
    DstLine: pRGBArray;
    DstGap: Integer;
    w1, w2, w3, w4: Integer;
  begin
    Src.PixelFormat := pf24Bit;
    Dst.PixelFormat := pf24Bit;

    if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
      Dst.Assign(Src)
    else
    begin
      DstLine := Dst.ScanLine[0];
      DstGap := Integer(Dst.ScanLine[1]) - Integer(DstLine);

      xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
      yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
      yP := 0;

      for y := 0 to pred(Dst.Height) do
      begin
        xP := 0;

        SrcLine1 := Src.ScanLine[yP shr 16];

        if (yP shr 16 < pred(Src.Height)) then
          SrcLine2 := Src.ScanLine[succ(yP shr 16)]
        else
          SrcLine2 := Src.ScanLine[yP shr 16];

        z2 := succ(yP and $FFFF);
        iz2 := succ((not yp) and $FFFF);
        for x := 0 to pred(Dst.Width) do
        begin
          t3 := xP shr 16;
          z := xP and $FFFF;
          w2 := MulDiv(z, iz2, $10000);
          w1 := iz2 - w2;
          w4 := MulDiv(z, z2, $10000);
          w3 := z2 - w4;
          DstLine[x].rgbtRed := (SrcLine1[t3].rgbtRed * w1 +
          SrcLine1[t3 + 1].rgbtRed * w2 +
          SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
          DstLine[x].rgbtGreen :=
          (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 +

          SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
          DstLine[x].rgbtBlue := (SrcLine1[t3].rgbtBlue * w1 +
          SrcLine1[t3 + 1].rgbtBlue * w2 +
          SrcLine2[t3].rgbtBlue * w3 +
          SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
          Inc(xP, xP2);
        end; {for}
        Inc(yP, yP2);
        DstLine := pRGBArray(Integer(DstLine) + DstGap);
      end; {for}
    end; {if}
  end; {SmoothResize}

var
  aWidth : integer;
  Bitmap, OldBitmap, NewBitmap : TBitmap;
  DC : hDc;
  DesktopRect : TRect;
  DesktopCanvas : TCanvas;
  HoraAtu : DWord;
  JPeg: TJPegImage;
begin
  try
    // pega um DC para a ·rea de trabalho
    DC := GetDC(GetDesktopWindow);
    try
      // cria um canvas para ·rea de trabalho
      DesktopCanvas := TCanvas.Create;
      // cria um bitmap para armazenar ·rea de trabalho
      Bitmap := TBitmap.Create;
      try
        // deixa tamanho do bitmap igual ao da tela
        Bitmap.Width := Screen.Width;
        Bitmap.Height := Screen.Height;
        // seta o Handle do canvas para o DC da ·rea de trabalho
        DesktopCanvas.Handle := DC;
        DeskTopRect := Rect(0,0,Screen.Width,Screen.Height);
        // copia imagem da ·rea de trabalho para o bitmap
        Bitmap.Canvas.CopyRect(DeskTopRect,DeskTopCanvas,DeskTopRect);
        // salva o bitmap
        JPeg := TJPegImage.Create;
        try
          JPeg.CompressionQuality := qld;
          JPeg.Assign(Bitmap);
          // Redimensiona
          OldBitmap := TBitmap.Create;
          OldBitmap.Assign(Jpeg);
          aWidth := OldBitmap.Width;
          if (OldBitmap.Width > MaxWidth) then
          begin
            aWidth := MaxWidth;
            NewBitmap := TBitmap.Create;
            try
              NewBitmap.Width := MaxWidth;
              NewBitmap.Height := MulDiv(MaxWidth, OldBitmap.Height, OldBitmap.Width);
              SmoothResize(OldBitmap, NewBitmap);
              JPeg.Assign(NewBitmap);
            finally
              NewBitmap.Free;
            end; {try}
          end {if}
          else //Se n„o for menor que o tamanho m·ximo, pega de OldBitmap
            JPeg.Assign(OldBitmap);
          // Continua
          JPeg.SaveToFile(NomeArq);
        finally
          JPeg.Free;
        end;
      finally
        Bitmap.Free;
        OldBitmap.Free;
        DesktopCanvas.Free;
      end;
    finally
      // libera o DC da ·rea de trabalho
      ReleaseDC(GetDesktopWindow,DC);
    end;
  finally
  end;
end;

procedure TFuncoes.AbreUrl(Url:String;frm:Tform);
begin
  ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Url), NIL, NIL, SW_SHOWNORMAL);
end;

function TFuncoes.AnoBiSexto(Ano: Integer): Boolean;
begin
// Verifica se o ano È Bi-Sexto
Result := (Ano mod 4 = 0) and ((Ano mod 100 <> 0) or
(Ano mod 400 = 0));
end;

function TFuncoes.DiasPorMes(Ano, Mes: Integer): Integer;
const DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
Result := DaysInMonth[Mes];
if (Mes = 2) and AnoBiSexto(Ano) then
Inc(Result);
end;

function TFuncoes.DownloadArquivo(Arquivo, Destino: string): Boolean;
begin
  try
    Result:= UrlDownloadToFile(nil, PChar(Arquivo),PChar(Destino), 0, nil) = 0;
  except
    Result:= False;
  end;
end;

function TFuncoes.ValorPorExtenso(Valor: double): string;

      Function Ext3(Parte:string):string;
      var
        Base: string;
        digito: integer;
      begin
       Base:='';
       digito:=StrToInt(Parte[1]);
       if digito=0 then
        Base:=''
       else
        Base:=Centenas[digito];
       if (digito = 1) and (Parte > '100') then
        Base:='cento';
       Digito:=StrToInt(Parte[2]);
       if digito = 1 then
        begin
         Digito:=StrToInt(Parte[3]);
         if Base <> '' then
          Base:=Base + ' e ';
         Base:=Base + Dez[Digito];
        end
       else
        begin
         if (Base <> '') and (Digito > 0) then
          Base:=Base+' e ';
         if Digito > 1 then
          Base:=Base + Dezenas[digito];
         Digito:=StrToInt(Parte[3]);
         if Digito > 0 then
          begin
           if Base <> '' then Base:=Base+' e ';
           Base:=Base+Unidades[Digito];
          end;
        end;
       Result:=Base;
      end;
var
  ComoTexto: string;
  Parte: string;
begin
 Result:='';
 ComoTexto:=FloatToStrF(Abs(Valor),ffFixed,18,2);
// Acrescenta zeros a esquerda ate 12 digitos
 while length(ComoTexto) < 15 do
  Insert('0',ComoTexto,1);
// Retira caracteres a esquerda para o m·ximo de 12 digitos
 while length(ComoTexto) > 15 do
  delete(ComoTexto,1,1);

// Calcula os bilhıes
 Parte:=Ext3(copy(ComoTexto,1,3));
 if StrToInt(copy(ComoTexto,1,3)) = 1 then
  Parte:=Parte + ' ' + BilhaoSingular
 else
  if Parte <> '' then
   Parte:=Parte + ' ' + BilhaoPlural;
 Result:=Parte;

// Calcula os milhıes
 Parte:=Ext3(copy(ComoTexto,4,3));
 if Parte <> '' then
  begin
   if Result <> '' then
    Result:=Result+', ';
   if StrToInt(copy(ComoTexto,4,3)) = 1 then
    Parte:=Parte + ' ' + MilhaoSingular
   else
    Parte:=Parte + ' ' + MilhaoPlural;
   Result:=Result + Parte;
  end;

// Calcula os milhares
 Parte:=Ext3(copy(ComoTexto,7,3));
 if Parte <> '' then
  begin
   if Result <> '' then
    Result:=Result + ', ';
   Parte:=Parte + ' mil';
   Result:=Result + Parte;
  end;

// Calcula as unidades
 Parte:=Ext3(copy(ComoTexto,10,3));
 if Parte <> '' then
  begin
   if Result <> '' then
    if Frac(Valor) = 0 then
     Result:=Result + ' e '
    else
     Result:=Result + ', ';
   Result:=Result + Parte;
  end;

// Acrescenta o texto da moeda
 if System.Int(Valor) = 1 then
  Parte:=' ' + MoedaSingular
 else
  Parte:=' ' + MoedaPlural;
 if copy(ComoTexto,7,6) = '000000' then
  Parte:='DE ' + MoedaPlural;
 Result:=Result + Parte;

// Se o valor for zero, limpa o resultado
 if System.int(Valor) = 0 then Result:='';

//Calcula os centavos
 Parte:=Ext3('0'+copy(ComoTexto,14,2));
 if Parte <> '' then
  begin
   if Result <> '' then
    Result:=Result + ' e ';
   if Parte = Unidades[1] then
    Parte:=Parte + ' '+CentSingular
   else
    Parte:=Parte + ' '+CentPlural;
   Result:=Result + Parte;
  end;

// Se o valor for zero, assume a constante ZERO
 if Valor = 0 then
  Result:=Zero;
end;

procedure TFuncoes.OrdenaClientDataSet(CDS: TClientDataSet; Campo: TField);
var
  nomeindice: string;
  opcoesindice: Tindexoptions;
begin
  if CDS.IndexName = copy('ixasc' + Campo.FieldName,1,30) then
  begin
    NomeIndice := copy('ixdesc' + Campo.FieldName,1,30);
    opcoesindice := [ixDescending, ixCaseInsensitive];
  end else
  begin
    NomeIndice := copy('ixasc' + Campo.FieldName,1,30);
    opcoesindice := [ixCaseInsensitive];
  end;
  try
    if CDS.IndexDefs.IndexOf(NomeIndice) = -1 then
    CDS.IndexDefs.Add(NomeIndice, Campo.FieldName, Opcoesindice);
    CDS.IndexName := NomeIndice;
    CDS.IndexDefs.Update;
    CDS.First;
  except 
  end;
end;

function TFuncoes.Arredondar(Valor: Double; Dec: Integer): Double;
var
  Valor1,
  Numero1,
  Numero2,
  Numero3: Double;
begin
  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=System.Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);
  Numero3:=Round(Numero2);
  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

function TFuncoes.DiasEntreDatas(dataini,datafin:string):integer;
var a,b,c:tdatetime;
  ct,s:integer;
begin
  if StrToDate(DataFin) < StrtoDate(DataIni) then
    begin
      Result := 0;
      exit;
    end;
  ct := 0;
  s := 1;
  a := strtodate(dataFin);
  b := strtodate(dataIni);
  if a > b then
    begin
      c := a;
      a := b;
      b := c;
      s := 1;
    end;
  a := a + 1;
  while (dayofweek(a)<>2) and (a <= b) do
    begin
      if dayofweek(a) in [1..7] then
        begin
          inc(ct);
        end;
      a := a + 1;
    end;
  ct := ct + round((7*System.int((b-a)/7)));
  a := a + (7*System.int((b-a)/7));
  while a <= b do
    begin
      if dayofweek(a) in [1..7] then
        begin
          inc(ct);
        end;
      a := a + 1;
    end;
  if ct < 0 then
    begin
      ct := 0;
    end;
  result := s*ct;
end;

Function TFuncoes.NumeroSerialHD:String;
Var
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : Array[0..11] of Char;
begin
  Try
    GetVolumeInformation(PChar('C:\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
    Result := IntToHex(Serial,8);
  Except
    Result :='';
  end;
end;

function TFuncoes.ProximoDiaUtil(dData : TDateTime) : TSQLTimeStamp;
begin 
  if DayOfWeek(dData) = 7 then
    dData := dData + 2
  else if DayOfWeek(dData) = 1 then
    dData := dData + 1;
  ProximoDiaUtil := DateTimetoSqlTimeStamp(dData); 
end;

function TFuncoes.RetornaIP:string;

var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin 
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d',
    [Byte(h_addr^[0]),Byte(h_addr^[1]),
    Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;

function TFuncoes.RetornaIdadeAtual(Nasc : TDate): Integer;
Var AuxIdade, Meses : String;
  MesesFloat : Real;
  IdadeInc, IdadeReal : Integer;
begin
  AuxIdade := Format('%0.2f', [(Date - Nasc) / 365.6]);
  Meses := FloatToStr(Frac(StrToFloat(AuxIdade)));
  if AuxIdade = '0' then
  begin
  Result := 0;
  Exit;
  end;
  if Meses[1] = '-' then
  begin
  Meses := FloatToStr(StrToFloat(Meses) * -1);
  end;
  Delete(Meses, 1, 2);
  if Length(Meses) = 1 then
  begin
  Meses := Meses + '0';
  end;
  if (Meses <> '0') And (Meses <> '') then
  begin
  MesesFloat := Round(((365.6 * StrToInt(Meses)) / 100) / 30.47)
  end
  else
  begin
  MesesFloat := 0;
  end;
  if MesesFloat <> 12 then
  begin
  IdadeReal := Trunc(StrToFloat(AuxIdade)); // + MesesFloat;
  end
  else
  begin
  IdadeInc := Trunc(StrToFloat(AuxIdade));
  Inc(IdadeInc);
  IdadeReal := IdadeInc;
  end;
  Result := IdadeReal;
end;

function TFuncoes.VerificaCPF(num: string): boolean;
var
  n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
  d1,d2: integer;
  digitado, calculado: string;
begin
  try
  n1:=StrToInt(num[1]);
  n2:=StrToInt(num[2]);
  n3:=StrToInt(num[3]);
  n4:=StrToInt(num[5]);
  n5:=StrToInt(num[6]);
  n6:=StrToInt(num[7]);
  n7:=StrToInt(num[9]);
  n8:=StrToInt(num[10]);
  n9:=StrToInt(num[11]);
  d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
  d1:=11-(d1 mod 11);
  if d1>=10 then d1:=0;
  d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
  d2:=11-(d2 mod 11);
  if d2>=10 then d2:=0;
  calculado:=inttostr(d1)+inttostr(d2);
  digitado:=num[13]+num[14];
  if calculado=digitado then
    Result:=true
      else
        Result:=false;
  except
    Result:=false;
  end;
end;


function TFuncoes.VerificaCGC(num: string): boolean;
var
n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12: integer;
d1,d2: integer;
digitado, calculado: string;
begin
  try
  n1:=StrToInt(num[1]);
  n2:=StrToInt(num[2]);
  n3:=StrToInt(num[4]);
  n4:=StrToInt(num[5]);
  n5:=StrToInt(num[6]);
  n6:=StrToInt(num[8]);
  n7:=StrToInt(num[9]);
  n8:=StrToInt(num[10]);
  n9:=StrToInt(num[12]);
  n10:=StrToInt(num[13]);
  n11:=StrToInt(num[14]);
  n12:=StrToInt(num[15]);
  d1:=n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
  d1:=11-(d1 mod 11);
  if d1>=10 then d1:=0;
  d2:=d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
  d2:=11-(d2 mod 11);
  if d2>=10 then d2:=0;
  calculado:=inttostr(d1)+inttostr(d2);
  digitado:=num[17]+num[18];
    if calculado=digitado then
      Result:=true
        else
          Result:=false;
  except
    Result:=false;
  end;
end;

function TFuncoes.Cripta(Action, Src: String): String;
//Action = C: Criptografa
//Action = D: Descriptografa
Label Fim; //FunÁ„o para criptografar e descriptografar string's
var
  KeyLen : Integer;
  KeyPos : Integer;
  OffSet : Integer;
  Dest, Key : String;  
  SrcPos : Integer;
  SrcAsc : Integer;
  TmpSrcAsc : Integer;
  Range : Integer;
begin
  if (Src = '') Then
  begin
    Result:= '';
    Goto Fim;
  end;
//  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
//  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
  Key := 'YUQL%%$#%3DF#0WI5E$JA$46#NM@XXL6JAOAUW%$#@0AOMM4$4VZYW&&HJUI23@7E%#@!DF34#4SKL K3LA@DJSL9RTIKJ';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Src,1,2));
    SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
    if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;

function TFuncoes.DataExtenso(Data:TDateTime;tipo:integer): String;
{Retorna uma data por extenso}
//tipo 1: "Segunda-Feira, 01 de Janeiro de 2007"
//tipo 2: "Segunda-Feira"
//tipo 3: "Janeiro de 2007"
//tipo 4: "3 de Jan"
//tipo 5: "03 de Janeiro"
//tipo 6: "03"
//tipo 7: "Segunda, 03 de Janeiro"
//tipo 8: "01 de Janeiro de 2007"
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of String;
  DiaDaSemanaAbr : array [1..7] of String;
  Meses : array [1..12] of String;
  MesesAbreviado : array [1..12] of String;
  Dia, Mes, Ano : Word;
begin
{ Dias da Semana }
  DiaDasemana [1]:= 'Domingo';
  DiaDasemana [2]:= 'Segunda-Feira';
  DiaDasemana [3]:= 'TerÁa-Feira';
  DiaDasemana [4]:= 'Quarta-Feira';
  DiaDasemana [5]:= 'Quinta-Feira';
  DiaDasemana [6]:= 'Sexta-Feira';
  DiaDasemana [7]:= 'S·bado';
{ Dias da SemanaAbreviado }
  DiaDasemanaAbr [1]:= 'Domingo';
  DiaDasemanaAbr [2]:= 'Segunda';
  DiaDasemanaAbr [3]:= 'TerÁa';
  DiaDasemanaAbr [4]:= 'Quarta';
  DiaDasemanaAbr [5]:= 'Quinta';
  DiaDasemanaAbr [6]:= 'Sexta';
  DiaDasemanaAbr [7]:= 'S·bado';
{ Meses do ano }
  Meses [1] := 'Janeiro';
  Meses [2] := 'Fevereiro';
  Meses [3] := 'MarÁo';
  Meses [4] := 'Abril';
  Meses [5] := 'Maio';
  Meses [6] := 'Junho';
  Meses [7] := 'Julho';
  Meses [8] := 'Agosto';
  Meses [9] := 'Setembro';
  Meses [10]:= 'Outubro';
  Meses [11]:= 'Novembro';
  Meses [12]:= 'Dezembro';
{ Meses do ano abreviados }
  MesesAbreviado [1] := 'Jan';
  MesesAbreviado [2] := 'Fev';
  MesesAbreviado [3] := 'Mar';
  MesesAbreviado [4] := 'Abr';
  MesesAbreviado [5] := 'Mai';
  MesesAbreviado [6] := 'Jun';
  MesesAbreviado [7] := 'Jul';
  MesesAbreviado [8] := 'Ago';
  MesesAbreviado [9] := 'Set';
  MesesAbreviado [10]:= 'Out';
  MesesAbreviado [11]:= 'Nov';
  MesesAbreviado [12]:= 'Dez';
  DecodeDate (Data, Ano, Mes, Dia);
  NoDia := DayOfWeek (Data);
  if tipo = 1 then Result := DiaDaSemana[NoDia] + ', ' + IntToStr(Dia) + ' de ' + Meses[Mes]+ ' de ' + IntToStr(Ano)
  else if tipo = 2 then Result := DiaDaSemana[NoDia]
  else if tipo = 3 then Result := Meses[Mes] + ' de ' + IntToStr(Ano)
  else if tipo = 4 then Result := InttoStr(Dia) + ' de ' + MesesAbreviado[Mes]
  else if tipo = 5 then Result := FormatFloat('00',Dia) + ' de ' + Meses[Mes]
  else if tipo = 6 then Result := FormatFloat('00',Dia)
  else if tipo = 7 then Result := DiaDaSemanaAbr[NoDia] + ', ' + FormatFloat('00',Dia) + ' de ' + Meses[Mes]
  else if tipo = 8 then result := IntToStr(Dia) + ' de ' + Meses[Mes]+ ' de ' + IntToStr(Ano); 
       
               

end;

{ TFuncoes }

procedure TFuncoes.AbreUrlPublicidade(NumPub: integer; frm:tform);
var
  inifile: TIniFile;
begin
  inifile := Tinifile.Create(extractfilepath(application.ExeName) + 'Pub.sis');
  case NumPub of
    1:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url1',''))), NIL, NIL, SW_SHOWNORMAL);
    2:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url2',''))), NIL, NIL, SW_SHOWNORMAL);
    3:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url3',''))), NIL, NIL, SW_SHOWNORMAL);
    4:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url4',''))), NIL, NIL, SW_SHOWNORMAL);
    5:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url5',''))), NIL, NIL, SW_SHOWNORMAL);
    6:ShellExecute(ValidParentForm(frm).Handle,'open', PChar(Cripta('D',inifile.ReadString('Publicidade','Url6',''))), NIL, NIL, SW_SHOWNORMAL);
  end;
  inifile.Free;
end;

{
procedure TFuncoes.MudarComEnter(var Msg: TMsg; var Handled: Boolean);
begin //faz o enter ser o tab por toda a aplicaÁ„o
  try
    If not ((Screen.ActiveControl is TCustomMemo) or (Screen.ActiveControl is TCustomGrid) or
             (Screen.ActiveControl is TButton) or (Screen.ActiveForm.ClassName = 'TMessageForm') or
              (FrmMain.Configuracao.enterportab = false)) then
    begin
      If Msg.message = WM_KEYDOWN then
      begin
        Case Msg.wParam of
          VK_RETURN{,VK_DOWN} {:Screen.ActiveForm.Perform(WM_NextDlgCtl,0,0);
          //VK_UP : Screen.ActiveForm.Perform(WM_NextDlgCtl,1,0);
        end;
      end;
    end;
  except
  end;
end;

}

function TFuncoes.strPadC(const S: string; Len: Integer): string;
begin
  Result := strPadChC(S, BLANK, Len);
end;

function TFuncoes.strPadR(const S: string; Len: Integer): string;
begin
  Result := strPadChR(S, BLANK, Len);
end;

function TFuncoes.strPadZeroL(const S: string; Len: Integer): string;
begin
  Result := strPadChL(strTrim(S), _ZERO, Len);
end;

function TFuncoes.strPadZeroR(const S: string; Len: Integer): string;
begin
  Result := strPadChR(strTrim(S), _ZERO, Len);
end;

function TFuncoes.strPadChL(const S: string; C: Char; Len: Integer): string;
begin
  Result := S;
  while Length(Result) < Len do
    Result := C + Result;
end;

function TFuncoes.strPadChR(const S: string; C: Char; Len: Integer): string;
begin
  Result := S;
  while Length(Result) < Len do
    Result := Result + C;
end;

function TFuncoes.strPadChC(const S: string; C: Char; Len: Integer): string;
begin
  Result := S;
  while Length(Result) < Len do
  begin
    Result := Result + C;
    if Length(Result) < Len then
      Result := C + Result;
  end;
end;

function TFuncoes.strPadL(const S: string; Len: Integer): string;
begin
  Result := strPadChL(S, BLANK, Len);
end;

function TFuncoes.strTrim(const S: string): string;
begin
  Result := StrTrimChR(StrTrimChL(S, BLANK), BLANK);
end;

function TFuncoes.strTrimA(const S: string): string;
begin
  Result := StrTrimChA(S, BLANK);
end;

function TFuncoes.strTrimChA(const S: string; C: Char): string;
var
  I: Word;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if Result[I] = C then
      Delete(Result, I, 1);
end;

function TFuncoes.strTrimChL(const S: string; C: Char): string;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[1] = C) do
    Delete(Result, 1, 1);
end;

function TFuncoes.strTrimChR(const S: string; C: Char): string;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[Length(Result)] = C) do
    Delete(Result, Length(Result), 1);
end;

function TFuncoes.MensagemErroSocket(Erro: Integer): string;
begin
  case Erro of
    0: Result := 'Directly send error';
    10004: Result := 'Interrupted function call';
    10013: Result := 'Permission denied';
    10014: Result := 'Bad address';
    10022: Result := 'Invalid argument';
    10024: Result := 'Too many open files';
    10035: Result := 'Resource temporarily unavailable';
    10036: Result := 'Operation now in progress';
    10037: Result := 'Operation already in progress';
    10038: Result := 'Socket operation on non-socket';
    10039: Result := 'Destination address required';
    10040: Result := 'Message too long';
    10041: Result := 'Protocol wrong type for socket';
    10042: Result := 'Bad protocol option';
    10043: Result := 'Protocol not supported';
    10044: Result := 'Socket type not supported';
    10045: Result := 'Operation not supported';
    10046: Result := 'Protocol family not supported';
    10047: Result := 'Address family not supported by protocol family';
    10048: Result := 'Address already in use';
    10049: Result := 'Cannot assign requested address';
    10050: Result := 'Network is down';
    10051: Result := 'Network is unreachable';
    10052: Result := 'Network dropped connection on reset';
    10053: Result := 'Software caused connection abort';
    10054: Result := 'Connection reset by peer';
    10055: Result := 'No buffer space available';
    10056: Result := 'Socket is already connected';
    10057: Result := 'Socket is not connected';
    10058: Result := 'Cannot send after socket shutdown';
    10060: Result := 'Connection timed out';
    10061: Result := 'Connection refused';
    10064: Result := 'Host is down';
    10065: Result := 'No route to host';
    10067: Result := 'Too many processes';
    10091: Result := 'Network subsystem is unavailable';
    10092: Result := 'WINSOCK.DLL version out of range';
    10093: Result := 'Successful WSAStartup not yet performed';
    10094: Result := 'Graceful shutdown in progress';
    11001: Result := 'Host not found';
    11002: Result := 'Non-authoritative host not found';
    11003: Result := 'This is a non-recoverable error';
    11004: Result := 'Valid name, no data record of requested type';
  end;
end;



end.
