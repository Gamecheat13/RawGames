#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\clientfaceanim_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\footsteps_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\archetype_shared\archetype_shared;

//Abilities
#using scripts\shared\abilities\_ability_player;	//DO NOT REMOVE - needed for system registration

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_destructible;
#using scripts\zm\_callbacks;
#using scripts\zm\_sticky_grenade;
#using scripts\shared\util_shared;

//System registration
#using scripts\zm\_ambient;
#using scripts\zm\_global_fx;
#using scripts\zm\_radiant_live_update;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_traps;
#using scripts\zm\gametypes\_weaponobjects;
#using scripts\zm\craftables\_zm_craftables;

//Weapon registration
#using scripts\zm\gametypes\_weaponobjects;

#namespace load;

function levelNotifyHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		level notify(state,clientNum);
	}
}

function warnMissileLocking( localClientNum, set )
{
	/*if ( set && !(self islocalplayerviewlinked(localClientNum)) )
		return;
		
	_helicopter_sounds::play_targeted_sound( set );*/
}

function warnMissileLocked( localClientNum, set )
{
	/*if ( set && !(self islocalplayerviewlinked(localClientNum)) )
		return;

	_helicopter_sounds::play_locked_sound( set );*/
}

function warnMissileFired( localClientNum, set )
{
	/*if ( set && !(self islocalplayerviewlinked(localClientNum)) )
		return;

	_helicopter_sounds::play_fired_sound( set );*/
}

function main()
{
	/#
	
	Assert( isdefined( level.first_frame ), "There should be no waits before load::main." );
	
	#/
	
	zm::init();
		
	level thread server_time();
	level thread util::init_utility();

	util::register_system("levelNotify",&levelNotifyHandler);
	
	register_clientfields();
	
	level.createFX_disable_fx = (GetDvarInt("disable_fx") == 1);
	
	//level thread _dogs::init();
	if (  level._uses_sticky_grenades )
	{
		level thread _sticky_grenade::main();
	}

	system::wait_till( "all" );

	level thread load::art_review();

	level flagsys::set( "load_main_complete" );
}

function server_time()
{
	for (;;)
	{
		level.serverTime = getServerTime( 0 );
		wait( 0.01 );
	}
}

function register_clientfields()
{
	//clientfield::register( "missile", "cf_m_proximity", VERSION_SHIP, 1, "int", &callback::callback_proximity, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "missile", "cf_m_emp", VERSION_SHIP, 1, "int", &callback::callback_emp, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "missile", "cf_m_stun", VERSION_SHIP, 1, "int", &callback::callback_stunned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	//clientfield::register( "scriptmover", "cf_s_emp", VERSION_SHIP, 1, "int", &callback::callback_emp, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "scriptmover", "cf_s_stun", VERSION_SHIP, 1, "int", &callback::callback_stunned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	//clientfield::register( "world", "sndPrematch", VERSION_SHIP, 1, "int", &audio::sndMPPrematch, CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "toplayer", "sndMelee", VERSION_SHIP, 1, "int", &audio::weapon_butt_sounds, CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "toplayer", "sndEMP", VERSION_SHIP, 1, "int", &audio::sndEMP, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );	
	
	clientfield::register( "allplayers", "zmbLastStand", 1, 1, "int", &zm::Laststand, !true, true );

	clientfield::register( "clientuimodel", "zmhud.swordEnergy", 1, 7, "float", undefined, !true, !true );
	clientfield::register( "clientuimodel", "zmhud.swordState", 1, 2, "int", undefined, !true, !true );
	clientfield::register( "clientuimodel", "zmhud.swordChargeUpdate", 1, 1, "counter", undefined, !true, !true );
	//clientfield::register( "toplayer", "zmbLastStand", VERSION_SHIP, 1, "int", &zm_audio::sndZmbLaststand, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
}
