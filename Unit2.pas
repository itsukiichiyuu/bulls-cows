{�l�ve HERNANDEZ ALEXIS}

unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Ifond: TImage;
    Lnom: TLabel;
    Emot: TEdit;
    Enbbulls: TEdit;
    Enbcows: TEdit;
    Ereste: TEdit;
    Bcheck: TButton;
    Bquit: TButton;
    Braz: TButton;
    Lbulls: TLabel;
    Lcows: TLabel;
    stockmot: TMemo;
    Llgmot: TLabel;
    Ltest: TLabel;
    procedure BquitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BcheckClick(Sender: TObject);
    procedure BrazClick(Sender: TObject);
  private
    mot:string;
    lgmot,essai:integer;
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//---------------------------------------------------------------------------

//on test si il y a plusieurs fois la m�me lettre
function erreur(cherche:string):boolean;
var
  i,j:integer;
  test:boolean;
begin
test:=false;
for i := 1 to length(cherche) do
begin
  for j := 1 to length(cherche) do
  begin
      if (i<>j) and (cherche[i]=cherche[j]) then
      test:=true;
  end;
end;

erreur:=test;

//s'il y a bien plusieurs fois la m�me lettre, on affiche une erreur
if test=true then
  showmessage ('vous avez tap� plusieurs fois la m�me lettre');
end;

//---------------------------------------------------------------------------

//test s'il y a un caract�re sp�cial dans le mot
function erreur2(cherche:string):boolean;
var
  i:integer;
  test:boolean;
begin
erreur2:=false;
test:=false;
for i := 1 to length(cherche) do
begin
  if (cherche[i]<'a') or (cherche[i]>'z') then
    test:=true;
end;

erreur2:=test;

//s'il y a bien un caract�re sp�cial, on affiche une erreur
if test=true then
  showmessage ('pas de caract�re sp�ciaux (,?;.:&...)');
end;

//---------------------------------------------------------------------------

function erreur3(cherche,mot:string):boolean;
begin
    //test si rien n'a �t� tap�
  if cherche='' then
  begin
    erreur3:=true;
    showmessage('vous n''avez rien tap�');
  end

  //test si le mot tap� est trop long
  else if length(cherche)> length(mot) then
  begin
    erreur3:=true;
    showmessage ('vous avez tap� un mot trop long');
  end

  //test si le mot tap� est trop court
  else if length(cherche)< length(mot) then
  begin
    erreur3:=true;
    showmessage ('vous avez tap� un mot trop court');
  end;
end;

//---------------------------------------------------------------------------

//but: r�aliser tout les tests de comparaison
//entr�es: la variable cherche
//sortie: toutes les variables �dit�es en fonction de "cherche"
procedure TForm1.BcheckClick(Sender: TObject);
var
  gagne:boolean;
  i,j,bulls,cows:integer;
  cherche:string;
begin

//-----------------INITIALISATION DES DONNEES---------------------
  gagne:=false;
  cherche:=Emot.Text;
  bulls:=0;
  cows:=0;
//----------------------FIN INITIALISATION------------------------

  cherche:=lowercase(cherche);  //on r�duit tout  en minuscule

  if cherche=mot then   //si le joueur trouve il saute les tests
  begin
    gagne:=true;
  end;

  //si il n'y a pas d'erreurs on continue le programme
  if (gagne=false)and (erreur(cherche)=false) and (erreur2(cherche)=false) then
  begin
  //si il n'y a toujours aucune erreurs on calcule les bulls et les cows
  //on compare la chaine mot avec le chaine cherche
    if erreur3(cherche,mot)=false then
    begin
      for i := 1 to length(mot) do
      begin
        for j := 1 to length(mot) do
        begin
          if (i=j) and (mot[i]=cherche[j]) then
            bulls:=bulls+1;//si on trouve une lettre au bon emplacement bulls+1
          if (i<>j) and (mot[i]=cherche[j]) then
            cows:=cows+1;  //si on trouve une lettre au mauvais placement cows +1
        end;
      end;
      Enbbulls.Text:=inttostr(bulls); //affichage des bulls
      Enbcows.Text:=inttostr(cows);   //affichage des cows
      essai:=essai-1;                 // retrait d'un essai

      //message pour donner le nombre d'essais restants
      Ereste.Text:='il vous reste :'+inttostr(essai)+'essais';

      //si le joueur n'a plus d'essai il a perdu
      if essai=0 then
      begin
        if MessageDlg('Perdu :( voulez-vous recommencer ?',
        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo then
        begin
          //le joueur choisis non, il quitte
          Close
        end
        //si le joueur veux rejouer le jeux se r�initialise
        else
        begin
          BrazClick(Sender);
        end;
      end;
    end;
  end;

  if gagne=true then
      if MessageDlg('BRAVO vous avez trouv� le mot ! voulez-vous recommencer ?',
      mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo then
      //le joueur choisis non, il quitte
        Close
      //si le joueur veux rejouer le jeux se r�initialise
      else
      BrazClick(Sender);
end;

//---------------------------------------------------------------------------

procedure TForm1.BquitClick(Sender: TObject);
begin
  close;
end;

//but: r�initialiser le jeu
//entr�e: les variables du jeu � modifier
//sortie: les variable r�initialis�es
procedure TForm1.BrazClick(Sender: TObject);
begin
  mot:=stockmot.Lines[Random(stockmot.Lines.Count-1)];
//Ltest.Caption:=mot; //debug pour voir le mot
  lgmot:=length(mot);

//g�re le nombre d'essai possible en fonction de la taille du mot
  case length(mot) of
    3:essai:=4;
    4:essai:=7;
    5:essai:=10;
    6:essai:=16;
    7:essai:=20;
  end;
  Ereste.Text:='il vous reste :'+inttostr(essai)+'essais';
  Llgmot.Caption:='mot en '+inttostr(lgmot)+' lettres';
  Enbbulls.Text:='';
  Enbcows.Text:='';
  Emot.Text:='';
  Emot.Setfocus;
end;

//---------------------------------------------------------------------------

//but: initialiser le jeu
//entr�e: les variables vides du jeu � modifier
//sortie: les variable initialis�es
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;

  stockmot.Lines.LoadFromFile('dico.txt'); //charge le fichier .txt des mots
  mot:=stockmot.Lines[Random(stockmot.Lines.Count-1)];
  //Ltest.Caption:=mot; //debug pour voir le mot
  lgmot:=length(mot);

  //g�re le nombre d'essai possible en fonction de la taille du mot
  case length(mot) of
    3:essai:=4;
    4:essai:=7;
    5:essai:=10;
    6:essai:=16;
    7:essai:=20;
  end;

  Ereste.Text:='il vous reste :'+inttostr(essai)+'essais';
  Llgmot.Caption:='mot en '+inttostr(lgmot)+' lettres';

end;

//---------------------------------------------------------------------------

end.
//------------------------------FIN PROGRAMME--------------------------------
