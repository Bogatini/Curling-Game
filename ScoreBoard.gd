extends PopupDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func display_scores(blueScore, redScore):
	var text = "Red Score: " + str(redScore) + "\n" + "Blue Score: " + str(blueScore) + "\n"
	
	if blueScore > redScore:
		text += "Blue Wins!"
	elif blueScore < redScore:
		text += "Red Wins!"
	else:
		text += "It's a tie!"
	
	# display scores in the middle of the label
	$Label.text = text
	$Label.align = Label.ALIGN_CENTER
