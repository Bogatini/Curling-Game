extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.is_in_group("Stone"): # if the object is a stone that can have its friction changed
		
		# https://www.omnicalculator.com/math/right-triangle-side-angle
		
		# difficult bit ************
		# ended up not having to do trig tho
		
		var centreVector = self.global_position.direction_to(body.global_position)
		var perpendicularVector = Vector2(centreVector.y * -1, centreVector.x)
		
		var vel = body.linear_velocity
		var perpendicularVel = vel.dot(perpendicularVector) # get dot product of the vectors
		
		var force = (perpendicularVector * -1) * (10 * perpendicularVel) # artificially increase the sideways force
		
		# if the entry angle isnt taken into account if the stone goes straight into a rough patch it will just speed up
		var entryAngle = cos(centreVector.angle_to(vel)) # get entry angle of the stone
														 # cosine is used here because i want stones coming in at steeper angles to be affected by the force more
														 # the entry angle can vary between 0 and 90 degrees. on a cos graph this translates to between 1 and 0
														 # this value can then be multiplied with the intended force to scale it
														
		var angularMultiplier = clamp(entryAngle, 0.2, 1.0) # Limit impulse based on entry angle
		
		body.apply_central_impulse(force * angularMultiplier) # apply the calculated force
		
		body.apply_torque_impulse(force.length())
		
		body.setFricitonValue(0.05)
		

func _on_Area2D_body_exited(body):
	if body.is_in_group("Stone"): # once the stone leaves the area, change the friction back to normal
		body.setFricitonValue(body.basicFrictionValue)
