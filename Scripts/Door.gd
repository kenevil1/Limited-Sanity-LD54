extends StaticBody3D

var door_open = false
@export var can_open = true

@export var lore_teleport_point : Node3D = null
@export var player : Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open_door():
	$AnimationPlayer.play("Open")
	$DoorOpenAudio.play()
	door_open = true

func close_door():
	$AnimationPlayer.play_backwards("Open")
	$DoorCloseAudio.play()
	door_open = false

func lore_teleport():
	player.play_teleport_effect(lore_teleport_point)
	#player.position = lore_teleport_point.position

func toggle_door():
	if can_open:
		if lore_teleport_point != null:
			lore_teleport()
			return
			
		if door_open:
			close_door()
		else:
			open_door()
	else:
		$DoorLockedAudio.play()
