unit KiEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, SysUtils, Graphics,
  KiBorder, KiFill,
  BGRABitmap, BGRABitmapTypes,
  BCTools,
  LMessages, LResources;


type
  TEditType = (etText, etNumber, etDateTime);

  { TKiEdit }

  TKiEdit = class(TCustomControl)
  private
    FEditType: TEditType;
    //FEdit: TCustomEdit;
    FOldFillColor: TColor;
    FFill: TFill;
    FOldBorderWidth: Integer;
    FOldBorderColor: TColor;
    FBGRA: TBGRABitmap;
    FBorder: TBorder;
    FOnClick: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    procedure SetBorder(const aValue: TBorder);
    procedure SetEditType(AValue: TEditType);
    procedure SetFill(const aValue: TFill);
  protected
    //messagens
    procedure CMFocusChanged(var Message: TLMessage); message CM_FOCUSCHANGED;
    procedure CMMouseEnter(var Message: TLMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TLMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //properties
    property Align;
    property Anchors;
    property Border: TBorder read FBorder write SetBorder;
    property Background: TFill read FFill write SetFill;
    property EditType: TEditType read FEditType write SetEditType default etText;
    property Enabled;
    property Hint;
    property ShowHint;
    property Visible;
    property TabOrder;
    property TabStop;
  published
    //events
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  procedure Register;

implementation

procedure Register;
begin
  {$i kicomponents.lrs}
  RegisterComponents('KiComponents',[TKiEdit]);
end;

{ TKiEdit }

procedure TKiEdit.SetBorder(const aValue: TBorder);
begin
  FBorder.Assign(aValue);
end;

procedure TKiEdit.SetEditType(AValue: TEditType);
begin
  if FEditType = AValue then
    Exit;

  FEditType := AValue;
end;

procedure TKiEdit.SetFill(const aValue: TFill);
begin
  FFill.Assign(aValue);
end;

procedure TKiEdit.CMFocusChanged(var Message: TLMessage);
begin
  inherited;
  Invalidate;
end;

procedure TKiEdit.CMMouseEnter(var Message: TLMessage);
begin
  FOldBorderWidth := FBorder.Width;
  FBorder.Width   := FBorder.WidthActive;
  FOldBorderColor := FBorder.Color;
  FBorder.Color   := FBorder.ColorActive;
  FOldFillColor   := FFill.Color;
  FFill.Color     := FFill.ColorActive;

  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TKiEdit.CMMouseLeave(var Message: TLMessage);
begin
  FBorder.Width := FOldBorderWidth;
  FBorder.Color := FOldBorderColor;
  FFill.Color   := FOldFillColor;

  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TKiEdit.Paint;
const
  SIDECOUNT = 4;
  ANGLE     = 45;
var
  cx, cy, rx, ry, a: single;
  coords: array of TPointF;
  minCoord, maxCoord: TPointF;
  i, aWidth: integer;
  borderGrad, fillGrad: TBGRACustomScanner;
  aBorderColor, aFillColor: TColor;
begin
  inherited Paint;

  if not Enabled then
  begin
    aWidth       := 1;
    aBorderColor := $00AFAFB3; //cinza claro
    aFillColor   := $00CECED2; //cinza bem claro
  end
  else
  begin
    if Focused then
    begin
      aWidth       := FBorder.WidthActive;
      aBorderColor := FBorder.ColorActive;
      aFillColor   := FFill.ColorActive;
    end
    else
    begin
      aWidth       := FBorder.Width;
      aBorderColor := FBorder.Color;
      aFillColor   := FFill.Color;
    end;
  end;

  {$IFNDEF FPC}
  if FBGRA <> nil then
    FBGRA.SetSize(Width, Height);
  {$ENDIF}

  FBGRA.FillTransparent;
  FBGRA.PenStyle := FBorder.Style;

  with FBGRA.Canvas2D do
  begin
    lineJoin     := 'round';

    if FBorder.UseGradient then
    begin
      borderGrad := CreateGradient(FBorder.Gradient, Classes.rect(0, 0, Width, Height));
      strokeStyle(borderGrad);
    end
    else
    begin
      borderGrad := nil;
      strokeStyle(ColorToBGRA(ColorToRGB(aBorderColor), FBorder.Opacity));
    end;

    lineStyle(FBGRA.CustomPenStyle);
    lineWidth := aWidth;

    if FFill.UseGradient then
    begin
      fillGrad := CreateGradient(FFill.Gradient, Classes.rect(0, 0, Width, Height));
      fillStyle(fillGrad);
    end
    else
    begin
      fillGrad := nil;
      fillStyle(ColorToBGRA(ColorToRGB(aFillColor), FFill.Opacity));
    end;

    cx := Width / 2;
    cy := Height / 2;
    rx := (Width - aWidth) / 2;
    ry := (Height - aWidth) / 2;

    SetLength(coords, SIDECOUNT);

    for i := 0 to high(coords) do
    begin
      a := (i / SIDECOUNT + ANGLE / 360) * 2 * Pi;
      coords[i] := PointF(sin(a), -cos(a));
    end;

    minCoord := coords[0];
    maxCoord := coords[0];

    for i := 1 to high(coords) do
    begin
      if coords[i].x < minCoord.x then
        minCoord.x := coords[i].x;

      if coords[i].y < minCoord.y then
        minCoord.y := coords[i].y;

      if coords[i].x > maxCoord.x then
        maxCoord.x := coords[i].x;

      if coords[i].y > maxCoord.y then
        maxCoord.y := coords[i].y;
    end;

    for i := 0 to high(coords) do
    begin
      with (coords[i] - minCoord) do
        coords[i] := PointF((x / (maxCoord.x - minCoord.x) - 0.5) *
          2 * rx + cx, (y / (maxCoord.y - minCoord.y) - 0.5) * 2 * ry + cy);
    end;

    beginPath;

    for i := 0 to high(coords) do
    begin
      lineTo((coords[i] + coords[(i + 1) mod length(coords)]) * (1 / 2));
      arcTo(coords[(i + 1) mod length(coords)], coords[(i + 2) mod length(coords)], FBorder.RoundRadius);
    end;

    closePath;
    fill;

    if aWidth <> 0 then
      stroke;

    fillStyle(BGRAWhite);
    strokeStyle(BGRABlack);

    fillGrad.Free;
    borderGrad.Free;
  end;

  FBGRA.Draw(Self.Canvas, 0, 0, False);
end;

procedure TKiEdit.Resize;
begin
  if FBGRA <> nil then
    FBGRA.SetSize(Width, Height);

  inherited Resize;
  Invalidate;
end;

procedure TKiEdit.Click;
begin
  inherited Click;
  SetFocus;

  if Assigned(FOnClick) then
    FOnClick(Self);
end;

constructor TKiEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height   := 30;
  Width    := 80;
  TabStop  := True;
  ShowHint := True;
  EditType := etText;

  FBorder  := TBorder.Create(Self);
  FFill    := TFill.Create(Self);
  FBGRA    := TBGRABitmap.Create(Width, Height, BGRAPixelTransparent);
end;

destructor TKiEdit.Destroy;
begin
  FreeAndNil(FBGRA);
  FreeAndNil(FBorder);
  FreeAndNil(FFill);
  inherited Destroy;
end;


end.

