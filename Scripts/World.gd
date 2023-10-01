extends Node3D

@export var player: Node3D
@export var lore_door: Node3D
@export var false_wall: Node3D

var false_wall_keep_check = false

var first_lore_item_found = false

var lore_fail = false
var one_time_fail_message_check = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player/Head
	false_wall = $FalseWall
	lore_door = $Doors/Door

func first_lore_item_found_logic():
	lore_door.visible = true
	$Doors/Door/DoorStatic.can_open = true
	lore_door.process_mode = Node.PROCESS_MODE_INHERIT
	
	false_wall.visible = false
	false_wall.process_mode = Node.PROCESS_MODE_DISABLED

func lore_item_to_room():
	var familyframe = get_tree().get_nodes_in_group("FamilyFrame")
	var greenalcohol = get_tree().get_nodes_in_group("GreenAlcohol")
	var packingbox = get_tree().get_nodes_in_group("PackingBox")
	
	if len(familyframe) == 0 or len(greenalcohol) == 0 or len(packingbox) == 0:
		lore_fail = true
		return
	
	if $FamilyFrame/RigidBody3D.pick_up_point != null or $GreenAlcohol/RigidBody3D.pick_up_point != null or $PackingBox/RigidBody3D.pick_up_point != null and first_lore_item_found == false:
		first_lore_item_found_logic()
		first_lore_item_found = true
		
	if $FamilyFrame/RigidBody3D.pick_up_point != null:
		$FalseWall.visible = false
		$Doors/Door/DoorStatic.can_open = true
		$KidsRoomStorage.process_mode = Node.PROCESS_MODE_DISABLED
		$KidsRoomStorage.visible = false
		$FathersCouch.process_mode = Node.PROCESS_MODE_DISABLED
		$FathersCouch.visible = false
		$KidsRoom.process_mode = Node.PROCESS_MODE_INHERIT
		$KidsRoom.visible = true
		
	if $PackingBox/RigidBody3D.pick_up_point != null:
		$FalseWall.visible = false
		$Doors/Door/DoorStatic.can_open = true
		$KidsRoom.process_mode = Node.PROCESS_MODE_DISABLED
		$KidsRoom.visible = false
		$FathersCouch.process_mode = Node.PROCESS_MODE_DISABLED
		$FathersCouch.visible = false
		$KidsRoomStorage.process_mode = Node.PROCESS_MODE_INHERIT
		$KidsRoomStorage.visible = true
		
	if $GreenAlcohol/RigidBody3D.pick_up_point != null:
		$FalseWall.visible = false
		$Doors/Door/DoorStatic.can_open = true
		$KidsRoom.process_mode = Node.PROCESS_MODE_DISABLED
		$KidsRoom.visible = false
		$KidsRoomStorage.process_mode = Node.PROCESS_MODE_DISABLED
		$KidsRoomStorage.visible = false
		$FathersCouch.process_mode = Node.PROCESS_MODE_INHERIT
		$FathersCouch.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func one_time_fail_message():
	$Player.get_tree().call_group("Dialogue", "display_text", "With this item's disposal, the thread of prophecy is severed.")
	one_time_fail_message_check = true

func _physics_process(delta):
	if false_wall_keep_check:
		false_wall_check()
	
	if lore_fail and one_time_fail_message_check == false:
		one_time_fail_message()
	
	lore_item_to_room()

func _on_start_button_up():
	$StartScreen/Camera3D.current = false
	$StartScreen.visible = false
	$StartScreen.process_mode = Node.PROCESS_MODE_DISABLED
	
	$StartScreen/Camera3D/Control.visible = false
	$StartScreen/Camera3D/Control.process_mode = Node.PROCESS_MODE_DISABLED
	
	$Player.process_mode = Node.PROCESS_MODE_INHERIT
	$Player/Head/Camera3D.current = true
	
	$Lights/AlarmLight.alarm_enabled = true
	$Lights/AlarmLight/AlarmSound.play()

func _on_quit_button_up():
	get_tree().quit()


func false_wall_check():
	if rad_to_deg(player.global_transform.basis.z.angle_to((player.global_position - lore_door.global_position).normalized())) > 100:
		lore_door.visible = false
		$Doors/Door/DoorStatic.close_door()
		$Doors/Door/DoorStatic.can_open = false
		lore_door.process_mode = Node.PROCESS_MODE_DISABLED
		
		false_wall.visible = true
		false_wall.process_mode = Node.PROCESS_MODE_INHERIT

func _on_lore_room_detector_body_entered(body):
	if body.is_in_group('Player'):
		false_wall_keep_check = true
		if rad_to_deg(player.global_transform.basis.z.angle_to((player.global_position - lore_door.global_position).normalized())) > 100 and lore_door.visible == true:
			lore_door.visible = false
			$Doors/Door/DoorStatic.close_door()
			$Doors/Door/DoorStatic.can_open = false
			lore_door.process_mode = Node.PROCESS_MODE_DISABLED
			
			false_wall.visible = true
			false_wall.process_mode = Node.PROCESS_MODE_INHERIT
		


func _on_lore_room_detector_body_exited(body):
	if body.is_in_group('Player'):
		false_wall_keep_check = false
		lore_door.visible = true
		lore_door.process_mode = Node.PROCESS_MODE_INHERIT
		
		false_wall.visible = true
		false_wall.process_mode = Node.PROCESS_MODE_DISABLED
