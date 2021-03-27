#! /bin/bash

#Assumptions
#The research group only has one server
#The Ubuntu server is running Apache as the webserver. 
#All changes made to the site will be in /var/www/html and assumed to appear on the website instantly.
#Backups will be made to the backups folder on the server
#The research group already exists
#Users have an accounts on the server, they can login and make changes to the shared research directory(folder).
#All changes will be made under their user accounts. 

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
        printf "server check:\n"
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

        #SETUP FOLDERS
        printf "folder setup:\n"
        #the following will be our research folders
        #html - apache server generated folder
        #research - where our pdf papers will be unpublished
        #published - where our published papers will be copied to site
        #logfiles - different log files for admins
        #backups - backups of html website and papers
        researchFolders=('html', 'research', 'published', 'logfiles', 'backups',)
        #first we setup our folders by doing a check and create if not found
        numFolders=${#researchFolders[@]}

        #this for loop checks all our folders 
        #if we added more it would check those too
        for (( i=0; i<numFolders; i++))
        do
            folderName=${researchFolders[$i]::-1} # need -1 to remove comma

            #simple check if folder exists and create if not
            if [ -d "$serverPath/$folderName" ] 
            then
                printf " folder: $folderName ok\n"
            else
                sudo mkdir -p $serverPath/$folderName
                printf " folder: $folderName :created\n"
            fi
        done

        #SETUP GROUP
        printf "group setup:\n"
        #create group, create users and set access
        folderName=${researchFolders[1]::-1} #research set to r_group ownership
        sudo chmod -R 770 $serverPath/$folderName # root, groups can rwx world cannot
        #we check if the research group already exists
        if [ $(getent group r_group) ]; then
            printf " r_group exists. setting permissions\n"
            sudo chgrp -R r_group $serverPath/$folderName
            #sudo stfacl -dR -m g:r_group:rwx $serverPath/$folderName
        else
            printf " r_group doesn't exist. creating and setting permissions\n"
            sudo addgroup r_group #we create our research group
            sudo chgrp -R r_group $serverPath/$folderName
            #sudo stfacl -dR -m g:r_group:rwx $serverPath/$folderName
        fi

        #SETUP RESEARCHERS
        printf "researcher setup:\n"
        #the following will be our researchers (including us)
        #Sarah Conor # chief researcher
        #Miles Dyson
        #Jon Conor
        #su in as one of these users. eg su sarah
        researchers=('sarah', 'miles', 'jon',)
        numrusers=${#researchers[@]}

        for (( i=0; i<numrusers; i++))
        do
            r_user=${researchers[$i]::-1}
            printf " $r_user setup attempt.\n"
            sudo useradd -m $r_user #we will let linux check if they exist
            #userOwner groupOwner
        done
        printf "finsihed setup commands...\n\n"
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

    #we list all the researchers before we change anything one to 
    #remind user the names to use
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " User: $user, Groups:" && id $user
    done
    printf "Enter the name of new researcher to delete\n"
    read newUser
    sudo userdel -r $newUser
    printf "Researchers:\n"
    for user in $( cd /home/ && ls )
    do
        printf " User: $user, Groups:" && id $user
    done
    read -n 1 -s -r -p "Press any key to return to the Group Menu"
    GroupMenu
}
function removeResearcherFromGroup(){
    echo "test"
}

#/**** MENU SYSTEM ****/
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
    select choice in Users Logs Setup Exit
    do
        #gives options automatically
        #echo "You have selected $car"
        case $choice in
        Users)
            UserMenu;;
        Logs)
            echo "Logs";;
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

#MainMenu
SetupResearchSystem