#using scripts\codescripts\struct;

#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;
#using scripts\cp\gametypes\_player_cam;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_claymore;
#using scripts\cp\_explosive_bolt;
#using scripts\cp\_helicopter_sounds;
#using scripts\cp\killstreaks\_turret;
#using scripts\shared\util_shared;

//Shared registration - move these to load_shared if/when possible
#using scripts\shared\audio_shared;
#using scripts\shared\clientfaceanim_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\vehicle_shared;

//System registration
#using scripts\cp\_ambient;
#using scripts\cp\_callbacks;
#using scripts\cp\_destructible;
#using scripts\cp\_global_fx;
#using scripts\cp\_laststand;
#using scripts\cp\_oed;
#using scripts\cp\_radiant_live_update;
#using scripts\cp\_rewindobjects;
#using scripts\cp\_rotating_object;
#using scripts\cp\_skipto;
#using scripts\cp\_vehicle;
#using scripts\cp\gametypes\_weaponobjects;

//Killstreaks registration
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_helicopter;
#using scripts\cp\killstreaks\_missile_drone;
#using scripts\cp\killstreaks\_planemortar;
#using scripts\cp\killstreaks\_remotemissile;

//Weapon registration
#using scripts\shared\weapons\spike_charge;
#using scripts\shared\weapons\_sticky_grenade;
//#using scripts\cp\_acousticsensor;
#using scripts\cp\_bouncingbetty;
//#using scripts\cp\_claymore;
#using scripts\cp\_decoy;
#using scripts\cp\_explosive_bolt;
#using scripts\cp\_flashgrenades;
#using scripts\cp\_hacker_tool;
#using scripts\cp\_proximity_grenade;
#using scripts\cp\_riotshield;
#using scripts\cp\_satchel_charge;
//#using scripts\cp\_scrambler;
#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_trophy_system;
#using scripts\cp\gametypes\_weaponobjects;

//Abilities
#using scripts\shared\abilities\_ability_player;	//DO NOT REMOVE - needed for system registration
#using scripts\cp\cybercom\_cybercom;

#using scripts\cp\bonuszm\_bonuszm;


#namespace load;

function levelNotifyHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		level notify(state,clientNum);
	}
}

function main()
{
	/#
	
	Assert( isdefined( level.first_frame ), "There should be no waits before load::main." );
	
	#/
		
	if ( ( isdefined( level._loadStarted ) && level._loadStarted ) )
	{
		// In CP let load::main be called more than once for simplicity in setting up HUB neighborhoods
		return;
	}
	
	level._loadStarted = true;
	
	level thread util::serverTime();
	level thread util::init_utility();
	level thread register_clientfields();

	util::registerSystem( "levelNotify", &levelNotifyHandler );

	
	level.createFX_disable_fx = (GetDvarInt("disable_fx") == 1);
	
	//The functions are threaded just in case any of them create 'wait's. Note these functions should not have 'wait's in their 'init' and 'main' functions.
	
	//level thread _airstrike::init();
	//level thread _plane::init();
	level thread _claymore::init();	
	level thread _explosive_bolt::main();	

	//level thread helicopter_sounds::init();
	//level thread _helicopter_player::init();
	level thread _turret::init();

//	footsteps();
	
	callback::add_callback( #"on_localclient_connect", &basic_player_connect);
	callback::on_spawned( &on_player_spawned );

	system::wait_till( "all" );
	
	load::art_review();
	
	level flagsys::set( "load_main_complete" );
}

function basic_player_connect( localClientNum )
{
	if ( !isdefined( level._laststand ) )
	{
		level._laststand = [];
	}
	
	level._laststand[localClientNum] = false;
	
	ForceGameModeMappings( localClientNum, "default" );
}

function on_player_spawned( localClientNum )
{
	self thread force_update_player_clientfields(localClientNum);
}

function force_update_player_clientfields( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( !ClientHasSnapshot( localClientNum ) )
	{
		wait 0.25;
	}
	
	wait 0.25;
	
	self ProcessClientFieldsAsIfNew();
}

/*footsteps()
{
	util::setFootstepEffect( "asphalt",    "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "brick",      "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "carpet",     "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "cloth",      "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "concrete",   "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "dirt",       "_t6/bio/player/fx_footstep_sand" );
	util::setFootstepEffect( "foliage",    "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "gravel",     "_t6/bio/player/fx_footstep_sand" );
	util::setFootstepEffect( "grass",      "_t6/bio/player/fx_footstep_sand" );
	util::setFootstepEffect( "metal",      "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "mud",        "_t6/bio/player/fx_footstep_mud" );
	util::setFootstepEffect( "paper",      "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "plaster",    "_t6/bio/player/fx_footstep_dust" );
	util::setFootstepEffect( "rock",       "_t6/bio/player/fx_footstep_sand" );
	util::setFootstepEffect( "sand",       "_t6/bio/player/fx_footstep_sand" );
	util::setFootstepEffect( "water",      "_t6/bio/player/fx_footstep_water" );
	util::setFootstepEffect( "wood",       "_t6/bio/player/fx_footstep_dust" );
}*/

function register_clientfields()
{
//	clientfield::register( "missile", "cf_m_proximity", VERSION_SHIP, 1, "int", &callback::callback_proximity, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
//	clientfield::register( "missile", "cf_m_emp", VERSION_SHIP, 1, "int", &callback::callback_emp, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
//	clientfield::register( "missile", "cf_m_stun", VERSION_SHIP, 1, "int", &callback::callback_stunned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
//	
//	clientfield::register( "scriptmover", "cf_s_emp", VERSION_SHIP, 1, "int", &callback::callback_emp, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
//	clientfield::register( "scriptmover", "cf_s_stun", VERSION_SHIP, 1, "int", &callback::callback_stunned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	clientfield::register( "toplayer", "sndHealth", 1, 2, "int", &audio::sndHealthSystem, !true, !true );
}
