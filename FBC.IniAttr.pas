///  <summary>
///  INI Section 이름 어트리뷰트
///  </summary>
unit FBC.IniAttr;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  System.TypInfo,
  System.IniFiles;

type
  ///  <summary>
  ///  INI Section 이름 어트리뷰트
  ///  </summary>
  IniSectionAttribute = class(TCustomAttribute)
  private
    FSection: string;
  public
    constructor Create(const ASection: string); virtual;

    property Section: string read FSection;
  end;

  ///  <summary>
  ///  Boolean 어트리뷰트
  ///  </summary>
  IniBoolAttribute = class(TCustomAttribute)
  private
    FDefaultValue: Boolean;
  public
    constructor Create(const ADefaultValue: Boolean = True);

    property DefaultValue: Boolean read FDefaultValue;
  end;

  ///  <summary>
  ///  Date 어트리뷰트
  ///  </summary>
  IniDateAttribute = class(TCustomAttribute)
  private
    FDefaultValue: string;
  public
    constructor Create(const ADefaultValue: string = ''); reintroduce;

    property DefaultValue: string read FDefaultValue;
  end;

  ///  <summary>
  ///  DateTime 어트리뷰트
  ///  </summary>
  IniDateTimeAttribute = class(TCustomAttribute)
  private
    FDefaultValue: string;
  public
    constructor Create(const ADefaultValue: string = '');

    property DefaultValue: string read FDefaultValue;
  end;

  ///  <summary>
  ///  Double 어트리뷰트
  ///  </summary>
  IniFloatAttribute = class(TCustomAttribute)
  private
    FDefaultValue: Double;
  public
    constructor Create(const ADefaultValue: Double = 0.0);

    property DefaultValue: Double read FDefaultValue;
  end;

  ///  <summary>
  ///  Integer 어트리뷰트
  ///  </summary>
  IniIntAttribute = class(TCustomAttribute)
  private
    FDefaultValue: Integer;
  public
    constructor Create(const ADefaultValue: Integer = 0);

    property DefaultValue: Integer read FDefaultValue;
  end;

  ///  <summary>
  ///  Int64 어트리뷰트
  ///  </summary>
  IniInt64Attribute = class(TCustomAttribute)
  private
    FDefaultValue: Int64;
  public
    constructor Create(const ADefaultValue: Int64 = 0);

    property DefaultValue: Int64 read FDefaultValue;
  end;

  ///  <summary>
  ///  string 어트리뷰트
  ///  </summary>
  IniStringAttribute = class(TCustomAttribute)
  private
    FDefaultValue: string;
  public
    constructor Create(const ADefaultValue: string = '');

    property DefaultValue: string read FDefaultValue;
  end;

  ///  <summary>
  ///  INI 파일과 매핑할 수 있는 기본 클래스
  ///  </summary>
  TIniObject = class
  public
    ///  <summary>
    ///  INI에서 데이터를 읽어서 프러퍼티에 설정한다
    ///  </summary>
    ///  <param name AFileName>로드할 INI 파일명</param>
    procedure LoadFromFile(const AFileName: string); virtual;
    ///  <summary>
    ///  프러퍼티의 값을 INI에 기록한다
    ///  </summary>
    ///  <param name AFileName>로드할 INI 파일명</param>
    procedure SaveToFile(const AFileName: string); virtual;
  end;

implementation

{$REGION 'IniSectionAttribute'}

constructor IniSectionAttribute.Create(const ASection: string);
begin
  FSection := ASection;
end;

{$ENDREGION}

{$REGION 'IniBoolAttribute'}

constructor IniBoolAttribute.Create(const ADefaultValue: Boolean);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniDateAttribute'}

constructor IniDateAttribute.Create(const ADefaultValue: string);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniDateTimeAttribute'}

constructor IniDateTimeAttribute.Create(const ADefaultValue: string);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniFloatAttribute'}

constructor IniFloatAttribute.Create( const ADefaultValue: Double);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniIntAttribute'}

constructor IniIntAttribute.Create( const ADefaultValue: Integer);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniInt64Attribute'}

constructor IniInt64Attribute.Create(const ADefaultValue: Int64);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'IniStringAttribute'}

constructor IniStringAttribute.Create(const ADefaultValue: string);
begin
  FDefaultValue := ADefaultValue;
end;

{$ENDREGION}

{$REGION 'TIniObject'}

procedure TIniObject.LoadFromFile(const AFileName: string);
begin
  var LIniFile := TIniFile.Create(AFileName);
  var LContext := TRttiContext.Create;
  try
    var LSectionAttr := LContext.GetType(Self.ClassType).GetAttribute(IniSectionAttribute);
    var LProps := LContext.GetType(Self.ClassType).GetProperties;

    for var LProp in LProps do
    begin
      for var LAttr in LProp.GetAttributes do
      begin
        var LSectionName := (LSectionAttr as IniSectionAttribute).Section;

        if (LAttr is IniBoolAttribute) then
          LProp.SetValue(Self, LIniFile.ReadBool(LSectionName, LProp.Name, (LAttr as IniBoolAttribute).DefaultValue))
        else
        if (LAttr is IniDateAttribute) then
          LProp.SetValue(Self, LIniFile.ReadDate(LSectionName, LProp.Name, StrToDateTime((LAttr as IniDateAttribute).DefaultValue)))
        else
        if (LAttr is IniDateTimeAttribute) then
          LProp.SetValue(Self, LIniFile.ReadDateTime(LSectionName, LProp.Name, StrToDateTime((LAttr as IniDateTimeAttribute).DefaultValue)))
        else
        if (LAttr is IniFloatAttribute) then
          LProp.SetValue(Self, LIniFile.ReadFloat(LSectionName, LProp.Name, (LAttr as IniFloatAttribute).DefaultValue))
        else
        if (LAttr is IniIntAttribute) then
          LProp.SetValue(Self, LIniFile.ReadInteger(LSectionName, LProp.Name, (LAttr as IniIntAttribute).DefaultValue))
        else
        if (LAttr is IniInt64Attribute) then
          LProp.SetValue(Self, LIniFile.ReadInt64(LSectionName, LProp.Name, (LAttr as IniInt64Attribute).DefaultValue))
        else
        if (LAttr is IniStringAttribute) then
          LProp.SetValue(Self, LIniFile.ReadString(LSectionName, LProp.Name, (LAttr as IniStringAttribute).DefaultValue));
      end;
    end;
  finally
    LContext.Free;
    LIniFile.Free;
  end;
end;

procedure TIniObject.SaveToFile(const AFileName: string);
begin
  var LIniFile := TIniFile.Create(AFileName);
  var LContext := TRttiContext.Create;
  try
    var LSectionAttr := LContext.GetType(Self.ClassType).GetAttribute(IniSectionAttribute);
    var LProps := LContext.GetType(Self.ClassType).GetProperties;

    for var LProp in LProps do
    begin
      for var LAttr in LProp.GetAttributes do
      begin
        var LSectionName := (LSectionAttr as IniSectionAttribute).Section;
        var LValue := LProp.GetValue(Self);

        if (LAttr is IniBoolAttribute) then
          LIniFile.WriteBool(LSectionName, LProp.Name, LValue.AsBoolean)
        else
        if (LAttr is IniDateAttribute) then
          LIniFile.WriteDate(LSectionName, LProp.Name, LValue.AsExtended)
        else
        if (LAttr is IniDateTimeAttribute) then
          LIniFile.WriteDateTime(LSectionName, LProp.Name, LValue.AsExtended)
        else
        if (LAttr is IniFloatAttribute) then
          LIniFile.WriteFloat(LSectionName, LProp.Name, LValue.AsExtended)
        else
        if (LAttr is IniIntAttribute) then
          LIniFile.WriteInteger(LSectionName, LProp.Name, LValue.AsInteger)
        else
        if (LAttr is IniInt64Attribute) then
          LIniFile.ReadInt64(LSectionName, LProp.Name, LValue.AsInt64)
        else
        if (LAttr is IniStringAttribute) then
          LIniFile.WriteString(LSectionName, LProp.Name, LValue.AsString);
      end;
    end;
  finally
    LContext.Free;
    LIniFile.Free;
  end;
end;

{$ENDREGION}

end.
