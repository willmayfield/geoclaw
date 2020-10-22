import netCDF4
import pandas as pd

topo_nc_file = './crm_vol6.nc'
nc = netCDF4.Dataset(topo_nc_file, mode='r')

nc.variables.keys()

lat = nc.variables['lat'][:]
lon = nc.variables['lon'][:]
elev = nc.variables['z'][:]

# a pandas.Series designed for time series of a 2D lat,lon grid
elev_data = pd.Series(elev) 

elev_data.to_csv('elev.csv',index=True, header=True)
