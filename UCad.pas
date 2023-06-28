unit UCad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Datasnap.Provider,
  Datasnap.DBClient, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, FireDAC.Phys.IB, FireDAC.Phys.IBDef;

type
  TFrmCad = class(TForm)
    DgbCadastro: TDBGrid;
    ToolBarCadastro: TToolBar;
    ImageListCadastro: TImageList;
    BtnAdicionar: TToolButton;
    BtnExcluir: TToolButton;
    BtnEditar: TToolButton;
    FdcCad: TFDConnection;
    FdqCad: TFDQuery;
    DsCad: TDataSource;
    CdsCad: TClientDataSet;
    DspCad: TDataSetProvider;
    CdsCadID: TIntegerField;
    CdsCadDATACADASTRO: TSQLTimeStampField;
    CdsCadNOME: TStringField;
    CdsCadCPFCNPJ: TStringField;
    CdsCadDATANASCIMENTO: TSQLTimeStampField;
    CdsCadCIDADE: TStringField;
    CdsCadESTADO: TStringField;
    CdsCadEDICAO: TStringField;
    procedure BtnAdicionarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure StatusBarra(BarraCadastro: TDataSet);
    { Public declarations }
  end;

var
  FrmCad: TFrmCad;

implementation

{$R *.dfm}

uses UAddCad;

{ TFrmCadastro }

procedure TFrmCad.BtnAdicionarClick(Sender: TObject);
begin
 FrmAddCad.FdqAddCad.Open;
 FrmAddCad.CdsAddCad.Append;
 FrmAddCad.ShowModal;
 FdqCad.Refresh;
 CdsCad.Refresh;
end;

procedure TFrmCad.BtnEditarClick(Sender: TObject);
begin
 CdsCad.Edit;
 CdsCadEDICAO.AsString := 'S';
 FrmAddCad.CdsAddCad.Edit;
 FrmAddCad.ShowModal;
 StatusBarra(CdsCad);
end;

procedure TFrmCad.BtnExcluirClick(Sender: TObject);
begin
 if Application.MessageBox(Pchar('Deseja excluir o cadastro?'), 'Confirmação', MB_USEGLYPHCHARS + MB_DEFBUTTON2) = mrYES then
 begin
  FrmAddCad.CdsAddCad.Delete;
  FdqCad.Refresh;
  CdsCad.Refresh;
  StatusBarra(CdsCad);
 end;
end;

procedure TFrmCad.FormShow(Sender: TObject);
begin
 CdsCad.Open;
 FdqCad.Open;
 FrmAddCad.CdsAddCad.Open;
 StatusBarra(CdsCad);
end;

procedure TFrmCad.StatusBarra(BarraCadastro: TDataSet);
begin
 BtnAdicionar.Enabled := not (BarraCadastro.State in [dsEdit, dsInsert]);
 BtnEditar.Enabled := not (BarraCadastro.State in [dsEdit, dsInsert]) and not (BarraCadastro.IsEmpty);
 BtnExcluir.Enabled := not (BarraCadastro.State in [dsEdit, dsInsert]) and not (BarraCadastro.IsEmpty);
end;

end.
