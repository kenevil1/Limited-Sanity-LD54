extends RigidBody3D

@export var player: Node3D

var in_bin = []

@export var pick_up_point: Node3D = null
@export var pickup_force = 5

var dialogue_text = ""

var joke_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(in_bin)
	if rad_to_deg(player.global_transform.basis.z.angle_to((player.global_position - global_position).normalized())) > 90 and len(in_bin) > 0:
		for i in in_bin:
			i.queue_free()
			in_bin.remove_at(in_bin.find(i))
		$ThrowAwayEffect.play()
	
	if pick_up_point != null:
		var dir_vec3 = pick_up_point.global_position - global_position
		linear_velocity = dir_vec3.normalized() * pickup_force * dir_vec3.length()

func use_item(pickup_point):
	if pick_up_point == null:
		on_pickup(pickup_point)
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

func _on_detect_body_entered(body):
	if body.is_in_group('Item'):
		in_bin.append(body.get_parent())
	

func _on_detect_body_exited(body):
	if body.is_in_group('Item'):
		in_bin.remove_at(in_bin.find(body.get_parent()))
	if body.is_in_group('Player') and joke_done == false:
		body.get_tree().call_group("Dialogue", "display_text", "Alright, enough cosplaying as Oscar the Grouch")
		joke_done = true
