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
function scheduleStatus(){
    #show title and clear screen
    clear
    printf "**Welcome to Research Manager**\n\n" 
    printf "SCHEDULE STATUS\n\n"
    crontab -l
    read -n 1 -s -r -p "Press any key to return to the Main Menu"
    MainMenu

}

function nightlyPublish(){
    #write out current crontab
    crontab -l > tempCron
    #echo new cron into cron file
    echo "00 02 * * * root ./research-manager.sh && publishAllToSite" >> tempCron
    #install new cron file
    crontab tempCron
    rm tempCron
}

function backup(){
    DATE=$(date +"%d-%b-%Y")
    sudo tar -zcvf website-$DATE.tgz /var/www/html
    sudo mv *.tgz /var/www/backups/
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
            serverPath="/var/www" #now we get a path to it, for later
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

        #SETUP FOLDERS
        printf "\n\nfolder setup:\n"
        #the following will be our research folders
        #html - apache server generated folder
        #research - where our pdf papers will be unpublished
        #published - where our published papers will be copied to site
        #logfiles - different log files for admins
        #backups - backups of html website and papers
        researchFolders=('html', 'research', 'published', 'logfiles', 'backups',)
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
                printf " folder: $folderName ok\n"
            else
                sudo mkdir -p $serverPath/$folderName
                sudo chown root:r_group $serverPath/$folderName
                #here we set all folders to be private
                sudo chmod -R 744 $serverPath/$folderName # root can rwx, groups can r--, world cannot
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

        #first lets make us and admin(root) a researcher if not done already
        sudo usermod -aG r_group root
        sudo usermod -aG r_group $USERNAME
        printf "root and $USERNAME:\n"
        printf " root and $USERNAME may need to re-login for group settings to take effect\n\n"
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
    for p_paper in $( ls /var/www/research/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/published/$p_paper" ]]
            then
                sudo rm -v /var/www/research/$p_paper
            else
                sudo cp /var/www/research/$p_paper /var/www/published/
                sudo rm -v /var/www/research/$p_paper
            fi
        fi
    done
    printf "\n"
}

function publishAllToSite()
{
    for p_paper in $( ls /var/www/published/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/html/$p_paper" ]]
            then
                sudo rm -v /var/www/published/$p_paper
            else
                sudo cp /var/www/published/$p_paper /var/www/html/
                sudo rm -v /var/www/published/$p_paper
            fi
        fi
    done
    printf "\n"
}

function unpublishAllFromSite()
{
    for p_paper in $( ls /var/www/html/ )
    do
        if [ "$p_paper" != "index.html" ]
        then
            if [[ -f "/var/www/published/$p_paper" ]]
            then
                sudo rm -v /var/www/html/$p_paper
            else
                sudo cp /var/www/html/$p_paper /var/www/published/
                sudo rm -v /var/www/html/$p_paper
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
                sudo rm -v /var/www/published/$p_paper
            else
                sudo cp /var/www/published/$p_paper /var/www/research/
                sudo rm -v /var/www/published/$p_paper
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
    for r_paper in $( ls /var/www/research/ )
    do
        printf " Paper: $r_paper\n"
    done
    printf "\n"
    printf "Published Research Papers:\n"
    for p_paper in $( ls /var/www/published/ )
    do
        printf " Paper: $p_paper\n"
    done
    printf "\n"
    printf "Live on Website:\n"
    for p_paper in $( ls /var/www/html/ )
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
        if [[ -f "/var/www/published/$p_paper" ]]
        then
            sudo rm -v /var/www/research/$p_paper
        else
            sudo cp /var/www/research/$p_paper /var/www/published/
            sudo rm -v /var/www/research/$p_paper
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
        if [[ -f "/var/www/html/$p_paper" ]]
        then
            sudo rm -v /var/www/published/$p_paper
        else
            sudo cp /var/www/published/$p_paper /var/www/html/
            sudo rm -v /var/www/published/$p_paper
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
            if [[ -f "/var/www/published/$p_paper" ]]
            then
                sudo rm -v /var/www/html/$p_paper
            else
                sudo cp /var/www/html/$p_paper /var/www/published/
                sudo rm -v /var/www/html/$p_paper
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
            if [[ -f "/var/www/research/$p_paper" ]]
            then
                sudo rm -v /var/www/published/$p_paper
            else
                sudo cp /var/www/published/$p_paper /var/www/research/
                sudo rm -v /var/www/published/$p_paper
            fi
        fi
    fi
    printf "\n"
    publishStatus
    read -n 1 -s -r -p "Press any key to return to the Research Menu"
    ResearchMenu

}

#/**** MENU SYSTEMs ****/
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
            echo "Logs";;
        Schedules)
            scheduleStatus;;
        Backup)
            backup;; 
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

MainMenu
