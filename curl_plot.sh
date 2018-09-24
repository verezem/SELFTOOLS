#!/bin/bash

set -x

# This is a script to plot curl over f with curl_plot.py script and put it to DRAKKAR monitoring site.

source ./header.sh
yr1=1992
yr2=1992

# open tunnel through meolkerg for machine without direct acces to ige-meom-drakkar
open_tunnel() {
      case $MACHINE in
      ( curie000 )
      # obsolete ( ==> curie000 is a dummy  name ) ige-meom-drakkar is now directly accessible from curie
      ssh_port="-p 3022"
      scp_port="-P 3022"
      web_host=localhost

      # check if tunnel already open
      pid=$(ps -edf | grep "ssh -f -N -L 3022:ige-meom-drakkar.u-ga.fr:22" | grep -v grep | head -1 | awk '{ print $2}')
      if [  $pid ] ; then
         exit
      else
         ssh -f -N -L 3022:ige-meom-drakkar.u-ga.fr:22 ige-meom-cal1.u-ga.fr
      fi  ;;

      ( * )
      ssh_port=
      scp_port=
      web_host=ige-meom-drakkar.u-ga.fr  ;;
      esac
              }

# close tunnel
close_tunnel() {
    pid=$(ps -edf | grep "ssh -f -N -L 3022:ige-meom-drakkar.u-ga.fr:22" | grep -v grep | head -1 | awk '{ print $2}')
    if [ $pid ] ; then  kill -9 $pid ; fi
               }

# copy_png_to_web : copy balance plots to the DRAKKAR website
# usage : copy_png_to_web file
copy_png_to_web()  {
          ssh $ssh_port $web_host -l drakkar \
         " if [ ! -d DRAKKAR/$CONFIG/$CONFCASE/CURL ] ; then mkdir -p DRAKKAR/$CONFIG/$CONFCASE/CURL ; fi "
          scp $scp_port $@ drakkar@${web_host}:DRAKKAR/$CONFIG/${CONFCASE}/CURL/
                  }

for yr in {1992..1992} ; do
    " if [ ! -d $DIAGDIR/PLOTS/$yr ] ; then mkdir -p $DIAGDIR/PLOTS/$yr ; fi "
    python curl_plot.py $DIAGDIR/$yr/ $DIAGDIR/PLOTS/$yr/ $CONFIG $CASE $yr
    convert -delay 20 $DIAGDIR/PLOTS/$yr/*.png $DIAGDIR/PLOTS/$yr/${CONFCASE}_y${yr}_curl.gif
done 

open_tunnel
copy_png_to_web $DIAGDIR/PLOTS/$yr/${CONFCASE}_y${yr}_curl.gif
close_tunnel
