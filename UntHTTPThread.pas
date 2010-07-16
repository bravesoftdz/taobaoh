unit UntHTTPThread;

interface

uses
  Classes, idhttp, IdCookieManager, SysUtils, Dialogs, IdMultipartFormData;

type

  ThttpThread = class(TThread)
  private
    { Private declarations }

    http:TIDHttp;
    furl:String;

    //引用外部变量，不用释放
    fpost:TStrings;
    fbody:TStrings;
    fpostData:TIdMultiPartFormDataStream;

    //内部变量，阻塞模式时使用
    selfPost:TStrings;
    selfBody:TStrings;
    selfBodyStream:TMemoryStream;

    bget, bpost , bpostdata:boolean;
    frunonce:boolean;

    fbodystream:TMemoryStream;
    fgetstream:boolean;
  protected
    procedure Execute; override;

    procedure init(url:String);overload;
    procedure initPost(url:String; post:TStrings);overload;
    procedure init(url:String; var body:TStrings; runonce:Boolean=false);overload;
    procedure init(url:String; post:TStrings; var body:TStrings; runonce:Boolean=false);overload;
    procedure init(url:String; post:TStrings; var body:TMemoryStream; runonce:Boolean=false);overload;
    procedure init(url:String; var postdata: TIdMultiPartFormDataStream; var body:TStrings; runonce:Boolean=false);overload;

    procedure inccount();
    procedure deccount();
  public
    cookie:TIdCookieManager;
    downloading:Boolean;
    constructor Create(cookie:TIdCookieManager);
    destructor Destroy; override;

    procedure setReferer(referer:String);

    function httpGet(url: String):TStrings;
    function httpGetStream(url: String):TStream;

    function httpPost(url:String;post:TStrings):TStrings;
    function httpPostStream(url:String;postdata:TIdMultiPartFormDataStream):TStrings;

    function getRequest():TIdHTTPRequest;

    function isTerminated: boolean;

  end;

implementation

{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure listThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ listThread }


function ThttpThread.isTerminated: boolean;
begin
  result := self.Terminated;
end;

procedure ThttpThread.setReferer(referer: String);
begin
  http.Request.Referer := referer;
end;

procedure ThttpThread.Execute;
begin
  self.FreeOnTerminate := true;
  while not self.Terminated do begin
    if not downloading then continue;

    try
      try

        if bget then begin
          if fgetstream then begin
            fbodystream.Position := 0 ;
            http.Get(furl, fbodystream)
          end else
            fbody.Text := http.get(furl)
        end else if bpost then begin
          fbody.Text := http.Post(furl,fpost);
        end else begin
          fbody.Text := http.Post(furl, fpostdata);
        end;

      except
       on E:Exception do begin
          fbody.Text := e.Message;
        end;
      end;
    finally

      if frunonce then begin

        self.Terminate ;
        downloading := false;
      end else begin
        downloading := false;
      end;
    end;
  end;
end;





function ThttpThread.getRequest: TIdHTTPRequest;
begin
  result := http.Request;
end;

function ThttpThread.httppost(url: String; post: TStrings): TStrings;
begin
  bget := false;
  bpost := true;
  bpostdata := false;
  
  initPost(url, post);

  downloading := true;
  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

function ThttpThread.httpget(url: String): TStrings;
begin

  bget := true;
  bpost := false;
  bpostdata := false;

  init(url);
  downloading := true;
  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

function ThttpThread.httpGetStream(url: String): TStream;
begin
  bget := true;
  bpost := false;
  bpostdata := false;

  init(url, nil, selfBodyStream);
  downloading := true;
  self.Resume;
  while self.downloading do sleep(1);
  result := self.fbodystream;
end;

function ThttpThread.httpPostStream(url: String;postdata: TIdMultiPartFormDataStream): TStrings;
begin
  bget := false;
  bpost := false;
  bpostdata := true;

  init(url, postdata, selfBody, false);
  downloading := true;
  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

constructor ThttpThread.Create(cookie:TIdCookieManager);
var i:integer;
cookieStr :String;
begin
  inherited create(true);

  http := TIDhttp.Create(nil);

  http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.2)';
  http.HandleRedirects := true;
  http.AllowCookies := true;
  self.cookie := TIdCookieManager.Create(nil);
  http.CookieManager := self.cookie;
  if cookie <> nil then begin
    for i := 0 to cookie.CookieCollection.Count - 1 do begin
      self.cookie.AddCookie2(cookie.CookieCollection[i].CookieText, cookie.CookieCollection[i].Domain);
    end;
  end;
  



  selfBody := TStringList.Create;
  selfPost := TStringList.Create;
  selfBodyStream := TMemoryStream.Create;

  bget := false;
  bpost := false;
  bpostdata := false;

  synchronize(inccount);
end;



destructor ThttpThread.Destroy;
begin
  http.Free;
  cookie.Free;

  selfBody.Free;
  selfPost.Free;
  selfBodyStream.Free;

  synchronize(deccount);
  inherited
end;

procedure ThttpThread.deccount;
begin
 //

end;

procedure ThttpThread.inccount;
begin
  //
end;

procedure ThttpThread.init(url: String);
begin
  self.furl := url;
  self.fbody := selfBody;
  self.frunonce := false;
  self.fgetstream := false;

  self.fpost := selfPost;
end;

procedure ThttpThread.init(url: String; post: TStrings; var body: TMemoryStream; runonce: Boolean=false);
begin
  self.furl := url;
  self.fbodystream := body;
  self.frunonce := runonce;
  self.fgetstream := true;

  self.fpost := post;
end;

procedure ThttpThread.init(url: String; post: TStrings;var body:TStrings;runonce:Boolean=false);
begin
  self.furl := url;
  self.fbody := body;
  self.frunonce := runonce;
  self.fgetstream := false;

  self.fpost := post;
end;


procedure ThttpThread.init(url: String; var postdata: TIdMultiPartFormDataStream;var body:TStrings;runonce:Boolean=false);
begin
  self.furl := url;
  self.fbody := body;
  self.frunonce := runonce;
  self.fgetstream := false;

  self.fpostData := postdata;
end;


procedure ThttpThread.initPost(url: String; post: TStrings);
begin
  self.furl := url;
  self.fbody := selfBody;
  self.frunonce := false;
  self.fgetstream := false;

  self.fpost := post;
end;

procedure ThttpThread.init(url: String; var body: TStrings;
  runonce: Boolean);
begin
  self.furl := url;
  self.fbody := body;
  self.frunonce := runonce;
  self.fgetstream := false;
end;

end.
