unit UntCommon;

interface

uses
classes;

function SplitString(Source, Deli:string):TStringList;

implementation

function SplitString(Source, Deli:string):TStringList;//����ַ�������
var
EndOfCurrentString:byte; 
StringList:TStringList;
begin
    StringList:=TStringList.Create;
    while Pos(Deli,Source)>0 do         //�����ڲ�ַ���ʱ
    begin
      EndOfCurrentString:=Pos(Deli,Source);         //ȡ�ָ�����λ��
      StringList.add(Copy(Source,1,EndOfCurrentString-1));    //�����Ŀ
      Source:=Copy(Source,EndOfCurrentString+length(Deli),length(Source)-EndOfCurrentString); //��ȥ�������ͷָ���
    end;
    StringList.Add(source);   //��������ڷָ���ʱ��ֱ����Ϊ��Ŀ���
    Result:=StringList;       //���÷�������
end;
end.
