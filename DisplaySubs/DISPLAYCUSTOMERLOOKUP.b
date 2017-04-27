**************************************************************************************
***displays customer look up page
*******************************************************************************************

    SUBROUTINE DISPLAYCUSTOMERLOOKUP

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

    AdjustTitle = 20          ;*positions title in section header
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " LOOKUP CUSTOMER/NEW ORDER "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to Main Menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "CN. Search Customer by Company Name."
    CRT@(MAINCOL,MAINSTARTLINE+4): "CI. Search Customer by Company ID#."
    CRT@(MAINCOL,MAINSTARTLINE+5): "EX. Exit Program."

    PRINT@(MAINCOL,MAINSTARTLINE+9):   "       Company Name:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+10):  " Contact First Name:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+11):  " Contact Last  Name:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+12):  "      Contact Phone:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+13):  "    Billing Address:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+14):  "             Line 2:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+15):  "               City:                             State:           "
    PRINT@(MAINCOL,MAINSTARTLINE+16):  "                Zip:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+18):  "   Shipping Address:                                              "
    PRINT@(MAINCOL,MAINSTARTLINE+19):  "             Line 2:                                              " 
    PRINT@(MAINCOL,MAINSTARTLINE+20):  "               City:                             State:           "
    PRINT@(MAINCOL,MAINSTARTLINE+21):  "                Zip:                                              "
    RETURN
