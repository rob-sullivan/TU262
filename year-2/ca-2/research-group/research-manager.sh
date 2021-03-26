#! /bin/bash

function welcome() {
    clear
    printf "**Welcome to Research Manager**\n\n"    
}

function checkServer(){
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
        else
            printf " apache is not running. check if installed and try running\n"
            printf " sudo apt-get update\n"
            printf " sudo apt-get install apache2\n\n"
            exit
        fi
    else
        printf " Apache is running.\n"
    fi
}
#used during startup check to create a html file if one doesn't exist
function setupHtmlFile() {
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
		    <td>Alfreds Futterkiste</td>
		    <td>Maria Anders</td>
		    <td>Germany</td>
		</tr>
		<tr>
		    <td>Centro comercial Moctezuma</td>
		    <td>Francisco Chang</td>
		    <td>Mexico</td>
		</tr>
		<tr>
		    <td>Ernst Handel</td>
		    <td>Roland Mendel</td>
		    <td>Austria</td>
		</tr>
		<tr>
		    <td>Island Trading</td>
		    <td>Helen Bennett</td>
		    <td>UK</td>
		</tr>
		<tr>
		    <td>Laughing Bacchus Winecellars</td>
		    <td>Yoshi Tannamuri</td>
		    <td>Canada</td>
		</tr>
		<tr>
		    <td>Magazzini Alimentari Riuniti</td>
		    <td>Giovanni Rovelli</td>
		    <td>Italy</td>
		</tr>
        </table>
    </body>
</html>
EOT
sudo mv index.html $htmlPath/index.html
printf " file: index.html created\n"
}

#used during startup check to copy over demo papers
function setupDemoPapers(){

    dest=$1
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

#do a check and see if system is setup correctly.
function checkSetup()
{
    printf "running demo setup:\n"

    #first we check if apache is running. 
    checkServer

    #now we get a path to it, for later
    serverPath="/var/www/"

    #the following will be our demo folders
    :-'
        html - apache server generated folder
        research - where our pdf papers will be unpublished
        published - where our published papers will be copied to site
        logfiles - different log files for admins
        backups - backups of html website and papers
    '
    researchFolders=('html', 'research', 'published', 'logfiles', 'backups')

    #the following will be our demo users
    :-'
        Sarah Conor # chief researcher
        Miles Dyson
        Jon Conor
    '
    researchers={'sarah', 'miles', 'jon'}

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
    
    #now check for index.html and create if not
    htmlFolder=${researchFolders[0]::-1}

    if [ -f "$serverPath$htmlFolder/index.html" ]
    then
        echo " file: index.html ok"
    else
        #little more complex but all we are doing
        #is creating a html file via a function
        # we pass in the html path as an arg
        htmlPath=$serverPath$htmlFolder
        setupHtmlFile $htmlPath
    fi

    #so far so good, now we copy over our demo papers to research folder
    researchFolder=${researchFolders[1]::-1}
    setupDemoPapers $serverPath$researchFolder/


    #create group, create users and set access
    folderName=${researchFolders[1]::-1} #research set to shared
    sudo chmod -R 770 $serverPath$folderName # root, groups can rwx world cannot

    #group setup
    if [ $(getent group r_group) ]; then
        echo "group exists."
        sudo addgroup r_group #we create our research group
        sudo chgrp -R r_group $serverPath$folderName
        sudo stfacl -dR -m g:r_group:rwx $serverPath$folderName
    else
        echo "group does not exist."
        sudo chgrp -R r_group $serverPath$folderName
        sudo stfacl -dR -m g:r_group:rwx $serverPath$folderName
    fi

    #check if users exist and added to group
    numrusers=${#researchers[@]}
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

    #set all other folders to private


    printf "\demo setup complete.\n\n"

    printf "site live at: http://127.0.0.1/\n\n"
}

#main function that runs and controls the program 
function main() {
    welcome
    checkSetup
}

#main #starts the manager

if [ $(getent group r_group) ]; then
  echo "group exists."
else
  echo "group does not exist."
fi