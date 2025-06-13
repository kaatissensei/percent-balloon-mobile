extends MultiMeshInstance2D

var colors = ["Blue", "Cyan", "Green", "Orange", "Pink", "Purple", "Red", "Sky_Blue", "Yellow"]
var bob_height: float = 5.0
var bob_width: float = 3.0
var bob_speed: float = 3.0

@onready var start_position: Vector2 =  global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randColor
	var bpr = 15 #balloons per row
	var rows = 7
	for x in range(bpr):
		for y in range(rows):
			if (y*bpr + x) < 100:
				var rnd = randi_range(-5,5)
				self.multimesh.set_instance_transform_2d(y*bpr + x, Transform2D(deg_to_rad(180 + rnd), Vector2((100+x * 65) + rnd, 100+y * 55 + rnd) )) #2d(instance int, transform2d(rot, trans)
				#self.multimesh.set z_index = rnd
				randColor = colors[randi() % colors.size()]
				self.multimesh.set_instance_color(y*bpr + x, Color.from_string(randColor, Color.RED))
				#self.multimesh.color_array = colors
				#WIP - How do I keep the white parts of the texture white

func _physics_process(delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	#rotate
	#self.scale.x = sin(time * rotate_speed)
	
	#bob up and down
	var y_pos 	= ((1+sin(time * bob_speed)) / 2) * bob_height
	global_position.y = start_position.y - y_pos
	
	var x_pos = ((1+cos(time * bob_speed)) / 2) * bob_width
	global_position.x = start_position.x - x_pos
