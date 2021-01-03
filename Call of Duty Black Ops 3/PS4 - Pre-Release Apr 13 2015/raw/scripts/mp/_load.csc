#using scripts\codescripts\struct;

//TODO T7 - move what we can into load_shared once ZM gets a pass
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\objpoints_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_ballistic_knife;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_chemicalgel;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_lightninggun;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_sensor_grenade;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\multilockapguidance;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\_art;
#using scripts\mp\_destructible;
#using scripts\mp\_load;
#using scripts\mp\_util;

//REGISTRATION - These scripts are initialized here
//Do not remove unless you are removing the script from the game

//System registration
#using scripts\mp\_arena;
#using scripts\mp\_bb;
#using scripts\shared\_burnplayer;
#using scripts\mp\_callbacks;
#using scripts\mp\_devgui;
#using scripts\mp\_medals;
#using scripts\mp\_perks;
#using scripts\mp\_popups;
#using scripts\mp\_vehicle;

//Gametypes Registration - DO NOT REMOVE
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;

//Killstreak registration
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_drone_strike;
#using scripts\mp\killstreaks\_helicopter_guard;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_uav;

//Weapon registration
#using scripts\shared\weapons\_pineapple_gun;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\mp\_ballistic_knife;
#using scripts\mp\_bouncingbetty;
#using scripts\mp\_chemicalgel;
#using scripts\mp\_explosive_bolt;
#using scripts\mp\_flashgrenades;
#using scripts\mp\_hacker_tool;
#using scripts\mp\_heatseekingmissile;
#using scripts\mp\_incendiary;
#using scripts\mp\_armblade;
#using scripts\mp\_lightninggun;
#using scripts\mp\_proximity_grenade;
#using scripts\mp\_riotshield;
#using scripts\mp\_satchel_charge;
#using scripts\mp\_sensor_grenade;
#using scripts\mp\_threat_detector;
#using scripts\mp\_smokegrenade;
#using scripts\mp\_tacticalinsertion;
#using scripts\mp\_trophy_system;
#using scripts\mp\gametypes\_weaponobjects;

//Abilities registration
#using scripts\shared\abilities\_ability_player;

#precache( "fx", "_t6/bio/player/fx_footstep_dust" );
#precache( "fx", "_t6/bio/player/fx_footstep_sand" );
#precache( "fx", "_t6/bio/player/fx_footstep_mud" );
#precache( "fx", "_t6/bio/player/fx_footstep_water" );

#namespace load;

function main()
{
	/#
	
	Assert( isdefined( level.first_frame ), "There should be no waits before load::main." );
	
	#/
	
	level._loadStarted = true;
	
	register_clientfields();
	
	level.aiTriggerSpawnFlags = getaitriggerflags();
	level.vehicleTriggerSpawnFlags = getvehicletriggerflags();
	
	setup_traversals();
 	
 	//TODO T7 - remove once globallogic_audio is shared
	level.globallogic_audio_dialog_on_player_override = &globallogic_audio::leader_dialog_on_player;

	system::wait_till( "all" );	
	level flagsys::set( "load_main_complete" );
}

function setFootstepEffect(name, fx)
{
	assert(isdefined(name), "Need to define the footstep surface type.");
	assert(isdefined(fx), "Need to define the mud footstep effect.");
	if (!isdefined(anim.optionalStepEffects))
		anim.optionalStepEffects = [];
	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}

function footsteps()
{
	setFootstepEffect( "asphalt",  "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "brick",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "carpet",   "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "cloth",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "concrete", "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "dirt",     "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "foliage",  "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "gravel",   "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "grass",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "metal",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "mud",      "_t6/bio/player/fx_footstep_mud" ); 
	setFootstepEffect( "paper",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "plaster",  "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "rock",     "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "sand",     "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "water",    "_t6/bio/player/fx_footstep_water" ); 
	setFootstepEffect( "wood",     "_t6/bio/player/fx_footstep_dust" ); 
}

// All "Begin" nodes get passed in here through _load.gsc
function init_traverse()
{
	point = GetEnt(self.target, "targetname");
	if (isdefined(point))
	{
		self.traverse_height = point.origin[2];
		point Delete();
	}
 	else
 	{
 		point = struct::get(self.target, "targetname");
 		if (isdefined(point))
 		{
 			self.traverse_height = point.origin[2];
 		}
 	}
}

function setup_traversals()
{
	potential_traverse_nodes = GetAllNodes();
	for (i = 0; i < potential_traverse_nodes.size; i++)
	{
		node = potential_traverse_nodes[i];
		if (node.type == "Begin")
		{
			node init_traverse();
		}
	}
}

function register_clientfields()
{
	clientfield::register( "missile", "cf_m_proximity", 1, 1, "int" );
	clientfield::register( "missile", "cf_m_emp", 1, 1, "int" );
	clientfield::register( "missile", "cf_m_stun", 1, 1, "int" );
	
	//clientfield::register( "scriptmover", "cf_s_emp", VERSION_SHIP, 1, "int" );
	//clientfield::register( "scriptmover", "cf_s_stun", VERSION_SHIP, 1, "int" );
}
