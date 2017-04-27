*********************************************************
***Prompts EDITPREVIOUSORDER menu
*************************************************************

    SUBROUTINE EDITPREVIOUSORDERMENUPROMPT

    COMMON MAINSECTIONWIDTH, DISPLAYSECTIONWIDTH, MAINSTARTLINE, MAINHEADER, MAINCOL

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
    CASE MenuChoice = "ID"
***SUBROUTINE NEEDED
    CASE MenuChoice = "EX"
        CRT@(-1)
        STOP
    END CASE
    RETURN

