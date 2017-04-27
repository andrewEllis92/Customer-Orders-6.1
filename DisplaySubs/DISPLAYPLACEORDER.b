*************************************************************************************
***Displaysplace order page
****************************************************************************************

    SUBROUTINE DISPLAYPLACEORDER

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

    AdjustTitle = 19:         ;*positins title in section header line

***Displays screen and menu items, leaving 4 lines for menu prompt inbetween
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " Place Order "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to main menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "PO. Place Order"
    CRT@(MAINCOL,MAINSTARTLINE+4): "EX. Exit Program"
    PRINT@(MAINCOL,MAINSTARTLINE+9):   "             Order Total: "
    PRINT@(MAINCOL,MAINSTARTLINE+10):   "Open Order Delivery Date: "
    PRINT@(MAINCOL,MAINSTARTLINE+11):  "Back Order Delivery Date: "

    RETURN
