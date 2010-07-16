unit UntInputValidCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GIFImage, StrUtils;

type
  TFrmInputValidCode = class(TForm)
    ImgValidCode: TImage;
    EdtValidCode: TEdit;
    BtnOK: TButton;
    procedure ImgValidCodeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams);Override;
  private
    { Private declarations }
  public
    { Public declarations }
    function showImg(imgStream:TStream):String;
    procedure flashme;
    procedure test;
  end;

  procedure getRGBValue(c:TColor; var R,G,B:double);
  function getValidCode(validImage: TGIFImage):String;Overload;
  function getValidCode(imgStream: TStream):String;Overload;
  procedure filteImage(validImage: TGIFImage);
var
  FrmInputValidCode: TFrmInputValidCode;
  ValidImageArray: array [1..4, 0..9] of TGifImage;
  i,j :integer;
implementation

{$R *.dfm}

{ TFrmInputValidCode }

procedure TFrmInputValidCode.CreateParams(var Params: TCreateParams);
begin

  inherited CreateParams(Params);
  //Params.Style := WS_DISABLED;
  //Params.ExStyle := WS_EX_APPWINDOW;
  Params.WndParent := getDeskTopWindow;

end;

procedure TFrmInputValidCode.BtnOKClick(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

function TFrmInputValidCode.showImg(imgStream: TStream): String;
var
gif:TGIFImage;
begin
  gif := TGIFImage.Create;
  imgStream.Position := 0;
  gif.LoadFromStream(imgStream);
  EdtValidCode.Text := getValidCode(gif);
  ImgValidCode.Picture.Bitmap := gif.Bitmap;
  flashme;
  self.ShowModal;
  gif.Free;
  result := EdtValidCode.Text;
  close;
end;

procedure TFrmInputValidCode.test;
var
  gif:TGIFImage;
  c:TColor;
  R, G, B :double;
begin
  gif := TGIFImage.Create;
  gif.LoadFromFile('f:/1.gif');
  EdtValidCode.Text := getValidCode(gif);
  ImgValidCode.Picture.Bitmap := gif.Bitmap;
  c := ValidImageArray[1][0].Bitmap.Canvas.Pixels[0,0];
  getRGBValue(c, R, G, B);
  showmessage('R:'+floattoStr(R)+' G:'+floattoStr(G)+' B:'+floattoStr(B));
end;

procedure filteImage(validImage: TGIFImage);
var c:TColor;
i, j:Integer;
R, G, B :double;
begin
  //ImgValidCode.Picture.Bitmap.Canvas.Pen.Color := clWhite;
  for i := 0 to validImage.Bitmap.Height - 1 do begin
    for j := 0 to validImage.Bitmap.Width - 1 do begin

      c := validImage.Bitmap.Canvas.Pixels[j,i];
      R   :=   c   and   $FF;
      G   :=   (c   and   $FF00)   shr   8;
      B   :=   (c   and   $FF0000)   shr   16;

      if (R = 255) and (G = 0) and (B = 0 ) then
        //去掉红色 R 255 G 0 B 0
        validImage.Bitmap.Canvas.Pixels[j,i] := clWhite
      else if (R = 0) and (G = 0) and (B = 255 ) then
        //去掉蓝色 R 0 G 0 B 255
        validImage.Bitmap.Canvas.Pixels[j,i] := clWhite;
    end;
  end;

end;

procedure TFrmInputValidCode.flashme;
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

procedure getRGBValue(c: TColor; var R, G, B: double);
begin
  R   :=   c   and   $FF;
  G   :=   (c   and   $FF00)   shr   8;
  B   :=   (c   and   $FF0000)   shr   16;  
end;

function getValidCode(imgStream: TStream): String;
var 
gif:TGIFImage;
begin
  gif := TGIFImage.Create;
  try
    imgStream.Position := 0;
    gif.LoadFromStream(imgStream);
    result := getValidCode(gif);
  finally
    gif.free;
  end;
end;

function getValidCode(validImage: TGIFImage): String;
  function getValidCodeSub(index:integer; validImage: TGIFImage):String;
  var likeCount, likePer, pixCount, mostLikePer, mostLikeNum, i, x, y:Integer;
  g:TGIFImage;
  begin
    mostLikePer := 0;
    mostLikeNum := 0;
    //第一位验证码 [6,7] [13,20]
    //第二位验证码 [16,7] [23,20]
    //第三位验证码 [26,7] [33,20]
    //第四位验证码 [36,7] [43,20]
    for i := 0 to 9 do begin
      g := ValidImageArray[index][i];
      pixCount := 0;//有效象素
      likeCount := 0;//有效象素相似数
      likePer := 0;//有效象素相似比
      for x := 6+(index-1)*10 to 13+(index-1)*10 do begin
        for y := 7 to 20 do begin
          if g.Bitmap.Canvas.Pixels[x,y] <> clWhite then begin
            inc(pixCount);
            if validImage.Bitmap.Canvas.Pixels[x,y] <> clWhite then
              inc(likeCount);
          end;          
        end;
      end;
      likePer := round(likeCount/PixCount *100);
      if likePer > mostLikePer then begin
        mostLikeNum := i;
        mostLikePer := likePer;
      end;
    end;
    result := inttoStr(mostLikeNum);
  end;
begin
  if validImage<> nil then begin
    filteImage(validImage);
    result := getValidCodeSub(1,validImage) + getValidCodeSub(2,validImage) +
              getValidCodeSub(3,validImage) + getValidCodeSub(4,validImage);
  end else begin
    result := '';
  end;
end;

procedure TFrmInputValidCode.ImgValidCodeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c:TColor;
R, G, B :double;
begin
  c := ImgValidCode.Picture.Bitmap.Canvas.Pixels[X,Y];
  getRGBValue(c, R, G, B);
  showmessage('R:'+floattoStr(R)+' G:'+floattoStr(G)+' B:'+floattoStr(B));
end;

initialization
begin
  for i := 1 to 4 do begin
    for j := 0 to 9 do begin
      ValidImageArray[i][j] := TGifImage.Create;
      ValidImageArray[i][j].LoadFromFile(ExtractFilePath(Application.ExeName)+'\res\'+
        DupeString('x', i-1)+InttoStr(j)+DupeString('x', 4-i)+'.gif');
    end;
  end;
end;

finalization
begin
  for i := 1 to 4 do begin
    for j := 0 to 9 do begin
      ValidImageArray[i][j].Free;
    end;
  end;
end;

end.
