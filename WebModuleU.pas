unit WebModuleU;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp,
Data.DBXJSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Moni.Base, FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, System.JSON,
  FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TwmMain = class(TWebModule)
    dbConnection: TFDConnection;
    cmdInsertContact: TFDCommand;
    qryContacts: TFDQuery;
    cmdUpdateContact: TFDCommand;
    WebFileDispatcher1: TWebFileDispatcher;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    procedure wmMainDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMainwaGetContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wmMainwaDeleteContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wmMainwaSaveContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure dbConnectionBeforeConnect(Sender: TObject);
  private
    procedure PrepareResponse(AJSONValue: TJSONValue; AWebResponse: TWebResponse);
  end;

var
  WebModuleClass: TComponentClass = TwmMain;

implementation

{$R *.dfm}


uses
  ObjectsMappers, {this unit comes from delphimvcframework project}
  System.RegularExpressions,
  System.IOUtils;

procedure TwmMain.wmMainDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.SendRedirect('/index.html');
end;

procedure TwmMain.wmMainwaDeleteContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  dbConnection.ExecSQL('DELETE FROM CONTACTS WHERE CODE = ?', [Request.ContentFields.Values['code']]);
  PrepareResponse(nil, Response);
end;

procedure TwmMain.wmMainwaGetContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JContacts: TJSONArray;
  SQL: string;
  OrderBy: string;
begin
  SQL := 'SELECT FIRST 20 FIO, SEX, HOMEPHONE, CELURARPHONE, EMAIL FROM CONTACTS ';
  OrderBy := Request.QueryFields.Values['jtSorting'];
  if OrderBy.IsEmpty then
    SQL := SQL + 'ORDER BY FIO ASC'
  else
  begin
    if TRegEx.IsMatch(OrderBy, '^[A-Z,_]+[ ]+(ASC|DESC)$', [roIgnoreCase]) then
      SQL := SQL + 'ORDER BY ' + OrderBy.ToUpper
    else
      raise Exception.Create('Invalid order clause syntax');
  end;

  // execute query and prepare response
  qryContacts.Open(SQL);
  try
    JContacts := qryContacts.AsJSONArray;
  finally
    qryContacts.Close;
  end;
  PrepareResponse(JContacts, Response);
end;

procedure TwmMain.wmMainwaSaveContactAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  InsertMode: Boolean;
  JObj: TJSONObject;
  LastID: Integer;
  HTTPFields: TStrings;
  procedure MapStringsToParams(AStrings: TStrings; AFDParams: TFDParams);
  var
    i: Integer;
  begin
    for i := 0 to HTTPFields.Count - 1 do
    begin
      if AStrings.ValueFromIndex[i].IsEmpty then
        AFDParams.ParamByName(AStrings.Names[i].ToUpper).Clear()
      else
        AFDParams.ParamByName(AStrings.Names[i].ToUpper).Value :=
          AStrings.ValueFromIndex[i];
    end;
  end;

begin
  HTTPFields := Request.ContentFields;
  InsertMode := HTTPFields.IndexOfName('id') = -1;
  if InsertMode then
  begin
    MapStringsToParams(HTTPFields, cmdInsertContact.Params);
    cmdInsertContact.Execute();
    LastID := dbConnection.GetLastAutoGenValue('GEN_CONTACTS_ID');
  end
  else
  begin
    MapStringsToParams(HTTPFields, cmdUpdateContact.Params);
    cmdUpdateContact.Execute();
    LastID := StrToIntDef(HTTPFields.Values['code'], 0);
  end;

  // execute query and prepare response
  qryContacts.Open('SELECT * FROM CONTACTS WHERE CODE = ?', [LastID]);
  try
    PrepareResponse(qryContacts.AsJSONObject, Response);
    //qryContacts.AsJSONArrayString;
  finally
    qryContacts.Close;
  end;
end;

procedure TwmMain.dbConnectionBeforeConnect(Sender: TObject);
begin
  dbConnection.Params.Values['Database'] :=
    TPath.GetDirectoryName(WebApplicationFileName) +
    '\DATA\IVIEWER_UTF.FDB';
  dbConnection.Params.Values['CharacterSet'] :=
    'UTF8';
end;

procedure TwmMain.PrepareResponse(AJSONValue: TJSONValue; AWebResponse: TWebResponse);
var
  JObj: TJSONObject;
begin
  JObj := TJSONObject.Create;
  try
    JObj.AddPair('Result', 'OK');
    if Assigned(AJSONValue) then
    begin
      if AJSONValue is TJSONArray then
      begin
        JObj.AddPair('Records', AJSONValue);
        JObj.AddPair('TotalRecordCount', IntToStr((AJSONValue as TJSONArray).Count));
      end
      else
        JObj.AddPair('Record', AJSONValue)
    end;
    AWebResponse.Content := JObj.ToString;
    AWebResponse.StatusCode := 200;
    AWebResponse.ContentType := 'application/json; charset=utf-8';
  finally
    JObj.Free;
  end;
end;

end.
