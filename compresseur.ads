with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with abr; use abr;
with File_Chainee; use File_Chainee;
with tableaux; use tableaux;
with Code;use Code;
with Unchecked_Deallocation ;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package compresseur is

type Octet is private;

	procedure Tab_prio(T:in out Tab;Nom_Fichier : in String);
	procedure File_Prio (F :in out File; T:in out tab);
	procedure creation_huffmann(F : in out File ; A:in out Arbre);
	procedure Const_dico(A:in out Arbre;T:in out dico; F: in out code_binaire);
	procedure Ecrire_File(F:in File;Nom_Fichier:in string);
	Procedure Text_Bin(dictionnaire: in out dico; fichierAcompresser: in string; fichierAecrire: in string);
	procedure Compresser(Nom_Fichier:In String;Nom_Fichier_Comp:in string);
	procedure vide_dico(D: in out dico);


	private 
	type Octet is new Integer range 0 .. 255;
	for Octet'Size use 8;

end compresseur;
