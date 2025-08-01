unit Backend.Delphi.Connection;

interface

uses System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PGDef,
  FireDAC.ConsoleUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client;

type
  TBackendDelphiConnection = class(TDataModule)
    Connection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
  public
    constructor Create; reintroduce;
  end;

var
  BackendDelphiConnection: TBackendDelphiConnection;

implementation

{$R *.dfm}

constructor TBackendDelphiConnection.Create;
begin
  inherited Create(nil);
end;

end.
