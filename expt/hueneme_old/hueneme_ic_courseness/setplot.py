
""" 
Set up the plot figures, axes, and items to be done for each frame.

This module is imported by the plotting routines and then the
function setplot is called to set the plot parameters.
    
""" 

from __future__ import absolute_import
from __future__ import print_function
import numpy as np
import matplotlib.pyplot as plt

from clawpack.geoclaw import topotools
from six.moves import range

try:
    TG32412 = np.loadtxt('32412_notide.txt')
except:
    print("*** Could not load DART data file")

#--------------------------
def setplot(plotdata=None):
#--------------------------
    
    """ 
    Specify what is to be plotted at each frame.
    Input:  plotdata, an instance of pyclaw.plotters.data.ClawPlotData.
    Output: a modified version of plotdata.
    
    """ 


    from clawpack.visclaw import colormaps, geoplot
    from numpy import linspace

    if plotdata is None:
        from clawpack.visclaw.data import ClawPlotData
        plotdata = ClawPlotData()


    plotdata.clearfigures()  # clear any old figures,axes,items data


    # To plot gauge locations on pcolor or contour plot, use this as
    # an afteraxis function:

    def addgauges(current_data):
        from clawpack.visclaw import gaugetools
        gaugetools.plot_gauge_locations(current_data.plotdata, \
             gaugenos='all', format_string='ko', add_labels=True)

    def speed_or_depth(current_data):
        drytol_default = 1.e-3
        drytol = getattr(current_data.user, 'drytol', drytol_default)
        q = current_data.q
        h = q[0,:,:]
        eta = q[3,:,:]
        speed = np.sqrt(q[1,:,:]**2 + q[2,:,:]**2)
        topo = eta - h
    
        # With this version, the land was plotted as white in png files for KML.
        # surface = ma.masked_where(h <= drytol, eta)
        # depth = ma.masked_where(h <= drytol, h)
        # surface_or_depth = where(topo<0, surface, depth)

        # With this version, the land is transparent.
        speed_or_depth = np.ma.masked_where(h <= drytol,
                                             np.where(topo<0, speed, h))

        try:
           # Use mask covering coarse regions if it's set:
           m = current_data.mask_coarse
           speed_or_depth = np.ma.masked_where(m, speed_or_depth)
        except:
            pass

        return speed_or_depth




    #-----------------------------------------
    # Figure for surface
    #-----------------------------------------
    plotfigure = plotdata.new_plotfigure(name='Surface', figno=0)

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes('pcolor')
    plotaxes.title = 'Surface'
    plotaxes.scaled = True

    def fixup(current_data):
        import pylab
        addgauges(current_data)
        t = current_data.t
        t = t / 3600.  # hours
        pylab.title('Surface at %4.2f hours' % t, fontsize=12)
        pylab.xticks(fontsize=8)
        pylab.yticks(fontsize=8)
    plotaxes.afteraxes = fixup

    # Water
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    #plotitem.plot_var = geoplot.surface
    plotitem.plot_var = geoplot.surface_or_depth
    plotitem.pcolor_cmap = geoplot.tsunami_colormap
    plotitem.pcolor_cmin = -0.5
    plotitem.pcolor_cmax = 0.5
    plotitem.add_colorbar = True
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1

    # Land
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    plotitem.plot_var = geoplot.land
    plotitem.pcolor_cmap = geoplot.land_colors
    plotitem.pcolor_cmin = 0.0
    plotitem.pcolor_cmax = 50.0
    plotitem.add_colorbar = False
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1
    #plotaxes.xlimits = [-120,-60]
    #plotaxes.ylimits = [-60,0]
    plotaxes.xlimits = [-119.3,-119.05]
    plotaxes.ylimits = [34.02,34.18]   

    # add contour lines of bathy if desired:
    plotitem = plotaxes.new_plotitem(plot_type='2d_contour')
    plotitem.show = True
    plotitem.plot_var = geoplot.topo
    plotitem.contour_levels = linspace(-600,100,8)
    plotitem.amr_contour_colors = ['k']  # color on each level
    plotitem.kwargs = {'linestyles':'solid','linewidths':1}
    plotitem.amr_contour_show = [1,0,0]  
    plotitem.celledges_show = 0
    plotitem.patchedges_show = 0

    #-----------------------------------------
    # Figure for surface in port
    #-----------------------------------------
    plotfigure = plotdata.new_plotfigure(name='Port', figno=1)

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes('pcolor')
    plotaxes.title = 'Surface in Port'
    plotaxes.scaled = True

    def fixup(current_data):
        import pylab
        addgauges(current_data)
        t = current_data.t
        t = t / 3600.  # hours
        pylab.title('Surface in port at %4.2f hours' % t, fontsize=12)
        pylab.xticks(fontsize=8)
        pylab.yticks(fontsize=8)
    plotaxes.afteraxes = fixup

    # Water
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    #plotitem.plot_var = geoplot.surface
    plotitem.plot_var = geoplot.surface_or_depth
    plotitem.pcolor_cmap = geoplot.tsunami_colormap
    plotitem.pcolor_cmin = -0.5
    plotitem.pcolor_cmax = 0.5
    plotitem.add_colorbar = True
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1

    # Land
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    plotitem.plot_var = geoplot.land
    plotitem.pcolor_cmap = geoplot.land_colors
    plotitem.pcolor_cmin = 0.0
    plotitem.pcolor_cmax = 20.0
    plotitem.add_colorbar = False
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1
    #plotaxes.xlimits = [-120,-60]
    #plotaxes.ylimits = [-60,0]
    plotaxes.xlimits = [-119.23,-119.18]
    plotaxes.ylimits = [34.13,34.16]   

    # add contour lines of bathy if desired:
    plotitem = plotaxes.new_plotitem(plot_type='2d_contour')
    plotitem.show = True
    plotitem.plot_var = geoplot.topo
    plotitem.contour_levels = linspace(-200,100,10)
    plotitem.amr_contour_colors = ['k']  # color on each level
    plotitem.kwargs = {'linestyles':'solid','linewidths':1}
    plotitem.amr_contour_show = [1,0,0]  
    plotitem.celledges_show = 0
    plotitem.patchedges_show = 0

    #-----------------------------------------
    # Figure for speed
    #-----------------------------------------
    plotfigure = plotdata.new_plotfigure(name='Speed', figno=10)

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes('pcolor')
    plotaxes.title = 'Speed'
    plotaxes.scaled = True

    def fixup(current_data):
        import pylab
        addgauges(current_data)
        t = current_data.t
        t = t / 3600.  # hours
        pylab.title('Surface at %4.2f hours' % t, fontsize=12)
        pylab.xticks(fontsize=8)
        pylab.yticks(fontsize=8)
    plotaxes.afteraxes = fixup



    # Water
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    #plotitem.plot_var = geoplot.surface
    plotitem.plot_var = speed_or_depth
    plotitem.pcolor_cmap = geoplot.tsunami_colormap
    plotitem.pcolor_cmin = -0.9
    plotitem.pcolor_cmax = 0.9
    plotitem.add_colorbar = True
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1

    # Land
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    plotitem.plot_var = geoplot.land
    plotitem.pcolor_cmap = geoplot.land_colors
    plotitem.pcolor_cmin = 0.0
    plotitem.pcolor_cmax = 50.0
    plotitem.add_colorbar = False
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1
    #plotaxes.xlimits = [-120,-60]
    #plotaxes.ylimits = [-60,0]
    plotaxes.xlimits = [-119.3,-119.05]
    plotaxes.ylimits = [34.02,34.18]   

    # add contour lines of bathy if desired:
    plotitem = plotaxes.new_plotitem(plot_type='2d_contour')
    plotitem.show = True
    plotitem.plot_var = geoplot.topo
    plotitem.contour_levels = linspace(-600,100,8)
    plotitem.amr_contour_colors = ['k']  # color on each level
    plotitem.kwargs = {'linestyles':'solid','linewidths':1}
    plotitem.amr_contour_show = [1,0,0]  
    plotitem.celledges_show = 0
    plotitem.patchedges_show = 0


#        if gaugeno == 32412:
#            try:
#                plot(TG32412[:,0], TG32412[:,1], 'r')
#                legend(['GeoClaw','Obs'],loc='lower right')
#            except: pass
#            axis((0,t.max(),-0.3,0.3))

#        plot(t, 0*t, 'k')
#        n = int(floor(t.max()/300.) + 2)
#        xticks([300*i for i in range(n)], ['%i' % i for i in range(n)])
#        xlabel('time (hours)')

    #-----------------------------------------
    # Figure for speed in port
    #-----------------------------------------
    plotfigure = plotdata.new_plotfigure(name='Speed in Port', figno=11)

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes('pcolor')
    plotaxes.title = 'Speed in Port'
    plotaxes.scaled = True

    def fixup(current_data):
        import pylab
        addgauges(current_data)
        t = current_data.t
        t = t / 3600.  # hours
        pylab.title('Surface in port at %4.2f hours' % t, fontsize=12)
        pylab.xticks(fontsize=8)
        pylab.yticks(fontsize=8)
    plotaxes.afteraxes = fixup

    # Water
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    #plotitem.plot_var = geoplot.surface
    plotitem.plot_var = speed_or_depth
    plotitem.pcolor_cmap = geoplot.tsunami_colormap
    plotitem.pcolor_cmin = -0.9
    plotitem.pcolor_cmax = 0.9
    plotitem.add_colorbar = True
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1

    # Land
    plotitem = plotaxes.new_plotitem(plot_type='2d_pcolor')
    plotitem.plot_var = geoplot.land
    plotitem.pcolor_cmap = geoplot.land_colors
    plotitem.pcolor_cmin = 0.0
    plotitem.pcolor_cmax = 20.0
    plotitem.add_colorbar = False
    plotitem.amr_celledges_show = [0,0,0]
    plotitem.patchedges_show = 1
    #plotaxes.xlimits = [-120,-60]
    #plotaxes.ylimits = [-60,0]
    plotaxes.xlimits = [-119.23,-119.18]
    plotaxes.ylimits = [34.13,34.16]   

    # add contour lines of bathy if desired:
    plotitem = plotaxes.new_plotitem(plot_type='2d_contour')
    plotitem.show = True
    plotitem.plot_var = geoplot.topo
    plotitem.contour_levels = linspace(-200,100,10)
    plotitem.amr_contour_colors = ['k']  # color on each level
    plotitem.kwargs = {'linestyles':'solid','linewidths':1}
    plotitem.amr_contour_show = [1,0,0]  
    plotitem.celledges_show = 0
    plotitem.patchedges_show = 0

    def add_arrows(current_data):
        from pylab import plot, legend, xticks, floor, axis, xlabel
        t = current_data.t
        x = current_data.x
        y = current_data.y 
        q = current_data.q
        speed = np.sqrt(q[1,:,:]**2 + q[2,:,:]**2)
        quiv = plt.quiver(x[:],y[:],q[1,:,:],q[2,:,:],pivot='mid',units = 'width', width = .003, scale = 35,minlength = 0)
    plotaxes.afteraxes = add_arrows

    #-----------------------------------------
    # Figures for gauges
    #-----------------------------------------
    plotfigure = plotdata.new_plotfigure(name='Surface at gauges', figno=300, \
                    type='each_gauge')
    plotfigure.clf_each_gauge = True

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes()
    plotaxes.xlimits = 'auto'
    plotaxes.ylimits = 'auto'
    plotaxes.title = 'Surface'

    # Plot surface as blue curve:
    plotitem = plotaxes.new_plotitem(plot_type='1d_plot')
    plotitem.plot_var = 3
    plotitem.plotstyle = 'b-'

    # Plot topo as green curve:
    plotitem = plotaxes.new_plotitem(plot_type='1d_plot')
    plotitem.show = False

    def gaugetopo(current_data):
        q = current_data.q
        h = q[0,:]
        eta = q[3,:]
        topo = eta - h
        return topo
        
    plotitem.plot_var = gaugetopo
    plotitem.plotstyle = 'g-'

    def add_zeroline(current_data):
        from pylab import plot, legend, xticks, floor, axis, xlabel
        t = current_data.t 
        gaugeno = current_data.gaugeno

        if gaugeno == 32412:
            try:
                plot(TG32412[:,0], TG32412[:,1], 'r')
                legend(['GeoClaw','Obs'],loc='lower right')
            except: pass
            axis((0,t.max(),-0.3,0.3))

        plot(t, 0*t, 'k')
        n = int(floor(t.max()/300.) + 2)
        xticks([300*i for i in range(n)], ['%i' % i for i in range(n)])
        xlabel('time (hours)')

    plotaxes.afteraxes = add_zeroline


    #-----------------------------------------
    # Figures for speed gauges
    #---------------------------
    plotfigure = plotdata.new_plotfigure(name='Speed at gauges', figno=400, \
                    type='each_gauge')
    plotfigure.clf_each_gauge = True

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes()
    plotaxes.xlimits = 'auto'
    plotaxes.ylimits = 'auto'
    plotaxes.title = 'Speed'

    # Plot surface as blue curve:
    plotitem = plotaxes.new_plotitem(plot_type='1d_plot')

    def speedgauge(current_data):
        q = current_data.q
        speedgauge = np.sqrt(q[1,:]**2 + q[2,:]**2)
        
        return speedgauge

    plotitem.plot_var = speedgauge
    plotitem.plotstyle = 'r-'


    # Plot topo as green curve:
    plotitem = plotaxes.new_plotitem(plot_type='1d_plot')
    plotitem.show = False

    def gaugetopo(current_data):
        q = current_data.q
        h = q[0,:]
        eta = q[3,:]
        topo = eta - h
        return topo
        
    plotitem.plot_var = gaugetopo
    plotitem.plotstyle = 'g-'

    def add_zeroline(current_data):
        from pylab import plot, legend, xticks, floor, axis, xlabel
        t = current_data.t 
        gaugeno = current_data.gaugeno

        if gaugeno == 32412:
            try:
                plot(TG32412[:,0], TG32412[:,1], 'r')
                legend(['GeoClaw','Obs'],loc='lower right')
            except: pass
            axis((0,t.max(),-0.3,0.3))

        plot(t, 0*t, 'k')
        n = int(floor(t.max()/300.) + 2)
        xticks([300*i for i in range(n)], ['%i' % i for i in range(n)])
        xlabel('time (hours)')

    plotaxes.afteraxes = add_zeroline

    #-----------------------------------------
    
    # Parameters used only when creating html and/or latex hardcopy
    # e.g., via pyclaw.plotters.frametools.printframes:

    plotdata.printfigs = True                # print figures
    plotdata.print_format = 'png'            # file format
    plotdata.print_framenos = 'all'          # list of frames to print
    plotdata.print_gaugenos = 'all'          # list of gauges to print
    plotdata.print_fignos = 'all'            # list of figures to print
    plotdata.html = True                     # create html files of plots?
    plotdata.html_homelink = '../README.html'   # pointer for top of index
    plotdata.latex = False                    # create latex file of plots?
    plotdata.latex_figsperline = 2           # layout of plots
    plotdata.latex_framesperline = 1         # layout of plots
    plotdata.latex_makepdf = False           # also run pdflatex?
    plotdata.parallel = True                 # make multiple frame png's at once

    return plotdata

