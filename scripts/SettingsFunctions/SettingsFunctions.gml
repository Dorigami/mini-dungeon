function settings_create_config(){
	var _s = {}
	var _key_values = [
		["fullscreen", 0],
		["resolution", settings_determine_resolution()],
		["aspect_ratio", 16/9],
		["music_volume", 0.5],
		["sfx_volume", 0.5],
	];
	// set the struct values, then return
	for(var i=0; i<array_length(_key_values); i++){
		_s[$ _key_values[i][0]] = _key_values[i][1];
	}
	return _s;
}
function settings_determine_resolution(){
	with(o_engine){
		return [0, 480, 360]; // the first element is the index where this resolution came from
		//return [0, 960, 720];
	}
}
function settings_load_from_config(){
	/*
	if(!os_is_html5){
		var _json, _file, _filename = working_directory + "settings.cfg";
		if(!file_exists(_filename)){ settings_create_config() }
		_file = file_text_open_read(_filename);
		_json = json_parse(file_text_read_string(_file));
		file_text_close(_file);
		return _json;
	} else {
	*/
		// get the default settings struct from the create settings function
		return settings_create_config(false);
	//}
}
function settings_save_to_config(){
	if(os_is_html5) exit;
	var _file = file_text_open_write(working_directory+"settings.cfg");
	file_text_write_string(_file, json_stringify(settings));
	file_text_close(_file);
}
function settings_enforce_values(){
	if(os_is_html5) exit;
	var _settings, _file, _filename = working_directory + "settings.cfg";
	// get the settings from the file
	if(!file_exists(_filename)){ settings_create_config() }
	_file = file_text_open_read(_filename);
	_settings = json_parse(file_text_read_string(_file));
	file_text_close(_file);
	
	// restrict values to acceptable ranges
	_settings.sfx_volume = clamp(_settings.sfx_volume,0,100);
	_settings.music_volume = clamp(_settings.music_volume,0,100);
	_settings.game_speed = round(clamp(_settings.game_speed,1,5));
	
	// set the settings
	global.i_engine.settings = _settings;
	global.i_sound.set_music_volume(_settings.music_volume);
	global.i_sound.set_sfx_volume(_settings.sfx_volume);
	if(_settings.fullscreen != window_get_fullscreen()){ window_set_fullscreen(_settings.fullscreen) }
	
	InitializeDisplay();
}