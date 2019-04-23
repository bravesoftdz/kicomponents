unit KiBorder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, BCTypes;

type

  { TBorder }

  TBorder = class(TPersistent)
  private
    FGradient: TBCGradient;
    FOpacity: Byte;
    FColor: TColor;
    FColorActive: TColor;
    FOwner: TPersistent;
    FRoundRadius: Integer;
    FStyle: TPenStyle;
    FUseGradient: Boolean;
    FWidth: Integer;
    FWidthActive: Integer;
    procedure SetGradient(const aValue: TBCGradient);
    procedure SetOpacity(const aValue: Byte);
    procedure SetColor(const aValue: TColor);
    procedure SetColorActive(const aValue: TColor);
    procedure SetRoundRadius(aValue: Integer);
    procedure SetStyle(const aValue: TPenStyle);
    procedure SetUseGradient(const aValue: Boolean);
    procedure SetWidth(aValue: Integer);
    procedure SetWidthActive(aValue: Integer);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetOwner: TPersistent; override;
  published
    property Color: TColor read FColor write SetColor default clBlack;
    property ColorActive: TColor read FColorActive write SetColorActive default clHighlight;
    property Gradient: TBCGradient read FGradient write SetGradient;
    property Opacity: Byte read FOpacity write SetOpacity default 255;
    property RoundRadius: Integer read FRoundRadius write SetRoundRadius default 15;
    property Style: TPenStyle read FStyle write SetStyle default psSolid;
    property UseGradient: Boolean read FUseGradient write SetUseGradient default False;
    property Width: Integer read FWidth write SetWidth default 1;
    property WidthActive : Integer read FWidthActive write SetWidthActive default 1;
  end;

implementation

{ TBorder }

procedure TBorder.SetWidth(aValue: Integer);
begin
  if aValue < 0 then
    aValue := 0;

  if FWidth = aValue then
    Exit;

  FWidth := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetColor(const aValue: TColor);
begin
  if FColor = aValue then
    Exit;

  FColor := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetOpacity(const aValue: Byte);
begin
  if FOpacity = aValue then
    Exit;

  FOpacity := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetGradient(const aValue: TBCGradient);
begin
  if FGradient = aValue then
    Exit;

  FGradient := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetColorActive(const aValue: TColor);
begin
  if FColorActive = aValue then
    Exit;

  FColorActive := aValue;
end;

procedure TBorder.SetRoundRadius(aValue: Integer);
begin
  if aValue < 0 then
    aValue := 0;

  if FRoundRadius = aValue then
    Exit;

  FRoundRadius := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetStyle(const aValue: TPenStyle);
begin
  if FStyle = aValue then
    Exit;

  FStyle := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetUseGradient(const aValue: Boolean);
begin
  if FUseGradient = aValue then
    Exit;

  FUseGradient := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TBorder.SetWidthActive(aValue: Integer);
begin
  if FWidthActive = aValue then
    Exit;

  FWidthActive := aValue;
end;

constructor TBorder.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner       := AOwner;
  FWidth       := 1;
  FWidthActive := 1;
  FColor       := clBlack;
  FColorActive := clHighlight;
  FOpacity     := 255;
  FRoundRadius := 15;
  FStyle       := psSolid;
  FUseGradient := False;

  FGradient                := TBCGradient.Create(TCustomControl(GetOwner));
  FGradient.Point2XPercent := 100;
  FGradient.StartColor     := clWhite;
  FGradient.EndColor       := clBlack;
end;

destructor TBorder.Destroy;
begin
  FreeAndNil(FGradient);
  inherited Destroy;
end;

procedure TBorder.Assign(Source: TPersistent);
begin
  if Source is TBorder then
    with TBorder(Source) do
    begin
      Self.FWidth       := Width;
      Self.FWidthActive := WidthActive;
      Self.FColor       := Color;
      Self.FColorActive := ColorActive;
      Self.FOpacity     := Opacity;
      Self.FRoundRadius := RoundRadius;
      Self.FStyle       := Style;
      Self.FUseGradient := UseGradient;
      Self.FGradient    := Gradient;
    end
    else
      inherited Assign(Source);
end;

function TBorder.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

end.

