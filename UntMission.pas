unit UntMission;

interface

uses
classes, inifiles, IdCookieManager, UntHTTPThread, UntCommon;

type
  TAccount = class(TObject)
  private
    fname: String;
    fpassword: String;
    procedure setName(const Value: String);
    procedure setPassword(const Value: String);
  public
    property name     :String read fname      write setName;
    property password :String read fpassword  write setPassword;
  end;

  TMissionConfig = class(TObject)
  private
    flistTimer:Integer;
    fsendTimer: Integer;
    fcontentBoardId: String;
    fcontentId: String;
    fsendType: String;
    fcontentType: String;
    fcontent: String;
    flistBegin: String;
    flineTag: String;
    fboardUrl: String;
    floginUrl: String;
    floginType: String;
    faccounts: String;

    currentAccountIndex:Integer;
    currentContentIndex:Integer;
    accountList:TStringList;
    contentList:TStringList;
    fname: String;
    procedure setName(const Value: String);

    procedure setAccounts(const Value: String);
    procedure setLoginType(const Value: String);
    procedure setBoardUrl(const Value: String);
    procedure setLineTag(const Value: String);
    procedure setListBegin(const Value: String);
    procedure setLoginUrl(const Value: String);
    procedure setContent(const Value: String);
    procedure setContentBoardId(const Value: String);
    procedure setContentId(const Value: String);
    procedure setContentType(const Value: String);
    procedure setListTimer(const Value: Integer);
    procedure setSendTimer(const Value: Integer);
    procedure setSendType(const Value: String);


    procedure initAccountSet();
    procedure initContentSet();
  public
    property name           :String   read fname            write setName;
    property listTimer      :Integer  read flistTimer       write setListTimer;
    property sendTimer      :Integer  read fsendTimer       write setSendTimer;
    property sendType       :String   read fsendType        write setSendType;
    property contentType    :String   read fcontentType     write setContentType;
    property content        :String   read fcontent         write setContent;
    property contentBoardId :String   read fcontentBoardId  write setContentBoardId;
    property contentId      :String   read fcontentId       write setContentId;
    property boardUrl       :String   read fboardUrl        write setBoardUrl;
    property listBegin      :String   read flistBegin       write setListBegin;
    property lineTag        :String   read flineTag         write setLineTag;
    property loginUrl       :String   read floginUrl        write setLoginUrl;
    property accounts       :String   read faccounts        write setAccounts;
    property loginType      :String   read floginType       write setLoginType;

    function getNextAccount:TAccount;
    function getNextContent:String;

    constructor create;
  end;

  TMission = class(TThread)
  private
    procedure cookieSet;
    { Private declarations }
  protected
    //成功数， 总请求数， 状态(0停止 ，1运行)
    successCount, requestCount, state:Integer;
    logon:Boolean;
    httpThreads :TStringList;
    mc :TMissionConfig;
    procedure cookieSendSet;
    function login:Boolean;
    function getHTTPThread(cookie:TIdCookieManager):THTTPThread;
    procedure killHTTPThread(http:THTTPThread);

    procedure Execute;virtual;
  public
    { Public declarations }
    lastHttpResponse:TStrings;
    lastHttpCookie:TIdCookieManager;
    constructor create(iniFile:TIniFile; name:String);
    destructor destroy;Override;
    //加载任务属性
    procedure init(iniFile:TIniFile; name:String);
    procedure start;
    procedure stop;
    function getCurrentThreads:Integer;
    function getSuccessCount:Integer;
    function getRequestCount:Integer;
    function getState:Integer;
    function getStateName:String;
    function getMissionName:String;
  end;

implementation

{ TMission }

function TMission.getHTTPThread(cookie:TIdCookieManager): THTTPThread;
var http:THTTPThread;
begin
  http := THTTPThread.create(cookie);
  httpThreads.AddObject('', http);
  result := http;
end;

function TMission.getMissionName: String;
begin
  result := mc.name;
end;

function TMission.getRequestCount: Integer;
begin
  result := requestCount;
end;

function TMission.getState: Integer;
begin
  result := state;
end;

function TMission.getStateName: String;
begin
  if state = 0 then
    result := '停止'
  else
    result := '运行中';
end;

function TMission.getSuccessCount: Integer;
begin
  result := successCount; 
end;

procedure TMission.cookieSendSet;
begin

end;

procedure TMission.cookieSet;
begin

end;

constructor TMission.create(iniFile:TIniFile; name:String);
begin
  inherited create(true);

  mc := TMissionConfig.Create;
  httpThreads := TStringList.Create;
  lastHttpResponse := TStringList.Create;
  lastHttpCookie := TIdCookieManager.Create(nil);
  successCount := 0;

  init(iniFile, name);
end;

destructor TMission.destroy; 
begin
  mc.Free;
  httpThreads.Free;
  lastHttpResponse.Free;
  lastHttpCookie.Free;

  inherited;
end;

procedure TMission.Execute;
begin

end;

function TMission.getCurrentThreads: Integer;
var i:Integer;
begin
  for  i:= httpThreads.Count - 1 downto 0 do begin
    if (httpThreads.Objects[i] = nil) then
      httpThreads.Delete(i);
  end;
  result := httpThreads.Count;
end;

procedure TMission.init(iniFile: TIniFile; name: String);
begin
  mc.name := name;
  mc.flistTimer := iniFile.ReadInteger(name, 'listTimer', 0);
  mc.fsendTimer := iniFile.ReadInteger(name, 'sendTimer', 0);
  mc.fcontentBoardId := iniFile.ReadString(name, 'contentBoardId', '');
  mc.fcontentId := iniFile.ReadString(name, 'contentId', '');
  mc.fsendType :=  iniFile.ReadString(name, 'sendType', '');
  mc.fcontentType := iniFile.ReadString(name, 'contentType', '');
  mc.fcontent := iniFile.ReadString(name, 'content', '');
  mc.flistBegin := iniFile.ReadString(name, 'listBegin', '');
  mc.flineTag := iniFile.ReadString(name, 'lineTag', '');
  mc.fboardUrl := iniFile.ReadString(name, 'boardUrl', '');
  mc.floginUrl := iniFile.ReadString(name, 'loginUrl', '');
  mc.faccounts := iniFile.ReadString(name, 'accounts', '');
  mc.floginType := iniFile.ReadString(name, 'loginType', '');
end;

procedure TMission.killHTTPThread(http: THTTPThread);
begin
  httpThreads.Delete(httpThreads.IndexOfObject(http)); 
  http.Terminate;
end;

function TMission.login:Boolean;
begin
  logon := true;
end;

procedure TMission.start;
begin
  state := 1;
end;


procedure TMission.stop;
begin
  state := 0;
end;

{ TMissionConfig }

constructor TMissionConfig.create;
begin
  currentAccountIndex := -1;
  currentContentIndex := -1;
end;

function TMissionConfig.getNextAccount: TAccount;
begin
  if accountList = nil then
    self.initAccountSet;

  if accountList.Count = 0 then result := nil;
  
  {
  ;登录类型 ran （随机) list（循环）
  loginType=
  }
  if loginType = 'ran' then begin
    Randomize;
    currentAccountIndex := Random(accountList.Count);
  end else begin
    inc(currentAccountIndex);
    if currentAccountIndex >= accountList.Count then begin
      currentAccountIndex := 0;
    end;
  end;
  result := TAccount(accountList.objects[currentAccountIndex]);
end;

function TMissionConfig.getNextContent: String;
begin
  if contentList = nil then
    self.initContentSet;

  if contentList.Count = 0 then result := '';

  {;内容类型 ran（随机) all（全部）
  contentType=}
  if contentType = 'ran' then begin
    Randomize;
    currentContentIndex := Random(contentList.Count);
    result := contentList.Strings[currentContentIndex];
  end else begin
    result := contentList.Text;
  end;
end;

procedure TMissionConfig.initAccountSet;
var 
accountArray:TStringList;
i:Integer;
accountString:String;
account:TAccount;
begin
  accountList := TStringList.Create;
  accountArray := SplitString(self.accounts, '|');
  for i := 0 to accountArray.Count - 1 do begin
    accountString := accountArray.Strings[i];
    account := TAccount.Create;
    account.name := copy(accountString, 1, pos(':', accountString)-1);
    account.password := copy(accountString, pos(':', accountString)+1, length(accountString));
    accountList.AddObject('', account);
  end;
end;

procedure TMissionConfig.initContentSet;
begin
  contentList := SplitString(self.fcontent, '|');
end;

procedure TMissionConfig.setAccounts(const Value: String);
begin
  faccounts := Value;
end;

procedure TMissionConfig.setBoardUrl(const Value: String);
begin
  fboardUrl := Value;
end;

procedure TMissionConfig.setContent(const Value: String);
begin
  fcontent := Value;
end;

procedure TMissionConfig.setContentBoardId(const Value: String);
begin
  fcontentBoardId := Value;
end;

procedure TMissionConfig.setContentId(const Value: String);
begin
  fcontentId := Value;
end;

procedure TMissionConfig.setContentType(const Value: String);
begin
  fcontentType := Value;
end;

procedure TMissionConfig.setLineTag(const Value: String);
begin
  flineTag := Value;
end;

procedure TMissionConfig.setListBegin(const Value: String);
begin
  flistBegin := Value;
end;

procedure TMissionConfig.setListTimer(const Value: Integer);
begin
  flistTimer := Value;
end;

procedure TMissionConfig.setLoginType(const Value: String);
begin
  floginTYpe := Value;
end;

procedure TMissionConfig.setLoginUrl(const Value: String);
begin
  floginUrl := Value;
end;

procedure TMissionConfig.setName(const Value: String);
begin
  fname := Value;
end;

procedure TMissionConfig.setSendTimer(const Value: Integer);
begin
  fsendTimer := Value;
end;

procedure TMissionConfig.setSendType(const Value: String);
begin
  fsendType := Value;
end;

{ TAccount }

procedure TAccount.setName(const Value: String);
begin
  fname := Value;
end;

procedure TAccount.setPassword(const Value: String);
begin
  fpassword := Value;
end;

end.
