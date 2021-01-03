#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;

#namespace zm_audio;

function autoexec __init__sytem__() {     system::register("zm_audio",&__init__,undefined,undefined);    }

function __init__()
{
	// "allplayers" may need to be used instead of "toplayer" because it is possible the player in question is being spectated
	clientfield::register( "allplayers", "charindex", 1, 3, "int", &charindex_cb, !true, true ); 
	
	//to prevent exert sounds on the client from stepping on VO sounds on the server. 
	clientfield::register( "toplayer", "isspeaking", 1, 1, "int", &isspeaking_cb, !true, true ); 
	
	level.exert_sounds = [];
	
	// sniper hold breath
	level.exert_sounds[0]["playerbreathinsound"] = "vox_exert_generic_inhale";
	
	// sniper exhale
	level.exert_sounds[0]["playerbreathoutsound"] = "vox_exert_generic_exhale";
	
	// sniper hold breath
	level.exert_sounds[0]["playerbreathgaspsound"] = "vox_exert_generic_exhale";

	// falling damage
	level.exert_sounds[0]["falldamage"] = "vox_exert_generic_pain";
	
	// mantle launch
	level.exert_sounds[0]["mantlesoundplayer"] = "vox_exert_generic_mantle";
	
	// melee swipe
	level.exert_sounds[0]["meleeswipesoundplayer"] = "vox_exert_generic_knifeswipe";
	
	// DTP land ** this may need to be expanded to take surface type into account
	level.exert_sounds[0]["dtplandsoundplayer"] = "vox_exert_generic_pain";

	// custom character exerts - most of the exert sounds will be set up here
	//if (isdefined(level.setupCustomCharacterExerts))
	//	[[level.setupCustomCharacterExerts]]();
	
	level thread gameover_snapshot();
	
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned(localclientnum)
{
	//audio::snd_set_snapshot( "zmb_game_start" );
}

function delay_set_exert_id(newVal)
{
	self endon("entityshutdown");
	self endon("sndEndExertOverride");
	wait 0.5;
	self.player_exert_id = newVal; 
}

function charindex_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if (!bNewEnt)
	{
		self.player_exert_id = newVal; 
		self._first_frame_exert_id_recieved = true;
		self notify( "sndEndExertOverride" );
	}
	else if(!isdefined(self._first_frame_exert_id_recieved))
	{
		self._first_frame_exert_id_recieved = true;
		self thread delay_set_exert_id(newVal);
	}
}

function isspeaking_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if (!bNewEnt)
	{
		self.isSpeaking = newVal; 
	}
	else
	{
		self.isSpeaking = 0;
	}
}


//GAMETYPE GENERAL AUDIO FUNCTIONS
function zmbMusLooper()
{
	ent = spawn( 0, (0,0,0), "script_origin" );
	playsound( 0, "mus_zmb_gamemode_start", (0,0,0) );
	wait(10);
	ent playloopsound( "mus_zmb_gamemode_loop", .05 );
	ent thread waitfor_music_stop();
}
function waitfor_music_stop()
{
	level waittill( "stpm" );
	self StopAllLoopSounds( .1 );
	playsound( 0, "mus_zmb_gamemode_end", (0,0,0) );
	wait(1);
	self delete();
}

function playerFallDamageSound(client_num, firstperson)
{
	self playerExert( client_num, "falldamage" );
	/*
	sound_alias = "vox_plr_0_exert_breathing_hurt";
	if ( firstperson )
	{
		sound_alias = "vox_plr_0_exert_breathing_hurt";
		self playsound( client_num, sound_alias );
	}
	*/
}


function clientVoiceSetup()
{
	callback::on_localclient_connect( &audio_player_connect );

	players = GetLocalPlayers();
	for (i = 0; i<players.size; i++)
		thread audio_player_connect( i );
	
}

function audio_player_connect( localClientNum )
{
	thread sndVoNotifyPlain( localClientNum, "playerbreathinsound" ); 
	thread sndVoNotifyPlain( localClientNum, "playerbreathoutsound" ); 
	thread sndVoNotifyPlain( localClientNum, "playerbreathgaspsound" ); 
	thread sndVoNotifyPlain( localClientNum, "mantlesoundplayer" ); 
	thread sndVoNotifyPlain( localClientNum, "meleeswipesoundplayer" );
	//thread sndMeleeSwipe( localClientNum, "meleeswipesoundplayer" ); 	
	thread sndVoNotifyDTP( localClientNum, "dtplandsoundplayer" ); 
}


function playerExert( localClientNum, exert )
{
	if(IsDefined(self.isSpeaking) && self.isSpeaking == 1)
	{
		return;
	}
	
	id = level.exert_sounds[0][exert];
	
	if( isArray(level.exert_sounds[0][exert]))
	{
		id = array::random(level.exert_sounds[0][exert]);
	}
	
	if ( isdefined(self.player_exert_id) )
	{
		if(IsArray(level.exert_sounds[self.player_exert_id][exert]))
		{
			id = array::random(level.exert_sounds[self.player_exert_id][exert]);
		}
		else
		{
			id = level.exert_sounds[self.player_exert_id][exert];
		}
	}
	
	if( isdefined( id ) )
		self playsound ( localClientNum, id);
}

function sndVoNotifyDTP( localClientNum, notifyString )
{
	player = undefined;
	while( !IsDefined( player ) )
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait( 0.05 );
	}
	player endon("disconnect");
	
	for(;;)
	{	
		player waittill ( notifyString, surfaceType );
		// for now we are ignoring the surface type
		player playerExert( localClientNum, notifyString );
	}
}

function sndMeleeSwipe( localClientNum, notifyString )
{
	player = undefined;
	while( !IsDefined( player ) )
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait( 0.05 );
	}
	player endon("disconnect");
	for(;;)
	{	
		player waittill ( notifyString );
		currentweapon = GetCurrentWeapon( localClientNum );
		
		if( ( isdefined( level.sndNoMeleeOnClient ) && level.sndNoMeleeOnClient ) )
		{	
			return;
		}

		if (( isdefined( player.is_player_zombie ) && player.is_player_zombie ))
		{	
			playsound( 0, "zmb_melee_whoosh_zmb_plr", player.origin );
		}
		else if( currentweapon.name == "bowie_knife" )
		{	
			playsound( 0, "zmb_bowie_swing_plr", player.origin );
		}
		else if( currentweapon.name == "spoon_zm_alcatraz" )
		{	
			playsound( 0, "zmb_spoon_swing_plr", player.origin );
		}
		else if( currentweapon.name == "spork_zm_alcatraz" )
		{	
			playsound( 0, "zmb_spork_swing_plr", player.origin );
		}
		else
		{
			playsound( 0, "zmb_melee_whoosh_plr", player.origin );
		}
	}
}

function sndVoNotifyPlain( localClientNum, notifyString )
{
	player = undefined;
	while( !IsDefined( player ) )
	{
		player = GetNonPredictedLocalPlayer(localClientNum);
		wait( 0.05 );
	}
	player endon("disconnect");
	for(;;)
	{	
		player waittill ( notifyString );
		
		if( ( isdefined( player.is_player_zombie ) && player.is_player_zombie ) )
			continue;
		
		player playerExert( localClientNum, notifyString );
	}
}


function end_gameover_snapshot()
{
	level util::waittill_any( "demo_jump", "demo_player_switch", "snd_clear_script_duck" );

	wait(1);
	
	audio::snd_set_snapshot( "default" );
	
	level thread gameover_snapshot();
}


function gameover_snapshot()
{
	level waittill( "zesn" );
	audio::snd_set_snapshot( "zmb_game_over" );
	level thread end_gameover_snapshot();
}

function sndSetZombieContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal == 1 )
	{
		self setsoundentcontext("grass", "no_grass");
	}
	else
	{
		self setsoundentcontext("grass", "in_grass");
	}
}

function sndZmbLaststand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		PlaySound( localClientNum, "chr_health_laststand_enter", (0,0,0) );
		forceambientroom( "sndHealth_LastStand" );
		self.inLastStand = true;
	}
	else
	{
		if( ( isdefined( self.inLastStand ) && self.inLastStand ) )
		{
			forceambientroom( "" );
			playsound( localClientNum, "chr_health_laststand_exit", (0,0,0) );
			self.inLastStand = false;
		}
	}
}