program Cadastrov2;

uses
  Vcl.Forms,
  UCad in 'UCad.pas' {FrmCad},
  UAddCad in 'UAddCad.pas' {FrmAddCad};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCad, FrmCad);
  Application.CreateForm(TFrmAddCad, FrmAddCad);
  Application.Run;
end.
