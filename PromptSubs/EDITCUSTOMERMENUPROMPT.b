*********************************************************
**Prompts EDITCUSTOMER menu
*************************************************************
    SUBROUTINE EDITCUSTOMERMENUPROMPT
    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

    EQU TRUE TO 1
    EQU FALSE TO 0
    DEFFUN ValidPhone()
    DEFFUN ValidEntry()
    DEFFUN ValidState()
    DEFFUN ValidZip()


*************Checks for CustomerID
    IF CustomerID = " " THEN
        PRINT ("Must look up customer first!(LC)")
    END ELSE

*************Loops menu choice until valid input
        LOOP
            PROMPT@(MAINCOL,MAINSTARTLINE+19):  "Choose an action: "
            INPUT MenuChoice, 2
            ClearError = STR(" ",MAINSECTIONWIDTH)          ;*clears error message
            CRT@(MAINCOL,MAINSTARTLINE+8): ClearError
            MenuChoice = UPCASE(MenuChoice)       ;*converts entry to upper case
        UNTIL MenuChoice = "RM" OR MenuChoice = "EN" OR MenuChoice = "EF" OR MenuChoice = "EL" OR MenuChoice = "B1" OR MenuChoice = "B2" OR MenuChoice = "EC" OR MenuChoice = "EY" OR MenuChoice = "EZ" OR MenuChoice = "S1" OR MenuChoice = "S2" OR MenuChoice = "ED" OR MenuChoice = "EK" OR MenuChoice = "ET" OR  MenuChoice = "EX" OR MenuChoice = "ES" OR MenuChoice = "CI" OR MenuChoice = "EH" DO
            CRT@(MAINCOL,MAINSTARTLINE+22): "Please Enter a valid menu choice."
        REPEAT

*************Takes user to menu choice
        BEGIN CASE
        CASE MenuChoice = "RM"
            RETURN
        CASE MenuChoice = "EN"
            GOSUB EDITCOMPNAME
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "B1"
            GOSUB EDITBILLINGLINE1
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "B2"
            GOSUB EDITBILLINGLINE2
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EF"
            GOSUB EDITFNAME
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EL"
            GOSUB EDITLNAME
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "ED"
            GOSUB EDITSCITY
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "S1"
            GOSUB EDITSHIPPINGLINE1
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "S2"
            GOSUB EDITSHIPPINGLINE2
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EK"
            GOSUB EDITSSTATE
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "ET"
            GOSUB EDITSZIP
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EY"
            GOSUB EDITBCITY
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "ES"
            GOSUB EDITBSTATE
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EZ"
            GOSUB EDITBZIP
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EH"
            GOSUB EDITNUM
            GOSUB CONFIRMCUSTOMERINFO
        CASE MenuChoice = "EX"
            CRT@(-1)
            STOP
        END CASE
    END
    RETURN

**********************************
*EDITCOMPNAME SUBROUTINE
**********************************
EDITCOMPNAME:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Company Name: "

        LOOP
            INPUT NewCompName
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewCompName)  ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the company name correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)

    UNTIL Correct = 'y'
        R.CUSTOMERFILE<1> = NewCompName 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITFNAME SUBROUTINE
**********************************
EDITFNAME:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New First Name: "

        LOOP
            INPUT NewFName
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewFName)     ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT


        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the first name correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)

    UNTIL Correct = 'y'
        R.CUSTOMERFILE<4> = NewFName 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITLNAME SUBROUTINE
**********************************
EDITLNAME:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Last Name: "

        LOOP
            INPUT NewLName
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewLName)     ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the last name correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)

    UNTIL Correct = 'y'
        R.CUSTOMERFILE<5> = NewLName 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITNUM SUBROUTINE
**********************************
EDITNUM:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Number: "

        LOOP
            INPUT NewNum
            ValidInput = ValidPhone(NewNum)       ;*validates standard phone number formats including 10 digits with no dashes
            Type = "Phone"    ;*reassigns type for error message displayf
            CALL ERRORMESSAGES(Type,ValidInput)   ;*passes type and whether true or false
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the number correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)

    UNTIL Correct = 'y'
        R.CUSTOMERFILE<6> = NewNum 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITBILLINGLINE1 SUBROUTINE
**********************************
EDITBILLINGLINE1:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Billing Line 1: "

        LOOP
            INPUT NewBill
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewBill)      ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the address correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<2,1> = NewBill 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITSHIPPINGLINE1 SUBROUTINE
**********************************
EDITSHIPPINGLINE1:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Shipping Line 1: "

        LOOP
            INPUT NewShip
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewShip)      ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the address correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<3,1> = NewShip 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITBILLINGLINE2 SUBROUTINE
**********************************
EDITBILLINGLINE2:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Billing Line 2: "

        LOOP
            INPUT NewBill
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewBill)      ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is Line 2 correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<2,2> = NewBill 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITSHIPPINGLINE2 SUBROUTINE
**********************************
EDITSHIPPINGLINE2:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Shipping Line 2: "

        LOOP
            INPUT NewShip
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewShip)      ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is Line 2 correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<3,2> = NewShip 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITBCITY SUBROUTINE
**********************************
EDITBCITY:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New City: "

        LOOP
            INPUT NewBCity
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewBCity)     ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the city correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<2,3> = NewBCity 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITSCITY SUBROUTINE
**********************************
EDITSCITY:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New City: "

        LOOP
            INPUT NewSCity
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(NewSCity)     ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the city correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<3,3> = NewSCity 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITBSTATE SUBROUTINE
**********************************
EDITBSTATE:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New State: "

        LOOP
            INPUT NewBState
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidState(NewBState)    ;* validates state
            Type = "State"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the state correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<2,4> = NewBState 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITSSTATE SUBROUTINE
**********************************
EDITSSTATE:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New State: "

        LOOP
            INPUT NewSState
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidState(NewSState)    ;* validates state
            Type = "State"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the state correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<3,4> = NewSState 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITBZIP SUBROUTINE
**********************************
EDITBZIP:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Zip Code: "

        LOOP
            INPUT NewBZip
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidZip(NewBZip)        ;* makes sure zip is valid
            Type = "Zip"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the zip code correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<2,5> = NewBZip 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

**********************************
*EDITSZIP SUBROUTINE
**********************************
EDITSZIP:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    READ R.CUSTOMERFILE FROM F.CUSTOMERFILE,CustomerID ELSE
        R.CUSTOMERFILE = ''
    END

    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+20): "New Zip Code: "

        LOOP
            INPUT NewSZip
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidZip(NewSZip)        ;* makes sure zip is valid
            Type = "Zip"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        UNTIL ValidInput MATCHES TRUE REPEAT

        PROMPT@(MAINCOL,MAINSTARTLINE+22): "Is the zip code correct? (y for Yes, n for No)"
        INPUT Correct
        Correct = DOWNCASE(Correct)
    UNTIL Correct = 'y'
        R.CUSTOMERFILE<3,5> = NewSZip 'L#24'
        WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,CustomerID
    REPEAT
    RETURN

******************************
*CONFIRMCUSTOMERINFO SUBROUTINE
*******************************
CONFIRMCUSTOMERINFO:

    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   CustomerID
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   R.CUSTOMERFILE<1>
*** Billing Address
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   R.CUSTOMERFILE<2,1>
    PRINT@(MAINCOL+88,MAINSTARTLINE+6):   R.CUSTOMERFILE<2,2>
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   R.CUSTOMERFILE<2,3>
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  R.CUSTOMERFILE<2,4>
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   R.CUSTOMERFILE<2,5>

*** Shipping Address
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):   R.CUSTOMERFILE<3,1>
    PRINT@(MAINCOL+90,MAINSTARTLINE+15):   R.CUSTOMERFILE<3,2>
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):   R.CUSTOMERFILE<3,3>
    PRINT@(MAINCOL+125,MAINSTARTLINE+16):  R.CUSTOMERFILE<3,4>
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):   R.CUSTOMERFILE<3,5>

    RETURN


