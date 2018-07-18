# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 17:39:48 2018

@author: Polina
"""

import numpy as np
import pandas as pd
import netCDF4 as nc
import glob
import matplotlib.pyplot as plt
import sys

#print 'Usage: python fwbal.py $DIAGDIR $CONFIG $CASE yyyy1 yyyy2 '
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

# Specify the directory to find input files
datadir = sys.argv[1]
conf = sys.argv[2]
case = sys.argv[3]
yr1 = sys.argv[4]
yr2 =sys.argv[5]

numyr1 = int(yr1)
numyr2 = int(yr2)
print numyr1, numyr2
#print datadir
flxfile = datadir + conf+'-'+case+'_y'+yr1+'-'+yr2+'_fwfl.nc'
ntrpfile = datadir + conf+'-'+case+'_y'+yr1+'-'+yr2+'_northtrp.nc'
strpfile = datadir + conf+'-'+case+'_y'+yr1+'-'+yr2+'_southtrp.nc'

flxdat = nc.Dataset(flxfile)
ntrpdat = nc.Dataset(ntrpfile)
strpdat = nc.Dataset(strpfile)

twflx = np.squeeze(np.array(flxdat.variables['sum_sowaflup'][:])*1e-9) # total upward (extracted) water flux [kg/s]
evap = np.squeeze(np.array(flxdat.variables['sum_3Dsoevap'][:])*1e-9) # integrated mean evaporation [kg/s]
prec = np.squeeze(np.array(flxdat.variables['sum_3Dsoprecip'][:])*1e-9*-1)#.13 # integrated mean amount of precipitaition [kg/s] !! 1.13 - checking for precip correction
runf = np.squeeze(np.array(flxdat.variables['sum_3Dsornf'][:])*1e-9*-1) # integrated mean runoff
damp = np.squeeze(np.array(flxdat.variables['sum_3Dsowafld'][:])*1e-9) # integrated mean damping term

strp = np.squeeze(np.array(strpdat.variables['vtrp'][:])) # southern boundary integrated transport, Sv
ntrp = np.squeeze(np.array(ntrpdat.variables['vtrp'][:])) # northern boundary integrated transport, Sv
ttrp = strp+ntrp
twflx2 = evap+prec+runf+damp
balc = ttrp+twflx2
print twflx.shape

# draw bar plot with mean and sum values
# calculate balbance and compare to TWFLX!!!!!
fig, ax = plt.subplots()
colors=['plum','thistle', 'wheat', 'tan', 'darkkhaki', 'sage', 'steelblue']
x = np.arange(7)
flx = [np.mean(twflx2),np.mean(balc), np.mean(ttrp), np.mean(evap), np.mean(prec), np.mean(runf), np.mean(damp)]
sflx = [np.sum(twflx),np.sum(balc), np.sum(ttrp), np.sum(evap), np.sum(prec), np.sum(runf), np.sum(damp)]
np.array(flx)
plt.bar(x,flx, color=colors)
#plt.bar(x,sflx, color=colors)
plt.plot([0,7],[0.0,0],'k-',lw=1)
plt.title('Mean '+yr1+'-'+yr2+' annual fresh water balance terms:\n'+conf+'-'+case)
plt.xticks([0.4,1.4,2.4,3.4,4.4,5.4,6.4,7.4],('Net\nsurflux','Balance','Ttrp', 'Evap', 'Precip', 'Runoff', 'Damping'),rotation=27)
plt.grid()
plt.savefig(case+'_bar_fwflx_mean.jpeg', format='jpeg', dpi=300)

print np.mean(twflx2),np.mean(balc), np.mean(ttrp), np.mean(evap), np.mean(prec), np.mean(runf), np.mean(damp)

# plot the time seria for yearly averages
fig, ax2 = plt.subplots()
xx = np.arange(numyr1,numyr2+1, 1)
plt.plot(xx,twflx,'darkorchid',lw=2,label='twflx')
plt.plot(xx,balc,'palevioletred',lw=2, label='balance')
plt.plot(xx,ttrp,'peru',lw=2,label='ttrp')
plt.plot(xx,evap,'slategray',linestyle=':',lw=2,label='evap')
plt.plot(xx,prec,'darkkhaki',linestyle='-.',lw=2, label='precip')
plt.plot(xx,runf,'sage',linestyle='-.',lw=2, label='runoff')
plt.plot(xx,damp,'royalblue',linestyle='--',lw=2,label='damping')
plt.grid()
plt.legend(loc='best', prop={'size': 7})
plt.title('Yearly means of water flux balance components:\n'+conf+'-'+case)
plt.savefig(case+'_ts_fwflx_mean.jpeg', format='jpeg', dpi=300)

