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
    real(kind=8), parameter :: posx1 = -119.245d0     
    real(kind=8), parameter :: posy1 = 34.055d0     
    ! Parameters for problem, down hump     
    real(kind=8), parameter :: sigmax2 = 0.0015d0     
    real(kind=8), parameter :: sigmay2 = 0.003d0     
    real(kind=8), parameter :: amp2 = -12.0d0*0.97222222222*1.5     
    real(kind=8), parameter :: theta2 = -.8d0     
    real(kind=8), parameter :: posx2 = -119.237d0     
    real(kind=8), parameter :: posy2 = 34.0633d0   


    !real(kind=8), parameter :: PI_8 = 4*atan(1.0_8)i
    real, dimension(1:1600) :: my_randns

    real(kind=8), parameter :: amp_var = 0.15d0
    real(kind=8), parameter :: theta_var = 0.15d0
    real(kind=8), parameter :: pos_var = 0.0008d0



   ! Other storage
    CHARACTER(len=5) :: gf_dim_read, ensnum_read 
    integer :: i,j,k, num_gf, gf_dim, e_num
    real(kind=8) :: x,y,a,b,c,a2,b2,c2, gf_dx, gf_dy, gf_ll_x, gf_ll_y
    real(kind=8) :: amp_pert1, amp_pert2, theta_pert, posx1_pert, posx2_pert, posy1_pert, posy2_pert
    real(kind=8) :: nrn_1, nrn_2, nrn_3, nrn_4
!    num_gf = 0

 my_randns = (/0.31065, -1.3391, 0.30235, 1.7215, -0.21582, -1.1695, -0.19607, -1.2406,  &
1.1441, -1.2205, 1.2362, -0.13633, -0.27804, 1.2323, -1.904, 0.54965,  &
2.1042, 0.93871, -0.30957, -1.4145, 2.1212, -0.34674, 0.68902, -0.62083,  &
-2.1868, 0.43807, 0.53096, 1.2141, 0.10765, 0.33697, 1.394, -2.9647,  &
-1.6925, -1.0205, -0.20988, 0.46551, -0.41053, 0.527, -1.342, -0.13544,  &
-1.4018, 0.88478, -0.057806, -2.2928, 1.9952, 1.0247, -1.5362, -1.7075,  &
-0.21732, 0.15471, -0.69766, 1.0045, -0.6159, 0.041794, 0.33906, -0.089481,  &
-1.7949, -1.5818, -0.92355, -0.14514, -0.54248, 0.025498, 0.19723, -0.084973,  &
-0.43148, 0.093352, 1.6695, 1.454, -0.48387, -0.54174, -0.19844, 0.49919,  &
0.88082, -0.12882, -0.20398, 0.78296, 0.18622, 1.2947, -3.2017, -0.76646,  &
1.4381, 0.67227, 0.42941, -1.0521, 0.90952, -1.1535, 0.15339, -0.93066,  &
-0.39166, 0.43952, -0.52406, 0.51875, -0.17962, 1.5392, 0.42554, 0.79568,  &
-0.32071, 0.021273, -1.6026, -1.3182, 1.5302, -0.3736, 1.6271, 0.78428,  &
0.40256, 0.37605, -0.86298, 1.2863, 0.82865, 0.062081, -0.037656, -0.05665,  &
-0.086772, 1.167, -0.35805, -2.1693, 0.89339, -0.13667, 1.5135, 0.24919,  &
0.096472, -2.0981, -0.21595, -0.12639, 0.42936, 1.0553, -0.35358, -0.25225,  &
1.735, 0.42089, -1.9478, -0.22845, 0.16027, 0.30712, 2.0464, 0.84486,  &
0.82715, -0.7176, 0.037246, 0.291, -1.0913, -0.25522, -0.52399, -1.0172,  &
1.5169, -1.695, -0.69323, -0.62084, 2.1503, -1.598, -0.11387, -0.40676,  &
0.71305, 0.37731, 0.52646, 0.7066, 0.87956, -0.81862, -1.3326, 1.4472,  &
-0.53735, -1.3109, -0.05809, -0.49555, 0.38189, 1.141, -0.063236, -1.5323,  &
-0.22492, 0.98394, -1.0266, -1.8227, 0.47312, -1.1706, -0.40796, -1.0095,  &
-0.67067, -0.55357, 0.84995, -0.76776, -1.244, -1.0832, -0.48509, -0.69195,  &
0.96778, 0.31045, -0.37843, 2.1341, -0.2931, 0.84751, -0.49804, -0.45449,  &
2.7816, -0.41861, 1.4097, 2.7403, -0.81158, 0.84708, 1.8424, 1.6226,  &
0.48127, 0.57372, 0.78852, 1.2221, -1.853, 1.7229, -0.51199, -0.95581,  &
1.5969, -1.134, 1.355, -2.2942, -2.1936, -1.5869, 0.36356, -0.47615,  &
-0.18001, 1.8517, -0.65936, -1.0292, -0.033197, -0.095244, -0.1391, -0.67523,  &
-1.9959, 1.2363, 1.8925, -0.45999, -0.16432, -1.4771, 0.64045, -0.66272,  &
-2.038, -1.0373, -0.63377, 0.61323, -0.34178, 0.59355, -0.99005, -0.92423,  &
1.3714, -2.4405, -0.89273, 1.0595, 0.42012, -0.22038, 1.6264, -0.58159,  &
0.071402, 0.28568, 0.78124, 0.64444, -0.31759, 0.036986, -0.47724, 2.1683,  &
-0.16075, -0.94977, 1.5836, 1.0476, 0.24261, -2.0672, 1.3375, 0.55559,  &
0.52565, -0.48335, 1.6685, -3.0351, -0.57532, -0.58671, 1.225, -1.5422,  &
0.47699, 0.23023, -0.55135, -1.5446, -0.95706, 0.46555, -3.1331, -0.6249,  &
-0.10447, 0.046478, -1.6922, 0.07478, -0.6505, -0.77387, 0.60972, -0.55525,  &
0.47921, 1.3312, 0.85499, 1.529, -0.27216, -0.2587, -0.21996, 0.019434,  &
0.60013, -0.64217, -0.47993, 0.36728, 0.07861, 0.92536, -0.19766, 0.79068,  &
0.65884, -2.1644, 1.1893, -0.14048, -0.77685, 1.9535, -0.70732, -0.77049,  &
0.37909, -0.91298, -0.25484, -0.21572, 1.0702, -0.48115, 1.0866, -1.1591,  &
0.65846, 0.79797, -1.5693, 1.2191, -0.22608, 0.18, 0.48921, -0.17739,  &
-0.30883, -1.7522, -1.3786, -2.5721, -1.2095, -0.0045321, 1.094, -1.3468,  &
0.03118, -0.86907, 0.40316, -0.94942, -1.2126, -1.5031, -0.41441, 1.0341,  &
1.4774, -1.4469, 0.39543, 0.11681, -0.82012, 1.957, 2.9467, -0.70548,  &
0.88963, -0.75193, -0.31525, 2.0689, -0.082902, -0.18288, -0.42282, 1.6521,  &
1.1149, 1.8297, 0.57096, -1.1732, -0.51729, -0.070431, -0.48679, -0.98066,  &
-1.3179, -0.91427, 0.082008, -0.32713, 0.86299, -1.065, -0.11976, -0.31083,  &
2.0736, -0.61115, -0.38557, 0.20844, 0.54362, 0.20785, -1.2228, -1.2769,  &
-2.1173, -0.16642, 0.96731, 0.057431, 0.19435, 1.6983, -0.74519, -0.54257,  &
-1.4149, -0.10487, -1.0571, -0.59982, 0.044413, -1.0623, -2.3578, 2.102,  &
0.066775, -0.71069, 0.35971, 0.62642, 1.2655, 0.46496, -0.19075, 0.11643,  &
-1.3391, 0.41687, 0.81075, 1.539, -0.29957, 0.66721, -0.67813, 0.26639,  &
1.1841, 0.025673, 0.48963, 1.0264, -0.58331, -0.10509, -2.5764, -0.0016054,  &
-0.69879, 0.37566, -0.76496, 0.25028, 1.3454, -0.74561, 0.37562, 0.57189,  &
2.0666, -0.84403, -0.93508, 1.3168, 0.48758, -2.4235, -0.67441, 0.0095472,  &
0.3243, 0.16343, -0.27096, -0.6357, -0.29196, 0.025031, -1.5708, 1.3525,  &
0.28549, 0.91509, 0.27308, 0.62008, -0.88792, 1.4885, -0.29475, 2.0882,  &
-0.2483, -2.0678, 0.66433, 0.67561, -1.8456, -0.56463, 0.6213, 0.85118,  &
0.002608, -1.6045, 1.6293, 0.083247, 1.0084, 0.39949, -1.4214, 0.73485,  &
1.4525, -1.5745, -0.52502, -0.93237, 0.26102, -0.62447, -1.3279, 0.52365,  &
0.46361, 0.8348, -1.4872, -0.65605, 0.6639, -0.29464, 1.3081, 1.9573,  &
0.17995, -0.33166, -0.82501, -0.16828, 0.73632, 0.27552, -0.81812, -0.18868,  &
1.2708, 0.75738, 0.076144, 1.189, -0.63857, -1.339, 0.54797, 0.013869,  &
0.57079, -0.26339, 0.19699, 0.18844, -0.57282, 0.97373, -1.6739, 0.87381,  &
-2.908, -0.9088, -1.5817, -0.053921, 0.4965, -0.37016, -0.55579, 0.70771,  &
-1.0806, -0.16745, 0.93077, 0.99274, 0.65362, 0.5883, -1.587, -0.30002,  &
0.66695, -0.0041691, -0.16514, 0.74818, -1.6942, -0.712, 1.2572, -0.22835,  &
-0.0052569, -0.82546, 0.30918, 0.71181, -1.5402, 0.74714, 2.2344, 1.2688,  &
-0.97854, -1.4018, 0.70768, 0.77965, 0.031787, 0.15676, 1.2009, -0.67524,  &
-0.80432, -1.4331, 0.20106, -0.37668, 0.32598, 0.11701, 0.10742, 0.78222,  &
0.21754, -0.89877, 0.58447, 1.3651, 0.81799, 0.0059188, 1.8751, -1.7646,  &
-1.1013, 0.43047, 0.70209, -0.63084, 0.66349, 1.1035, 0.28694, 0.92112,  &
-0.37685, 0.29934, 0.4337, -0.76298, -1.1481, 0.33408, -0.37443, -0.97593,  &
0.67221, -0.28248, 0.82984, 0.24378, 0.37853, -0.33347, 2.0618, 0.74329,  &
-0.63329, -1.6364, -1.2035, -0.21058, -2.1951, 1.2806, -0.19655, 1.519,  &
0.022392, 0.64581, 0.28647, 0.12174, -0.83944, -1.5848, -1.0054, -0.59667,  &
-0.46143, -2.017, 1.013, -0.30824, 1.2268, 1.6875, 1.8746, 1.8411,  &
-0.39712, -0.63246, 0.22437, -0.66207, -2.0627, -0.50978, -0.15248, 0.9294,  &
-1.3903, 0.94497, -0.63738, -0.67155, 0.17032, 0.39253, -0.57754, -0.19206,  &
-1.7752, -0.2477, -0.4407, -1.1998, -0.054814, -0.50845, -1.0569, -0.47589,  &
0.58196, 0.79388, 0.29556, -0.90681, 1.1217, -0.31434, 0.95855, 0.34043,  &
-0.61749, -0.34709, -2.5517, -0.76761, -0.75916, -1.1411, 0.064282, -0.37022,  &
-1.5587, 1.2666, -1.0381, -0.18576, 0.84886, -0.16833, 0.18107, 2.0064,  &
-0.99358, 0.68642, -0.024057, -1.3495, 0.7317, -0.15372, -0.80255, 0.10759,  &
0.20244, 0.53843, 0.28049, 0.29021, -0.32084, 1.4573, 1.5717, 1.4392,  &
1.1979, -0.16389, 0.63133, -0.98144, -0.20656, 0.073757, -0.34287, -0.97321,  &
0.30255, -0.20764, 0.35579, -0.48762, -0.18267, -0.73521, -0.60149, 2.7524,  &
-0.39535, 0.39553, -0.7683, -0.37624, -0.90408, 0.19757, 0.49117, 0.36552,  &
0.31877, 0.53204, 1.8743, -0.0033121, 0.89616, -0.43216, 0.45826, 0.64661,  &
1.0336, 0.49691, 1.886, 0.18998, 0.13082, -0.19557, 1.7365, -0.43557,  &
-0.53436, -0.020905, -0.45974, 0.47142, 0.45518, -0.0075339, 0.33124, -1.1841,  &
0.58576, 0.80549, -0.45869, -0.046566, -0.28414, -0.30049, -0.71909, 1.3862,  &
-0.34159, -0.91833, -0.3465, -0.61129, 1.2816, 0.69447, -1.8996, 2.0208,  &
-0.56603, -1.4176, -1.0904, -0.63967, 2.1306, -1.2044, 0.96687, 1.5068,  &
-0.14571, 0.59122, 0.14869, -0.51983, -1.7134, -0.57027, -0.078438, -1.6896,  &
-0.092403, -1.5444, -0.89254, -1.3875, 0.45937, 0.72634, 0.39987, -0.88717,  &
-1.3403, -2.4538, 0.34441, 1.8917, 0.27361, 1.114, 0.75091, 0.66517,  &
-1.131, -0.81403, 1.0988, -1.0199, -1.5304, 0.24599, 0.66806, 0.52529,  &
-0.3663, 0.5281, -0.17889, 1.0666, -1.2504, -0.9639, -0.67261, -0.58036,  &
0.40067, 0.32872, -0.83498, 0.4315, -0.20743, 0.8505, 0.61192, -0.028475,  &
0.31696, 0.3342, -0.010718, -0.55684, -0.57704, 0.10187, -1.028, 0.23348,  &
-0.62756, -0.57956, -1.1746, -1.7649, -0.47431, 0.75866, -0.79624, 0.69808,  &
-1.2023, -1.5352, 0.13647, 2.0522, -0.33967, -0.0019654, -0.1566, 0.12502,  &
0.20622, -0.13001, -2.1438, 1.488, -1.3979, 1.0921, -0.50777, -0.45684,  &
0.36299, 1.2553, 1.1151, -0.14063, 1.4537, 0.9453, -0.068345, -0.050127,  &
1.3062, 0.53863, -1.1952, -0.91492, -0.17632, 0.58126, -1.854, -0.90258,  &
-0.6414, 1.7681, 0.013797, 0.32986, 0.58954, 0.33535, 0.41584, -0.17959,  &
-0.043375, 0.041731, 0.036598, 0.32053, 0.77266, 0.15441, -1.3798, 1.1923,  &
1.6291, 0.9859, -0.34154, 1.3623, 1.2336, 0.36825, 0.43015, 1.5789,  &
1.9761, -1.5309, -0.17254, -1.0399, -0.65948, 0.53382, 0.83117, -0.098308,  &
0.67234, 0.20448, -0.50322, -2.0964, 0.13833, 0.30867, -1.9745, 0.78484,  &
1.1498, -1.023, 1.8576, 1.7731, -0.26067, 2.157, 0.29631, -0.32521,  &
-0.04007, 0.23191, 0.76143, 1.4348, 0.3472, -0.057204, 0.9919, 2.1354,  &
-0.99049, 2.3118, 0.76733, -0.5781, 1.4587, -0.11551, -0.44704, 0.048799,  &
2.931, 0.67619, -0.040374, -0.98227, -0.91961, -0.72124, -0.31159, 0.51511,  &
0.87334, 2.1937, 0.6005, -1.0837, 0.84787, 0.018844, 0.10256, 0.66908,  &
0.40073, -0.11027, 0.10271, -0.82551, 0.10467, 0.44554, -1.5961, 0.47305,  &
1.1088, 2.4569, 1.0082, 0.81972, -0.077754, 0.41451, 0.69138, 0.30701,  &
1.944, 0.043795, -1.1235, 0.38653, -0.64132, 0.11857, 0.42559, -0.29567,  &
1.1197, 0.57333, 0.8063, 1.2772, 1.5996, 0.11501, -0.89617, 0.27657,  &
1.5321, 0.30595, -0.28665, -0.29043, -0.73614, 1.7197, 0.96416, 0.17462,  &
0.53961, -1.8243, 1.1276, -0.43277, 1.8264, -0.71603, -0.25411, 1.3197,  &
-1.8704, -0.68804, 0.14436, 0.93163, -0.48515, -0.74109, -0.19451, 0.88479,  &
-1.1827, -0.62538, 1.1141, -1.2756, -1.0101, 2.1439, -0.52916, 0.3966,  &
1.536, 1.4121, -2.3596, -1.0816, -1.4545, 0.99556, -0.38997, -0.28211,  &
-1.3184, -0.27481, -0.40999, -0.14493, 0.74935, -1.3906, 1.8457, -0.13784,  &
1.0028, 0.87859, -0.58106, 0.89932, 2.0468, 1.4223, -0.87044, 0.86213,  &
0.51507, 1.3199, -0.1025, 0.62963, -0.0093385, 0.65316, -0.013003, 0.21677,  &
1.057, 1.7616, -0.016311, 0.98285, -0.71237, -0.65265, -0.66956, -1.8848,  &
-1.7904, 1.3647, -1.0712, 0.44942, -0.3874, 0.84336, 1.6197, 0.64879,  &
0.32231, -0.070337, -1.4396, -0.66278, -0.2034, 0.058658, -0.39295, 1.1272,  &
-0.25347, 1.0793, 1.3026, 1.9697, -0.11764, -0.32944, 0.75996, 0.070414,  &
0.32828, 0.49387, -1.275, 1.2388, -0.44572, 0.57022, -3.0328, -0.3783,  &
1.6232, -0.68401, 1.2904, 0.18125, -1.0088, -0.40588, 1.2661, 0.19128,  &
-0.33303, -0.41576, -0.8229, 1.3307, -1.4734, 0.84503, 1.6085, -0.020044,  &
-0.12474, 0.30864, 0.25203, 1.3082, -0.33255, 0.43067, 0.75646, 0.32796,  &
0.77964, -1.032, 0.58305, 2.7285, -0.38336, 1.2293, -1.2623, -0.7627,  &
-0.060299, 2.2832, -0.36743, 0.25065, -1.6793, -0.063959, -0.43822, -1.6945,  &
-0.65268, -0.52403, -2.0003, -0.5444, 2.0543, -0.40233, -0.35786, 1.3203,  &
2.25, 0.84219, 1.0602, -0.97457, 1.0568, 0.45982, -1.4935, -0.42962,  &
0.48166, -1.8612, -1.0824, -0.39218, 0.80484, 1.3729, 0.86127, -0.76747,  &
1.3006, -1.3167, 0.88398, 0.65405, 0.25089, -0.9741, -1.0995, -0.16166,  &
1.1597, -2.5247, 0.43577, -1.648, -0.96765, 0.93137, -0.33226, 0.87574,  &
-0.52171, -1.0169, 1.8537, 2.9685, 0.99245, 0.17444, -0.91939, 0.75542,  &
-0.82746, 1.2969, 0.32514, -1.6249, 0.27189, 0.23811, 0.10209, -0.383,  &
-0.3332, -0.59794, 0.58703, 0.53193, 1.522, -0.41482, -2.1535, 1.1395,  &
-2.2972, 1.1771, 1.323, -0.4768, 0.25807, -0.19006, 0.085463, -1.0973,  &
0.65357, 0.44892, 0.90188, -1.2544, -1.4264, 0.56042, -0.13407, 1.234,  &
0.57205, -2.1861, -0.83021, -0.4345, -0.59048, 1.8035, 0.98497, -0.054166,  &
0.086746, 0.69754, 0.57272, -0.073903, 0.70344, -0.54727, -0.067895, -1.5263,  &
-3.0188, 0.41843, -2.328, -2.3777, -0.097176, 0.084564, 0.83356, 0.24987,  &
0.015163, -1.0157, 2.1856, 0.3379, -0.28438, 1.4579, 0.017288, -1.4915,  &
-0.1526, 0.16913, -1.0914, 1.6728, -0.8498, 1.6858, 0.14839, 1.0677,  &
-0.079805, -0.25818, -0.96317, 1.0293, 0.56909, 0.76875, -0.16111, -0.0043226,  &
-0.60358, -0.31497, -0.066714, 1.4775, 0.33682, 0.51126, -0.18255, -0.68554,  &
-0.80362, 1.1394, -0.44295, -0.26438, -2.3337, 1.1513, 0.4991, 0.56372,  &
0.50834, -1.2071, -0.31568, -0.77837, -0.37428, -1.5967, -0.50283, 0.5784,  &
0.67211, 0.19493, 0.15837, -0.73073, 0.13731, 0.27228, -0.59153, 0.51769,  &
-0.45376, 1.0273, 0.85563, 0.52102, 0.32617, -0.11406, 0.71864, -0.072335,  &
-0.19818, -0.98534, 2.2759, -1.3505, 0.61371, -0.13996, -0.93562, 1.1958,  &
0.038065, 1.1019, -1.1874, -0.37861, -0.13682, -0.14107, -1.5244, 0.91266,  &
1.3616, 0.23277, -0.21623, 1.3174, -0.99686, 1.0584, -0.44511, -1.5397,  &
1.4516, -0.92948, -0.52086, 1.0506, 1.1698, 0.38909, 0.20564, -0.62436,  &
-0.86275, 0.00040704, 0.45397, -1.0416, -0.67697, 0.54293, 0.40781, 0.53029,  &
-0.53312, 0.38105, -1.0904, -2.0184, 0.23097, -0.19173, 1.0592, 0.17059,  &
-0.79013, 1.6842, 0.17324, 0.79356, 0.52349, -0.61974, -0.98117, -1.8812,  &
2.1949, -0.50638, 0.49026, -0.1349, 0.12634, -1.3982, 1.2756, -0.30792,  &
1.5109, 0.11399, -0.45461, 1.1169, 0.64914, 0.64752, -0.30555, 0.74596,  &
0.36205, 1.2018, 0.25346, 0.83172, 0.78616, -0.97549, -1.5572, 0.46528,  &
0.6341, -0.33226, -0.69937, 0.2994, 0.65588, -1.1635, -0.45769, -0.085678,  &
-0.67827, 1.57, 1.031, 1.1982, 0.061751, 1.5003, -0.015871, 3.118,  &
-1.0003, -1.9195, 1.8575, 0.1201, -1.4989, 1.7499, -0.37952, -0.59843,  &
0.43569, 0.37882, 0.19482, -0.13363, 1.1819, 1.3498, -0.52686, 1.8679,  &
-0.38442, -0.85687, -1.0127, -0.15828, 0.1036, 0.22494, -0.58425, -0.22241,  &
0.60165, 2.4736, -1.0159, -1.6808, -0.10543, 0.10042, 0.44137, 0.6023,  &
0.98174, 0.28991, 0.70543, 0.52871, 0.37529, 0.32967, 0.53515, -0.84035,  &
-1.481, 0.86463, 1.4203, 1.0057, -1.6078, 2.1012, 1.4777, -0.20167,  &
1.8356, -0.29179, 1.1952, -0.0031215, 0.79993, -0.48469, -1.2592, -2.7455,  &
0.50854, -0.96766, 0.76779, 1.2273, 0.50827, 0.45315, 0.36953, 0.94835,  &
0.37296, -1.4267, -1.1105, -0.070556, 1.546, 1.1726, 0.065887, 1.1073,  &
2.1471, 0.71624, -1.6031, -1.3433, -1.0188, -1.0548, 0.60327, 2.5123,  &
0.17269, 1.8439, -0.056204, 1.085, -0.094899, 0.21969, -0.017883, 1.4039,  &
0.42997, -1.7329, -0.4475, 0.43264, 0.014466, 0.12885, 0.14223, 0.60238,  &
-0.34451, -0.54308, 0.4114, -0.21709, -0.13856, -2.261, 0.56472, 1.437,  &
0.67556, 0.90649, 0.041446, 0.63099, -0.34025, -0.48784, -1.0596, -1.0294,  &
1.0121, 1.3598, 0.72117, -0.109, 0.41893, 0.27184, 2.6474, 0.62546,  &
-0.51447, 0.33384, -0.17434, 1.4013, 0.80708, 1.1118, 0.013642, -0.16538,  &
-0.9124, 0.29718, 0.85942, 1.1586, -0.71361, -1.5739, -1.5164, -2.2952,  &
0.45043, -0.61626, -1.3797, 0.24365, -0.35334, -1.7834, -0.014489, 1.3549,  &
-1.9488, -0.27517, -0.1941, 0.88308, -0.75189, -1.0224, -1.2194, -0.20431,  &
1.1509, 0.49516, -2.2736, 1.0541, 1.5048, -0.2203, -0.65663, -1.2783,  &
-0.67859, -0.76746, -1.9477, -0.40746, 0.26378, -0.40389, -1.0037, -2.3099,  &
-0.93238, -0.21731, -2.456, 0.63585, -1.096, 1.6196, -0.049071, 0.21633,  &
-1.4305, 2.1228, 1.4338, -1.2068, -0.64739, -1.273, 1.3752, 1.2463,  &
0.40958, 0.68798, -1.3401, -0.60902, -0.54199, -0.010784, 1.7047, -1.1996,  &
-0.27111, -1.5683, 0.2931, -0.86465, -0.083195, -0.68829, -0.34237, -1.4416,  &
1.06, -0.50096, -1.3191, 0.038014, -0.19554, -0.54043, 0.9966, -2.6385,  &
1.4214, -0.16931, -0.55282, -0.44206, 0.42654, -0.087042, -0.81358, 1.5015,  &
2.6077, 0.28462, 0.79463, 1.7228, 0.20552, 0.35303, 1.3939, 0.3864,  &
0.87384, -0.48727, -1.1323, 1.5729, 0.31182, -0.30171, -0.29687, -0.79581/)

    !get the gf indices
    CALL GET_ENVIRONMENT_VARIABLE("ens_num",ensnum_read)
    CALL GET_ENVIRONMENT_VARIABLE("gf_dim",gf_dim_read)

    read(ensnum_read, *) e_num
    read(gf_dim_read, *) gf_dim

    print*,'ENNNNNNNNSEMBLE BUMBER ',e_num


    nrn_1 = my_randns(4*e_num + 1)
    nrn_2 = my_randns(4*e_num + 2)
    nrn_3 = my_randns(4*e_num + 3)
    nrn_4 = my_randns(4*e_num + 4)
    

    print*,'NORMAL: ',nrn_1,'NORMAL2: ',nrn_2


    amp_pert1 = amp*(1 + nrn_1*amp_var)
    amp_pert2 = amp2*(1 + nrn_1*amp_var)
    theta_pert = theta*(1 + nrn_2*theta_var)
    posx1_pert = posx1 + nrn_3*pos_var
    posy1_pert = posy1 + nrn_4*pos_var
    posx2_pert = posx2 + nrn_3*pos_var
    posy2_pert = posy2 + nrn_4*pos_var
    

    
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
!            if (abs(x - posx) <= .02 .and.  abs(y - posy) <= .02) then 

                !leave in the ref. solution at full resolution
                q(1,i,j) = q(1,i,j)+amp_pert1*exp(-(a*(x-posx1_pert)**2+2*b*(x-posx1_pert)*(y-posy1_pert)+c*(y-posy1_pert)**2))
                q(1,i,j) = q(1,i,j)+amp_pert2*exp(-(a2*(x-posx2_pert)**2+2*b2*(x-posx2_pert)*(y-posy2_pert)+c2*(y-posy2_pert)**2))





 !           end if
        enddo
    enddo

print *,'                                           e_num: ',e_num,' '


    
end subroutine qinit
