unit UntMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, IdBaseComponent, IdCookieManager, StdCtrls, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    IdCookieManager2: TIdCookieManager;
    Button1: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UntPlugin_autohome50_5;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var m:TAutohome50_5;
i:Integer;
begin
  m := TAutohome50_5.create;
  m.start;
  {memo1.Lines.Clear;
  memo1.Lines.Add(m.lastHttpResponse.Text);
  memo1.Lines.Add('=================cookie================');
  for i:= 0 to m.lastHttpCookie.CookieCollection.Count -1 do begin
    memo1.Lines.Add(m.lastHttpCookie.CookieCollection.Items[i].CookieText);
  end;    }

  m.replyTest;
  memo1.Lines.Add(m.lastHttpResponse.Text);
  memo1.Lines.Add('=================cookie================');
  for i:= 0 to m.lastHttpCookie.CookieCollection.Count -1 do begin
    memo1.Lines.Add(m.lastHttpCookie.CookieCollection.Items[i].CookieText);
  end;
    
  m.Free;
end;

end.
