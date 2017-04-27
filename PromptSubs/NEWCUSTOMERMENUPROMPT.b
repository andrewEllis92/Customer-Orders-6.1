*********************************************************
***Prompts NEWCUSTOMER menu
*************************************************************

    SUBROUTINE NEWCUSTOMERMENUPROMPT

***************************COMMON AND GLOBAL VARIABLES***********************************

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL
    COMMON OrderListArray, BackOrderListArray
    COMMON CustomerID

    EQU TRUE TO 1
    EQU FALSE TO 0
    DEFFUN ValidPhone()
    DEFFUN ValidEntry()
    DEFFUN ValidState()
    DEFFUN ValidZip()

*************Loops menu choice until valid input.
    LOOP
        PROMPT@(MAINCOL,MAINSTARTLINE+6):  "Choose an action: "
        INPUT MenuChoice, 2

        ClearError = STR(" ",MAINSECTIONWIDTH)    ;*clears error message
        CRT@(MAINCOL,MAINSTARTLINE+7): ClearError

        MenuChoice = UPCASE(MenuChoice) ;*converts entry to upper case

    UNTIL MenuChoice = "RM" OR MenuChoice = "EX" OR MenuChoice = "NC" DO
        CRT@(MAINCOL,MAINSTARTLINE+7): "Please Enter a valid menu choice."
    REPEAT

*************Takes user to menu choice.
    BEGIN CASE
    CASE MenuChoice = "RM" OR MenuChoice = "rm"
        RETURN
    CASE MenuChoice = "NC" OR MenuChoice = "nc"
        GOSUB CLEARCUSTOMERINFO
        GOSUB GETCUSTOMERINFO
        GOSUB CONFIRMCUSTOMERINFO
        CALL SECONDMENU
    CASE MenuChoice = "EX" OR MenuChoice = "ex"
        CRT@(-1)
        STOP
    END CASE
    RETURN

***********************************************
*************Takes customer information.
***********************************************

GETCUSTOMERINFO:

***prompts for first data entry, following are prompted from each previous sub
    GOSUB COMPANYNAME
    GOSUB CONTACTFIRST
    GOSUB CONTACTLAST
    GOSUB CONTACTPHONE
    GOSUB BILLINGADDRESS
    GOSUB BILLINGLINE2
    GOSUB BILLINGCITY
    GOSUB BILLINGSTATE
    GOSUB BILLINGZIP
    GOSUB SHIPPINGADDRESS
    GOSUB SHIPPINGLINE2
    GOSUB SHIPPINGCITY
    GOSUB SHIPPINGSTATE
    GOSUB SHIPPINGZIP

***array for billing and shipping addresses

    BillingAddressArray = ''
    ShippingAddressArray = ''

****BILLING AND SHIPPING ARRAY BUILDS

    BillingAddressArray = INSERT(BillingAddressArray, 1, 1, 0, BillingAddress)
    BillingAddressArray = INSERT(BillingAddressArray, 1, 2, 0, BillingLine2)
    BillingAddressArray = INSERT(BillingAddressArray, 1, 3, 0, BillingCity)
    BillingAddressArray = INSERT(BillingAddressArray, 1, 4, 0, BillingState)
    BillingAddressArray = INSERT(BillingAddressArray, 1, 5, 0, BillingZip)

    ShippingAddressArray = INSERT(ShippingAddressArray, 1, 1, 0, ShippingAddress)
    ShippingAddressArray = INSERT(ShippingAddressArray, 1, 2, 0, ShippingLine2)
    ShippingAddressArray = INSERT(ShippingAddressArray, 1, 3, 0, ShippingCity)
    ShippingAddressArray = INSERT(ShippingAddressArray, 1, 4, 0, ShippingState)
    ShippingAddressArray = INSERT(ShippingAddressArray, 1, 5, 0, ShippingZip)

    RETURN

************************************************(START OF PROMPT SUBROUTINES)**************************************

************************************************************
****PROMPT FOR COMPANY NAME
*********************************************************

COMPANYNAME:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+8)
        INPUT CompanyName, 45

        BEGIN CASE  ;* checks if user wants to return to menu
        CASE CompanyName = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE CompanyName # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(CompanyName)  ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

************************************************************
****PROMPTS FOR CONTACTS FIRST NAME
*****************************************************************

CONTACTFIRST:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+9)
        INPUT ContactFirst, 30

        BEGIN CASE
        CASE ContactFirst = "z"
            CRT@(MAINCOL+21,MAINSTARTLINE+9): STR(' ', 30)  ;*clears z
            GOSUB COMPANYNAME
            GOSUB CONTACTFIRST
        CASE ContactFirst = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ContactFirst # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(ContactFirst) ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

********************************************************
***PROMPTS FOR CONTACTS LAST NAME
***********************************************************

CONTACTLAST:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+10)
        INPUT ContactLast, 40

        BEGIN CASE
        CASE ContactLast = 'z'
            CRT@(MAINCOL+21,MAINSTARTLINE+10): STR(' ', 40) ;*clears "z"
            GOSUB CONTACTFIRST
            GOSUB CONTACTLAST
        CASE ContactLast = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ContactLast # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(ContactLast)  ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

*****************************************************
***PROMPTS FOR CONTACT PHONE NUMBER
******************************************************

CONTACTPHONE:
    LOOP  ;*PHONE NUMBER
        CRT@(MAINCOL+21,MAINSTARTLINE+11): STR(' ',30)
        PROMPT@(MAINCOL+21,MAINSTARTLINE+11)
        INPUT ContactPhone, 14
        BEGIN CASE
        CASE ContactPhone = 'z'
            CRT@(MAINCOL+21,MAINSTARTLINE+11): STR(' ', 14) ;*clears "z"
            GOSUB CONTACTLAST
            GOSUB CONTACTPHONE
        CASE ContactPhone = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ContactPhone # "ex"
            ValidInput = ValidPhone(ContactPhone) ;*validates standard phone number formats including 10 digits with no dashes
            Type = "Phone"    ;*reassigns type for error message displayf
            CALL ERRORMESSAGES(Type,ValidInput)   ;*passes type and whether true or false
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

****************************************************BILLING ADDRESS

***********************************************
****PROMPTS FOR BILLING ADDRESS LINE 1
************************************************

BILLINGADDRESS:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+13)
        INPUT BillingAddress, 45

        BEGIN CASE
        CASE BillingAddress = 'z'
            CRT@(MAINCOL+21,MAINSTARTLINE+13): STR(' ', 45) ;*clears "z"
            GOSUB CONTACTPHONE
            GOSUB BILLINGADDRESS
        CASE BillingAddress = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE BillingAddress # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(BillingAddress)         ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

**************************************************
***PROMPTS FOR BILLING ADDRESS LINE 2
*********************************************************

BILLINGLINE2:

    PROMPT@(MAINCOL+21,MAINSTARTLINE+14)
    INPUT BillingLine2, 45

    BEGIN CASE
    CASE BillingLine2 = 'z'
        CRT@(MAINCOL+21,MAINSTARTLINE+14): STR(' ', 45)     ;*clears "z"
        GOSUB BILLINGADDRESS
        GOSUB BILLINGLINE2
    CASE BillingLine2 = "ex"
        CALL NEWCUSTOMERMENUPROMPT
    END CASE

    RETURN

*******************************************************
***PROMPTS FOR BILLING CITY
**********************************************************

BILLINGCITY:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+15)
        INPUT BillingCity, 20

        BEGIN CASE
        CASE BillingCity = 'z'
            CRT@(MAINCOL+21,MAINSTARTLINE+15): STR(' ', 20) ;*clears "z"
            GOSUB BILLINGLINE2
            GOSUB BILLINGCITY
        CASE BillingCity = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE BillingCity # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(BillingCity)  ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

**********************************************************
***PROMPTS FOR BILLING STATE
************************************************************

BILLINGSTATE:
    LOOP
        CRT@(MAINCOL+56,MAINSTARTLINE+15): STR(' ',2)
        PROMPT@(MAINCOL+56,MAINSTARTLINE+15)
        INPUT BillingState, 2

        BEGIN CASE
        CASE BillingState = 'z'
            CRT@(MAINCOL+56,MAINSTARTLINE+15): STR(' ', 2)  ;*clears "z"
            GOSUB BILLINGCITY
            GOSUB BILLINGSTATE
        CASE BillingState # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidState(BillingState) ;* makes sure zip is valid
            Type = "State"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN


****************************************************
***PROMPTS FOR BILLING ZIP
********************************************************

BILLINGZIP:
    LOOP
        CRT@(MAINCOL+21,MAINSTARTLINE+16): STR(' ',5)
        PROMPT@(MAINCOL+21,MAINSTARTLINE+16)
        INPUT BillingZip, 5

        BEGIN CASE
        CASE BillingZip = 'z'
            CRT@(MAINCOL+21,MAINSTARTLINE+16): STR(' ', 5)  ;*clears "z"
            GOSUB BILLINGSTATE
            GOSUB BILLINGZIP
        CASE BillingZip = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE BillingZip # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidZip(BillingZip)     ;* makes sure input is not blank
            Type = "Zip"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

************************************************SHIPPING ADDRESS

***********************************************************
***PROMPTS FOR SHIPPINGADDRESS LINE 1
**************************************************************

SHIPPINGADDRESS:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+18)
        INPUT ShippingAddress, 45

        BEGIN CASE
        CASE ShippingAddress = "z"
            CRT@(MAINCOL+21,MAINSTARTLINE+18): STR(' ', 45) ;*clears "z"
            GOSUB BILLINGZIP
            GOSUB SHIPPINGADDRESS
        CASE ShippingAddress = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ShippingAddress # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(ShippingAddress)        ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE

    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

****************************************************
***PROMPTS FOR SHIPPING ADDRESS LINE 2
******************************************************

SHIPPINGLINE2:

    PROMPT@(MAINCOL+21,MAINSTARTLINE+19)
    INPUT ShippingLine2, 45

    BEGIN CASE
    CASE ShippingLine2 = "z"
        CRT@(MAINCOL+21,MAINSTARTLINE+19): STR(' ', 45)     ;*clears "z"
        GOSUB SHIPPINGADDRESS
        GOSUB SHIPPINGLINE2
    CASE ShippingLine2 = "ex"
        CALL NEWCUSTOMERMENUPROMPT
    END CASE

    RETURN

****************************************************
***PROMPTS FOR SHIPPING CITY
******************************************************

SHIPPINGCITY:
    LOOP
        PROMPT@(MAINCOL+21,MAINSTARTLINE+20)
        INPUT ShippingCity, 20

        BEGIN CASE
        CASE ShippingCity = "z"
            CRT@(MAINCOL+21,MAINSTARTLINE+20): STR(' ', 20) ;*clears "z"
            GOSUB SHIPPINGLINE2
            GOSUB SHIPPINGCITY
        CASE ShippingCity = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ShippingCity # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidEntry(ShippingCity) ;* makes sure input is not blank
            Type = "Entry"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE
    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

***************************************************
****PROMPTS FOR SHIPPING STATE
*******************************************************

SHIPPINGSTATE:
    LOOP
        CRT@(MAINCOL+56,MAINSTARTLINE+20): STR(' ',15)
        PROMPT@(MAINCOL+56,MAINSTARTLINE+20)
        INPUT ShippingState, 2

        BEGIN CASE
        CASE ShippingState = "z"
            CRT@(MAINCOL+56,MAINSTARTLINE+20): STR(' ', 2)  ;*clears "z"
            GOSUB SHIPPINGCITY
            GOSUB SHIPPINGSTATE
        CASE ShippingState = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ShippingState # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidState(ShippingState)          ;* validates state
            Type = "State"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE
    UNTIL ValidInput MATCHES TRUE REPEAT

    RETURN

***************************************************
***PROMPTS FOR SHIPPING ZIP
***************************************************

SHIPPINGZIP:
    LOOP
        CRT@(MAINCOL+21,MAINSTARTLINE+21): STR(' ',30)
        PROMPT@(MAINCOL+21,MAINSTARTLINE+21):
        INPUT ShippingZip, 5

        BEGIN CASE
        CASE ShippingZip = "z"
            CRT@(MAINCOL+21,MAINSTARTLINE+21): STR(' ', 5)  ;*clears "z"
            GOSUB SHIPPINGSTATE
            GOSUB SHIPPINGZIP
        CASE ShippingZip = "ex"
            CALL NEWCUSTOMERMENUPROMPT
        CASE ShippingZip # "ex"
            ValidInput = ''   ;*resets for new validation
            ValidInput = ValidZip(ShippingZip)    ;* makes sure zip is valid
            Type = "Zip"
            CALL ERRORMESSAGES(Type, ValidInput)  ;*kicks out proper error message
        END CASE
    UNTIL ValidInput MATCHES TRUE REPEAT
    RETURN

***********************************************************(END OF PROMPT SUBROUTINES)******************************

*****************************************************
*************Writes customer info to file.
**************************************************

ADDCUSTOMERINFO:
    OPEN 'CustomerFile' TO F.CUSTOMERFILE ELSE
        ABORT 201, 'CUSTOMERFILE'
    END

    R.CUSTOMERFILE = ''

    R.CUSTOMERFILE<1> = CompanyName
    R.CUSTOMERFILE<2> = BillingAddressArray
    R.CUSTOMERFILE<3> = ShippingAddressArray
    R.CUSTOMERFILE<4> = ContactFirst
    R.CUSTOMERFILE<5> = ContactLast
    R.CUSTOMERFILE<6> = ContactPhone

    WRITE R.CUSTOMERFILE ON F.CUSTOMERFILE,NewRecord

    CustomerID = NewRecord

    RETURN

******************************
*CONFIRMCUSTOMERINFO SUBROUTINE
*******************************
CONFIRMCUSTOMERINFO:

    EXECUTE "COUNT CustomerFile" CAPTURING TotalRecords
    TotalRecords = OCONV(TotalRecords, "MCN")
    NewRecord = TotalRecords + 1
    NewRecord = NewRecord'R%7'


    PRINT@(MAINCOL+88,MAINSTARTLINE+2):   NewRecord
    PRINT@(MAINCOL+88,MAINSTARTLINE+3):   CompanyName
*** Billing Address
    PRINT@(MAINCOL+88,MAINSTARTLINE+4):   BillingAddress
    PRINT@(MAINCOL+88,MAINSTARTLINE+5):   BillingLine2
    PRINT@(MAINCOL+88,MAINSTARTLINE+7):   BillingCity
    PRINT@(MAINCOL+123,MAINSTARTLINE+7):  BillingState
    PRINT@(MAINCOL+88,MAINSTARTLINE+8):   BillingZip

*** Shipping Address
    PRINT@(MAINCOL+90,MAINSTARTLINE+13):   ShippingAddress
    PRINT@(MAINCOL+90,MAINSTARTLINE+14):   ShippingLine2
    PRINT@(MAINCOL+90,MAINSTARTLINE+16):   ShippingCity
    PRINT@(MAINCOL+125,MAINSTARTLINE+16):  ShippingState
    PRINT@(MAINCOL+90,MAINSTARTLINE+17):   ShippingZip

    LOOP
        PRINT@(MAINCOL,MAINSTARTLINE+23): "Is the information on the right correct? (y for Yes, n for No)"
        PROMPT@(MAINCOL,MAINSTARTLINE+24):
        INPUT isCustomer
        isCustomer = DOWNCASE(isCustomer)
        IF isCustomer = 'n' THEN
            PRINT@(MAINCOL,MAINSTARTLINE+23): "                                                                 "       ;* Clear correct customer message
            PRINT@(MAINCOL,MAINSTARTLINE+24): "                "      ;* Clear entry for correct customer message
            GOSUB CLEARCUSTOMERINFO
            RETURN
        END

    UNTIL isCustomer = 'y'
    REPEAT

    GOSUB ADDCUSTOMERINFO

    RETURN

******************************
*CLEARCUSTOMERINFO SUBROUTINE
*******************************
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





















