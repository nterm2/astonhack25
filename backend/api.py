from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import database
parser = reqparse.RequestParser()
parser.add_argument('task')
app = Flask(__name__)
api = Api(app)

class Results(Resource):
    def get(self):
        return getResultsData(), 200  

    def post(self):
        data = request.get_json()
        if not data:
            return {"error": "Invalid input, expected JSON"}, 400

        try:
            reactionScore = data["reactionScore"]
            memoryScore = data["memoryScore"]
            psychometricScore = data["psychometricScore"]
            AIScore = data["AIScore"]
            AIResult = data["AIResult"]

            database.insertResults(reactionScore, memoryScore, psychometricScore, AIScore, AIResult)
            return {"message": "Results inserted successfully"}, 201  
        except KeyError as e:
            return {"error": f"Missing field: {str(e)}"}, 400  

class LatestResults(Resource):
    def get(self):
        return database.getLatestResults()

class WeekAverage(Resource):
    def get(self):
        return database.getWeekAverage()

class OverallProgress(Resource):
    def get(self):
        return database.getOverallProgress()

class Streak(Resource):
    def get(self):
        return database.getStreak()

class ResultsData(Resource):
    def get(self):
        return database.getResultsData()

class StreakData(Resource):
    def get(self):
        return database.getStreakData()

api.add_resource(Results, '/')
api.add_resource(LatestResults, '/get-latest-results')
api.add_resource(WeekAverage, '/get-week-average')
api.add_resource(OverallProgress, '/get-overall-progress')
api.add_resource(Streak, '/get-streak')
api.add_resource(ResultsData, '/get-results-data')
api.add_resource(StreakData, '/get-streak-data')

if __name__ == '__main__':
    app.run(debug=True)