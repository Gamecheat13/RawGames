// This file includes all the default juggernaut animations. Faction specfic rusher override calls should go in its own anims_table_*.gsc
#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_juggernaut_anim_array()
{
	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_f"]			= %Juggernaut_walkF;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["sprint"]					= %Juggernaut_sprint;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]		= %Juggernaut_aim5;
	
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_walk_f"]			= %Juggernaut_walkF;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_walk_r"]			= %Juggernaut_walkR;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_walk_l"]			= %Juggernaut_walkL;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_walk_b"]			= %Juggernaut_walkB;
//
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_b_aim_up"]		= %ai_tactical_walk_b_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_b_aim_down"]		= %ai_tactical_walk_b_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_b_aim_left"]		= %ai_tactical_walk_b_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_b_aim_right"]	= %ai_tactical_walk_b_aim6;
//
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_f_aim_up"]		= %ai_tactical_walk_f_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_f_aim_down"]		= %ai_tactical_walk_f_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_f_aim_left"]		= %ai_tactical_walk_f_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_f_aim_right"]	= %ai_tactical_walk_f_aim6;
//
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_l_aim_up"]		= %ai_tactical_walk_l_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_l_aim_down"]		= %ai_tactical_walk_l_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_l_aim_left"]		= %ai_tactical_walk_l_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["tactical_l_aim_right"]	= %ai_tactical_walk_l_aim6;
		
	self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_f"]			= %Juggernaut_walkF;
	self.anim_array[self.animType]["move"]["stand"]["spread"]["sprint"]					= %Juggernaut_sprint;
	self.anim_array[self.animType]["combat"]["stand"]["spread"]["straight_level"]		= %Juggernaut_aim5;
	
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_walk_f"]		= %Juggernaut_walkF;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_walk_r"]		= %Juggernaut_walkR;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_walk_l"]		= %Juggernaut_walkL;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_walk_b"]		= %Juggernaut_walkB;
//
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_b_aim_up"]		= %ai_tactical_walk_b_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_b_aim_down"]	= %ai_tactical_walk_b_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_b_aim_left"]	= %ai_tactical_walk_b_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_b_aim_right"]	= %ai_tactical_walk_b_aim6;
//
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_f_aim_up"]		= %ai_tactical_walk_f_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_f_aim_down"]	= %ai_tactical_walk_f_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_f_aim_left"]	= %ai_tactical_walk_f_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_f_aim_right"]	= %ai_tactical_walk_f_aim6;
//
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_l_aim_up"]		= %ai_tactical_walk_l_aim8;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_l_aim_down"]	= %ai_tactical_walk_l_aim2;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_l_aim_left"]	= %ai_tactical_walk_l_aim4;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["tactical_l_aim_right"]	= %ai_tactical_walk_l_aim6;
//	
	
//	// set run and gun animations to default
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_f"]		= %Juggernaut_walkF;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_r"]		= %Juggernaut_walkR;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_l"]		= %Juggernaut_walkL;
//	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_b"]		= %Juggernaut_walkB;
//	
//	// aim variations
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]	= %Juggernaut_aim5;
//
//	// AI_TODO - replace these animations with better aim additives specific to juggernaut
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_f_aim_up"]       = %ai_run_n_gun_f_aim_8;
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_f_aim_down"]     = %ai_run_n_gun_f_aim_2;
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_f_aim_left"]     = %ai_run_n_gun_f_aim_4;
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_f_aim_right"]    = %ai_run_n_gun_f_aim_6;
//
//	/////////////////////
//	/// Shotgun anims are the same
//	/////////////////////
//
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["sprint"]			= %Juggernaut_sprint;
//
//	// set run and gun animations to default
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_f"]		= %Juggernaut_walkF;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_r"]		= %Juggernaut_walkR;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_l"]		= %Juggernaut_walkL;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["run_n_gun_b"]		= %Juggernaut_walkB;
//
//	// replace lean animations
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_lean_l"]	= %Juggernaut_walkL;
//	self.anim_array[self.animType]["move"]["stand"]["spread"]["combat_run_lean_r"]	= %Juggernaut_walkR;
//
//	// aim variations
//	self.anim_array[self.animType]["combat"]["stand"]["spread"]["straight_level"]	= %Juggernaut_aim5;
//
//	// AI_TODO - replace these animations with better aim additives specific to juggernaut
//	self.anim_array[self.animType]["combat"]["stand"]["spread"]["add_f_aim_up"]       = %ai_run_n_gun_f_aim_8;
//	self.anim_array[self.animType]["combat"]["stand"]["spread"]["add_f_aim_down"]     = %ai_run_n_gun_f_aim_2;
//	self.anim_array[self.animType]["combat"]["stand"]["spread"]["add_f_aim_left"]     = %ai_run_n_gun_f_aim_4;
//	self.anim_array[self.animType]["combat"]["stand"]["spread"]["add_f_aim_right"]    = %ai_run_n_gun_f_aim_6;
}
