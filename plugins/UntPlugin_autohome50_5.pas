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
    procedure Execute;Override;
  public
    { Public declarations }
    procedure start;overload;
    procedure reply;
  end;

implementation

uses UntInputValidCode;


{ TAutohome50_5 }

procedure TAutohome50_5.Execute;
begin
  inherited;
  while not self.Terminated do begin
    if not self.logon then login;

    reply;
    sleep(mc.sendTimer);
  end;
end;

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
  inherited login;
  result := true;
end;


procedure TAutohome50_5.reply;
var
http:THTTPThread;
postdata: TIdMultiPartFormDataStream;
body, action, validform, validcode, topicId:String;
account:TAccount;
url:String;
frmInputValidCode:TFrmInputValidCode;
begin
  http := self.getHTTPThread(self.lastHttpCookie);

  url := mc.boardUrl;
  self.lastHttpResponse.Text := http.httpGet(url).Text;
  body := copy(self.lastHttpResponse.Text, pos(mc.listBegin, self.lastHttpResponse.Text)+length(mc.listBegin),
              length(self.lastHttpResponse.Text));

  //<tr *><td *>*</td>*<a *href="/bbs/thread-c-$contentBoardId$-#contentId#-1.html"*>#title#</a>*<td *>*<a *>#author#</a>*</td><td class="nums">*</td></tr>

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
  //postdata.AddFormField('upPic', '');
  postData.AddFormField('validform', validform);

  frmInputValidCode := TFrmInputValidCode.Create(nil);
  validcode := frmInputValidCode.showImg(http.httpGetStream('http://club.autohome.com.cn/validcodeimage.aspx?0.7975265414743804'));
  postData.AddFormField('validcode', validcode);

  //5567µÄÑéÖ¤cookie    http://club.autohome.com.cn/validcodeimage.aspx?0.7975265414743804
  //http.cookie.AddCookie('validcode=Gokj%2bk%2fIfLKLZqUFn31MVQ%3d%3d', '.autohome.com.cn');

  self.lastHttpResponse.Clear;
  http.setReferer('http://club.autohome.com.cn/bbs/thread-c-153-6170009-1.html');
  self.lastHttpResponse.Text := http.httpPostStream('http://club.autohome.com.cn/bbs/'+action, postData).Text;
  self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);

  self.killHTTPThread(http);
end;

procedure TAutohome50_5.start;
begin
  inherited;
end;

end.
