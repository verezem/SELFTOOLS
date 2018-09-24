# -*- coding: utf-8 -*-
"""
Created on Thu Jul 26 17:43:50 2018

@author: polina

USAGE: python curl_plot.py $DIAGDIR $PICTDIR $CONFIG $CASE yyyy1
"""

import os
import numpy as np
import netCDF4 as nc
import datetime
import time
from pylab import *
from mpl_toolkits.basemap import Basemap

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

# Specify the directory to find input files
datadir = sys.argv[1]
pictdir = sys.argv[2]
conf = sys.argv[3]
case = sys.argv[4]
yr1 = sys.argv[5]

numyr1 = int(yr1)
print datadir
print pictdir

def get_time(inp):
    secs00 = 2208988800
#    print arg
    tim0 = 0
    tim0 = inp - secs00
    tim1 = 0
    tim1 = time.asctime(time.localtime(tim0))[4:]
    print tim1
    tim2 = 0
    tim2 = datetime.datetime.strptime(tim1, '%b %d %H:%M:%S %Y') #'%b %d %H:%M:%S %Y')
    tim3 = tim2.strftime('%Y%m%d%H%M')
    t3 =  datetime.datetime.strptime(str(tim3),'%Y%m%d%H%M')
    return t3

def plot_map(lon,lat,vort):
    fig = plt.figure(figsize=(10,6))               
#    m = Basemap(width=5500000, height=2500000, \
#                          rsphere=(6378137.00,6356752.3142),\
#                          resolution='i', projection='lcc',\
#                          lat_1=48., lat_2=69., lat_0=60., lon_0=-28.)
    m = Basemap(llcrnrlon=-72.,llcrnrlat=48.,urcrnrlon=17.,urcrnrlat=70.,\
            rsphere=(6378137.00,6356752.3142),\
            resolution='i',projection='merc',\
            lat_0=58.,lon_0=-30.,lat_ts=62.)
    m.drawlsmask(land_color='0.8', ocean_color='w')
    m.drawmeridians(np.arange(-80.,30.,10.),labels=[0,0,0,1],color='c')
    m.drawparallels(np.arange(0.,90.,10.),labels=[1,0,0,0],color='c')
    m.drawcoastlines(linewidth=0.25)
    m.fillcontinents(color='0.75',lake_color='#99ffff')
    #lonv, latv = np.meshgrid(lon,lat)
    xx, yy = m(lon,lat)
    m.drawmapboundary(fill_color='0.3')
    im1 = m.pcolormesh(xx,yy,vort,vmin=-1., vmax=1.,shading='flat',cmap=plt.cm.seismic)
    cb = m.colorbar(im1,"right", size="5%", pad="6%")
    plt.title(str(t3)+' 50 m relative vorticity/f')
    plt.savefig(pictdir+conf+'-'+case+'_y'+yr1+'m'+str(t3)[5:6]+'d'+str(t3)[8:9]+'_curl.png', format='png', dpi=200)
    #plt.show()
    plt.cla()
    plt.clf() 
    plt.close()


filename = datadir + conf+'-'+case+'_y'+yr1+'_curl.nc'
dat = nc.Dataset(filename)
tim = dat.variables['time_counter'][:]
for it in range(len(tim)):
    print it, tim[it]
    t3 = 0
    t3 = get_time(tim[it])
    cof = dat.variables['socurloverf'][it]
    lat = dat.variables['nav_lat'][:]
    lon = dat.variables['nav_lon'][:]
    print cof.shape
    plot_map(lon,lat,cof)
