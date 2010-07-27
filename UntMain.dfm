object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'taobaoke'
  ClientHeight = 431
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 84
    Height = 13
    Caption = #27491#22312#25191#34892#30340#20219#21153
  end
  object LVMissionList: TListView
    Left = 8
    Top = 27
    Width = 641
    Height = 134
    Columns = <
      item
        Caption = #20219#21153#21517
        Width = 123
      end
      item
        Caption = #24403#21069#32447#31243#25968
        Width = 94
      end
      item
        Caption = #24635#35831#27714#25968
        Width = 88
      end
      item
        Caption = #25104#21151#25968
        Width = 99
      end
      item
        Caption = #24635#36816#34892#26102#38388
        Width = 91
      end
      item
        Caption = #29366#24577
        Width = 78
      end>
    Items.ItemData = {
      03520000000300000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
      0001310000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000000001320000
      000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000000000}
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = LVMissionListSelectItem
  end
  object BtnStart: TButton
    Left = 8
    Top = 167
    Width = 75
    Height = 25
    Caption = #24320#22987
    Enabled = False
    TabOrder = 1
    OnClick = BtnStartClick
  end
  object BtnStop: TButton
    Left = 89
    Top = 167
    Width = 75
    Height = 25
    Caption = #20572#27490
    Enabled = False
    TabOrder = 2
    OnClick = BtnStopClick
  end
  object BitBtn1: TBitBtn
    Left = 248
    Top = 167
    Width = 75
    Height = 25
    Caption = #27491#21017#27979#35797
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object PCLog: TPageControl
    Left = 0
    Top = 198
    Width = 661
    Height = 233
    ActivePage = TSResponse
    Align = alBottom
    Style = tsFlatButtons
    TabOrder = 4
    object TSResponse: TTabSheet
      Caption = 'Response'
      object MemResponse: TMemo
        Left = 0
        Top = 0
        Width = 653
        Height = 202
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TSCookie: TTabSheet
      Caption = 'Cookie'
      ImageIndex = 1
      object MemCookie: TMemo
        Left = 0
        Top = 0
        Width = 653
        Height = 202
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Request'
      ImageIndex = 2
      object MemRequest: TMemo
        Left = 0
        Top = 0
        Width = 653
        Height = 202
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Button1: TButton
    Left = 329
    Top = 167
    Width = 75
    Height = 25
    Caption = #39564#35777#27979#35797
    TabOrder = 5
    OnClick = Button1Click
  end
  object IdCookieManager2: TIdCookieManager
    Left = 416
    Top = 269
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 512
    Top = 269
  end
  object PopupMenu1: TPopupMenu
    Left = 272
    Top = 269
    object N1: TMenuItem
      Caption = #26242#20572
    end
  end
  object TimerDisp: TTimer
    Interval = 10000
    OnTimer = TimerDispTimer
    Left = 168
    Top = 269
  end
end
