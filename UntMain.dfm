object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'taobaoke'
  ClientHeight = 400
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 84
    Height = 13
    Caption = #27491#22312#25191#34892#30340#20219#21153
  end
  object LVMissionList: TListView
    Left = 8
    Top = 27
    Width = 641
    Height = 185
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
      01460000000300000000000000FFFFFFFFFFFFFFFF0000000000000000013100
      00000000FFFFFFFFFFFFFFFF000000000000000001320000000000FFFFFFFFFF
      FFFFFF000000000000000000}
    TabOrder = 0
    ViewStyle = vsReport
  end
  object BtnStart: TButton
    Left = 8
    Top = 218
    Width = 75
    Height = 25
    Caption = #24320#22987
    Enabled = False
    TabOrder = 1
    OnClick = BtnStartClick
  end
  object MemLog: TMemo
    Left = 8
    Top = 249
    Width = 641
    Height = 143
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object BtnStop: TButton
    Left = 89
    Top = 218
    Width = 75
    Height = 25
    Caption = #20572#27490
    Enabled = False
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 248
    Top = 218
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object IdCookieManager2: TIdCookieManager
    Left = 368
    Top = 224
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 408
    Top = 224
  end
  object PopupMenu1: TPopupMenu
    Left = 328
    Top = 224
    object N1: TMenuItem
      Caption = #26242#20572
    end
  end
  object TimerDisp: TTimer
    OnTimer = TimerDispTimer
    Left = 176
    Top = 216
  end
end
