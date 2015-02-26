unit DrdDataSet;

{***********************************************************}
{ ...::: DRD SISTEMAS :::...                                }
{ www.drdsistemas.com.br                                    }
{ Programador........: Eduardo Silva dos Santos.            }
{ Tester.............: Uélita Giacomim da Silva.            }
{ Função do Módulo...: Componente com Múltiplos SQL's       }
{ Data de Criação....: 24/04/2002 -- 22:20                  }
{ Observações........:                                      }
{                                                           }
{***********************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DB,
  {MyDAC}
  MyAccess, DBAccess;

type
  TCallSQL = (csSelect, csInsert, csUpdate, csDelete, 
              csOther1, csOther2, csOther3, csOther4, csOther5,
              csOther6,csOther7,csOther8,csOther9,csOther10,csOther11,
              csOther12,csOther13,csOther14,csOther15);

type
  TDRDQuery = class( TMyQuery ) //Muda a classe Ascendete caso necessário..
  private
    { Private declarations }
    FSQLSelect, FSQLInsert, FSQLUpdate, FSQLDelete, 
    FSQLOther1, FSQLOther2, FSQLOther3, FSQLOther4, FSQLOther5,
    FSQLOther6,FSQLOther7,FSQLOther8,FSQLOther9 ,FSQLOther10,
    FSQLOther11,FSQLOther12,FSQLOther13,FSQLOther14,FSQLOther15: TStrings;

    procedure SetSelect(Value: TStrings);
    procedure SetInsert(Value: TStrings);
    procedure SetUpdate(Value: TStrings);
    procedure SetDelete(Value: TStrings);
    procedure SetOther1(Value: TStrings);
    procedure SetOther2(Value: TStrings);
    procedure SetOther3(Value: TStrings);
    procedure SetOther4(Value: TStrings);
    procedure SetOther5(Value: TStrings);
    procedure SetOther6(Value: TStrings);
    procedure SetOther7(Value: TStrings);
    procedure SetOther8(Value: TStrings);
    procedure SetOther9(Value: TStrings);
    procedure SetOther10(Value: TStrings);
    procedure SetOther11(Value: TStrings);
    procedure SetOther12(Value: TStrings);
    procedure SetOther13(Value: TStrings);
    procedure SetOther14(Value: TStrings);
    procedure SetOther15(Value: TStrings);

  protected
    { Protected declarations }
    property SQL;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CallSQL(Value: TCallSQL; lPrepare: Boolean = False);
  published
    { Published declarations }
    property SQL_Select: TStrings read FSQLSelect write SetSelect;
    property SQL_Insert: TStrings read FSQLInsert write SetInsert;
    property SQL_Update: TStrings read FSQLUpdate write SetUpdate;
    property SQL_Delete: TStrings read FSQLDelete write SetDelete;
    property SQL_Other1: TStrings read FSQLOther1 write SetOther1;
    property SQL_Other2: TStrings read FSQLOther2 write SetOther2;
    property SQL_Other3: TStrings read FSQLOther3 write SetOther3;
    property SQL_Other4: TStrings read FSQLOther4 write SetOther4;
    property SQL_Other5: TStrings read FSQLOther5 write SetOther5;
    property SQL_Other6: TStrings read FSQLOther6 write SetOther6;
    property SQL_Other7: TStrings read FSQLOther7 write SetOther7;
    property SQL_Other8: TStrings read FSQLOther8 write SetOther8;
    property SQL_Other9: TStrings read FSQLOther9 write SetOther9;
    property SQL_Other10: TStrings read FSQLOther10 write SetOther10;
    property SQL_Other11: TStrings read FSQLOther11 write SetOther11;
    property SQL_Other12: TStrings read FSQLOther12 write SetOther12;
    property SQL_Other13: TStrings read FSQLOther13 write SetOther13;
    property SQL_Other14: TStrings read FSQLOther14 write SetOther14;
    property SQL_Other15: TStrings read FSQLOther15 write SetOther15;

  end;
    procedure Register;

implementation

constructor TDRDQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQLSelect  := TStringList.Create;
  FSQLInsert  := TStringList.Create;
  FSQLUpdate  := TStringList.Create;
  FSQLDelete  := TStringList.Create;
  FSQLOther1  := TStringList.Create;
  FSQLOther2  := TStringList.Create;
  FSQLOther3  := TStringList.Create;
  FSQLOther4  := TStringList.Create;
  FSQLOther5  := TStringList.Create;
  FSQLOther6  := TStringList.Create;
  FSQLOther7  := TStringList.Create;
  FSQLOther8  := TStringList.Create;
  FSQLOther9  := TStringList.Create;
  FSQLOther10 := TStringList.Create;
  FSQLOther11 := TStringList.Create;
  FSQLOther12 := TStringList.Create;
  FSQLOther13 := TStringList.Create;
  FSQLOther14 := TStringList.Create;
  FSQLOther15 := TStringList.Create;

end;

procedure TDRDQuery.SetSelect(Value: TStrings);
begin
  if SQL_Select.Text <> Value.Text then
  begin
    SQL_Select.BeginUpdate;
    try
      SQL_Select.Assign(Value);
    finally
      SQL_Select.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetInsert(Value: TStrings);
begin
  if SQL_Insert.Text <> Value.Text then
  begin
    SQLInsert.BeginUpdate;
    try
      SQLInsert.Assign(Value);
    finally
      SQLInsert.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetUpdate(Value: TStrings);
begin
  if SQL_Update.Text <> Value.Text then
  begin
    SQLUpdate.BeginUpdate;
    try
      SQLUpdate.Assign(Value);
    finally
      SQLUpdate.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetDelete(Value: TStrings);
begin
  if SQL_Delete.Text <> Value.Text then
  begin
    SQLDelete.BeginUpdate;
    try
      SQLDelete.Assign(Value);
    finally
      SQLDelete.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther1(Value: TStrings);
begin
  if SQL_Other1.Text <> Value.Text then begin
    SQL_Other1.BeginUpdate;
    try
      SQL_Other1.Assign(Value);
    finally
      SQL_Other1.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther2(Value: TStrings);
begin
  if SQL_Other2.Text <> Value.Text then
  begin
    SQL_Other2.BeginUpdate;
    try
      SQL_Other2.Assign(Value);
    finally
      SQL_Other2.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther3(Value: TStrings);
begin
  if SQL_Other3.Text <> Value.Text then
  begin
    SQL_Other3.BeginUpdate;
    try
      SQL_Other3.Assign(Value);
    finally
      SQL_Other3.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther4(Value: TStrings);
begin
  if SQL_Other4.Text <> Value.Text then
  begin
    SQL_Other4.BeginUpdate;
    try
      SQL_Other4.Assign(Value);
    finally
      SQL_Other4.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther5(Value: TStrings);
begin
  if SQL_Other5.Text <> Value.Text then
  begin
    SQL_Other5.BeginUpdate;
    try
      SQL_Other5.Assign(Value);
    finally
      SQL_Other5.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther6(Value: TStrings);
begin
  if SQL_Other6.Text <> Value.Text then
  begin
    SQL_Other6.BeginUpdate;
    try
      SQL_Other6.Assign(Value);
    finally
      SQL_Other6.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther7(Value: TStrings);
begin
  if SQL_Other7.Text <> Value.Text then
  begin
    SQL_Other7.BeginUpdate;
    try
      SQL_Other7.Assign(Value);
    finally
      SQL_Other7.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther8(Value: TStrings);
begin
  if SQL_Other8.Text <> Value.Text then
  begin
    SQL_Other8.BeginUpdate;
    try
      SQL_Other8.Assign(Value);
    finally
      SQL_Other8.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther9(Value: TStrings);
begin
  if SQL_Other9.Text <> Value.Text then
  begin
    SQL_Other9.BeginUpdate;
    try
      SQL_Other9.Assign(Value);
    finally
      SQL_Other9.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther10(Value: TStrings);
begin
  if SQL_Other10.Text <> Value.Text then
  begin
    SQL_Other10.BeginUpdate;
    try
      SQL_Other10.Assign(Value);
    finally
      SQL_Other10.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther11(Value: TStrings);
begin
  if SQL_Other11.Text <> Value.Text then
  begin
    SQL_Other11.BeginUpdate;
    try
      SQL_Other11.Assign(Value);
    finally
      SQL_Other11.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther12(Value: TStrings);
begin
  if SQL_Other12.Text <> Value.Text then
  begin
    SQL_Other12.BeginUpdate;
    try
      SQL_Other12.Assign(Value);
    finally
      SQL_Other12.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther13(Value: TStrings);
begin
  if SQL_Other13.Text <> Value.Text then
  begin
    SQL_Other13.BeginUpdate;
    try
      SQL_Other13.Assign(Value);
    finally
      SQL_Other13.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther14(Value: TStrings);
begin
  if SQL_Other14.Text <> Value.Text then
  begin
    SQL_Other14.BeginUpdate;
    try
      SQL_Other14.Assign(Value);
    finally
      SQL_Other14.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.SetOther15(Value: TStrings);
begin
  if SQL_Other15.Text <> Value.Text then
  begin
    SQL_Other15.BeginUpdate;
    try
      SQL_Other15.Assign(Value);
    finally
      SQL_Other15.EndUpdate;
    end;
  end;
end;

procedure TDRDQuery.CallSQL(Value: TCallSQL; lPrepare: Boolean = False);
begin
   Close;
   SQL.Clear;   // Seleciona o SQL a utilizar
   case Value of
     csSelect:  SQL.AddStrings(FSQLSelect);
     csInsert:  SQL.AddStrings(FSQLInsert);
     csUpdate:  SQL.AddStrings(FSQLUpdate);
     csDelete:  SQL.AddStrings(FSQLDelete);
     csOther1:  SQL.AddStrings(FSQLOther1);
     csOther2:  SQL.AddStrings(FSQLOther2);
     csOther3:  SQL.AddStrings(FSQLOther3);
     csOther4:  SQL.AddStrings(FSQLOther4);
     csOther5:  SQL.AddStrings(FSQLOther5);
     csOther6:  SQL.AddStrings(FSQLOther6);
     csOther7:  SQL.AddStrings(FSQLOther7);
     csOther8:  SQL.AddStrings(FSQLOther8);
     csOther9:  SQL.AddStrings(FSQLOther9);
     csOther10: SQL.AddStrings(FSQLOther10);
     csOther11: SQL.AddStrings(FSQLOther11);
     csOther12: SQL.AddStrings(FSQLOther12);
     csOther13: SQL.AddStrings(FSQLOther13);
     csOther14: SQL.AddStrings(FSQLOther14);
     csOther15: SQL.AddStrings(FSQLOther15);
   end;
//   if lPrepare then
   // Prepare;  se colocar para preparar da problema pq os parametros ainda não foram passados.

end;

destructor TDRDQuery.Destroy;
begin
   FreeAndNil( FSQLSelect );
   FreeAndNil( FSQLInsert );
   FreeAndNil( FSQLUpdate );
   FreeAndNil( FSQLDelete );
   FreeAndNil( FSQLOther1 );
   FreeAndNil( FSQLOther2 );
   FreeAndNil( FSQLOther3 );
   FreeAndNil( FSQLOther4 );
   FreeAndNil( FSQLOther5 );
   FreeAndNil( FSQLOther6 );
   FreeAndNil( FSQLOther7 );
   FreeAndNil( FSQLOther8 );
   FreeAndNil( FSQLOther9 );
   FreeAndNil( FSQLOther10 );
   FreeAndNil( FSQLOther11 );
   FreeAndNil( FSQLOther12 );
   FreeAndNil( FSQLOther13 );
   FreeAndNil( FSQLOther14 );
   FreeAndNil( FSQLOther15 );
   inherited Destroy;

end;

procedure Register;
begin
   RegisterComponents('ARTHUS', [TDRDQuery]);

end;


end.
