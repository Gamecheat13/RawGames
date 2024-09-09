#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;
#include maps\mp\bots\_bots_personality;


//=======================================================
//						main
//=======================================================
main()
{
	// This is called directly from native code on game startup after the _bots::main() is executed
	setup_callbacks();
}


//=======================================================
//					setup_callbacks
//=======================================================
setup_callbacks()
{
	level.bot_funcs["can_use_crate"] = ::can_use_crate;
	level.bot_funcs["gametype_think"] = ::bot_hp_think;
}


//=======================================================
//					can_use_crate
//=======================================================
can_use_crate()
{
	return true;
}


//=======================================================
//					bot_hp_think
//=======================================================
bot_hp_think()
{
	self notify( "bot_hp_think" );
	self endon(  "bot_hp_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	// TDM just performs normal personality logic
	while ( true )
	{
		self [[ self.personality_update_function ]]();
		waitframe();
	}
}