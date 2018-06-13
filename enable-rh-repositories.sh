#!/bin/bash

OUTFILE=./product-list-include.txt
OFS=$IFS


function Usage() {

  # Function   : Usage
  # Purpose    : Display how to use this program.
  # Parameters : None
  # Output     : How to use this program.

  # Print usage clause.
  echo "Usage:" 1>&2
  echo "$0 [[-o or --org ] organization] [-l or --list] [-e or --enable] -f filename" 1>&2
  echo " " 1>&2
  echo "-l or --list    : create listing to modify for enabling Red Hat Repositories." 1>&2
  echo "-e or --enable  : enabling Red Hat Repositories." 1>&2
  echo "-f or --file    : filename to output to modified and filename to read in to enable repos." 1>&2
  echo "-h or --help    : help information." 1>&2
  echo "-o or --org     : organization. " 1>&2
  echo " " 1>&2
  # Exit program.
  exit 1
}

function generate-rh-repo-list {

   ORG=$1
   FILENAME=$2
   if [ "${ORG}" != "" ]; then
      ORG="--organization ${ORG}"
   fi
   hammer --output csv product list ${ORG} | grep -v ^ID | awk -F , '{ printf("%s\n", $2 ) }' | \
   while read PNAME
   do
      IFS=','
      hammer --output csv repository-set list ${ORG} --product "${PNAME}" | grep -v ^ID | \
      while read ID NULL RNAME
      do
         hammer --output csv repository-set available-repositories ${ORG} --id ${ID} --product "${PNAME}" | grep -viE 'ID|Name' | \
         while read NAME ARCH RELEASE NULL ENABLED
         do
            echo n,$NAME,$ARCH,$RELEASE,$ID,$RNAME
         done
      done
   done > $FILENAME

}

function enable-rh-repo-list {

   ORG=$1
   FILENAME=$2
   if [ "${ORG}" != "" ]; then
      ORG="--organization ${ORG}"
   fi
   IFS=','
   cat ./${FILENAME} | grep -v ^n | \
   while read ENABLE REPONAME ARCH RELEASERVER REPOSITORYID NAME
   do
       if [ "{RELEASEVER}" != "" ]; then
          OPTIONSLINE="${ORG} --basearch ${ARCH} --name \"${REPONAME}\" --product-id ${REPOSITORYID}"
       else
          OPTIONSLINE="${ORG} --basearch ${ARCH} --releasever ${RELEASEVER} --name \"${REPONAME}\" --product-id ${REPOSITORYID}"
       fi
       echo Enabling : $REPONAME
       #echo hammer repository-set enable $OPTIONSLINE
   done

}

#
# MAIN Program
#

# If no command-line arguments and parameters found then print usage.

if [ $# -lt 1 ] ; then Usage >&2 ; fi

# Pull arguments from command-line. Print usage if
# getopt returns a error.

# Process command-line arguments and parameters.

# Using getopt to pull in the values from the command-line.

LIST=0
ENABLEREPOS=0
OPTS=`getopt -n 'parse-options' -o lef: --long help,list,enable,file: -- "$@"`
if [ $? != 0 ] ; then Usage >&2 ; fi
eval set -- "$OPTS"

# Process the arguments into variables.

while true; do
    case "$1" in
        -h | --help )
            shift
            Usage
            ;;
        -l | --list )
            LIST=1
            shift 
            ;;
        -e | --enable )
            ENABLEREPOS=1
            shift
            ;;
        -f | --file )
            FILENAME="${2}"
            shift 2
            ;;
        -o | --org )
            ORG="${2}"
            shift 2
            ;;
        -- )
            shift
            break
            ;;
         * )
            shift
            Usage
            ;;
    esac
done

# Making sure all the required variables we need from the command-line
# are populated.

if [ -z "${FILENAME}" ]; then
    Usage
    exit 1
fi

if [ $ENABLEREPOS -eq 1 -a $LIST -eq 1 ]; then
    Usage
    exit 1
fi

OFS=$IFS

if [ $LIST -eq 1 ]; then
   generate-rh-repo-list "${ORG}" $FILENAME
   echo " "
   echo "Step 1: Modify ${FILENAME} to enable Red Hat Repositories in the list"
   echo "Step 2: Mark the ones to enable by changing 'n' to 'y' and save the file"
   echo "Step 3: Rerun $0 with -e -f $FILENAME to enable the repos in Satellite."
fi

if [ $ENABLEREPOS -eq 1 ]; then
   enable-rh-repo-list "${ORG}" $FILENAME
fi

IFS=$OFS
exit 0
