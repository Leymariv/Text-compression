with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with abr; use abr;
with File_Chainee; use File_Chainee;
with tableaux; use tableaux;
with Code;use Code;
with Unchecked_Deallocation ;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package decompresseur is

	type Octet is private;

	procedure File_Binaire(F:in out File ; Nom_Fichier:in String);
	procedure creation_huffmann(F : in out File ; A:in out Arbre);
	function pow(nombre: in octet; puissance: in octet) return octet;
	Procedure decodage_Bin(huffmann: in arbre; fichierAdecompresser: in string; fichierAecrire: in string);
	procedure decompresser(Nom_fichier_in: in string; Nom_fichier_out: in string);


	private 
	type Octet is new Integer range 0 .. 255;
	for Octet'Size use 8;

end decompresseur;



