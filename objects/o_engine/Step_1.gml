/// @description run game

// game update loop
if(global.game_state != GameStates.PAUSE)
{
	// do the general update
	with(p_entity){ Update() }
}

