unit KiFill;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, BCTypes;

type

  { TFill }

  TFill = class(TPersistent)
  private
    FColor: TColor;
    FColorActive: TColor;
    FGradient: TBCGradient;
    FOpacity: Byte;
    FOwner: TPersistent;
    FUseGradient: Boolean;
    procedure SetGradient(const aValue: TBCGradient);
    procedure SetOpacity(const aValue: Byte);
    procedure SetColor(const aValue: TColor);
    procedure SetColorActive(const aValue: TColor);
    procedure SetUseGradient(const aValue: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetOwner: TPersistent; override;
  published
    property Color: TColor read FColor write SetColor default clWhite;
    property ColorActive: TColor read FColorActive write SetColorActive default $00FFF2E7; //azul bem clarinho
    property Gradient: TBCGradient read FGradient write SetGradient;
    property Opacity: Byte read FOpacity write SetOpacity default 255;
    property UseGradient: Boolean read FUseGradient write SetUseGradient default False;
  end;

implementation

{ TFill }

procedure TFill.SetGradient(const aValue: TBCGradient);
begin
  if FGradient = aValue then
    Exit;

  FGradient := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TFill.SetOpacity(const aValue: Byte);
begin
  if FOpacity = aValue then
    Exit;

  FOpacity := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TFill.SetColor(const aValue: TColor);
begin
  if FColor = aValue then
    Exit;

  FColor := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

procedure TFill.SetColorActive(const aValue: TColor);
begin
  if FColorActive = aValue then
    Exit;

  FColorActive := aValue;
end;

procedure TFill.SetUseGradient(const aValue: Boolean);
begin
  if FUseGradient = aValue then
    Exit;

  FUseGradient := aValue;
  TCustomControl(GetOwner).Invalidate;
end;

constructor TFill.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner       := AOwner;
  FColor       := clWhite;
  FColorActive := $00FFF2E7;
  FOpacity     := 255;
  FUseGradient := False;

  FGradient                := TBCGradient.Create(TCustomControl(GetOwner));
  FGradient.Point2XPercent := 100;
  FGradient.StartColor     := clWhite;
  FGradient.EndColor       := clBlack;
end;

destructor TFill.Destroy;
begin
  FreeAndNil(FGradient);
  inherited Destroy;
end;

procedure TFill.Assign(Source: TPersistent);
begin
  if Source is TFill then
    with TFill(Source) do
    begin
      Self.FColor       := Color;
      Self.FColorActive := ColorActive;
      Self.FOpacity     := Opacity;
      Self.FUseGradient := UseGradient;
      Self.FGradient    := Gradient;
    end
    else
      inherited Assign(Source);
end;

function TFill.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

end.

