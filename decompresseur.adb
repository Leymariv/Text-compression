with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with abr; use abr;
with File_Chainee; use File_Chainee;
with tableaux; use tableaux;
with Code;use Code;
with Unchecked_Deallocation ;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with compresseur; use compresseur;
with decompresseur; use decompresseur;

--   $ od -t x1 exemple_io.txt


package body decompresseur is

	-------------DECLARATION DE NOS VARIABLES--------------------------------------------------------------------


	Huffmann_bin: arbre;
	F_bin:File:=Nouvelle_file;

	Fichier : Ada.Streams.Stream_IO.File_Type;
	Fichier2 : Ada.Streams.Stream_IO.File_Type;
	Flux : Ada.Streams.Stream_IO.Stream_Access;
	Flux2 : Ada.Streams.Stream_IO.Stream_Access;


	--------------NOS PROCEDURES SECONDAIRES--------------------------------------------------------------------

	-- File de l'arbre en binaire------------------------------------------------------------------------------
	-- ca lire l'arbre stocké en entete de fichier
	procedure File_Binaire(F:in out File ; Nom_Fichier:in String) is
		Lit_Ascii:Integer:=255;
		Lit_Prio:Integer:=0;
		A:Arbre:=null;
	begin
		Open(Fichier, In_File, Nom_Fichier);
		Flux := Stream(Fichier);

		-- boucle infini avec condition d'arret plus loin
		while true loop
			Lit_ascii := integer'Input(Flux);
			-- si c'est 0, on s'arrête :
			if Lit_Ascii = 0 then 
				Close(Fichier);
				return;
			end if;
			-- sinon on prend le suivant qui est une prio :
			Lit_Prio:=Integer'Input(Flux);
			A:=new Noeud'(Lit_Prio,null,null,Lit_Ascii);
			Enfiler(F,A);
		end loop;

	end File_Binaire;
	-----------------------------------------------------------------------------------------------------------
	-- creation de l'arbre de huffman

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

	--------------------------------------------------------------------------------------------------------------
	function pow(nombre: in octet; puissance: in octet) return octet is
		result:octet := 1;
		n:octet := puissance;
	begin
		while n /= 0 loop
			result := result*nombre;
			n := n-1;
		end loop;
		return result;
	end pow;

	----------------------------------------------------------------------------------

	Procedure decodage_Bin(huffmann: in arbre; fichierAdecompresser: in string; fichierAecrire: in string) is
	temp:arbre := huffmann;
	octet_a_lire:Octet := 0;
	code:octet := 0;
	cour:integer := 1; 	
	I:octet;
	begin

	Open(Fichier, in_File, fichierAdecompresser);
	Flux := Stream(Fichier);
	Open(Fichier2, append_File, fichierAecrire);
	Flux2 := Stream(Fichier2);

	-- placement au bon endroit :
	while cour /= 0 loop
		cour := integer'input(Flux);
	end loop;

	-- lecture tant qu'il reste des octet on incrémente la case qui leur correspond
	while not End_Of_File(Fichier) loop
		octet_a_lire := Octet'Input(Flux);
		I := 8;
		while I /= 0 loop
			-- décalage pour lire le bit qui nous intéresse (le Ième):
			code := octet_a_lire/(pow(2,I-1));
			-- pour ne pas prendre en compte les bit devant celui intéressant:
			code := code mod 2;
			I := I-1;
			if code = 1 then
				temp := temp.fd;
			else
				temp := temp.fg;
			end if;
			if temp.ascii /= 266 then
				character'output(Flux2,character'val(temp.ascii));
				temp := huffmann;
			end if;
		end loop;
	end loop;
	Close(Fichier);
	Close(Fichier2);
end decodage_bin;


-------------------------------------------------------------
-------------------------------NOTRE PROCEDURE PRINCIPALE-----------------------------------------------

procedure decompresser(Nom_fichier_in: in string; Nom_fichier_out: in string) is
begin

	put("debut de la decompression");
	file_binaire(F_bin,Nom_Fichier_in);		-- on lit la file en entête
	--afficher(F_bin);				-- on regarde la file
	creation_huffmann(F_bin,huffmann_bin);		-- on récrée le même arbre H avec la meme fonction
	--afficher(huffmann_bin);			-- on regarde l'arbre

	create(Fichier, Out_File,Nom_fichier_out);
	Close(Fichier);
	decodage_bin(huffmann_bin,nom_fichier_in,nom_fichier_out);

	New_line;
	put("decompression terminé ! enjoy");
	--libération
	libere_arbre(huffmann_bin);
	vide(F_bin);

end decompresser;
end decompresseur;

