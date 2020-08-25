unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Permissions, FMX.ListView.Appearances,
  FMX.ListView.Types, FMX.ListView.Adapters.Base, FMX.ListView,
  System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ActionList1: TActionList;
    ActPhotoCamera: TTakePhotoFromCameraAction;
    Button2: TButton;
    Image1: TImage;
    ListView1: TListView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActPhotoCameraDidFinishTaking(Image: TBitmap);
    procedure Button2Click(Sender: TObject);
  private
    {$IFDEF ANDROID}
    PermissaoCamera, PermissaoReadStorage, PermissaoWriteStorage : string;
    procedure TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
    {$ENDIF}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
uses FMX.DialogService
{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}
;

{$IFDEF ANDROID}
procedure TForm1.TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 3 Permissoes: CAMERA, READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
                ActPhotoCamera.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para tirar fotos');
end;
{$ENDIF}

procedure TForm1.ActPhotoCameraDidFinishTaking(Image: TBitmap);
var
 ItemAdd : TListViewItem;
 textObj : TListItemText;
 imageItem : TListItemImage;
begin
//  ListView1.Items.Clear;
  ListView1.BeginUpdate;
  with ListView1.Items.Add do
  begin
//   Items := 'Olá mundo';
   textObj := Objects.FindObjectT<TListItemText>('Text1');
   textObj.Text := 'olá';
   imageItem := Objects.FindObjectT<TListItemImage>('Image2');
   imageItem.Bitmap := Image;
  end;
  ListView1.EndUpdate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([PermissaoCamera,
                                           PermissaoReadStorage,
                                           PermissaoWriteStorage],
                                           TakePicturePermissionRequestResult);
    {$ENDIF}
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 ItemAdd : TListViewItem;
 textObj : TListItemText;
 imageItem : TListItemImage;
 aux : TBitmap;
begin
//  ListView1.Items.Clear;
  ListView1.BeginUpdate;
  ItemAdd := ListView1.Items.Add;

//   Items := 'Olá mundo';
   textObj := ItemAdd.Objects.FindObjectT<TListItemText>('Text1');
   textObj.Text := 'olá';
   imageItem := ItemAdd.Objects.FindObjectT<TListItemImage>('Image2');
    aux.LoadFromFile('C:\Users\renato\Pictures\redacao3.png');
   imageItem.Bitmap := aux;

  ListView1.EndUpdate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     {$IFDEF ANDROID}
      PermissaoCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
      PermissaoReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
      PermissaoWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
      {$ENDIF}
end;

end.
