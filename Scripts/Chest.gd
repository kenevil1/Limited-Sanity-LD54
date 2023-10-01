extends StaticBody3D

var in_chest = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group('Item'):
		in_chest.append(body.get_parent())


func _on_area_3d_body_exited(body):
	if body.is_in_group('Item'):
		in_chest.remove_at(in_chest.find(body.get_parent()))
