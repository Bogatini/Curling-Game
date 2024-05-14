extends Node2D

var Test = preload("res://RoughIce.tscn")

var canPlace = true
var timer = Timer.new()

func _ready():
	# the timer starts when a patch is placed and prevents more patches from being placed dependitn on wait_time
	self.add_child(timer)
	timer.wait_time = 0.5
	timer.connect("timeout", self, "_on_Timer_timeout")

# when the timer finishes, do this:
func _on_Timer_timeout():
	canPlace = true


func _input(event):
	var thrower = get_tree().get_nodes_in_group("Thrower")[0]
	
	# if the stone has been thrown, check if the player is pressing the left mouse button
	if canPlace and Input.is_action_pressed("Left_Mouse") and thrower.throwerState == thrower.throwerStates.stoneThrown:
		var mousePos = get_global_mouse_position()
		
		# create a new rough patch of ice and place it at the cursor
		var newPatch = Test.instance()
		add_child(newPatch)
		newPatch.position = mousePos
		
		canPlace = false
		timer.start()
