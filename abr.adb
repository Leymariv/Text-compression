With Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body ABR is

------------------------------------------------------------------------
      procedure Libere_Noeud is new Ada.Unchecked_Deallocation (noeud, Arbre);
------------------------------------------------------------------------

        function Arbre_Vide return Arbre is
        begin
                return null;
        end Arbre_Vide;

------------------------------------------------------------------------

        function Est_Vide(A : in Arbre) return Boolean is
        begin
                return A = Arbre_Vide;
        end Est_Vide;

------------------------------------------------------------------------

        procedure Libere_Arbre(A : in out Arbre) is
        begin
                if A = null then
               return;
                end if;
                Libere_Arbre(A.Fg);
                Libere_Arbre(A.Fd);
                Libere_Noeud(A);
		

        end Libere_Arbre;

------------------------------------------------------------------------

        procedure Afficher(A : in Arbre) is
        begin
                if A = null then
                        return;
                end if;
                Afficher(A.Fg);
                put(integer'image(A.ascii)&"/"&integer'image(A.prio));
		New_line;
                Afficher(A.Fd);

        end Afficher;

------------------------------------------------------------------------

        procedure Insere(E : in Integer; code: in Integer ; A : in out Arbre) is
        N: Arbre := new Noeud'(E,null,null,code);
        begin
                -- prise en compte de l'arbre null :
                if A = null then
                        A := N;
                        return;
                end if;
                -- on place l'élément au bon endroit
                if E <= A.prio then
                        Insere(E,code,A.Fg);
                else
                        Insere(E,code,A.Fd);
                end if;
        end Insere;

------------------------------------------------------------------------


        -- un peu d'iteratif pour changer!
        function Est_Present_Iter(E : in Integer; A : in Arbre) return Boolean is
                Cour : Arbre := A;
                begin
                        while Cour /= null loop
                                if Cour.prio = E then
                                        return true;
                                elsif Cour.prio <= E then
                                        Cour:= Cour.Fd;
                                else
                                        Cour:= Cour.Fg;
                                end if;
                        end loop;
                return false;
                end Est_Present_Iter;

-------------------------------------------------------------------------

                function hauteur( A: in Arbre) return Integer is
                        D:integer;
                        G:integer;
                        begin
                                if A = null then
                                        return -1;
                                else
                                        D := hauteur(A.fd);
                                        G := hauteur(A.fg);
                                        if D>G then
                                                return 1+D;
                                        else
                                                return 1+G;
                                        end if;
                                end if;
                        end hauteur;

---------------------------------------------------------------------------







end ABR;
