program taobaoke;

uses
  Forms,
  UntMain in 'UntMain.pas' {Form1},
  UntMission in 'UntMission.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
