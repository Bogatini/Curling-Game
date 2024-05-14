extends Node2D

enum throwerStates{
	idle,
	throwing,
	stoneThrown,
	reload
}

var throwerState
var throwingLine
var player
var startPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	throwerState = throwerStates.idle
	
	throwingLine = $ThrowingLine
	
	startPosition = $StartPoint.position
	
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.position = startPosition


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match throwerState:
		throwerStates.idle: # do nothing
			pass
		throwerStates.throwing:
			player = get_tree().get_nodes_in_group("Player")[0]
			
			if Input.is_action_pressed("Left_Mouse"): # points the aiming line in the correct direction
				var draggingPoint = get_global_mouse_position()
				
				if draggingPoint.distance_to(startPosition) > 150: # ANNOYING VECTOR MATHS##########
					#mousePos = mousePos.normalized() * 150 - old version, doesnt work if the start position is moved at all
					draggingPoint = (draggingPoint - startPosition).normalized() * 150
					draggingPoint += $StartPoint.position
					
				#player.position = draggingPoint
				
				# poing line in opposite direction
				draggingPoint.x = draggingPoint.x * -1
				draggingPoint.y = draggingPoint.y * -1
				throwingLine.points[0] = draggingPoint
				
			else: # player has let go of the stone
				var draggingPoint = get_global_mouse_position() # reinitialise location, the mouse will have one frame to move outside of the maximum throw amount but thats fine
				if draggingPoint.distance_to(startPosition) > 150: # ANNOYING VECTOR MATHS##########
					draggingPoint = draggingPoint.normalized() * 150 # wont work if the throwing point is moved from (0,0)
				
				var distance = draggingPoint.distance_to(startPosition)
				var vel = (startPosition - draggingPoint)
				
				player.throwStone()
				throwerState = throwerStates.stoneThrown
				player.apply_impulse(startPosition, vel/5 * distance) # empty vector is used because there is no offset
				
				# reset the arrow
				throwingLine.points[0] = startPosition
				throwingLine.points[1] = startPosition
				
				GameManager.CurrentGameState = GameManager.GameState.Play # tell the game manager the stone has been thrown
				
			
		throwerStates.stoneThrown:
			pass # do nothing
		throwerStates.reload:
			var stones = get_tree().get_nodes_in_group("Player")
			#print(stones[0])
			if stones.size() > 0:
				player = stones[0]
				$Tween.interpolate_property(player, "position", player.position, startPosition, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				if (player.global_position - startPosition).length() < 0.1: # if its slow enough
					throwerState = throwerStates.idle


func _on_GrabArea_input_event(viewport, event, shape_idx):
	if throwerState == throwerStates.idle && event is InputEventMouseButton: # add onther check?
		throwerState = throwerStates.throwing
