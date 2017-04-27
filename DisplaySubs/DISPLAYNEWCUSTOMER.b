*************************************************************************************
***Displays new customer page
****************************************************************************************

SUBROUTINE DISPLAYNEWCUSTOMER

COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

AdjustTitle = 19:         ;*positins title in section header line.

***Displays screen and menu items, leaving 4 lines for menu prompt inbetween
CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " ADD NEW CUSTOMER/NEW ORDER "
CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to main menu."
CRT@(MAINCOL,MAINSTARTLINE+3): "NC. Add new customer information to order form"
CRT@(MAINCOL,MAINSTARTLINE+4): "EX. Exit Program"
PRINT@(MAINCOL,MAINSTARTLINE+8):   "       Company Name: "
PRINT@(MAINCOL,MAINSTARTLINE+9):   " Contact First Name: "
PRINT@(MAINCOL,MAINSTARTLINE+10):  " Contact Last  Name: "
PRINT@(MAINCOL,MAINSTARTLINE+11):  "      Contact Phone: "
PRINT@(MAINCOL,MAINSTARTLINE+13):  "    Billing Address: "
PRINT@(MAINCOL,MAINSTARTLINE+14):  "             Line 2: "
PRINT@(MAINCOL,MAINSTARTLINE+15):  "               City:                             State: "
PRINT@(MAINCOL,MAINSTARTLINE+16):  "                Zip: "
PRINT@(MAINCOL,MAINSTARTLINE+18):  "   Shipping Address: "
PRINT@(MAINCOL,MAINSTARTLINE+19):  "             Line 2: "
PRINT@(MAINCOL,MAINSTARTLINE+20):  "               City:                             State: "
PRINT@(MAINCOL,MAINSTARTLINE+21):  "                Zip: "
RETURN
