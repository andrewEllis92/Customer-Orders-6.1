***created 4/12/2017 Andrea Chesak 

    FUNCTION ValidPhone(Phone)

    EQU TRUE TO 1
    EQU FALSE TO 0
    
    IF Phone MATCHES "'('3N')'3N'-'4N" OR Phone MATCHES "'('3N')'' '3N'-'4N" OR Phone MATCHES "3N'-'3N'-'4N" OR Phone MATCHES "10N" THEN
        ValidInput = TRUE
    END ELSE
        ValidInput = FALSE
    END 
    RETURN(ValidInput)
