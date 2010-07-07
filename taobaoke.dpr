program taobaoke;

uses
  Forms,
  UntMain in 'UntMain.pas' {Form1},
  UntMission in 'UntMission.pas',
  UntPlugin_autohome50_5 in 'plugins\UntPlugin_autohome50_5.pas',
  UntHTTPThread in 'UntHTTPThread.pas',
  UntCommon in 'common\UntCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
