***Andrea Chesak
***Order of Orders
***April 3, 2017

    SUBROUTINE ERRORMESSAGES(Type,ValidInput)

**********************Global Variables
    EQU TRUE TO 1
    EQU FALSE TO 0

***Error messages for phone, generic entry, state, zip, and email
    
    CRT@(5,30): STR(' ', 65)  ;* clears previous error messages
    
    BEGIN CASE
    CASE Type = "Phone" AND ValidInput MATCHES FALSE
        CRT@(5,30): "Please enter a valid phone number. Standard formats excepted!"
    CASE Type = "Entry" AND ValidInput MATCHES FALSE
        CRT@(5,30): "Required field!" 
    CASE Type = "State" AND ValidInput MATCHES FALSE
        CRT@(5,30): "Please enter a valid 2 character state abbreviation!"
    CASE Type = "Zip" AND ValidInput MATCHES FALSE
        CRT@(5,30): "Please enter a valid zip code!"
    CASE Type = "Email" AND ValidInput MATCHES FALSE
        CRT@(5,30): "Please enter a valid email address!" 
    END CASE 
    RETURN

