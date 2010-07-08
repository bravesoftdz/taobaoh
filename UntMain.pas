unit UntMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, IdBaseComponent, IdCookieManager, StdCtrls, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Menus, ExtCtrls, UntMission, iniFiles,
  Buttons;


type
  TFrmMain = class(TForm)
    LVMissionList: TListView;
    IdCookieManager2: TIdCookieManager;
    BtnStart: TButton;
    MemLog: TMemo;
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    TimerDisp: TTimer;
    BtnStop: TButton;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure TimerDispTimer(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    missionList :array of TMission;
    procedure init();
  end;

var
  FrmMain: TFrmMain;

implementation

uses UntPlugin_autohome50_5, PerlRegEx;

{$R *.dfm}

procedure TFrmMain.BitBtn1Click(Sender: TObject);
var
reg: TPerlRegEx;
mem:TStrings;
begin
reg := TPerlRegEx.Create(nil);

mem := TStringList.Create();
mem.LoadFromFile('F:\1.txt');
reg.Subject := mem.Text;
reg.RegEx := '<tbody>[^</tbody>].+</tbody>';

while reg.MatchAgain do //很明显: 本例只能找到一个结果
begin
ShowMessage(reg.MatchedExpression); //找到的字符串: 2007
ShowMessage(IntToStr(reg.MatchedExpressionOffset)); //它所在的位置: 10
ShowMessage(IntToStr(reg.MatchedExpressionLength)); //它的长度: 6
end;
end;

procedure TFrmMain.BtnStartClick(Sender: TObject);
begin
  //m := TAutohome50_5.create;
  //m.start;
  {memo1.Lines.Clear;
  memo1.Lines.Add(m.lastHttpResponse.Text);
  memo1.Lines.Add('=================cookie================');
  for i:= 0 to m.lastHttpCookie.CookieCollection.Count -1 do begin
    memo1.Lines.Add(m.lastHttpCookie.CookieCollection.Items[i].CookieText);
  end;    }
  {
  m.replyTest;
  memo1.Lines.Add(m.lastHttpResponse.Text);
  memo1.Lines.Add('=================cookie================');
  for i:= 0 to m.lastHttpCookie.CookieCollection.Count -1 do begin
    memo1.Lines.Add(m.lastHttpCookie.CookieCollection.Items[i].CookieText);
  end;

  m.Free;  }
end;

procedure TFrmMain.init;
var iniFile:TiniFile;
sections:TStrings;
i:Integer;
m:TMission;
begin
  sections := TStringList.Create;
  iniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'mission.ini');
  iniFile.ReadSections(sections);
  setLength(missionList, sections.Count-1);

  LVMissionList.Items.Clear;


  for i := 0 to sections.Count - 1 do begin
    if sections[i] <> 'mission_base' then begin
      if iniFile.ReadString(sections[i], 'plugin', '') = 'TAutohome50_5' then begin
        m := TAutohome50_5.create(iniFile, sections[i]);
      end;

      missionList[i] := m;
      LVMissionList.Items.Add;
    end;
  end;
end;

procedure TFrmMain.TimerDispTimer(Sender: TObject);
var
i:Integer;
m:TMission;
begin
  for  i:= low(missionList) to high(missionList) do begin
    m := missionList[i];
    if m <> nil then
      with LVMissionList.Items.Item[i-1] do begin
        Caption := m.getMissionName;
        SubItems.Strings[0] := InttoStr(m.getCurrentThreads);//当前线程数
        SubItems.Strings[1] := InttoStr(m.getRequestCount);//当前请求数
        SubItems.Strings[2] := InttoStr(m.getSuccessCount);//当前成功数
        SubItems.Strings[3] := m.getStateName;
      end;
  end;
end;

end.
