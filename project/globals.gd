extends Node

const colors = ["Blue", "Green", "Orange", "Pink", "Purple", "Red", "Sky_Blue", "Yellow"] #Cyan
var randColor
var top_bpr = 15 #balloons per row
var rows = 7
var num_balloons = 100
var balloonArray = [] #array of all balloons
var remainingBalloons = []  #array with unpopped balloons. balloon removed when "popped"
var guesses = [] #[0] = team1, etc.
var answer
var numToPop = []

var bob_speed: float = 2.5
var bob_height: float = 5.0
var bob_width: float = 5.0
var textureLoc = "res://images/balloons/"
var textureName
var BALLOON = preload("res://balloon.tscn")
var scale: float = 0.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guesses = [0,0,0,0,0,0,0,0]
	numToPop = [0,0,0,0,0,0,0,0]
	answer = 50

func set_guess(i: int, val: int):
	guesses[i] = val
	
func get_guess(i: int):
	return guesses[i]
	
func set_num_to_pop(i: int, val: int):
	numToPop[i] = val
	
func get_num_to_pop(i: int):
	return numToPop[i]

func set_answer(val: int):
	answer = val
	
func get_answer():
	return answer
	
func get_rand_balloon():
	var balloonNum = randi_range(0,remainingBalloons.size() - 1)
	return remainingBalloons[balloonNum]
