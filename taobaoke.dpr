program taobaoke;

uses
  Forms,
  UntMain in 'UntMain.pas' {FrmMain},
  UntMission in 'UntMission.pas',
  UntPlugin_autohome50_5 in 'plugins\UntPlugin_autohome50_5.pas',
  UntHTTPThread in 'UntHTTPThread.pas',
  UntCommon in 'common\UntCommon.pas',
  UntInputValidCode in 'UntInputValidCode.pas' {FrmInputValidCode},
  GIFImage in 'GIFImage.pas',
  PerlRegEx in 'common\PerlRegEx.pas',
  pcre in 'common\pcre.pas',
  UntLog in 'UntLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
