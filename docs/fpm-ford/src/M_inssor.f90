Module M_inssor
use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64, real32, real64, real128
implicit none
Private
integer,parameter :: f_char=selected_char_kind("DEFAULT")
public :: inssor
interface inssor
  module procedure real64_inssor, real32_inssor, int32_inssor, f_char_inssor
end interface inssor
contains
!>
!!##NAME
!!    inssor(3f) - [orderpack:SORT] Sorts array into ascending order
!!                 (Insertion sort, generally for small or nearly sorted
!!                 arrays)
!!
!!##SYNOPSIS
!!
!!     Subroutine inssor (XDONT)
!!
!!             ${TYPE} (kind=${KIND}), Intent (InOut) :: XDONT(:)
!!
!!    Where ${TYPE}(kind=${KIND}) may be
!!
!!       o Real(kind=real32)
!!       o Real(kind=real64)
!!       o Integer(kind=int32)
!!       o Character(kind=selected_char_kind("DEFAULT"),len=*)
!!
!!##DESCRIPTION
!!    Sorts XDONT into ascending order (Insertion sort)
!!
!!    This subroutine uses an insertion sort. It does not use any work array
!!    and is faster when XDONT is of very small size (< 20), or already
!!    almost sorted, but worst case behavior can happen fairly probably
!!    (initially inverse sorted). In many cases, the quicksort or merge
!!    sort method is faster.
!!
!!##OPTIONS
!!     XDONT      array to sort
!!
!!##EXAMPLES
!!
!!   Sample program:
!!
!!    program demo_inssor
!!    ! sort an array using insertion sort
!!    use,intrinsic :: iso_fortran_env, only : int32, real32, real64
!!    use M_inssor, only : inssor
!!    implicit none
!!    ! an insertion sort is very efficient for very small arrays
!!    ! but generally slower than methods like quicksort and mergesort.
!!    real(kind=real32) :: valsr(2000)
!!    real(kind=real64) :: valsd(2000)
!!    integer           :: valsi(2000)
!!    integer           :: i
!!       call random_seed()
!!       call random_number(valsr)
!!       call random_number(valsd)
!!       valsi=int(valsr*1000000.0)
!!       valsr=valsr*1000000.0-500000.0
!!       valsd=valsd*1000000.0-500000.0
!!       call inssor(valsi)
!!       do i=1,size(valsi)-1
!!          if (valsi(i+1).lt.valsi(i))then
!!             write(*,*)'not sorted'
!!             stop 1
!!          endif
!!       enddo
!!       call inssor(valsr)
!!       do i=1,size(valsr)-1
!!          if (valsr(i+1).lt.valsr(i))then
!!             write(*,*)'not sorted'
!!             stop 2
!!          endif
!!       enddo
!!       call inssor(valsd)
!!       do i=1,size(valsd)-1
!!          if (valsd(i+1).lt.valsd(i))then
!!             write(*,*)'not sorted'
!!             stop 3
!!          endif
!!       enddo
!!       write(*,*)'random arrays are now sorted'
!!    end program demo_inssor
!!
!!   Results:
!!
!!     random arrays are now sorted
!!
!!##AUTHOR
!!     Michel Olagnon - Apr. 2000
!!
!!     John Urban, 2022.04.16
!!     o added man-page and reduced to a template using the
!!       prep(1) preprocessor.
!!
!!##LICENSE
!!    CC0-1.0
Subroutine real64_inssor (XDONT)
! __________________________________________________________
      Real (kind=real64), Dimension (:), Intent (InOut) :: XDONT
      Real (Kind=real64) :: XWRK, XMIN
! __________________________________________________________
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine real64_inssor
Subroutine real32_inssor (XDONT)
! __________________________________________________________
      Real (kind=real32), Dimension (:), Intent (InOut) :: XDONT
      Real (Kind=real32) :: XWRK, XMIN
! __________________________________________________________
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine real32_inssor
Subroutine int32_inssor (XDONT)
! __________________________________________________________
      Integer (kind=int32), Dimension (:), Intent (InOut) :: XDONT
      Integer (Kind=int32) :: XWRK, XMIN
! __________________________________________________________
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine int32_inssor
Subroutine f_char_inssor (XDONT)
! __________________________________________________________
      character (kind=f_char,len=*), Dimension (:), Intent (InOut) :: XDONT
      character (Kind=f_char,len=len(XDONT)) :: XWRK, XMIN
! __________________________________________________________
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine f_char_inssor
end module M_inssor
