*********************************************************************************************
***pulls up a previous order to edit it
****************************************************************************************************
    
    SUBROUTINE DISPLAYEDITPREVIOUSORDER
    
    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    
    AdjustTitle = 23          ;*positions title in section header
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " EDIT PREVIOUS ORDER "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to Main Menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "ID. Search for order by ID#."
    CRT@(MAINCOL,MAINSTARTLINE+4): "EX. Exit Program."

    RETURN
