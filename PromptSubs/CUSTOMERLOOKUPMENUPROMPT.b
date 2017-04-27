*********************************************************
***Prompts CUSTOMERLOOKUP menu
*************************************************************

    SUBROUTINE CUSTOMERLOOKUPMENUPROMPT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+7):  "Choose an action: "
        INPUT MenuChoice, 2

        ClearError = STR(" ",MAINSECTIONWIDTH)    ;*clears error message
        CRT@(MAINCOL,MAINSTARTLINE+8): ClearError

        MenuChoice = UPCASE(MenuChoice) ;*converts entry to upper case

    UNTIL MenuChoice = "RM" OR MenuChoice = "EX" OR MenuChoice = "CN" OR MenuChoice = "CI" DO
        CRT@(MAINCOL,MAINSTARTLINE+8): "Please Enter a valid menu choice."
    REPEAT

*************Takes user to menu choice.
    BEGIN CASE
    CASE MenuChoice = "RM"
        RETURN
    CASE MenuChoice = "CN"
        GOSUB CLEARCUSTOMERINFO
        GOSUB LOOKUPBYCOMPANYNAME
        GOSUB CONFIRMCUSTOMERINFO
        CALL SECONDMENU
    CASE MenuChoice = "CI"
        GOSUB CLEARCUSTOMERINFO
        GOSUB LOOKUPBYCUSTOMERID
        GOSUB CONFIRMCUSTOMERINFO
        CALL SECONDMENU
    CASE MenuChoice = "EX"
        CRT@(-1)
        STOP
    END CASE
    RETURN



*******************************
*LOOKUPBYCOMPANYNAME SUBROUTINE
*******************************
LOOKUPBYCOMPANYNAME:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    R.CUSTOMERFILE = ''

    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+8):   "Company Name: "
        PROMPT@(MAINCOL+14,MAINSTARTLINE+8)
        INPUT CompanyName,25

        EXECUTE "COUNT CustomerFile" CAPTURING TotalRecords ;* Count number of records in the CustomerFile
        TotalRecords = OCONV(TotalRecords, "MCN") ;* Pull out just the number

        FOR I = 1 TO TotalRecords       ;* For loop to search trough records in customer
            I = I'R%7'        ;* Set I to look like 0000001
            READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,I THEN  ;* Read in current record
                IF R.CUSTOMERFILE<1> = CompanyName THEN     ;* If the Comapny Field value equals the entered company name
                    CustomerID = I      ;* then set customerID equal to I
                    GOSUB PAINTCUSTOMERINFO       ;* and call PAINTCUSTOMERINFO SUBROUTINE
                    BREAK
                END
            END
        NEXT I

        PRINT@(MAINCOL,MAINSTARTLINE+23): "Is this the correct customer? (y for Yes, n for No)"
        PROMPT@(MAINCOL,MAINSTARTLINE+24):
        INPUT isCustomer,1
        isCustomer = DOWNCASE(isCustomer)
        IF isCustomer = 'n' THEN
            PRINT@(MAINCOL,MAINSTARTLINE+23):  STR(" ", 52) ;* Clear correct customer message
            PRINT@(MAINCOL,MAINSTARTLINE+24):  STR(" ", 15) ;* Clear input for correct customer message
            PRINT@(MAINCOL+12,MAINSTARTLINE+8): STR(" ", 28)          ;* Clear entered company name
            CALL DISPLAYCUSTOMERLOOKUP
        END
    UNTIL isCustomer = 'y'
    REPEAT

    RETURN

*******************************
*LOOKUPBYCUSTOMERID SUBROUTINE
*******************************
LOOKUPBYCUSTOMERID:
**** Open the file
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    R.CUSTOMERFILE = ''

    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+8):   "Customer ID: "
        PROMPT@(MAINCOL+12,MAINSTARTLINE+8)
        INPUT CustomerID,7

        READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE       ;* Read in the record from CustomerFile with the ID equal to CustomerID
            PRINT@(MAINCOL,MAINSTARTLINE+25):   "No record found for that Customer ID."
        END

        GOSUB PAINTCUSTOMERINFO

        PRINT@(MAINCOL,MAINSTARTLINE+23): "Is this the correct customer? (y for Yes, n for No)"
        PROMPT@(MAINCOL,MAINSTARTLINE+24):
        INPUT isCustomer,1
        isCustomer = DOWNCASE(isCustomer)
        IF isCustomer = 'n' THEN
            PRINT@(MAINCOL,MAINSTARTLINE+23):  STR(" ", 52) ;* Clear correct customer message
            PRINT@(MAINCOL,MAINSTARTLINE+24):  STR(" ", 15) ;* Clear input for correct customer message
            PRINT@(MAINCOL+12,MAINSTARTLINE+8): STR(" ", 12)          ;* Clear entered customer id
            CALL DISPLAYCUSTOMERLOOKUP
        END
    UNTIL isCustomer = 'y'
    REPEAT

    RETURN


******************************
*PAINTCUSTOMERINFO SUBROUTINE
******************************
PAINTCUSTOMERINFO:

    PRINT@(MAINCOL+21,MAINSTARTLINE+9):  R.CUSTOMERFILE<1>  ;*Company Name
    PRINT@(MAINCOL+21,MAINSTARTLINE+10): R.CUSTOMERFILE<4>  ;*Contact Firstname
    PRINT@(MAINCOL+21,MAINSTARTLINE+11): R.CUSTOMERFILE<5>  ;*Contact Lastname
    PRINT@(MAINCOL+21,MAINSTARTLINE+12): R.CUSTOMERFILE<6>  ;*Contact Phone
*** Billing Address
    PRINT@(MAINCOL+21,MAINSTARTLINE+13): R.CUSTOMERFILE<2,1>          ;*Billing Line1
    PRINT@(MAINCOL+21,MAINSTARTLINE+14): R.CUSTOMERFILE<2,2>          ;*Billing Line2
    PRINT@(MAINCOL+21,MAINSTARTLINE+15): R.CUSTOMERFILE<2,3>          ;*Billing City
    PRINT@(MAINCOL+56,MAINSTARTLINE+15): R.CUSTOMERFILE<2,4>          ;*Billing State
    PRINT@(MAINCOL+21,MAINSTARTLINE+16): R.CUSTOMERFILE<2,5>          ;*Billing Zip
*** Shipping Address
    PRINT@(MAINCOL+21,MAINSTARTLINE+18): R.CUSTOMERFILE<3,1>          ;*Shipping Line1
    PRINT@(MAINCOL+21,MAINSTARTLINE+19): R.CUSTOMERFILE<3,2>          ;*Shipping Line2
    PRINT@(MAINCOL+21,MAINSTARTLINE+20): R.CUSTOMERFILE<3,3>          ;*Shipping City
    PRINT@(MAINCOL+56,MAINSTARTLINE+20): R.CUSTOMERFILE<3,4>          ;*Shipping State
    PRINT@(MAINCOL+21,MAINSTARTLINE+21): R.CUSTOMERFILE<3,5>          ;*Shipping Zip

    RETURN

*******************************
*CONFIRMCUSTOMERINFO SUBROUTINE
*******************************
CONFIRMCUSTOMERINFO:

    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   CustomerID        ;*Customer ID
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   R.CUSTOMERFILE<1> ;*Company Name
*** Billing Address
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   R.CUSTOMERFILE<2,1>         ;*Billing Line1
    PRINT@(MAINCOL+88,MAINSTARTLINE+6):   R.CUSTOMERFILE<2,2>         ;*Billing Line2
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   R.CUSTOMERFILE<2,3>         ;*Billing City
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  R.CUSTOMERFILE<2,4>         ;*Billing State
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   R.CUSTOMERFILE<2,5>         ;*Billing Zip

*** Shipping Address
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):   R.CUSTOMERFILE<3,1>        ;*Shipping Line1
    PRINT@(MAINCOL+90,MAINSTARTLINE+15):   R.CUSTOMERFILE<3,2>        ;*Shipping Line2
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):   R.CUSTOMERFILE<3,3>        ;*Shipping City
    PRINT@(MAINCOL+125,MAINSTARTLINE+16):  R.CUSTOMERFILE<3,4>        ;*Shipping State
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):   R.CUSTOMERFILE<3,5>        ;*Shipping Zip

    RETURN

*****************************
*CLEARCUSTOMERINFO SUBROUTINE
*****************************
CLEARCUSTOMERINFO:

    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   STR(" ", 38)      ;*Customer ID
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   STR(" ", 38)      ;*Company Name
*** Billing Address
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   STR(" ", 38)      ;*Billing Line1
    PRINT@(MAINCOL+88,MAINSTARTLINE+6):   STR(" ", 38)      ;*Billing Line2
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   STR(" ", 15)      ;*Billing City
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  STR(" ", 3)       ;*Billing State
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   STR(" ", 38)      ;*Billing Zip
*** Shipping Address
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):  STR(" ", 38)      ;*Shipping Line1
    PRINT@(MAINCOL+90,MAINSTARTLINE+15):  STR(" ", 38)      ;*Shipping Line2
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):  STR(" ", 15)      ;*Shipping City
    PRINT@(MAINCOL+125,MAINSTARTLINE+16): STR(" ", 3)       ;*Shipping State
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):  STR(" ", 38)      ;*Shipping Zip

    RETURN












