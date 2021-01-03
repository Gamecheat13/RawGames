#using scripts\codescripts\struct;

#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientfield_shared;
#using scripts\shared\clientfaceanim_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\footsteps_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\spike_charge;
#using scripts\shared\weapons\_lightninggun;
#using scripts\shared\weapons\_pineapple_gun;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\multilockapguidance;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_util;

//System registration
#using scripts\mp\_ambient;
#using scripts\shared\_burnplayer;
#using scripts\mp\_callbacks;
#using scripts\mp\_ctf;
#using scripts\mp\_destructible;
#using scripts\mp\_global_fx;
#using scripts\mp\_multi_extracam;
#using scripts\mp\_perks;
#using scripts\mp\_radiant_live_update;
#using scripts\mp\_rewindobjects;
#using scripts\mp\_rotating_object;
#using scripts\mp\_vehicle;
#using scripts\mp\_end_game_flow;
#using scripts\mp\mpdialog;

//Weapon registration
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\mp\_bouncingbetty;
#using scripts\mp\_hacker_tool;
#using scripts\mp\_hive_gun;
#using scripts\mp\_claymore;
#using scripts\mp\_decoy;
#using scripts\mp\_explosive_bolt;
#using scripts\mp\_flashgrenades;
#using scripts\mp\_gravity_spikes;
#using scripts\mp\_lightninggun;
#using scripts\mp\_proximity_grenade;
#using scripts\mp\_riotshield;
#using scripts\mp\_satchel_charge;
#using scripts\mp\_threat_detector;
#using scripts\mp\_tacticalinsertion;
#using scripts\mp\_trophy_system;
#using scripts\mp\gametypes\_weaponobjects;

//Killstreak registration
#using scripts\mp\_helicopter_sounds;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_dart;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_helicopter_gunner;
#using scripts\mp\killstreaks\_flak_drone;
#using scripts\mp\killstreaks\_microwave_turret;
#using scripts\mp\killstreaks\_planemortar;
#using scripts\mp\killstreaks\_remotemissile;
#using scripts\mp\killstreaks\_raps;
#using scripts\mp\killstreaks\_killstreak_detect;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

//Abilities registration
#using scripts\shared\abilities\_ability_player;

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
	
	level thread util::serverTime();
	level thread util::init_utility();

	util::registerSystem("levelNotify",&levelNotifyHandler);

	register_clientfields();
	
	level.createFX_disable_fx = (GetDvarInt("disable_fx") == 1);
	
	//The functions are threaded just in case any of them create 'wait's. Note these functions should not have 'wait's in their 'init' and 'main' functions.

//	footsteps();
	
	system::wait_till( "all" );
	
	level flagsys::set( "load_main_complete" );
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
	clientfield::register( "missile", "cf_m_proximity", 1, 1, "int", &callback::callback_proximity, !true, !true );
	clientfield::register( "missile", "cf_m_emp", 1, 1, "int", &callback::callback_emp, !true, !true );
	clientfield::register( "missile", "cf_m_stun", 1, 1, "int", &callback::callback_stunned, !true, !true );
	
	//clientfield::register( "scriptmover", "cf_s_emp", VERSION_SHIP, 1, "int", &callback::callback_emp, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "scriptmover", "cf_s_stun", VERSION_SHIP, 1, "int", &callback::callback_stunned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
}
