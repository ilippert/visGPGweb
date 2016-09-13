#!/bin/sh
clear

echo -e '\n'"Ingmar Lippert's (2016) (c) script for visualising partial GPG Web of Trust " '\n' ;

date=`date "+%Y-%m-%d--%H_%M_%S"`


#using scope argument passed from command line, otherwise use global

if test -z "$1"; then
    echo "argument empty; to visualise global network"
    scope='global'
else
    echo "argument provided; assigning scope argument: "
    scope=$1
    echo $scope
fi


#defining visualisation software
echo "specify visualisation software/path/command: "
#e.g. springgraph with options or neato
visualsoftware=neato
#The "-s .6" specifies the scale, and is optional. All of the node locations are multiplied by this. Increase the scale to eliminate node overlaps. Decrease the scale to make the graph smaller.
visualsoftwareoptions=""
echo $visualsoftware



cd ../visualisations

#sleep 5

# starting sound

paplay /usr/share/sounds/gnome/default/alerts/sonar.ogg; 

echo -e '\n' Commencing script at $date with scope /$scope/ '\n' ;

#sleep 2


# generate and convert
echo -e '\n' generate... '\n' ;

if [ "$scope" = "global" ]; then 
    #global
    #echo "scope = $scope" 
    gpg --list-sigs | sig2dot > keyring-$date.dot
else
    #other than global
    #echo "scope = $scope"  
    gpg --list-sigs $scope | sig2dot > keyring-$date.dot
fi;








#clear

#visualising dot file
neato -Tps keyring-$date.dot > keyring-$date.$visualsoftware.ps

#cat keyring-$date.dot |$visualsoftware $visualsoftwareoptions > keyring-$date.$visualsoftware.png





#converting file
convert keyring-$date.$visualsoftware.ps keyring-$date.$visualsoftware.pdf

#convert keyring-$date.$visualsoftware.png keyring-$date.$visualsoftware.pdf


ls -l
#sleep 5


# rename and clean up
#clear 
echo -e '\n' cleaning up ... '\n' ;
## substituting spaces by commas in scope
scope=${scope// /,}
#moving and removing
mv keyring-$date.$visualsoftware.pdf $scope-WebOfTrust.$visualsoftware-$date.pdf
rm keyring*

ls -l
#sleep 2


# opening file and ending
evince $scope-WebOfTrust.$visualsoftware-$date.pdf &
echo -e '\n'"Done at";
date 
cd ../VisualiseGPGWebOfTrust
#ending sound
paplay /usr/share/sounds/gnome/default/alerts/sonar.ogg;
