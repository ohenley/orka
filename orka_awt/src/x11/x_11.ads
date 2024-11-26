package X_11 is
   pragma Preelaborate;

   type Display is null record;
   type Display_Ptr is access all Display;
end X_11;