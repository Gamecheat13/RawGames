#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

#insert raw\maps\_utility.gsh;
//
main()
{
	flag_wait( "level.player" );
	
	// starting number for the collectible index
	n_intel_index = level.player get_temp_stat( TEMP_STAT_INTEL_INDEX );
  	a_collectibles = GetEntArray ( "collectible", "targetname" );
  
  	//thread the challenge to pick up intel if an intel was found in the level
  	if( a_collectibles.size > 0 )
  	{
  		level.player thread maps\_challenges_sp::register_challenge( "locateintel", ::collectibles_level_challenge );
  	}
		
	level.collectibles = collectible_init( a_collectibles, n_intel_index );

	for ( i = 0; i < level.collectibles.size; i++ )
	{
		level.collectibles[i] thread collectible_wait_for_pickup();
	}
	
	OnSaveRestored_Callback(::collectibles_level_restore);

	//level is ending update the collectible index for the next level	
	level waittill( "nextmission" );
	level.player set_temp_stat( TEMP_STAT_INTEL_INDEX, a_collectibles.size + n_intel_index );
}

//self is the player
collectibles_level_challenge( str_notify )
{
	while( 1 )
	{
		//notify sent to the player whenever an intel is collected
		self waittill( "check_challenge" );
		
		//check to see if all 3 have been collected for that mission
		if( IS_TRUE( collected_all() ) )
		{
			self notify( str_notify );
			return;
		}			
	}
}

//
//	Needed for level restores because collectible data is saved separate from map data.
collectibles_level_restore()
{
	// We're getting these again.  They should already have parameters set on them from the init.
	map_collectibles = getentarray ( "collectible", "targetname" );
	for ( i = 0; i < map_collectibles.size; i++ )
	{
		if ( HasCollectible( int( map_collectibles[i].script_parameters ) ) )
		{
			collectible_remove_found( map_collectibles[i] );
			continue;
		}
	}
}


//
//	Search through the map and assign numbers to collectibles based on the map name.
//	Remove ones we've already collected
collectible_init( map_collectibles, n_intel_index )
{
	collectibles = [];
	items = 0;
	const radius = 64;
	start_num = 1 + n_intel_index;
      	
	// Assign the index and remove ones we've already picked up.
	for ( i = 0; i < map_collectibles.size; i++ )
	{
		map_collectibles[i].script_parameters = start_num + i;
		if ( HasCollectible( int( map_collectibles[i].script_parameters ) ) )
		{
			collectible_remove_found( map_collectibles[i] );
			continue;
		}
		map_collectibles[i].trigger = Spawn( "trigger_radius", map_collectibles[i].origin, 0, radius, radius );
		map_collectibles[i].trigger setHintString ( "" );
		map_collectibles[i].trigger setCursorHint( "HINT_NOICON" );

		assert( IsDefined( map_collectibles[i].trigger ), "ERROR: _collectibles: Unable to create collectible trigger" );
		collectibles[items] = map_collectibles[i];
		items++;
	}
	
	return collectibles;
}


//
//	Delete the collectible once it's picked up.
collectible_remove_found( collectible_item )
{
	if ( IsDefined( collectible_item.trigger ) )
	{
		collectible_item.trigger Delete();
	}
	if ( IsDefined( collectible_item.target ) )
	{
		m_stand = GetEnt( collectible_item.target, "targetname" );
		m_stand Delete();
	}
	collectible_item Delete();
}


//
//	Wait until the player presses use while looking at the trigger.
collectible_wait_for_pickup()
{
	level endon ( "collectible_save_restored" );

	while (1)
	{
		self.trigger waittill( "trigger", player );

		player_is_looking_at = player is_player_looking_at( self.origin, 0.9, false );
		if ( player_is_looking_at )
		{
			self.trigger setHintString ( &"SCRIPT_COLLECTIBLE_PICKUP" );
		}
		else
		{
			self.trigger setHintString ( "" );
		}

		if ( IsAlive( player) &&
			 player_is_looking_at &&
			 player Use_button_held() )
			 
		{
			playsoundatposition ("uin_aar_unlock_loud", (0,0,0));			
			break;
		}

		wait( 0.05 );

		if ( !player IsTouching( self.trigger ) )
		{
			self.trigger setHintString ( "" );
		}
	}

	SetCollectible( int( self.script_parameters ) );

	player thread collectibleNotify( self.Unlock );
	player notify( "check_challenge" );
	
	collectible_remove_found( self );	
}

//	InfoMessage
//	TODO: Need to find out how many have been found and report that in the secondary message.
collectibleNotify( Unlock, num_found )
{
	notifyData = spawnStruct();
	notifyData.notifyText = &"SCRIPT_COLLECTIBLE";
//	notifyData.notifyText2 = &"SCRIPT_FOUNDCOLLECTIBLE";
	notifyData.sound = undefined;

	self maps\_hud_message::notifyMessage( notifyData );
}
