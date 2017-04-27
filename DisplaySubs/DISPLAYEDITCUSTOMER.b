********************************************************************************************
***this displays screen for edit current customer information on the order
**************************************************************************************************

    SUBROUTINE DISPLAYEDITCUSTOMER

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

    AdjustTitle = 20          ;*positions title in section header
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " EDIT CUSTOMER INFORMATION "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to Main Menu."
    CRT@(MAINCOL,MAINSTARTLINE+3): "EN. Edit Company Name."
    CRT@(MAINCOL,MAINSTARTLINE+4): "EF. Edit First Name."
    CRT@(MAINCOL,MAINSTARTLINE+5): "EL. Edit Last Name."
    CRT@(MAINCOL,MAINSTARTLINE+6): "EH. Edit Contact Number."
    CRT@(MAINCOL,MAINSTARTLINE+7): "B1. Edit Billing Line 1."
    CRT@(MAINCOL,MAINSTARTLINE+8): "B2. Edit Billing Line 2."
    CRT@(MAINCOL,MAINSTARTLINE+9): "EY. Edit Billing City."
    CRT@(MAINCOL,MAINSTARTLINE+10): "ES. Edit Billing State."
    CRT@(MAINCOL,MAINSTARTLINE+11): "EZ. Edit Billing Zip."
    CRT@(MAINCOL,MAINSTARTLINE+12): "S1. Edit Shipping Line 1."
    CRT@(MAINCOL,MAINSTARTLINE+13): "S2. Edit Shipping Line 2."
    CRT@(MAINCOL,MAINSTARTLINE+14): "ED. Edit Shipping City."
    CRT@(MAINCOL,MAINSTARTLINE+15): "EK. Edit Shipping State."
    CRT@(MAINCOL,MAINSTARTLINE+16): "ET. Edit Shipping Zip."
    CRT@(MAINCOL,MAINSTARTLINE+17): "EX. Exit Program."

    RETURN




