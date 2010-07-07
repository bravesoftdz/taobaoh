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

    function httpGet(url: String):TStrings;
    //procedure httpGetStream(url: String;var body:TMemoryStream;runonce:Boolean=false);overload;

    function httpPost(url:String;post:TStrings):TStrings;
    function httpPostStream(url:String;postdata:TIdMultiPartFormDataStream):TStrings;

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

procedure ThttpThread.Execute;
begin
  self.FreeOnTerminate := true;
  while not self.Terminated do begin
    try
      try
        downloading := true;

        if bget then begin
          if fgetstream then 
            http.Get(furl, fbodystream)
          else
            fbody.Text := http.get(furl)
        end else if bpost then begin
          fbody.Text := http.Post(furl,fpost);
        end else begin
          fbody.Text := http.Post(furl, fpostdata);
        end;

      except
       on E:Exception do begin
          {showmessage(e.message+#13#10+
                      'url:'+furl+#13#10+
                      '');}
        end;
      end;
    finally

      if frunonce then begin

        self.Terminate ;
        downloading := false;
      end else begin
        downloading := false;
        self.Suspend;
      end;
    end;
  end;
end;





function ThttpThread.httppost(url: String; post: TStrings): TStrings;
begin
  downloading := true;
  bget := false;
  bpost := true;
  bpostdata := false;
  
  initPost(url, post);

  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

function ThttpThread.httpget(url: String): TStrings;
begin
  downloading := true;
  bget := true;
  bpost := false;
  bpostdata := false;

  init(url);
  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

function ThttpThread.httpPostStream(url: String;postdata: TIdMultiPartFormDataStream): TStrings;
begin
  downloading := true;
  bget := false;
  bpost := false;
  bpostdata := true;

  init(url, postdata, selfBody, false);
  self.Resume;
  while self.downloading do sleep(1);
  result := fbody;
end;

constructor ThttpThread.Create(cookie:TIdCookieManager);
begin
  inherited create(true);
  
  self.cookie := TIdCookieManager.Create(nil);
  if cookie <> nil then
    self.cookie.CookieCollection.Assign(cookie.CookieCollection);

  http := TIDhttp.Create(nil);
  http.CookieManager := self.cookie;
  http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.2)';
  http.HandleRedirects := true;
  http.ProtocolVersion :=   pv1_0;

  selfBody := TStringList.Create;
  selfPost := TStringList.Create;

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
