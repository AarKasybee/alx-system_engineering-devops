#! /bin/bash
#  ===============================================
#

# VERSION  | DATE       | DESCRIPTION
# 1.0      | 2019/02/08 | Creation
# 1.1      | 2019/02/21 | Adding Env variables check
# 1.2      | 2019/05/23 | CR554: [CheckInstall] Add a sort to order generated items
# 1.3      | 2019/08/30 | CR632: [Checkinstall] error message on RTC Linux traction
# 1.4      | 2019/12/13 | Check injection propagation mode
# 1.5      | 2021/01/05 | Adding check of /usr/local/lib 
# 1.5.1    | 2021/01/18 | Adding Hardware check
# 1.5.2    | 2021/01/22 | Adding PCI Tree check
# 1.5.3    | 2021/01/22 | Adding UTEST-5 compatibility
# 1.5.4    | 2021/02/11 | Adding BIOS information
# 1.5.5    | 2021/05/25 | Adding check for Profibus related files and folders
#                       | Adding Kernel information and Kernel module list
#                       | Improve network information
# 1.5.6    | 2021/05/28 | Sort the module list
# 1.5.7    | 2021/10/27 | Adding cb_server
# 1.5.8    | 2022/05/25 | redirect stderr in the log file
# 1.5.9    | 2023/05/05 | Adding the check of the libxml (PATCH04)
###############################################################################
VERSION="1.5.9"
CURENT_DATE=`date +"%y%m%d%H%M%S"`
OUTFILE=/home/CheckInstall.$CURENT_DATE.xml
HOSTNAME=`hostname`
##U-TEST4
SPHEREA_FOLDER1="/opt/gc"
SPHEREA_FOLDER2="/opt/vs"
SPHEREA_FOLDER3="/opt/utest"

## IF U-TEST5
if [ -d "/opt/spherea" ]
then
SPHEREA_FOLDER1="/opt/spherea/rtc"
SPHEREA_FOLDER2="/opt/spherea/vs"
SPHEREA_FOLDER3="/opt/spherea/commons"
fi


declare -a TAB_FOLDER=(
"/usr/local/bin/cleanup.sh"
"/usr/local/bin/configureBench.sh"
"/usr/local/bin/CheckInstall.sh"
"/usr/local/bin/cb_server"
"/usr/local/TBRP"
"/usr/local/lib"
$SPHEREA_FOLDER1
$SPHEREA_FOLDER2
$SPHEREA_FOLDER3
"/opt/cifx"
)


#####################################
#          functions                #
#####################################
# Get the XML header
GetXMLHeader ()
{
   echo "<CHECKINSTALLATION>"
   echo "   <Tool version=\""$VERSION"\" os=\"Linux\" />" 
   echo "   <DATE>$CURENT_DATE</DATE>" 
}

# Get the RPM list
GetRPMList ()
{
   echo "   <RPM_LIST>" 
   rpm -qa | sort | while read line
   do
      echo "      <RPM>$line</RPM>" 
   done
   echo "   </RPM_LIST>" 
}

# Get the environment variables
GetEnvVar ()
{
   declare -i ORDER=1
   echo "   <ENV_VAR_LIST>" 
   for var in `echo $PATH | tr ":" " "`
   do
      echo "      <ENV_VAR order=\"$ORDER\">$var</ENV_VAR>" 
      ORDER=$(( ORDER + 1 ))
   done
   echo "   </ENV_VAR_LIST>" 
}

# get informations about network
GetNetworkInfo ()
{
   RESULT=`ifconfig;ip a`
   echo "   <NETWORK_INFO>" 
   echo "      <HOSTNAME>$HOSTNAME</HOSTNAME>" 
   echo "      <IPCONFIG>" 
   echo "$RESULT"   
   echo "      </IPCONFIG>" 
   echo "   </NETWORK_INFO>" 
}

# get informations about BIOS
GetBiosInfo ()
{
   RESULT=`dmidecode -t 0`
   echo "   <BIOS_INFO>" 
   echo "$RESULT"   
   echo "   </BIOS_INFO>" 
}

# get kernel information
GetKernelInfo ()
{
   RESULT=`uname -a`
   echo "   <KERNEL_INFO>" 
   echo "$RESULT"   
   echo "   </KERNEL_INFO>" 
}


# get kernel information
GetKernelModuleList ()
{
   RESULT=`lsmod | sort`
   echo "   <KERNEL_MODULES>" 
   echo "$RESULT"   
   echo "   </KERNEL_MODULES>" 
}



# get hardware information
GetHardwareInfo ()
{
   echo "   <HARDWARE_INFO>" 
   RESULT=`lspci -vv`
   echo "      <PCI>" 
   echo "$RESULT"   
   echo "      </PCI>" 
   RESULT=`lspci -tv`
   echo "      <PCI_TREE>" 
   echo "$RESULT"   
   echo "      </PCI_TREE>" 
   if [ -d /dev/comedi/by-path ]
   then
	   RESULT=`ls -l /dev/comedi/by-path`
	   echo "      <COMEDI>" 
	   echo "$RESULT"   
	   echo "      </COMEDI>" 
	else
		echo "      <COMEDI></COMEDI>" 		
   fi
   RESULT=`nilsdev -v`
   echo "      <DAQMX>" 
   echo "$RESULT"   
   echo "      </DAQMX>" 
   echo "   </HARDWARE_INFO>" 
}

# Return the MD5 for each file found into the specified folder or file
TestFolder ()
{
   echo "   <FOLDER_LIST>" 
   for rep in ${TAB_FOLDER[@]}
   do
      echo "      <FOLDER Name=\"$rep\">" 
      if [ -f $rep ]
      then
        ls -lrt $rep | awk '{print $1" "$3" "$4}' | while read DROITS OWNER GROUP
        do
           md5sum $rep | while read MD5 FILE
           do
              echo "         <MD5 file=\"$FILE\" droits=\"$DROITS\" prop=\"$OWNER\" groupe=\"$GROUP\">$MD5</MD5>" 
           done
        done
      else
         if [ -d $rep ]
         then
            find $rep -name "*" |sort| while read line
            do
               if [ -f "$line" ]
               then
                  md5sum "$line" | awk '{print "         <MD5 file=\""$2"\">"$1"</MD5>"}' 
               fi
            done
         fi
      fi
      echo "      </FOLDER>" 
    
   done
   echo "   </FOLDER_LIST>" 
}

# get the XML footer
GetXMLFooter ()
{
   echo "</CHECKINSTALLATION>" 
}

#####################################
#             main                  #
#####################################

echo "Analyze in progress"| awk '{printf $0}'

(

GetXMLHeader;

TestFolder;

GetRPMList;

GetEnvVar;

GetNetworkInfo;

GetHardwareInfo;

GetBiosInfo;

GetKernelInfo;

GetKernelModuleList;

GetXMLFooter;

)>>$OUTFILE 2>>$OUTFILE


echo ""
echo ""

echo "File generated with success: $OUTFILE"

echo ""

#####################################
#          end of script            #
#####################################

