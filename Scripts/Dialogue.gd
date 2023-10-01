extends MarginContainer

@onready var label = $MarginContainer/DialogueText
@onready var letter_timer = $LetterTimer

const  MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

func _display_letter():
	label.text += text[letter_index]
	$NormalVoice.play()
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			letter_timer.start(punctuation_time)
		" ":
			letter_timer.start(space_time)
		_:
			letter_timer.start(letter_time)

func display_text(text_to_display):
	visible = true
	$BubbleTimer.stop()
	letter_index = 0
	text = text_to_display
	label.text = text_to_display
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	#if size.x > MAX_WIDTH:
	#	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	#	custom_minimum_size.y = size.y
		
	
	label.text = ""
	_display_letter()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	##display_text("This is my story fr fr")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_letter_timer_timeout():
	_display_letter()


func _on_finished_displaying():
	$BubbleTimer.start(2.5)


func _on_bubble_timer_timeout():
	visible = false
