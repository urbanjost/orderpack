     program demo_refsor
     use,intrinsic :: iso_fortran_env, only : int32, real32, real64
     use M_refsor, only : refsor
     implicit none
     ! an insertion sort is very efficient for very small arrays
     ! but generally slower than methods like quicksort and mergesort.
     real(kind=real64) :: valsd(2000)
     integer           :: i
        call random_seed()
        call random_number(valsd)
        valsd=valsd*1000000.0-500000.0
        call refsor(valsd)
        do i=1,size(valsd)-1
           if (valsd(i+1).lt.valsd(i))then
              write(*,*)'not sorted'
              stop 3
           endif
        enddo
        write(*,*)'random arrays are now sorted'
     end program demo_refsor
