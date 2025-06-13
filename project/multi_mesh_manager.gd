class_name MultiMeshManager extends MultiMeshInstance2D

var retired_ids: Array[int] = []
var screen_size = Vector2(1920, 1080)
var aabb: AABB = AABB(Vector3.ZERO, Vector3(screen_size.x, screen_size.y, 0))



func _ready() -> void:
	multimesh.instance_count = 100
	multimesh.visible_instance_count = 100

func register_instance(node: Node2D) -> int:
	if not retired_ids.is_empty():
		var id: int = retired_ids.pop_front()
		multimesh.set_instance_color(id, Color.WHITE)
		return id
	var id: int = multimesh.visible_instance_count
	multimesh.visible_instance_count += 1
	multimesh.set_instance_color(id, Color.WHITE)
	return id
	
func remove_instance(node: Node2D) -> void:
	retired_ids.append(node.instance_id)
	multimesh.set_instance_color(node.instance_id, Color.TRANSPARENT)
	multimesh.set_instance_transform_2d(node.instance_id, Transform2D(.8, Vector2(1.3, 1.4), .54, Vector2(2000000, 2000000)))
	
