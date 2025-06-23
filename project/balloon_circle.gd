extends Node

#@onready var spawnArea = %CollisionShape2D.get_shape().size
#@onready var origin = self.global_position
var origin

var balloon_color : String #Color
var team_num : int
var ratio : float = 1
var balloon_size : int = 100
var balloon_scale : float
var radius : float = 200

var r : float = 0
var theta : float = 0
var num_rings : float = 5 #int?

func _ready() -> void:
	balloon_scale = 0.4 #Main.scale * ratio
	#var size : float = balloon_size * ratio
	
	await call_deferred("balloon_gen")
	#balloon_gen()

func get_position():
	pass

func gen_random_pos():
	var x = randf_range(-radius, radius) #(origin.x, spawnArea.x)
	var y_range = sqrt(pow(radius,2) - pow(x,2))
	var y = randf_range(-y_range, y_range)
	#print("Balloon at %d, %d" % [x,y])
	return Vector2(origin.x + x, origin.y + y)

func gen_balloon_circle():
	r = fmod(r + radius/num_rings, radius)
	theta = fmod(theta + 20, 360)
	var x = r * cos(deg_to_rad(theta))
	var y = r * sin(deg_to_rad(theta))
	return Vector2(origin.x + x, origin.y + y)

func balloon_gen(team_color : String = "Red"):	
	team_color = name.substr(13)
	team_num = int(get_parent().name.right(1))
	origin = self.global_position#self.global_position
	print(self.name + " at " + str(origin.x) + " " + str(origin.y))
#Create new balloon instance
	for i in range(100):
		var newBalloon = Main.BALLOON.instantiate()
		newBalloon.add_to_group("result_balloons")
		#add_child(newBalloon)
		#var rnd = randi_range(-10,10)
		#newBalloon.transform = 
		var new_pos = gen_balloon_circle()
		#print(new_pos)
		newBalloon.position = new_pos#gen_random_pos()
		#print(newBalloon.position)
		#Set balloon color
		balloon_color = team_color
			
		var textureName = Main.textureLoc + "balloon" + balloon_color + "Sm.png"
		newBalloon.texture = load(textureName)
		newBalloon.scale = Vector2(balloon_scale, balloon_scale)
		newBalloon.name = "Balloon" + str(i).pad_zeros(2)
		newBalloon.set_balloon_color(balloon_color)
		newBalloon.tied = false
		Main.result_balloons[team_num-1].append(newBalloon)
		add_child(newBalloon)
		#newBalloon.position = Vector2(300,300)#self.position#gen_balloon_circle()#gen_random_pos()
