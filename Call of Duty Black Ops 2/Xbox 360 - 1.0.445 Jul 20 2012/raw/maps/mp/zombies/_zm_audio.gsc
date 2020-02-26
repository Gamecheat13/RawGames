// #include maps\_utility; 
// #include common_scripts\utility;
// #include maps\_zombiemode_utility; 
// #include maps\_music; 
// #include maps\_busing;

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_weapons; 

init()
{
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_audio.gsc)" );	#/
	level zmbVox();
	level init_music_states();
	level maps\mp\zombies\_zm_audio_announcer::init();
	OnPlayerConnect_Callback(::init_audio_functions);
}

//All Vox should be found in this section.
//If there is an Alias that needs to be changed, check here first.
zmbVox()
{
	level.vox = zmbVoxCreate();
	
	//ANNOUNCER COMMON VOX
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"carpenter", 				"powerup_carpenter" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"insta_kill", 				"powerup_instakill" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"double_points", 			"powerup_doublepoints" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"nuke", 					"powerup_nuke" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"full_ammo", 				"powerup_maxammo" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"fire_sale", 				"powerup_firesale" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"fire_sale_short", 			"firesale_short" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"minigun", 					"powerup_death_machine" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"bonfire_sale", 			"bonfiresale" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"tesla", 					"tesla" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"random_weapon", 			"random_weapon" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"bonus_points_player", 		"points_positive" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"bonus_points_team", 		"points_positive" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"lose_points_team", 		"points_negative" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"lose_perk", 				"powerup_negative" );
	level.vox zmbVoxAdd( "announcer", 	"powerup", 		"empty_clip", 				"powerup_negative" );

	//PLAYER COMMON VOX
	level.vox zmbVoxAdd( "player", 		"general", 		"crawl_spawn", 				"spawn_crawl",			"resp_spawn_crawl");
	level.vox zmbVoxAdd( "player", 		"general", 		"ammo_low", 				"ammo_low",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"ammo_out", 				"ammo_out",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"door_deny", 				"nomoney",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"perk_deny", 				"nomoney",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"intro", 					"map_intro",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"shoot_arm", 				"shoot_limb",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"box_move", 				"box_move",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"no_money", 				"nomoney",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"oh_shit", 					"ohshit",				"resp_ohshit");
	level.vox zmbVoxAdd( "player", 		"general", 		"revive_down", 				"revive_down",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"revive_up", 				"revive_up",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"crawl_hit", 				"crawler_hit",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"sigh", 					"sigh",					undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"hitmed", 					"gen_hitmed",			undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"round_5", 					"round_5",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"round_20", 				"round_20",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"round_10", 				"round_10",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"round_35", 				"round_35",				undefined);
	level.vox zmbVoxAdd( "player", 		"general", 		"round_50", 				"round_50",				undefined);
	
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_armorvest", 		"perk_jugga",			undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_quickrevive",	"perk_revive",			undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_fastreload", 	"perk_speed",			undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_rof", 			"perk_doubletap",		undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_longersprint",	"perk_stamin",			undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_flakjacket", 	"perk_phdflopper",		undefined);
	level.vox zmbVoxAdd( "player", 		"perk", 		"specialty_deadshot", 		"perk_deadshot",		undefined);
	
	level.vox zmbVoxAdd( "player", 		"powerup", 		"nuke", 					"powerup_nuke",			undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"insta_kill", 				"powerup_insta",		undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"full_ammo", 				"powerup_ammo",			undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"double_points", 			"powerup_double",		undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"carpenter", 				"powerup_carp",			undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"firesale", 				"powerup_firesale",		undefined);
	level.vox zmbVoxAdd( "player", 		"powerup", 		"minigun", 					"powerup_minigun",		undefined);
		
	level.vox zmbVoxAdd( "player", 		"kill", 		"melee", 					"kill_melee",			undefined);	
	level.vox zmbVoxAdd( "player", 		"kill", 		"melee_instakill", 			"kill_insta",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"weapon_instakill", 		"kill_insta",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"closekill", 				"kill_close",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"damage", 					"kill_damaged",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"streak", 					"kill_streak",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"headshot", 				"kill_headshot",		"resp_kill_headshot");
	level.vox zmbVoxAdd( "player", 		"kill", 		"explosive", 				"kill_explo",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"flame", 					"kill_flame",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"raygun", 					"kill_ray",				undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"bullet", 					"kill_streak",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"tesla", 					"kill_tesla",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"monkey", 					"kill_monkey",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"thundergun", 				"kill_thunder",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"freeze", 					"kill_freeze",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"crawler", 					"kill_crawler",			undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"hellhound", 				"kill_hellhound",		undefined);
	level.vox zmbVoxAdd( "player", 		"kill", 		"quad", 					"kill_quad",			undefined);
	
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"pistol", 				"wpck_crappy",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"smg", 					"wpck_smg",				undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"dualwield", 			"wpck_dual",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"shotgun", 				"wpck_shotgun",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"rifle", 				"wpck_sniper",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"burstrifle", 			"wpck_mg",				undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"assault", 				"wpck_mg",				undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"sniper", 				"wpck_sniper",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"mg", 					"wpck_mg",				undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"launcher", 			"wpck_launcher",		undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"grenade", 				"wpck_grenade",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"bowie", 				"wpck_bowie",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"raygun", 				"wpck_raygun",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"monkey", 				"wpck_monkey",			"resp_wpck_monkey");
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"crossbow", 			"wpck_launcher",		undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"upgrade", 				"wpck_upgrade",			undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"favorite", 			"wpck_favorite",		undefined);
	level.vox zmbVoxAdd( "player", 		"weapon_pickup",	"favorite_upgrade", 	"wpck_favorite_upgrade",undefined);  
	    
	//**ZOMBIE VOCALIZATIONS**\\    
	    //ARRAY and PREFIX: Setting up a prefix and array for all Zombie vocalizations  
	    level.zmb_vox                               =   [];
	    level.zmb_vox["prefix"]                     =   "zmb_vocals_";
	    
	    //Standard Zombies
	    level.zmb_vox["zombie"]                     =   [];
	    level.zmb_vox["zombie"]["ambient"]          =   "zombie_ambience";
	    level.zmb_vox["zombie"]["sprint"]           =   "zombie_sprint";
	    level.zmb_vox["zombie"]["attack"]           =   "zombie_attack";
	    level.zmb_vox["zombie"]["teardown"]         =   "zombie_teardown";
	    level.zmb_vox["zombie"]["taunt"]            =   "zombie_taunt";
	    level.zmb_vox["zombie"]["behind"]           =   "zombie_behind";
	    level.zmb_vox["zombie"]["death"]            =   "zombie_death";
	    level.zmb_vox["zombie"]["crawler"]          =   "zombie_crawler";
	    
	    //Quad Zombies
		level.zmb_vox["quad_zombie"]                =   [];
	    level.zmb_vox["quad_zombie"]["ambient"]     =   "quad_ambience";
	    level.zmb_vox["quad_zombie"]["sprint"]      =   "quad_sprint";
	    level.zmb_vox["quad_zombie"]["attack"]      =   "quad_attack";
	    level.zmb_vox["quad_zombie"]["behind"]      =   "quad_behind";
	    level.zmb_vox["quad_zombie"]["death"]       =   "quad_death";
	    
	    //Thief Zombies
		level.zmb_vox["thief_zombie"]                =   [];
	    level.zmb_vox["thief_zombie"]["ambient"]     =   "thief_ambience";
	    level.zmb_vox["thief_zombie"]["sprint"]      =   "thief_sprint";
	    level.zmb_vox["thief_zombie"]["steal"]       =   "thief_steal";
	    level.zmb_vox["thief_zombie"]["death"]       =   "thief_death";
	    level.zmb_vox["thief_zombie"]["anger"]       =   "thief_anger";
	
	    //Boss Zombies
		level.zmb_vox["boss_zombie"]                =   [];
	    level.zmb_vox["boss_zombie"]["ambient"]     =   "boss_ambience";
	    level.zmb_vox["boss_zombie"]["sprint"]      =   "boss_sprint";
	    level.zmb_vox["boss_zombie"]["attack"]      =   "boss_attack";
	    level.zmb_vox["boss_zombie"]["behind"]      =   "boss_behind";
	    level.zmb_vox["boss_zombie"]["death"]       =   "boss_death";
	    
	    //Monkey Zombies
	    level.zmb_vox["monkey_zombie"]              =   [];
	    level.zmb_vox["monkey_zombie"]["ambient"]   =   "monkey_ambience";
	    level.zmb_vox["monkey_zombie"]["sprint"]    =   "monkey_sprint";
	    level.zmb_vox["monkey_zombie"]["attack"]    =   "monkey_attack";
	    level.zmb_vox["monkey_zombie"]["behind"]    =   "monkey_behind";
	    level.zmb_vox["monkey_zombie"]["death"]     =   "monkey_death";

	//Init Level Specific Vox
	if( isdefined( level._zmbVoxLevelSpecific ) )
		level thread [[level._zmbVoxLevelSpecific]]();
	
	//Init Gametype Specific Vox
	if( isdefined( level._zmbVoxGametypeSpecific ) )
		level thread [[level._zmbVoxGametypeSpecific]]();
	
	announcer_ent = spawn( "script_origin", (0,0,0) );
	level.vox zmbVoxInitSpeaker( "announcer", "vox_zmba_", announcer_ent );
}

init_audio_functions()
{
	self thread zombie_behind_vox();
	self thread player_killstreak_timer();
	self thread oh_shit_vox();
}

//Plays a specific Zombie vocal when they are close behind the player
//Self is the Player(s)
zombie_behind_vox()
{
	self endon("death_or_disconnect");
	
	if(!IsDefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;	
		level._audio_zbv_shared_ent_list = GetAISpeciesArray("axis");
	}
	
	while(1)
	{
		wait(1);		
		
		t = GetTime();
		
		if(t > level._zbv_vox_last_update_time + 1000)
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = GetAISpeciesArray("axis");
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
				yaw = self maps\mp\zombies\_zm_utility::GetYawToSpot(zombs[i].origin );
				z_diff = self.origin[2] - zombs[i].origin[2];
				if( (yaw < -95 || yaw > 95) && abs( z_diff ) < 50 )
				{
					zombs[i] thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "behind", zombs[i].animname );
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

attack_vox_network_choke()
{
	while(1)
	{
		level._num_attack_vox = 0;
		wait_network_frame();
	}
}

do_zombies_playvocals( alias_type, zombie_type )
{
    self endon( "death" );
    
    if( !IsDefined( zombie_type ) )
    {
        zombie_type = "zombie";
    }
	
	//Prevent shrinked zombies from playing vocals OTHER than shrinked ambients
	if( is_true( self.shrinked ) )
	{
		return;
	}
    
    if( !IsDefined( self.talking ) )
    {
        self.talking = false;
    }
    
    //DEBUG SECTION
    if( !IsDefined( level.zmb_vox[zombie_type] ) )
    {
        /#
        PrintLn( "ZM >> AUDIO - ZOMBIE TYPE: " + zombie_type + " has NO aliases set up for it." );
        #/
        return;
    }
    
    if( !IsDefined( level.zmb_vox[zombie_type][alias_type] ) )
    {
        /#
        PrintLn( "ZM >> AUDIO - ZOMBIE TYPE: " + zombie_type + " has NO aliases set up for ALIAS_TYPE: " + alias_type );
        #/
        return;
    }
    
    if(alias_type == "attack")
    {
    	if(!IsDefined(level._num_attack_vox))
    	{
    		level thread attack_vox_network_choke();
    	}
    	
    	if(level._num_attack_vox > 4)
    	{
    		return;
    	}
    	
    	level._num_attack_vox ++;
  	}
    
    alias = level.zmb_vox["prefix"] + level.zmb_vox[zombie_type][alias_type];
    
    if( alias_type == "attack" || alias_type == "behind" || alias_type == "death" || alias_type == "anger" || alias_type == "steal" )
    {
        self PlaySound( alias );
    }
    else if( !self.talking )
    {
        self.talking = true;
        self PlaySoundWithNotify( alias, "sounddone" );
        self waittill( "sounddone" );
        self.talking = false;
    }
}   

oh_shit_vox()
{
	self endon("death_or_disconnect");
	
	while(1)
	{
		wait(1);
		
		players = GET_PLAYERS();
		zombs = GetAISpeciesArray("axis");
	
		if( players.size > 1 )
		{
			close_zombs = 0;
			for( i=0; i<zombs.size; i++ )
			{
				if( DistanceSquared( zombs[i].origin, self.origin ) < 250 * 250)
				{
					close_zombs ++;
				}
			}
			if( close_zombs > 4 )
			{
				if( randomintrange( 0, 20 ) < 5 )
				{
					self create_and_play_dialog( "general", "oh_shit" );
					wait(4);	
				}
			}
		}
	}
}

//**Player & NPC Dialog - The following functions all serve to play Player and NPC dialog
//**To use create_and_play_dialog, _zm_audio must be included in the GSC you're using the function in, or you must
//**call the function like so: player maps\mp\zombies\_zm_audio::create_and_play_dialog()

create_and_play_dialog( category, type, response, force_variant, override )
{              
	waittime = .25;
		
	if( !isdefined( self.zmbVoxID ) )
	{
		/#
		if( GetDvarInt( "debug_audio" ) > 0 )
			iprintln( "DIALOG DEBUGGER: No zmbVoxID setup on this character. Run zmbVoxInitSpeaker on this character in order to play vox" );
		#/
		return;
	}
	
	/#
	if( GetDvarInt( "debug_audio" ) > 0 )
	    self thread dialog_debugger( category, type );
	#/
	
	alias_suffix = undefined;
	index = undefined;
	prefix = undefined;
	
	if( !IsDefined( level.vox.speaker[self.zmbVoxID].alias[category][type] ) )
	{
		return;
	}
	
	prefix =  level.vox.speaker[self.zmbVoxID].prefix;
	alias_suffix =  level.vox.speaker[self.zmbVoxID].alias[category][type];
		
	if( self is_player() )
	{
		if( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && ( type != "revive_down" || type != "revive_up" ) )
		{
			return;
		}
		
		index = maps\mp\zombies\_zm_weapons::get_player_index(self);
		prefix = prefix + index + "_";
		
	}
	
	if( IsDefined( response ) )
	    alias_suffix = response + alias_suffix;
	
    sound_to_play = self zmbVoxGetLineVariant( prefix, alias_suffix, force_variant, override );
    
    if( isdefined( sound_to_play ) )
    {
		if( isdefined( level._audio_custom_player_playvox ) )
		{
			self thread [[level._audio_custom_player_playvox]]( prefix, index, sound_to_play, waittime, category, type, override );
		}
		else
		{
			self thread do_player_or_npc_playvox( prefix, index, sound_to_play, waittime, category, type, override );
		}
    }
    else
    {
    	/#
		if( GetDvarInt( "debug_audio" ) > 0 )
			iprintln( "DIALOG DEBUGGER: SOUND_TO_PLAY is undefined" );
		#/
    }
}

do_player_or_npc_playvox( prefix, index, sound_to_play, waittime, category, type, override )
{
	if ( is_true( level.skit_vox_override ) && ( IsDefined( override ) && !override ) )
	{
		return;
	}
	
	// Init self.isSpeaking
	if ( !IsDefined( self.isSpeaking ) )
	{
		self.isSpeaking = false;
	}
	
	// If We're Alraedy Speaking, Back Out
	//------------------------------------
	if ( is_true( self.isSpeaking ) )
	{
		/#
		PrintLn( "DIALOG DEBUGGER: Can't play (" + ( prefix + sound_to_play ) + ") because we are speaking already." );
		#/
		
		return;
	}

	// If No One Nearby Speaking, We Can Talk
	//---------------------------------------
	if ( !self areNearbySpeakersActive() )
	{
		self.isSpeaking = true;

		self PlaySoundWithNotify( prefix + sound_to_play, "sound_done" + sound_to_play );
		self waittill( "sound_done" + sound_to_play );
		wait( waittime );
		
		/* AYERS: Cutting off responses for now, since so few exist and response functions need to be rewritten
		// Player Response Exists
		//-----------------------
		if ( IsDefined( level.vox.speaker[self.zmbVoxID].response ) &&
					IsDefined( level.vox.speaker[self.zmbVoxID].response[category][type] ) )
		{
			// If Self Is NPC (COOP or SOLO) Or Self Is Player (COOP), A Player Can Respond
			//-----------------------------------------------------------------------------
			if ( is_true( self.isNPC ) || !flag( "solo_game" ) )
			{
				if ( IsDefined( level._audio_custom_response_line ) )
				{
					level thread [[ level._audio_custom_response_line ]]( self, index, category, type );
				}
				else
				{
					level thread setup_response_line( self, index, category, type );
				}
			}
		}
		// NPC Response Exists
		//--------------------
		else if ( IsDefined( level.npc_vox[ category ] ) && 
							IsDefined( level.npc_vox[ category ][ type + "_response" ] ) )
		{
			// TODO NPC VERSION: level thread setup_response_line( self, index, category, type );
		}
		*/

		self.isSpeaking = false;
	}
	else
	{
		/#
		PrintLn( "DIALOG DEBUGGER: Can't play (" + ( prefix + sound_to_play ) + ") because someone is nearby speaking already." );
		#/
	}
}
/*
setup_response_line( player, index, category, type )
{
	Dempsey = 0;
	Nikolai = 1;
	Takeo = 2;
	Richtofen = 3;
	
	switch( player.entity_num )
	{
		case 0:
			level setup_hero_rival( player, Nikolai, Richtofen, category, type );
		break;
		
		case 1:
			level setup_hero_rival( player, Richtofen, Takeo, category, type );
		break;
		
		case 2:
			level setup_hero_rival( player, Dempsey, Nikolai, category, type );
		break;
		
		case 3:
			level setup_hero_rival( player, Takeo, Dempsey, category, type );
		break;
	}
	return;
}

setup_hero_rival( player, hero, rival, category, type )
{
	players = GET_PLAYERS();
	
    playHero = false;
    playRival = false;
    hero_player = undefined;
    rival_player = undefined;
    
	for ( i = 0; i < players.size; i++ )
	{
    	if ( players[i].entity_num == hero )
    	{
    	    playHero = true;
    	    hero_player = players[i];
    	}
    	if ( players[i].entity_num == rival )
    	{
    	    playRival = true;
    	    rival_player = players[i];
    	}
	}
	
	if(playHero && playRival)
	{
		if(randomfloatrange(0,1) < .5)
		{
			playRival = false;
		}
		else
		{
			playHero = false;
		}
	}	
	if( playHero && IsDefined( hero_player ) )
	{		
		if( distancesquared (player.origin, hero_player.origin) < 500*500)
		{
			hero_player create_and_play_dialog( category, type + "_response", "hr_" );
		}
		else if( isdefined( rival_player ) )
		{
			playRival = true;
		}
	}		
	if( playRival && IsDefined( rival_player ) )
	{
		if( distancesquared (player.origin, rival_player.origin) < 500*500)
		{
			rival_player create_and_play_dialog( category, type + "_response", "riv_" );
		}
	}
}
*/
//For any 2d Announcer Line
do_announcer_playvox( category, type, team )
{
	if( !IsDefined( level.vox.speaker["announcer"].alias[category] ) || !isdefined( level.vox.speaker["announcer"].alias[category][type] ) )
		return;
	
	if( !IsDefined( level.devil_is_speaking ) )
	{
		level.devil_is_speaking = 0;
	}
	
	prefix = level.vox.speaker["announcer"].prefix;
	suffix = level.vox.speaker["announcer"].ent zmbVoxGetLineVariant( prefix, level.vox.speaker["announcer"].alias[category][type] );
	
	if( !isdefined( suffix ) )
		return;
	
	alias = prefix + suffix;
	//alias = level.vox.speaker["announcer"].prefix + level.vox.speaker["announcer"].alias[category][type] + "_0";
	
	if( level.devil_is_speaking == 0 )
	{
		level.devil_is_speaking = 1;
		
		if( !isdefined( team ) )
			level.vox.speaker["announcer"].ent PlaySoundWithNotify( alias, "sounddone" );
		else
			level thread zmbVoxAnnouncerToTeam( category, type, team );
			
		level.vox.speaker["announcer"].ent waittill( "sounddone" );
		level.devil_is_speaking = 0;
	}
}
zmbVoxAnnouncerToTeam( category, type, team )
{
	prefix = level.vox.speaker["announcer"].prefix;
	alias_to_team = prefix + level.vox.speaker["announcer"].ent zmbVoxGetLineVariant( prefix, level.vox.speaker["announcer"].alias[category][type] );
	
	if( isdefined( level.vox.speaker["announcer"].response[category][type] ) )
		alias_to_rival = prefix + level.vox.speaker["announcer"].ent zmbVoxGetLineVariant( prefix, level.vox.speaker["announcer"].response[category][type] );
	
	players = get_players();
	
	for( i=0;i<players.size;i++ )
	{
		if(!isDefined(players[i]._encounters_team) )
		{
			continue;
		}
		
		if( players[i]._encounters_team == team )
			level.vox.speaker["announcer"].ent playsoundtoplayer( alias_to_team, players[i] );
		else if( isdefined( alias_to_rival ) )
			level.vox.speaker["announcer"].ent playsoundtoplayer( alias_to_rival, players[i] );
	}
	
	wait(3);
	level.vox.speaker["announcer"].ent notify( "sounddone" );
}

//** Player Killstreaks: The following functions start a timer on each player whenever they begin killing zombies.
//** If they kill a certain amount of zombies within a certain time, they will get a Killstreak line
player_killstreak_timer()
{
	self endon("disconnect");
	self endon("death");
	
	if(GetDvar ("zombie_kills") == "") 
	{
		SetDvar ("zombie_kills", "7");
	}	
	if(GetDvar ("zombie_kill_timer") == "") 
	{
		SetDvar ("zombie_kill_timer", "5");
	}

	kills = GetDvarInt( "zombie_kills");
	time = GetDvarInt( "zombie_kill_timer");

	if (!isdefined (self.timerIsrunning))	
	{
		self.timerIsrunning = 0;
	}

	while(1)
	{
		self waittill( "zom_kill", zomb );	
		
		if( IsDefined( zomb._black_hole_bomb_collapse_death ) && zomb._black_hole_bomb_collapse_death == 1 )
		{
		    continue;
		}
		
		if( is_true( zomb.microwavegun_death ) )
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

player_zombie_kill_vox( hit_location, player, mod, zombie )
{
	weapon = player GetCurrentWeapon();
	dist = DistanceSquared( player.origin, zombie.origin );
	
	if( !isdefined(level.zombie_vars["zombie_insta_kill"] ) )
		level.zombie_vars["zombie_insta_kill"] = 0;
		
	instakill = level.zombie_vars["zombie_insta_kill"];
	
	death = get_mod_type( hit_location, mod, weapon, zombie, instakill, dist, player );
	chance = get_mod_chance( death );
	
	if( !IsDefined( player.force_wait_on_kill_line ) )
	    player.force_wait_on_kill_line = false;

	if( ( chance > RandomIntRange( 1, 100 ) ) && player.force_wait_on_kill_line == false )
	{
		player.force_wait_on_kill_line = true;
		player create_and_play_dialog( "kill", death );
		wait(2);
		player.force_wait_on_kill_line = false;
	}
}

get_mod_chance( meansofdeath )
{
	chance = undefined;
	
	switch( meansofdeath )
	{
		case "sickle":                  chance = 40; break;
		case "melee": 					chance = 40; break;
		case "melee_instakill": 	    chance = 99; break;
		case "weapon_instakill": 	    chance = 10; break;
		case "explosive": 				chance = 60; break;	
		case "flame":					chance = 60; break;	
		case "raygun":					chance = 75; break;	
		case "headshot":				chance = 99; break;
		case "crawler":					chance = 30; break;
		case "quad":					chance = 30; break;
		case "astro":					chance = 99; break;
		case "closekill":				chance = 15; break;	
		case "bullet":					chance = 10; break;
		case "claymore":                chance = 99; break;
		case "dolls":                   chance = 99; break;
		case "default":					chance = 1;  break;
	}
	return chance;
}

get_mod_type( impact, mod, weapon, zombie, instakill, dist, player )
{
	close_dist = 64 * 64;
	far_dist = 400 * 400;
	
	//PREVENTING BLACK HOLE BOMB FROM CALLING A BUNCH OF WEAPON KILL LINES
	if( IsDefined( zombie._black_hole_bomb_collapse_death ) && zombie._black_hole_bomb_collapse_death == 1 )
	{
	    return "default";
	}
	
	if( is_placeable_mine( weapon ) )
	{
	    if( !instakill )
	        return "claymore";
	    else
	        return "weapon_instakill";
	}
	
	//MELEE & MELEE_INSTAKILL
	if( ( mod == "MOD_MELEE" ||
				mod == "MOD_BAYONET" ||
				mod == "MOD_UNKNOWN" ) &&
				dist < close_dist )
	{
		if( !instakill )
		{
			if( player HasWeapon( "sickle_knife_zm" ) )
			    return "sickle";
			else
			    return "melee";
		}
		else
			return "melee_instakill";
	}
	
	if( IsDefined( zombie.damageweapon ) && zombie.damageweapon == "zombie_nesting_doll_single" )
	{
	    if( !instakill )
	        return "dolls";
	    else
	        return "weapon_instakill";
	}
	
	//EXPLOSIVE & EXPLOSIVE_INSTAKILL
	if( ( mod == "MOD_GRENADE" ||
				mod == "MOD_GRENADE_SPLASH" ||
				mod == "MOD_PROJECTILE_SPLASH" ||
				mod == "MOD_EXPLOSIVE" ) && 
			  weapon != "ray_gun_zm" )
	{
		if( !instakill )
			return "explosive";
		else
			return "weapon_instakill";
	}
	
	//FLAME & FLAME_INSTAKILL
	if( ( IsSubStr( weapon, "flame" ) || 
				IsSubStr( weapon, "molotov_" ) ||
				IsSubStr( weapon, "napalmblob_" ) ) && 
			( mod == "MOD_BURNED" || 
			 	mod == "MOD_GRENADE" || 
			 	mod == "MOD_GRENADE_SPLASH" ) )
	{
		if( !instakill )
			return "flame";
		else
			return "weapon_instakill";
	}
	
	//RAYGUN & RAYGUN_INSTAKILL
	if( weapon == "ray_gun_zm" &&
			dist > far_dist )
	{
		if( !instakill )
			return "raygun";
		else
			return "weapon_instakill";
	}
		
	//HEADSHOT
	if( ( mod == "MOD_RIFLE_BULLET" || 
		    mod == "MOD_PISTOL_BULLET" ) &&
		  ( impact == "head" &&
		  	dist > far_dist &&
		  	!instakill ) )
	{
		return "headshot";
	}
	
	//QUAD
	if( mod != "MOD_MELEE" && 
			impact != "head" &&
			zombie.animname == "quad_zombie" &&
			!instakill )
	{
	    return "quad";
	}		 
	
	//ASTRO
	if( mod != "MOD_MELEE" && 
			impact != "head" &&
			zombie.animname == "astro_zombie" &&
			!instakill )
	{
	    return "astro";
	}
	
	//CRAWLER
	if( mod != "MOD_MELEE" && 
			impact != "head" &&
			!zombie.has_legs &&
			!instakill )
	{
		return "crawler";
	}
	
	//CLOSEKILL
	if( mod != "MOD_BURNED" &&
			dist < close_dist && 
			!instakill )
	{
		return "closekill";
	}
	
	//BULLET & BULLET_INSTAKILL
	if( mod == "MOD_RIFLE_BULLET" || 
		  mod == "MOD_PISTOL_BULLET" )
	{
		if( !instakill )
			return "bullet";
		else
			return "weapon_instakill";
	}
	
	return "default";
}

timer_actual(kills, time)
{
	self endon("disconnect");
	self endon("death");
	
	timer = gettime() + (time * 1000);
	while(getTime() < timer)
	{
		if (self.killcounter > kills)
		{
			self create_and_play_dialog( "kill", "streak" );

			wait(1);
		
			//resets the killcounter and the timer 
			self.killcounter = 0;

			timer = -1;
		}
		wait(0.1);
	}
	self.killcounter = 0;
	self.timerIsrunning = 0;
}

perks_a_cola_jingle_timer()
{	
	self endon( "death" );
	self thread play_random_broken_sounds();
	while(1)
	{
		//wait(randomfloatrange(60, 120));
		wait(randomfloatrange(31,45));
		if(randomint(100) < 15)
		{
			self thread play_jingle_or_stinger(self.script_sound);
			
		}		
	}	
}

play_jingle_or_stinger( perksacola )
{
	playsoundatposition ("evt_electrical_surge", self.origin);
	if(!IsDefined (self.jingle_is_playing ))
	{
		self.jingle_is_playing = 0;
	}	
	if (IsDefined ( perksacola ))
	{
		if(self.jingle_is_playing == 0 && level.music_override == false)
		{
			self.jingle_is_playing = 1;
			self PlaySoundWithNotify ( perksacola, "sound_done");
			self waittill ("sound_done");
			self.jingle_is_playing = 0;
		}
	}
}

play_random_broken_sounds()
{
	self endon( "death" );
	level endon ("jingle_playing");
	if (!isdefined (self.script_sound))
	{
		self.script_sound = "null";
	}
	if (self.script_sound == "mus_perks_revive_jingle")
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
			playsoundatposition ("zmb_perks_broken_jingle", self.origin);
			//playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("evt_electrical_surge", self.origin);
	
		}
	}
	else
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
			// playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("evt_electrical_surge", self.origin);
		}
	}
}	

//SELF = Player Buying Perk
perk_vox( perk )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	//Delay to prevent an early speech
	wait( 1.5 );
	if( !IsDefined( level.vox.speaker["player"].alias["perk"][perk] ) )
	{
		/#
		IPrintLnBold( perk + " has no PLR VOX category set up." );
		#/
		return;
	}
	
	self create_and_play_dialog( "perk", perk );
}

dialog_debugger( category, type )
{
    /#
    PrintLn( "DIALOG DEBUGGER: " + self.zmbVoxID + " attempting to speak" );
    
    if( !IsDefined( level.vox.speaker[self.zmbVoxID].alias[category][type] ) )
	{
		IPrintLnBold( self.zmbVoxID + " tried to play a line, but no alias exists. Category: " + category + " Type: " + type );
	    PrintLn( "DIALOG DEBUGGER ERROR: Alias Not Defined For " + category + " " + type );
	}
	    
	if( !IsDefined( level.vox.speaker[self.zmbVoxID].response ) )
    	PrintLn( "DIALOG DEBUGGER ERROR: Response Alias Not Defined For " + category + " " + type + "_response" );
    #/
}

//MUSIC STATES
init_music_states()
{
    level.music_override = false;
    level.music_round_override = false;
    level.old_music_state = undefined;
    
    level.zmb_music_states                                  =   [];
    level thread setupMusicState( "round_start", "mus_zombie_round_start", true, true, true, "WAVE" );
    level thread setupMusicState( "round_end", "mus_zombie_round_over", true, true, true, "SILENCE" );
    level thread setupMusicState( "wave_loop", "WAVE", false, true, undefined, undefined );
    level thread setupMusicState( "game_over", "mus_zombie_game_over", true, false, undefined, "SILENCE" );
    level thread setupMusicState( "dog_start", "mus_zombie_dog_start", true, true, undefined, undefined );
    level thread setupMusicState( "dog_end", "mus_zombie_dog_end", true, true, undefined, undefined );
    level thread setupMusicState( "egg", "EGG", false, false, undefined, undefined );
    level thread setupMusicState( "egg_safe", "EGG_SAFE", false, false, undefined, undefined );
    level thread setupMusicState( "egg_a7x", "EGG_A7X", false, false, undefined, undefined );
    level thread setupMusicState( "sam_reveal", "SAM", false, false, undefined, undefined );
}
setupMusicState( state, alias, is_alias, override, round_override, musicstate )
{
	if( !isdefined( level.zmb_music_states[state] ) )
		level.zmb_music_states[state]                 =   spawnStruct();
	
    level.zmb_music_states[state].music           =   alias;
    level.zmb_music_states[state].is_alias        =   is_alias; 
    level.zmb_music_states[state].override        =   override;
    level.zmb_music_states[state].round_override  =   round_override;
    level.zmb_music_states[state].musicstate	  =	  musicstate;		
}

change_zombie_music( state )
{
    wait(.05);
    
    m = level.zmb_music_states[state];
    
    if( !IsDefined( m ) )
    {
        /#
        IPrintLnBold( "Called change_zombie_music on undefined state: " + state );
        #/
        return;
    }
    
    do_logic =  true;
    
    if( !IsDefined( level.old_music_state ) )
    {
        do_logic = false;
    }
    
    if(do_logic)
    {
        if( level.old_music_state == m )
        {
            return;
        }
        else if( level.old_music_state.music == "mus_zombie_game_over" )
        {
            return;
        }
    }
    
    if( !IsDefined( m.round_override ) )
        m.round_override = false;
    
    if( m.override == true && level.music_override == true )
        return;
        
    if( m.round_override == true && level.music_round_override == true )
        return;    
    
    if( m.is_alias )
    {
        if( IsDefined( m.musicstate ) )
        {
            maps\mp\_music::setmusicstate( m.musicstate );
        }
            
        play_sound_2d( m.music );
    }
    else
    {
        maps\mp\_music::setmusicstate( m.music );
    }
    
    level.old_music_state = m;
}

//SELF == Trigger, for now
weapon_toggle_vox( alias, weapon )
{
    self notify( "audio_activated_trigger" );
    self endon( "audio_activated_trigger" );
    
    prefix = "vox_pa_switcher_";
    sound_to_play = prefix + alias;
    type = undefined;
    
    if( IsDefined( weapon ) )
    {
        type = get_weapon_num( weapon );
        
        if( !IsDefined( type ) )
        {
            return;
        }
    }
    
    self StopSounds();
    wait(.05);
    
    if( IsDefined( type ) )
    {
        self PlaySoundWithNotify( prefix + "weapon_" + type, "sounddone" );
        self waittill( "sounddone" );
    }
    
    self PlaySound( sound_to_play + "_0" );
}
get_weapon_num( weapon )
{
    weapon_num = undefined;
    
    switch( weapon )
    {
        case "humangun_zm":         
            weapon_num =  0;   
        break;
        
		case "sniper_explosive_zm": 
		    weapon_num =  1;   
		break;
		
		case "tesla_gun_zm":        
		    weapon_num =  2;   
		break;
    }
    
    return weapon_num;
}

addAsSpeakerNPC()
{
	if ( !IsDefined( level.NPCs ) )
	{
		level.NPCs = [];
	}
	
	self.isNPC = true;
	
	level.NPCs[ level.NPCs.size ] = self;
}

areNearbySpeakersActive()
{
	radius = 1000; // Twice Range Of Response Radius (Which Is Currently 500 Units)
	
	nearbySpeakerActive = false;
	
	speakers = GET_PLAYERS();
	if ( IsDefined( level.NPCs ) )
	{
		speakers = ArrayCombine( speakers, level.NPCs, true, false );
	}
	
	foreach ( person in speakers )
	{
		if ( self == person )
		{
			continue;
		}
		
		// Players
		//--------
		if ( person is_player() )
		{
			// Nearby Player Isn't Currently Playing
			//--------------------------------------
			if ( person.sessionstate != "playing" )
			{
				continue;
			}
			
			// Nearby Player In Last Stand
			//----------------------------
			if ( person maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			{
				continue;
			}
		}
		// NPCs
		//-----
		else
		{
			
		}
		
		if ( is_true( person.isSpeaking ) )
		{
			if ( DistanceSquared( self.origin, person.origin ) < ( radius * radius ) )
			{
				nearbySpeakerActive = true;
			}
		}
	}
	
	return nearbySpeakerActive;
}

zmbVoxCreate()
{
	vox = SpawnStruct(); 
	vox.speaker = []; 
	return( vox );
}
zmbVoxInitSpeaker( speaker, prefix, ent )
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
zmbVoxAdd( speaker, category, type, alias, response )
{
	Assert( IsDefined( speaker ) );
	Assert( IsDefined( category ) );
	Assert( IsDefined( type ) );
	Assert( IsDefined( alias ) );
	
	if( !isdefined( self.speaker[speaker] ) )
	{
		self.speaker[speaker] = SpawnStruct();
		self.speaker[speaker].alias = [];
	}
	
	if( !isdefined( self.speaker[speaker].alias[category] ) )
	{
		self.speaker[speaker].alias[category] = [];
	}
	
	self.speaker[speaker].alias[category][type] = alias;
	
	if( isdefined( response ) )
	{
		if( !isdefined( self.speaker[speaker].response ) )
			self.speaker[speaker].response = [];
		
		if( !isdefined( self.speaker[speaker].response[category] ) )
			self.speaker[speaker].response[category] = [];
		
		self.speaker[speaker].response[category][type] = response;
	}
}

zmbVoxGetLineVariant( prefix, alias_suffix, force_variant, override )
{
	if( !IsDefined ( self.sound_dialog ) )
	{
		self.sound_dialog = [];
		self.sound_dialog_available = [];
	}
				
	if ( !IsDefined ( self.sound_dialog[ alias_suffix ] ) )//|| (self.sound_dialog[ alias_suffix ].size <= 0) )
	{
		num_variants = maps\mp\zombies\_zm_spawner::get_number_variants( prefix + alias_suffix );      
		
		if( num_variants <= 0 )
		{
		    /#
		    if( GetDvarInt( "debug_audio" ) > 0 )
		        PrintLn( "DIALOG DEBUGGER: No variants found for - " + prefix + alias_suffix );
		    #/
		    return undefined;
		}     
		
		for( i = 0; i < num_variants; i++ )
		{
			self.sound_dialog[ alias_suffix ][ i ] = i;     
		}	
		
		self.sound_dialog_available[ alias_suffix ] = [];
	}
	
	if ( self.sound_dialog_available[ alias_suffix ].size <= 0 )
	{
		for( i = 0; i < self.sound_dialog[ alias_suffix ].size; i++ )
		{
			self.sound_dialog_available[ alias_suffix ][i] = self.sound_dialog[ alias_suffix ][i];
		}
	}
  
	variation = random( self.sound_dialog_available[ alias_suffix ] );
	ArrayRemoveValue( self.sound_dialog_available[ alias_suffix ], variation );
    
    if( IsDefined( force_variant ) )
    {
        variation = force_variant;
    }
    
    if( !IsDefined( override ) )
    {
        override = false;
    }
    
    return (alias_suffix + "_" + variation);
}

zmbVoxCrowdOnTeam( alias, team, other_alias )
{	
	alias = "vox_crowd_" + alias;
	
	if( !isdefined( team ) )
	{
		level play_sound_2d( alias );
		return;
	}
	
	players = get_players();
	
	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]._encounters_team) )
		{
			continue;
		}
		
		if( players[i]._encounters_team == team )
		{
			players[i] playsoundtoplayer( alias, players[i] );
		}
		else if( isdefined( other_alias ) )
		{
			players[i] playsoundtoplayer( other_alias, players[i] );
		}
	}
}