#! /bin/bash

#Assumptions:
    #The research group only has one server, running Apache as the webserver. 
    #All changes made to the site will be in /var/www/html and assumed to appear on the website instantly.
    #Backups will be made to the backups folder on the server
    #The research group already exists
    #Users have an accounts on the server, they can login and make changes to the shared research directory(folder).
    #All changes will be made under their user accounts. e.g su username
    #Folder structure:
        #research
        #published
        #html
        #logfiles
        #backups


#to install server - https://phoenixnap.com/kb/how-to-install-apache-web-server-on-ubuntu-18-04
 # sudo apt-get update
 # sudo apt-get install apache2
 # type this in browser: http://local.server.ip
 # hostname -I | awk '{print $1}' to find
 # sudo ufw show app list
 # sudo ufw allow 'Apache'
 # sudo ufw status

 # apache server control
 # sudo systemctl stop apache2.service
 # sudo systemctl start apache2.service
 # sudo systemctl restart apache2.service
 # sudo systemctl reload apache2.service

#/**** SCHEDULE FUNCTIONS ****/
function scheduleStatus()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "SCHEDULE STATUS\n\n"
    crontab -l
    read -n 1 -s -r -p "Press any key to return to the Main Menu"
    MainMenu

}

function nightlyPublish()
{
    printf "scheduling nightly 2am publish\n"
    #check job not already in place 
    #write out current crontab and echo new cron into cron file
    crontab -l | grep -q 'publishAllToSite'  && echo 'nightly schedule exists already' || echo "00 02 * * * root ./research-manager.sh && publishAllToSite" >> tempCron
    crontab -l > tempCron
    
    
    #install new cron file
    crontab tempCron
    rm tempCron
}

function nightlyBackup()
{
    printf "scheduling nightly backup\n"
    #check job not already in place 
    #write out current crontab and echo new cron into cron file
    crontab -l | grep -q 'backupWebsite'  && echo 'nightly schedule exists already' || echo "00 02 * * * root ./research-manager.sh && backupWebsite" >> tempCron
    crontab -l > tempCron
    #install new cron file
    crontab tempCron
    rm tempCron
}

function nightlyLog()
{
    printf "scheduling nightly logfiles\n"
    #write out current crontab
    crontab -l > tempCron
    #echo new cron into cron file
    echo "01 02 * * * root ./research-manager.sh && generateLogFiles" >> tempCron
    #install new cron file
    crontab tempCron
    rm tempCron
}

#/**** BACKUP FUNCTIONS ****/
function backupWebsite()
{
    printf "making a backup of files\n"
    DATE=$(date +"%d-%b-%Y")
    sudo tar -zcvf website-$DATE.tgz /var/www/html
    sudo mv *.tgz /var/www/html/backups/
}

#/**** LOGGING FUNCTIONS ****/
function viewAllLogs()
{
    clear
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
    grep $searchTerm /var/www/html/logfiles/$logfile.txt
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

function SetupResearchSystem(){

    #show title and clear screen
    clear
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
                sudo chmod -R 744 $serverPath/$folderName # rootcan rwx, groups can r--, world cannot
                #put a watch on dir -w is watch -p is options w r x a(append)
                sudo auditctl -w $serverPath/$folderName -p wrxa
                printf " folder: $folderName ok\n"
            else
                sudo mkdir -p $serverPath/$folderName
                sudo chown root:r_group $serverPath/$folderName
                #here we set all folders to be private
                sudo chmod -R 744 $serverPath/$folderName # root can rwx, groups can r--, world cannot
                #put a watch on dir -w is watch -p is options w r x a(append)
                sudo auditctl -w $serverPath/$folderName -p wrxa
                printf " folder: $folderName :created\n"
            fi
        done

        #here we set the research folder to be a shared folder
        folderName=${researchFolders[1]::-1}
        sudo chmod -R 777 $serverPath/$folderName # root, groups, world can rwx

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

        #SETUP LOGFIES
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
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "List Researchers\n\n"
    printf "Current Researcher:\n"
    for user in $( cd /home/ && ls )
    do
        printf " User: $user, Groups:" && id $user
    done
    read -n 1 -s -r -p "Press any key to return to the Main Menu"
    MainMenu
}

#This is to create a new researcher
function createResearcher()
{
    #show title and clear screen
    clear
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
    clear
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
    clear
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
    clear
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
    for p_paper in $( ls /var/www/html/research/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/published/$p_paper" ]]
            then
                sudo rm -v /var/www/html/research/$p_paper
            else
                sudo cp /var/www/html/research/$p_paper /var/www/published/
                sudo rm -v /var/www/html/research/$p_paper
            fi
        fi
    done
    printf "\n"
}

function publishAllToSite()
{
    for p_paper in $( ls /var/www/html/published/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/live/$p_paper" ]]
            then
                sudo rm -v /var/www/html/published/$p_paper
            else
                sudo cp /var/www/html/published/$p_paper /var/www/html/live/
                sudo rm -v /var/www/html/published/$p_paper
            fi
        fi
    done
    printf "\n"
}

function unpublishAllFromSite()
{
    for p_paper in $( ls /var/www/html/live/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/published/$p_paper" ]]
            then
                sudo rm -v /var/www/html/published/$p_paper
            else
                sudo cp /var/www/html/live/$p_paper /var/www/html/published/
                sudo rm -v /var/www/html/live/$p_paper
            fi
        fi
    done
    printf "\n"

}

function unpublishAllResearch()
{
    for p_paper in $( ls /var/www/published/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/research/$p_paper" ]]
            then
                sudo rm -v /var/www/html/published/$p_paper
            else
                sudo cp /var/www/html/published/$p_paper /var/www/html/research/
                sudo rm -v /var/www/html/published/$p_paper
            fi
        fi
    done
    printf "\n"

}

#/**** PUBLISH PAPER MANUAL FUNCTIONS ****/
function publishStatus()
{
    #show title and clear screen
    clear
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
function publishAResearchPaper()
{
    publishStatus
    printf "Enter the full name the paper to publish\n"
    read p_paper
    if [ "$p_paper" != "index.html" ]
    then
        if [[ -f "/var/www/html/published/$p_paper" ]]
        then
            sudo rm -v /var/www/html/research/$p_paper
        else
            sudo cp /var/www/html/research/$p_paper /var/www/html/published/
            sudo rm -v /var/www/html/research/$p_paper
        fi
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
    if [ "$p_paper" != "index.html" ]
    then
        if [[ -f "/var/www/html/live/$p_paper" ]]
        then
            sudo rm -v /var/www/html/published/$p_paper
        else
            sudo cp /var/www/html/published/$p_paper /var/www/html/live/
            sudo rm -v /var/www/html/published/$p_paper
        fi
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
    if [ "$p_paper" != "index.html" ]
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
    if [ "$p_paper" != "index.html" ]
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
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu

}
schedule
#/**** MENU SYSTEMs ****/
function ScheduleMenu()
{
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "lOG MENU\n\n"
    #select loop
    select choice in View-All-Logs View-Log Search-Log Generate-Logs Back
    do
        case $choice in
        View-Schedule )
            viewAllLogs 
            read -n 1 -s -r -p "Press any key to return to the Research Menu"
            LogMenu;;
        View-Log)
            viewLog;;
        Search-Log)
            searchLog;;
        Generate-Logs)
            generateLogFiles;;
        Back)
            MainMenu;;
        *)
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
            viewAllLogs 
            read -n 1 -s -r -p "Press any key to return to the Research Menu"
            LogMenu;;
        View-Log)
            viewLog;;
        Search-Log)
            searchLog;;
        Generate-Logs)
            generateLogFiles;;
        Back)
            MainMenu;;
        *)
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
    select choice in Publish-Status Publish-A-Research-Paper Publish-A-Paper-To-Site Unpublish-A-Research-Paper Unpublish-A-Paper-From-Site Back
    do
        case $choice in
        Publish-Status)
            publishStatus
            read -n 1 -s -r -p "Press any key to return to the Research Menu"
            ResearchMenu;;
        Publish-A-Research-Paper)
            publishAResearchPaper;;
        Publish-A-Paper-To-Site)
            publishAPaperToSite;;
        Unpublish-A-Research-Paper)
            unpublishAResearchPaper;;
        Unpublish-A-Paper-From-Site)
            unpublishAPaperFromSite;;
        Back)
            MainMenu;;
        *)
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
            listResearchers;; #d.r.y here by reusing list researchers
        Add)
            addResearcherToGroup;;
        Remove)
            removeResearcherFromGroup;;
        Back)
            UserMenu;;
        *)
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
            listResearchers;;
        Add)
            createResearcher;;
        Delete)
            deleteResearcher;;
        Groups)
            GroupMenu;;
        Back)
            MainMenu;;
        *)
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
            UserMenu;;
        Research)
            ResearchMenu;;
        Logs)
            LogMenu;;
        Schedules)
            scheduleStatus;;
        Backup)
            backupWebsite;; 
        Health)
            echo "Schedules";; #system health menu.
        Setup)
            SetupResearchSystem;;
        Exit)
            clear
            echo "exited Research Manager..." && exit;;
        *)
            echo "Please select a valid option."
        esac
    done
}

#MainMenu #main function to start the program and show the menu
scheduleStatus