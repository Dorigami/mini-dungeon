#macro FRAME_RATE 30
#macro ROOM_START r_game
#macro NONE -1
#macro OUT 0
#macro IN 1
#macro UP 1
#macro DOWN -1
#macro LEFT 0
#macro RIGHT 1
#macro TRIGHT 0
#macro TLEFT 1
#macro TUP 2
#macro TDOWN 3
#macro UPPERDEPTH -5000
#macro ENTITYDEPTH -200
#macro LOWERDEPTH 0
#macro LOREM_IPSUM "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

enum GameStates 
{
	PLAY,
	PAUSE,
    VICTORY,
    DEFEAT,
}
