unit UntInputValidCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GIFImage;

type
  TFrmInputValidCode = class(TForm)
    ImgValidCode: TImage;
    EdtValidCode: TEdit;
    BtnOK: TButton;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function showImg(imgStream:TStream):String;
  end;

var
  FrmInputValidCode: TFrmInputValidCode;

implementation

{$R *.dfm}

{ TFrmInputValidCode }

procedure TFrmInputValidCode.BtnOKClick(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

function TFrmInputValidCode.showImg(imgStream: TStream): String;
var ms:TMemoryStream;
gif:TGIFImage;
begin
  //
  {ms := TMemoryStream.Create;
  ms.LoadFromStream(imgStream);
  ms.SaveToFile('C:\1.gif');
  ms.Free;
  }
  gif := TGIFImage.Create;
  imgStream.Position := 0;
  gif.LoadFromStream(imgStream);
  ImgValidCode.Picture.Bitmap := gif.Bitmap;
  self.ShowModal;
  gif.Free;
  result := EdtValidCode.Text;
  close;
end;

end.
