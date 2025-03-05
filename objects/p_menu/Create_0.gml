/// @description Initialize
function SliderBarAdd(_x, _y, _cntr, _ind, _name, _title, _spr_slider, _spr_bar, _slider_prog, _min, _max, _width, _height, _scr, _scrArgs){
	var _newControl = new SliderBar();
	var _9s = sprite_get_nineslice(_spr_bar);
	// calculate required width/height, and respective scaling
	if(is_undefined(_width)){ _width = sprite_get_width(_spr_slider)*10 }
	if(is_undefined(_height)){ _height = sprite_get_height(_spr_slider) }
	
	// set new values
	with(_newControl)
	{
		container = _cntr;
		index = _ind;
		name = _name;
		title_text = _title
		spr_slider = _spr_slider;
		spr_bar = _spr_bar;
		slider_progress = _slider_prog;
		activationScript = _scr;
		activationScriptArgs = _scrArgs;
		width = _width;
		height = _height;
		xscale = _width / sprite_get_width(_spr_bar);
		yscale = _height / (sprite_get_height(_spr_bar) -_9s.top - _9s.bottom);
		slider_size = sprite_get_height(_spr_bar)*yscale -_9s.top - _9s.bottom;
		slider_scale = slider_size / sprite_get_height(_spr_slider);
		x = _x;
		y = _y;
		// determine start/end points for slider
		slider_half_size = slider_size div 2;
		slider_x1 = _9s.left;
		slider_x2 = _width - slider_size - _9s.right;
		slider_y1 = _9s.top;
		slider_len = slider_x2 - slider_x1;
		slider_min = is_undefined(_min) ? 0 : _min;
		slider_max = is_undefined(_max) ? 100 : _max;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
SliderBar = function() constructor{
	container = noone;
	index = -1;
	name = "";
	spr_slider = -1;
	spr_bar = -1;
	slider_progress = 0;
	slider_dragging = false;
	slider_bbox = [0,0,0,0];
	slider_x = 0;
	slider_y = 0;
	text_color = c_black;
	value_override = false;
	value_override_text = "";
	alpha = 1;
	x = 0;
	y = 0;
	visible = true;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	hover_snd = snd_modern03;
	activated_snd = snd_modern02;
	static Init = function(){
		
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		text_pos[1] = xTrue + (floor(width+14));
		text_pos[2] = yTrue + (height div 2);
		// enable dragging
		if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height)){

		}
		if(point_in_rectangle(mouse_x,mouse_y,slider_bbox[0],slider_bbox[1],slider_bbox[2],slider_bbox[3])){
			if(mouse_check_button_pressed(mb_left)){
				if(!slider_dragging) 
				{
					slider_dragging = true;
					SoundCommand(hover_snd);
				}
			}
		}
		// cancel dragging
		if(mouse_check_button_released(mb_left)){
			if(slider_dragging){
				slider_dragging = false;
				activated = true;
			}
		}
		// update slider value
		if(slider_dragging){
			slider_progress =  clamp(((mouse_x-slider_half_size)-(xTrue+slider_x1))/slider_len, 0, 1);
		}
		// activation script
		if(activated){
			activated = false;
			if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
			SoundCommand(activated_snd);
		}
		// update slider bbox
		slider_x = xTrue + slider_x1 + floor(slider_progress*slider_len);
		slider_y = yTrue + slider_y1;
		var _x = slider_x + slider_half_size;
		var _y = slider_y + slider_half_size;
		slider_bbox[0] = _x-slider_half_size*1.1;
		slider_bbox[1] = _y-slider_half_size*1.1;
		slider_bbox[2] = _x+slider_half_size*1.1;
		slider_bbox[3] = _y+slider_half_size*1.1;
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = container.image_alpha; 
		draw_set_alpha(_alpha);
		// draw the bar
		draw_sprite_ext(spr_bar,0,xTrue,yTrue,xscale,yscale,0,c_white,_alpha);
		// draw the slider (alternate image while dragging)
		draw_sprite_ext(spr_slider,slider_dragging ? 1 : 0,slider_x,slider_y,slider_scale,slider_scale,0,c_white,_alpha);
		// draw text stuff
		draw_set_color(text_color);
		draw_set_halign(fa_left);
		draw_set_valign(fa_bottom);
		draw_text(xTrue,yTrue+2,title_text);
		draw_set_valign(fa_middle);
		var _val = round(lerp(slider_min,slider_max,slider_progress))
		if(value_override){
			draw_text(text_pos[1], text_pos[2], value_override_arr[_val-1]);
		} else {
			draw_text(text_pos[1], text_pos[2], string(_val));
		}
	}
}
function TextBoxAdd(_x, _y, _cntr, _ind, _name, _spr, _text, _font, _caption, _txtLim, _scr, _scrArgs, _width, _height){
	var _newControl = new TextBox()
	draw_set_font(_font);
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _spr;
		width = _width;
		height = _height;
		textLimit = is_undefined(_width) ?  _txtLim : _width div string_width("X");
		text = _text;
		font = _font;
		text_prev = _text;
		caption = _caption;
		activationScript = _scr;
		activationScriptArgs = _scrArgs;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
TextBox = function() constructor{
	container = noone;
	index = 0;
	name = "";
	sprite = undefined;
	image = 0;
	xscale = 1;
	yscale = 1;
	x = 0;
	y = 0;
	visible = true;
	color = c_white;
	highlighted = false;
	highlightForced = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	textLimit = 0;
	enabled = true;
	text = "";
	text_prev = "";
	textCursor = true;
	textCursorTime = FRAME_RATE;
	textCursorTimer = -1;
	fontHeight = 0;
	caption = "";
	static Init = function(){
		draw_set_font(font);
		fontHeight = string_height("L"); 
		if(!is_undefined(width) && !is_undefined(height)){
			xscale = width / sprite_get_width(sprite);
			yscale = height / sprite_get_height(sprite);
		} else {
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height))
		{
			if(mouse_check_button_released(mb_any)){ 
				container.controlsFocus = index;
				if(global.i_engine.os_is_android){
					keyboard_string = text;
					keyboard_virtual_show(kbv_type_default, kbv_returnkey_default, kbv_autocapitalize_none, false);
				}
			}
		} else {
			if(mouse_check_button_released(mb_any) && container.controlsFocus == index){ 
				container.controlsFocus = -1;
				if(keyboard_virtual_status()) keyboard_virtual_hide();
			}
		}
		// allow for numerical inputs when focused
		if(container.controlsFocus == index)
		{
			//timer for the cursor blinking
			if(--textCursorTimer <= 0) 
			{
				textCursor = !textCursor;
				textCursorTimer =  textCursorTime;
			}
			// backspace
			if(keyboard_check_pressed(vk_backspace))
			{
				if(text != "") {
					text = string_copy(text,1,string_length(text)-1);
					activated = true;
				}
			}
			// numbers
			if(string_length(text) < textLimit)
			{
				var _lower_limit = 32;
				var _upper_limit = 122;
				var _char = 0;
				if(keyboard_check_pressed(vk_anykey) && !keyboard_check_pressed(vk_backspace) && !keyboard_check_pressed(vk_enter)){
					_char = string_char_at(keyboard_string,string_length(keyboard_string));
					if(ord(_char)>= _lower_limit && ord(_char) <= _upper_limit){
						text += _char;
					}
					activated = true;
				}
			}
			// enter key
			if(keyboard_check_pressed(vk_enter)) 
			{
				container.controlsFocus = -1;
				if(keyboard_virtual_status()) keyboard_virtual_hide();
			}
		} else { textCursor = false }
	
		if(activated)
		{
			alarm[0] = 4;
			activated = false;
			if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
		}
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = enabled ? min(1, container.image_alpha) : min(1.0, container.image_alpha); 
		draw_set_alpha(_alpha);
		var _x = xTrue-8;
		var _y = yTrue+0.5*height;
		var _wid = string_width(text);
		var _maxWid = string_width("H")*textLimit;
		var _hgt = 0.8*string_height(text);
		image = index == container.controlsFocus ? 1 : 0;
		
		draw_sprite_ext(sprite, image, xTrue, yTrue, xscale, yscale,0,c_white,_alpha);
		draw_set_color(color);
		draw_set_font(font);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_left);
		draw_text(_x+14,_y, text);
		if(caption != "") 
		{
			draw_set_valign(fa_middle);
			draw_set_halign(fa_right);
			draw_text(_x,_y,caption);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
		}
		_x += _wid;
		_y -= 0.5*fontHeight;
		if(textCursor) draw_rectangle(_x+14,_y+2,_x+15,_y+fontHeight-3,false);
		draw_set_color(c_white);
	}
}
function ButtonAdd(_x, _y, _cntr, _ind, _name, _spr, _sprAlt, _caption, _hotkey, _scr, _scrArgs, _uses_9s_sprite=false){
	if(_uses_9s_sprite){
		var _newControl = new Button9s();
	} else {
		var _newControl = new Button();
	}
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _spr;
		caption = _caption;
		hotkey = _hotkey;
		spriteAlt = _sprAlt;
		activationScript = _scr;
		activationScriptArgs = _scrArgs;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
Button = function() constructor{
	container = noone;
	index = 0;
	name = "";
	sprite = undefined;
	spriteAlt = undefined;
	drawAlt = false;
	image = 0;
	caption = "";
	font = f_default_s;
	color = c_white;
	hotkey = undefined;
	width = 0;
	height = 0;
	x = 0;
	y = 0;
	visible = true;
	xTrue = 0;
	yTrue = 0;
	enabled = true;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	hover_snd = snd_modern03;
	activated_snd = snd_modern02;
	static Init = function(){
		if(!is_undefined(sprite))
		{
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		}
		if(!is_undefined(hotkey))
		{
			if(hotkey != vk_enter) && (hotkey != vk_space)
			{
				caption += "\n[" + chr(hotkey) + "]";
			}
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		if(enabled)
		{
			if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height))
			{
				if(!highlighted){
					SoundCommand(hover_snd);
					highlighted = true;
				}
				pressed = mouse_check_button(mb_any);
				if(mouse_check_button_released(mb_any)) 
				{
					container.controlsFocus = index;
					activated = true;
				}
				if(pressed && keyboard_virtual_status()){ keyboard_virtual_hide(); }
			} else {
				highlighted = false;
				pressed = false;
			}
			// respond to key presses
			// activate on enter when focused
			if(container.controlsFocus == index)
			{ 
				highlighted = true;
			}
			// hotkey to activate the button
			if(!is_undefined(hotkey))
			{
				if(keyboard_check(hotkey)) pressed = true;
				if(keyboard_check_released(hotkey)) activated = true;
			}
			if(activated)
			{
				alarm[0] = 4;
				activated = false;
				SoundCommand(activated_snd);
				if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
			}
			// adjust the sprite
			image = 0;
			if(highlightForced) highlighted = true;
			if(highlighted) image = 1;
			if(pressed) image = 2;
		}
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = enabled ? min(1, container.image_alpha) : min(0.5, container.image_alpha); 
		draw_set_alpha(_alpha);
		draw_set_color(color);
		// draw button sprite
		if(drawAlt) && (!is_undefined(spriteAlt))
		{
			draw_sprite(spriteAlt, image, xTrue, yTrue)
		} else {
			draw_sprite(sprite, image, xTrue, yTrue);
		}
		if(!is_undefined(caption))
		{
			if(draw_get_font() != font) draw_set_font(font);
			// show caption
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text(xTrue + 0.5*width, yTrue + 0.5*height + image, caption);
			draw_set_alpha(1);
		}
	}
}
Button9s = function() constructor{
	container = noone;
	index = 0;
	name = "";
	sprite = undefined;
	spriteAlt = undefined;
	drawAlt = false;
	image = 0;
	blend = c_white;
	caption = "";
	font = f_default_s;
	color = c_white;
	hotkey = undefined;
	width = -1;
	height = -1;
	x = 0;
	y = 0;
	visible = true;
	xTrue = 0;
	yTrue = 0;
	enabled = true;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	hover_snd = snd_modern03;
	activated_snd = snd_modern02;
	static Init = function(){
		// check if the width & height have been set
		if(width + height == -2){
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		}
		xscale = width / sprite_get_width(sprite);
		yscale = height / sprite_get_height(sprite);
		if(!is_undefined(hotkey))
		{
			if(hotkey != vk_enter) && (hotkey != vk_space)
			{
				caption += "\n[" + chr(hotkey) + "]";
			}
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		if(enabled)
		{
			if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height))
			{
				if(!highlighted){
					SoundCommand(hover_snd);
					highlighted = true;
				}
				pressed = mouse_check_button(mb_any);
				if(mouse_check_button_released(mb_any)) 
				{
					container.controlsFocus = index;
					activated = true;
				}
				if(pressed && keyboard_virtual_status()){ keyboard_virtual_hide(); }
			} else {
				highlighted = false;
				pressed = false;
			}
			// respond to key presses
			// activate on enter when focused
			if(container.controlsFocus == index)
			{ 
				highlighted = true;
			}
			// hotkey to activate the button
			if(!is_undefined(hotkey))
			{
				if(keyboard_check(hotkey)) pressed = true;
				if(keyboard_check_released(hotkey)) activated = true;
			}
			if(activated)
			{
				alarm[0] = 4;
				activated = false;
				SoundCommand(activated_snd);
				if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
			}
			// adjust the sprite
			image = 0;
			if(highlightForced) highlighted = true;
			if(highlighted) image = 1;
			if(pressed) image = 2;
		}
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = enabled ? min(1, container.image_alpha) : min(0.5, container.image_alpha); 
		draw_set_alpha(_alpha);
		draw_set_color(color);
		if(draw_get_font() != font) draw_set_font(font);
		// draw button sprite
		if(drawAlt) && (!is_undefined(spriteAlt))
		{
			draw_sprite(spriteAlt, image, xTrue, yTrue)
		} else {
			draw_sprite_ext(sprite, image, xTrue, yTrue,xscale,yscale,0,blend,_alpha);
		}
		if(!is_undefined(caption))
		{
			// show caption
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text(xTrue + 0.5*width, yTrue + 0.5*height + image, caption);
		}
	}
}
function LabelAdd(_x, _y, _cntr, _ind, _name, _text, _font=f_default_s, _valign=fa_top, _halign=fa_left){
	var _newControl = new Label()
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		text = _text;
		font = _font;
		halign = _halign;
		valign = _valign;
		xTrue = _cntr.x+_x;
		yTrue = _cntr.y+_y;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
Label = function() constructor{
	container = noone;
	index = -1;
	name = "";
	text = "";
	text_pos = vect2(0,0);
	alpha = 1;
	image = 0;
	width = 0;
	height = 0;
	color = c_white;
	x = 0;
	y = 0;
	visible = true;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	static Init = function(){

	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		text_pos[1] = xTrue + (width div 2);
		text_pos[2] = yTrue + (height div 2);
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = container.image_alpha; 
		draw_set_font(font);
		draw_set_alpha(_alpha);
		draw_set_color(color);
		draw_set_valign(valign);
		draw_set_halign(halign);
		draw_text(xTrue, yTrue, text);
	}
}
function ImageAdd(_x, _y, _cntr, _ind, _name, _sprite, _image,_width,_height,_bg_visible){
	var _newControl = new Image();
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _sprite;
		image = _image;
		width = _width;
		height = _height;
		bg_visible = _bg_visible;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
Image = function() constructor{
	container = noone;
	index = -1;
	name = "";
	alpha = 1;
	sprite = undefined;
	image = 0;
	xscale = 1;
	yscale = 1;
	width = 0;
	height = 0;
	color = c_white;
	bg_visible = true;
	x = 0;
	y = 0;
	visible = true;
	static Init = function(){
		if(!is_undefined(sprite) && !is_undefined(width) && !is_undefined(height)){
			xscale = width / sprite_get_width(sprite);
			yscale = height / sprite_get_height(sprite);
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
	}
	static Draw = function(){
		if(!visible) return;
		var _alpha = container.image_alpha; 
		draw_set_alpha(_alpha);
		draw_set_color(color);
		if(bg_visible){
			draw_rectangle(xTrue,yTrue,xTrue+width,yTrue+height,false);
		}
		if(!is_undefined(sprite)){
			draw_sprite_ext(sprite, image,xTrue,yTrue,xscale,yscale,0,c_white,_alpha);
		}
	}
}
controlsCount = 0;
controlsFocus = -1; 
controlsMap = ds_map_create();
controlsList = ds_list_create();

alarm[0] = 1;
depth = UPPERDEPTH;
image_speed = 0;
image_index = 0;

leftClick = false;
leftScript = -1;
leftArgs = -1;
rightClick = false;
rightScript = -1;
rightArgs = -1;
text = "";
baseColor = c_black;
highlightColor = c_yellow;
textColor = c_black;
textOffsetY = 0;
focus = false;
press = false;
gui = false;
enabled = true;
closable = false;

menuOpen = false;

stack_index = ds_stack_size(global.i_engine.menu_stack);
ds_stack_push(global.i_engine.menu_stack, id);

// bring the engine depth up to this menu to draw the background
global.i_engine.depth = depth+3;
global.i_engine.image_alpha = 1;