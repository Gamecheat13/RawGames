#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_cairo_lotus_fx;
#using scripts\cp\cp_mi_cairo_lotus_sound;

function main()
{
	//visionset_mgr::register_overlay_info_style_electrified( "shotgun_electric", VERSION_SHIP, 15, 1.25 );
	
	cp_mi_cairo_lotus_fx::main();
	cp_mi_cairo_lotus_sound::main();

	setup_skiptos();
	
	load::main();

	callback::on_spawned( &on_player_spawned );
	
	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function on_player_spawned( localClientNum )
{
	player = getlocalplayer( localClientNum );
	
	// threads for clientside triggers
	e_trigger = GetEnt( localClientNum, "mobile_shop_1_final_ascent", "targetname" );
	e_trigger._localClientNum = localClientNum;
	e_trigger waittill( "trigger", trigPlayer );
	e_trigger thread trigger::function_thread( trigPlayer, &trig_mobile_shop_1_final_ascent );
}

//*****************************************************************************
// SKIPTOS
//*****************************************************************************
function setup_skiptos()
{	
	// Events 1 - 9
	skipto::add( "plan_b", 					&skipto_init,			"Plan B" );
	skipto::add( "start_the_riots", 		&start_the_riots,		"Start the Riots" );
	skipto::add( "general_hakim", 			&general_hakim,			"General Hakim" );
	skipto::add( "apartments",				&skipto_init, 			"Apartments" );
	skipto::add( "atrium_battle",			&atrium_battle,			"Atrium Battle" );
	skipto::add( "to_security_station",		&to_security_station, 	"To Security Station" );
	skipto::add( "hack_the_system", 		&skipto_init,			"Hack the System" );
	skipto::add( "prometheus_otr",			&skipto_init,			"Prometheus OTR" );
	skipto::add( "vtol_hallway",			&skipto_init,			"VTOL Hallway" );
	skipto::add( "mobile_shop_ride2",		&skipto_init,			"Mobile Shop Ride 2" );
	skipto::add( "to_detention_center3",	&skipto_init,			"Get to the Detention Center" );
	skipto::add( "to_detention_center4",	&skipto_init,			"Get to the Detention Center" );
	skipto::add( "detention_center",		&skipto_init,			"Detention Center" );
	skipto::add( "stand_down", 				&skipto_init,			"Stand Down" );
	skipto::add( "pursuit", 				&skipto_init,			"Pursuit" );
	
	// Events 10 - 16
	skipto::add( "sky_bridge", 				&skipto_init );
	skipto::add( "tower_2_ascent", 			&skipto_init );
	skipto::add( "minigun_platform", 		&skipto_init );
	skipto::add( "platform_fall", 			&skipto_init );
	skipto::add( "hunter", 					&skipto_init );
	skipto::add( "prometheus_intro",		&skipto_init );
	skipto::add( "boss_battle", 			&skipto_init );
	skipto::add( "old_friend", 				&skipto_init );
}

function skipto_init( str_objective, b_starting )
{
}

function start_the_riots( str_objective, b_starting )
{
	if ( b_starting )
	{
	}
	
	level thread scene::play( "crowds_early", "script_noteworthy" );
	level thread scene::play( "crowds_hakim", "script_noteworthy" );
}

function general_hakim( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread scene::play( "crowds_hakim", "script_noteworthy" );
	}
	
	level thread scene::stop( "crowds_early", "script_noteworthy" );
	level thread scene::play( "crowds_atrium", "script_noteworthy" );
}

function atrium_battle( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread scene::play( "crowds_atrium", "script_noteworthy" );
	}

	level thread scene::stop( "crowds_hakim", "script_noteworthy" );
	level thread scene::play( "crowds_mobile_shop_1", "script_noteworthy" );
}

function trig_mobile_shop_1_final_ascent( trigPlayer )
{
	level thread scene::play( "crowds_to_security_station", "script_noteworthy" );
}

function to_security_station( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread scene::play( "crowds_to_security_station", "script_noteworthy" );
	}
	
	level thread scene::stop( "crowds_atrium", "script_noteworthy" );
}
