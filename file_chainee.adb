with   Ada.Text_Io,Ada.Unchecked_Deallocation,abr ;
use   Ada.Text_Io,abr;


package body File_chainee is




   procedure Liberer is new Ada.Unchecked_Deallocation (Cellule,File);

   ----------------------------------------------------------------------------

   function Nouvelle_File return File is
   begin
      return null;
   end Nouvelle_File;

   ---------------------------------------------------------------------------------

   function Est_Vide(F:in File) return Boolean is
   begin
      if F = Null then return True;
      else return False;
      end if;
   end Est_Vide;

   ---------------------------------------------------------------------------------

   procedure Afficher (F:in File) is
      Temp:File:=F;
   begin
      if f = null then
         New_Line;
         put("File vide!");
      end if;
      while temp /= null loop
         new_line;
         put("element de la file : ");
         --Affiche(Temp.abr);
         Put("caractere '"& Integer'image(temp.abr.ascii)&"' apparait "& Integer'Image(Temp.abr.Prio)&" fois");
         temp:=temp.Suiv;
      end loop;
      Liberer(Temp);
   end Afficher;

   -------------------------------------------------------------------------------------------

   procedure defiler (F : in out File; A :in out arbre) is
      temp:file := F;
   begin
      if F = null then raise Erreur_file_vide;
      end if;
      A := F.abr;
      F := F.suiv;
      Liberer(temp);
   end defiler;


   ----------------------------------------------------------------------------------------------




   procedure met_a_jour( F: in out File; A: in arbre  ) is
      Temp: file:=F;
      prec: file:=F;
      Nv_maillon:File := new cellule'(A,null);

   begin
      if Est_Vide(F) then     -- si la file est vide on met simplement le
                                --nouveau maillon en lieu et place de la file.
         F := Nv_maillon;
      else
         if A.prio < F.abr.prio then
		 Nv_maillon.suiv := F;
		 F := Nv_maillon;

         else
            -- on se place au bon endroit
            while temp /= null and then A.prio > temp.abr.prio loop
               prec := temp;
               temp := temp.suiv;
            end loop;
            -- on fait le chaînage
            temp:=prec.suiv;
            Nv_maillon.suiv := temp;
            prec.suiv := Nv_maillon;
         end if;
      end if;
   end;

   ----------------------------------------------------------------------------------------------
procedure enfiler(F: in out file; A: in arbre) is 
	temp:file:=F;
begin
	if est_Vide(F) then
		F := new cellule'(A,null);
	else
		while temp.suiv /= null loop
			temp := temp.suiv;
		end loop;
		temp.suiv := new cellule'(A,null);
	end if;
end enfiler;
--------------------------------------------------------------------------------------------

procedure vide(L: in out file) is 
begin
	if L /= null then
		if L.suiv /= null then
			vide(L.suiv);
		end if;
		Liberer(L);
	end if;
end vide;

---------------------------------------------------------------------------------------------


end File_Chainee;


































