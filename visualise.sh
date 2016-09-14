#!/bin/sh
clear

echo -e '\n'"Ingmar Lippert's (2016) (c) script for visualising partial GPG Web of Trust " '\n' ;

        echo "starting testing;"
if hash neato 2>/dev/null; then
        echo "."
    else
        echo "I require neato but it's not installed.  Aborting."; exit;
    fi
if hash springgraph 2>/dev/null; then
        echo "."
    else
        echo "I require springgraph but it's not installed.  Aborting."; exit;
    fi
if hash paplay 2>/dev/null; then
        echo "."
    else
        echo "I require paplay but it's not installed.  Aborting."; exit;
    fi
if hash paplay 2>/dev/null; then
        echo "."
    else
        echo "I require paplay but it's not installed.  Aborting."; exit;
    fi
if hash gpg 2>/dev/null; then
        echo "."
    else
        echo "I require gpg but it's not installed.  Aborting."; exit;
    fi
if hash sig2dot 2>/dev/null; then
        echo "."
    else
        echo "I require sig2dot but it's not installed.  Aborting."; exit;
    fi
if hash convert 2>/dev/null; then
        echo "."
    else
        echo "I require convert but it's not installed.  Aborting."; exit;
    fi



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
convert -pointsize 15 -fill gray -draw "text 5,25 'Web of Trust'"  -pointsize 22 -fill black -draw "text 5,80 $scope" -pointsize 20 -fill black -draw "text 5,50 '$date" keyring-$date.$visualsoftware.ps keyring-$date.$visualsoftware.pdf

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
