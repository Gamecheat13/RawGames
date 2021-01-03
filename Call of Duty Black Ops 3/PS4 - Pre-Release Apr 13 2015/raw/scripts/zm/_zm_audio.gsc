#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                	                                     	                            	                                 	                                                           	                                                           	                                                                                           	                                                                                                                 	                                             

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace zm_audio;

function autoexec __init__sytem__() {     system::register("zm_audio",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "allplayers", "charindex", 1, 3, "int" ); 
	clientfield::register( "toplayer", "isspeaking",1, 1, "int" ); 
	
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_audio.gsc)" );	#/
	level.audio_get_mod_type = &get_mod_type;
	level zmbVox();
	callback::on_connect( &init_audio_functions );
	
	level thread sndMusicSystem_Init();
	level thread sndAnnouncer_Init();
}

function SetExertVoice( exert_id )
{
	self.player_exert_id = exert_id; 
	self clientfield::set( "charindex", self.player_exert_id );
	
}

function playerExert( exert )
{
	if(( isdefined( self.isSpeaking ) && self.isSpeaking ) || ( isdefined( self.isexerting ) && self.isexerting ) )
	{
		return;
	}
	id = level.exert_sounds[0][exert];
	if( isDefined(self.player_exert_id) )
	{
		if (!isdefined(level.exert_sounds) || !isdefined(level.exert_sounds[self.player_exert_id]) || !isdefined(level.exert_sounds[self.player_exert_id][exert]))
			return;
		if(IsArray(level.exert_sounds[self.player_exert_id][exert]))
		{
			id = array::random(level.exert_sounds[self.player_exert_id][exert]);
		}
		else
		{
			id = level.exert_sounds[self.player_exert_id][exert];
		}
	}
	
	if (isdefined(id))
	{
		self.isexerting = true;
		self thread exert_timer();
		self playsound (id);
	}
}

function exert_timer()
{
	self endon("disconnect");
	//wait(1);	
	//self.isexerting = true;
	wait( randomfloatrange (1.5,3));
	self.isexerting = false;
	
}



//All Vox should be found in this section.
//If there is an Alias that needs to be changed, check here first.
function zmbVox()
{
	level.votimer = [];
	
	level.vox = zmbVoxCreate();

	//Init Level Specific Vox
	if( isdefined( level._zmbVoxLevelSpecific ) )
		level thread [[level._zmbVoxLevelSpecific]]();
	
	//Init Gametype Specific Vox
	if( isdefined( level._zmbVoxGametypeSpecific ) )
		level thread [[level._zmbVoxGametypeSpecific]]();
	
	announcer_ent = spawn( "script_origin", (0,0,0) );
	level.vox zmbVoxInitSpeaker( "announcer", "vox_zmba_", announcer_ent );

	// sniper hold breath
	level.exert_sounds[0]["burp"] = "evt_belch";

	// medium hit
	level.exert_sounds[0]["hitmed"] = "null";

	// large hit
	level.exert_sounds[0]["hitlrg"] = "null";

	// custom character exerts
	if (isdefined(level.setupCustomCharacterExerts))
		[[level.setupCustomCharacterExerts]]();
}

function init_audio_functions()
{
	self thread zombie_behind_vox();
	self thread player_killstreak_timer();
	
	if(isdefined(level._custom_zombie_oh_shit_vox_func))
	{
		self thread [[level._custom_zombie_oh_shit_vox_func]]();
	}
	else
	{
    	self thread oh_shit_vox();
	}
}

//Plays a specific Zombie vocal when they are close behind the player
//Self is the Player(s)
function zombie_behind_vox()
{
	level endon("unloaded");
	self endon("death_or_disconnect");
	
	if(!IsDefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;	
		level._audio_zbv_shared_ent_list = zombie_utility::get_round_enemy_array();
	}
	
	while(1)
	{
		wait(1);		
		
		t = GetTime();
		
		if(t > level._zbv_vox_last_update_time + 1000)
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = zombie_utility::get_round_enemy_array();
		}
		
		zombs = level._audio_zbv_shared_ent_list;
		
		played_sound = false;
		
		for(i=0;i<zombs.size;i++)
		{
			if(!isDefined(zombs[i]))
			{
				continue;
			}
			
			if(zombs[i].isdog)
			{
				continue;
			}
				
			dist = 200;	
			z_dist = 50;	
			alias = level.vox_behind_zombie;
					
			if(IsDefined(zombs[i].zombie_move_speed))
			{
				switch(zombs[i].zombie_move_speed)
				{
					case "walk": dist = 200;break;
					case "run": dist = 250;break;
					case "sprint": dist = 275;break;
				}	
			}			
			if(DistanceSquared(zombs[i].origin,self.origin) < dist * dist )
			{				
				yaw = self zm_utility::GetYawToSpot(zombs[i].origin );
				z_diff = self.origin[2] - zombs[i].origin[2];
				if( (yaw < -95 || yaw > 95) && abs( z_diff ) < 50 )
				{
					zombs[i] notify( "bhtn_action_notify", "behind" );
					played_sound = true;
					break;
				}			
			}
		}
		
		if(played_sound)
		{
			wait(5);		// Each player can only play one instance of this sound every 5 seconds - instead of the previous network storm.
		}
	}
}

function oh_shit_vox()
{
	self endon("death_or_disconnect");
	
	while(1)
	{
		wait(1);
		
		players = GetPlayers();
		zombs = zombie_utility::get_round_enemy_array();
	
		if( players.size >= 1 )
		{
			close_zombs = 0;
			for( i=0; i<zombs.size; i++ )
			{
				if( (isDefined(zombs[i].favoriteenemy) && zombs[i].favoriteenemy == self) || !isDefined(zombs[i].favoriteenemy) )
				{
					if( DistanceSquared( zombs[i].origin, self.origin ) < 250 * 250)
					{
						close_zombs ++;
					}
				}
			}
			if( close_zombs > 4 )
			{
				self zm_audio::create_and_play_dialog( "general", "oh_shit" );
				wait(4);	
			}
		}
	}
}

//** Player Killstreaks: The following functions start a timer on each player whenever they begin killing zombies.
//** If they kill a certain amount of zombies within a certain time, they will get a Killstreak line
function player_killstreak_timer()
{
	self endon("disconnect");
	self endon("death");
	
	if(GetDvarString ("zombie_kills") == "") 
	{
		SetDvar ("zombie_kills", "7");
	}	
	if(GetDvarString ("zombie_kill_timer") == "") 
	{
		SetDvar ("zombie_kill_timer", "5");
	}

	kills = GetDvarInt( "zombie_kills");
	time = GetDvarInt( "zombie_kill_timer");

	if (!isdefined (self.timerIsrunning))	
	{
		self.timerIsrunning = 0;
		self.killcounter = 0;
	}

	while(1)
	{
		self waittill( "zom_kill", zomb );	
		
		if( IsDefined( zomb._black_hole_bomb_collapse_death ) && zomb._black_hole_bomb_collapse_death == 1 )
		{
		    continue;
		}
		
		if( ( isdefined( zomb.microwavegun_death ) && zomb.microwavegun_death ) )
		{
			continue;
		}
		
		self.killcounter ++;

		if (self.timerIsrunning != 1)	
		{
			self.timerIsrunning = 1;
			self thread timer_actual(kills, time);			
		}
	}	
}

function player_zombie_kill_vox( hit_location, player, mod, zombie )
{
	weapon = player GetCurrentWeapon();
	dist = DistanceSquared( player.origin, zombie.origin );
	
	if( !isdefined(level.zombie_vars[player.team]["zombie_insta_kill"] ) )
		level.zombie_vars[player.team]["zombie_insta_kill"] = 0;
		
	instakill = level.zombie_vars[player.team]["zombie_insta_kill"];
	
	death = [[ level.audio_get_mod_type ]]( hit_location, mod, weapon, zombie, instakill, dist, player );

	if( !( isdefined( player.force_wait_on_kill_line ) && player.force_wait_on_kill_line ) )
	{
		player.force_wait_on_kill_line = true;
		player create_and_play_dialog( "kill", death );
		wait(2);
		if(isdefined(player))	// Host migration or simple disconnection during this wait can lead to the following line causing an SRE.
		{
			player.force_wait_on_kill_line = false;
		}
	}
}

function get_response_chance( event )
{
	if(!isDefined(level.response_chances[event] ))
	{
		return 0;
	}
	return level.response_chances[event];
}

function get_mod_type( impact, mod, weapon, zombie, instakill, dist, player )
{
	close_dist = 64 * 64;
	med_dist = 124 * 124;
	far_dist = 400 * 400;
	
	if( zm_utility::is_placeable_mine( weapon ) )
	{
	    if( !instakill )
	        return "betty";
	    else
	        return "weapon_instakill";
	}
	
	if ( zombie.damageweapon.name ==  "cymbal_monkey" )
	{
		if(instakill)
			return "weapon_instakill";
		else
			return "monkey";
	}
	
	//RAYGUN & RAYGUN_INSTAKILL
	if( weapon.name == "ray_gun" && dist > far_dist )
	{
		if( !instakill )
			return "raygun";
		else
			return "weapon_instakill";
	}
	
	//HEADSHOT
	if( zm_utility::is_headshot(weapon,impact,mod) && dist >= far_dist )
	{
		return "headshot";
	}	
	
	//MELEE & MELEE_INSTAKILL
	if ( (mod == "MOD_MELEE" || mod == "MOD_UNKNOWN") && dist < close_dist )
	{
		if( !instakill )
			return "melee";
		else
			return "melee_instakill";
	}
	
	//EXPLOSIVE & EXPLOSIVE_INSTAKILL
	if( zm_utility::is_explosive_damage( mod ) && weapon.name != "ray_gun" && !( isdefined( zombie.is_on_fire ) && zombie.is_on_fire ) )
	{
		if( !instakill )
			return "explosive";
		else
			return "weapon_instakill";
	}
	
	//FLAME & FLAME_INSTAKILL
	if( weapon.doesFireDamage && ( mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" ) )
	{
		if( !instakill )
			return "flame";
		else
			return "weapon_instakill";
	}
		
	if (!isdefined(impact))
		impact = "";
	
	//BULLET & BULLET_INSTAKILL
	if( mod == "MOD_RIFLE_BULLET" ||   mod == "MOD_PISTOL_BULLET" )
	{
		if( !instakill )
			return "bullet";
		else
			return "weapon_instakill";
	}
	
	if(instakill)
	{
		return "default";
	}
	
	//CRAWLER
	if( mod != "MOD_MELEE" && zombie.missingLegs )
	{
		return "crawler";
	}
	
	//CLOSEKILL
	if( mod != "MOD_BURNED" && dist < close_dist  )
	{
		return "close";
	}
	
	return "default";
}

function timer_actual(kills, time)
{
	self endon("disconnect");
	self endon("death");
	
	timer = gettime() + (time * 1000);
	while(getTime() < timer)
	{
		if (self.killcounter > kills )
		{
			self create_and_play_dialog( "kill", "streak" );

			wait(1);
		
			//resets the killcounter and the timer 
			self.killcounter = 0;

			timer = -1;
		}
		wait(0.1);
	}
	wait(10); //10 seconds before he can say this again
	self.killcounter = 0;
	self.timerIsrunning = 0;
}	

function zmbVoxCreate()
{
	vox = SpawnStruct(); 
	vox.speaker = []; 
	return( vox );
}
function zmbVoxInitSpeaker( speaker, prefix, ent )
{
	ent.zmbVoxID = speaker;
	
	if( !isdefined( self.speaker[speaker] ) )
	{
		self.speaker[speaker] = SpawnStruct();
		self.speaker[speaker].alias = [];
	}
	
	self.speaker[speaker].prefix = prefix;
	self.speaker[speaker].ent = ent;
}


function custom_kill_damaged_VO( player ) // self = zombie
{
	self notify( "sound_damage_player_updated" );
	
	self endon( "death" );
	self endon( "sound_damage_player_updated" );
	
	self.sound_damage_player = player;

	wait 2;

	self.sound_damage_player = undefined;	
}


/*
 * 		
 * 		UPDATED DIALOG SYSTEM SECTION
 * 		Contains new way of importing lines per level
 * 		Cleans up unneeded function and uses
 * 		Check out _zm_audio.gsh for definitions if unsure
 * 
 */

function loadPlayerVoiceCategories(table)
{
	level.votimer = [];
	level.sndPlayerVox = [];
	
	index = 0;
	row = TableLookupRow( table, index );
	
	while ( isdefined( row ) )
	{
		//Get this weapons data from the current tablerow
		category 		= checkStringValid( row[0] );
		subcategory 	= checkStringValid( row[1] );
		suffix 			= checkStringValid( row[2] );
		percentage 		= int( row[3] );
		
		if( percentage <= 0 )
			percentage = 100;
		
		response		= checkStringTrue( row[4] );
		
		if( ( isdefined( response ) && response ) )
		{
			zmbVoxAdd( category, subcategory + "_resp_hr", suffix + "_resp_hr", percentage, false );
			zmbVoxAdd( category, subcategory + "_resp_riv", suffix + "_resp_riv", percentage, false );
		}
		
		zmbVoxAdd( category, subcategory, suffix, percentage, response );

		index++;
		row = TableLookupRow( table, index );
	}
}
function checkStringValid( str )
{
	if( str != "" )
		return str;
	return undefined;
}
function checkStringTrue( str )
{
	if( !isdefined( str ) )
		return false;
	
	if( str != "" )
	{
		if( ToLower( str ) == "true" )
			return true;
	}
	return false;
}
function zmbVoxAdd( category, subcategory, suffix, percentage, response )
{
	Assert( IsDefined( category ) );
	Assert( IsDefined( subcategory ) );
	Assert( IsDefined( suffix ) );
	Assert( IsDefined( percentage ) );
	Assert( IsDefined( response ) );
	
	vox = level.sndPlayerVox;
	
	if( !isdefined( vox[category] ) )
		vox[category] = [];
	
	vox[category][subcategory] = spawnstruct();
	vox[category][subcategory].suffix = suffix;
	vox[category][subcategory].percentage = percentage;
	vox[category][subcategory].response = response;
	
	zm_utility::create_vox_timer(subcategory);
}

function create_and_play_dialog( category, subcategory, force_variant )
{              
	if( !IsDefined( level.sndPlayerVox ) )
		return;
	
	if( !IsDefined( level.sndPlayerVox[category] ) )
		return;
	
	if( !IsDefined( level.sndPlayerVox[category][subcategory] ) )
	{
		/#
		if( GetDvarInt( "debug_audio" ) > 0 )
			println( "DIALOG ERROR: No Category " + category + " or Subcategory " + subcategory + ". No dialog will play" );
		#/
		return;
	}
	
	if( ( isdefined( level.sndVoxOverride ) && level.sndVoxOverride ) )
		return;
	
	suffix =  level.sndPlayerVox[category][subcategory].suffix;
	percentage =  level.sndPlayerVox[category][subcategory].percentage;
	
	prefix = shouldPlayerSpeak(self, subcategory, percentage );
	if( !isdefined( prefix ) )
		return;
	
    sound_to_play = self zmbVoxGetLineVariant( prefix, suffix, force_variant );
    
    if( isdefined( sound_to_play ) )
    {
		self thread do_player_or_npc_playvox( sound_to_play, category, subcategory );
    }
    else
    {
    	/#
		if( GetDvarInt( "debug_audio" ) > 0 )
			iprintln( "DIALOG DEBUGGER: SOUND_TO_PLAY is undefined" );
		#/
    }
}
function do_player_or_npc_playvox( sound_to_play, category, subcategory )
{
	self endon("death_or_disconnect");

	if ( !IsDefined( self.isSpeaking ) )
	{
		self.isSpeaking = false;
	}

	if ( ( isdefined( self.isSpeaking ) && self.isSpeaking ) )
	{
		return;
	}
	
	waittime = 1;

	if ( !self areNearbySpeakersActive() || ( isdefined( self.ignoreNearbySpkrs ) && self.ignoreNearbySpkrs ) )
	{
		self.speakingLine = sound_to_play;
		
		self.isSpeaking = true;
		if(isPlayer(self))
		{
			self clientfield::set_to_player( "isspeaking",1 ); 
		}

		playbackTime = soundgetplaybacktime( sound_to_play );
		
		if( !isdefined( playbackTime ) )
			return;
		
		if ( playbackTime >= 0 )
		{
			playbackTime = playbackTime * .001;
		}
		else
		{
			playbackTime = 1;
		}
		
		self PlaySoundOnTag( sound_to_play, "J_Head" );
		//self PlaySoundWithNotify( sound_to_play, "sound_done" + sound_to_play );
		wait(playbackTime);
		
		if( isPlayer(self) && isDefined(self.last_vo_played_time)  )
		{
			if( GetTime() < ( self.last_vo_played_time + 5000 ) )
			{
				self.last_vo_played_time = GetTime();
				waittime = 7;
			}
		}
		
		wait( waittime );
		
		self.isSpeaking = false;
		
		if(isPlayer(self))
		{
			self clientfield::set_to_player( "isspeaking",0 ); 
		}
		
		if( !level flag::get( "solo_game" ) && ( isdefined( level.sndPlayerVox[category][subcategory].response ) && level.sndPlayerVox[category][subcategory].response ) )
		{
			level thread setup_response_line( self, category, subcategory );
		}
	}
}	
function setup_response_line( player, category, subcategory )
{
	switch( player.entity_num )
	{
		case 0:
			level setup_hero_rival( player, 1, 3, category, subcategory );
		break;
		
		case 1:
			level setup_hero_rival( player, 3, 2, category, subcategory );
		break;
		
		case 2:
			level setup_hero_rival( player, 0, 1, category, subcategory );
		break;
		
		case 3:
			level setup_hero_rival( player, 2, 0, category, subcategory );
		break;
	}
	return;
}
function setup_hero_rival( player, hero, rival, category, subcategory )
{
	players = GetPlayers();
	
    hero_player = undefined;
    rival_player = undefined;
    
    foreach(ent in players)
    {
    	if(ent.characterIndex == hero )
    	{
    		hero_player = ent;
    	}
    	else if (ent.characterIndex == rival )
    	{
    		rival_player = ent;
    	}
    }    
	
    if(isDefined(hero_player) && isDefined(rival_player))
	{
    	if( randomint(100) > 50 )
		{
			hero_player = undefined;
		}
		else
		{
			rival_player = undefined;
		}
	}	
	if( IsDefined( hero_player ) && distancesquared (player.origin, hero_player.origin) < 500*500 )
	{		
		hero_player create_and_play_dialog( category, subcategory + "_resp_hr" );
	}		
	else if(IsDefined( rival_player ) && distancesquared (player.origin, rival_player.origin) < 500*500  )
	{
		rival_player create_and_play_dialog( category, subcategory + "_resp_riv" );
	}
}

function shouldPlayerSpeak(player, subcategory, percentage )
{
	if( player zm_utility::is_player() )
	{
		if ( player.sessionstate != "playing" )
			return undefined;
		
		if( player laststand::player_is_in_laststand() && ( subcategory != "revive_down" || subcategory != "revive_up" ) )
			return undefined;
	}
	
	if(( isdefined( player.dontspeak ) && player.dontspeak ))
		return undefined;
	
	if( percentage < randomintrange(1,101) )
		return undefined;
	
	index = zm_weapons::get_player_index(player);
	return "vox_plr_" + index + "_";
}
function zmbVoxGetLineVariant( prefix, suffix, force_variant )
{
	if( !IsDefined ( self.sound_dialog ) )
	{
		self.sound_dialog = [];
		self.sound_dialog_available = [];
	}
				
	if ( !IsDefined ( self.sound_dialog[ suffix ] ) )
	{
		num_variants = zm_spawner::get_number_variants( prefix + suffix );      
		
		if( num_variants <= 0 )
		{
		    /#
		    if( GetDvarInt( "debug_audio" ) > 0 )
		        PrintLn( "DIALOG DEBUGGER: No variants found for - " + prefix + suffix );
		    #/
		    return undefined;
		}     
		
		for( i = 0; i < num_variants; i++ )
		{
			self.sound_dialog[ suffix ][ i ] = i;     
		}	
		
		self.sound_dialog_available[ suffix ] = [];
	}
	
	if ( self.sound_dialog_available[ suffix ].size <= 0 )
	{
		for( i = 0; i < self.sound_dialog[ suffix ].size; i++ )
		{
			self.sound_dialog_available[ suffix ][i] = self.sound_dialog[ suffix ][i];
		}
	}
  
	variation = array::random( self.sound_dialog_available[ suffix ] );
	ArrayRemoveValue( self.sound_dialog_available[ suffix ], variation );
    
    if( IsDefined( force_variant ) )
    {
        variation = force_variant;
    }
    
    return (prefix + suffix + "_" + variation);
}
function areNearbySpeakersActive()
{
	radius = 1000; // Twice Range Of Response Radius (Which Is Currently 500 Units)
	
	nearbySpeakerActive = false;
	
	speakers = GetPlayers();
	
	foreach ( person in speakers )
	{
		if ( self == person )
		{
			continue;
		}

		if ( person zm_utility::is_player() )
		{
			// Nearby Player Isn't Currently Playing
			//--------------------------------------
			if ( person.sessionstate != "playing" )
			{
				continue;
			}
			
			// Nearby Player In Last Stand
			//----------------------------
			if ( person laststand::player_is_in_laststand() )
			{
				continue;
			}
		}
		
		if ( ( isdefined( person.isSpeaking ) && person.isSpeaking ) && !( isdefined( person.ignoreNearbySpkrs ) && person.ignoreNearbySpkrs ) )
		{
			if ( DistanceSquared( self.origin, person.origin ) < ( radius * radius ) )
			{
				nearbySpeakerActive = true;
			}
		}
	}
	
	return nearbySpeakerActive;
}

/*
 * 		
 * 		MUSIC
 * 		Encompasses both the standard Round Start/End Music system, and the updated system added in MOTD, Buried, Origins
 * 
 * 
 */
	
function sndMusicSystem_Init()
{
	//Defaults. Can't really seeing any need to change these frequently
	sndMusicSystem_CreateState( "round_start", "mus_zombie_round_start", 3 );
	sndMusicSystem_CreateState( "round_start_short", "mus_zombie_round_start_short", 3 );
	sndMusicSystem_CreateState( "round_start_first", "mus_zombie_round_start_first", 3 );
	sndMusicSystem_CreateState( "round_end", "mus_zombie_round_over", 3 );
	sndMusicSystem_CreateState( "dog_start", "mus_zombie_round_dog_start", 3 );
	sndMusicSystem_CreateState( "dog_end", "mus_zombie_round_dog_over", 3 );
	sndMusicSystem_CreateState( "game_over", "mus_zombie_game_over", 5 );
}
function sndMusicSystem_CreateState( state, alias, playtype = 1, delay = 0 )
{
	if( !isdefined( level.musicSystem ) )
	{
		level.musicSystem = spawnstruct();
		level.musicSystem.ent = spawn( "script_origin", (0,0,0) );
		level.musicSystem.queue = false;
		level.musicSystem.currentPlaytype = 0;
		level.musicSystem.currentState = undefined;
		level.musicSystem.states = [];
	}
	
	s = level.musicSystem;
	if( !isdefined( s.states[state] ) )
	{
		s.states[state] = spawnstruct();
		s.states[state].alias = alias;
		s.states[state].delay = delay;
		s.states[state].playtype = playtype;
	}
}
function sndMusicSystem_PlayState( state )
{
	if( !isdefined( level.musicSystem ) )
		return;
	
	s = level.musicSystem;
	
	if( !isdefined( s.states[state] ) )
		return;
	
	playtype = s.states[state].playtype;
	
	if( s.currentPlaytype > 0 )
	{
		if( playtype == 1 )
		{
			break;
		}
		else if( playtype == 2 )
		{
			level thread sndMusicSystem_QueueState(state);
		}
		else if( playtype > s.currentPlaytype || (playtype == 3 && s.currentPlaytype == 3 ) )
		{
			level sndMusicSystem_StopAndFlush();
			level thread playState( state );
		}
	}
	else
	{
		level thread playState( state );
	}
}
function playState( state )
{
	level endon( "sndStateStop" );
	
	s = level.musicSystem;

	s.currentPlaytype = s.states[state].playtype;
	s.currentState = state;
	
	wait( s.states[state].delay + .1 );
	
	s.ent PlaySound( s.states[state].alias );
	
	playbacktime = soundgetplaybacktime( s.states[state].alias );
	if( !isdefined( playbacktime ) || playbacktime <= 0 )
		waittime = 1;
	else
		waittime = playbackTime * .001;
	
	wait(waittime);
	
	s.ent stopsounds();
	s.currentPlaytype = 0;
	s.currentState = undefined;
}
function sndMusicSystem_QueueState( state )
{
	level endon( "sndQueueFlush" );
	
	s = level.musicSystem;
	count = 0;
	
	if( ( isdefined( s.queue ) && s.queue ) )
	{
		return;
	}
	else
	{
		s.queue = true;
		
		while(s.currentPlaytype > 0)
		{
			wait(.5);
			count++;
			if( count >= 120 )
			{
				s.queue = false;
				return;
			}
		}
		
		level thread playState( state );
		
		s.queue = false;
	}
}
function sndMusicSystem_StopAndFlush()
{
	level notify( "sndQueueFlush" );
	level.musicSystem.queue = false;
	
	level notify( "sndStateStop" );
	level.musicSystem.ent stopsounds();
	level.musicSystem.currentPlaytype = 0;
	level.musicSystem.currentState = undefined;
}


function sndMusicSystem_LocationsInit(locationArray)
{
	if( !isdefined( locationArray ) || locationArray.size <= 0 )
		return;
	
	level.musicSystem.locationArray = locationArray;
	level thread sndMusicSystem_Locations(locationArray);
}
function sndMusicSystem_Locations(locationArray)
{	
	numCut = 0;
	level.sndLastZone = undefined;
	
	s = level.musicSystem;
	
	while(1)
	{
		level waittill( "newzoneActive", activeZone );
		
		wait(.1);
		
		if( !sndLocationShouldPlay( locationArray, activeZone ) )
		{
			continue;
		}
	   
		level thread sndMusicSystem_PlayState( activeZone );
		
		locationArray = sndCurrentLocationArray( locationArray, activeZone, numCut, 3 );
		level.sndLastZone = activeZone;
		
		if( numCut >= 3 )
			numCut = 0;
		else
			numCut++;
		
		level waittill( "between_round_over" );
	}
}
function sndLocationShouldPlay(array,activeZone)
{
	shouldPlay = false;
	
	if( level.musicSystem.currentPlaytype >= 3 )
	{
		level thread sndLocationQueue( activeZone );
		return shouldPlay;
	}

	foreach( place in array )
	{
		if( place == activeZone )
			shouldPlay = true;
	}
	
	if( shouldPlay == false )
		return shouldPlay;
	
	if( zm_zonemgr::any_player_in_zone( activeZone ) )
		shouldPlay = true;	
	else
		shouldPlay = false;
	
	return shouldPlay;
}
function sndCurrentLocationArray( current_array, activeZone, numCut, num )
{
	if( numCut >= num )
	{
		current_array = level.musicSystem.locationArray;
	}
	
	foreach( place in current_array )
	{
		if( place == activeZone )
		{
			arrayremovevalue( current_array, place );
			break;
		}
	}	
	return current_array;
}
function sndLocationQueue( zone )
{
	level endon( "newzoneActive" );
	
	while( level.musicSystem.currentPlaytype >= 3 )
		wait.5;
	
	level notify( "newzoneActive", zone );
}

function sndMusicSystem_EESetup(state, origin1, origin2, origin3, origin4, origin5)
{
	sndEEarray = array();
	
	if( isdefined( origin1 ) )
		if ( !isdefined( sndEEarray ) ) sndEEarray = []; else if ( !IsArray( sndEEarray ) ) sndEEarray = array( sndEEarray ); sndEEarray[sndEEarray.size]=origin1;;
	if( isdefined( origin2 ) )
		if ( !isdefined( sndEEarray ) ) sndEEarray = []; else if ( !IsArray( sndEEarray ) ) sndEEarray = array( sndEEarray ); sndEEarray[sndEEarray.size]=origin2;;
	if( isdefined( origin3 ) )
		if ( !isdefined( sndEEarray ) ) sndEEarray = []; else if ( !IsArray( sndEEarray ) ) sndEEarray = array( sndEEarray ); sndEEarray[sndEEarray.size]=origin3;;
	if( isdefined( origin4 ) )
		if ( !isdefined( sndEEarray ) ) sndEEarray = []; else if ( !IsArray( sndEEarray ) ) sndEEarray = array( sndEEarray ); sndEEarray[sndEEarray.size]=origin4;;
	if( isdefined( origin5 ) )
		if ( !isdefined( sndEEarray ) ) sndEEarray = []; else if ( !IsArray( sndEEarray ) ) sndEEarray = array( sndEEarray ); sndEEarray[sndEEarray.size]=origin5;;
	
	if( sndEEarray.size > 0 )
	{
		level.sndEEMax = sndEEarray.size;
		level.sndEECount = 0;
		foreach( origin in sndEEarray )
		{
			level thread sndMusicSystem_EEWait(origin, state);
		}
	}
}
function sndMusicSystem_EEWait( origin, state )
{
  	temp_ent = Spawn( "script_origin", origin );
	temp_ent PlayLoopSound( "zmb_meteor_loop" );
		
	temp_ent thread secretUse( "main_music_egg_hit", (0,255,0), &sndMusicSystem_EEOverride );
	temp_ent waittill( "main_music_egg_hit", player);
	
	temp_ent StopLoopSound( 1 );
	player PlaySound( "zmb_meteor_activate" );
		
	level.sndEECount++;
	
	if( level.sndEECount >= level.sndEEMax )
	{ 
		level thread sndMusicSystem_PlayState( state );
	}
	
	temp_ent Delete();
}
function sndMusicSystem_EEOverride(arg1,arg2)
{
	if( isdefined( level.musicSystem.currentPlaytype ) && level.musicSystem.currentPlaytype >= 4 )
	{
		return false;
	}
	return true;
}
function secretUse(notify_string, color, qualifier_func, arg1, arg2 )
{
	waittillframeend;	// In case the calling thread is threading this, then waiting for the notify, and the player has 
						// use pressed down already, this makes sure that the calling thread doesn't get notified, before it's
						// good and ready.
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		
		/#
//		Print3d(self.origin, "+", color, 1);
		#/
			
		players = level.players;
		foreach(player in players)
		{
			qualifier_passed = true;

			if(isdefined(qualifier_func))
			{
				qualifier_passed = player [[qualifier_func]](arg1,arg2);
			}

			if(qualifier_passed && (DistanceSquared(self.origin, player.origin) < 64*64))
			{
				if(player laststand::is_facing(self))
				{
					if(player UseButtonPressed())
					{
						self notify(notify_string, player);
						return;
					}
				}			
			}
		}
		wait(0.1);
	}
}

/*
 * 
 * 		ANNOUNCER VOX: Don't need an overly complicated system, just a few simple functions
 * 		Will simply play announcer vox in 2d.  Prefix can be changed in level gsc if we need a new announcer
 * 		
 * 
 */ 
 
 
function sndAnnouncer_Init()
{
	if( !isdefined( level.zmAnnouncerPrefix ) )
		level.zmAnnouncerPrefix = "vox_"+"zmba"+"_";

	sndAnnouncerVoxAdd( "carpenter", "powerup_carpenter" );
	sndAnnouncerVoxAdd( "insta_kill", "powerup_instakill" );
	sndAnnouncerVoxAdd( "double_points", "powerup_doublepoints" );
	sndAnnouncerVoxAdd( "nuke", "powerup_nuke" );
	sndAnnouncerVoxAdd( "full_ammo", "powerup_maxammo" );
	sndAnnouncerVoxAdd( "fire_sale", "powerup_firesale" );
	sndAnnouncerVoxAdd( "minigun", "powerup_death_machine" );
	sndAnnouncerVoxAdd( "boxmove", "event_magicbox" );
	sndAnnouncerVoxAdd( "dogstart", "event_dogstart" );
}
function sndAnnouncerVoxAdd( type, suffix )
{
	if( !isdefined( level.zmAnnouncerVox ) )
	{
		level.zmAnnouncerVox = array();
	}
	
	level.zmAnnouncerVox[type] = suffix;
}
function sndAnnouncerPlayVox(type, player)
{
	if( !isdefined( level.zmAnnouncerVox[type] ) )
		return;
	
	prefix = level.zmAnnouncerPrefix;
	suffix = level.zmAnnouncerVox[type];
	
	if( !( isdefined( level.zmAnnouncerTalking ) && level.zmAnnouncerTalking ) )
	{
		if( !isdefined( player ) )
		{
			level.zmAnnouncerTalking = true;
			
			temp_ent = spawn("script_origin", (0,0,0));
			temp_ent PlaySoundWithNotify(prefix+suffix, prefix+suffix+"wait");
			temp_ent waittill(prefix+suffix+"wait");
			{wait(.05);};
			temp_ent delete();
			
			level.zmAnnouncerTalking = false;
		}
		else
		{
			player playsoundtoplayer( prefix+suffix, player );
		}
	}
}

/*
 * 
 * 		ZOMBIE VOX: Moving to the notify system, most vox is still script based, but death and attack are from AI Editor
 * 
 */ 

function zmbAIVox_NotifyConvert()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self thread zmbAIVox_PlayDeath();

	while (1)
{
		self waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{					
			case "death":
			case "behind":
			case "attack_melee":
			case "electrocute":
			case "close":
				level thread zmbAIVox_PlayVox( self, notify_string, true );
				break;
			case "teardown":
			case "taunt":
			case "ambient":
			case "sprint":
			case "crawler":
				level thread zmbAIVox_PlayVox( self, notify_string, false );
				break;
			default:
			{
				if ( IsDefined( level._zmbAIVox_SpecialType ) )
				{
					if( isdefined( level._zmbAIVox_SpecialType[notify_string] ) )
					{
						level thread zmbAIVox_PlayVox( self, notify_string, false );
					}
				}
				break;
			}
		}
	}
}
function zmbAIVox_PlayVox( zombie, type, override )
{
    zombie endon( "death" ); 
    
    if( !isdefined( zombie ) )
    	return;
    
    if( !isdefined( zombie.voicePrefix ) )
    	return; 
    
    alias = "zmb_vocals_" + zombie.voicePrefix + "_" + type;
    
    if( sndIsNetworkSafe() )
    {
	    if( ( isdefined( override ) && override ) )
	    {
	   		zombie PlaySound( alias );
	    }
	    else if( !( isdefined( zombie.talking ) && zombie.talking ) )
	    {
	        zombie.talking = true;
	        
	        if( zombie is_last_zombie() )
	        	alias = alias + "_loud";
	        
	        zombie PlaySoundOnTag( alias, "j_head" );
	        playbackTime = soundgetplaybacktime( alias );
		
			if( !isdefined( playbackTime ) )
				playbackTime = 1;
			
			if ( playbackTime >= 0 )
				playbackTime = playbackTime * .001;
			else
				playbackTime = 1;
			
			wait(playbacktime);
	        zombie.talking = false;
	    }
    }
}
function zmbAIVox_PlayDeath()
{
	self endon ( "disconnect" );
	
	self waittill ( "death", attacker, meansOfDeath );
	
	if ( isdefined( self ) )
	{	
		level thread zmbAIVox_PlayVox( self, "death", true );
	}
}

function networkSafeReset()
{
	while(1)
	{
		level._numZmbAIVox = 0;
		util::wait_network_frame();
	}
}
function sndIsNetworkSafe()
{
	if ( !IsDefined( level._numZmbAIVox ) )
	{
	 	level thread networkSafeReset();
	}

	if ( level._numZmbAIVox > 4 )
	{
	  	return false;
	}

	level._numZmbAIVox++;
	return true;
}

function is_last_zombie()
{
	if( zombie_utility::get_current_zombie_count() <= 1 )
		return true;
	
	return false;
}

/*		
 * 		Radio Easter Eggs (Or any sort of story asset)
 * 
 */ 
 
function sndRadioSetup(alias_prefix, is_sequential = false, origin1, origin2, origin3, origin4, origin5)
{
	radio = spawnstruct();
	radio.counter = 1;
	radio.alias_prefix = alias_prefix;
	radio.isPlaying = false;
	radio.array = array();
	
	if( isdefined( origin1 ) )
		if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin1;;
	if( isdefined( origin2 ) )
		if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin2;;
	if( isdefined( origin3 ) )
		if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin3;;
	if( isdefined( origin4 ) )
		if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin4;;
	if( isdefined( origin5 ) )
		if ( !isdefined( radio.array ) ) radio.array = []; else if ( !IsArray( radio.array ) ) radio.array = array( radio.array ); radio.array[radio.array.size]=origin5;;
	
	if( radio.array.size > 0 )
	{
		for(i=0;i<radio.array.size;i++)
		{
			level thread sndRadioWait(radio.array[i], radio, is_sequential, i+1);
		}
	}
}
function sndRadioWait(origin, radio, is_sequential, num)
{	
	temp_ent = Spawn( "script_origin", origin );
	temp_ent thread secretUse( "sndRadioHit", (0,0,255), &sndRadio_Override, radio );
	temp_ent waittill( "sndRadioHit", player);
	
	if( !( isdefined( is_sequential ) && is_sequential ) )
	{
		radioNum = num;
	}
	else
	{
		radioNum = radio.counter;
	}
	
	radioAlias = radio.alias_prefix + radioNum;	
	radioLineCount = zm_spawner::get_number_variants( radioAlias );
	
	if( radioLineCount > 0 )
	{
		radio.isPlaying = true;
	
		for(i=0;i<radioLineCount;i++)
		{
			temp_ent playsound( radioAlias + "_" + i );
			playbackTime = soundgetplaybacktime( radioAlias + "_" + i );
			
			if( !isdefined( playbackTime ) )
				playbackTime = 1;
			
			if ( playbackTime >= 0 )
				playbackTime = playbackTime * .001;
			else
				playbackTime = 1;
			
			wait(playbacktime);
		}
	}
	
	radio.counter++;
	radio.isPlaying = false;
	
	temp_ent Delete();
}
function sndRadio_Override(arg1,arg2)
{
	if( isdefined( arg1 ) && arg1.isPlaying == true )
	{
		return false;
	}
	return true;
}


//Perksacola Jingle Stuff
function sndPerksJingles_Timer()
{
	self endon( "death" );
	
	if( isdefined( self.sndJingleCooldown ) )
	{
		self.sndJingleCooldown = false;
	}
	
	while(1)
	{
		wait(randomfloatrange(22,45));
		
		if( (randomintrange(0,100) <= 15) && !( isdefined( self.sndJingleCooldown ) && self.sndJingleCooldown ) )
		{
			self thread sndPerksJingles_Player(0);
		}
	}
}
function sndPerksJingles_Player(type)
{
	if( !isdefined( self.sndJingleActive ) )
	{
		self.sndJingleActive = false;
	}
	
	alias = self.script_sound;
	if( type == 1 )
		alias = self.script_label;
	
	if( !( isdefined( self.sndJingleActive ) && self.sndJingleActive ) && level.musicSystem.currentPlaytype < 4 )
	{
		self.sndJingleActive = true;
		self playsoundwithnotify( alias, "sndDone" );
		
		playbacktime = soundgetplaybacktime( alias );
		if( !isdefined( playbacktime ) || playbacktime <= 0 )
			waittime = 1;
		else
			waittime = playbackTime * .001;
	
		wait(waittime);
		
		if( type == 0 )
		{
			self.sndJingleCooldown = true;
			self thread sndPerksJingles_Cooldown();
		}
		
		self.sndJingleActive = false;
	}
}
function sndPerksJingles_Cooldown()
{
	self endon( "death" );
	wait(45);
	self.sndJingleCooldown = false;
}

/*
 * 
 * 		CONVERSATIONS
 * 		These will shut off normal player lines for the duration of the conversation
 * 		Conversations can have Required Players.  If a certain player character isn't in the game, the conversation won't occur
 * 		If a Player has a line in a conversation, is NOT a required player, and is NOT currently in game, the line will just be skipped
 * 
 * 
 */


function sndConversation_Init( name, specialEndon = undefined )
{
	if( !isdefined( level.sndConversations ) )
	{
		level.sndConversations = array();
	}
	
	level.sndConversations[name] = spawnstruct();
	level.sndConversations[name].specialEndon = specialEndon;
}
function sndConversation_AddLine( name, line, player_or_random, ignorePlayer = 5 )
{
	thisConvo = level.sndConversations[name];
	
	if( !isdefined( thisConvo.line ) )
	{
		thisConvo.line = array();
	}
	
	if( !isdefined( thisConvo.player ) )
	{
		thisConvo.player = array();
	}
	
	if( !isdefined( thisConvo.ignorePlayer ) )
	{
		thisConvo.ignorePlayer = array();
	}
	
	if ( !isdefined( thisConvo.line ) ) thisConvo.line = []; else if ( !IsArray( thisConvo.line ) ) thisConvo.line = array( thisConvo.line ); thisConvo.line[thisConvo.line.size]=line;;
	if ( !isdefined( thisConvo.player ) ) thisConvo.player = []; else if ( !IsArray( thisConvo.player ) ) thisConvo.player = array( thisConvo.player ); thisConvo.player[thisConvo.player.size]=player_or_random;;
	if ( !isdefined( thisConvo.ignorePlayer ) ) thisConvo.ignorePlayer = []; else if ( !IsArray( thisConvo.ignorePlayer ) ) thisConvo.ignorePlayer = array( thisConvo.ignorePlayer ); thisConvo.ignorePlayer[thisConvo.ignorePlayer.size]=ignorePlayer;;
}
function sndConversation_Play( name )
{	
	thisConvo = level.sndConversations[name];
	
	level endon( "sndConvoInterrupt" );
	if( isdefined( thisConvo.specialEndon ) )
	{
		level endon( thisConvo.specialEndon );
	}
	
	while( isAnyoneTalking() )
		wait(.5);
	
	while( ( isdefined( level.sndVoxOverride ) && level.sndVoxOverride ) )
		wait(.5);
	
	level.sndVoxOverride = true;
	for(i=0;i<thisConvo.line.size;i++)
	{
		if( thisConvo.player[i] == 4 )
			speaker = getRandomCharacter(thisConvo.ignorePlayer[i]);
		else
			speaker = getSpecificCharacter(thisConvo.player[i]);
			
		if( !isdefined( speaker ) )
			continue;
			
		if( isCurrentSpeakerAbleToTalk(speaker) )
		{
			speaker thread sndConvoInterrupt();
			speaker PlaySoundOnTag( "vox_plr_"+speaker.characterIndex+"_"+thisConvo.line[i], "J_Head" );
			//speaker PlaySound( "vox_plr_"+speaker.characterIndex+"_"+thisConvo.line[i] );
			waitPlaybackTime( "vox_plr_"+speaker.characterIndex+"_"+thisConvo.line[i] );
			level notify( "sndConvoLineDone" );
		}
	}
	level.sndVoxOverride = false;
	level notify( "sndConversationDone" );
}
function waitPlaybackTime(alias)
{
	playbackTime = soundgetplaybacktime( alias );
			
	if( !isdefined( playbackTime ) )
		playbackTime = 1;
			
	if ( playbackTime >= 0 )
		playbackTime = playbackTime * .001;
	else
		playbackTime = 1;
			
	wait(playbacktime);
}
function isCurrentSpeakerAbleToTalk(player)
{
	if( !isdefined( player ) )
		return false;
	
	if ( player.sessionstate != "playing" )
		return false;
		
	if( ( isdefined( player.laststand ) && player.laststand ) )
		return false;
	
	return true;
}
function getRandomCharacter(ignore)
{
	array = level.players;
	array::randomize( array );
	
	foreach( guy in array )
	{
		if( guy.characterIndex == ignore )
			continue;
		
		return guy;
	}
	return undefined;
}
function getSpecificCharacter(charIndex)
{
	foreach( guy in level.players )
	{
		if( guy.characterIndex == charIndex )
			return guy;
	}
	return undefined;
}
function isAnyoneTalking()
{
	foreach( player in level.players )
	{
		if( ( isdefined( player.isSpeaking ) && player.isSpeaking ) )
		{
			return true;
		}
	}
	
	return false;
}
function sndConvoInterrupt()
{
	level endon("sndConvoLineDone");
	
	while(1)
	{	
		if( !isdefined( self ) )
			return;
		
		max_dist_squared = 0;
		check_pos = self.origin;
		count = 0;
		
		foreach(player in level.players)
		{
			if( self == player )
				continue;
			
			if( distance2dsquared(player.origin, self.origin) >= 450*450 )
				count++;
		}
		
		if( count == (level.players.size-1))
			break;
		
		wait(0.25);
	}
	
	level notify("sndConvoInterrupt");
	level notify("sndConversationDone");
	level.sndVoxOverride = false;
}