*********************************************************
***Prompts EDITCURRENTORDER menu
*********************************************************
*   V1.1
*   Jacob Lee


    SUBROUTINE EDITCURRENTORDERMENUPROMPT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

***
*Control Variables DO NOT TOUCH!!!!
***

    i=1   ;*This is a tracking integer (OrderListArray)
    k=1   ;*This is a tracking integer (BackOrderListArray)
    Default = 1     ;*Used to for a "true" in operational functions
    ClearError = STR(" ",MAINSECTIONWIDTH)        ;*clears error message

    GOSUB CLEARCUSTOMERINFO
    GOSUB CLEARSCREENALT
    GOSUB OPENORDERS          ;*Temporary fix until this imports ORDERS from main program
    GOSUB UPDATEPARTSFILE1    ;*Resets inventory in the parts file so from the order until order is reconfirmed

*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+7):  "Choose an action: "
        INPUT MenuChoice, 2
        MenuChoice = UPCASE(MenuChoice)
        BEGIN CASE
        CASE MenuChoice = "RM"          ;*Returns to previous menu
            GOSUB WRITEORDERS
            GOSUB UPDATEPARTSFILE2
            RETURN
        CASE MenuChoice = "SA"          ;*Edit shipping address

***SOMEONE ELSE CAN DO IT***

            RETURN
        CASE MenuChoice = "EP"          ;*Edit the order list
            GOSUB SUBMENU
        CASE MenuChoice = "EX"
            GOSUB WRITEORDERS
            GOSUB UPDATEPARTSFILE2
            CRT@(-1)
            STOP
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL MenuChoice = "EX" DO
    REPEAT
    RETURN

***
*GENERAL SUBROUTINES
***

SUBMENU:
    GOSUB CLEARERROR
    PRINT@(MAINCOL,MAINSTARTLINE+10): "Select an action: "
    PRINT@(MAINCOL,MAINSTARTLINE+11): "AP: Add new part  "
    PRINT@(MAINCOL,MAINSTARTLINE+12): "EP: Edit part     "
    PRINT@(MAINCOL,MAINSTARTLINE+13): "RP: Remove part   "
    PRINT@(MAINCOL,MAINSTARTLINE+14): "RM: Return to menu"
    LOOP
        GOSUB PAINTSCREEN
        PROMPT@(MAINCOL+20,MAINSTARTLINE+10): ""
        INPUT SubMenuChoice,2
        SubMenuChoice = UPCASE(SubMenuChoice)
        BEGIN CASE
        CASE SubMenuChoice = "AP"       ;*Adds a part to the order list
            GOSUB ADDPART
        CASE SubMenuChoice = "EP"       ;*Edits an existing order's PartNo or Quantity
            GOSUB EDITPART
        CASE SubMenuChoice = "RP"       ;*Removes an item from the order list
            GOSUB REMOVEPART
        CASE SubMenuChoice = "RM"       ;*Returns to previous menu
            RETURN
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL SubMenuChoice = "RM" DO
    REPEAT
    RETURN

ADDPART:  *Add element to OrderListArray
    GOSUB CLEARSCREENSUB
    GOSUB GETPARTINFO
    i = DCOUNT(OrderListArray,CHAR(253)) + 1
    k = DCOUNT(BackOrderListArray,CHAR(253)) + 1
    PRINT@(MAINCOL,MAINSTARTLINE+26): "How many?: "
    PROMPT@(MAINCOL+30,MAINSTARTLINE+26): ""
    INPUT Quantity
    GOSUB LATEXWARNING
    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+28): "Add this item?(Y/N): "     ;*Confirm addition of item
        PROMPT@(MAINCOL+30,MAINSTARTLINE+28): ""
        INPUT AddConfirm,1
        AddConfirm = UPCASE(AddConfirm)
        BEGIN CASE
        CASE AddConfirm = "Y"
            GOSUB CLEARERROR
            GOSUB DEFINEELEMENT
        CASE AddConfirm = "N"
            GOSUB CLEARERROR
            RETURN
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL AddConfirm = "Y" OR AddConfirm = "N" DO
    REPEAT
    RETURN

GETPARTINFO:        *Fetches information based on the part#
    GOSUB DISPPARTDATA
    PROMPT@(MAINCOL+30,MAINSTARTLINE+20): ""
    INPUT PartNo,7
    PartNo = PartNo'R%7'
    GOSUB DISPPARTINFO
    RETURN

DISPPARTDATA:       *Generates a "form" for part info to display next to
    PRINT@(MAINCOL,MAINSTARTLINE+20): "Enter an part ID:   "
    PRINT@(MAINCOL,MAINSTARTLINE+21): "Part Description:   "
    PRINT@(MAINCOL,MAINSTARTLINE+22): "Parts on Hand:      "
    PRINT@(MAINCOL,MAINSTARTLINE+23): "Parts on Order:     "
    PRINT@(MAINCOL,MAINSTARTLINE+24): "Latex:              "
    PRINT@(MAINCOL,MAINSTARTLINE+25): "Price:              "
    RETURN

DISPPARTINFO:       *display part info fetched from PARTS and PRICES
    GOSUB FILEPARTS
    GOSUB FILEPRICES
    PRINT@(MAINCOL+30,MAINSTARTLINE+20): PartNo
    PRINT@(MAINCOL+30,MAINSTARTLINE+21): PartDesc
    PRINT@(MAINCOL+30,MAINSTARTLINE+22): PartOnHand
    PRINT@(MAINCOL+30,MAINSTARTLINE+23): PartOnOrder
    PRINT@(MAINCOL+30,MAINSTARTLINE+24): Latex
    PRINT@(MAINCOL+30,MAINSTARTLINE+25): Price
    RETURN

FINDORDERLISTID:    *Finds the Field ID of a particular string in OrderListArray
    FIND PartNo2 IN OrderListArray SETTING Ap,Vp THEN
        OrderListID = Vp
    END ELSE
        OrderListID = 0
    END
    RETURN

FINDBACKORDERLISTID:*Finds the Field ID of a particular string in BackOrderListArray
    FIND PartNo2 IN BackOrderListArray SETTING Ap,Vp THEN
        BackOrderListID = Vp
    END ELSE
        BackOrderListID = 0
    END
    RETURN

VALIDPARTNO:        *Checks PartNo2 is a valid ID in either OrderListArray OR BackOrderListArray
    IF OrderListID + BackOrderListID > 0 THEN
        Valid = 1
    END ELSE
        Valid = 0
    END
    RETURN

EDITPART: *Edits existing part's PartNo or Quantity
    GOSUB CLEARSCREENSUB
    LOOP
        CRT@(MAINCOL,MAINSTARTLINE+16):"Select a listed part# to edit: "        ;*Select a PartNo from OrderListArray to begin edit
        PROMPT@(MAINCOL+40,MAINSTARTLINE+16): ""
        INPUT PartNo2,7
        PartNo2 = PartNo2'R%7'
        CRT@(MAINCOL+40,MAINSTARTLINE+16): PartNo2
        GOSUB FINDORDERLISTID
        GOSUB FINDBACKORDERLISTID
        GOSUB VALIDPARTNO
    UNTIL Valid = 1 DO
    REPEAT
    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+17): "Edit (P)art Number or (Q)uantity?:   "         ;*Decision branch; change PartNo or Quantity
        PROMPT@(MAINCOL+40,MAINSTARTLINE+17): ""
        INPUT EditChoice,1
        EditChoice = UPCASE(EditChoice)
        BEGIN CASE
        CASE EditChoice = "P"
            GOSUB CLEARERROR
            GOSUB DISPPARTDATA
            PRINT@(MAINCOL,MAINSTARTLINE+18): "What is the new Part#?: "        ;*First branch, alter PartNo
            PROMPT@(MAINCOL+40,MAINSTARTLINE+18): ""
            INPUT PartNo,7
            PartNo = PartNo'R%7' 
            CRT@(MAINCOL+40,MAINSTARTLINE+18): PartNo
            IF OrderListID > 0 THEN
                Quantity = OrderListArray<1,OrderListID,3>
                IF BackOrderListID > 0 THEN
                    Quantity = Quantity + BackOrderListArray<1,BackOrderListID,3>
                END
            END ELSE          ;*!!!Exception in case of item being entirely on back-order!!!
                Quantity = BackOrderListArray<1,BackOrderListID,3>
            END

            GOSUB DISPPARTINFO
            GOSUB LATEXWARNING
        CASE EditChoice = "Q"
            GOSUB CLEARERROR
            GOSUB DISPPARTDATA
            PartNo = PartNo2  ;*Needed to fun the DISPPARTINFO subroutine properly
            GOSUB DISPPARTINFO
            PRINT@(MAINCOL,MAINSTARTLINE+18): "What is the new Quantity?: "     ;*Second branch, alter Quantity
            PROMPT@(MAINCOL+40,MAINSTARTLINE+18): ""
            INPUT Quantity
            IF OrderListID > 0 THEN
                PartNo = OrderListArray<1,OrderListID,1>
                PartDesc = OrderListArray<1,OrderListID,2>
                Price = OrderListArray<1,OrderListID,4>

            END ELSE          ;*!!!Exception in case of item being entirely on back-order!!!
                PartNo = BackOrderListArray<1,BackOrderListID,1>
                PartDesc = BackOrderListArray<1,BackOrderListID,2>
                Price = BackOrderListArray<1,BackOrderListID,4>
            END
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL EditChoice = "P" OR EditChoice = "Q" DO
    REPEAT
    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+27): "Confirm change?(Y/N):    " ;*Confirms alterations to OrderListArray
        PROMPT@(MAINCOL+30,MAINSTARTLINE+27): ""
        INPUT Confirm,1
        Confirm = UPCASE(Confirm)
        BEGIN CASE
        CASE Confirm = "Y"
            GOSUB CLEARERROR
            GOSUB REMOVEORDER ;*Removes former order element
            GOSUB REMOVEBACKORDER       ;*Removes former back-order element
            GOSUB DEFINEELEMENT         ;*Creates new order element w/ back-order element as needed
        CASE Confirm = "N"
            GOSUB CLEARERROR
            RETURN
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL Confirm = "Y" OR Confirm = "N" DO
    REPEAT
    RETURN

REMOVEORDER:        *Wipes away a specific order
    IF OrderListID > 0 THEN
        DEL OrderListArray<1,OrderListID>
    END
    RETURN

REMOVEBACKORDER:    *Wipes away a specified back-order
    IF BackOrderListID > 0 THEN
        DEL BackOrderListArray<1,BackOrderListID>
    END
    RETURN

DEFINEELEMENT:      *Checks inventory, creates order, and creates back-orders as needed
    i = DCOUNT(OrderListArray,CHAR(253)) + 1
    k = DCOUNT(BackOrderListArray,CHAR(253)) + 1
    PartAvailable = PartOnHand - PartOnOrder
    PartOnBackOrder = Quantity - PartAvailable

    IF Quantity <= PartAvailable THEN   ;*Quantity fully in stock
        OrderListArray = INSERT(OrderListArray, 1, i, 1, PartNo)
        OrderListArray = INSERT(OrderListArray, 1, i, 2, PartDesc)
        OrderListArray = INSERT(OrderListArray, 1, i, 3, Quantity)
        OrderListArray = INSERT(OrderListArray, 1, i, 4, Price)

    END ELSE
        IF PartOnOrder >= PartOnHand THEN         ;*Quantity fully NOT in stock
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 1, PartNo)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 2, PartDesc)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 3, PartOnBackOrder)
            BackOrderListArray = INSERT(BackOrderListArray, 1, k, 4, Price)

        END ELSE    ;*Quantity partially in stock
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

REMOVEPART:         *Deletes element from OrderListArray w/ corresponding element in BackOrderListArray
    GOSUB CLEARSCREENSUB
    PRINT@(MAINCOL,MAINSTARTLINE+16): "Select an item to remove: "    ;*Picks an item of the array to remove
    PROMPT@(MAINCOL+30,MAINSTARTLINE+16): ""
    INPUT PartNo2
    PartNo2 = PartNo2'R%7'
    CRT@(MAINCOL+30,MAINSTARTLINE+16): PartNo2
    GOSUB FINDORDERLISTID
    GOSUB FINDBACKORDERLISTID
    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+17): "Confirm removal?(Y/N):    "          ;*Confirms the removal
        PROMPT@(MAINCOL+30,MAINSTARTLINE+17): ""
        INPUT Confirm,1
        Confirm = UPCASE(Confirm)
        BEGIN CASE
        CASE Confirm = "Y"
            GOSUB CLEARERROR
            IF OrderListID > 0 THEN
                DEL OrderListArray<1,OrderListID> ;*Wipes away previous order
            END
            GOSUB REMOVEBACKORDER
        CASE Confirm = "N"
            GOSUB CLEARERROR
            RETURN
        CASE Default = 1
            GOSUB THROWERROR
        END CASE
    UNTIL Confirm = "Y" OR Confirm = "N" DO
    REPEAT
    RETURN

PAINTSCREEN:        *Displays data in the "order list" section
    GOSUB CLEARSCREENALT
    j=1
    DisplayCap = 1
    DisplayCap = DCOUNT(OrderListArray, CHAR(253))
    LOOP  ;*Paints the "normal" orders
        PRINT@(MAINCOL+70,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,1>,"R")
        PRINT@(MAINCOL+85,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,2>,"L")
        PRINT@(MAINCOL+113,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,3>,"R,& #6")
        PRINT@(MAINCOL+123,MAINSTARTLINE+19+j): FMT(OrderListArray<1,j,4>,"R2,& $#6")
    UNTIL j > DisplayCap DO
        j=j+1
    REPEAT

    j = 1
    DisplayCap2 = DCOUNT(BackOrderListArray, CHAR(253))
    LOOP  ;*Paints the back-orders
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

PAINTCUSTOMERINFO:  *Display data in the "customer information" section
    GOSUB CLEARCUSTOMERINFO
    GOSUB FILECUSTOMER
    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   CustomerID
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   Name

*** Billing Address
    PRINT@(MAINCOL+88,MAINSTARTLINE+4):   Billing<1,1>
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   Billing<1,2>
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   Billing<1,3>
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  Billing<1,4>
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   Billing<1,5>

*** Shipping Address
    PRINT@(MAINCOL+90,MAINSTARTLINE+13):   Shipping<1,1>
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):   Shipping<1,2>
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):   Shipping<1,4>
    PRINT@(MAINCOL+125,MAINSTARTLINE+16):  Shipping<1,3>
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):   Shipping<1,5>
    RETURN

PRICETOTAL:         *Figures the total of the price
    TotalPrice = 0
    Counter = DCOUNT(OrderListArray, CHAR(253))
    i = 1
    LOOP
        Quantity = OrderListArray<1,i,3>
        Price = OrderListArray<1,i,4>
        UnitPrice = Quantity * Price
        TotalPrice = TotalPrice + UnitPrice
    UNTIL i > Counter DO
        i = i + 1
    REPEAT

    Counter = DCOUNT(BackOrderListArray, CHAR(253))
    i = 1
    LOOP
        Quantity = BackOrderListArray<1,i,3>
        Price = BackOrderListArray<1,i,4>
        UnitPrice = Quantity * Price
        TotalPrice = TotalPrice + UnitPrice
    UNTIL i > Counter DO
        i = i + 1
    REPEAT
    RETURN

LATEXWARNING:       *Confirmation that product has latex
    CRT@(MAINCOL+6,MAINSTARTLINE+25): SPACE(30)
    IF Latex = "Y" THEN
        CRT@(MAINCOL+6,MAINSTARTLINE+35): "Product contains Latex"
        MSLEEP(1500)
        CRT@(MAINCOL+6,MAINSTARTLINE+35): SPACE(30)
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

FILECUSTOMER:       *Opens, reads, and closes the "CUSTOMERFILES" file. Captures relevant data
    OPEN 'CUSTOMERFILE' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END
    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END
    Name = R.CUSTOMERFILE<1>
    CLOSE F.CUSTOMERFILE
    RETURN

OPENORDERS:         *Opens, reads, and closes the "ORDERS" file. Captures relevant data
    CRT@(MAINCOL,MAINSTARTLINE+50): "Enter an order ID: "
    PROMPT@(MAINCOL+20,MAINSTARTLINE+50): ""
    INPUT OrderID,7
    OrderID = OrderID'R%7'
    CRT@(MAINCOL+20,MAINSTARTLINE+50): OrderID
    OPEN 'ORDERS' TO F.ORDERS ELSE
        ABORT 201, 'ORDERS'
    END
    READ R.ORDERS FROM F.ORDERS,OrderID ELSE
        R.ORDERS = ''
    END
    CustomerID = R.ORDERS<1>
    Billing = R.ORDERS<2>
    Shipping = R.ORDERS<3>
    OrderListArray = R.ORDERS<4>
    BackOrderListArray = R.ORDERS<5>
    CLOSE F.ORDERS
    GOSUB PAINTSCREEN
    GOSUB PAINTCUSTOMERINFO
    RETURN

WRITEORDERS:        *Writes modified order to the "ORDERS" file.
    OPEN 'ORDERS' TO F.ORDERS ELSE
        ABORT 201, 'ORDERS'
    END
    GOSUB PRICETOTAL
    R.ORDERS<4> = OrderListArray
    R.ORDERS<5> = BackOrderListArray
    R.ORDERS<9> = TotalPrice
    WRITE R.ORDERS ON F.ORDERS,OrderID
    CLOSE F.ORDERS
    RETURN

UPDATEPARTSFILE1:
    TempListArray = OrderListArray
***
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONORDER1
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT
***
    TempListArray = BackOrderListArray
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONBACKORDER1
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT
    RETURN

UPDATEPARTSONORDER1:
    OPEN 'PARTS' TO F.PARTS ELSE
        ABORT 201, 'PARTS'
    END
    READ R.PARTS FROM F.PARTS,PartNo ELSE
        R.PARTS = ''
    END
    PartOnOrder = R.PARTS<3>
    R.PARTS<3> = PartOnOrder - Quantity
    WRITE R.PARTS ON F.PARTS,PartNo
    CLOSE F.PARTS
    RETURN

UPDATEPARTSONBACKORDER1:
    OPEN 'PARTS' TO F.PARTS ELSE
        ABORT 201, 'PARTS'
    END
    READ R.PARTS FROM F.PARTS,PartNo ELSE
        R.PARTS = ''
    END
    PartOnOrder = R.PARTS<4>
    R.PARTS<4> = PartOnOrder - Quantity
    WRITE R.PARTS ON F.PARTS,PartNo
    RETURN


UPDATEPARTSFILE2:
    TempListArray = OrderListArray
***
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONORDER2
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT
***
    TempListArray = BackOrderListArray
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONBACKORDER2
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT
    RETURN

UPDATEPARTSONORDER2:
    OPEN 'PARTS' TO F.PARTS ELSE
        ABORT 201, 'PARTS'
    END
    READ R.PARTS FROM F.PARTS,PartNo ELSE
        R.PARTS = ''
    END
    PartOnOrder = R.PARTS<3>
    R.PARTS<3> = PartOnOrder + Quantity
    WRITE R.PARTS ON F.PARTS,PartNo
    CLOSE F.PARTS
    RETURN

UPDATEPARTSONBACKORDER2:
    OPEN 'PARTS' TO F.PARTS ELSE
        ABORT 201, 'PARTS'
    END
    READ R.PARTS FROM F.PARTS,PartNo ELSE
        R.PARTS = ''
    END
    PartOnOrder = R.PARTS<4>
    R.PARTS<4> = PartOnOrder + Quantity
    WRITE R.PARTS ON F.PARTS,PartNo
    RETURN
***
*MISC. SUBROUTINES
***

CLEARCUSTOMERINFO:
    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   "                                     "
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   "                                     "
*** Billing Address                       "                                     "
    PRINT@(MAINCOL+88,MAINSTARTLINE+4):   "                                     "
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   "                                     "
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   "       "
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  "       "
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   "                                     "
*** Shipping Address                      "                                     "
    PRINT@(MAINCOL+90,MAINSTARTLINE+13):  "                                     "
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):  "                                     "
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):  "       "
    PRINT@(MAINCOL+125,MAINSTARTLINE+16): "       "
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):  "                                     "
    RETURN

CLEARSCREENSUB:
    CRT@(MAINCOL,MAINSTARTLINE+16): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+17): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+18): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+19): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+20): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+21): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+22): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+23): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+24): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+25): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+26): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+27): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+28): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+29): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+30): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+31): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+32): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+33): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+34): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+35): ClearError
    CRT@(MAINCOL,MAINSTARTLINE+36): ClearError
    RETURN

CLEARSCREENALT:     *Clears the order list section
    CRT@(MAINCOL+70,MAINSTARTLINE+20): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+21): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+22): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+23): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+24): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+25): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+26): SPACE(06)
    CRT@(MAINCOL+70,MAINSTARTLINE+27): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+28): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+29): SPACE(60)
    CRT@(MAINCOL+70,MAINSTARTLINE+30): SPACE(60)
    RETURN

THROWERROR:         *Throws an error
    CRT@(MAINCOL,MAINSTARTLINE+8): "Please Enter a valid menu choice."
    RETURN

CLEARERROR:         *Clears an error
    CRT@(MAINCOL,MAINSTARTLINE+8): ClearError
    RETURN

SEEVAR:   *For debugging purposes
    CRT@(MAINCOL,MAINSTARTLINE+51):OrderListArray
    CRT@(MAINCOL,MAINSTARTLINE+53):BackOrderListArray
    RETURN

