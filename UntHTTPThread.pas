unit UntHTTPThread;

interface

uses
  Classes, idhttp, IdCookieManager, SysUtils, Dialogs, IdMultipartFormData;

type

  ThttpThread = class(TThread)
  private
    { Private declarations }

    http:TIDHttp;
    cookie:TIdCookieManager;
    furl:String;
    fpost:TStrings;
    fpostData:TIdMultiPartFormDataStream;
    bget, bpost , bpostdata:boolean;
    frunonce:boolean;
    fbody:TStrings;
    fbodystream:TMemoryStream;
    fgetstream:boolean;
  protected
    procedure Execute; override;
    procedure init(url:String; var body:TStrings; runonce:Boolean=false);overload;
    procedure init(url:String; post:TStrings; var body:TStrings; runonce:Boolean=false);overload;
    procedure init(url:String; post:TStrings; var body:TMemoryStream; runonce:Boolean=false);overload;
    procedure init(url:String; var postdata: TIdMultiPartFormDataStream; var body:TStrings; runonce:Boolean=false);overload;
  public
    downloading:Boolean;
    constructor createex(cookie:TIdCookieManager);
    destructor Destroy; override;
    procedure httpget(url: String;var body:TMemoryStream;runonce:Boolean=false);overload;
    procedure httpget(url: String;var body:TStrings;runonce:Boolean=false);overload;
    procedure httppost(url:String;post:TStrings;var body:TStrings;runonce:Boolean=false);overload;
    procedure httppost(url:String;var postdata:TIdMultiPartFormDataStream;var body:TStrings;runonce:Boolean=false);overload;
    function isTerminated: boolean;
    procedure inccount();
    procedure deccount();
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




procedure ThttpThread.httpget(url: String;var body:TStrings;runonce:Boolean=false);
begin
  downloading := true;
  bget := true;
  init(url, body, runonce);
end;

procedure ThttpThread.httpget(url: String;var body:TMemoryStream;runonce:Boolean=false);
begin
  downloading := true;
  bget := true;
  init(url, nil, body, runonce);
end;



procedure ThttpThread.httppost(url: String; post: TStrings;var body:TStrings;runonce:Boolean=false);
begin
  downloading := true;
  bpost := true;
  init(url, post, body, runonce);
end;

procedure ThttpThread.httppost(url: String; var postdata: TIdMultipartFormDataStream;var body:TStrings;runonce:Boolean=false);
begin
  downloading := true;
  bpostdata := true;
  init(url, postdata, body, runonce);
end;

constructor ThttpThread.createex(cookie:TIdCookieManager);
begin
  inherited create(true);
  if cookie <> nil then
    self.cookie := cookie
  else
    cookie := TIdCookieManager.Create(nil);
  http := TIDhttp.Create(nil);
  http.CookieManager := self.cookie;
  
  http.Request.UserAgent := 'IE8.0';
  bget := false;
  bpost := false;
  bpostdata := false;

  synchronize(inccount);
end;



destructor ThttpThread.Destroy;
begin
  http.Free;

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


procedure ThttpThread.init(url: String; var body: TStrings;
  runonce: Boolean);
begin
  self.furl := url;
  self.fbody := body;
  self.frunonce := runonce;
  self.fgetstream := false;
end;

end.
