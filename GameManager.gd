extends Node2D

# global vals here
enum GameState {
	Start,
	Play,
	Finish,
	WaitToClose
}

var CurrentGameState = GameState.Start

var blueScore = 0
var redScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	match CurrentGameState:
		GameState.Start: # the game has started
			pass
		GameState.Play:
			if get_tree().get_nodes_in_group("Player").size() <= 0: # all stones have been thrown
				CurrentGameState = GameState.Finish			
			
		GameState.Finish:
			var target = get_tree().get_nodes_in_group("Target")[0]
			
			var redTeamArray = get_tree().get_nodes_in_group("Red")
			var blueTeamArray = get_tree().get_nodes_in_group("Blue")

			for stone in redTeamArray:
				var distance = (target.targetPos - stone.global_position).length()
				
				
				if distance < 50:
					GameManager.redScore += 10
				elif distance < 100:
					GameManager.redScore += 5
				elif distance < 150:
					GameManager.redScore += 2
			
			for stone in blueTeamArray:
				var distance = (target.targetPos - stone.position).length()

				if distance < 50:
					GameManager.blueScore += 10
				elif distance < 100:
					GameManager.blueScore += 5
				elif distance < 150:
					GameManager.blueScore += 2
								
			var scoreBoard = get_tree().get_nodes_in_group("Label")[0]
			
			scoreBoard.popup()
			scoreBoard.display_scores(blueScore, redScore)
			
			CurrentGameState = GameState.WaitToClose

		GameState.WaitToClose:
			pass # the scoreboard will remain untill the user closes the app
	pass
