inherited BackendDelphiCadastro: TBackendDelphiCadastro
  Width = 425
  object qryPesquisa: TFDQuery
    Connection = Connection
    Left = 200
    Top = 32
  end
  object qryRecordCount: TFDQuery
    Connection = Connection
    Left = 320
    Top = 32
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
  object qryCadastro: TFDQuery
    Connection = Connection
    Left = 200
    Top = 88
  end
end
