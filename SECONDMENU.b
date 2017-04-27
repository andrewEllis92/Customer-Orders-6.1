*******************************************************************
***sets up secondary menu, prompts user input
***********************************************************************
    SUBROUTINE SECONDMENU

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

    CALL CLEARMENUSCREEN      ;*clears menu screen when returning from menu options.

****************variables to control section position and layouts.
    AdjustTitle = 25          ;* positions title in section header line

***Labels, beggining and end of section lines.
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " ***MAIN MENU*** "
    CRT@(MAINCOL,MAINSTARTLINE+2): "RM. Return to previous Menu"
    CRT@(MAINCOL,MAINSTARTLINE+3): "AP. Add Products to Order"
    CRT@(MAINCOL,MAINSTARTLINE+4): "EC. Edit Customer Information"
    CRT@(MAINCOL,MAINSTARTLINE+5): "EX. Exit"

*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+11):  "Choose an action: "
        INPUT MenuChoice, 2 
        ClearError = STR(" ",MAINSECTIONWIDTH):   ;*clears error message
        CRT@(MAINCOL,MAINSTARTLINE+13): ClearError
        MenuChoice = UPCASE(MenuChoice)
    UNTIL MenuChoice = "RM" OR MenuChoice = "AP" OR MenuChoice = "EC" OR MenuChoice = "EX" DO
        CRT@(MAINCOL,MAINSTARTLINE+13): "Please Enter a valid menu choice."
    REPEAT

*************Takes user to menu choice.
    BEGIN CASE
    CASE MenuChoice = "RM"
        RETURN
    CASE MenuChoice = "AP"
        GOSUB ADDPRODUCT
    CASE MenuChoice = "EC"
        GOSUB EDITCUSTOMER
    CASE MenuChoice = "EX"
        CRT@(-1)
        STOP
    END CASE
    RETURN


*************************************************************************
***NOTES: This should add a product to the current order section
*******************************************************************************
ADDPRODUCT:

    CALL CLEARMENUSCREEN
    CALL DISPLAYADDPRODUCT    ;*In Display Subs
    CALL ADDPRODUCTMENUPROMPT ;*In Prompt Subs
    RETURN

********************************************************************************************
***NOTES: This should edit customer information that is populated already in the customer information section
************************************************************************************************************

EDITCUSTOMER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYEDITCUSTOMER  ;*In Display Subs
    CALL EDITCUSTOMERMENUPROMPT         ;*In Prompt Subs

    RETURN




