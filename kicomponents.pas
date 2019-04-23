{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit KiComponents;

{$warn 5023 off : no warning about unused units}
interface

uses
  KiEdit, KiBorder, KiFill, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('KiEdit', @KiEdit.Register);
end;

initialization
  RegisterPackage('KiComponents', @Register);
end.
