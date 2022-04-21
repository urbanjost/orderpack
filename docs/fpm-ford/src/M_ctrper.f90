Module M_ctrper
use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64, real32, real64, real128
Use M_mrgrnk
implicit none
Private
integer,parameter :: f_char=selected_char_kind("DEFAULT")
public :: ctrper
interface ctrper
  module procedure real64_ctrper, real32_ctrper, int32_ctrper, f_char_ctrper
end interface ctrper
contains
!>
!!##NAME
!!    ctrper(3f) - [orderpack:PERMUTATION] generate a random permutation
!!                 of an array leaving elements close to initial locations
!!
!!##SYNOPSIS
!!
!!     Subroutine ctrper (XDONT, PCLS)
!!
!!      ${TYPE} (kind=${KIND}), Intent (InOut) :: XDONT(:)
!!      Real, Intent (In) :: PCLS
!!
!!    Where ${TYPE}(kind=${KIND}) may be
!!
!!       o Real(kind=real32)
!!       o Real(kind=real64)
!!       o Integer(kind=int32)
!!       o Character(kind=selected_char_kind("DEFAULT"),len=*)
!!
!!##DESCRIPTION
!!   Shuffle the array XDONT randomly, leaving elements close to their
!!   initial locations.
!!
!!   Nearbyness is controlled by PCLS. The relative proportion of initial
!!   order and random order is defined as 1-PCLS / PCLS, thus when PCLS = 0,
!!   there is no change in the order whereas the new order is fully random
!!   when PCLS = 1.
!!
!!   Note this differs from adding random noise to the values. The original
!!   values remain unchanged, their order is just perturbed.
!!
!!   Internally, the routine creates a real array of the indices of XDONT()
!!   perturbed by random values that are based on the size of PCLS. The
!!   new array is then ranked and the resulting index is used to permute
!!   the input array.
!!
!!##OPTIONS
!!     XDONT      Array of values to perturb.
!!     PCLS       Proportion of closeness, constrained to the range 0.0(no
!!                change) to 1.0(fully random).
!!
!!##EXAMPLES
!!
!!   Sample program:
!!
!!    program demo_ctrper
!!    ! generate a random perturbation of an array
!!    use M_ctrper, only : ctrper
!!    implicit none
!!    character(len=*),parameter :: g='(*(g0,1x))'
!!    character(len=*),parameter :: list= '(*(g0:,", "))'
!!    integer,allocatable :: xdont(:)
!!    integer,allocatable :: xout(:,:)
!!    integer          :: isz, i, j
!!    isz=200
!!       ! randomly pertube location of values
!!       !
!!       ! make an array with three identical rows
!!       if(allocated(xout))deallocate(xout)
!!       allocate(xout(3,isz))
!!       xdont=[(i,i=isz,1,-1)]*10
!!       xout(1,:)=xdont
!!       xout(2,:)=xdont
!!       xout(3,:)=xdont
!!       ! pertube each row a different amount
!!       call ctrper(xout(1,:),0.0)
!!       call ctrper(xout(2,:),0.1)
!!       call ctrper(xout(3,:),1.0)
!!       ! show values
!!       write(*,'(a)')'count    unchanged  perturbed  random'
!!       do i=1,size(xdont)
!!          write(*,'(*(i8,1x))')i,xout(:,i)
!!       enddo
!!    char: block
!!    character(len=:),allocatable :: cdont(:)
!!       cdont=[character(len=20) :: 'a', 'be', 'car', 'dam','fan','gas','egg']
!!       isz=size(cdont)
!!       write(*,g)'Original.................:',(trim(cdont(i)),i=1,isz)
!!       call ctrper(cdont,1.0)
!!       write(*,g)'Perturbed ...............:',(trim(cdont(i)),i=1,isz)
!!       write(*,g)
!!    endblock char
!!
!!    end program demo_ctrper
!!
!!   Results:
!!
!!    count    unchanged  perturbed  random
!!           1     2000     1980       80
!!           2     1990     1990      580
!!           3     1980     1890     1690
!!           4     1970     1900     1340
!!           5     1960     1920     1260
!!           6     1950     1950     1220
!!           7     1940     1880      160
!!           8     1930     1960     1620
!!           9     1920     1860      540
!!           .        .        .        .
!!           .        .        .        .
!!           .        .        .        .
!!           .        .        .        .
!!         189      120       80     1200
!!         190      110      150      800
!!         191      100      120     1430
!!         192       90      170     1410
!!         193       80      140      370
!!         194       70       90     1720
!!         195       60       10      830
!!         196       50      100     1670
!!         197       40       20      470
!!         198       30       70     1020
!!         199       20       60     1540
!!         200       10       30     1810
!!    Original.................: a be car dam fan gas egg
!!    Perturbed ...............: a be gas dam fan car egg
!!
!!##AUTHOR
!!     Michel Olagnon, 2000-2012
!!
!!     John Urban, 2022.04.16
!!     o added man-page and reduced to a template using the
!!       prep(1) preprocessor.
!!
!!##LICENSE
!!    CC0-1.0
Subroutine real64_ctrper (XDONT, PCLS)
! _________________________________________________________
      Real (kind=real64), Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_Number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*[ (Real(I), I=1,size(XDONT)) ]
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine real64_ctrper
Subroutine real32_ctrper (XDONT, PCLS)
! _________________________________________________________
      Real (kind=real32), Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_Number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*[ (Real(I), I=1,size(XDONT)) ]
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine real32_ctrper
Subroutine int32_ctrper (XDONT, PCLS)
! _________________________________________________________
      Integer (kind=int32), Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_Number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*[ (Real(I), I=1,size(XDONT)) ]
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine int32_ctrper
Subroutine f_char_ctrper (XDONT, PCLS)
! _________________________________________________________
      character (kind=f_char,len=*), Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_Number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*[ (Real(I), I=1,size(XDONT)) ]
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine f_char_ctrper
end module M_ctrper
