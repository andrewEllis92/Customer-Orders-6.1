    FUNCTION ValidZip(Zip)
    EQU TRUE TO 1
EQU FALSE TO 0
    BEGIN CASE
    CASE Zip MATCHES "5N"
        ValidInput = TRUE
    CASE Zip # "5N"
        ValidInput = FALSE
    END CASE
    RETURN(ValidInput)
