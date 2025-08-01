object BackendDelphiConnection: TBackendDelphiConnection
  Height = 236
  Width = 178
  object Connection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Shopping_Pooled')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 72
    Top = 32
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    Left = 72
    Top = 88
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 72
    Top = 144
  end
end
