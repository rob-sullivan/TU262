#! /bin/bash

#function to list all, add or delete users $1 is command, $2 is user's name
function People(){ 
    #list all users
    if [ "$1" == "list" ]
    then
        printf "Current Users:\n"
        for user in $( cd /home/ && ls )
        do
            echo " user: $user"
        done
    #add user
    elif [ "$1" == "add" ]
    then
        
        for user in $( cd /home/ && ls )
        do
            if [ "$user" == "$2"]
            then
                echo " user: $user exists"
            else
                sudo useradd -m $2
                echo " user: $user created"
            fi
        done
    #remove user
    elif [ "$1" == "remove" ]
    then
        sudo userdel -r $2
    else
        printf " Only the following allowed:\n"
        printf "  people list\n"
        printf "  people add [name]\n"
        printf "  people remove [name]\n"
    fi
}

function Welcome() {
    clear
    printf "**Welcome to Research Manager**\n\n"    
}

#used during startup check this function checks if apache is installed and running if it's not we give user 
#some info on how to do it and if it is installed but not running we try run it.
function CheckServer(){
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
            printf " apache restarted successfully\n"
            serverPath="/var/www/" #now we get a path to it, for later
        else
            printf " apache is not running. check if installed and try running\n"
            printf " sudo apt-get update\n"
            printf " sudo apt-get install apache2\n\n"
            exit
        fi
    else
        printf " Apache is running.\n"
        serverPath="/var/www/" #now we get a path to it, for later
    fi
}

function SetupDemoFolders(){
    #the following will be our demo folders
    #html - apache server generated folder
    #research - where our pdf papers will be unpublished
    #published - where our published papers will be copied to site
    #logfiles - different log files for admins
    #backups - backups of html website and papers

    researchFolders=('html', 'research', 'published', 'logfiles', 'backups')
    #first we setup our folders by doing a check and create if not found
    numFolders=${#researchFolders[@]}

    #this for loop checks all our folders 
    #if we added more it would check those too
    for (( i=0; i<numFolders; i++))
    do
        folderName=${researchFolders[$i]::-1} # need -1 to remove comma

        #simple check if folder exists and create if not
        if [ -d "$serverPath$folderName" ] 
        then
            printf " folder: $folderName ok\n"
        else
            sudo mkdir -p $serverPath$folderName
            printf " folder: $folderName :created\n"
        fi
    done
}

#used during startup check to create a html file if one doesn't exist
function SetupDemoHtmlFile() {
    #now check for index.html and create if not
    htmlFolder=${researchFolders[0]::-1}

    if [ -f "$serverPath$htmlFolder/index.html" ]
    then
        echo " file: index.html ok"
    else
        #little complex but all we are doing here
        #is creating the content of a html file
        # we pass in the html path as an arg
        htmlPath=$serverPath$htmlFolder
        cat <<EOT >> index.html
<!DOCTYPE html>
<html>
    <head>
        <style>
        table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
        }

        td, th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
        }

        tr:nth-child(even) {
        background-color: #dddddd;
        }
        </style>
        <title>The Research Portal</title>
    </head>

    <body>
        <h2>Published Research</h2>

        <table>
		<tr>
		    <th>Date</th>
		    <th>Paper Title</th>
		    <th>Author(s)</th>
		</tr>
		<tr>
		    <td>2015</td>
		    <td>ADAM : A Method For Stocastic Optimization</td>
		    <td>Diederik P. Kingma & Jimmy Lei Ba</td>
		</tr>
		<tr>
		    <td>2016</td>
		    <td>Asynchronous Methods for Deep Reinforcement Learning</td>
		    <td>Volodymyr Mnih et Al</td>
		</tr>
		<tr>
		    <td>2016</td>
		    <td>High Dimensional Continuous Control Using Generalized Advantage Estimation</td>
		    <td>John Schulman et Al</td>
		</tr>
		<tr>
		    <td>20019</td>
		    <td>Markov Decision Processes</td>
		    <td>Martijn van Otterlo</td>
		</tr>
        </table>
    </body>
</html>
EOT
        sudo mv index.html $htmlPath/index.html
        printf " file: index.html created\n"
    fi
 
}

#used during startup check to copy over demo papers
function SetupDemoPapers(){
    #so far so good, now we copy over our demo papers to research folder
    researchFolder=${researchFolders[1]::-1}
    dest=$serverPath$researchFolder/

    cd demo-papers/

    for file in $( ls )
    do
        if [ -f  $dest/$file ] ; then
            printf " file: $file ok\n"
        else
            sudo cp $file  $dest${file}
            printf " file: $file copied\n"
        fi
    done
    cd ..
    
}

function SetupDemoUsers(){
    #the following will be our demo users who will be researchers
    #Sarah Conor # chief researcher
    #Miles Dyson
    #Jon Conor
    researchers=('sarah', 'miles', 'jon')
    numrusers=${#researchers[@]}

    for (( i=0; i<numrusers; i++))
    do
        r_user=${researchers[$i]::-1}
        sudo useradd -m $r_user
    done
}

function SetupDemoGroup(){
    #create group, create users and set access
    folderName=${researchFolders[1]::-1} #research set to shared
    sudo chmod -R 770 $serverPath$folderName # root, groups can rwx world cannot
    #group setup
    if [ $(getent group r_group) ]; then
        echo "group exists."
        sudo chgrp -R r_group $serverPath$folderName
        sudo stfacl -dR -m g:r_group:rwx $serverPath$folderName
    else
        echo "group does not exist."
        sudo addgroup r_group #we create our research group
        sudo chgrp -R r_group $serverPath$folderName
        sudo stfacl -dR -m g:r_group:rwx $serverPath$folderName
    fi

    #check if users exist and added to group
    for (( i=0; i<numrusers; i++))
    do
        if id "$i" >/dev/null 2>&1; then
            echo "user: $i exists"
            #add users to group
            sudo usermod -a -G r_research $i
        else
            echo "user: $i does not exist"
        fi
    done
}
#do a check and see if system is setup correctly.
function Setup()
{
    printf "running demo setup:\n"
    #CheckServer #first we check if apache is running. Then get path to server 
    #SetupDemoFolders #then we setup our folders
    #SetupDemoHtmlFile # we check and setup our demo website
    #SetupDemoPapers # we copy over papers to our research folder
    SetupDemoUsers
    #SetupDemoGroup
    #set all other folders to private
    printf "demo setup complete.\n\n"
    printf "site live at: http://127.0.0.1/\n\n"
    read -n 1 -s -r -p "Press any key to continue"
    Menu
}

function UserMenu()
{
    Welcome #show title and clear screen
    #select loop
    select choice in List Add Delete Groups Back
    do
        #gives options automatically
        #echo "You have selected $car"
        case $choice in
        List)
            Welcome #show title and clear screen
            People list
            read -n 1 -s -r -p "Press any key to continue"
            UserMenu;;
        Add)
            Welcome #show title and clear screen
            printf "enter name of user to add\n"
            read newUser
            People "add" $newUser
            read -n 1 -s -r -p "Press any key to continue"
            UserMenu;;
        Delete)
            echo "Delete";;
        Groups)
            echo "Groups";;
        Back)
            Main;;
        *)
            echo "Please select a valid option."
        esac
    done
}

function MainMenu()
{
    Welcome #show title and clear screen
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
            Setup;;
        Exit)
            echo "exiting..." && exit;;
        *)
            echo "Please select a valid option."
        esac
    done
}
#main function that runs and controls the program 
function Main() {
    Welcome
    MainMenu
}

Main #starts the manager
#
