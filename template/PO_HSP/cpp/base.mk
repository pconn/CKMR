AD BEGIN
  WORKING DIRECTORY: "./work/";

  // For bounds-checking, change the next line into SWITCHES: "rebuild", "BoundsCheck"
  SWITCHES: "rebuild"; //,"BoundsCheck"; 
  CPP OPTIONS FILE: cpp_macros.txt;
  FORTRAN INCLUDE FILES: stdlib.f;

  CLASS D$(classname)($(classname)) SOURCE FILE: $(filename).cpp OUTPUT FILES: D$(filename).cpp D$(filename).hpp  
  BEGIN
    // To turn on AD, add lines like the following

    // For fitting:
    FUNCTION=lglk OUTVAR=lglk VAR=pars MODE=r; // USER='-ext C:/Progra~1/ADT/bin/adt-include/my_adlib.txt';
    
    // For design:
    // FUNCTION=sqrt_Pr_stuff OUTVAR=sqrt_Pr_PO_ybt,sqrt_Pr_MHS_byaya VAR=pars MODE=f;
  END

  CLASS RI$(classname)(R$(classname)) SOURCE FILE: R$(filename).cpp OUTPUT FILES: RI$(filename).cpp RI$(filename).hpp
  BEGIN

  END
END
