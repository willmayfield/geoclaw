! qinit routine for parabolic bowl problem, only single layer
subroutine qinit(meqn,mbc,mx,my,xlower,ylower,dx,dy,q,maux,aux)

    use geoclaw_module, only: grav

    implicit none

    ! Subroutine arguments
    integer, intent(in) :: meqn,mbc,mx,my,maux
    real(kind=8), intent(in) :: xlower,ylower,dx,dy
    real(kind=8), intent(inout) :: q(meqn,1-mbc:mx+mbc,1-mbc:my+mbc)
    real(kind=8), intent(inout) :: aux(maux,1-mbc:mx+mbc,1-mbc:my+mbc)

    ! Parameters for problem
    real(kind=8), parameter :: sigmax = 0.006d0
    real(kind=8), parameter :: sigmay = 0.008d0
    real(kind=8), parameter :: amp = 1.1d0
    real(kind=8), parameter :: theta = 0.0d0
    real(kind=8), parameter :: posx = -119.24d0
    real(kind=8), parameter :: posy = 34.06d0

   ! Other storage
    integer :: i,j
    real(kind=8) :: x,y,a,b,c
    
    a = cos(theta)**2/(2*sigmax**2) + sin(theta)**2/(2*sigmay**2) 
    b = -sin(2*theta)/(4*sigmax**2) + sin(2*theta)/(4*sigmay**2) 
    c = sin(theta)**2/(2*sigmax**2) + cos(theta)**2/(2*sigmay**2) 

    print *,'NEW BOX: dx = ',dx,' dy = ',dy

    do i=1-mbc,mx+mbc
        x = xlower + (i - 0.5d0)*dx
        do j=1-mbc,my+mbc
            y = ylower + (j - 0.5d0) * dy
            
            q(1,i,j) = max(0.d0, -aux(1,i,j))
            q(2,i,j) = 0.d0
            q(3,i,j) = 0.d0 !q(1,i,j)

 
            if (sqrt((x - posx)**2 + (y-posy)**2) < .02) then
!            if (sqrt((x - posx)**2 + (y-posy)**2) < .005) then

                q(1,i,j) = q(1,i,j) +  amp*exp(-(a*(x-posx)**2 + 2*b*(x-posx)*(y-posy) + c*(y-posy)**2))
!               q(1,i,j) = q(1,i,j) +  1

                print *,'yes yes COORDS: x=',x,'  and y=',y

            end if
        enddo
    enddo


    
end subroutine qinit
