unit UntPlugin_autohome50_5;

interface

uses
UntMission, IdCookieManager, UntHTTPThread, SysUtils, iniFiles, Forms, IdMultipartFormData;

type
  TAutohome50_5 = class(TMission)
  private
    { Private declarations }
  protected
    function login:Boolean;OverLoad;
  public
    { Public declarations }
    procedure start;OverLoad;
    procedure replyTest;
  end;

implementation


{ TAutohome50_5 }

function TAutohome50_5.login:Boolean;
var account:TAccount;
http:THTTPThread;
loginUrl:String;
begin
  account := self.mc.getNextAccount;
  loginUrl := self.mc.loginUrl;
  loginUrl := StringReplace(loginUrl, '$name$', account.name, [rfReplaceAll]);
  loginUrl := StringReplace(loginUrl, '$password$', account.password, [rfReplaceAll]);
  http := self.getHTTPThread(nil);
  self.lastHttpResponse.Text := http.httpPost(loginUrl, nil).Text;
  self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);

  killHttpThread(http);
  result := true;
end;


procedure TAutohome50_5.replyTest;
var
http:THTTPThread;
postdata: TIdMultiPartFormDataStream;
body, action, validform:String;
account:TAccount;
loginUrl:String;
begin
  account := self.mc.getNextAccount;
  loginUrl := self.mc.loginUrl;
  loginUrl := StringReplace(loginUrl, '$name$', account.name, [rfReplaceAll]);
  loginUrl := StringReplace(loginUrl, '$password$', account.password, [rfReplaceAll]);
  http := self.getHTTPThread(nil);
  http.httpPost(loginUrl, nil);
  //self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);

  //http := self.getHTTPThread(self.lastHttpCookie);
  self.lastHttpResponse.Text := http.httpGet('http://club.autohome.com.cn/bbs/thread-c-153-6170009-1.html').Text;
  body := copy(self.lastHttpResponse.Text,
    pos('id="postform" action="',self.lastHttpResponse.Text) + length('id="postform" action="'), length(self.lastHttpResponse.Text));
  action := copy(body, 1, pos('"', body)-1);
  body := copy(body, pos('validform" value=''', body)+ length('validform" value='''), length(body));
  validform := copy(body, 1, pos('''', body)-1);
  body := self.mc.getNextContent;

  postdata := TIdMultiPartFormDataStream.Create;
  postdata.AddFormField('target', '');
  postdata.AddFormField('txtContent', body);
  postdata.AddFormField('upPic', '');
  postData.AddFormField('validform', validform);
  postData.AddFormField('validcode', '9852');

  //9852µÄÑéÖ¤cookie
  http.cookie.AddCookie('validcode=t%2fe8lKsa1QdrlUhWNCba%2bQ%3d%3d', '.autohome.com.cn');
  self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);

  self.lastHttpResponse.Clear;
  self.lastHttpResponse.Text := http.httpPostStream('http://club.autohome.com.cn/bbs/'+action, postData).Text;
  self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);
end;

procedure TAutohome50_5.start;
var iniFile:TIniFile;
http:THTTPThread;
begin
  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'mission.ini');
  init(iniFile, 'autohome_50*5');
  //login;

  //http := self.getHTTPThread(self.lastHttpCookie);
  //self.lastHttpResponse := http.httpGet(self.mc.boardUrl);
end;

end.
