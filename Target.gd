extends Node2D

var targetPos

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = $Centre.global_position

func _on_LargeRing_body_entered(body):
	if body.is_in_group("Stone"): # if the object is a stone
		body.setFricitonValue(0.04) # arbitrary

func _on_LargeRing_body_exited(body):
	if body.is_in_group("Stone"):
		body.setFricitonValue(body.basicFrictionValue)
