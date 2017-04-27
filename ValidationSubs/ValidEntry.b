***Create 4/12/2017 by Andrea Chesak


    FUNCTION ValidEntry(Entry)
    EQU TRUE TO 1
EQU FALSE TO 0
    BEGIN CASE
    CASE Entry MATCHES ''
        ValidInput = FALSE
    CASE Entry # ''
        ValidInput = TRUE
    END CASE
    RETURN(ValidInput)
