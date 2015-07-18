
package code is

	Code_Vide, Code_Trop_Court : exception;


	-- Representation de bits
	type Bit is new Natural range 0 .. 1;
	for bit'size use 2;

	ZERO : constant Bit := 0;
	UN   : constant Bit := 1;

	type Code_Binaire_Interne;
	type Code_Binaire is access Code_Binaire_Interne;

	type Code_Binaire_interne is record
		Val:bit;
		Suiv:Code_Binaire;
	end record;

	type Dico is array (0..255) of Code_binaire;


	-- Cree un code initialement vide
	function Cree_Code return Code_Binaire;
	-- Libere un code
	procedure Libere_Code(C : in out Code_Binaire);
	-- Affiche un code
	procedure Afficher(C : in Code_Binaire);
	-- Ajoute le bit B en queue du code C
	procedure Ajouter_queue(B : in Bit; C : in out Code_Binaire);
	procedure copie(ori: in code_binaire; clone: in out code_binaire);
	procedure vide_bin(F:in out code_binaire);

end code;
