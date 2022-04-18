Module M_inspar
use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64, real32, real64, real128
implicit none
Private
public :: inspar
private :: real64_inspar, real32_inspar, int32_inspar
interface inspar
  module procedure real64_inspar, real32_inspar, int32_inspar
end interface inspar
contains
!>
!!##NAME
!!    inspar(3f) - [orderpack:PARTIAL_SORT] partially sorts an array,
!!                 bringing the N lowest values to the beginning of the array
!!
!!##SYNOPSIS
!!
!!
!!     Subroutine inspar (XDONT, NORD)
!!      ${TYPE} (kind=${KIND}), Dimension (:), Intent (InOut) :: XDONT
!!      Integer, Intent (In) :: NORD
!!
!!    Where ${TYPE}(kind=${KIND}) may be
!!
!!       o Real(kind=real32)
!!       o Real(kind=real64)
!!       o Integer(kind=int32)
!!
!!##DESCRIPTION
!!    INSPAR partially sorts XDONT, bringing the NORD lowest values to the
!!    beginning of the array.
!!
!!    This subroutine uses an insertion sort, limiting insertion to the
!!    first NORD values. It does not use any work array and is faster when
!!    NORD is very small (2-5), but worst case behavior can happen fairly
!!    probably (initially inverse sorted). Therefore, in many cases, the
!!    refined quicksort method is faster.
!!
!!##OPTIONS
!!     XDONT      The array to partially sort
!!     NORD       number of sorted values to return.
!!
!!##EXAMPLES
!!
!!   Sample program:
!!
!!    program demo_inspar
!!    use M_inspar, only : inspar
!!    implicit none
!!    character(len=*),parameter :: g='(*(g0,1x))'
!!    integer,allocatable :: xdont(:)
!!    integer :: nord
!!    xdont=[10,5,7,1,4,5,6,8,9,10,1]
!!    nord=5
!!       write(*,g)'ORIGINAL:',xdont
!!       call inspar(xdont,nord)
!!       write(*,g)'NUMBER OF INDICES TO SORT:',nord
!!       write(*,g)nord,'LOWEST VALUES:',xdont(:nord)
!!       write(*,g)'ENTIRE ARRAY:',xdont
!!    end program demo_inspar
!!
!!   Results:
!!
!!    ORIGINAL: 10 5 7 1 4 5 6 8 9 10 1
!!    NUMBER OF INDICES TO SORT: 5
!!    5 LOWEST VALUES: 1 1 4 5 5
!!    ENTIRE ARRAY: 1 1 4 5 5 10 7 8 9 10 6
!!
!!##AUTHOR
!!     Michel Olagnon - Feb. 2000
!!
!!     John Urban, 2022.04.16
!!     o added man-page and reduced to a template using the
!!       prep(1) preprocessor.
!!
!!##LICENSE
!!    CC0-1.0
Subroutine real64_inspar (XDONT, NORD)
Real (kind=real64), Dimension (:), Intent (InOut) :: XDONT
Integer, Intent (In) :: NORD
! __________________________________________________________
Real (kind=real64) :: XWRK, XWRK1
Integer :: ICRS, IDCR
!
   Do ICRS = 2, NORD
      XWRK = XDONT (ICRS)
      Do IDCR = ICRS - 1, 1, -1
         If (XWRK >= XDONT(IDCR)) Exit
         XDONT (IDCR+1) = XDONT (IDCR)
      End Do
      XDONT (IDCR+1) = XWRK
   End Do
!
   XWRK1 = XDONT (NORD)
   Do ICRS = NORD + 1, SIZE (XDONT)
      If (XDONT(ICRS) < XWRK1) Then
         XWRK = XDONT (ICRS)
         XDONT (ICRS) = XWRK1
         Do IDCR = NORD - 1, 1, -1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
         XWRK1 = XDONT (NORD)
      End If
   End Do
!
End Subroutine real64_inspar
Subroutine real32_inspar (XDONT, NORD)
Real (kind=real32), Dimension (:), Intent (InOut) :: XDONT
Integer, Intent (In) :: NORD
! __________________________________________________________
Real (kind=real32) :: XWRK, XWRK1
Integer :: ICRS, IDCR
!
   Do ICRS = 2, NORD
      XWRK = XDONT (ICRS)
      Do IDCR = ICRS - 1, 1, -1
         If (XWRK >= XDONT(IDCR)) Exit
         XDONT (IDCR+1) = XDONT (IDCR)
      End Do
      XDONT (IDCR+1) = XWRK
   End Do
!
   XWRK1 = XDONT (NORD)
   Do ICRS = NORD + 1, SIZE (XDONT)
      If (XDONT(ICRS) < XWRK1) Then
         XWRK = XDONT (ICRS)
         XDONT (ICRS) = XWRK1
         Do IDCR = NORD - 1, 1, -1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
         XWRK1 = XDONT (NORD)
      End If
   End Do
!
End Subroutine real32_inspar
Subroutine int32_inspar (XDONT, NORD)
Integer (kind=int32), Dimension (:), Intent (InOut) :: XDONT
Integer, Intent (In) :: NORD
! __________________________________________________________
Integer (kind=int32) :: XWRK, XWRK1
Integer :: ICRS, IDCR
!
   Do ICRS = 2, NORD
      XWRK = XDONT (ICRS)
      Do IDCR = ICRS - 1, 1, -1
         If (XWRK >= XDONT(IDCR)) Exit
         XDONT (IDCR+1) = XDONT (IDCR)
      End Do
      XDONT (IDCR+1) = XWRK
   End Do
!
   XWRK1 = XDONT (NORD)
   Do ICRS = NORD + 1, SIZE (XDONT)
      If (XDONT(ICRS) < XWRK1) Then
         XWRK = XDONT (ICRS)
         XDONT (ICRS) = XWRK1
         Do IDCR = NORD - 1, 1, -1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
         XWRK1 = XDONT (NORD)
      End If
   End Do
!
End Subroutine int32_inspar
end module M_inspar