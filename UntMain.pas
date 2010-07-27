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
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    TimerDisp: TTimer;
    BtnStop: TButton;
    BitBtn1: TBitBtn;
    PCLog: TPageControl;
    TSResponse: TTabSheet;
    TSCookie: TTabSheet;
    MemResponse: TMemo;
    MemCookie: TMemo;
    TabSheet1: TTabSheet;
    MemRequest: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure LVMissionListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TimerDispTimer(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
    missionList :array of TMission;
    procedure init();
    procedure flashme;
  end;

var
  FrmMain: TFrmMain;

implementation

uses UntPlugin_autohome50_5, PerlRegEx, UntInputValidCode;

{$R *.dfm}

procedure TFrmMain.BitBtn1Click(Sender: TObject);
var
reg: TPerlRegEx;
mem:TStrings;
f:File;
begin
  reg := TPerlRegEx.Create(nil);

  mem := TStringList.Create();
  mem.LoadFromFile('F:\1.txt');
  reg.Subject := mem.Text;
  reg.RegEx := 'id="postform" action="(.*?)"';

  while reg.MatchAgain do //很明显: 本例只能找到一个结果
  begin
    ShowMessage(reg.MatchedExpression); //找到的字符串: 2007
    ShowMessage(InttoStr(reg.SubExpressionCount));
    ShowMessage(reg.SubExpressions[1]);
    //ShowMessage(IntToStr(reg.MatchedExpressionOffset)); //它所在的位置: 10
    //ShowMessage(IntToStr(reg.MatchedExpressionLength)); //它的长度: 6
  end;
  reg.RegEx := 'validform" value=''(.*?)''';
  while reg.MatchAgain do //很明显: 本例只能找到一个结果
  begin
    ShowMessage(reg.MatchedExpression); //找到的字符串: 2007
    ShowMessage(InttoStr(reg.SubExpressionCount));
    ShowMessage(reg.SubExpressions[1]);
    //ShowMessage(IntToStr(reg.MatchedExpressionOffset)); //它所在的位置: 10
    //ShowMessage(IntToStr(reg.MatchedExpressionLength)); //它的长度: 6
  end;
end;

procedure TFrmMain.BtnStartClick(Sender: TObject);
var
  m:TMission;
begin
  if LVMissionList.ItemIndex <> -1 then begin
    m := missionList[LVMissionList.ItemIndex];
    m.start;
    LVMissionListSelectItem(nil, LVMissionList.Items[LVMissionList.ItemIndex], true);
  end;

end;

procedure TFrmMain.BtnStopClick(Sender: TObject);
var
  m:TMission;
begin
  if LVMissionList.ItemIndex <> -1 then begin
    m := missionList[LVMissionList.ItemIndex];
    m.stop;
    LVMissionListSelectItem(nil, LVMissionList.Items[LVMissionList.ItemIndex], true);
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
var
ivc :TFrmInputValidCode;
begin
  ivc := TFrmInputValidCode.Create(self);
  ivc.test;
  ivc.Show;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  init();
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
  setLength(missionList, sections.Count - 1);

  LVMissionList.Clear;


  for i := 0 to sections.Count - 1 do begin
    if sections[i] <> 'mission_base' then begin
      m := nil;
      if iniFile.ReadString(sections[i], 'plugin', '') = 'TAutohome50_5' then begin
        m := TAutohome50_5.create(iniFile, sections[i]);
      end;

      missionList[i-1] := m;
      with LVMissionList.Items.Add do begin
        Caption := m.getMissionName;
        SubItems.Add('0');
        SubItems.Add('0');
        SubItems.Add('0');
        SubItems.Add('停止');
      end;
    end;
  end;
end;

procedure TFrmMain.LVMissionListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  m:TMission;
begin
  m := missionList[Item.Index];
  if m<>nil then begin
    BtnStart.Enabled := m.getState = 0;
    BtnStop.Enabled := m.getState = 1;
  end;
end;

procedure TFrmMain.TimerDispTimer(Sender: TObject);
var
i:Integer;
m:TMission;
begin
  TimerDisp.Enabled := false;
  for  i:= low(missionList) to high(missionList) do begin
    m := missionList[i];
    if m <> nil then
      with LVMissionList.Items.Item[i] do begin
        Caption := m.getMissionName;
        SubItems.Strings[0] := InttoStr(m.getCurrentThreads);//当前线程数
        SubItems.Strings[1] := InttoStr(m.getRequestCount);//当前请求数
        SubItems.Strings[2] := InttoStr(m.getSuccessCount);//当前成功数
        SubItems.Strings[3] := m.getStateName;
      end;
  end;
  if LVMissionList.ItemIndex <> -1 then begin
    m := missionList[LVMissionList.ItemIndex];
    memResponse.Lines.Text := m.lastHttpResponse.Text;
    memCookie.Clear;
    for i := 0 to m.lastHttpCookie.CookieCollection.Count - 1 do
      memCookie.Lines.Add(m.lastHttpCookie.CookieCollection.Items[i].CookieText);
    memRequest.Lines.Text := m.lastHttpRequest.Text;
    LVMissionListSelectItem(nil, LVMissionList.Items[LVMissionList.ItemIndex], true);
  end;
  TimerDisp.Enabled := true;
end;

procedure TFrmMain.flashme;
var
  FWinfo: FLASHWINFO;
begin
  FWinfo.cbSize := 20;
  FWinfo.hwnd := self.Handle; // 闪烁窗口的句柄
  FWinfo.dwflags := FLASHW_TRAY;
  FWinfo.ucount := 2; // 闪烁的次数
  FWinfo.dwtimeout := 0; // 速度以毫秒为单位, 0 默认为与指针闪烁的速率相同
  FlashWindowEx(FWinfo); // 使它闪烁!
end;

end.
