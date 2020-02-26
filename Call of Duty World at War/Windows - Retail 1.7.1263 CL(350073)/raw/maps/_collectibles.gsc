#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_collectibles_game;

main()
{
	precachestring( &"SCRIPT_COLLECTIBLE_OF_THIRTEEN" );
	precachestring( &"SCRIPT_COLLECTIBLE_STICKS_AND_STONES_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_VAMPIRE_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_BERSERKER_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_ZOMBIE_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_PAINTBALL_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_DIRTY_HARRY_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_MORPHINE_SHOT_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_THUNDER_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_FLAK_JACKET_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_HARDCORE_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_BODY_ARMOR_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_HARD_HEADED_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_COLD_DEAD_HANDS_UNLOCK" );
	precachestring( &"SCRIPT_COLLECTIBLE_USAGE" );

	level._effect["thunder"] = loadfx("explosions/default_explosion");

	level.collectible_dvar = "cheat_items_set1";
	level.host_options_dvar = "ui_hostOptions";
	level.host_options_enabled_dvar = "ui_hostOptionsEnabled";
	
	level.collectible_table				= "maps/_collectible_items.csv";
	level.collectible_table_unlock_col	= 0;
	level.collectible_table_key_col		= 1;

	level.collectible_unlocks["collectible_sticksstones"]	= 0;
	level.collectible_unlocks["collectible_vampire"]		= 1;	
	level.collectible_unlocks["collectible_berserker"]		= 2;
	level.collectible_unlocks["collectible_zombie"]			= 3;	
	level.collectible_unlocks["collectible_paintball"]		= 4;
	level.collectible_unlocks["collectible_dirtyharry"]		= 5;
	level.collectible_unlocks["collectible_morphine"]		= 6;	
	level.collectible_unlocks["collectible_thunder"]		= 7;	
	level.collectible_unlocks["collectible_flak_jacket"]	= 8;
	level.collectible_unlocks["collectible_hardcore"]		= 9;
	level.collectible_unlocks["collectible_body_armor"]		= 10;
	level.collectible_unlocks["collectible_hard_headed"]	= 11;
	level.collectible_unlocks["collectible_dead_hands"]		= 12;

	level.collectible_save_restored = false;
	level.collectibles = collectible_init();

	level thread onPlayerConnect();

	setDvar( "ui_level_cheatpoints", level.collectibles.size ); 

	for ( i = 0; i < level.collectibles.size; i++ )
	{
		level.collectibles[i] thread collectible_wait_for_pickup();
	}
}


onPlayerConnect()
{
	if ( !( level.onlineGame && (GetDvarInt("xblive_privatematch") || !level.console) ) )
	{
		return;
	}

	for( ;; )
	{
		level waittill( "connecting", player ); 
		player thread onPlayerSpawned(); 
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" ); 

	for( ;; )
	{
		self waittill( "spawned_player" ); 

		if( IsDefined( self.player_inited ) && self.player_inited )
		{
			continue;
		}

		host_options_init();

		/#
			self thread host_options_development();
		#/
	}
}


onSaveRestored()
{
	level notify ( "collectible_save_restored" );
	level.collectible_save_restored = true;

	level.collectibles = collectible_init();

	setDvar( "ui_level_cheatpoints", level.collectibles.size ); 

	for ( i = 0; i < level.collectibles.size; i++ )
	{
		level.collectibles[i] thread collectible_wait_for_pickup();
	}
}


collectible_init()
{
	collectibles = [];
	items = 0;
	
	map_collectibles = getentarray ( "collectible", "targetname" );

	for ( i = 0; i < map_collectibles.size; i++ )
	{
		map_collectibles[i].item = getent( map_collectibles[i].target, "targetname" );
		map_collectibles[i].unlock = collectible_get_unlock( map_collectibles[i].item );

		if ( collectible_has_been_found( map_collectibles[i].unlock ) )
		{
			collectible_remove_found( map_collectibles[i] );
			continue;
		}

		collectibles[items] = map_collectibles[i];
		items++;
	}

	if ( !level.collectible_save_restored )
		RegisterClientSys( "collectibles" );

	return collectibles;
}


host_options_init()
{
	host_options = GetDvarInt( level.host_options_dvar );
	host_options_enabled = GetDvarInt( level.host_options_enabled_dvar );

	if ( !IsDefined( host_options ) || host_options == 0 || host_options_enabled == 0 || level.script == "see2" )
		return;

	keys = GetArrayKeys( level.collectible_unlocks );
	keys = array_reverse( keys );

	for ( i = 0; i < level.collectible_unlocks.size; i++ )
	{
		if ( ( host_options & (1 << i) ) != 0 )
		{
			SetCollectible( keys[i] );

			switch ( keys[i] )
			{
			case "collectible_vampire":
				self thread vampire_main();
				clientNotify( "vampire_start" );
			break;

			case "collectible_berserker":
				self thread berserker_main();
			break;

			case "collectible_sticksstones":
				self thread sticksstones_main();
			break;

			case "collectible_hardcore":
				SetDvar( "player_lastStandBleedoutTime", "15" );
			break;
			}
		}
	}
}


has_collectible( collectible_name )
{
	// MikeD (8/9/2008): Make sure the collectibles are defined... Fixes issues where an AI dies before _load is even ran.
	if( !IsDefined( level.collectible_unlocks ) )
	{
		return false;
	}

	value = collectible_get_unlock_value( collectible_name );
	return HasCollectible( value );
}


collectible_remove_found( collectible_item )
{
	collectible_item.item hide();
	collectible_item.item notsolid();

	collectible_item trigger_off();
	collectible_item delete();
}


collectible_get_unlock_value( collectible_name )
{
	assert( IsDefined( collectible_name ) );

	if ( !IsDefined( level.collectible_unlocks[ collectible_name ] ) )
	{
		assertmsg( "Unknown collectible name: '" + collectible_name + "'" );
	}
	
	collectible_value = level.collectible_unlocks[ collectible_name ];
	return collectible_value;
}


collectible_has_been_found( collectible_name )
{
	if ( IsCoopEPD() )
		return true;

	if ( coopGame() && collectible_coop_found() )
		return true;

	if ( coopGame() )
		return false;
	
	unlocks = GetDvarInt( level.collectible_dvar );
	collectible_value = collectible_get_unlock_value( collectible_name );

	return ( ( unlocks & (1 << collectible_value) ) != 0 );
}


collectible_coop_found()
{
	// returns true if this collectible has been found in a coop game, needed for checkpoint restores
	if ( level.collectible_save_restored == true && GetDvar( "coop_collectibles_found" ) == level.script )
		return true;

	return false;
}


collectible_aquire_unlock( collectible_name, player )
{
	collectible_value = collectible_get_unlock_value( collectible_name );
	SetClientSysState( "collectibles", collectible_value );

	SetDvar( "coop_collectibles_found", level.script );

	arcademode_assignpoints( "arcademode_score_generic500", player );
}


collectible_get_unlock( item )
{
	origin_string = item.origin[0] + ", " + item.origin[1] + ", " + item.origin[2];
	key = level.script + ", " + origin_string;

	unlock = TableLookup( level.collectible_table, level.collectible_table_key_col, key, level.collectible_table_unlock_col );

	if ( !IsDefined( unlock ) || unlock == "" )
	{
		assertmsg( "Add the map name and origin of this collectible item ( " + origin_string + " ) to " + level.collectible_table + " file" );
	}

	return unlock;
}

collectible_get_unlock_message( unlock )
{
	string = "";

	switch( unlock )
	{
		case "collectible_sticksstones":
			string = &"SCRIPT_COLLECTIBLE_STICKS_AND_STONES_UNLOCK";
			break;
		case "collectible_vampire":
			string = &"SCRIPT_COLLECTIBLE_VAMPIRE_UNLOCK";
			break;
		case "collectible_berserker":
			string = &"SCRIPT_COLLECTIBLE_BERSERKER_UNLOCK";
			break;
		case "collectible_zombie":
			string = &"SCRIPT_COLLECTIBLE_ZOMBIE_UNLOCK";
			break;
		case "collectible_paintball":
			string = &"SCRIPT_COLLECTIBLE_PAINTBALL_UNLOCK";
			break;
		case "collectible_dirtyharry":
			string = &"SCRIPT_COLLECTIBLE_DIRTY_HARRY_UNLOCK";
			break;
		case "collectible_morphine":
			string = &"SCRIPT_COLLECTIBLE_MORPHINE_SHOT_UNLOCK";
			break;
		case "collectible_thunder":
			string = &"SCRIPT_COLLECTIBLE_THUNDER_UNLOCK";
			break;
		case "collectible_flak_jacket":
			string = &"SCRIPT_COLLECTIBLE_FLAK_JACKET_UNLOCK";
			break;
		case "collectible_hardcore":
			string = &"SCRIPT_COLLECTIBLE_HARDCORE_UNLOCK";
			break;
		case "collectible_body_armor":
			string = &"SCRIPT_COLLECTIBLE_BODY_ARMOR_UNLOCK";
			break;
		case "collectible_hard_headed":
			string = &"SCRIPT_COLLECTIBLE_HARD_HEADED_UNLOCK";
			break;
		case "collectible_dead_hands":
			string = &"SCRIPT_COLLECTIBLE_COLD_DEAD_HANDS_UNLOCK";
			break;
		default: 
			assertmsg( "Collectible not found " + unlock );
	}
	return string;
}


collectible_wait_for_pickup()
{
	level endon ( "collectible_save_restored" );
	
	self setHintString ( &"SCRIPT_COLLECTIBLE_PICKUP" );
	self usetriggerrequirelookat();

	self waittill( "trigger", player );

	// this dvar is set in the client script
	if ( collectible_has_been_found( self.unlock ) )
	{
		num_found = GetDvarInt( "cheat_points" );
	}
	else
	{
		num_found = GetDvarInt( "cheat_points" ) + 1;
	}
	
	if ( num_found > level.collectible_unlocks.size )
	{
		num_found = level.collectible_unlocks.size;
	}
	
	collectible_aquire_unlock( self.unlock, player );
	collectible_remove_found( self );

	player thread collectibleNotify( self.Unlock, num_found );

	if ( CoopGame() )
	{
		// sends the message to all players who picked up the collectible
		CoopInfo( "msgcoop_collectible", player );
	}
}

collectibleNotify( Unlock, num_found )
{
	message = collectible_get_unlock_message( unlock );

	notifyData = spawnStruct();
	notifyData.notifyText = num_found;
	notifyData.textLabel = &"SCRIPT_COLLECTIBLE_OF_THIRTEEN";
	notifyData.notifyText2 = message;
	notifyData.sound = undefined;

	if ( !GetDvarInt( level.collectible_dvar ) )
		notifyData.notifyText3 = &"SCRIPT_COLLECTIBLE_USAGE";

	if ( CoopGame() )
	{
		notifyData.notifyText = undefined;
		notifyData.textLabel = undefined;
	}

	self maps\_hud_message::notifyMessage( notifyData );
}


// used to enable host options "on the fly" while playing the level
host_options_development()
{
/#
	self endon( "disconnect" ); 
	self endon( "death" );

	keys = GetArrayKeys( level.collectible_unlocks );
	keys = array_reverse( keys );

	self.running_collectibles = [];

	for ( ;; )
	{
		wait ( 1.0 );
		
		host_options = GetDvarInt( level.host_options_dvar );

		for ( i = 0; i < level.collectible_unlocks.size; i++ )
		{
			// assume if it's in the host options it's already running
			if ( ( host_options & (1 << i) ) != 0 )
				continue;

			if ( HasCollectible( i ) && !IsDefined( self.running_collectibles[i] ) )
			{
				self.running_collectibles[i] = keys[i];
				iprintln( "Collectible Enabled: " + keys[i] );

				switch ( keys[i] )
				{
				case "collectible_vampire":
					self thread vampire_main();
					clientNotify( "vampire_start" );
				break;

				case "collectible_berserker":
					self thread berserker_main( true );
				break;

				case "collectible_sticksstones":
					self thread sticksstones_main();
				break;
				}
			}
			else if ( !HasCollectible( i ) && IsDefined( self.running_collectibles[i] ) )
			{
				self.running_collectibles[i] = undefined;
				iprintln( "Collectible Disabled: " + keys[i] );

				switch ( keys[i] )
				{
				case "collectible_vampire":
					self notify( "vampire_end" );
				break;

				case "collectible_berserker":
					self notify( "berserker_end" );
				break;

				case "collectible_sticksstones":
					self notify( "sticksstones_end" );
				break;
				}
			}
		}
	}
#/
}