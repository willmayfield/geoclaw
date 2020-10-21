"""
Create topo and dtopo files needed for this example:
    etopo10min120W60W60S0S.asc        download from GeoClaw topo repository
    dtopo_usgs100227.tt3              create using Okada model 
Prior to Clawpack 5.2.1, the fault parameters we specified in a .cfg file,
but now they are explicit below.
    
Call functions with makeplots==True to create plots of topo, slip, and dtopo.
"""

from __future__ import absolute_import
from __future__ import print_function
import os
from clawpack.geoclaw.topotools import Topography
import clawpack.clawutil.data
from numpy import *

try:
    CLAW = os.environ['CLAW']
except:
    raise Exception("*** Must first set CLAW enviornment variable")

# Scratch directory for storing topo and dtopo files:
scratch_dir = os.path.join(CLAW, 'geoclaw', 'scratch')

def get_topo(makeplots=False):
    """
    Retrieve the topo file from the GeoClaw repository.
    """
    from clawpack.geoclaw import topotools
    topo_fname = 'etopo10min120W60W60S0S.asc'
    url = 'http://www.geoclaw.org/topo/etopo/' + topo_fname
#    topo_fname='etopo1_bedrock.asc'
#    url = '/home/will/Downloads/' + topo_fname
    clawpack.clawutil.data.get_remote_file(url, output_dir=scratch_dir, 
            file_name=topo_fname, verbose=True)

    if makeplots:
        from matplotlib import pyplot as plt
        topo = topotools.Topography(os.path.join(scratch_dir,topo_fname), topo_type=2)
        topo.plot()
        fname = os.path.splitext(topo_fname)[0] + '.png'
        plt.savefig(fname)
        print("Created ",fname)


    
def make_dtopo(makeplots=False):
    """
    Create dtopo data file for deformation of sea floor due to earthquake.
    Uses the Okada model with fault parameters and mesh specified below.
    """
    from clawpack.geoclaw import dtopotools
    import numpy

    dtopo_fname = os.path.join(scratch_dir, "dtopo_usgs100227.tt3")
    #dtopo_fname = os.path.join(scratch_dir, "dtopo_gulf.tt3")

    # Specify subfault parameters for this simple fault model consisting
    # of a single subfault:

    usgs_subfault = dtopotools.SubFault()
    usgs_subfault.strike = 16.
    usgs_subfault.length = 450.e3
    usgs_subfault.width = 100.e3
    usgs_subfault.depth = 35.e3
    usgs_subfault.slip = 15.
    usgs_subfault.rake = 104.
    usgs_subfault.dip = 14.
    usgs_subfault.longitude = -72.668
    usgs_subfault.latitude = -35.826
    usgs_subfault.coordinate_specification = "top center"

    fault = dtopotools.Fault()
    fault.subfaults = [usgs_subfault]

    print("Mw = ",fault.Mw())

    if os.path.exists(dtopo_fname):
        print("*** Not regenerating dtopo file (already exists): %s" \
                    % dtopo_fname)
    else:
        print("Using Okada model to create dtopo file")

        x = numpy.linspace(-77, -67, 100)
        y = numpy.linspace(-40, -30, 100)
        times = [1.]

        fault.create_dtopography(x,y,times)
        dtopo = fault.dtopo
        dtopo.write(dtopo_fname, dtopo_type=3)


    if makeplots:
        from matplotlib import pyplot as plt
        if fault.dtopo is None:
            # read in the pre-existing file:
            print("Reading in dtopo file...")
            dtopo = dtopotools.DTopography()
            dtopo.read(dtopo_fname, dtopo_type=3)
            x = dtopo.x
            y = dtopo.y
        plt.figure(figsize=(12,7))
        ax1 = plt.subplot(121)
        ax2 = plt.subplot(122)
        fault.plot_subfaults(axes=ax1,slip_color=True)
        ax1.set_xlim(x.min(),x.max())
        ax1.set_ylim(y.min(),y.max())
        dtopo.plot_dZ_colors(1.,axes=ax2)
        fname = os.path.splitext(os.path.split(dtopo_fname)[-1])[0] + '.png'
        plt.savefig(fname)
        print("Created ",fname)

def makeqinit():
    """
    Create qinit data file
    """
    nxpoints = 100
    nypoints = 100
    xlower = -119.05
    xupper = -119.30
    yupper = 34.18
    ylower = 34.02
    outfile= "hump.xyz"     

    topography = Topography(topo_func=qinit)
    topography.x = linspace(xlower,xupper,nxpoints)
    topography.y = linspace(ylower,yupper,nypoints)
    topography.write(outfile, topo_type=1)

def qinit(x,y):
    """
    Gaussian hump:
    """
    from numpy import where

    z = 0.0*x

#perturbed ref solutions!
#    ze3 = -((float(b)*x+10e0)**2 + (float(c)*y+10e0)**2)/10.
#   z3 = where(ze3>-10., float(a)*60.e0*exp(ze3), 0.)


#the ref solution hump!
#    ze3 = -((x+10e0)**2 + (y+10e0)**2)/10.
#    z3 = where(ze3>-10., 60.e0*exp(ze3), 0.)
#    z = z3

########### This one to create GFs #########
#for on top of nonlinear wave
    for j in range(40,60):
        for k in range(40,60):
            z[j,k] = 20. + z[j,k]

#for linear:
#    z[int(a),int(b)] = 1
############################################

    print (z.shape)
    return z


if __name__=='__main__':
#    get_topo(False)
#    make_dtopo(False)
    makeqinit()
