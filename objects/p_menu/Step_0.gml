/// @description Control the Button

if(alarm[0] > -1) exit;

if(global.game_state != GameStates.PAUSE) && (image_alpha > 0)
{
	// update controls
	controlsCount = ds_list_size(controlsList)
	if(controlsCount > 0)
	{
		for(var i=0; i<controlsCount; i++)
		{
			var _ctrl = controlsList[| i];
			_ctrl.Update();
		}
	}
}
