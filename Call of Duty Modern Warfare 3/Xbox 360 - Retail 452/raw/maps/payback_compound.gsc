#include maps\_utility;
#include common_scripts\utility;
#include maps\payback_util;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;

start_compound()
{
	// AUDIO: jump/checkpoints
	//exploder(2000);
	texploder(2300);
	exploder(2000);
	exploder(2500);
	aud_send_msg("default");
	
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	
	level.hannibal = spawn_ally("hannibal");	
	level.murdock = spawn_ally("murdock");
	level.barracus = spawn_ally("barracus");
	
	
	thread maps\payback_1_script_a::intro();
		
	compound();
}

// logic for compound section
compound()
{
	// logic for compound section
	maps\payback_1_script_d::chopper_main();

	// wait till done with compound section
	//level waittill( "payback_compound_finished" );
	// then start streets section
	//maps\payback_streets::streets();
}

init_flags_compound()
{
	maps\payback_1_script_a::init_compound_a_flags();
	maps\payback_1_script_b::init_compound_b_flags();
	maps\payback_1_script_c::init_compound_c_flags();
	maps\payback_1_script_d::chopper_flag_init();
	
}