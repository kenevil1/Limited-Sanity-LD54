extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var capture_mouse = true
var sensitivity = 0.005

@export var grabbed_object: Node3D = null

var play_fov_effect = false
var goal_fov = 1
var goal_tp_point : Node3D = null


func drop_current_object():
	if grabbed_object != null:
		grabbed_object.on_drop()
		grabbed_object = null

func door_check():
	if $Head/Camera3D/LookingCast.get_collider().is_in_group("Door"):
		$Head/Camera3D/LookingCast.get_collider().toggle_door()

func alarm_check():
	if $Head/Camera3D/LookingCast.get_collider().is_in_group("Alarm"):
		$Head/Camera3D/LookingCast.get_collider().alarm_enabled = false
		$Head/Camera3D/UI/Dialogue.display_text("Thank god, that alarm was killing me")

func item_check():
	if $Head/Camera3D/LookingCast.get_collider().is_in_group("Item") and is_on_floor():
		if $Head/Camera3D/LookingCast.get_collider() == grabbed_object:
			drop_current_object()
			return
		drop_current_object()
		grabbed_object = $Head/Camera3D/LookingCast.get_collider()
		grabbed_object.use_item($Head/Camera3D/PickupPoint)
		if grabbed_object.dialogue_text != "":
			$Head/Camera3D/UI/Dialogue.display_text(grabbed_object.dialogue_text)
			
func objectdialogue_check():
	if $Head/Camera3D/LookingCast.get_collider().is_in_group("ObjectDialogue"):
		if $Head/Camera3D/LookingCast.get_collider().dialogue_text != "" and $Head/Camera3D/LookingCast.get_collider().can_speak:
			$Head/Camera3D/UI/Dialogue.display_text($Head/Camera3D/LookingCast.get_collider().dialogue_text)

func looking_check(delta):
	if $Head/Camera3D/LookingCast.get_collider() != null and Input.is_action_just_released("use") and len($Head/Camera3D/LookingCast.get_collider().get_groups()) > 0:
		door_check()
		alarm_check()
		item_check()
		objectdialogue_check()

func teleport_effect_logic(delta):
	$Head/Camera3D.fov = lerpf($Head/Camera3D.fov, goal_fov, delta * 5)
	
	if $Head/Camera3D.fov < 5:
		position = goal_tp_point.position
		goal_tp_point = null
		$Head/Camera3D.fov = 10
		goal_fov = 75

func play_teleport_effect(lore_teleport_point):
	play_fov_effect = true
	goal_fov = 1
	goal_tp_point = lore_teleport_point

func _process(delta):
	if play_fov_effect:
		teleport_effect_logic(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		capture_mouse = !capture_mouse
		
	if capture_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	looking_check(delta)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		drop_current_object()

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = ($Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion && capture_mouse:
		$Head.rotate_y(-event.relative.x * sensitivity)
		$Head/Camera3D.rotate_x(-event.relative.y * sensitivity)
		$Head/Camera3D.rotation.x = clamp($Head/Camera3D.rotation.x, deg_to_rad(-80), deg_to_rad(90))
