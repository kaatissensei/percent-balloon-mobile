extends Node

const colors: Array[String] = ["Blue", "Green", "Orange", "Pink", "Purple", "Red", "Sky_Blue", "Yellow"] #Cyan
var randColor
const top_bpr: int = 15 #balloons per row
const rows: int = 7
const num_balloons: int = 100
const num_teams: int = 6
var balloons = [] #array of all balloons
#var balloonsArray = [] #array of above
var remainingBalloons: Array = []  #array with unpopped balloons. balloon removed when "popped"
var remainingArray: Array[Array] = [] #array of remainingBalloons[] for each team
var result_balloons : Array[Array] = []
var remaining_result_balloons : Array[Array] = []
var guesses = [] #[0] = team1, etc.
var answer
var numToPop = []
var currentTeam = 0
const bob_speed: float = 2.5
const bob_height: float = 5.0
const bob_width: float = 5.0
const textureLoc = "res://images/balloons/"
var textureName
const BALLOON = preload("res://balloon.tscn")
const BALLOON_LOCAL = preload("res://balloon_local.tscn")
const scale: float = 0.8
var percent_mode = true

var num_questions : int = 10
var questions : Array[String] = []
var answers : Array[int] = []
var question_num : int = 1   #Current question number
var falls : Array[int] = []
var csvFile
var csvArray = []
var trigger_restore : bool = false
var trigger_fall : Array[bool]
var demo_csv

@onready var redBalloon = preload("res://images/balloons/balloonRedSm.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	questions.resize(num_questions)
	answers.resize(num_questions)
	
	clear_team_array(guesses)
	clear_team_array(numToPop)
	clear_team_array(falls)
	
	trigger_fall.resize(num_teams)
	trigger_fall.fill(false)
	
	result_balloons.resize(num_teams)

func clear_team_array(array : Array, value = 0):
	array.resize(num_teams)
	array.fill(value)

func build_remaining_array():
	for i in range(num_teams):
		remainingArray.append(remainingBalloons.duplicate(true))

func build_remaining_result_balloons():
	pass

func set_guess(val: int, team_num : int = currentTeam):
	guesses[team_num] = val
	
func get_guess(team_num: int):
	return guesses[team_num]
	
func set_num_to_pop(teamNum: int, val: int):
	numToPop[teamNum] = val
	
func get_num_to_pop(i: int):
	return numToPop[i]

func set_answer(val: int):
	answer = val
	
func get_answer():
	return answer

func get_rand_balloon(teamNum: int):
	var balloonNum = randi_range(0,remainingArray[teamNum].size() - 1)
	return remainingArray[teamNum][balloonNum]

func get_rand_balloons(teamNum: int):
	var balloonNum = randi_range(0,remainingArray[teamNum].size() - 1)
	var remArray_balloon = remainingArray[teamNum][balloonNum]
	var rrb = remaining_result_balloons[teamNum][balloonNum]
	return [remArray_balloon, rrb]

func set_current_team(teamNum: int):
	currentTeam = teamNum

func get_current_team():
	return currentTeam

func clear_questions():
	questions.clear()
	answers.clear()
	questions.resize(num_questions)
	answers.resize(num_questions)

func parse_csv():
	var csv_line_len = 2 #number of elements per csv line
	clear_questions()
	csvArray.clear()
	while csvFile.get_position() < csvFile.get_length():
		var csvLine = csvFile.get_csv_line()
		csvArray.push_back(csvLine)
	csvArray.pop_front() #removes title

	for i in range(csvArray.size()):
		var arr = csvArray.slice(i,i+csv_line_len)[0]
		#Assign variables here
		questions[i] = arr[0]
		answers[i] = int(arr[1])

func parse_csv_string():
	var comma_pos : int
	var split_by_line = csvFile.split("\n")
	#var csv_questions : Array[Array]
	questions.clear()
	answers.clear()
	for q in split_by_line:
		comma_pos = q.rfind(",")
		questions.push_back(q.substr(0,comma_pos))
		answers.push_back(int(q.substr(comma_pos + 1)))
	#Remove headers
	questions.pop_front()
	answers.pop_front()
	
func fullscreen():
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

func switch_percent_mode(tf : bool):
	percent_mode = tf

func reset():
	#Reset remainingBalloons
	remainingBalloons.clear()
	remainingArray.clear()
	remainingBalloons = balloons.duplicate(true)
	#for balloon in balloons:
	#	remainingBalloons.append(balloon)
	build_remaining_array()
	#Reset other arrays
	clear_team_array(guesses)
	clear_team_array(numToPop)
	clear_team_array(falls)
	clear_team_array(trigger_fall, false)
	reset_rrb()
	
	set_current_team(0)

func restore_remaining(team_num : int):
	var new_remBal = balloons.duplicate(true)
	remainingArray[team_num].clear()
	remainingArray[team_num] = new_remBal
	remaining_result_balloons[team_num].clear()
	remaining_result_balloons[team_num] = result_balloons[team_num].duplicate(true)

func reset_rrb():
	#remaining_result_balloons.clear()
	remaining_result_balloons = result_balloons.duplicate(true)

func fall(team_num : int):
	falls[team_num] += 1

func get_falls(team_num : int):
	return falls[team_num]

##Saving
func save():
	var save_dict = {
		"questions" : questions,
		"answers" : answers
	}
	return save_dict

func save_JSON():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	# Call the node's save function.
	var node_data = call("save")

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(node_data)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func load_JSON():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		clear_questions()
		questions.assign(node_data["questions"])
		answers.assign(node_data["answers"])
		
func load_demo_csv() :
	demo_csv = "Question,Answer
What percent of students like science?,66
What percent play games?,81
What percent play the piano?,25
What percent said their favorite fruit is apples?,18
What percent said their favorite sport was soccer?,27
What percent watch TV every day?,61
What percent study English every day?,4
What percent have only one sibling?,48
What percent eat breakfast every day?,80
What percent never read books?,18"
	csvFile = demo_csv
	#parse_csv_string()
