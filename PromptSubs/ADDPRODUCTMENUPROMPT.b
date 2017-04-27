*********************************************************
***Prompts ADDPRODUCT menu
*********************************************************

    SUBROUTINE ADDPRODUCTMENUPROMPT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

***
*Control Variables. DO NOT TOUCH!!!
***
    OrderListArray = ''       ;*Initializes the orderlist to be blank
    BackOrderListArray = ''
    R.ORDERS = ''
    i=1   ;* This is a tracking integer (OrderListArray organization)
    k=1   ;* This is a tracking integer (BackOrderListArray organization)
    Default=1       ;*Used to force a "true" for operational functions
    ClearError = STR(" ",MAINSECTIONWIDTH)        ;*Variable for wiping a section clean

*************Operates the main menu
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+7):  "Choose an action: "
        INPUT MenuChoice,2
        MenuChoice = UPCASE(MenuChoice)
        BEGIN CASE
        CASE MenuChoice = "RM"          ;*Returns to previous menu
            RETURN
        CASE MenuChoice = "ID"          ;*Search items by Part# ID
            CRT@(MAINCOL,MAINSTARTLINE+8): ClearError
            GOSUB SUBMENU
        CASE MenuChoice = "PO"          ;*Places the order
            GOSUB PLACEORDER
        CASE MenuChoice = "EX"          ;*Exits the program
            CRT@(-1)
            STOP
        CASE Default=1
            GOSUB THROWERROR
        END CASE
    UNTIL MenuChoice = "RM" DO
    REPEAT
    RETURN
*************

***
*GENERAL SUBROUTINES
***


SUBMENU:  *Options for adding parts to the order
    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+8):  "Add a part?(Y/N): "
        PROMPT@(MAINCOL+18,MAINSTARTLINE+8) ""
        INPUT SubMenuChoice,1
        SubMenuChoice = UPCASE(SubMenuChoice)
        BEGIN CASE
        CASE SubMenuChoice = "Y"
            CRT@(MAINCOL,MAINSTARTLINE+9): ClearError
            GOSUB GETPARTINFO
            GOSUB ADDPART
        CASE SubMenuChoice = "N"
            RETURN
        CASE Default=1
            GOSUB THROWERROR
        END CASE
    UNTIL SubMenuChoice = "N" DO
    REPEAT
    RETURN

GETPARTINFO:        *Retreives data about from parts file base on partno
    GOSUB CLEARSCREEN
    INPUT@(MAINCOL+21,MAINSTARTLINE+11) PartNo,7
    PartNo=PartNo'R%7'
    GOSUB FILEPARTS
    GOSUB FILEPRICES
    PRINT@(MAINCOL+21,MAINSTARTLINE+11): PartNo
    PRINT@(MAINCOL+21,MAINSTARTLINE+12): PartDesc
    PRINT@(MAINCOL+21,MAINSTARTLINE+13): PartOnHand
    PRINT@(MAINCOL+21,MAINSTARTLINE+14): PartOnOrder
    PRINT@(MAINCOL+21,MAINSTARTLINE+15): Latex
    PRINT@(MAINCOL+21,MAINSTARTLINE+16): Price
    RETURN


ADDPART:  *Builds single element of orderlist array w/ PartNo, PartDesc, Quantity, Price
    i = DCOUNT(OrderListArray, CHAR(253)) + 1
    k = DCOUNT(BackOrderListArray, CHAR(253)) + 1
    Quantity = ''
    PRINT@(MAINCOL+10,MAINSTARTLINE+18): "How many?: "
    PROMPT@(MAINCOL+21,MAINSTARTLINE+18): ""
    INPUT Quantity
    GOSUB LATEXWARNING
***MENU***
    LOOP  ;*Confirm that addition of part to order list
        PRINT@(MAINCOL+6,MAINSTARTLINE+19): "Confirm?(Y/N): "
        PROMPT@(MAINCOL+21,MAINSTARTLINE+19): ""
        INPUT ConfirmChoice,1
        ConfirmChoice = UPCASE(ConfirmChoice)
        BEGIN CASE
        CASE ConfirmChoice = "Y"
            CRT@(MAINCOL,MAINSTARTLINE+9): ClearError
            GOSUB DEFINEELEMENT
            GOSUB PAINTSCREEN
        CASE ConfirmChoice = "N"
            RETURN
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL ConfirmChoice = "Y" DO
    REPEAT
    RETURN

DEFINEELEMENT:      *Checks inventory and creates back-orders as needed
    PartAvailable = PartOnHand - PartOnOrder
    PartOnBackOrder = Quantity - PartAvailable
    IF Quantity <= PartAvailable THEN
        OrderListArray = INSERT(OrderListArray, 1, i, 1, PartNo)
        OrderListArray = INSERT(OrderListArray, 1, i, 2, PartDesc)
        OrderListArray = INSERT(OrderListArray, 1, i, 3, Quantity)
        OrderListArray = INSERT(OrderListArray, 1, i, 4, Price)
    END ELSE
        IF PartOnOrder >= PartOnHand THEN
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 1, PartNo)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 2, PartDesc)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 3, PartOnBackOrder)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 4, Price)
        END ELSE
            OrderListArray = INSERT(OrderListArray, 1, i, 1, PartNo)
            OrderListArray = INSERT(OrderListArray, 1, i, 2, PartDesc)
            OrderListArray = INSERT(OrderListArray, 1, i, 3, PartAvailable)
            OrderListArray = INSERT(OrderListArray, 1, i, 4, Price)

            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 1, PartNo)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 2, PartDesc)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 3, PartOnBackOrder)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 4, Price)
        END
    END
    RETURN

PAINTSCREEN:        *Displays data in the "order list" section
    GOSUB CLEARSCREENALT
    j=1
    DisplayCap = 1
    DisplayCap = DCOUNT(OrderListArray, CHAR(253))
    LOOP
        PRINT@(MAINCOL+70,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,1>,"R")
        PRINT@(MAINCOL+85,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,2>,"L")
        PRINT@(MAINCOL+113,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,3>,"R,& #6")
        PRINT@(MAINCOL+123,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,4>,"R2,& $#6")
    UNTIL j > DisplayCap DO
        j=j+1
    REPEAT

    j = 1
    DisplayCap2 = DCOUNT(BackOrderListArray, CHAR(253))
    LOOP
        PRINT@(MAINCOL+70,MAINSTARTLINE+19+j+DisplayCap): FMT(BackOrderListArray<1,j,1>,"R")
        PRINT@(MAINCOL+85,MAINSTARTLINE+19+j+DisplayCap): FMT(BackOrderListArray<1,j,2>,"L")
        PRINT@(MAINCOL+113,MAINSTARTLINE+19+j+DisplayCap): FMT(BackOrderListArray<1,j,3>,"R,& #6")
        PRINT@(MAINCOL+123,MAINSTARTLINE+19+j+DisplayCap): FMT(BackOrderListArray<1,j,4>,"R2,& $#6")
    UNTIL j > DisplayCap2 DO
        PRINT@(MAINCOL+140,MAINSTARTLINE+19+j+DisplayCap): FMT("BO","R")
        j=j+1
    REPEAT

    PartNo = ""
    RETURN

LATEXWARNING:       *Confirmation that product has latex
    CRT@(MAINCOL+6,MAINSTARTLINE+25): SPACE(30)
    IF Latex = "Y" THEN
        CRT@(MAINCOL+6,MAINSTARTLINE+25): "Product contains Latex"
        MSLEEP(1500)
        CRT@(MAINCOL+6,MAINSTARTLINE+25): SPACE(30)
    END
    RETURN

***
*FILE SUBROUTINES - Extract these to modular subroutines eventually
***


FILEPARTS:*Opens, reads, and closes the "PARTS" file. Captures relevant data
    OPEN 'PARTS' TO F.PARTS ELSE
        ABORT 201, 'PARTS'
    END
    READ R.PARTS FROM F.PARTS,PartNo ELSE
        R.PARTS = ''
    END
    PartDesc = R.PARTS<1>
    PartOnHand = R.PARTS<2>
    PartOnOrder = R.PARTS<3>
    Latex = R.PARTS<5>
    CLOSE F.PARTS
    RETURN


FILEPRICES:         *Opens, reads, and closes the "PRICES" file. Captures relevant data
    OPEN 'PRICES' TO F.PRICES ELSE
        ABORT 201, 'PRICES'
    END
    READ R.PRICES FROM F.PRICES,PartNo ELSE
        R.PRICES = ''
    END
    Price = R.PRICES<1>
    CLOSE F.PRICES
    RETURN


FILEORDERS:         *Finalizes the array and writes it to the "ORDERS" file.
    OPEN 'ORDERS' TO F.ORDERS ELSE
        ABORT 201, 'ORDERS'
    END
    R.ORDERS = ''
    EXECUTE "COUNT ORDERS" CAPTURING TotalRecords
    TotalRecords = OCONV(TotalRecords, "MCN")
    NewRecord = TotalRecords + 1
    NewRecord = NewRecord'R%7'
    R.ORDERS<1> = OrderListArray
    WRITE R.ORDERS ON F.ORDERS,NewRecord
    CLOSE F.ORDERS
    RETURN

***
*MISC. SUBROUTINES
***

THROWERROR:         *Garbage in, garbage out
    CRT@(MAINCOL,MAINSTARTLINE+9): "Please Enter a valid menu choice."
    RETURN

CLEARSCREEN:        *Wipes old data from data entry area
    CRT@(MAINCOL+21,MAINSTARTLINE+11): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+12): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+13): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+14): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+15): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+16): SPACE(25)
    CRT@(MAINCOL+21,MAINSTARTLINE+18): SPACE(25)
    RETURN

CLEARSCREENALT:     *Clears the order list section
    CRT@(MAINCOL+70,MAINSTARTLINE+20): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+21): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+22): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+23): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+24): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+25): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+26): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+27): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+28): SPACE(80)
    CRT@(MAINCOL+70,MAINSTARTLINE+29): SPACE(80)
    RETURN

SEEVAR:   *displays variables near bottom of screen: for debugging only
    PRINT@(MAINCOL,MAINSTARTLINE+100):R.PARTS<1>:" ":R.PARTS<2>:" ":R.PARTS<3>:" ":R.PARTS<4>:" ":R.PARTS<5>
    RETURN


*******************************************************************************************
*** NOTES: this will update the database and possibly print a reciept
**********************************************************************************************
PLACEORDER:

    CALL CLEARMENUSCREEN
    CALL DISPLAYPLACEORDER
    CALL PLACEORDERMENUPROMPT

    RETURN


