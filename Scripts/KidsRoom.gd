extends Node3D

var passed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(len($Chest/StaticBody3D.in_chest))
	if len($Chest/StaticBody3D.in_chest) >= 4 and $Lid/StaticBody3D.door_open == false and passed == false:
		passed = true
		$Door/DoorStatic.can_open = true
		$KnockingAudio.play()
