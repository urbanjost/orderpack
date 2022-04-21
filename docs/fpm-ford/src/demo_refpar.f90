     program demo_refpar
     use,intrinsic :: iso_fortran_env, only : int32, real32, real64
     use M_refpar, only : refpar
     implicit none
     real(kind=real32) :: valsr(2000)
     integer           :: indx(2000)
     integer           :: i
     real,allocatable  :: results(:)
        ! create some random data
        call random_seed()
        call random_number(valsr)
        valsr=valsr*1000000.0-500000.0
        ! get 300 lowest values sorted
        call refpar(valsr,indx,300)
        !
        results=valsr(indx(:300))
        ! check if sorted
        do i=1,300-1
           if (results(i+1).lt.results(i))then
              write(*,*)'ERROR: not sorted'
              stop 1
           endif
        enddo
        write(*,*)'random array now sorted'
     end program demo_refpar
