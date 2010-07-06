unit UntPlugin_autohome50_5;

interface

uses
UntMission, IdCookieManager;

type
  TAutohome50_5 = class(TMission)
  private
    { Private declarations }
  protected
    function login:TIdCookieManager;OverLoad;
  public
    { Public declarations }
    procedure start;OverLoad;
  end;

implementation


{ TAutohome50_5 }

function TAutohome50_5.login: TIdCookieManager;
begin

end;

procedure TAutohome50_5.start;
begin
  
end;

end.
