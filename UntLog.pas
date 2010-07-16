unit UntLog;



interface

uses SysUtils, Forms, Windows;


const fdebug = false;

var logFile:Text;

procedure log(msg:String);

procedure debug(msg:String);
procedure info(msg:String);
procedure error(msg:String);


implementation

procedure log(msg:String);
begin
  writeln(logFile, '['+formatDateTime('yyyy-mm-dd hh:mm:ss', now)+']'+msg);
end;

procedure debug(msg:String);
begin
  log('[DEBUG]' + msg);
end;

procedure info(msg:String);
begin
  log('[INFO]' + msg);
end;

procedure error(msg:String);
begin
  log('[ERROR]' + msg);
end;

initialization
begin
  if not FileExists(ExtractFilePath(Application.ExeName)+'log.txt') then
    CreateFile(PChar(ExtractFilePath(Application.ExeName)+'log.txt'), 0, FILE_SHARE_READ, nil, CREATE_NEW, FILE_ATTRIBUTE_NORMAL,FILE_FLAG_WRITE_THROUGH);
  assign(logFile, ExtractFilePath(Application.ExeName)+'log.txt');
  append(logFile);
end;

finalization
begin
  close(logFile);
end;

end.
