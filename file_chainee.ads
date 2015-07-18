with ABR; use ABR;

package File_Chainee is

 type Cellule;
   type File is access Cellule;



   --déclaration du type cellule sans la définition (elle se fait plus tard
   type Cellule is record
      abr: Arbre;
      Suiv:file;
   end record;

   --fonctions caractéristiques des files
   function Est_Vide(F:in File) return boolean;
   function Nouvelle_File return File;

   --procedures caractéristiques des files
   procedure Enfiler(F: in out file; A: in arbre);
   procedure Afficher(F:in File);
   procedure defiler (F : in out File; A :in out arbre );
   procedure met_a_jour (F: in out File; A: in arbre );
   procedure vide(L: in out file);
   
   --exceptions
   Erreur_File_Vide : exception;



end File_Chainee;






















