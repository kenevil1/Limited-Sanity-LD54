extends StaticBody3D

var total_time = 0
var fade_speed = 6
var alarm_enabled = false
var idle_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alarm_enabled:
		alarm_going(delta)
	else:
		$AlarmSound.stop()
		alarm_idle(delta)

func alarm_idle(delta):
	total_time += delta * idle_speed
	if total_time > PI: total_time = 0
	$AlarmOmniLight.light_energy = sin(total_time)

func alarm_going(delta):
	total_time += delta * fade_speed
	if total_time > PI: total_time = 0
	$AlarmOmniLight.light_energy = sin(total_time)
