extends CharacterBody2D

var speed = 300
var moving : bool = false
var place : int = 0

func _ready() -> void:
	velocity.y = 0
	set_physics_process(false)

func start_moving():
	velocity.y = -100
	set_physics_process(true)

#func get_input():
#	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	velocity.y = -90
func set_place(place_num : int):
	place = place_num

func _physics_process(delta):
	#get_input()
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		get_child(0).text = str(place)
		velocity.y = 0
		if place == 1:
			%FinalScores.show_banner()
		#print(self.name, ": I somehow find %s and I collided" % collision.get_collider().name)
