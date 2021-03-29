#! /bin/bash

#Copyright 2021, Rob Sullivan, All rights reserved.
#@author Rob Sullivan <http://mailto:c08345457@mytudublin.ie> 

#What is it:
#This script helps an administrator of a research group conducting ongoing research to track changes 
#made to their directories, preventing where possible incorrect changes to the directory. 
#An administrator can use this script to determine who made changes. 
#Overall offering transparency and accountability for all changes made to the research directory going forward.

#How it works:
#Using the menu system an admin can setup directories, manage scheduled tasks, manage user/group management and view logs

#This script was wrote in bash and tested on Ubuntu

#Installation & Running
# - sudo apt install apache2
# - sudo apt install auditd
# - sudo ./research-manager.sh


#License
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#A copy of the GNU General Public License can be found at 
#<http://www.gnu.org/licenses/>.




#/**** SCHEDULE FUNCTIONS ****/
function scheduleStatus()
{
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "SCHEDULE STATUS\n\n"
    sudo crontab -l
}

function nightlyPublish()
{
    printf "scheduling nightly 2am publish\n"
    #check job not already in place 
    #write out current crontab and echo new cron into cron file
    sudo crontab -l | grep -q 'publishAllToSite'  && echo 'nightly schedule exists already' || echo "00 02 * * * root ./research-manager.sh && publishAllToSite" >> tempCron1
    sudo crontab -l >> tempCron1
    
    
    #install new cron file
    sudo crontab tempCron1
    sudo rm tempCron1
}

function nightlyBackup()
{
    printf "scheduling nightly backup\n"
    #check job not already in place 
    #write out current crontab and echo new cron into cron file
    sudo crontab -l | grep -q 'backupWebsite'  && echo 'nightly schedule exists already' || echo "01 02 * * * root ./research-manager.sh && backupWebsite" >> tempCron2
    sudo crontab -l >> tempCron2
    #install new cron file
    sudo crontab tempCron2
    sudo rm tempCron2
}

function nightlyLog()
{
    printf "scheduling nightly logfiles\n"
    #write out current crontab and echo new cron into cron file
    sudo crontab -l | grep -q 'generateLogFiles'  && echo 'nightly schedule exists already' || echo "02 02 * * * root ./research-manager.sh && generateLogFiles" >> tempCron3
    sudo crontab -l >> tempCron3
    #install new cron file
    sudo crontab tempCron3
    sudo rm tempCron3
}

function nightlyHealthCheck()
{
    printf "scheduling nightly health check\n"
    #write out current crontab
    #write out current crontab and echo new cron into cron file
    sudo crontab -l | grep -q 'systemHealthReport'  && echo 'nightly schedule exists already' || echo "03 02 * * * root ./research-manager.sh && systemHealthReport" >> tempCron4
    sudo crontab -l >> tempCron4
    #install new cron file
    sudo crontab tempCron4
    sudo rm tempCron4
}

#/**** BACKUP FUNCTIONS ****/
function backupWebsite()
{
    printf "making a backup of files\n"
    sudo chmod -R 700 /var/www/html/
    DATE=$(date +"%d-%b-%Y")
    sudo tar --exclude='/var/www/html/backups/' -zcvf website-$DATE.tgz /var/www/html
    sudo mv *.tgz /var/www/html/backups/
    sudo chmod -R 774 /var/www/html/
    #here we set the research folder to be a shared folder
    sudo chmod -R 777 var/www/html/research/
    sudo chmod -R 777 var/www/html/ #not to be used in production
}

#/**** LOGGING FUNCTIONS ****/
function viewAllLogs()
{
    printf "**Welcome to Research Manager**\n\n" 
    printf "Log Files:\n"
    for log in $( ls /var/www/html/logfiles/ )
    do
        printf " $log\n"
    done
    printf "\n"
}

function viewLog()
{
    viewAllLogs
    printf "Enter a log file to view\n"
    read logfile
    sudo cat /var/www/html/logfiles/$logfile
    read -n 1 -s -r -p "Press any key to return to the Log Menu"
    LogMenu
}

function searchLog()
{
    viewAllLogs
    printf "Enter a log file to search in\n"
    read logfile
    printf "Enter a search term\n"
    read searchTerm
    grep $searchTerm /var/www/html/logfiles/$logfile
    read -n 1 -s -r -p "Press any key to return to the Log Menu"
    LogMenu
}

function generateLogFiles()
{
    printf "generating logfiles\n"
    numFolders=${#researchFolders[@]}
    for (( i=0; i<numFolders; i++))
    do
        folderName=${researchFolders[$i]::-1} # need -1 to remove comma
        sudo ausearch -f $serverPath/$folderName | aureport -f -i  > $serverPath/logfiles/$folderName.txt
    done

}

#/**** SETUP FUNCTION ****/
function SetupResearchSystem(){

    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "SETUP Research System\n\n"
    printf "This command will run a setup of the research system.\n"
    printf "It will do the following:\n"
    printf " check if apache server is running and start it if not.\n"
    printf " setup research, published, logfiles and backups folders along side html folder in /var/www/\n"
    printf " setup research group (r_group) and set initial group permissions\n"
    printf " setup initial researchers sarah, miles and jon.\n"
    printf "if any of these are already setup it will skip the setup.\n"
    printf "if not running in sudo you may be asked to enter a password\n\n"
    
    echo -n "Do you want to run setup (y/n)? "
    read answer

    if [ "$answer" != "${answer#[Yy]}" ]
    then
        #SETUP RESEARCH SERVER
        printf "\n\nserver check:\n"
        #checking if Apache is running or not
        if ! pidof apache2 > /dev/null
        then
            printf " apache web server is down, trying auto-restart. please wait...\n"
            # web server down, restart the server
            sudo /etc/init.d/apache2 restart > /dev/null
            sleep 10
            #checking if apache restarted or not
            if pidof apache2 > /dev/null
            then
                printf " apache restarted successfully at: http://127.0.0.1/\n"
                serverPath="/var/www/" #now we get a path to it, for later
            else
                printf " apache is not running. check if installed and try running\n"
                printf " sudo apt-get update\n"
                printf " sudo apt-get install apache2\n\n"
                exit
            fi
        else
            printf " Apache is running.\n"
            serverPath="/var/www/html" #now we get a path to it, for later
        fi

        #SETUP GROUP
        printf "group setup:\n"
        #we check if the research group already exists
        if [ $(getent group r_group) ]; then
            #set access here
            printf " r_group exists. setting permissions\n"
        else
            printf " r_group doesn't exist. creating and setting permissions\n"
            sudo addgroup r_group #we create our research group
        fi

        #SETUP AUDITD
        #checks if auditd is installed (taken from here: https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script#:~:text=To%20check%20if%20something%20is,then%20run%20this%20tool%20again.%22&text=The%20executable%20check%20is%20needed,name%20is%20found%20in%20%24PATH%20.) 
        command -v auditd >/dev/null 2>&1 || { echo >&2 "auditd not installed.\nrun sudo apt install auditd."; }

        #SETUP FOLDERS
        printf "\n\nfolder setup:\n"
        #the following will be our research folders
        #html - apache server generated folder
        #research - where our pdf papers will be unpublished
        #published - where our published papers will be copied to site
        #logfiles - different log files for admins
        #backups - backups of html website and papers
        researchFolders=('live', 'research', 'published', 'logfiles', 'backups',)
        #first we setup our folders by doing a check and create if not found
        numFolders=${#researchFolders[@]}
        for (( i=0; i<numFolders; i++))
        do
            folderName=${researchFolders[$i]::-1} # need -1 to remove comma
            #simple check if folder exists and create if not
            if [ -d "$serverPath/$folderName" ] 
            then
                sudo chown root:r_group $serverPath/$folderName
                #here we set all folders to be private
                sudo chmod -R 764 $serverPath/$folderName # rootcan rwx, groups can r--, world cannot
                #put a watch on dir -w is watch -p is options w r x a(append)
                sudo auditctl -w $serverPath/$folderName -p wrxa
                printf " folder: $folderName ok\n"
            else
                sudo mkdir -p $serverPath/$folderName
                sudo chown root:r_group $serverPath/$folderName
                #here we set all folders to be private
                sudo chmod -R 764 $serverPath/$folderName # root can rwx, groups can r--, world cannot
                #put a watch on dir -w is watch -p is options w r x a(append)
                sudo auditctl -w $serverPath/$folderName -p wrxa
                printf " folder: $folderName :created\n"
            fi
        done

        #here we set the research folder to be a shared folder
        sudo chmod -R 777 var/www/html/research/ # root, groups, world can rwx
        sudo chmod -R 777 var/www/html/ #not to be used in production
        #SETUP RESEARCHERS
        printf "\n\nresearcher setup:\n"
        #the following will be our researchers (including us)
        #Sarah Conor # chief researcher
        #Miles Dyson
        #Jon Conor
        #su in as one of these users. eg su sarah

        #first lets make admin(root) part of research group if not done already
        sudo usermod -aG r_group root
        printf "root:\n"
        printf " root may need to re-login for group settings to take effect\n\n"
        #now we define 3 other researchers in an array
        researchers=('sarah', 'miles', 'jon',)
        numrusers=${#researchers[@]} #get the length of the array for our loop

        #array is zero index so we start at zero and loop until num rusers
        for (( i=0; i<numrusers; i++))
        do
            r_user=${researchers[$i]::-1}
            printf "$r_user:\n"
            sudo useradd -m $r_user #we will let linux check if they exist
            #add user to the research group
            sudo usermod -aG r_group $r_user
            #logout and login to take effect so we remind admin of this
            printf " $r_user will need to re-login for group settings to take effect\n\n"
        done

        #SETUP SCHEDULES
        printf "\n\nschedule setup:\n"
        nightlyPublish #copies all publish files to html folder at 2am every night
        nightlyBackup #packages up files in html folder and stores them in var/www/backup/ each night
        nightlyLog #we use aureport with ausearch to generate log files
        nightlyHealthCheck #generates a health report and stores it for us to check later

        #SETUP LOGFILES
        generateLogFiles #we generate initial logfiles in /var/www/html/logfiles/

        printf "finished setup commands...\n\n"
    else
        printf "\nsetup was cancelled...\n\n"
    fi
    read -n 1 -s -r -p "Press any key to return to the Main Menu"
    MainMenu
}

#/**** USER ADMIN FUNCTIONS ****/
#This is for listing all researchers and their groups
function listResearchers()
{
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "List Researchers\n\n"
    printf "Current Researcher:\n"
    for user in $( cd /home/ && ls )
    do
        printf " User: $user, Groups:" && id $user
    done
}

#This is to create a new researcher
function createResearcher()
{
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "Create New Researcher\n\n"
    printf "Enter the name of new researcher to add\n"
    read newUser
    sudo useradd -m $newUser
    read -n 1 -s -r -p "Press any key to continue"
    listResearchers
}

#This is to delete a researcher
function deleteResearcher()
{
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "Delete Researcher\n\n"

    #we list all the researchers before we delete one to 
    #remind user the names to use
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " User: $user, Groups:" && id $user
    done
    printf "Enter the name of new researcher to delete\n"
    read newUser
    sudo userdel -r $newUser
    read -n 1 -s -r -p "Press any key to continue"
    listResearchers
}

#/**** GROUP ADMIN FUNCTIONS ****/
function addResearcherToGroup(){
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "Add Researcher to Group\n\n"

    #get name of research to add to the group
    printf "Enter the name of new researcher to add to research group\n"
    read newUser
    sudo usermod -aG r_group $newUser
    printf "$r_user will need to re-login for group settings to take effect\n\n"
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " Researcher: $user, Groups:" && id $user
    done
    read -n 1 -s -r -p "Press any key to return to the Group Menu"
    GroupMenu
}

function removeResearcherFromGroup(){
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "Remove Researcher to Group\n\n"

    #we list all the researchers before we change anything one to 
    #remind user the names to use
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " Researcher: $user, Groups:" && id $user
    done
    #get name of research to add to the group
    printf "Enter the name of new researcher to add to research group\n"
    read newUser
    sudo gpasswd -d $newUser r_group
    printf "$r_user will need to re-login for group settings to take effect\n\n"
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " Researcher: $user, Groups:" && id $user
    done
    read -n 1 -s -r -p "Press any key to return to the Group Menu"
    GroupMenu
}

#/**** PUBLISH PAPER AUTO FUNCTIONS ****/

function publishAllResearch()
{
    sudo chmod -R 700 /var/www/html/
    for p_paper in $( ls /var/www/html/research/ )
    do  
        #create a .lock file to lock the file
        sudo touch $p_paper.lock
        if [[ -f "/var/www/html/published/$p_paper" ]]
        then
            sudo rm -v /var/www/html/research/$p_paper
            #delete a .lock file to unlock the file
            sudo rm $p_paper.lock
        else
            sudo cp /var/www/html/research/$p_paper /var/www/published/
            sudo rm -v /var/www/html/research/$p_paper
            #delete a .lock file to unlock the file
            sudo rm $p_paper.lock
        fi
    done
    sudo chmod -R 774 /var/www/html/
    #here we set the research folder to be a shared folder
    sudo chmod -R 777 var/www/html/research # root, groups, world can rwx
    sudo chmod -R 777 var/www/html/ #not to be used in production
    printf "\n"
}

function publishAllToSite()
{
    sudo chmod -R 700 /var/www/html/
    for p_paper in $( ls /var/www/html/published/ )
    do
        #create a .lock file to lock the file
        sudo touch $p_paper.lock
        if [[ -f "/var/www/html/live/$p_paper" ]]
        then
            sudo rm -v /var/www/html/published/$p_paper
            sudo rm $p_paper.lock
        else
            sudo cp /var/www/html/published/$p_paper /var/www/html/live/
            sudo rm -v /var/www/html/published/$p_paper
            sudo rm $p_paper.lock
        fi
    done
    sudo chmod -R 774 /var/www/html/
    #here we set the research folder to be a shared folder
    sudo chmod -R 777 var/www/html/research # root, groups, world can rwx
    sudo chmod -R 777 var/www/html/ #not to be used in production
    printf "\n"
}

function unpublishAllFromSite()
{
    sudo chmod -R 700 /var/www/html/
    for p_paper in $( ls /var/www/html/live/ )
    do
        sudo touch $p_paper.lock
        if [[ -f "/var/www/html/published/$p_paper" ]]
        then
            sudo rm -v /var/www/html/published/$p_paper
            sudo rm $p_paper.lock
        else
            sudo cp /var/www/html/live/$p_paper /var/www/html/published/
            sudo rm -v /var/www/html/live/$p_paper
            sudo rm $p_paper.lock
        fi
    done
    sudo chmod -R 774 /var/www/html/
    #here we set the research folder to be a shared folder
    sudo chmod -R 777 var/www/html/research # root, groups, world can rwx
    sudo chmod -R 777 var/www/html/ #not to be used in production
    printf "\n"

}

function unpublishAllResearch()
{
    sudo chmod -R 700 /var/www/html/
    for p_paper in $( ls /var/www/published/ )
    do
        sudo touch $p_paper.lock
        if [[ -f "/var/www/research/$p_paper" ]]
        then
            sudo rm -v /var/www/html/published/$p_paper
            sudo rm $p_paper.lock
        else
            sudo cp /var/www/html/published/$p_paper /var/www/html/research/
            sudo rm -v /var/www/html/published/$p_paper
            sudo rm $p_paper.lock
        fi
    done
    sudo chmod -R 774 /var/www/html/
    #here we set the research folder to be a shared folder
    sudo chmod -R 777 var/www/html/research # root, groups, world can rwx
    sudo chmod -R 777 var/www/html/ #not to be used in production
    printf "\n"

}

#/**** PUBLISH PAPER MANUAL FUNCTIONS ****/
function publishStatus()
{
    #show title and clear screen
    printf "**Welcome to Research Manager**\n\n" 
    printf "Research Paper Status..\n\n"

    printf "\nUnpublished Research Papers:\n"
    for r_paper in $( ls /var/www/html/research/ )
    do
        printf " Paper: $r_paper\n"
    done
    printf "\n"
    printf "Published Research Papers:\n"
    for p_paper in $( ls /var/www/html/published/ )
    do
        printf " Paper: $p_paper\n"
    done
    printf "\n"
    printf "Live on Website:\n"
    for p_paper in $( ls /var/www/html/live/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            printf " Paper: $p_paper\n"
        fi
    done
    printf "\n"
}

function searchPapers()
{
    publishStatus
    printf "Enter a search term\n"
    read searchTerm
    grep -r $searchTerm /var/www/html/live/ /var/www/html/published/ /var/www/html/research/
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu
}

function publishAResearchPaper()
{
    publishStatus
    printf "Enter the full name the paper to publish\n"
    read p_paper
    lockedFile=${p_paper[$i]::-4}
    if [ "$p_paper" != "$lockedFile.lock" ]
    then
        if [[ -f "/var/www/html/published/$p_paper" ]]
        then
            sudo rm -v /var/www/html/research/$p_paper
        else
            sudo cp /var/www/html/research/$p_paper /var/www/html/published/
            sudo rm -v /var/www/html/research/$p_paper
        fi
    else
        printf "$p_paper is currently locked.\n"
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu
}

function publishAPaperToSite()
{       
    publishStatus
    printf "Enter the full name the paper to publish to the site\n"
    read p_paper
    lockedFile=${p_paper[$i]::-4}
    if [ "$p_paper" != "$lockedFile.lock" ]
    then
        if [[ -f "/var/www/html/live/$p_paper" ]]
        then
            sudo rm -v /var/www/html/published/$p_paper
        else
            sudo cp /var/www/html/published/$p_paper /var/www/html/live/
            sudo rm -v /var/www/html/published/$p_paper
        fi
    else
        printf "$p_paper is currently locked.\n"
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu
}

function unpublishAPaperFromSite()
{
    publishStatus
    printf "Enter the full name the paper to unpublish from site\n"
    read p_paper
    lockedFile=${p_paper[$i]::-4}
    if [ "$p_paper" != "$lockedFile.lock" ]
    then
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/published/$p_paper" ]]
            then
                sudo rm -v /var/www/html/live/$p_paper
            else
                sudo cp /var/www/html/live/$p_paper /var/www/html/published/
                sudo rm -v /var/www/html/live/$p_paper
            fi
        fi
    else
        printf "$p_paper is currently locked.\n"
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu
}

function unpublishAResearchPaper()
{
    publishStatus
    printf "Enter the full name the paper to unpublish\n"
    read p_paper
    lockedFile=${p_paper[$i]::-4}
    if [ "$p_paper" != "$lockedFile.lock" ]
    then
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/research/$p_paper" ]]
            then
                sudo rm -v /var/www/html/published/$p_paper
            else
                sudo cp /var/www/html/published/$p_paper /var/www/html/research/
                sudo rm -v /var/www/html/published/$p_paper
            fi
        fi
    else
        printf "$p_paper is currently locked.\n"
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu

}

#/**** SYSTEM HEALTH FUNCTIONS ****/

function systemHealth()
{
    printf "**Welcome to Research Manager**\n\n" 
    printf "System Health Check\n\n"
    printf "Please note a report has also been generated and stored in /var/www/html/logfiles/\n\n"
    printf "\n\nserver check:\n"
    #checking if Apache is running or not
    if ! pidof apache2 > /dev/null
    then
        printf " apache web server is down, trying auto-restart. please wait...\n"
        # web server down, restart the server
        sudo /etc/init.d/apache2 restart > /dev/null
        sleep 10
        #checking if apache restarted or not
        if pidof apache2 > /dev/null
        then
            printf " apache restarted successfully at: http://127.0.0.1/\n"
            serverPath="/var/www/" #now we get a path to it, for later
        else
            printf " apache is not running. check if installed and try running\n"
            printf " sudo apt-get update\n"
            printf " sudo apt-get install apache2\n\n"
            exit
        fi
    else
        printf " Apache is running.\n"
        serverPath="/var/www/html" #now we get a path to it, for later
    fi
    read -n 1 -s -r -p "Press any key to continue"
    #folder health
    printf "**Welcome to Research Manager**\n\n" 
    printf "System Health Check\n\n"
    printf "folder health:\n"
    researchFolders=('live', 'research', 'published', 'logfiles', 'backups',)
    numFolders=${#researchFolders[@]}
    for (( i=0; i<numFolders; i++))
    do
        folderName=${researchFolders[$i]::-1} # need -1 to remove comma
        #simple check if folder exists and create if not
        if [ -d "$serverPath/$folderName" ] 
        then
            printf " folder: $folderName ok\n"
        else
            printf " folder: $folderName :does not exist\n"
        fi
    done
    read -n 1 -s -r -p "Press any key to continue"
    scheduleStatus
    read -n 1 -s -r -p "Press any key to continue"
    viewAllLogs
    read -n 1 -s -r -p "Press any key to continue"
    listResearchers
    read -n 1 -s -r -p "Press any key to continue"
    publishStatus
    read -n 1 -s -r -p "Press any key to continue"
    printf "hardware health:\n"
    vmstat
    read -n 1 -s -r -p "Press any key to continue"

}
function systemHealthReport()
{
    printf "generating system health report\n"
    printf "report can be found in /var/www/html/logfiles/\n"
    printf "errors/issues: \n"
    DATE=$(date +"%d-%b-%Y")
    printf $DATE >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    printf "System Health CheReport\n\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt

    printf "\n\nserver check:\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    #checking if Apache is running or not
    if ! pidof apache2 > /dev/null
    then
        printf " apache web server is down, trying auto-restart. please wait...\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
        # web server down, restart the server
        sudo /etc/init.d/apache2 restart > /dev/null
        sleep 10
        #checking if apache restarted or not
        if pidof apache2 > /dev/null
        then
            printf " apache restarted successfully at: http://127.0.0.1/\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
            serverPath="/var/www/" #now we get a path to it, for later
        else
            printf " apache is not running. check if installed and try running\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
            printf " sudo apt-get update\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
            printf " sudo apt-get install apache2\n\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
            exit
        fi
    else
        printf " Apache is running.\n" >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
        serverPath="/var/www/html" #now we get a path to it, for later
    fi
    #folder health
    printf "**Welcome to Research Manager**\n\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    printf "System Health Check\n\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    printf "folder health:\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    researchFolders=('live', 'research', 'published', 'logfiles', 'backups',)
    numFolders=${#researchFolders[@]}
    for (( i=0; i<numFolders; i++))
    do
        folderName=${researchFolders[$i]::-1} # need -1 to remove comma
        #simple check if folder exists and create if not
        if [ -d "$serverPath/$folderName" ] 
        then
            printf " folder: $folderName ok\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
        else
            printf " folder: $folderName :does not exist\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
        fi
    done
    scheduleStatus  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    viewAllLogs  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    listResearchers  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    publishStatus  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    printf "hardware health:\n"  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt
    vmstat  >> /var/www/html/logfiles/systemhealthreport-$DATE.txt

}

#/**** MENU FUNCTIONS ****/
function ScheduleMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "SCHEDULE MENU\n\n"
    #select loop
    select choice in View-Schedule Manual-Schedule-Publish Manual-Schedule-Backup Manual-Schedule-Log Back
    do
        case $choice in
        View-Schedule)
            clear
            scheduleStatus 
            read -n 1 -s -r -p "Press any key to return to the Schedule Menu"
            ScheduleMenu;;
        Manual-Schedule-Publish)
            clear
            nightlyPublish
            read -n 1 -s -r -p "Press any key to return to the Schedule Menu"
            ScheduleMenu;;
        Manual-Schedule-Backup)
            clear
            nightlyBackup
            read -n 1 -s -r -p "Press any key to return to the Schedule Menu"
            ScheduleMenu;;
        Manual-Schedule-Log)
            clear
            nightlyLog
            read -n 1 -s -r -p "Press any key to return to the Schedule Menu"
            ScheduleMenu;;
        Back)
            clear
            MainMenu;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}
function LogMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "lOG MENU\n\n"
    #select loop
    select choice in View-All-Logs View-Log Search-Log Generate-Logs Back
    do
        case $choice in
        View-All-Logs )
            clear
            viewAllLogs 
            read -n 1 -s -r -p "Press any key to return to the Log Menu"
            LogMenu;;
        View-Log)
            clear
            viewLog;;
        Search-Log)
            clear
            searchLog;;
        Generate-Logs)
            clear
            generateLogFiles;;
        Back)
            MainMenu;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}

function ResearchMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "RESEARCH MENU\n\n"
    #select loop
    select choice in Publish-Status Search-Papers Publish-A-Research-Paper Publish-A-Paper-To-Site Unpublish-A-Research-Paper Unpublish-A-Paper-From-Site Back
    do
        case $choice in
        Publish-Status)
            clear
            publishStatus
            read -n 1 -s -r -p "Press any key to return to the Research Menu"
            ResearchMenu;;
        Search-Papers)
            clear
            searchPapers
            read -n 1 -s -r -p "Press any key to return to the Research Menu"
            ResearchMenu;;
        Publish-A-Research-Paper)
            clear
            publishAResearchPaper;;
        Publish-A-Paper-To-Site)
            clear
            publishAPaperToSite;;
        Unpublish-A-Research-Paper)
            clear
            unpublishAResearchPaper;;
        Unpublish-A-Paper-From-Site)
            clear
            unpublishAPaperFromSite;;
        Back)
            clear
            MainMenu;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}

function GroupMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "GROUP MENU\n\n"
    #select loop
    select choice in List Add Remove Back
    do
        #gives options automatically
        #echo "You have selected $car"
        case $choice in
        List)
            clear
            listResearchers #d.r.y here by reusing list researchers
            read -n 1 -s -r -p "Press any key to return to the Main Menu"
            GroupMenu;;
        Add)
            clear
            addResearcherToGroup;;
        Remove)
            clear
            removeResearcherFromGroup;;
        Back)
            clear
            UserMenu;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}

function UserMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "GROUP MENU\n\n"
    #select loop
    select choice in List Add Delete Groups Back
    do
        #gives options automatically
        #echo "You have selected $car"
        case $choice in
        List)
            clear
            listResearchers
            read -n 1 -s -r -p "Press any key to return to the Main Menu"
            UserMenu;;
        Add)
            clear
            createResearcher;;
        Delete)
            clear
            deleteResearcher;;
        Groups)
            clear
            GroupMenu;;
        Back)
            clear
            MainMenu;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}

function MainMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "MAIN MENU\n\n"
    #select loop
    select choice in Users Research Logs Schedules Backup Health Setup Exit
    do
        #gives options automatically
        #echo "You have selected $car"
        case $choice in
        Users)
            clear
            UserMenu;;
        Research)
            clear
            ResearchMenu;;
        Logs)
            clear
            LogMenu;;
        Schedules)
            clear
            ScheduleMenu;;
        Backup)
            clear
            backupWebsite
            read -n 1 -s -r -p "Press any key to return to the Menu Menu"
            MainMenu;;
        Health)
            clear
            systemHealth
            systemHealthReport
            MainMenu;;
        Setup)
            clear
            SetupResearchSystem;;
        Exit)
            clear
            echo "exited Research Manager..." && exit;;
        *)
            clear
            echo "Please select a valid option."
        esac
    done
}

MainMenu #main function to start the program and show the menu
