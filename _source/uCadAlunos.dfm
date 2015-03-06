inherited FrmCadAlunos: TFrmCadAlunos
  Caption = 'Cadastro de Alunos'
  ClientHeight = 451
  ClientWidth = 811
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 827
  ExplicitHeight = 490
  PixelsPerInch = 96
  TextHeight = 13
  inherited FlatPanel1: TFlatPanel
    Width = 811
    inherited pnlCabecalho: TPanel
      Width = 809
      inherited sbpMax: TAdvGlowButton
        Left = 731
      end
      inherited SpbSair: TAdvGlowButton
        Left = 762
      end
    end
  end
  inherited TabPages: TRzPageControl
    Width = 811
    Height = 420
    ExplicitLeft = 0
    ExplicitTop = 31
    FixedDimension = 19
    inherited TbShTabela: TRzTabSheet
      ExplicitWidth = 807
      ExplicitHeight = 394
      inherited DbgBusca: TJvDBGrid
        Width = 802
        Height = 356
      end
      inherited PnlCustomGrid: TPanel
        Top = 370
        Width = 807
        ExplicitTop = 370
        ExplicitWidth = 807
      end
    end
  end
end
