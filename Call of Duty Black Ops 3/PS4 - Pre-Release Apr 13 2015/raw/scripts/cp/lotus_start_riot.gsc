#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\lotus_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "lui_menu", "TmpIntroIGC" );//TODO - remove once we get the anims

#precache( "objective", "cp_level_lotus_riot" );
#precache( "objective", "cp_level_lotus_hakim_access" );
#precache( "objective", "cp_level_lotus_hakim" );

#precache( "string", "CP_MI_CAIRO_LOTUS_OPEN_DOOR" );
#precache( "string", "CP_MI_CAIRO_LOTUS_SHIELD_TUTORIAL_BLOCK" );
#precache( "string", "CP_MI_CAIRO_LOTUS_SHIELD_TUTORIAL_ATTACK" );

function init()
{
	spawner::add_spawn_function_group( "riot_gate_enemies", "targetname", &init_gate_enemies );
	spawner::add_spawn_function_group( "civ_fodder", "targetname", &random_death );
	
	spawner::add_spawn_function_group( "assassination_toss", "script_noteworthy", &kill_at_goal );
}

function plan_b_main( str_objective, b_starting )
{	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		level.ai_hendricks = util::get_hero( "hendricks_riot" );
		level.ai_khalil = util::get_hero( "khalil_riot" );
	}
	else
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
	}

	level flag::wait_till( "all_players_spawned" );
	
	// Open the UI MENU//TODO - remove once we get the anims
	foreach ( player in level.players )
	{
		player.temp_menu = player OpenLUIMenu( "TmpIntroIGC" );
	}	
			
	wait 3;//Allow enough time to see temp intro igc card
	
	// Close the UI MENU//TODO - remove once we get the anims
	foreach ( player in level.players )
	{
		if( IsDefined( player.temp_menu ) )
		{
			player CloseLUIMenu( player.temp_menu );
		}
	}	
	
	objectives::set( "cp_level_lotus_riot" );
	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		foreach ( player in level.players )
		{
			player GiveWeapon( level.weaponRiotshield );
			player SwitchToWeapon( level.weaponRiotshield );
		}
	}

	skipto::objective_completed( "plan_b" );
}

function plan_b_done( str_objective, b_starting, b_direct, player )
{
	e_door = GetEnt( "plan_b_door", "targetname" );
	e_door ConnectPaths();
	e_door Delete();
}

function main( str_objective, b_starting )
{	
	if ( b_starting )
	{		
		if( !GetDvarint("ai_spawn_only_zombies") == 1 )
		{
			level.ai_hendricks = util::get_hero( "hendricks_riot" );
			level.ai_khalil = util::get_hero( "khalil_riot" );
		}
		else
		{
			level.ai_hendricks = util::get_hero( "hendricks" );
			level.ai_khalil = util::get_hero( "khalil" );
		}

		
		skipto::teleport_ai( str_objective );
		
		objectives::set( "cp_level_lotus_riot" );
	}
	
	trigger::use( "start_dead_scene" );//Play initial corpse scenes
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		level thread riotshield_tutorial();
	}
	level thread riot_ambient_scenes();
	
	t_door = GetEnt( "start_the_riots_done", "targetname" );
	t_door SetHintString( &"CP_MI_CAIRO_LOTUS_OPEN_DOOR" );
	e_door = getent( "keypad_door01", "targetname" );
	e_door DisconnectPaths();
	
	level scene::init( "cin_lot_02_02_startriots_vign_overridelock" );
	level scene::init( "cin_lot_04_01_security_vign_beaten" );
	level scene::init( "cin_lot_04_01_security_vign_holddown" );
	level scene::init( "cin_lot_04_01_security_vign_weaponcivs" );	
	
	spawn_hakim();
	
	trigger::wait_till( "enter_override_room" );
	
	s_keypad = struct::get( "hakim_keypad" );
	objectives::set( "cp_level_lotus_hakim_access", s_keypad );
	
	spawn_manager::wait_till_cleared( "override_room" );
	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		level scene::play( "cin_lot_02_02_startriots_vign_overridelock" );
	}

	objectives::complete( "cp_level_lotus_hakim_access" );
	level open_security_door();
	trigger::use( "override_lock_done" );
	
	objectives::set( "cp_level_lotus_hakim", level.ai_hakim );	
	
	trigger::wait_till( "start_the_riots_done" );
	
	skipto::objective_completed( "start_the_riots" );
}

function start_the_riots_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_hakim_access" );
	exploder::exploder( "fx_interior_ambient_falling_debris_tower1" );
}

function general_hakim_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		t_door = GetEnt( "start_the_riots_done", "targetname" );
		t_door SetHintString( &"CP_MI_CAIRO_LOTUS_OPEN_DOOR" );
	
		if( !GetDvarint("ai_spawn_only_zombies") == 1 )
		{
			level.ai_hendricks = util::get_hero( "hendricks_riot" );
			level.ai_khalil = util::get_hero( "khalil_riot" );
		}
		else
		{
			level.ai_hendricks = util::get_hero( "hendricks" );
			level.ai_khalil = util::get_hero( "khalil" );
		}
		
		spawn_hakim();
		
		skipto::teleport_ai( str_objective );
		
		objectives::set( "cp_level_lotus_hakim", level.ai_hakim );
		
		level scene::init( "cin_lot_03_01_hakim_1st_kill_player" );
		level scene::init( "cin_lot_04_01_security_vign_beaten" );
		level scene::init( "cin_lot_04_01_security_vign_holddown" );
		level scene::init( "cin_lot_04_01_security_vign_weaponcivs" );		
	}
	
	level scene::init( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
	level.ai_hakim util::stop_magic_bullet_shield();
	
	level thread scene::play( "assassination_bodies", "targetname" );
	level scene::init( "cin_lot_04_01_security_vign_weapon" );
	level scene::init( "cin_lot_04_01_security_vign_weapon_khalil" );

	level thread riot_fx();
	
	level waittill( "start_toss" );//Set by scriptbundle scene
	level thread scene::play( "cin_lot_03_01_hakim_vign_toss" );
	
	//Prep non-riotshield heroes
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_khalil = util::get_hero( "khalil" );
	
	//HACK - remove this once we get an anim for Khalil
	s_khalil = struct::get( "apartments_khalil_spawn" );
	level.ai_khalil ForceTeleport( s_khalil.origin, s_khalil.angles );
	s_hendricks = struct::get( "apartments_hendricks_spawn" );
	level.ai_hendricks ForceTeleport( s_hendricks.origin, s_hendricks.angles );
	
	level waittill( "hakim_killed" );//Set by scriptbundle scene
	
	skipto::objective_completed( "general_hakim" );
}

function general_hakim_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_hakim" );
	objectives::complete( "cp_level_lotus_riot" );
	
	exploder::exploder( "fx_interior_ambient_tracer_fire_atrium" );
}

////////////////////////////////////////////////////////////////////////////////////////////
//MAIN
////////////////////////////////////////////////////////////////////////////////////////////

function riot_ambient_scenes()
{
	flag::wait_till( "start_ambient_scenes" );
	e_gate = GetEnt( "apartment_gate_01", "targetname" );
	e_gate MoveZ( 100, .05 );//Open gate
	
	trigger::use( "gate_enemies" );//Play hallway scenes, Enemy group running towards other areas
	wait( .1 );
	
	e_gate MoveZ( -100, 7 );//Close gate
	
	trigger::wait_till( "riots_wave_two" );
	trigger::use( "civ_riot_fodder" );
}

function init_gate_enemies()
{
	self.goalradius = 16;
	
	self waittill( "goal" );
	
	/*if( isdefined( self.script_string ) )//TODO - update this once the anims are fixed
	{
		e_door = GetEnt( "apartment_door_0" + self.script_int, "targetname" );
		e_door scene::play( self.script_string, Array( self, e_door ) );
	}
	else*/
	{ 
		self Delete();
	}
}

function riotshield_tutorial()
{
	wait( .5 );
	util::screen_message_create( &"CP_MI_CAIRO_LOTUS_SHIELD_TUTORIAL_BLOCK", &"CP_MI_CAIRO_LOTUS_SHIELD_TUTORIAL_ATTACK", undefined, undefined, 3 );
}

function random_death()
{
	self endon( "death" );
	wait( RandomIntRange( 3, 6 ) );
	self kill();
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

function spawn_hakim()
{
	if ( !isdefined( level.ai_hakim ) )
	{
		level.ai_hakim = spawner::simple_spawn_single( "hakim", &util::magic_bullet_shield );
	}
	
	level scene::init( "hakim_speech", "targetname" );
	return level.ai_hakim;
}


function heroes_ignoreall( b_ignore )
{
	level.ai_hendricks.ignoreall = b_ignore;
	level.ai_khalil.ignoreall = b_ignore;
}

function open_security_door()
{
	e_door = getent( "keypad_door01", "targetname" );
	e_door ConnectPaths();
	e_door MoveZ( 100, .5 );
}

//self = ai
function kill_at_goal()
{
	self endon( "death" );
	self.scenegoal = self.target;
	
	self waittill( "goal" );
	
	self Kill();
}

function riot_fx()
{
	level waittill( "molotov_throw" );
	exploder::exploder( "fx_interior_ambient_tracer_fire_atrium" );
}
