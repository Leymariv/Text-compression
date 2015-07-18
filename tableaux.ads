with code;use code;

--Creer une file chaînée.

package tableaux is

   --creation du type tab

   type Tab is array (0..255) of integer;
  

   --fonctions caractéristiques des tab

  function est_vide(T:in tab) return boolean;
  function Indice_max(T:in Tab) return Integer;
  procedure Afficher(T:in Tab);
   --procedures caractéristiques des tableaux





end tableaux;




