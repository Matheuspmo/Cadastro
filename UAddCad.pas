unit UAddCad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Datasnap.Provider, Datasnap.DBClient,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, Vcl.ToolWin, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.ExtCtrls, FireDAC.Phys.IB, FireDAC.Phys.IBDef;

type
  TFrmAddCad = class(TForm)
    DsAddCad: TDataSource;
    CdsAddCad: TClientDataSet;
    DspAddCad: TDataSetProvider;
    TNome: TLabel;
    DbNome: TDBEdit;
    TCPF: TLabel;
    DbCPF: TDBEdit;
    TDataNascimento: TLabel;
    TCidade: TLabel;
    TEstado: TLabel;
    ToolBar1: TToolBar;
    ImageListAddCad: TImageList;
    BtnSalvar: TToolButton;
    BtnCancelar: TToolButton;
    PAddCad: TPanel;
    DtpDataNascimento: TDateTimePicker;
    FdcCidade: TFDConnection;
    FdqCidade: TFDQuery;
    DsCidade: TDataSource;
    DblCidade: TDBLookupComboBox;
    DblEstado: TDBLookupComboBox;
    FdqEstado: TFDQuery;
    DsEstado: TDataSource;
    RbCPF: TRadioButton;
    RbCNPJ: TRadioButton;
    FdqAddCad: TFDQuery;
    FdcAddCad: TFDConnection;
    CdsAddCadDATACADASTRO: TSQLTimeStampField;
    CdsAddCadNOME: TStringField;
    CdsAddCadCPFCNPJ: TStringField;
    CdsAddCadDATANASCIMENTO: TSQLTimeStampField;
    CdsAddCadCIDADE: TStringField;
    CdsAddCadESTADO: TStringField;
    procedure BtnSalvarClick(Sender: TObject);
    procedure CdsAddCadAfterInsert(DataSet: TDataSet);
    procedure CdsAddCadAfterPost(DataSet: TDataSet);
    procedure CdsAddCadAfterDelete(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure RbCNPJClick(Sender: TObject);
    procedure RbCPFClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure DblEstadoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAddCad: TFrmAddCad;

implementation

{$R *.dfm}

uses UCad;

procedure TFrmAddCad.BtnCancelarClick(Sender: TObject);
begin
 CdsAddCad.Cancel;
 FrmAddCad.Close;
 FrmCad.CdsCad.Close;
 FrmCad.CdsCad.Open;
 FrmCad.StatusBarra(FrmCad.CdsCad);
end;

procedure TFrmAddCad.BtnSalvarClick(Sender: TObject);
begin
 if ((DbNome.Text <> '') and (DbCPF.Text <> '') and (DblCidade.Text <> '') and (DblEstado.Text <> '')) then
 begin
  if ((RbCPF.Checked) and (Length(DbCPF.Text)<11)) or ((RbCNPJ.Checked) and (Length(DbCPF.Text)<14)) then
  begin
   Application.MessageBox(Pchar('Tamanho de CPF/CNPJ inválido!'), 'Aviso');
  end
  else
  begin
   CdsAddCad.FieldByName('DATANASCIMENTO').AsDateTime := DtpDataNascimento.DateTime;
   CdsAddCad.Post;
   FrmAddCad.Close;
  end;
 end
 else
  Application.MessageBox(Pchar('Favor preencher todos os campos!'), 'Aviso');
end;

procedure TFrmAddCad.CdsAddCadAfterDelete(DataSet: TDataSet);
begin
 CdsAddCad.ApplyUpdates(0);
end;

procedure TFrmAddCad.CdsAddCadAfterInsert(DataSet: TDataSet);
begin
 CdsAddCadDATACADASTRO.AsDateTime := date();
end;

procedure TFrmAddCad.CdsAddCadAfterPost(DataSet: TDataSet);
begin
 CdsAddCad.ApplyUpdates(0);
end;

procedure TFrmAddCad.DblEstadoExit(Sender: TObject);
begin
 FdqCidade.Close;
 FdqCidade.ParamByName('Estado').AsString := DblEstado.Text;
 FdqCidade.Open;
end;

procedure TFrmAddCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FdqAddCad.SQL.Clear;
end;

procedure TFrmAddCad.FormCreate(Sender: TObject);
begin
 FdqAddCad.Open;
end;

procedure TFrmAddCad.FormShow(Sender: TObject);
begin
  if  FrmCad.CdsCadEDICAO.AsString = 'S' then
  begin
    CdsAddCad.Close;
    FdqAddCad.Close;
    FdqAddCad.SQL.Clear;
    FdqAddCad.SQL.Add('SELECT DATACADASTRO,NOME,CPFCNPJ,DATANASCIMENTO,CIDADE,ESTADO');
    FdqAddCad.SQL.Add('FROM CADASTRO2');
    FdqAddCad.SQL.Add('WHERE ID = :ID');
    FdqAddCad.ParamByName('ID').AsString := FrmCad.CdsCadID.AsString;
    FdqAddCad.Open;
    CdsAddCad.Open;
    DbNome.Text := FrmCad.CdsCad.FieldByName('NOME').AsString;
    DbCPF.Text := FrmCad.CdsCad.FieldByName('CPFCNPJ').AsString;
    DtpDataNascimento.DateTime := FrmCad.CdsCad.FieldByName('DATANASCIMENTO').AsDateTime;
  end;

 DbNome.SetFocus;
 CdsAddCadCPFCNPJ.EditMask := '!999.999.999-99;0; ';
 FdqCidade.Active := true;
 FdqEstado.Active := true;
end;

procedure TFrmAddCad.RbCNPJClick(Sender: TObject);
begin
 CdsAddCadCPFCNPJ.EditMask := '!99.999.999/9999-99;0; ';
end;

procedure TFrmAddCad.RbCPFClick(Sender: TObject);
begin
 CdsAddCadCPFCNPJ.EditMask := '!999.999.999-99;0; ';
end;

end.
