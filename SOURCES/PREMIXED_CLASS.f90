MODULE PREMIXED_CLASS
USE NRTYPE
    INTERFACE COMP_PROGRESS 
      MODULE PROCEDURE COMP_PROGRESS
    END INTERFACE COMP_PROGRESS 
    CONTAINS
      SUBROUTINE COMP_PROGRESS(TEMPER,PROG_VAR,SAVEVAR,SPEC,SPECUB,SPECB)
        USE NRTYPE
        USE IO_CLASS
        REAL(DP) :: TEMP_MIN,TEMP_MAX
        REAL(DP),DIMENSION(:,:,:),INTENT(INOUT) :: PROG_VAR
        REAL(DP),DIMENSION(:,:,:),INTENT(IN) :: TEMPER
        REAL(DP),DIMENSION(:,:,:),INTENT(IN),OPTIONAL :: SPEC
        LOGICAL,INTENT(IN),OPTIONAL :: SAVEVAR
        REAL(DP),INTENT(IN),OPTIONAL :: SPECUB
        REAL(DP),INTENT(IN),OPTIONAL :: SPECB

        IF (PRESENT(SPEC))THEN
          ! for the moment this is only valid for CO2
          PROG_VAR(:,:,:) = (SPEC(:,:,:) - SPECUB)/(SPECB - SPECUB)
        ELSE
          TEMP_MIN = MINVAL(TEMPER)
          TEMP_MAX = MAXVAL(TEMPER)
          PROG_VAR(:,:,:) = (TEMPER(:,:,:)-TEMP_MIN)/(TEMP_MAX-TEMP_MIN)
        ENDIF
        IF (SAVEVAR.AND. PRESENT(SPEC)) THEN
          CALL WRITE_PROG('./OUTPUT/PROG_VAR_SPEC',PROG_VAR)
          CALL WRITE_PROG('./OUTPUT/SPEC',SPEC)
        ELSE
          CALL WRITE_PROG('./OUTPUT/PROG_VAR',PROG_VAR)
          CALL WRITE_PROG('./OUTPUT/TEMPER',TEMPER)
        ENDIF
      END SUBROUTINE COMP_PROGRESS
      !
END MODULE PREMIXED_CLASS
