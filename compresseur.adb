with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with abr; use abr;
with File_Chainee; use File_Chainee;
with tableaux; use tableaux;
with Code;use Code;
with Unchecked_Deallocation ;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
--   $ od -t x1 exemple_io.txt

package body Compresseur is


	-------------DECLARATION DE NOS VARIABLES------------------------------------------



	T_ascii:Tab:=(others=>0); 	-- Notre tableau qui sera notre table ascii (T[65]='A')
	F_Prio:File:=Nouvelle_file; 	
	-- File chainée d'arbre qui va recenser les ordres d'apparitions des caractères 
	-- (du moins fréquent au plus fréquent). C'est la structure arbre qui contient les 
	-- champs code ascii (abr.ascii) et nombre d'occurence (abr.prio).

	huffmann: arbre;	-- Notre arbre de huffmann
	Code:Code_Binaire;	-- File chainée de "bit"
	T_Trad:Dico; 	
	-- Notre dictionnaire qui est en fait une table de hachage 
	-- (tableau dont les indices repréentent le code ascii du 
	-- caractére, et dont les éléments sont des "code_binaires"


	Fichier : Ada.Streams.Stream_IO.File_Type;
	Fichier2 : Ada.Streams.Stream_IO.File_Type;
	Flux : Ada.Streams.Stream_IO.Stream_Access;
	Flux2 : Ada.Streams.Stream_IO.Stream_Access;



	--------------NOS PROCEDURES SECONDAIRES-------------------------------------------
	-- Lecture d'un fichier et incrémente les cases du tableau(ascii)

	procedure Tab_prio(T:in out Tab;Nom_Fichier : in String) is
		C : Character;
	begin
		Open(Fichier, In_File, Nom_Fichier);
		Flux := Stream(Fichier);
		-- lecture tant qu'il reste des caracteres:
		while not End_Of_File(Fichier) loop
			C := Character'Input(Flux);
			T(Character'Pos(C)):=T(Character'Pos(C))+1;
		end loop;
		Close(Fichier);
	end Tab_prio;


	-----------------------------------------------------------------------------------
	--Crée une file chainée de code ascii et de leur occurence dans l'ordre croissant.
	--A partir du tableau précédent.

	procedure File_Prio (F :in out File; T:in out tab) is
		Indice:Integer:=0; --indice de la lettre qui revient le plus
		N:Arbre;
	begin
		-- tant que tableau précédent non vide :
		while not est_Vide(T) loop
			Indice:=Indice_max(T);
			-- priorité / fg / fd / ascii
			N := new Noeud'(T(indice),null,null,Indice);
			met_a_jour(F,N);
			T(Indice):=0;
		end loop;


	end File_Prio;

	-------------------------------------------------------------------------------------------------------------
	-- creation de l'arbre de huffman selon la méthode décrite sur le sujet

	procedure creation_huffmann(F : in out File ; A:in out Arbre) is
		G,N,D:arbre;
	begin
		while F.suiv /= null loop
			defiler(F,G);
			defiler(F,D);
			N:=new noeud'(D.Prio + G.prio,G,D,266);
			met_a_jour(F,N);
		end loop;
		A:=F.Abr;
	end creation_huffmann;

	-----------------------------------------------------------------------------------

	-- Creation de la table de hachage contenat chaque caractére ainsi que leur code 
	-- en binaire. Ce sera notre "dictionnaire"

	procedure Const_dico(A:in out Arbre;T:in out dico; F: in out code_binaire) is
		fileg:code_binaire;
		filed:code_binaire;
	begin
		if A.ascii < 266 then
			T(A.ascii):=F;
		else
			if A.fg /= null then
				copie(F,fileg);
				ajouter_queue(ZERO,fileg);
				Const_dico(A.fg,T,fileg);
			end if;
			if A.fd /= null then
				copie(F,filed);
				ajouter_queue(UN,filed);
				Const_dico(A.fd,T,Filed);
			end if;
			vide_bin(F);
		end if;
	end Const_dico;

	-----------------------------------------------------------------------------------
	-- Sauvegarde de la file  de priorité qui permet de construit l'arbre de H.
	-- on stocke le code ascii avec sa priorité
	-- Les caractères de priorité 0 ne sont pas écrit:
	-- l'integer 0 sert de critère d'arrêt (4 bit à 0)

	procedure Ecrire_File(F:in File;Nom_Fichier:in string) is
		Temp:File:=F;
	begin
		--creation du fichier.comp
		create(Fichier, append_File, Nom_Fichier);
		Flux := Stream(Fichier);
		while Temp /= null loop
			-- sous forme de int, car la priorité peut > 256 et cela 
			-- permet de bien différencier l'arbre du code.
			Integer'Output(Flux,Temp.Abr.ascii);
			Integer'Output(Flux,Temp.Abr.prio);
			Temp:=Temp.Suiv;
		end loop;
		Integer'Output(Flux,0);
		Close(Fichier);
	end Ecrire_file;
	------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------

	--Ecriture de notre texte en binaire.
	--tant qu'on est pas a la fin du texte, tant que la file chainée représentant le code binaire de notre caractére n'est pas vide,on remplit notre variable Octet. Si octet est pleine on l'ecrit dans notre fichier compressé.

	Procedure Text_Bin(dictionnaire: in out dico; fichierAcompresser: in string; fichierAecrire: in string) is
	C:Character;
	X:integer;
	octet_a_ecrire:Octet := 0;
	F:code_binaire := null;
	huit:integer := 0;
begin

	Open(Fichier, In_File, fichierAcompresser);
	Flux := Stream(Fichier);
	Open(Fichier2, append_File, fichierAecrire);
	Flux2 := Stream(Fichier2);

	-- lecture tant qu'il reste des caracteres on incrémente la case qui leur correspond
	while not End_Of_File(Fichier) loop
		C := Character'Input(Flux);
		X := Character'pos(C);
		F := dictionnaire(X);
		while F /= null loop -- on écrit tout le nouveau code binaire du character
			if F.Val = 0 then
				-- on décale vers la droite pour écrire 0 en queue
				octet_a_ecrire := octet_a_ecrire*2;
				huit := huit+1;
			else -- F.Val = 1
				-- on décale vers la droite+1 pour écrire 1 en queue
				octet_a_ecrire := octet_a_ecrire*2+1;
				huit := huit+1;
			end if;
			if huit = 8 then
				-- on écrit, on réinitialise et on recommence
				Octet'Output(Flux2,octet_a_ecrire);
				octet_a_ecrire := 0;
				huit := 0;
			end if;
			F:=F.suiv;
		end loop;
	end loop;
	Close(Fichier);
	Close(Fichier2);
end Text_Bin;


----------------------------------------------------------------------------

procedure vide_dico(D: in out dico) is
begin
	for I in 0..255 loop
		vide_bin(D(I));
	end loop;
end vide_dico;






-------------------------------NOTRE PROCEDURE PRINCIPALE------------------

procedure Compresser(Nom_Fichier:In String;Nom_Fichier_Comp:in string) is
begin
	Put("Debut de la compression du fichier "&Nom_Fichier);
	New_Line;
	Tab_prio(T_Ascii,Nom_fichier);		-- on construit le tableau d'analyse fréquentiel
	File_Prio(F_Prio,T_ascii);			-- on fait la file de priorité
	--afficher(F_prio); 				-- on regarde la file de priorité
	Ecrire_File(F_Prio,Nom_Fichier_comp);	-- on stocke la file dans l'entête du fichier

	-- file bien stocké dans l'entête avec 0 en caractère d'arrêt.

	creation_huffmann(F_Prio,Huffmann);		-- création de l'arbre
	--afficher(huffmann);			-- on regarde l'arbre
	const_dico(huffmann,T_Trad,code);		-- le dictionnaire permet de gagner du temps
	--afficher(T_Trad(101));			-- par exemple on regarde le code de 'e', on voit qu'on gagne de l'espace sur e
	Text_Bin(T_Trad,Nom_fichier,Nom_Fichier_comp);-- on code...
	-- on a bien vérifié que les premiers codes en hexa : 93 ef correspondent au code du dico de 'L' et 'e' :
	-- 93 ef en binaire : 1001 0011 1110 1111 et avec afficher(T_trad(76)) et afficher(t_trad(101)) respectivement 
	-- les codes ascii en décimal de 'L' et 'e' on peut observer : L : 1001001111 et e : 101, une bonne traduction donc!
	-- on vérifie cela avec la commande od, le code du txt étant après l'integer 00 00 00 00 du au recopiage de l'arbre
	Put("Compression terminée! "&Nom_Fichier_Comp&" crée!");

	--libération
	Libere_arbre(huffmann);
	vide(F_prio);
	vide_dico(t_trad);


end Compresser;
end compresseur;

