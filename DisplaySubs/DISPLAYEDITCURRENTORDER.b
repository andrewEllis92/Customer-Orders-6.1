********************************************************************************************
***displays edit current order page
*************************************************************************************************
    
    SUBROUTINE DISPLAYEDITCURRENTORDER
    
    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    
    AdjustTitle = 23          ;*positions title in section header line
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " EDIT CURRENT ORDER "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to Main Menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "SA. Change Shipping Address."
    CRT@(MAINCOL,MAINSTARTLINE+4): "EP. Edit Products and Quantites on the Order."
    CRT@(MAINCOL,MAINSTARTLINE+5): "EX. Exit Program."

    RETURN
