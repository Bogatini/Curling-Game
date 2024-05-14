extends RigidBody2D

enum stoneState{
	notThrown,
	thrown
}
var state = stoneState.notThrown
var basicFrictionValue = 0.025
var frictionVal = basicFrictionValue


func setFricitonValue(value):
	frictionVal = value

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = RigidBody2D.MODE_KINEMATIC
	mass = 10
	bounce = 0.25
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# apply friction
	var vel = get_linear_velocity()
	var frictionVector = (vel * -1) * frictionVal
	self.apply_central_impulse(frictionVector)
	
	
	# dealing with when the stone has stopped
	if state == stoneState.thrown && linear_velocity <= Vector2(2,2): # if the stone has been thrown and its slow enough
		# wait 4 seconds after the stone has been thrown to do anything
		var timer = Timer.new()
		timer.set_wait_time(4)
		timer.set_one_shot(true) # dont make it start again
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		var thrower = get_tree().get_nodes_in_group("Thrower")[0]
		
		thrower.throwerState = thrower.throwerStates.reload
		self.remove_from_group("Player") # removes the current stone from the "Player" group meaning player[0] now points to the next stone to be thrown
		set_process_input(false) # the stone cannot take any inputs and is fully inactive, but is still affected by physics
		state = stoneState.notThrown

func throwStone():
	mode = RigidBody2D.MODE_RIGID
	state = stoneState.thrown
	pass
