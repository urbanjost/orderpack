Module M_fndnth
use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64, real32, real64, real128
implicit none
Private
integer,parameter :: f_char=selected_char_kind("DEFAULT")
public :: fndnth
interface fndnth
  module procedure real64_fndnth, real32_fndnth, int32_fndnth !, f_char_fndnth
end interface fndnth
contains
!>
!!##NAME
!!    fndnth(3f) - [orderpack:FRACTILE] Return Nth lowest ordered VALUE of array,
!!                 i.e. return fractile of order N/SIZE(array) (InsertSort-like)
!!
!!##SYNOPSIS
!!
!!     Function fndnth (XDONT, NORD) Result (FNDNTH)
!!
!!      ${TYPE} (Kind=${KIND}), Dimension (:), Intent (In) :: XDONT
!!      Integer, Intent (In) :: NORD
!!      ${TYPE} (Kind=${KIND}) :: FNDNTH
!!
!!    Where ${TYPE}(kind=${KIND}) may be
!!
!!    o Real(kind=real32)
!!    o Real(kind=real64)
!!    o Integer(kind=int32)
!!
!!##DESCRIPTION
!!    FNDNTH(3) returns the NORDth lowest value of XDONT(), i.e. the fractile
!!    of order NORD/SIZE(XDONT).
!!
!!    This subroutine uses an insertion sort, limiting insertion to the
!!    first NORD values. An insertion sort is very fast when NORD is very
!!    small (2-5).  Additionally, internally it requires only a work array
!!    of size NORD (and type of XDONT),
!!
!!    But worst case behavior can happen fairly probably (e.g., initially
!!    inverse sorted). Therefore, in many cases, the refined QuickSort
!!    method is faster.
!!
!!    so FNDNTH() should be used when NORD is small and XDONT is likely to
!!    be a random array, otherwise consider using INDNTH(3) or VALNTH(3).
!!
!!##OPTIONS
!!     XDONT     input array of values
!!     NORD      specify Nth value of sorted XDONT array to return, from
!!               1 to size(XDONT).
!!##RETURNS
!!     FNDNTH    returned value
!!
!!##EXAMPLES
!!
!!   Sample program:
!!
!!    program demo_fndnth
!!    ! return Nth ordered value of an array
!!    use M_fndnth, only : fndnth
!!    use M_valmed, only : valmed
!!    implicit none
!!    character(len=*),parameter :: list= '(*(g0:,", "))',sp='(*(g0,1x))'
!!    integer,allocatable :: iarr(:)
!!    integer :: i
!!       iarr=[80,70,30,40,-50,60,20,10]
!!       print sp, 'ORIGINAL:',iarr
!!       ! can return the same values as intrinsics minval() and maxval()
!!       print sp, 'minval',fndnth(iarr,1),          minval(iarr)
!!       print sp, 'maxval',fndnth(iarr,size(iarr)), maxval(iarr)
!!       ! but more generally it can return the Nth lowest value.
!!       print sp, 'median',fndnth(iarr,(size(iarr+1))/2), valmed(iarr)
!!       ! so only Nth ordered value can be found
!!       print sp,'nord=',3, ' fractile=',fndnth(iarr,3)
!!       ! sorting the hard way
!!       print sp, 'ORIGINAL:',iarr
!!       do i=1,size(iarr)
!!          write(*,list)i,fndnth(iarr,i)
!!       enddo
!!       print *
!!    end program demo_fndnth
!!
!!   Results:
!!
!!    ORIGINAL: 80 70 30 40 -50 60 20 10
!!    minval -50 -50
!!    maxval 80 80
!!    median 30 30
!!    nord= 3  fractile= 20
!!    ORIGINAL: 80 70 30 40 -50 60 20 10
!!    1, -50
!!    2, 10
!!    3, 20
!!    4, 30
!!    5, 40
!!    6, 60
!!    7, 70
!!    8, 80
!!
!!##SEE ALSO
!!
!!    indnth(3), valnth(3)
!!
!!##AUTHOR
!!    Michel Olagnon - Aug. 2000
!!
!!    John Urban, 2022.04.16
!!    o added man-page and reduced to a template using the
!!      prep(1) preprocessor.
!!
!!##LICENSE
!!    CC0-1.0
Function real64_fndnth (XDONT, NORD) Result (FNDNTH)
! __________________________________________________________
      Real (Kind=real64), Dimension (:), Intent (In) :: XDONT
      Real (Kind=real64) :: FNDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (Kind=real64), Dimension (NORD) :: XWRKT
      Real (Kind=real64) :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1
!
End Function real64_fndnth
Function real32_fndnth (XDONT, NORD) Result (FNDNTH)
! __________________________________________________________
      Real (Kind=real32), Dimension (:), Intent (In) :: XDONT
      Real (Kind=real32) :: FNDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (Kind=real32), Dimension (NORD) :: XWRKT
      Real (Kind=real32) :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1
!
End Function real32_fndnth
Function int32_fndnth (XDONT, NORD) Result (FNDNTH)
! __________________________________________________________
      Integer (Kind=int32), Dimension (:), Intent (In) :: XDONT
      Integer (Kind=int32) :: FNDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer (Kind=int32), Dimension (NORD) :: XWRKT
      Integer (Kind=int32) :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1
!
End Function int32_fndnth

end module M_fndnth
