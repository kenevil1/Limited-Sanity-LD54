extends RigidBody3D

@export var dialogue_text = ""
var dialogue_used = false

@export var pick_up_point: Node3D = null
@export var pickup_force = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pick_up_point != null:
		var dir_vec3 = pick_up_point.global_position - global_position
		linear_velocity = dir_vec3.normalized() * pickup_force * dir_vec3.length()
		
func use_item(node3d_point):
	if pick_up_point == null:
		on_pickup(node3d_point)
	else:
		on_drop()

func on_pickup(node3d_point):
	### basically sets the hands node to allow for pickup
	pick_up_point = node3d_point
	gravity_scale = 0
	angular_damp = 20

func on_drop():
	pick_up_point = null
	gravity_scale = 1
	angular_damp = 0
