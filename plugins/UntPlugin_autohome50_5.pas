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
    procedure start;Override;
    procedure reply;
  end;

implementation

uses UntInputValidCode, PerlRegEx, UntLog, UntMain;


{ TAutohome50_5 }

procedure TAutohome50_5.Execute;
begin
  while not self.Terminated do begin
    //if not self.logon then login;

    reply;

  end;
end;

function TAutohome50_5.login:Boolean;
var account:TAccount;
http:THTTPThread;
loginUrl:String;
begin
  http := self.getHTTPThread(nil);
  try
    account := self.mc.getNextAccount;
    loginUrl := self.mc.loginUrl;
    loginUrl := StringReplace(loginUrl, '$name$', account.name, [rfReplaceAll]);
    loginUrl := StringReplace(loginUrl, '$password$', account.password, [rfReplaceAll]);
    try
      self.lastHttpResponse.Text := http.httpPost(loginUrl, nil).Text;
      self.lastHttpCookie.CookieCollection.Assign(http.cookie.CookieCollection);
      self.lastHttpRequest.Add(http.getRequest.RawHeaders.Text);
    except
      on e:Exception do begin
        error(e.Message);
      end;
    end;
  finally
    killHttpThread(http);
    inherited login;
    result := true;
  end;
end;


procedure TAutohome50_5.reply;
var
http:THTTPThread;
postdata: TIdMultiPartFormDataStream;
body, action, validform, validcode, topicUrl:String;
url:String;
regList, regTopic: TPerlRegEx;
begin
  login;
  http := self.getHTTPThread(self.lastHttpCookie);
  regList := TPerlRegEx.Create(nil);
  regTopic := TPerlRegEx.Create(nil);
  try
    try
      url := mc.boardUrl;
      httpGet(http, url);

      body := copy(self.lastHttpResponse.Text, pos(mc.listBegin, self.lastHttpResponse.Text)+length(mc.listBegin),
                  length(self.lastHttpResponse.Text));
      //<tr *><td *>*</td>*<a *href="/bbs/thread-c-$contentBoardId$-#contentId#-1.html"*>#title#</a>*<td *>*<a *>#author#</a>*</td><td class="nums">*</td></tr>
      {

      <tbody><tr style="height:30px;">
            <td class="icon">&nbsp;</td>
            <th class="hot" ><span id="thread_TitleUp" >
            <a target="_blank" style="font-size:14px;"
            href="/bbs/thread-c-624-7299235-1.html"
            title="¡°xxx">xxx</a></span><font color=red style="font-size:9px;">NEW</font>¡¡
            </th><td class="author"><cite>
            <a href="/blog/1891280/" target=_blank title="xueyue1119">xueyue1119</a>
            </cite><em>2010-07-08</em></td><td class="nums">
            <strong id="commonreply7299235"></strong>/<em id="commonview7299235"></em>
            </td><td class="lastpost" style="width:150px;"><em>2010-7-08 15:55</em><cite>
            <a href='/blog/1022159/' target="_blank" title="xx">xx</a></cite></td></tr></tbody>
      }

      regList.Subject := body;
      regList.RegEx := '<tbody>.*?<a target="_blank".*?href="(.*?)".*?</tbody>';

      while regList.MatchAgain do
      begin
        topicUrl := 'http://club.autohome.com.cn' + regList.SubExpressions[1];
        httpGet(http, topicUrl);

        regTopic.Subject := self.lastHttpResponse.Text;
        regTopic.RegEx := 'id="postform" action="(.*?)"';
        if regTopic.MatchAgain then begin
          action := regTopic.SubExpressions[1];
          regTopic.RegEx := 'validform" value=''(.*?)''';
          if regTopic.MatchAgain then
            validform := regTopic.SubExpressions[1];
        end else begin
          //µÇÂ¼Ê§°Ü£¿
          stop;
          exit;
        end;

        body := self.mc.getNextContent;
    
        postdata := TIdMultiPartFormDataStream.Create;
        postdata.AddFormField('target', '');
        postdata.AddFormField('txtContent', body);
        postData.AddFormField('validform', validform);
        validcode := getValidCode(httpGetStream(http, 'http://club.autohome.com.cn/validcodeimage.aspx?0.'+floattostr(now)));
        postData.AddFormField('validcode', validcode);

        http.setReferer(topicUrl);
        httpPostStream(http, 'http://club.autohome.com.cn/bbs/'+action, postData);

        inc(self.successCount);
        self.Delay(mc.sendTimer);
      end;
    except
      on E:Exception do error(e.Message);
    end;
  finally
    self.killHTTPThread(http);
    regTopic.Free;
    regList.Free;
  end;
end;

procedure TAutohome50_5.start;
begin
  inherited;
  self.Resume;
end;

end.
