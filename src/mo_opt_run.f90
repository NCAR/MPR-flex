module mo_opt_run

  use nrtype,    only: i4b, i8b, dp
  use public_var

  IMPLICIT NONE

  PRIVATE

  PUBLIC :: opt_run    ! run model optimized parameter 

CONTAINS
  ! ------------------------------------------------------------------
  !     NAME
  !>        \opt_run

  !     PURPOSE
  !>        \run optimized run using restart file

  !     INTENT(IN)
  !>        \param[in] "real(dp) :: obj_func(p)"             Function on which to search the minimum
  !>        \param[in] "real(dp) :: pval(:)"                 inital value of decision variables
  !>        \logical,            :: restart                  logical to read state file and initialize, .false. -> start from begining

  !     INTENT(INOUT)
  !         None

  !     INTENT(OUT)
  !         None

  !     INTENT(INOUT), OPTIONAL
  !         None

  !     RETURN
  !>        None 

  !     RESTRICTIONS
  !         None.

  subroutine opt_run(obj_func, restartFile)
    use globalData, only:nBetaGammaCal ! meta for beta parameter listed in 'calPar' input
    implicit none
    ! input
    INTERFACE
       function obj_func(pp)
         use nrtype, only: dp
         implicit none
         real(dp), dimension(:), intent(in) :: pp
         real(dp)                           :: obj_func
       end function obj_func
    END INTERFACE
    character(len=strLen),      intent(in)  :: restartFile ! name of restart file including iteration, the most recent parameter values 
    ! Local variables
    real(dp),   dimension(:), allocatable   :: pval        ! inital value of decision (parameter) variables
    integer(i8b)                            :: i           ! loop index 
    integer(i8b)                            :: iDummy      ! dummy interger: fist line of restart file starting index of objective function evaluation 
    real(dp)                                :: rDummy      ! dummy real: intermediate results for objective function values logical                                 
    logical(lgc)                            :: isExistFile ! logical to check if the file exist or not
    
    allocate ( pval(nBetaGammaCal) )
    ! restart option
    print*, 'read restart file'
    inquire(file=trim(adjustl(restartFile)), exist=isExistFile)
    if ( isExistFile ) then !  if state file exists, update iStart and pval, otherwise iteration start with very beginning
      open(unit=70,file=trim(adjustl(restartFile)), action='read', status = 'unknown')
      read(70,*) iDummy
      read(70,*) (pval(i),i=1,nBetaGammaCal)    
      close(70)
    else
      stop 'no restart file:do optimization first'
    endif
    rDummy =  obj_func(pval)
    return
  end subroutine

end module mo_opt_run
