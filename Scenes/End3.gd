extends Node3D

@export var player: Node3D
var it_begun = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group('Player') and it_begun != true:
		it_begun = true
		body.get_tree().call_group("Dialogue", "display_text", "You confronted yourself and your past, but yet you do nothing for your future. Odd")
		$SecondDia.start()


func _on_timer_timeout():
	player.get_tree().call_group("Dialogue", "display_text", "Feel free to indulge then, I won't stop you, Pity")
	$End.start()


func _on_end_timeout():
	get_tree().quit()
