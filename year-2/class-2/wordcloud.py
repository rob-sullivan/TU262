import string # string.punctuation '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
#allchar = string.ascii_letters + string.punctuation + string.digits
#we create our dictionary and two functions to get data from it and to add data to it.
wordCloud = {}
def setWordCloudValue(key, value):
    wordCloud[key] = value

def getWordCloudValue(key):
    return wordCloud[key]

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
                    if char != "—": #remove this char (not in punctuation)
                        parsedWord += char
            wordCloud[parsedWord] = len(parsedWord)

def writeFile(fileName, word_cloud):
    currentFile = open(fileName, 'w', encoding="utf-8")
    print(""" 
            <!DOCTYPE html>
            <html>
                <head lang="en">
                    <meta charset="UTF-8">
                    <title>Tag Cloud Generator</title>
                </head>
                <body>
                    <div style="text-align: center; vertical-align: middle; font-family: arial; color: white; background-color:black; border:1px solid black">
                    <!-- Generated Word Cloud -->
            """, file=currentFile)
    print("                    " + wordCloudEncoder(word_cloud), file=currentFile)
    print(""" 
                </body>
            </html>
    """, file=currentFile)
    currentFile.close()

def wordCloudEncoder(d):
    htmlWordCloud = ""
    for key in d:
        htmlWordCloud += "<span style='font-size:" + str(d[key]*10) + "px'>" + key + "</span><br />"
    return(htmlWordCloud)


readFile("gettysburg.txt")
writeFile("gettysburg.html", wordCloud)
