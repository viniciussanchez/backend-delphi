unit Backend.Delphi.Cadastro;

interface

uses System.SysUtils, System.Classes, Backend.Delphi.Connection, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON, System.Generics.Collections;

type
  TBackendDelphiCadastro = class(TBackendDelphiConnection)
    qryPesquisa: TFDQuery;
    qryRecordCount: TFDQuery;
    qryCadastro: TFDQuery;
    qryRecordCountCOUNT: TLargeintField;
  private
    procedure SetOrdenacao(const AQuery: TFDQuery; const AQueryParams: TDictionary<string, string>);
    procedure SetPaginacao(const AQuery: TFDQuery; const AQueryParams: TDictionary<string, string>);
  protected
    function GetQuerysPesquisa: TArray<TFDQuery>;
  public
    function GetRecordCount: Int64; virtual;
    function ListAll(const AQueryParams: TDictionary<string, string>): TDataSet; virtual;
    function GetById(const AId: Int64): TDataSet; virtual;
    function Append(const AValue: TJSONObject): Boolean; virtual;
    function Update(const AValue: TJSONObject): Boolean; virtual;
    function Delete: Boolean; virtual;
  end;

var
  BackendDelphiCadastro: TBackendDelphiCadastro;

implementation

{$R *.dfm}

uses DataSet.Serialize;

function TBackendDelphiCadastro.Append(const AValue: TJSONObject): Boolean;
begin
  qryCadastro.SQL.Add('where id is null');
  qryCadastro.Open();
  qryCadastro.LoadFromJSON(AValue, False);
  Result := True;
end;

function TBackendDelphiCadastro.Delete: Boolean;
begin
  qryCadastro.Delete;
  Result := True;
end;

function TBackendDelphiCadastro.GetById(const AId: Int64): TDataSet;
begin
  qryCadastro.SQL.Add('where id = :id');
  qryCadastro.ParamByName('id').AsLargeInt := AId;
  qryCadastro.Open();
  Result := qryCadastro;
end;

function TBackendDelphiCadastro.GetQuerysPesquisa: TArray<TFDQuery>;
begin
  Result := [qryPesquisa, qryRecordCount];
end;

function TBackendDelphiCadastro.GetRecordCount: Int64;
begin
  qryRecordCount.Open();
  Result := qryRecordCountCOUNT.AsLargeInt;
end;

function TBackendDelphiCadastro.ListAll(const AQueryParams: TDictionary<string, string>): TDataSet;
begin
  Self.SetOrdenacao(qryPesquisa, AQueryParams);
  Self.SetPaginacao(qryPesquisa, AQueryParams);
  qryPesquisa.Open();
  Result := qryPesquisa;
end;

procedure TBackendDelphiCadastro.SetOrdenacao(const AQuery: TFDQuery; const AQueryParams: TDictionary<string, string>);
begin
  if not AQueryParams.ContainsKey('sort') then
    Exit;
  var LSQLOrdenacao: string;
  var LOrdenacoes := AQueryParams.Items['sort'].Split([';']);
  for var LOrdenacao in LOrdenacoes do
  begin
    var LDadosOrdenacao := LOrdenacao.Split([',']);
    var LFieldName := LDadosOrdenacao[0];
    if Assigned(AQuery.Fields.FindField(LFieldName)) then
    begin
      if not LSQLOrdenacao.Trim.IsEmpty then
        LSQLOrdenacao := LSQLOrdenacao + ', ';
      LSQLOrdenacao := LSQLOrdenacao + LFieldName;
      if Length(LDadosOrdenacao) = 2 then
      begin
        var LTipoOrdenacao := LDadosOrdenacao[1].Trim.ToLower;
        if LTipoOrdenacao.Equals('asc') or LTipoOrdenacao.Equals('desc') then
          LSQLOrdenacao := LSQLOrdenacao + ' ' + LTipoOrdenacao;
      end;
    end;
  end;
  if not LSQLOrdenacao.Trim.IsEmpty then
    AQuery.SQL.Add('order by ' + LSQLOrdenacao);
end;

procedure TBackendDelphiCadastro.SetPaginacao(const AQuery: TFDQuery; const AQueryParams: TDictionary<string, string>);
begin
  if AQueryParams.ContainsKey('limit') then
  begin
    AQuery.FetchOptions.RecsMax := StrToIntDef(AQueryParams.Items['limit'], 50);
    AQuery.FetchOptions.RowsetSize := AQuery.FetchOptions.RecsMax;
  end;
  if AQueryParams.ContainsKey('offset') then
    AQuery.FetchOptions.RecsSkip := StrToIntDef(AQueryParams.Items['offset'], 0);
end;

function TBackendDelphiCadastro.Update(const AValue: TJSONObject): Boolean;
begin
  qryCadastro.MergeFromJSONObject(AValue, False);
  Result := True;
end;

end.
