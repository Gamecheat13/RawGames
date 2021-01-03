#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

#using scripts\shared\stealth;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_tagging;
#using scripts\shared\stealth_vo;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_player;

/*
	STEALTH - Player
*/

/@
"Name: init()"
"Summary: Initialize stealth on a Player
"Module: Stealth"
"CallOn: A Player entity"
"Example: player stealth_player::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isPlayer( self ) );
	assert( !isDefined( self.stealth ) );

	if(!isdefined(self.stealth))self.stealth=SpawnStruct();
	
	self.stealth.player_detected = false;
	self.stealth.player_detect_count = 0;
	
	self thread stance_monitor_thread();
	self thread detected_monitor_thread();

	self stealth_tagging::init();
	self stealth_vo::init();
	
	/# self stealth_debug::init_debug( ); #/

	self thread ignore_me_on_spawn();
		
	// FIXME : Prototype directional indicators
	self thread detection_thread();
}

/@
"Name: stop()"
"Summary: Terminates stealth on this object
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_player::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
	// FIXME : Prototype directional indicators
	self clientfield::set_to_player( "stealth_sight_ent_01", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_02", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_03", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_04", 127 );
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( player stealth_player::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.player_detected );
}

/@
"Name: inc_detected( <detector>, <alertValue> )"
"Summary: Notifies player he has been detected"
"Module: Stealth"
"CallOn: Player"
"Example: player stealth_player::inc_detected( );"
"SPMP: singleplayer"
@/
function inc_detected( detector, alertValue )
{
	self.stealth.player_detect_count++;
}

function inc_aware( detector, alertValue )
{
	// ==================================================================	
	// FIXME : Prototype directional indicators
	if ( !isDefined( self.stealth.sensing ) )
		self.stealth.sensing = [];
	
	// Replace the one that is furthest away if i am closer
	furthestSq = 0.0;
	replace = -1;
	for ( i = 0; i < self.stealth.sensing.size; i++ )
	{
		value = self detection_value( self.stealth.sensing[i] );

		if ( value == 127 || !isDefined( self.stealth.sensing[i] ) || self.stealth.sensing[i] == detector )
		{
			self.stealth.sensing[i] = detector;
			return;
		}

		distSq = DistanceSquared( self.stealth.sensing[i].origin, self.origin );
		if ( distSq > furthestSq )
		{
			furthestSq = distSq;
			replace = i;
		}
	}

	if ( self.stealth.sensing.size < 4 )
	{
		// add a new one
		self.stealth.sensing[self.stealth.sensing.size] = detector;
		return;
	}

	// replace the furthest one	
	distSq = DistanceSquared( detector.origin, self.origin );
	if ( distSq < furthestSq )
		self.stealth.sensing[replace] = detector;
	// ==================================================================	
}

// FIXME : Prototype directional indicators
function detection_thread()
{
	self endon("disconnect");
	self endon("stop_stealth");

	self.stealth.sensing = [];
	
	// Wait a frame to allow player to get fully initialize first
	// Without this you would sometimes get an error calling clientfield::set_to_player()
	// "GScr_CodeSetPlayerStateClientField: must be called on a player"
	{wait(.05);};

	self clientfield::set_to_player( "stealth_sight_ent_01", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_02", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_03", 127 );
	self clientfield::set_to_player( "stealth_sight_ent_04", 127 );
	
	while ( 1 )
	{
		for ( i = 0; i < 4; i++ )
		{
			value = self detection_value( self.stealth.sensing[i] );
			if ( value > 0 && value != 127 )
			{
				self clientfield::set_to_player( "stealth_sight_ent_0" + (i + 1), self.stealth.sensing[i] GetEntityNumber() );
				self clientfield::set_to_player( "stealth_sight_lvl_0" + (i + 1), value );
			}
			else
			{
				self clientfield::set_to_player( "stealth_sight_ent_0" + (i + 1), 127 );
			}
		}
		
		{wait(.05);};
	}
}

// FIXME : Prototype directional indicators
function detection_value( other ) // self = player
{
	if ( !isDefined( other ) )
		return 127; // undefined
	
	if ( GetDvarInt("stealth_display", 1) == 1 && isAlive( other ) && !other.ignoreall )
	{
		// HACK
		// 50 and 100 are reserved for combat when not in sight (the former) and in sight (the latter)
		// 0 - 49 and 51 to 99 are for various stages of alertness when not in sight (the former) and in sight (the latter)
		value = other GetStealthSightValue(self) * 49;
		bCanSee = other stealth::can_see( self );
		bCombat = isDefined( other.stealth.aware_combat ) && isDefined( other.stealth.aware_combat[self GetEntityNumber()] );
		bAlert = isDefined( other.stealth.aware_alerted ) && isDefined( other.stealth.aware_alerted[self GetEntityNumber()] );
		if ( value > 0 || bAlert || bCombat )
		{
			if ( bCombat )
				value = 50;
			else if ( bAlert )
				value = 49;
			if ( bCanSee || bCombat )
				value += 50;
			return int( value );
		}
	}
	
	return 127; // undefined
}


/@
"Name: set_detected( <detected> )"
"Summary: Sets if this player is detected or not"
"Module: Stealth"
"CallOn: Player"
"Example: player stealth_player::set_detected( true );"
"SPMP: singleplayer"
@/
function set_detected( detected )
{
	self.stealth.player_detected = detected;
}

/@
"Name: get_detected(  )"
"Summary: Gets if this player is detected or not"
"Module: Stealth"
"CallOn: Player"
"Example: player stealth_player::get_detected( );"
"SPMP: singleplayer"
@/
function get_detected( )
{
	if ( !self stealth_player::enabled() )
		return false;
	
	return self.stealth.player_detected;
}

function stance_monitor_thread()
{
	self endon("disconnect");
	self endon("stop_stealth");

	while ( 1 )
	{
		stance = self GetStance();
		
		maxVisibleDist = 8192;
		
		switch ( stance )
		{
			case "crouch":
				maxVisibleDist = 800;
				break;
			case "prone":
				maxVisibleDist = 400;
				break;
		}
		
		// FIXME: handle shadow volumes
		// if ( self Touching( shadowVolume ) )
		// maxVisibleDist *= 0.75;
		    
		self.maxvisibledist = maxVisibleDist;
		
		wait 0.25;
	}
}

function detected_monitor_thread()
{
	self endon("disconnect");
	self endon("stop_stealth");
	
	while ( 1 )
	{
		self.stealth.player_detect_count = 0;
		
		wait 1.0;

		if ( self.stealth.player_detect_count <= 0 )
			self stealth_player::set_detected( false );
	}
}

/@
"Name: ignore_me_on_spawn()"
"Summary: Makes this player ignored by all potential enemies after the player spawns
"Module: Stealth"
"CallOn: A Player entity"
"Example: player thread stealth_player::ignore_me_on_spawn();"
"SPMP: singleplayer"
@/
function ignore_me_on_spawn()
{
	self endon("disconnect");
	self endon("stop_stealth");
	
	{wait(.05);};
	self set_ignore_me_one_to_one( true );
	
	while ( 1 )
	{
		self util::waittill_any( "spawned" );
		{wait(.05);};
		self set_ignore_me_one_to_one( true );
	}
}

/@
"Name: set_ignore_me_one_to_one( <ignore> )"
"Summary: Makes this player ignored by all potential enemies
"Module: Stealth"
"CallOn: A Player entity"
"Example: player stealth_player::set_ignore_me_one_to_one( true );"
"SPMP: singleplayer"
@/
function set_ignore_me_one_to_one( ignore )
{
	foreach ( enemy in level.stealth.enemies[self.team] )
	{
		if ( !isDefined( enemy ) )
			continue;
		
		if ( enemy stealth_aware::enabled() )
			enemy stealth_aware::set_ignore_sentient( self, ignore );
	}
}

/@
"Name: update_audio( <bCanSee>, <bCombat> )"
"Summary: Updates feedback audio for stealth detection"
"Module: stealth"
"CallOn: Player"
"MandatoryArg: <bCanSee>: if currently visible to an enemy"
"MandatoryArg: <awareness>: the awareness level of the enemy"
"Example: player stealth_player::update_audio( can_see_array[index], AI_AWARENESS_COMBAT );"
@/
function update_audio( bCanSee, awareness )
{
	// No audio if disabled
	if ( GetDvarInt( "stealth_audio", 1 ) == 0 )
		return;
	
	bCombat = awareness == "combat";
	
	if ( !self stealth_player::enabled() )
		return;
	
	if ( !( isdefined( self.stealth.player_detected ) && self.stealth.player_detected ) )
	{				
		// Audio SightING indication
		if ( !bCombat )
		{
			if ( bCanSee )
				self thread sighting_thread( awareness );
			
			if ( awareness == "high_alert" )
				self thread alerted_thread();
		}
	
		// Audio SightED indication
		if ( bCombat )
		{
			self.stealth.player_detected = true;
			self thread stealth_broken_sound();
		}
	}	
	else if ( awareness == "high_alert" )
	{
		self thread alerted_thread();
	}
}

function sighting_thread( awareness )
{
	self notify("sighting_thread");
	self endon("sighting_thread");
	
	self endon("disconnect");
	self endon("death");

	sighting_field = 1;
	if ( awareness == "high_alert" )
		sighting_field = 2;
	
	self clientfield::set_to_player( "stealth_sighting", sighting_field );
	
	// Automatically turns off if its not refreshed again within 0.15 seconds
	wait 0.15;	
	self clientfield::set_to_player( "stealth_sighting", 0 );
}

function alerted_thread()
{
	self notify("alerted_thread");
	self endon("alerted_thread");
	
	self endon("disconnect");
	self endon("death");
	
	self clientfield::set_to_player( "stealth_alerted", 1 );
	
	// Automatically turns off if its not refreshed again within 0.15 seconds
	wait 0.15;	
	self clientfield::set_to_player( "stealth_alerted", 0 );
}

function stealth_broken_sound() // self = player
{
	self playsoundtoplayer( "uin_stealth_broken", self );
	
	/* commented out as it was deemed too confusing
	
	foreach ( player in GetPlayers() )
	{
		if ( player != self && !IS_TRUE( player.stealth.player_detected ) )
			player playsoundtoplayer( "uin_stealth_broken_ally", player );
	}
	*/
}
