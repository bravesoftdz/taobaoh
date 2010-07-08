object FrmInputValidCode: TFrmInputValidCode
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #36755#20837#39564#35777
  ClientHeight = 144
  ClientWidth = 179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ImgValidCode: TImage
    Left = 8
    Top = 8
    Width = 161
    Height = 89
  end
  object EdtValidCode: TEdit
    Left = 8
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object BtnOK: TButton
    Left = 140
    Top = 111
    Width = 31
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = BtnOKClick
  end
end
