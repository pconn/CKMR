AD BEGIN
  WORKING DIRECTORY: "./work/";

  // For bounds-checking, change the next line into SWITCHES: "rebuild", "BoundsCheck"
  SWITCHES: "rebuild"; //"BoundsCheck"; 
  CPP OPTIONS FILE: cpp_macros.txt;
  FORTRAN INCLUDE FILES: stdlib.f;

  CLASS DBearded2(Bearded2) SOURCE FILE: Bearded2.cpp OUTPUT FILES: DBearded2.cpp DBearded2.hpp
  BEGIN
    // To turn on AD, add lines like the following

    // For fitting:
    FUNCTION=lglk OUTVAR=lglk VAR=pars MODE=r; // USER='-ext C:/Progra~1/ADT/bin/adt-include/my_adlib.txt';
    
    // For design:
     FUNCTION=sqrt_probs OUTVAR=sqrt_Pr_PO_ytbs,sqrt_Pr_HS_bbs VAR=pars MODE=f;
  END

  CLASS RIBearded2(RBearded2) SOURCE FILE: RBearded2.cpp OUTPUT FILES: RIBearded2.cpp RIBearded2.hpp
  BEGIN

  END
END
