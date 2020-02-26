//T6todo #include clientscripts\_music;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
//T6todo #include clientscripts\_zombiemode_dissolve;

#include clientscripts\mp\_utility;

init()
{
	PrintLn( "ZM >> Zombiemode Client Scripts Init (_zm.csc) " );
	
//T6todo	level thread clientscripts\_zombiemode_ffotd::main_start();

	level.zombiemode = true;
	level.swimmingFeature = false;

//T6todo	clientscripts\_load::main();

//T6todo	clientscripts\_footsteps::SetAIFootstepPrepend( "fly_step_zombie_");

//	thread clientscripts\_fx::fx_init(0);
//T6todo	thread clientscripts\_audio::audio_init(0);

	PrintLn( "ZM >> init_client_flags (_zm.csc) " );
	init_client_flags();
	
	PrintLn( "ZM >> init_client_flag_callback_funcs (_zm.csc) " );
	init_client_flag_callback_funcs();
	
	init_blocker_fx();
	init_riser_fx();
	
	level._zombieCBFunc = ::on_zombie_spawn;
	level._playerCBFunc = ::on_player_spawn;
	level._gibEventCBFunc = ::on_gib_event;
	
	level thread ZPO_listener();

	level._BOX_INDICATOR_NO_LIGHTS = -1;
	level._BOX_INDICATOR_FLASH_LIGHTS_MOVING = 99;
	level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE = 98;
	
	level._box_indicator = level._BOX_INDICATOR_NO_LIGHTS;	// No lights showing.

	registerSystem("box_indicator", ::box_monitor);

	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;

	OnPlayerConnect_Callback( ::on_player_connect );

//T6todo	clientscripts\_zombiemode_weap_freezegun::init();
//T6todo	clientscripts\_zombiemode_weap_tesla::init();
//T6todo	clientscripts\_zombiemode_weap_thundergun::init();

//T6todo	level thread clientscripts\_zombiemode_ffotd::main_end();
}


init_blocker_fx()
{
	level._effect["wood_chunk_destory"]	 		= LoadFX( "impacts/fx_large_woodhit" );
}

init_riser_fx()
{
	if(isDefined(level.riser_fx_on_client) && level.riser_fx_on_client )
	{
	
		// NEW riser effects in water
		if(isDefined(level.use_new_riser_water) && level.use_new_riser_water)
		{
			level._effect["rise_burst_water"]			  = LoadFX("maps/zombie/fx_mp_zombie_hand_water_burst");
			level._effect["rise_billow_water"]			= LoadFX("maps/zombie/fx_mp_zombie_body_water_billowing");	
		}
	
		level._effect["rise_dust_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_falling");
	
		level._effect["rise_burst"]					= LoadFX("maps/zombie/fx_mp_zombie_hand_dirt_burst");
		level._effect["rise_billow"]				= LoadFX("maps/zombie/fx_mp_zombie_body_dirt_billowing");
		level._effect["rise_dust"]					= LoadFX("maps/zombie/fx_mp_zombie_body_dust_falling");	
		
		if(isDefined(level.riser_type) && level.riser_type == "snow")
		{
			level._effect["rise_burst_snow"]        = loadfx("maps/zombie/fx_mp_zombie_hand_snow_burst");
			level._effect["rise_billow_snow"]       = loadfx("maps/zombie/fx_mp_zombie_body_snow_billowing");
			level._effect["rise_dust_snow"]					= LoadFX("maps/zombie/fx_mp_zombie_body_snow_falling");	
		}
	}

}

// Client flags registered here should be for global zombie systems, and should
// prefer to use high flag numbers and work downwards.

// Level specific flags should be registered in the level, and should prefer 
// low numbers, and work upwards.

init_client_flags()
{
	// Client flags for script movers
	PrintLn( "ZM >> init_client_flags START(_zm.csc) " );
	
	level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM	= 15;
	
	if(isDefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{
		//for tearing down and repairing the boards and rock chunks
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX	= 14;
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX	= 13;
	}
	
	if(isDefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
	{
		level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX	= 12;		
	}
	
	// Client flags for the player
	
	level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON = 14;
	level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION = 13;
	level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK = 12;
	
	if(isDefined(level.riser_fx_on_client) && level.riser_fx_on_client)
	{
		// Client flags for actors
		level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX = 8;
		level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX_WATER = 9;
	}
}


init_client_flag_callback_funcs()
{
	// Callbacks for script movers
	PrintLn( "ZM >> init_client_flag_callback_funcs START (_zm.csc) " );
	
	if(isDefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{	
		register_clientflag_callback("scriptmover", level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX, ::handle_vertical_board_clientside_fx);
		register_clientflag_callback("scriptmover", level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX, ::handle_horizontal_board_clientside_fx);
	}
	if(isDefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
	{
		register_clientflag_callback("scriptmover", level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX, ::handle_rock_clientside_fx);
	}
	
	println( "ZM >> register_clientflag_callback (_ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM) weapon_box_callback - client scripts" );
	register_clientflag_callback("scriptmover", level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM, clientscripts\mp\zombies\_zm_weapons::weapon_box_callback);
	
	
	// Callbacks for players
	register_clientflag_callback( "player", level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION, ::zombie_dive2nuke_visionset );
	register_clientflag_callback("player", level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON, ::player_toggle_cloak_handler);
	register_clientflag_callback("player", level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK, ::player_deadshot_perk_handler);
	
	if(isDefined(level.riser_fx_on_client) && level.riser_fx_on_client)
	{
		// Callbacks for actors
		register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX, ::handle_zombie_risers );
		register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX_WATER, ::handle_zombie_risers_water );
	}
}


handle_horizontal_board_clientside_fx(localClientNum, set, newEnt)
{
	
	if ( localClientNum != 0 )
	{
		return;
	}
	
	if(set)
	{
		localPlayers = getlocalplayers();
		snd_played = 0;
		for(i = 0; i < localPlayers.size; i ++)
		{	
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			if(!snd_played)
			{
				self thread do_teardown_sound("plank");
				snd_played = true;
			}
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (0, 0, -30));
		}	
	}
	else
	{
		playsound(0,"zmb_repair_boards",self.origin);
	
		localPlayers = getlocalplayers();
		snd_played = 0;
		wait(.3);
		PlaySound(0, "zmb_board_slam",self.origin );
			for(i = 0; i < localPlayers.size; i ++)
		{
			localPlayers[i] EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), self.origin, 150 ); // do I want an increment if more are gone...
			
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...

			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (0, 0, -30));
		}	
	}
	
}

handle_vertical_board_clientside_fx(localClientNum, set, newEnt)
{
	if ( localClientNum != 0 )
	{
		return;
	}
	if(set)
	{
		localPlayers = getlocalplayers();
		snd_played = 0;
		for(i = 0; i < localPlayers.size; i ++)
		{
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			if(!snd_played)
			{
				self thread do_teardown_sound("plank");
				snd_played = true;
			}
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (-30, 0, 0));
		}	
	}
	else
	{
		
		localPlayers = getlocalplayers();
		snd_played = 0;
		playsound(0,"zmb_repair_boards",self.origin);
		wait(.3);
		PlaySound(0, "zmb_board_slam",self.origin );
		for(i = 0; i < localPlayers.size; i ++)
		{
			localPlayers[i] EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), self.origin, 150 ); // do I want an increment if more are gone...
			
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...

			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (-30, 0, 0));
		}
	
	}
}

handle_rock_clientside_fx(localClientNum, set, newEnt)
{
	if ( localClientNum != 0 )
	{
		return;
	}

	if(set)
	{
		localPlayers = getlocalplayers();
		snd_played = 0;
		for(i = 0; i < localPlayers.size; i ++)
		{
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			if(!snd_played)
			{
				self thread do_teardown_sound("rock");
				snd_played = true;
			}
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (-30, 0, 0));
		}	
	}
	else
	{
		
		localPlayers = getlocalplayers();
		snd_played = 0;
		playsound(0,"zmb_repair_boards",self.origin);
		playsound(0,"zmb_cha_ching",self.origin);
		for(i = 0; i < localPlayers.size; i ++)
		{
			localPlayers[i] EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), self.origin, 150 ); // do I want an increment if more are gone...
			
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			if(!snd_played)
			{
				PlaySound(0, "zmb_break_rock_barrier_fix",self.origin );
				snd_played = true;
			}
			PlayFx( i,level._effect["wood_chunk_destory"], self.origin + (-30, 0, 0));
		}	
	}
	
}

do_teardown_sound(type)
{
	switch(type)
	{
		case "rock":
			PlaySound(0,"zmb_break_rock_barrier_fix",self.origin );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    PlaySound( 0,"zmb_break_rock_barrier_fix",self.origin );	
			break;
			
		case "plank":
			PlaySound(0,"zmb_break_boards",self.origin );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    PlaySound( 0,"zmb_break_boards",self.origin );	
			break;
	}
}

box_monitor(clientNum, state, oldState)
{
	if(IsDefined(level._custom_box_monitor))
	{
		[[level._custom_box_monitor]](clientNum, state, oldState);
	}
}

ZPO_listener()
{
	while(1)
	{
		level waittill("ZPO");	// Zombie power on.

		level notify("power_on" );	
		level notify("revive_on");
		level notify("middle_door_open");
		level notify("fast_reload_on");
		level notify("doubletap_on");
		level notify("divetonuke_on");
		level notify("marathon_on");
		level notify("jugger_on");
		level notify("additionalprimaryweapon_on");
	}
}

player_deadshot_perk_handler(localClientNum, set, newEnt)
{
	if ( !self IsLocalPlayer() || self IsSpectating() || self GetEntityNumber() != GetLocalPlayers()[localClientNum] GetEntityNumber() )
		return;
	
	if(set)
	{
		self UseAlternateAimParams();
	}
	else
	{
		self ClearAlternateAimParams();
	}
}

player_toggle_cloak_handler(localClientNum, set, newEnt)
{
	if ( set )
	{
		self thread cloak( localClientNum );
	}
	else
	{
		self thread uncloak( localClientNum );
	}	
}

//
//
createZombieEyes(localClientNum)
{
	if(isdefined(self._eyeArray))
	{
		if(!isdefined(self._eyeArray[localClientNum]))
		{
			linkTag = "J_Eyeball_LE";
			self._eyeArray[localClientNum] = PlayFxOnTag( localClientNum, level._effect["eye_glow"], self, linkTag );
		}
	} 
}

	
deleteZombieEyes(localClientNum)
{
	if(isdefined(self._eyeArray))
	{
		if(isdefined(self._eyeArray[localClientNum]))
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum] , true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}


on_player_connect(localClientNum)
{
	ForceGameModeMappings( localClientNum, "default" );
}


on_player_spawn(localClientNum)
{
	ForceGameModeMappings( localClientNum, "default" );
}


on_zombie_spawn(localClientNum)
{
	self endon("entityshutdown");
	if(!isdefined(self._eyeArray))
	{
		self._eyeArray = [];
	}

	wait( 0.05 ); //Wait and make sure we have set the haseyes flag on the server

	if(self haseyes())
	{
		self createZombieEyes(localClientNum);
	}

	self mapshaderconstant( localClientNum, 0, "scriptVector0", -4.0, -1.0, 0.0, -1.0 );
}

zombie_eye_callback(localClientNum, hasEyes)
{
	players = GetLocalPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( hasEyes )
		{
			self createZombieEyes( i );
		}
		else
		{
			self deleteZombieEyes( i );
		}
	}
}

init_perk_machines_fx()
{
	if ( GetDvar( "createfx" ) == "on" || GetDvar( "mutator_noPerks" ) == "1" )
	{
		return;
	}
	
	
	level._effect["sleight_light"]							= loadfx( "misc/fx_zombie_cola_on" );
	level._effect["doubletap_light"]						= loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect["divetonuke_light"]						= loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect["marathon_light"]							= loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect["jugger_light"]							= loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect["revive_light"]							= loadfx( "misc/fx_zombie_cola_revive_on" ); 
	level._effect["additionalprimaryweapon_light"]			= loadfx( "misc/fx_zombie_cola_dtap_on" );
	
	level thread perk_start_up();
	
}
perk_start_up()
{
	level waittill( "power_on" );
		
	timer = 0;
	duration = 0.1;
	
	machines = GetStructArray( "perksacola", "targetname" );
	
	while( true )
	{
		for( i = 0; i < machines.size; i++ )
		{
			switch( machines[i].script_sound )
			{
			case "mx_jugger_jingle":
				machines[i] thread vending_machine_flicker_light( "jugger_light", duration );
				break;
				
			case "mx_speed_jingle":
				machines[i] thread vending_machine_flicker_light( "sleight_light", duration );
				break;
				
			case "mx_doubletap_jingle":
				machines[i] thread vending_machine_flicker_light( "doubletap_light", duration );
				break;
				
			case "mx_divetonuke_jingle":
				machines[i] thread vending_machine_flicker_light( "divetonuke_light", duration );
				break;
				
			case "mx_marathon_jingle":
				machines[i] thread vending_machine_flicker_light( "marathon_light", duration );
				break;
			
			case "mx_revive_jingle":
				machines[i] thread vending_machine_flicker_light( "revive_light", duration );
				break;
				
			case "mx_additionalprimaryweapon_jingle":
				machines[i] thread vending_machine_flicker_light( "additionalprimaryweapon_light", duration );
				break;

			default:
				machines[i] thread vending_machine_flicker_light( "jugger_light", duration );
				break;
			}
		}
		timer += duration;
		duration += 0.2;
		if( timer >= 3 )
		{
			break;
		}
		realwait( duration );
	}
}

vending_machine_flicker_light( fx_light, duration )
{		
	players = getlocalplayers();
	for( i = 0; i < players.size; i++ )
	{
		self thread play_perk_fx_on_client( i, fx_light, duration );
	}

}
play_perk_fx_on_client( client_num, fx_light, duration )
{
	
	fxObj = spawn( client_num, self.origin +( 0, 0, -50 ), "script_model" ); 
	fxobj setmodel( "tag_origin" ); 
	//fxobj.angles = self.angles;
	playfxontag( client_num, level._effect[fx_light], fxObj, "tag_origin" ); 	 
	realwait( duration );
	fxobj delete();


}

cloak( localClientNum )
{
	self thread run_cloak_effect( localClientNum, true, 1500 );
}


uncloak( localClientNum )
{
	self thread run_cloak_effect( localClientNum, false, 1000 );
}


run_cloak_effect( localClientNum, cloak, durationMsec )
{
	self endon( "entityshutdown" );

	begin_time = GetRealTime();
	while( 1 )
	{
		age = GetRealTime() - begin_time;
		original_t = age / durationMsec;
		
		original_t = clamp( original_t, 0.0, 1.0 );
		adjusted_t = original_t;
		if ( !cloak )
		{
			adjusted_t = 1.0 - adjusted_t ;
		}

		// now map the required 0 -> 1 into the correct shader inputs for the cloak effect 0 -> 1 to -1 -> 1

		cloakMaskCompression = 1.0;
		cloakAmount = (adjusted_t - 0.5) * 2.0;
		cloakAmount = clamp( cloakAmount, -1.0, 1.0 );
		cloakAmount = cloakAmount * cloakMaskCompression;
		
		self setshaderconstant( localClientNum, 0, cloakMaskCompression, cloakAmount, 0, 0 );

		if ( original_t == 1.0 )
		{
			break;
		}

		realwait(0.05);
	}
}


mark_piece_gibbed( piece_index )
{
	if ( !isdefined( self.gibbed_pieces ) )
	{
		self.gibbed_pieces = [];
	}

	self.gibbed_pieces[self.gibbed_pieces.size] = piece_index;
}


has_gibbed_piece( piece_index )
{
	if ( !isdefined( self.gibbed_pieces ) )
	{
		return false;
	}

	for ( i = 0; i < self.gibbed_pieces.size; i++ )
	{
		if ( self.gibbed_pieces[i] == piece_index )
		{
			return true;
		}
	}

	return false;
}


do_headshot_gib_fx()
{
	fxTag = "j_neck";
	fxOrigin = self GetTagOrigin( fxTag );
	upVec = AnglesToUp( self GetTagAngles( fxTag ) );
	forwardVec = AnglesToForward( self GetTagAngles( fxTag ) );

	players = getlocalplayers();

	for ( i = 0; i < players.size; i++ )
	{
		// main head pop fx
		PlayFX( i, level._effect["headshot"], fxOrigin, forwardVec, upVec );
		PlayFX( i, level._effect["headshot_nochunks"], fxOrigin, forwardVec, upVec );
	}

	wait( 0.3 );
	if ( IsDefined( self ) )
	{
		players = getlocalplayers();

		for ( i = 0; i < players.size; i++ )
		{
			PlayFxOnTag( i, level._effect["bloodspurt"], self, fxTag );
		}
	}
}

do_gib_fx( tag )
{
	players = getlocalplayers();
	
	for ( i = 0; i < players.size; i++ )
	{
		PlayFxOnTag( i, level._effect["animscript_gib_fx"], self, tag ); 
	}
	PlaySound( 0, "zmb_death_gibs", self gettagorigin( tag ) );
}


do_gib( model, tag )
{
	//PrintLn( "*** Generating gib " + model + " from tag " + tag );

	start_pos = self gettagorigin( tag );
	start_angles = self gettagangles(tag);
	
	wait( 0.016 );
	
	end_pos = undefined;
	angles = undefined;
	
	if(!IsDefined(self))
	{
		end_pos = start_pos + (AnglesToForward(start_angles) * 10);
		angles = start_angles;
	}	
	else
	{
		end_pos = self gettagorigin( tag );
		angles = self gettagangles(tag);
	}

	if ( IsDefined( self._gib_vel ) )
	{
		forward = self._gib_vel;
		self._gib_vel = undefined;
	}
	else
	{
		forward = VectorNormalize( end_pos - start_pos ); 
		forward *= RandomIntRange( 600, 1000 );      
		forward += (0, 0, RandomIntRange( 400, 700 )); 
//		forward *= 2.0;
	}

	CreateDynEntAndLaunch( 0, model, end_pos, angles, start_pos, forward, level._effect["animscript_gibtrail_fx"], 1 );

	if(IsDefined(self))
	{
		self do_gib_fx( tag );
	}
	else
	{
		PlaySound( 0, "zmb_death_gibs", end_pos);
	}
}

on_gib_event( localClientNum, type, locations )
{
	if ( localClientNum != 0 )
	{
		return;
	}

	if( !is_mature() )
	{
		return;
	}

	if ( !isDefined( self._gib_def ) )
	{
		return;
	}

	if ( self._gib_def == -1 )
	{
		return;	// We're not set up to gib.  Go away.
	}

	if ( IsDefined( level._gib_overload_func ) )
	{
		PrintLn( "type " + type );
		PrintLn( "loc size " + locations.size );
		if ( self [[level._gib_overload_func]]( type, locations ) )
		{
			return;	// if overload func returns true - do more more processing.
		}
	}

	for ( i = 0; i < locations.size; i++ )
	{
		// only the head can gib after already gibbing
		if ( IsDefined( self.gibbed ) && level._ZOMBIE_GIB_PIECE_INDEX_HEAD != locations[i] )
		{
			continue;
		}

		switch( locations[i] )
		{
			case 0: // level._ZOMBIE_GIB_PIECE_INDEX_ALL
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn1 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag1 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn1, level._gibbing_actor_models[self._gib_def].gibSpawnTag1 );
				}
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn2 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag2 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn2, level._gibbing_actor_models[self._gib_def].gibSpawnTag2 );
				}
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn3 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag3 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn3, level._gibbing_actor_models[self._gib_def].gibSpawnTag3 );
				}
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn4 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag4 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn4, level._gibbing_actor_models[self._gib_def].gibSpawnTag4 );
				}

				self thread do_headshot_gib_fx(); // head
				self thread do_gib_fx( "J_SpineLower" ); //guts

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG );
				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HEAD );
				break;

			case 1: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn1 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag1 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn1, level._gibbing_actor_models[self._gib_def].gibSpawnTag1 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM );
				break;

			case 2: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn2 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag2 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn2, level._gibbing_actor_models[self._gib_def].gibSpawnTag2 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM );
				break;

			case 3: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn3 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag3 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn3, level._gibbing_actor_models[self._gib_def].gibSpawnTag3 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
				break;

			case 4: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG
				if ( IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawn4 ) && IsDefined( level._gibbing_actor_models[self._gib_def].gibSpawnTag4 ) )
				{
					self thread do_gib( level._gibbing_actor_models[self._gib_def].gibSpawn4, level._gibbing_actor_models[self._gib_def].gibSpawnTag4 );
				}

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG );
				break;

			case 5: // level._ZOMBIE_GIB_PIECE_INDEX_HEAD, fx only
				self thread do_headshot_gib_fx();

				mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HEAD );
				break;

			case 6: // level._ZOMBIE_GIB_PIECE_INDEX_GUTS, fx only
				self thread do_gib_fx( "J_SpineLower" );
				break;
		} 
	}

	self.gibbed = true;
}


// ww: function stores the vision set passed in and then applies it to the local player the function is threaded
// on. visionsets will be set up in a priority queue, whichever is the highest scoring vision set will be applied
// priorities should not go over ten! ten is only reserved for sets that must trump any and all (e.g. black hole bomb )
// SELF == PLAYER
zombie_vision_set_apply( str_visionset, int_priority, flt_transition_time, int_clientnum )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	// make sure the vision set list is on the player
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		// if not create it
		self._zombie_visionset_list = [];
	}
	
	// make sure the variables passed in are valid
	if( !IsDefined( str_visionset ) || !IsDefined( int_priority ) )
	{
		return;
	}
	
	// default flt_transition_time
	if( !IsDefined( flt_transition_time ) )
	{
		flt_transition_time = 1;
	}
	
	if( !IsDefined( int_clientnum ) )
	{
		if(self IsLocalPlayer())
		{
			int_clientnum = self GetLocalClientNumber();
		}
		
		if(!IsDefined(int_clientnum))
		{
			return;	// GetLocalClientNumber fails for spectators - get out.
		}
	}
	
	// make sure there isn't already one of the vision set in the array
	already_in_array = false;
	
	// if the array already has items in it check for duplictes
	if( self._zombie_visionset_list.size != 0 )
	{
		for( i = 0; i < self._zombie_visionset_list.size; i++ )
		{
			if( IsDefined( self._zombie_visionset_list[i].vision_set ) && self._zombie_visionset_list[i].vision_set == str_visionset )
			{
				already_in_array = true;
				
				// if the priority is different change it and 
				if( self._zombie_visionset_list[i].priority != int_priority )
				{
					// reset the priority based on the new int_priority
					self._zombie_visionset_list[i].priority = int_priority;
				}
				
				break;
				
			}
			
			// check to see if there is a visionset with this priority
		}
	}

	
	// if it isn't in the array add it
	if( !already_in_array )
	{
		// add the new vision set to the array
		temp_struct = spawnStruct();
		temp_struct.vision_set = str_visionset;
		temp_struct.priority = int_priority;
		self._zombie_visionset_list = add_to_array( self._zombie_visionset_list, temp_struct, false );
	}
	
	// now go through the player's list and find the one with highest priority	
	vision_to_set = self zombie_highest_vision_set_apply();
	
	if( IsDefined( vision_to_set ) )
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, vision_to_set, flt_transition_time );
	}
	else
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, "undefined", flt_transition_time );
	}
	
}

// ww: removes the vision set from the vision set array, goes through the array and sets the next highest priority
// SELF == PLAYER
zombie_vision_set_remove( str_visionset, flt_transition_time, int_clientnum )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	// make sure hte vision set is passed in
	if( !IsDefined( str_visionset ) )
	{
		return;
	}
	
	// default transition time
	if( !IsDefined( flt_transition_time ) )
	{
		flt_transition_time = 1;
	}
	
	// can't call this before the array has been set up through apply
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		self._zombie_visionset_list = [];
	}
	
	// get the player's client number if it wasn't passed in
	if( !IsDefined( int_clientnum ) )
	{
		if(self IsLocalPlayer())
		{
			int_clientnum = self GetLocalClientNumber();
		}
		
		if(!IsDefined(int_clientnum))
		{
			return;	// GetLocalClientNumber fails for spectators - get out.
		}
	}
	
	// remove the vision set from the array
	temp_struct = undefined;
	for( i = 0; i < self._zombie_visionset_list.size; i++ )
	{
		if( IsDefined( self._zombie_visionset_list[i].vision_set ) && self._zombie_visionset_list[i].vision_set == str_visionset )
		{
			temp_struct = self._zombie_visionset_list[i];
		}
	}
	
	if( IsDefined( temp_struct ) )
	{
		self._zombie_visionset_list = array_remove( self._zombie_visionset_list, temp_struct );
	}
	
	// set the next highest priority	
	vision_to_set = self zombie_highest_vision_set_apply();
	
	if( IsDefined( vision_to_set ) )
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, vision_to_set, flt_transition_time );
	}
	else
	{
		// now you have the highest scoring vision set, apply to player
		VisionSetNaked( int_clientnum, "undefined", flt_transition_time );
	}
}

// ww: apply the highest score vision set
zombie_highest_vision_set_apply()
{
	if( !IsDefined( self._zombie_visionset_list ) )
	{
		return;
	}
	
	highest_score = 0;
	highest_score_vision = undefined;
	
	//PrintLn( "******************************* " + self GetLocalClientNumber() + " ******************************" );
	//PrintLn( "******************************* " + self._zombie_visionset_list.size + " ******************************" );
	
	for( i = 0; i < self._zombie_visionset_list.size; i++ )
	{
		if( IsDefined( self._zombie_visionset_list[i].priority ) && self._zombie_visionset_list[i].priority > highest_score )
		{
			highest_score = self._zombie_visionset_list[i].priority;
			highest_score_vision = self._zombie_visionset_list[i].vision_set;
			//PrintLn( "******************************* " + self._zombie_visionset_list[i].priority + " ******************************" );
			//PrintLn( "******************************* " + self._zombie_visionset_list[i].vision_set + " ******************************" );
		}
	}
	
	return highest_score_vision;
}

// WW (01/12/11): Adding watcher function for dive to nuke's visionset and visual cues. Clientnotify will come from _zombiemode_perks
// for Acension, the watcher is started in zombie_cosmodrome OnPlayConnect & OnPlayerSpawned. Self will be player
zombie_dive2nuke_visionset( local_client_num, set, newEnt )
{
	self endon( "disconnect" );
	
	if( local_client_num != 0 )
	{
		return;
	}

	if( set )
	{
		if( !IsDefined( self._zombie_visionset_list ) )
		{
			PrintLn( "********************* zombie visionset array is not defined *******************************" );
		}
		
		// get players
		player = GetLocalPlayers()[ local_client_num ];
		if ( player GetEntityNumber() != self GetEntityNumber() )
		{
			return;
		}
		
		time_to_apply_vision = 0;
		time_to_remove_vision = 0.5;
		
		// start the vision set
		// WW (01/12/11): Breaking the priority rule here because this came after the black hole bomb. Greater than 10 is needed to trump the black hole
		self thread zombie_vision_set_apply( "zombie_cosmodrome_diveToNuke", 11, time_to_apply_vision, local_client_num );

		// wait before restoring it
		wait( 0.5 );
		
		// remove vision set
		self thread zombie_vision_set_remove( "zombie_cosmodrome_diveToNuke", time_to_remove_vision, local_client_num );

	}
	
}


sidequest_solo_completed_watcher()
{
	level endon( "SQC" );

	level waittill( "SQS" );

	SetCollectible( level.zombie_sidequest_solo_collectible );
}


sidequest_coop_completed_watcher()
{
	level endon( "SQS" );

	level waittill( "SQC" );

	SetCollectible( level.zombie_sidequest_solo_collectible );
	SetCollectible( level.zombie_sidequest_coop_collectible );
}


register_sidequest( solo_collectible, coop_collectible )
{
	level.zombie_sidequest_solo_collectible = solo_collectible;
	level.zombie_sidequest_coop_collectible = coop_collectible;

	level thread sidequest_solo_completed_watcher();
	level thread sidequest_coop_completed_watcher();
}




handle_zombie_risers_water(localClientNum, set, newEnt)
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	if(set)
	{
		localPlayers = getlocalplayers();
		snd_played = 0;
		for(i = 0; i < localPlayers.size; i ++)
		{
			if(!snd_played)
	  	{
	  		playsound(0,"zmb_zombie_spawn_water", self.origin);
				snd_played = 1;
			}
			playfx(i,level._effect["rise_burst_water"],self.origin + ( 0,0,randomintrange(5,10) ) );
			wait(.25);
			playfx(i,level._effect["rise_billow_water"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
			self thread rise_dust_fx(i,"water");
		}
	}
}


handle_zombie_risers(localClientNum, set, newEnt)
{
	if ( localClientNum != 0 )
	{
		return;
	}
		
	if(set)
	{
		localPlayers = getlocalplayers();
		snd_played = 0;
		
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		
		if(isdefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
	
		for(i = 0; i < localPlayers.size; i ++)
		{
			if(!snd_played)
	  	{
	  		playsound (0,sound, self.origin);
				snd_played = 1;
			}
			playfx(i,burst_fx,self.origin + ( 0,0,randomintrange(5,10) ) );
			wait(.25);
			playfx(i,billow_fx,self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
			self thread rise_dust_fx(i,type);
		}
	}

}

rise_dust_fx(clientnum,type)
{
	dust_tag = "J_SpineUpper";
	
	self endon("entityshutdown");


	dust_time = 7.5; // play dust fx for a max time
	dust_interval = .1; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	player = getlocalplayers()[clientnum];
	
	effect = level._effect["rise_dust"];
	
	if(type == "water")
	{
		effect = level._effect["rise_dust_water"];
	}
	else if ( type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
		
	for (t = 0; t < dust_time; t += dust_interval)
	{
		PlayfxOnTag(clientnum,effect, self, dust_tag);
		wait dust_interval;
	}

}
