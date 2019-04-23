unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  KiEdit, BGRAShape;

type

  { TForm1 }

  TForm1 = class(TForm)
    BGRAShape1: TBGRAShape;
    Button1: TButton;
    Edit1: TEdit;
    KiEdit1: TKiEdit;
    KiEdit2: TKiEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    procedure BorderEditColorEnter(Sender: TObject);
    procedure BorderEditColorExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure KiEdit1Click(Sender: TObject);
    procedure KiEdit1MouseEnter(Sender: TObject);
    procedure KiEdit1MouseLeave(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.BorderEditColorEnter(Sender: TObject);
begin
  BGRAShape1.BorderColor := clHighlight;
end;

procedure TForm1.BorderEditColorExit(Sender: TObject);
begin
  BGRAShape1.BorderColor := clWindowText;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  KiEdit1.Enabled := not KiEdit1.Enabled;

  if KiEdit1.Enabled then
    Label2.Caption := 'Estado: Ativo'
  else
    Label2.Caption := 'Estado: Inativo';
end;

procedure TForm1.KiEdit1Click(Sender: TObject);
begin
  if KiEdit1.Enabled then
    Label1.Caption := 'Status: Clicou';
end;

procedure TForm1.KiEdit1MouseEnter(Sender: TObject);
begin
  if KiEdit1.Enabled then
    Label1.Caption := 'Status: Entrou';
end;

procedure TForm1.KiEdit1MouseLeave(Sender: TObject);
begin
  if KiEdit1.Enabled then
    Label1.Caption := 'Status: Saiu';
end;

end.

