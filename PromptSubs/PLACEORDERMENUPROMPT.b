*********************************************************
***Prompts PLACEORDER menu
*************************************************************

    SUBROUTINE PLACEORDERMENUPROMPT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID


    DELIVERYDAYS = 2
    BACKDELIVERYDAYS = 5
*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+7):  "Choose an action: "
        INPUT MenuChoice, 2

        ClearError = STR(" ",MAINSECTIONWIDTH)    ;*clears error message
        CRT@(MAINCOL,MAINSTARTLINE+8): ClearError

        MenuChoice = UPCASE(MenuChoice) ;*converts entry to upper case

    UNTIL MenuChoice = "RM" OR MenuChoice = "EX" OR MenuChoice = "PO" DO
        CRT@(MAINCOL,MAINSTARTLINE+8): "Please Enter a valid menu choice."
    REPEAT

*************Takes user to menu choice.
    BEGIN CASE
    CASE MenuChoice = "RM"
        RETURN
    CASE MenuChoice = "PO"
        GOSUB GETORDERDATA
        GOSUB PAINTORDERDATA
    CASE MenuChoice = "EX"
        CRT@(-1)
        STOP
    END CASE
    RETURN

*******************************
*GETORDERDATA SUBROUTINE
*******************************
GETORDERDATA:
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

    PRINT@(MAINCOL+26,MAINSTARTLINE+9): TotalPrice

    NextDay = DATE()
    i = 0
    Default = 1
    LOOP
        DayName = OCONV(NextDay,"DWA")
        BEGIN CASE
        CASE DayName = "SATURDAY"

        CASE DayName = "SUNDAY"

        CASE Default = 1
            i = i + 1
        END CASE
    UNTIL i > DELIVERYDAYS DO
        NextDay = NextDay + 1
    REPEAT

    DeliveryDate = NextDay

    NextDay = DATE()
    i = 0
    LOOP
        DayName = OCONV(NextDay,"DWA")
        BEGIN CASE
        CASE DayName = "SATURDAY"

        CASE DayName = "SUNDAY"

        CASE Default = 1
            i = i + 1
        END CASE
    UNTIL i > BACKDELIVERYDAYS DO
        NextDay = NextDay + 1
    REPEAT

    BackDeliveryDate = NextDay

    RETURN


*******************************
*PAINTORDERDATA SUBROUTINE
*******************************
PAINTORDERDATA:

    PRINT@(MAINCOL+26,MAINSTARTLINE+9): TotalPrice

    PRINT@(MAINCOL+26,MAINSTARTLINE+10): OCONV(DeliveryDate, "DWA") : ", " : OCONV(DeliveryDate, "D4")

    PRINT@(MAINCOL+26,MAINSTARTLINE+11): OCONV(BackDeliveryDate, "DWA") : ", " : OCONV(BackDeliveryDate, "D4")

    PROMPT("Confirm?(Y/N): ")

    INPUT Answer,1

    Answer = UPCASE(Answer)

    BEGIN CASE
    CASE Answer = "Y"
        GOSUB CREATEORDERRECORD
    CASE Answer = "N"
        RETURN
    END CASE

    RETURN

*******************************
*CREATEORDERRECORD SUBROUTINE
*******************************
CREATEORDERRECORD:
    OPEN 'CUSTOMERFILE' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END
    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END
    Billing = R.CUSTOMERFILE<2>
    Shipping = R.CUSTOMERFILE<3>
    CLOSE F.CUSTOMERFILE

    OPEN 'ORDERS' TO F.ORDERS ELSE
        ABORT 201, 'ORDERS'
    END
    R.ORDERS = ''
    EXECUTE "COUNT ORDERS" CAPTURING TotalRecords
    TotalRecords = OCONV(TotalRecords, "MCN")
    NewRecord = TotalRecords + 1
    NewRecord = NewRecord'R%7'

    R.ORDERS<1> = CustomerID
    R.ORDERS<2> = Billing
    R.ORDERS<3> = Shipping
    R.ORDERS<4> = OrderListArray
    R.ORDERS<5> = BackOrderListArray
    R.ORDERS<6> = DATE()
    R.ORDERS<7> = DeliveryDate
    R.ORDERS<8> = BackDeliveryDate
    R.ORDERS<9> = TotalPrice
    R.ORDERS<10> = NewRecord

    WRITE R.ORDERS ON F.ORDERS,NewRecord
    CLOSE F.ORDERS

    GOSUB UPDATEPARTSFILE

    PRINT@(MAINCOL+26,MAINSTARTLINE+12): "Your order has been placed."

    PROMPT("")
    INPUT ANYTHING

    RETURN


************************
*UPDATE INVENTORY ORDERS
************************

UPDATEPARTSFILE: 
    TempListArray = OrderListArray
***
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONORDER
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT
***
    TempListArray = BackOrderListArray
    LOOP
        Counter = DCOUNT(TempListArray,CHAR(253))
        PartNo = TempListArray<1,1,1>
        Quantity = TempListArray<1,1,3>
        GOSUB UPDATEPARTSONBACKORDER
        GOSUB SEEVAR
    UNTIL Counter = 1 DO
        DEL TempListArray<1,1>
    REPEAT 
    RETURN

UPDATEPARTSONORDER: 
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

UPDATEPARTSONBACKORDER:
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
    
SEEVAR:   *DEBUGGING STUFF
    PRINT PartNo:" ":Quantity
    RETURN 
