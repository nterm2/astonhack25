import sqlite3  
import json

# create table 
def createDatabase():
    connection = sqlite3.connect("database.db")
    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Results ( 
            day INTEGER PRIMARY KEY AUTOINCREMENT, 
            reactionTime FLOAT,  
            memoryMatch FLOAT, 
            psychometric FLOAT, 
            AIdetection FLOAT
        )          
    """)

    connection.close()

# insert game scores
def insertResults(reactionScore, memoryScore, psychometricScore, AIScore, AIResult):
    connection = sqlite3.connect("database.db")
    cursor = connection.cursor()

    if AIResult == "Drunk":
        AIScore = 100 - AIScore 

    cursor.execute(""" 
    INSERT INTO Results (reactionTime, memoryMatch, psychometric, AIdetection)
    VALUES (?, ?, ?, ?)
    """, (reactionScore, memoryScore, psychometricScore, AIScore))
    connection.commit() 
    connection.close()

# for visualisations on flutter

# for current day
def getLatestResults():
    connection = sqlite3.connect("database.db")
    cursor = connection.cursor()

    cursor.execute("SELECT * FROM Results ORDER BY day DESC LIMIT 1")
    latestDayResult = cursor.fetchone() 
    connection.close()
    return latestDayResult

# for last week 
def getWeekAverage():
    connection = sqlite3.connect("database.db")
    cursor = connection.cursor() 

    cursor.execute("""  
        SELECT 
            day, 
            (reactionTime + memoryMatch + psychometric + AIdetection) / 4 AS dayAverage 
        FROM (   
            SELECT * FROM Results ORDER BY day DESC LIMIT 7
        )
        ORDER BY day DESC
    """)


    latestWeekResults = cursor.fetchall()
    connection.close()
    return latestWeekResults

# get overall average 
def getOverallProgress(): 
    connection = sqlite3.connect("database.db") 
    cursor = connection.cursor()  

    cursor.execute("""    
        SELECT 
            AVG(reactionTime) AS averageReactionTime, 
            AVG(memoryMatch) AS averageMemoryMatch,  
            AVG(psychometric) AS averagePsychometric,
            AVG(AIdetection) AS averageAIdetection  
        FROM Results
    """)

    overallProgressResult = cursor.fetchone() 
    connection.close() 
    return overallProgressResult

# get day streak
def getStreak(): 
    connection = sqlite3.connect("database.db") 
    cursor = connection.cursor()  

    cursor.execute("""  
        SELECT day
        FROM Results     
        ORDER BY day DESC    
        LIMIT 1
    """)

    currentStreak = cursor.fetchone()

    connection.close()
    return currentStreak 

# convert data to json

# convert results data to json 
def getResultsData():
    latestDayResult = getLatestResults() 
    latestWeekResults = getWeekAverage() 
    overallProgressResults = getOverallProgress() 

    resultKeys = ["baseline", "todayReactionResult", "todayMemoryResult", "todayPsychometricResult", "todayAIResult",
                "weekDay1", "weekDay2", "weekDay3", "weekDay4", "weekDay5", "weekDay6", "weekDay7",
                "reactionAverage", "memoryAverage", "psychometricAverage", "AIAverage"]
    
    resultValues = [60]

    latestDayResult = latestDayResult[1:]

    # day result
    for value in latestDayResult:
        resultValues.append(value)

    # week result
    numberOfDays = len(latestWeekResults)
    for value in latestWeekResults:
        resultValues.append(value[1])

    for i in range(0, 7 - numberOfDays):
        resultValues.append("None")

    # overall progress
    for value in overallProgressResults:
        resultValues.append(value)

    jsonResultDictionary = dict(zip(resultKeys, resultValues))

    with open("jsonResultDictionary.json", "w") as jsonFile:
        json.dump(jsonResultDictionary, jsonFile, indent=4) 

# convert streak data to json 
def getStreakData():
    totalDays = getStreak()

    resultKeys = ["currentStreak"]
    resultValues = []

    for value in totalDays:
        resultValues.append(value)

    jsonResultDictionary = dict(zip(resultKeys, resultValues))

    with open("jsonStreakData.json", "w") as jsonFile: 
        json.dump(jsonResultDictionary, jsonFile, indent=4)

"""TESTING"""

"""
createDatabase() 

#insertResults(70, 70, 70, 70, "Sober")
#insertResults(80, 80, 80, 80, "Sober")
#insertResults(40, 40, 40, 60, "Drunk")
#insertResults(50, 50, 50, 50, "Drunk")
#insertResults(30, 30, 30, 70, "Drunk")
#insertResults(30, 30, 30, 70, "Drunk")
#insertResults(30, 30, 30, 70, "Drunk")
#insertResults(70, 70, 70, 70, "Sober")
#insertResults(70, 70, 70, 70, "Sober")
#insertResults(70, 70, 70, 70, "Sober")

print(getStreak())

print("\n")
print("\n")

print(getLatestResults())

print("\n")
print("\n")

print(getWeekAverage())

print("\n")
print("\n")

print(getOverallProgress())
"""