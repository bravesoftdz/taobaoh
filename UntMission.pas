unit UntMission;

interface

uses
inifiles, IdCookieManager;

type
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
  public
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
  end;

  TMission = class(TObject)
  private
    procedure cookieSet;
    { Private declarations }
  protected
    mc :TMissionConfig;
    procedure cookieSendSet;
    function login:TIdCookieManager;
  public
    { Public declarations }
    constructor create;
    destructor destroy;Override;
    procedure init(iniFile:TIniFile; name:String);
    procedure start;
  end;

implementation

{ TMission }

procedure TMission.cookieSendSet;
begin

end;

procedure TMission.cookieSet;
begin

end;

constructor TMission.create;
begin
  mc := TMissionConfig.Create;
end;

destructor TMission.destroy; 
begin
  mc.Free;
  inherited;
end;

procedure TMission.init(iniFile: TIniFile; name: String);
begin
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
end;

function TMission.login:TIdCookieManager;
begin

end;

procedure TMission.start;
begin

end;


{ TMissionConfig }

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

procedure TMissionConfig.setLoginUrl(const Value: String);
begin
  floginUrl := Value;
end;

procedure TMissionConfig.setSendTimer(const Value: Integer);
begin
  fsendTimer := Value;
end;

procedure TMissionConfig.setSendType(const Value: String);
begin
  fsendType := Value;
end;

end.
