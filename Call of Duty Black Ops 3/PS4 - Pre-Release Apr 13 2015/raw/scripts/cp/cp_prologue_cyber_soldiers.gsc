
//
// Event 9
//
// cp_prologue_cyber_soldiers.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_mi_eth_prologue;

#using scripts\shared\scene_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_skipto;




//*****************************************************************************
// EVENT 9: Intro Cyber Soldierse
//*****************************************************************************

#namespace intro_cyber_soldiers;


function intro_cyber_soldiers_start()
{
	intro_cyber_soldiers_precache();	
	level thread intro_cyber_soldiers_main();
}

// DO ALL PRECACHING HERE
function intro_cyber_soldiers_precache()
{
	
}

// Event Main Function
function intro_cyber_soldiers_main()
{
	// Get Hendricks, Minister and Khalil
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_minister = util::get_hero( "minister" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		level thread move_lift();
	}

	cp_mi_eth_prologue::init_khalil( "skipto_robot_defend_khalil" );
	cp_mi_eth_prologue::init_minister( "skipto_robot_defend_minister" );
	cp_mi_eth_prologue::init_hendricks( "skipto_robot_defend_hendricks" );

	// Init the Cyber Soldiers
	level.ai_hyperion 	= util::get_hero( "hyperion" );
	level.ai_pallas 	= util::get_hero( "pallas" );	
	level.ai_prometheus = util::get_hero( "prometheus" );	
	level.ai_theia 		= util::get_hero( "theia" );
	
	
	
	foreach ( player in level.players )
	{
		player SetPlayerAngles( (0, 0, 0) );
		player FreezeControls( true );
	}
	
	level thread cyber_hangar_gate_close(8);

	// Play the intro
	scene::play( "cin_pro_09_01_intro_1st_cybersoldiers" );
	
	// TODO: so that they dont running into each other after animation. Remove it after the real cyber soliders scene check in
	temp_post_cybersolidier_goal();
	
	foreach ( player in level.players )
	{
		player FreezeControls( false );
	}
	
	wait( 0.1 );
	skipto::objective_completed( "skipto_intro_cyber_soldiers" );
}


function cyber_hangar_gate_close(move_time)
{

	hangar_gate_r = GetEnt( "cyber_hangar_gate_r", "targetname" );
	hangar_gate_r_pos = struct::get( "cyber_hangar_gate_r_pos", "targetname" );
	hangar_gate_r playsound ("evt_hangar_start_r");
	hangar_gate_r Moveto( hangar_gate_r_pos.origin, move_time );
	snd_hangar_r = spawn( "script_origin", (hangar_gate_r.origin));
	snd_hangar_r linkto (hangar_gate_r);
	snd_hangar_r playloopsound ( "evt_hangar_loop_r" );
	
	hangar_gate_l = GetEnt( "cyber_hangar_gate_l", "targetname" );
	hangar_gate_l_pos = struct::get( "cyber_hangar_gate_l_pos", "targetname" );
	hangar_gate_l playsound ("evt_hangar_start_l");
	hangar_gate_l Moveto( hangar_gate_l_pos.origin, move_time );
	snd_hangar_l = spawn( "script_origin", (hangar_gate_l.origin));
	snd_hangar_l linkto (hangar_gate_l);
	snd_hangar_l playloopsound ( "evt_hangar_loop_l" );
	
	hangar_gate_l waittill( "movedone" );
	hangar_gate_r playsound ("evt_hangar_stop_r");
	hangar_gate_l playsound ("evt_hangar_stop_l");
	snd_hangar_r stoploopsound ( .1 );
	snd_hangar_l stoploopsound ( .1 );	
	
	hangar_gate_r Disconnectpaths();
	hangar_gate_l Disconnectpaths();
	
}

function temp_post_cybersolidier_goal()
{
	level.ai_hendricks thread ai_goal();
	level.ai_minister thread ai_goal();
	level.ai_khalil thread ai_goal();
	//level.ai_hyperion thread ai_goal();
	level.ai_pallas thread ai_goal();
	//level.ai_prometheus thread ai_goal();
	//level.ai_theia thread ai_goal();
}

function ai_goal()
{
	self SetGoal( self.origin, true, 16 );
}

// move the lift for skipto
function move_lift()
{
	e_lift_door = GetEnt( "lift_door", "targetname" );
	v_up = ( 0, 0, 1 );
	v_dest = ( e_lift_door.origin + v_up * -100 );
	move_time = 0.1;
	e_lift_door MoveTo( v_dest, move_time );	
	e_lift_door waittill( "movedone" );
	
	level.e_lift = getent( "freight_lift", "targetname" );

	e_lift_door LinkTo( level.e_lift );
	
	level.e_lift SetMovingPlatformEnabled( true );
	v_up = ( 0, 0, 1 );
	lift_height = 100;
	move_time = 0.5;
	v_lift_destination = (level.e_lift.origin + v_up * lift_height );
	level.e_lift MoveTo( v_lift_destination, move_time );
}