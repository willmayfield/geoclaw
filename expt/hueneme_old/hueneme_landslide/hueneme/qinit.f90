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
    !real(kind=8), parameter :: PI_8 = 4*atan(1.0_8)i
    real, dimension(1:200) :: my_randns

    real(kind=8), parameter :: amp_var = 1.0d0
    real(kind=8), parameter :: theta_var = 0.2d0

   ! Other storage
    CHARACTER(len=5) :: gf_dim_read, ensnum_read 
    integer :: i,j,k, num_gf, gf_dim, e_num
    real(kind=8) :: x,y,a,b,c,a2,b2,c2, gf_dx, gf_dy, gf_ll_x, gf_ll_y
    real(kind=8) :: amp_pert1, amp_pert2, theta_pert
    real(kind=8) :: urn_1, urn_2, nrn_1, nrn_2
!    num_gf = 0

 my_randns = (/-0.24817,1.1934,-1.5636,-1.7452,-0.024095,-1.3482,-0.28721,-0.75127,0.43173, &
-0.43124,0.12185,0.42057,0.40485,0.48373,-0.29333,-2.4695,0.25221,-0.92917,0.53185,-1.3263, &
1.024,-0.90126,-0.65582,0.39817,2.3453,-0.94529,1.7895,0.49044,-0.89294,0.76421,0.22182, &
-0.46994,-0.43711,-2.0514,-0.16079,0.53075,0.26452,-0.33194,1.0651,-0.3964,0.61585,-1.1578, &
-0.19304,0.2863,0.72122,0.03869,0.34314,1.2561,1.2442,-0.56312,0.23462,1.5473,0.16698, &
0.031501,1.4188,0.89204,-0.65707,0.003798,-1.1241,-0.2487,0.89867,-1.2881,1.0216,-0.38425, &
-0.69743,-0.73442,-2.1297,-0.094252,-1.152,-1.6792,-0.0049894,-0.5875,-0.39927,0.12421, &
0.16438,-0.35009,-0.28529,-0.39783,-0.25638,-0.93547,-1.3075,-1.1253,0.52786,0.0054423, &
0.89986,1.18,-0.7637,-1.0567,-1.8606,-0.21111,0.6913,1.4982,0.076073,-0.46479,0.22029, &
-0.82179,0.090596,-0.080848,-1.2385,-0.33643,0.46254,1.4247,0.55028,1.9425,-0.69362, &
0.18509,-0.16687,0.14752,-1.0763,-0.10341,-0.31536,-0.37326,-0.36425,-0.25827,0.0088412, &
1.2959,-0.37907,-0.0053355,-1.6469,0.18607,0.080752,-0.647,0.3702,-0.28667,-0.27147, &
-1.1293,0.8773,-0.92228,0.1078,0.11893,0.71844,0.73908,-1.3553,1.2905,0.57342,-0.94955, &
-0.98969,-0.40949,-0.53584,0.9655,1.0186,0.2113,1.0264,0.10982,1.3266,1.2186,-1.2688, &
0.83629,0.36797,-0.21976,0.84089,-0.45009,-0.56585,0.56647,-0.10594,0.095586,1.1473, &
-0.49555,0.24171,0.76768,-1.1653,0.10289,-0.16963,0.45727,0.26206,0.029127,-0.82139, &
0.92337,1.4929,0.49234,0.84527,0.048235,-0.39443,0.18061,-1.5527,1.6593,0.93052,-1.8328, &
-1.3128,0.57538,-0.16099,-0.030443,-1.6021,0.1255,0.18054,0.63511,-1.4727,1.0203,-1.0616, &
0.060541,1.5133,1.3295,0.38821,1.0619,-1.1526,0.82407,0.91364,-1.0292,0.13901,2.8584/)

    !get the gf indices
    CALL GET_ENVIRONMENT_VARIABLE("ens_num",ensnum_read)
    CALL GET_ENVIRONMENT_VARIABLE("gf_dim",gf_dim_read)

    read(ensnum_read, *) e_num
    read(gf_dim_read, *) gf_dim

    !the width of the gf source zone is .04
!    gf_dx = .04/gf_dim
!    gf_dy = .04/gf_dim

    !lower left of source zone
!    gf_ll_x = posx - .02
!    gf_ll_y = posy - .02


    print*,'ENNNNNNNNSEMBLE BUMBER ',e_num

!    do k=1,100
!        urn_1 = rand()
!    enddo
    
    !call srand(e_num+54)
!    urn_1 = rand()
    !call srand(e_num+5454)
!    urn_2 = rand()
!    nrn_1 = sqrt(-2*log(urn_1))*cos(2*PI_8*urn_2)
!    nrn_2 = sqrt(-2*log(urn_1))*sin(2*PI_8*urn_2)

    nrn_1 = my_randns(2*e_num + 1)
    nrn_2 = my_randns(2*e_num + 2)
    

    print*,'NORMAL: ',nrn_1,'NORMAL2: ',nrn_2


    amp_pert1 = amp + nrn_1*amp_var
    amp_pert2 = amp2 - nrn_1*amp_var
    theta_pert = theta + nrn_2*theta_var
    

    
    a = cos(theta_pert)**2/(2*sigmax**2) + sin(theta_pert)**2/(2*sigmay**2) 
    b = -sin(2*theta_pert)/(4*sigmax**2) + sin(2*theta_pert)/(4*sigmay**2) 
    c = sin(theta_pert)**2/(2*sigmax**2) + cos(theta_pert)**2/(2*sigmay**2)

    a2 = cos(theta_pert)**2/(2*sigmax2**2) + sin(theta_pert)**2/(2*sigmay2**2) 
    b2 = -sin(2*theta_pert)/(4*sigmax2**2) + sin(2*theta_pert)/(4*sigmay2**2) 
    c2 = sin(theta_pert)**2/(2*sigmax2**2) + cos(theta_pert)**2/(2*sigmay2**2) 

!    print '(A,F10.5,A,F10.5)','NEW BOX: dx = ',dx,' dy = ',dy

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
                q(1,i,j) = q(1,i,j)+amp_pert1*exp(-(a*(x-posx)**2+2*b*(x-posx)*(y-posy)+c*(y-posy)**2))
                q(1,i,j) = q(1,i,j)+amp_pert2*exp(-(a2*(x-posx2)**2+2*b2*(x-posx2)*(y-posy2)+c2*(y-posy2)**2))





                !in the box?
 !               if (x >= gf_ll_x + gf_i*gf_dx .and. &
 !                   & x < gf_ll_x + (gf_i+1)*gf_dx .and. &
 !                   & y >= gf_ll_y + gf_j*gf_dy .and. &
 !                   & y < gf_ll_y + (gf_j + 1)*gf_dy) then


                !the impulse
 !               q(1,i,j) = q(1,i,j) +  2

 !               end if




 !               print *,'yes yes COORDS: x=',x,'  and y=',y
 !               num_gf = num_gf + 1

            end if
        enddo
    enddo

print *,'                                           e_num: ',e_num,' '


    
end subroutine qinit
