with   Ada.Text_Io;
use   Ada.Text_Io ;

package body tableaux is

	-----------------------------------------------
	function est_vide(T:in tab) return boolean is
	begin
		for k in T'range loop
			if T(k)/=0 then
				return false;
			end if;
		end loop;
		return true;

	end est_vide;

	------------------------------------------------

	function Indice_max(T:in Tab) return Integer is
		max:Integer:=T(0);
		Ind_max:Integer:=0;
	begin
		for K in T'Range loop
			if max<T(K) then
				max := T(K);
				Ind_max := K;
			end if;
		end loop;
		return Ind_max;
	end Indice_max;

	------------------------------------------------

	procedure Afficher(T:in Tab) is
	begin
		for K in T'Range loop
			New_Line;
			Put("caractere:" & integer'image(K)& " occurence:"&Integer'Image(T(K)));
		end loop;
	end Afficher;


end tableaux;




