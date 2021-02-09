import string # string.punctuation '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
#allchar = string.ascii_letters + string.punctuation + string.digits

stopWords = "ourselves hers between yourself but again there about once during out very having with they own an be some for do its yours such into of most itself other off is s am or who as from him each the themselves until below are we these your his through don nor me were her more himself this down should our their while above both up to ours had she all no when at any before them same and been have in will on does yourselves then that because what over why so can did not now under he you herself has just where too only myself which those i after few whom t being if theirs my against a by doing it how further was here than"
#we create our dictionary and two functions to get data from it and to add data to it.
wordCloudInc = {}
wordCloudExc = {}

def readFile(fileName):
    currentFile = open(fileName, 'r', encoding="utf-8")
    wordParser(currentFile)
    currentFile.close()

def wordParser(file):
    for line in file:
        words = line.split()
        for word in words:
            #remove special characters
            parsedWord = ""
            for char in word:
                if char not in string.punctuation:
                    if char == "—": #remove this char (not in punctuation)
                        parsedWord += " "
                    else:
                        parsedWord += char
            if parsedWord not in stopWords:
                wordCloudExc[parsedWord] = len(parsedWord)
            wordCloudInc[parsedWord] = len(parsedWord)

def writeFile(fileName, word_cloud_in, word_cloud_out):
    currentFile = open(fileName, 'w', encoding="utf-8")
    print(""" 
            <!DOCTYPE html>
            <html>
                <style>
                    * {
                    box-sizing: border-box;
                    }

                    body {
                    margin: 0;
                    font-family: Arial;
                    }

                    .header {
                    text-align: center;
                    padding: 32px;
                    }

                    .row {
                    display: -ms-flexbox; /* IE10 */
                    display: flex;
                    -ms-flex-wrap: wrap; /* IE10 */
                    flex-wrap: wrap;
                    padding: 0 4px;
                    }

                    /* Create four equal columns that sits next to each other */
                    .column {
                    -ms-flex: 25%; /* IE10 */
                    flex: 25%;
                    max-width: 25%;
                    padding: 0 4px;
                    }

                    .column img {
                    margin-top: 8px;
                    vertical-align: middle;
                    width: 100%;
                    }

                    /* Responsive layout - makes a two column-layout instead of four columns */
                    @media screen and (max-width: 800px) {
                    .column {
                        -ms-flex: 50%;
                        flex: 50%;
                        max-width: 50%;
                    }
                    }

                    /* Responsive layout - makes the two columns stack on top of each other instead of next to each other */
                    @media screen and (max-width: 600px) {
                    .column {
                        -ms-flex: 100%;
                        flex: 100%;
                        max-width: 100%;
                    }
                    }
                </style>

                <body>

                    <!-- Header -->
                    <div class="header">
                        <h1>Stop Words Included</h1>
                    </div>

                    <!-- Generated Word Cloud -->
                    <div style="text-align: center; vertical-align: middle; font-family: arial; color: white; background-color:black; border:1px solid black">
                        <div class="row"> 
                            <div class="column">""", file=currentFile)
    print("                    " + wordCloudEncoder(word_cloud_in), file=currentFile)
    print("""               </div>
                        </div>
                    </div>

                    <!-- Header -->
                    <div class="header">
                        <h1>Stop Words Removed</h1>
                    </div>

                    <!-- Generated Word Cloud -->
                    <div style="text-align: center; vertical-align: middle; font-family: arial; color: white; background-color:black; border:1px solid black">
                        <div class="row"> 
                            <div class="column">""", file=currentFile)
    print("                    " + wordCloudEncoder(word_cloud_out), file=currentFile)
    print("""               </div>
                        </div>
                    </div>
                </body>
            </html>
    """, file=currentFile)
    currentFile.close()

def wordCloudEncoder(d):
    x = 0
    htmlWordCloud = ""
    for key in d:
        if x % 6:
            htmlWordCloud += "</div><div class='column'>"
            htmlWordCloud += "<span style='font-size:" + str(d[key]*5) + "px'>" + key + "</span><br />"
        else:
            htmlWordCloud += "<span style='font-size:" + str(d[key]*5) + "px'>" + key + "</span><br />"
        x += 1
    return(htmlWordCloud)


readFile("gettysburg.txt")
writeFile("gettysburg.html", wordCloudInc, wordCloudExc)
