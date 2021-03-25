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
    real(kind=8), parameter :: amp = 6.0d0*1.5      
    real(kind=8), parameter :: theta = -.80d0      
    real(kind=8), parameter :: posx = -119.245d0      
    real(kind=8), parameter :: posy = 34.055d0      
    ! Parameters for problem, down hump          
    real(kind=8), parameter :: sigmax2 = 0.0015d0      
    real(kind=8), parameter :: sigmay2 = 0.003d0      
    real(kind=8), parameter :: amp2 = -12.0d0*0.97222222222*1.5      
    real(kind=8), parameter :: theta2 = -.8d0      
    real(kind=8), parameter :: posx2 = -119.237d0      
    real(kind=8), parameter :: posy2 = 34.0633d0   

    ! Parameters for problem, down hump
    real(kind=8), parameter :: sigmagf = 480.0d0
    real(kind=8), parameter :: ampgf = 2.0d0
    real(kind=8), parameter :: thetagf = 0.0d0
    real(kind=8) :: posxgf
    real(kind=8) :: posygf

    real, dimension(1:200) :: my_centers

   ! Other storage
    CHARACTER(len=4) :: gf_dim_read, gf_i_read
    integer :: i,j, num_gf, gf_dim, gf_i
    real(kind=8) :: x,y,a,b,c,a2,b2,c2, a3,b3,c3, gf_dx, gf_dy, gf_ll_x, gf_ll_y

    num_gf = 0


    my_centers = (/-119.236968, 34.063509, & 
-119.244233, 34.055895, & 
-119.247024, 34.053563, & 
-119.238726, 34.065635, & 
-119.245288, 34.052672, & 
-119.234390, 34.060011, & 
-119.237180, 34.061588, & 
-119.246343, 34.056787, & 
-119.233687, 34.062891, & 
-119.259116, 34.063989, & 
-119.241399, 34.058502, & 
-119.241069, 34.055141, & 
-119.242124, 34.053015, & 
-119.248452, 34.052603, & 
-119.242476, 34.059462, & 
-119.241187, 34.066595, & 
-119.243882, 34.059873, & 
-119.244937, 34.051780, & 
-119.247749, 34.049311, & 
-119.248101, 34.057610, & 
-119.250562, 34.054249, & 
-119.249507, 34.050614, & 
-119.240015, 34.057542, & 
-119.238608, 34.059599, & 
-119.245640, 34.048900, & 
-119.241890, 34.064949, & 
-119.231694, 34.064400, & 
-119.229116, 34.047322, & 
-119.234368, 34.056924, & 
-119.234507, 34.067281, & 
-119.243530, 34.049997, & 
-119.237649, 34.066526, & 
-119.235444, 34.058845, & 
-119.231577, 34.062686, & 
-119.232749, 34.065978, & 
-119.237905, 34.061108, & 
-119.240483, 34.070093, & 
-119.229468, 34.057953, & 
-119.240718, 34.061657, & 
-119.239663, 34.062137, & 
-119.230640, 34.065566, & 
-119.252649, 34.049860, & 
-119.242944, 34.068104, & 
-119.230149, 34.060971, & 
-119.229819, 34.056993, & 
-119.244680, 34.065292, & 
-119.239312, 34.056101, & 
-119.233452, 34.069270, & 
-119.238586, 34.052946, & 
-119.242827, 34.060834, & 
-119.236243, 34.064332, & 
-119.240366, 34.051026, & 
-119.228530, 34.066664, & 
-119.254055, 34.055072, & 
-119.251968, 34.046842, & 
-119.230874, 34.055484, & 
-119.249155, 34.058639, & 
-119.236499, 34.051163, & 
-119.250774, 34.046156, & 
-119.236851, 34.053906, & 
-119.241421, 34.048488, & 
-119.239993, 34.050134, & 
-119.254077, 34.051574, & 
-119.246694, 34.047734, & 
-119.250913, 34.060285, & 
-119.227358, 34.057747, & 
-119.248430, 34.059736, & 
-119.225366, 34.067692, & 
-119.251265, 34.059393, & 
-119.241538, 34.073042, & 
-119.249038, 34.045264, & 
-119.228743, 34.058776, & 
-119.252671, 34.056513, & 
-119.227124, 34.069681, & 
-119.227007, 34.061725, & 
-119.229937, 34.068447, & 
-119.244116, 34.041766, & 
-119.214116, 34.075100, & 
-119.228413, 34.054729, & 
-119.239055, 34.071739, & 
-119.226421, 34.065155, & 
-119.238257, 34.046911, & 
-119.249858, 34.063303, & 
-119.231226, 34.060079, & 
-119.253374, 34.061039, & 
-119.245618, 34.062480, & 
-119.227805, 34.067144, & 
-119.247046, 34.058365, & 
-119.247163, 34.065841, & 
-119.235562, 34.070916, & 
-119.256187, 34.057336, & 
-119.256890, 34.054455, & 
-119.239077, 34.068241, & 
-119.242805, 34.050477, & 
-119.242593, 34.071602, & 
-119.247280, 34.046293, & 
-119.225249, 34.060422, & 
-119.245757, 34.069133, & 
-119.236733, 34.044784, & 
-119.262866, 34.058433/)

    


    !get the gf indices
    CALL GET_ENVIRONMENT_VARIABLE("gf_i",gf_i_read)
    CALL GET_ENVIRONMENT_VARIABLE("gf_dim",gf_dim_read)

    read(gf_i_read, *) gf_i
    read(gf_dim_read, *) gf_dim

    posxgf = my_centers(2*(gf_i-1) + 1)
    posygf = my_centers(2*(gf_i-1) + 2)

    
    a = cos(theta)**2/(2*sigmax**2) + sin(theta)**2/(2*sigmay**2) 
    b = -sin(2*theta)/(4*sigmax**2) + sin(2*theta)/(4*sigmay**2) 
    c = sin(theta)**2/(2*sigmax**2) + cos(theta)**2/(2*sigmay**2)

    a2 = cos(theta2)**2/(2*sigmax2**2) + sin(theta2)**2/(2*sigmay2**2) 
    b2 = -sin(2*theta2)/(4*sigmax2**2) + sin(2*theta2)/(4*sigmay2**2) 
    c2 = sin(theta2)**2/(2*sigmax2**2) + cos(theta2)**2/(2*sigmay2**2)


    do i=1-mbc,mx+mbc
        x = xlower + (i - 0.5d0)*dx
        do j=1-mbc,my+mbc
            y = ylower + (j - 0.5d0) * dy
            
            q(1,i,j) = max(0.d0, -aux(1,i,j))
            q(2,i,j) = 0.d0
            q(3,i,j) = 0.d0 !q(1,i,j)

            !cut off things outside source zone
!            if (abs(x - posx) <= .02 .and.  abs(y - posy) <= .02) then 

                !leave in the ref. solution at full resolution
                q(1,i,j) = q(1,i,j)+amp*exp(-(a*(x-posx)**2+2*b*(x-posx)*(y-posy)+c*(y-posy)**2))
                q(1,i,j) = q(1,i,j)+amp2*exp(-(a2*(x-posx2)**2+2*b2*(x-posx2)*(y-posy2)+c2*(y-posy2)**2))
                

                !center is ( gf_ll_x + (gf_i+.5)*gf_dx , gf_ll_y + (gf_j+.5)*gf_dy )
                !put in the GF
                q(1,i,j) = q(1,i,j)+ampgf*exp(-(sigmagf**2)*((x-posxgf)**2 + (y - posygf)**2))



 !               print *,'yes yes COORDS: x=',x,'  and y=',y
                num_gf = num_gf + 1

!            end if
        enddo
    enddo

print *,'                                           NUM_GF: ',num_gf,' '

    
end subroutine qinit
