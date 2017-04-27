*****************************************************************************************
***displays add product page
*************************************************************************************************

    SUBROUTINE DISPLAYADDPRODUCT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

    AdjustTitle = 22          ;*positions title in section header line
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " ADD PRODUCTS TO ORDER "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to Main Menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "ID. Look Up by ID#."
    CRT@(MAINCOL,MAINSTARTLINE+4): "PO. Place Order."
    CRT@(MAINCOL,MAINSTARTLINE+5): "EX. Exit Program."
    PRINT@(MAINCOL,MAINSTARTLINE+11):  "       Enter an ID#: "
    PRINT@(MAINCOL,MAINSTARTLINE+12):  "          Part Name: "
    PRINT@(MAINCOL,MAINSTARTLINE+13):  "   Quantity on Hand: "
    PRINT@(MAINCOL,MAINSTARTLINE+14):  "  Quantity on Order: "
    PRINT@(MAINCOL,MAINSTARTLINE+15):  "              Latex: "
    PRINT@(MAINCOL,MAINSTARTLINE+16):  "              Price: "

    RETURN
