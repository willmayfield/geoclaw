! qinit routine for parabolic bowl problem, only single layer
subroutine qinit(meqn,mbc,mx,my,xlower,ylower,dx,dy,q,maux,aux)

    use geoclaw_module, only: grav

    implicit none

    ! Subroutine arguments
    integer, intent(in) :: meqn,mbc,mx,my,maux
    real(kind=8), intent(in) :: xlower,ylower,dx,dy
    real(kind=8), intent(inout) :: q(meqn,1-mbc:mx+mbc,1-mbc:my+mbc)
    real(kind=8), intent(inout) :: aux(maux,1-mbc:mx+mbc,1-mbc:my+mbc)

    ! Parameters for problem, up hump
    real(kind=8), parameter :: sigmax = 0.0035d0
    real(kind=8), parameter :: sigmay = 0.0025d0
    real(kind=8), parameter :: amp = 6.0d0
    real(kind=8), parameter :: theta = -.80d0
    real(kind=8), parameter :: posx = -119.245d0
    real(kind=8), parameter :: posy = 34.055d0
    ! Parameters for problem, down hump
    real(kind=8), parameter :: sigmax2 = 0.0015d0
    real(kind=8), parameter :: sigmay2 = 0.003d0
    real(kind=8), parameter :: amp2 = -12.0d0
    real(kind=8), parameter :: theta2 = -.8d0
    real(kind=8), parameter :: posx2 = -119.237d0
    real(kind=8), parameter :: posy2 = 34.0633d0

   ! Other storage
    CHARACTER(len=4) :: gf_dim_read, gf_i_read, gf_j_read
    integer :: i,j, num_gf, gf_dim, gf_i, gf_j
    real(kind=8) :: x,y,a,b,c,a2,b2,c2, gf_dx, gf_dy, gf_ll_x, gf_ll_y

    num_gf = 0

    !get the gf indices
    CALL GET_ENVIRONMENT_VARIABLE("gf_i",gf_i_read)
    CALL GET_ENVIRONMENT_VARIABLE("gf_j",gf_j_read)
    CALL GET_ENVIRONMENT_VARIABLE("gf_dim",gf_dim_read)

    read(gf_i_read, *) gf_i
    read(gf_j_read, *) gf_j
    read(gf_dim_read, *) gf_dim

    !the width of the gf source zone is .04
    gf_dx = .04/gf_dim
    gf_dy = .04/gf_dim

    !lower left of source zone
    gf_ll_x = posx - .02
    gf_ll_y = posy - .02

    
    a = cos(theta)**2/(2*sigmax**2) + sin(theta)**2/(2*sigmay**2) 
    b = -sin(2*theta)/(4*sigmax**2) + sin(2*theta)/(4*sigmay**2) 
    c = sin(theta)**2/(2*sigmax**2) + cos(theta)**2/(2*sigmay**2)

    a2 = cos(theta2)**2/(2*sigmax2**2) + sin(theta2)**2/(2*sigmay2**2) 
    b2 = -sin(2*theta2)/(4*sigmax2**2) + sin(2*theta2)/(4*sigmay2**2) 
    c2 = sin(theta2)**2/(2*sigmax2**2) + cos(theta2)**2/(2*sigmay2**2) 

    print '(A,F10.5,A,F10.5)','NEW BOX: dx = ',dx,' dy = ',dy

    do i=1-mbc,mx+mbc
        x = xlower + (i - 0.5d0)*dx
        do j=1-mbc,my+mbc
            y = ylower + (j - 0.5d0) * dy
            
            q(1,i,j) = max(0.d0, -aux(1,i,j))
            q(2,i,j) = 0.d0
            q(3,i,j) = 0.d0 !q(1,i,j)

            !cut off things outside source zone
            if (abs(x - posx) <= .02 .and.  abs(y - posy) <= .02) then 

                !leave in the ref. solution at full resolution
                q(1,i,j) = q(1,i,j)+amp*exp(-(a*(x-posx)**2+2*b*(x-posx)*(y-posy)+c*(y-posy)**2))
                q(1,i,j) = q(1,i,j)+amp2*exp(-(a2*(x-posx2)**2+2*b2*(x-posx2)*(y-posy2)+c2*(y-posy2)**2))





                !in the box?
                if (x >= gf_ll_x + gf_i*gf_dx .and. &
                    & x < gf_ll_x + (gf_i+1)*gf_dx .and. &
                    & y >= gf_ll_y + gf_j*gf_dy .and. &
                    & y < gf_ll_y + (gf_j + 1)*gf_dy) then


                !the impulse
                q(1,i,j) = q(1,i,j) +  2

                end if




 !               print *,'yes yes COORDS: x=',x,'  and y=',y
                num_gf = num_gf + 1

            end if
        enddo
    enddo

print *,'                                           NUM_GF: ',num_gf,' '

    
end subroutine qinit
