with   Ada.Text_Io,Ada.Unchecked_Deallocation;
use   Ada.Text_Io ;

package body Code is


   --déclaration du type cellule sans la définition (elle se fait plus tard
   

   procedure Liberer is new Ada.Unchecked_Deallocation (Code_Binaire_interne,Code_binaire);

   ---------FONCTIONS--------------------------------------------------------
   function Cree_Code return Code_Binaire is
   begin
      return null;
   end Cree_Code;
-----------------------------------------------------------------------------

   procedure Libere_Code(C : in out Code_Binaire) is
      Temp:Code_Binaire:=C;
   begin
      while C /= null loop
         Temp:=C;
         C:=C.Suiv;
         Liberer(Temp);
      end loop;
   end Libere_Code;
---------------------------------------------------------------------------

   procedure Afficher(C : in Code_Binaire) is
      Temp:Code_Binaire:=c;
   begin
if c= null then put("code binaire vide");
end if;
      while Temp /= null loop
         Put(bit'Image(temp.Val));
         Temp:=Temp.Suiv;
      end loop;
   end afficher;
------------------------------------------------------------------------------

   procedure Ajouter_queue(B : in Bit; C : in out Code_Binaire) is
      Nouveau:Code_binaire:=new Code_Binaire_Interne'(B,null);
      Temp:Code_Binaire:=C;
   begin
      if C=null then     -- si la file est vide on met simplement le
         c := nouveau;
      else
         while Temp.suiv /= null loop
            temp := temp.suiv;
         end loop;
         -- on fait le chaînage
         temp.suiv := nouveau;
      end if;
   end Ajouter_Queue;
------------------------------------------------------------------------------------
    procedure copie(ori: in code_binaire; clone: in out code_binaire) is
             temp:code_binaire:=ori;
             B:Bit;
     begin
             while temp /= null loop
                B:=Temp.Val;
                ajouter_queue(b,clone);
                temp := temp.suiv;
             end loop;
     end copie;
-----------------------------------------------------------------------------

	procedure vide_bin(F: in out code_binaire) is
	begin
		if F /= null then 
			if F.suiv /= null then
				vide_bin(F.suiv);
			end if;
			Liberer(F);
		end if;
	end vide_bin;

-----------------------------------------------------------------------------




end Code;
