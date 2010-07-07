unit UntCommon;

interface

uses
classes;

function SplitString(Source, Deli:string):TStringList;

implementation

function SplitString(Source, Deli:string):TStringList;//拆分字符串函数
var
EndOfCurrentString:byte; 
StringList:TStringList;
begin
    StringList:=TStringList.Create;
    while Pos(Deli,Source)>0 do         //当存在拆分符号时
    begin
      EndOfCurrentString:=Pos(Deli,Source);         //取分隔符的位置
      StringList.add(Copy(Source,1,EndOfCurrentString-1));    //添加项目
      Source:=Copy(Source,EndOfCurrentString+length(Deli),length(Source)-EndOfCurrentString); //减去已添加项和分隔符
    end;
    StringList.Add(source);   //如果不存在分隔符时，直接作为项目添加
    Result:=StringList;       //设置返回类型
end;
end.
