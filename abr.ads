

package ABR is


   type noeud;
   type Arbre is access Noeud;
   type Noeud is record
      prio : integer;
      Fg, Fd : Arbre;
      Ascii:Integer;
      end record;




        -- Retourne l'arbre vide
        function Arbre_Vide return Arbre;

        -- Retourne true si l'arbre est vide, false sinon
        function Est_Vide(A : in Arbre) return Boolean;

        --  Libere l'arbre A
        procedure Libere_Arbre(A : in out Arbre);

        -- Affiche toutes les Prioeurs de A par ordre croissant
        procedure Afficher(A : in Arbre);

        -- Requiert: A est un ABR
        -- Garantit: E insere dans A, A est toujours un ABR
        procedure Insere(E : in integer;code : in integer; A : in out Arbre);

        -- Retourne true si E est present dans A, false sinon.
        -- Version iterative
        function Est_Present_Iter(E : in integer; A : in Arbre) return Boolean;
        function hauteur(A: in arbre) return Integer;


end ABR;

