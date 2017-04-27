***Group: Order of Orders
***Created: March 20, 2017
***Modified March 20, 2017 by Andrea Chesak
***Program to take and modify orders

*************************************GLOBAL VARIABLES
    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

    MAINSECTIONWIDTH = 67     ;*controls width of main menu section
    DISPLAYSECTIONWIDTH = 80  ;*controls width of customer info and order sections
    MAINSTARTLINE = 1         ;* controls start line of main menu and submenu option display
    MAINHEADER = STR('~',MAINSECTIONWIDTH)        ;* creates main section header line
    MAINCOL = 2     ;*postions page display starting column


**************************************(MAIN)**************************


    CRT@(-1)
***subroutines to display screen sections
    GOSUB DISPLAYCUSTOMERINFO
    GOSUB DISPLAYORDERINFO
    LOOP
        GOSUB MAINMENU
    REPEAT


**************************************(END OF MAIN)***********************


**************************************(START OF MAIN DISPLAY SUBROUTINES and Menus for each option)*******************************


*******************************************************************
***sets up main menu, prompts user input
***********************************************************************

MAINMENU:

    CALL CLEARMENUSCREEN      ;*clears menu screen when returning from menu options

****************variables to control section position and layouts.
    AdjustTitle = 25          ;* positions title in section header line

***Labels, beggining and end of section lines.
    CRT@(MAINCOL,MAINSTARTLINE): MAINHEADER
    CRT@(MAINCOL+AdjustTitle,MAINSTARTLINE): " ***MAIN MENU*** "
    CRT@(MAINCOL,MAINSTARTLINE+2): "NC. New Customer"
    CRT@(MAINCOL,MAINSTARTLINE+3): "LC. Lookup Customer"
    CRT@(MAINCOL,MAINSTARTLINE+4): "EP. Edit a Previous Order"
    CRT@(MAINCOL,MAINSTARTLINE+5): "CP. Print Confirmation Page"
    CRT@(MAINCOL,MAINSTARTLINE+6): "EX. Exit"
	CRT@(MAINCOL,MAINSTARTLINE+9): "Lookup a customer or enter a new customer to begin placing an order."

*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+11):  "Choose an action: "
        INPUT MenuChoice, 2
        ClearError = STR(" ",MAINSECTIONWIDTH):   ;*clears error message
        CRT@(MAINCOL,MAINSTARTLINE+13): ClearError
        MenuChoice = UPCASE(MenuChoice)
    UNTIL MenuChoice = "NC" OR MenuChoice = "LC" OR MenuChoice = "EP" OR MenuChoice = "CP" OR MenuChoice = "EX" DO
        CRT@(MAINCOL,MAINSTARTLINE+13): "Please Enter a valid menu choice."
    REPEAT

*************Takes user to menu choice.
    BEGIN CASE
    CASE MenuChoice = "NC"
        GOSUB NEWCUSTOMER
    CASE MenuChoice = "LC"
        GOSUB CUSTOMERLOOKUP
    CASE MenuChoice = "EP"
        GOSUB EDITCURRENTORDER
    CASE MenuChoice = "CP"
        GOSUB CONFIRMATION
    CASE MenuChoice = "EX"
        CRT@(-1)
        STOP
    END CASE
    RETURN

*********************************************************************
***displays customer information
*************************************************************************

DISPLAYCUSTOMERINFO:

****************variables to control section position and layouts.
    NumLines = 11:  ;*number of lines in section
    StartLine = 1:  ;*line section begins on
    Col = 70:       ;*column section begins on
    ColLabel = Col + 1:       ;*where the labels start so they don't print over visual side section lines
    AdjustTitle = 30:         ;*positions title in section header line

**************for loop creates side section lines.
    FOR I = StartLine+1 TO NumLines-1
        CRT@(Col, I): "|"
    NEXT I

**************Labels, beggining and end of section lines.
    Line = STR("=",DISPLAYSECTIONWIDTH)
    CRT@(Col,StartLine): Line
    CRT@(Col+AdjustTitle,StartLine):" CUSTOMER INFORMATION "
    PRINT@(ColLabel,StartLine+2):"              ID#: "
    PRINT@(ColLabel,StartLine+3):"     Company Name: "
    PRINT@(ColLabel,StartLine+4):"  Billing Address: "
    PRINT@(ColLabel,StartLine+5):"           Line 1: "
    PRINT@(ColLabel,StartLine+6):"           Line 2: "
    PRINT@(ColLabel,StartLine+7):"             City:                             State: "
    PRINT@(ColLabel,StartLine+8):"              Zip: "
    CRT@(Col,NumLines): Line
    RETURN


*****************************************************************************
***displays shipping address and items added to order
*********************************************************************************

DISPLAYORDERINFO:

****************variables to control section position and layouts.
    NumLines = 42:  ;*number of lines in section
    StartLine = 12: ;*line the section begins on
    Col = 70:       ;*column the section begins on
    ColLabel = Col + 1:       ;*where the labels start so they don't print over visual side section lines
    AdjustTitle = 34:         ;*positions title in section header line

**************for loop creates side section lines
    FOR I = StartLine + 1 TO NumLines - 1
        CRT@(Col, I): "|"
    NEXT I

**************Labels, beggining and end of section lines
    Line = STR("=",DISPLAYSECTIONWIDTH)
    CRT@(Col,StartLine): Line
    CRT@(Col+AdjustTitle,StartLine): " CURRENT ORDER "
    PRINT@(ColLabel,StartLine+2):"   Shipping Address: "
    PRINT@(ColLabel,StartLine+3):"             Line 1: "
    PRINT@(ColLabel,StartLine+4):"             Line 2: "
    PRINT@(ColLabel,StartLine+5):"               City:                             State: "
    PRINT@(ColLabel,StartLine+6):"                Zip: "
    PRINT@(ColLabel,StartLine+8):" |Item ID#|    |Description|          |Quantity|  |Price|      |Back Order Status|"
    CRT@(Col,NumLines): Line
    RETURN


****************************************(END OF MAIN DISPLAY SUBROUTINES)****************************


****************************************(START OF MENU OPTION SUBROUTINES)***************************


**************************************************************************
***NOTES: this should allow us to enter new customer information and enter a shipping address for the order
**********************************************************************************

NEWCUSTOMER:
    CALL CLEARMENUSCREEN
    CALL DISPLAYNEWCUSTOMER   ;*In Display Subs
    CALL NEWCUSTOMERMENUPROMPT          ;*In Prompt Subs
	
    RETURN


***************************************************************************
***NOTES: this should pull up customers in the database by a search and populate the customer information section
***we may want to be able to choose the shipping address on this page and have it populated in the current order section
**********************************************************************************************

CUSTOMERLOOKUP:
    CALL CLEARMENUSCREEN
    CALL DISPLAYCUSTOMERLOOKUP          ;*In Display Subs
    CALL CUSTOMERLOOKUPMENUPROMPT       ;*In Prompt Subs

    RETURN


*************************************************************************
***NOTES: This should add a product to the current order section
*******************************************************************************
ADDPRODUCT:

    CALL CLEARMENUSCREEN
    CALL DISPLAYADDPRODUCT    ;*In Display Subs
    CALL ADDPRODUCTMENUPROMPT ;*In Prompt Subs

    RETURN


************************************************************************************
*** NOTES: this should edit the current order section by changing quantites of a product or deleting.
*******************************************************************************************************

EDITCURRENTORDER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYEDITCURRENTORDER        ;*In Display Subs
    CALL EDITCURRENTORDERMENUPROMPT     ;*In Prompt Subs

    RETURN


********************************************************************************************
***NOTES: This should edit customer information that is populated already in the customer information section
************************************************************************************************************

EDITCUSTOMER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYEDITCUSTOMER  ;*In Display Subs
    CALL EDITCUSTOMERMENUPROMPT         ;*In Prompt Subs

    RETURN


***************************************************************************************************
***NOTES: This should pull up a previous order and populate the customer information section and the order section with shipping address and products
*********************************************************************************************************

EDITPREVIOUSORDER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYEDITPREVIOUSORDER       ;*In Display Subs
    CALL EDITPREVIOUSORDERMENUPROMPT    ;*In Prompt Subs

    RETURN


*******************************************************************************************
*** NOTES: this will update the database and possibly print a reciept
**********************************************************************************************
PLACEORDER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYPLACEORDER
    CALL PLACEORDERMENUPROMPT

    RETURN

***************************************************************************
***NOTES: this should print a confirmation page **********************************************************************************************

CONFIRMATION:
    CALL CLEARMENUSCREEN
    CALL CONFIRMPAGE

    RETURN

******************************************(END OF MENU SUBROUTINES)********************************



    STOP
















