#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicledamage" );
main()
{
	if ( getdvar( "debug_destructibles" ) == "" )
		setdvar( "debug_destructibles", "0" );
	
	if ( getdvar( "destructibles_enable_physics" ) == "" )
		setdvar( "destructibles_enable_physics", "1" );
	
	find_destructibles();
}

destructible_create( type, health, validAttackers )
{
	//---------------------------------------------------------------------
	// Creates a new information structure for a destructible object
	//---------------------------------------------------------------------
	assert( isdefined( type ) );
	
	if( !isdefined( level.destructible_type ) )
		level.destructible_type = [];
	
	destructibleIndex = level.destructible_type.size;
	
	destructibleIndex = level.destructible_type.size;
	level.destructible_type[ destructibleIndex ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].v[ "type" ] = type;
	
	level.destructible_type[ destructibleIndex ].parts = [];
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "modelName" ] = self.model;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "health" ] = health;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "validAttackers" ] = validAttackers;
}

destructible_part( tagName, modelName, health, validAttackers )
{
	//---------------------------------------------------------------------
	// Adds a part to the last created destructible information structure
	// This part will be created and attached to the specified bone on load
	//---------------------------------------------------------------------
	destructibleIndex = ( level.destructible_type.size - 1 );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts.size ) );
	
	partIndex = level.destructible_type[ destructibleIndex ].parts.size;
	assert( partIndex > 0 );
	
	stateIndex = 0;
	
	destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers );
}

destructible_state( tagName, modelName, health, validAttackers )
{
	//---------------------------------------------------------------------
	// Adds a new part that is a state of the last created part
	// When the previous part reaches zero health this part will show up
	// and the previous part will be removed
	//---------------------------------------------------------------------
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size );
	
	destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers );
}

destructible_fx( tagName, fxName )
{
	assert( isdefined( tagName ) );
	assert( isdefined( fxName ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "fx_filename" ] = fxName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "fx_tag" ] = tagName;
}

destructible_loopfx( tagName, fxName, loopRate )
{
	assert( isdefined( tagName ) );
	assert( isdefined( fxName ) );
	assert( isdefined( loopRate ) );
	assert( loopRate > 0 );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_filename" ] = fxName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_tag" ] = tagName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_rate" ] = loopRate;
}

destructible_healthdrain( amount, interval )
{
	assert( isdefined( amount ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "healthdrain_amount" ] = amount;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "healthdrain_interval" ] = interval;
}

destructible_sound( soundAlias )
{
	assert( isdefined( soundAlias ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	if ( !isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ] ) )
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ] = [];
	
	index = level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ].size;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ][ index ] = soundAlias;
}

destructible_loopsound( soundAlias )
{
	assert( isdefined( soundAlias ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	if ( !isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ] ) )
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ] = [];
	
	index = level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ].size;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ][ index ] = soundAlias;
}

destructible_anim( animName, animTree, animType )
{
	assert( isdefined( anim ) );
	assert( isdefined( animtree ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "anim" ] = animName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "animTree" ] = animtree;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "animType" ] = animType;
}

destructible_physics()
{
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "physics" ] = true;
}

destructible_explode( force_min, force_max, range, mindamage, maxdamage )
{
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_force_min" ] = force_min;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_force_max" ] = force_max;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_range" ] = range;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_mindamage" ] = mindamage;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_maxdamage" ] = maxdamage;
}

destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers )
{
	assert( isdefined( partIndex ) );
	assert( isdefined( stateIndex ) );
	assert( isdefined( level.destructible_type ) );
	assert( level.destructible_type.size > 0 );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "modelName" ] = modelName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "tagName" ] = tagName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "health" ] = health;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "validAttackers" ] = validAttackers;
}

find_destructibles()
{
	//---------------------------------------------------------------------
	// Find all destructibles by their targetnames and run the setup
	//---------------------------------------------------------------------
	array_thread( getentarray( "destructible", "targetname" ), ::setup_destructibles );
}

setup_destructibles()
{
	//---------------------------------------------------------------------
	// Figure out what destructible information this entity should use
	//---------------------------------------------------------------------
	destuctableInfo = undefined;
	assertEx( isdefined( self.destructible_type ), "Destructible object with targetname 'destructible' does not have a 'destructible_type' key/value" );
	
	self.destuctableInfo = maps\_destructible_types::makeType( self.destructible_type );
	println( "### DESTRUCTIBLE ### assigned infotype index: " + self.destuctableInfo );
	assert( self.destuctableInfo >= 0 );
	
	//---------------------------------------------------------------------
	// Precache referenced models and load referenced effects
	//---------------------------------------------------------------------
	if ( isdefined( level.destructible_type[self.destuctableInfo].parts ) )
	{
		for( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			for( j = 0 ; j < level.destructible_type[ self.destuctableInfo ].parts[ i ].size ; j++ )
			{
				if( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= j )
					continue;
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] ) )
					precacheModel( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] );
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx_filename" ] ) )
					level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx" ] = loadfx( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx_filename" ] );
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx_filename" ] ) )
					level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx" ] = loadfx( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx_filename" ] );
			}
		}
	}
	
	//---------------------------------------------------------------------
	// Attach all parts to the entity
	//---------------------------------------------------------------------
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts ) )
	{
		self.destructible_parts = [];
		for( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			// create the struct where the info for each entity will be held
			self.destructible_parts[ i ] = spawnStruct();
			
			// set it's current state to 0 since it has never taken damage yet and will be on it's first state
			self.destructible_parts[ i ].v[ "currentState" ] = 0;
			
			// if it has a health value then store it's value
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "health" ] ) )
				self.destructible_parts[ i ].v[ "health" ] = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "health" ];
			
			// continue if it's the base model since its not an attached part
			if ( i == 0 )
				continue;
			
			// attach the part now
			modelName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "modelName" ];
			tagName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "tagName" ];
			self attach( modelName, tagName );
		}
	}
	
	//---------------------------------------------------------------------
	// Make this entity take damage and wait for events
	//---------------------------------------------------------------------
	self setCanDamage( true );
	self thread destructible_think();
}

destructible_think()
{	
	//---------------------------------------------------------------------
	// Wait until this entity takes damage
	//---------------------------------------------------------------------
	self endon( "stop_taking_damage" );
	for(;;)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		
		if ( !isdefined( damage ) )
			continue;
		if ( damage <= 0 )
			continue;
		
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			print3d( point, ".", ( 1, 1, 1 ), 1.0, 0.5, 100 );
			iprintln( "damage amount: " + damage );
			iprintln( "hit model: " + modelName );
			if ( isdefined( tagName ) )
				iprintln( "hit model tag: " + tagName );
			else
				iprintln( "hit model tag: " );
		}
		
		// override for when base model is damaged. We dont want to pass in empty strings
		assert( isdefined( modelName ) );
		if ( modelName == "" )
		{
			assert( isdefined( self.model ) );
			modelName = self.model;
		}
		if ( isdefined( tagName ) && tagName == "" )
		{
			tagName = undefined;
		}
		
		// special handling for splash and projectile damage
		if ( isdefined( type ) )
		{
			if ( ( issubstr( tolower( type ), "splash" ) ) || ( issubstr( tolower( type ), "grenade" ) ) || ( issubstr( tolower( type ), "projectile" ) ) || ( issubstr( tolower( type ), "explosive" ) ) )
			{
				if ( getdvar( "debug_destructibles" ) == "1" )
					iprintln( "type = splash" );
				
				self destructible_splash_damage( int( damage ), point, direction_vec, attacker );
				continue;
			}
		}
		
		self destructible_update_part( int( damage ), modelName, tagName, point, direction_vec, attacker );
	}
}

destructible_update_part( damage, modelName, tagName, point, direction_vec, attacker )
{
	//---------------------------------------------------------------------
	// Find what part this is, or is a child of. If the base model was
	// the entity that was damaged the part index will be -1
	//---------------------------------------------------------------------
	if ( !isdefined( self.destructible_parts ) )
		return;
	if ( self.destructible_parts.size == 0 )
		return;
	
	partIndex = -1;
	stateIndex = -1;
	assert( isdefined( self.model ) );
	if ( ( tolower( modelName ) == tolower( self.model ) ) && ( !isdefined( tagName ) ) )
	{
		modelName = self.model;
		tagName = undefined;
		partIndex = 0;
		stateIndex = 0;
	}
	
	for( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
	{
		stateIndex = self.destructible_parts[ i ].v[ "currentState" ];
		
		if( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= stateIndex )
			continue;
		
		if( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "modelName" ] ) )
			continue;
		
		if ( tolower( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "modelName" ] ) == tolower( modelName ) )
		{
			if ( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "tagName" ] == tagName )
			{
				partIndex = i;
				break;
			}
		}
	}
	assert( stateIndex >= 0 );
	
	if ( partIndex < 0 )
		return;
	
	//---------------------------------------------------------------------
	// Deduct the damage amount from the part's health
	// If the part runs out of health go to the next state
	//---------------------------------------------------------------------
	state_before = stateIndex;
	updateHealthValue = false;
	delayModelSwap = false;
	for(;;)
	{
		stateIndex = self.destructible_parts[ partIndex ].v[ "currentState" ];
		
		// there isn't another state to go to when damaged
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ] ) )
			break;
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "health" ] ) )
			break;
		if ( !isdefined( self.destructible_parts[ partIndex ].v[ "health" ] ) )
			break;
		
		if ( updateHealthValue )
			self.destructible_parts[ partIndex ].v[ "health" ] = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "health" ];
		updateHealthValue = false;
		
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			iprintln( "stateindex: " + stateIndex );
			iprintln( "damage: " + damage );
			iprintln( "health (before): " + self.destructible_parts[ partIndex ].v[ "health" ] );
		}
		
		// apply the damage to the part if the attacker was a valid attacker
		validAttacker = self isAttackerValid( partIndex, stateIndex, attacker );
		if ( validAttacker )
			self.destructible_parts[ partIndex ].v[ "health" ] -= damage;
		
		if ( getdvar( "debug_destructibles" ) == "1" )
			iprintln( "health (after): " + self.destructible_parts[ partIndex ].v[ "health" ] );
		
		// if the part still has health left then we're done
		if ( self.destructible_parts[ partIndex ].v[ "health" ] > 0 )
			return;
		
		// if the part ran out of health then carry over to the next part
		damage = int( abs( self.destructible_parts[ partIndex ].v[ "health" ] ) );
		if ( damage < 0 )
			return;
		self.destructible_parts[ partIndex ].v[ "currentState" ]++;
		stateIndex = self.destructible_parts[ partIndex ].v[ "currentState" ];
		actionStateIndex = ( stateIndex - 1 );
		
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ] ) )
			return;
		
		//---------------------------------------------------------------------
		// A state change is required so detach the old model or replace it if 
		// it's the base model that took the damage.
		// Then attach the model ( if specified ) used for the new state
		// Only do this if there is another state to go to, some parts might have
		// fx or anims, or sounds but no next model to go to
		//---------------------------------------------------------------------
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ] ) )
		{
			if ( partIndex == 0 )
			{
				newModel = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ];
				self setmodel( newModel );
			}
			else
			{
				// handle a part getting damaged here - must be detached and reattached
				self detach( modelName, tagName );
				modelName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ];
				tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "tagName" ];
			
				if ( isdefined( modelName ) && isdefined( tagName ) )
					self attach( modelName, tagName );
			}
		}
		
		// if the part has an fx then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx" ] ) )
		{
			assert( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx_tag" ] ) );
			fx = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx" ];
			fx_tag = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx_tag" ];
			self notify( "FX_State_Change" + partIndex );
			playfxontag ( fx, self, fx_tag );
		}
		
		// if the part has a looping fx then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx" ] ) )
		{
			assert( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_tag" ] ) );
			loopfx = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx" ];
			loopfx_tag = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_tag" ];
			loopRate = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_rate" ];
			self notify( "FX_State_Change" + partIndex );
			self thread loopfx_onTag( loopfx, loopfx_tag, loopRate, partIndex );
		}
		
		// if the part has an anim then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "anim" ] ) )
		{
			animName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "anim" ];
			animTree = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "animTree" ];
			self useanimtree( animTree );
			animType = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "animType" ];
			if ( animType == "setanim" )
				self setAnim( animName, 1.0, 1.0, 1.0 );
			else if ( animType == "setanimknob" )
				self setAnimKnob( animName, 1.0, 1.0, 1.0 );
			else
				assertMsg( "Tried to play an animation on a destructible with an invalid animType: " + animType );
		}
		
		// if the part has a soundalias then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ] ) )
		{
			for( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ].size ; i++ )
			{
				soundAlias = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ][ i ];
				soundTagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "tagName" ];
				self thread play_sound_on_tag( soundAlias, soundTagName );
			}
		}
		
		// if the part should drain health then start the drain
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_amount" ] ) )
		{
			self notify( "Health_Drain_State_Change" + partIndex );
			healthdrain_amount = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_amount" ];
			healthdrain_interval = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_interval" ];
			healthdrain_modelName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "modelName" ];
			healthdrain_tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "tagName" ];
			if ( healthdrain_amount > 0 )
			{
				assert( ( isdefined( healthdrain_interval ) ) && ( healthdrain_interval > 0 ) );
				self thread health_drain( healthdrain_amount, healthdrain_interval, partIndex, healthdrain_modelName, healthdrain_tagName );
			}
		}
		
		// if the part is meant to explode on this state then do it now. Causes all attached models to become physics with the specified force
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_min" ] ) )
		{
			delayModelSwap = true;
			force_min = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_min" ];
			force_max = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_max" ];
			range = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_range" ];
			mindamage = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_mindamage" ];
			maxdamage = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_maxdamage" ];
			self thread explode( partIndex, force_min, force_max, range, mindamage, maxdamage );
		}
		
		// if the part should do physics here then initiate the physics and velocity
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "physics" ] ) )
		{
			initial_velocity = point;
			impactDir = ( 0, 0, 0 );
			if ( isdefined( attacker ) )
			{
				impactDir = attacker.origin;
				if ( attacker == level.player )
					impactDir = level.player getEye();
				initial_velocity = vectorNormalize( point - impactDir);
				initial_velocity = vectorScale( initial_velocity, 200 );
			}
			self thread physics_launch( partIndex, actionStateIndex, point, initial_velocity );
			return;
		}
		
		updateHealthValue = true;
	}
}

destructible_splash_damage( damage, point, direction_vec, attacker )
{
	if ( damage <= 0 )
		return;
	
	//------------------------------------------------------------------------
	// Fill an array of all possible parts that might have been splash damaged
	//------------------------------------------------------------------------
	damagedParts = [];
	closestPartDist = undefined;
	if ( isdefined( level.destructible_type[self.destuctableInfo].parts ) )
	{
		for( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			for( j = 0 ; j < level.destructible_type[ self.destuctableInfo ].parts[ i ].size ; j++ )
			{
				if( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= j )
					continue;
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] ) )
				{
					// see how far the part is from the splash damage origin
					modelName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ];
					assert( isdefined( modelName ) );
					
					// special handling for the base model which doesn't use a tag
					if ( i == 0 )
					{
						d = distance( point, self.origin );
						tagName = undefined;
					}
					else
					{
						tagName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "tagName" ];
						assert( isdefined( tagName ) );
						d = distance( point, self getTagOrigin( tagName ) );
					}
					
					if ( ( !isdefined( closestPartDist ) ) || ( d < closestPartDist ) )
						closestPartDist = d;
					
					// add the part to the list of parts to be damaged
					index = damagedParts.size;
					damagedParts[ index ] = spawnStruct();
					damagedParts[ index ].v[ "modelName" ] = modelName;
					damagedParts[ index ].v[ "tagName" ] = tagName;
					damagedParts[ index ].v[ "distance" ] = d;
				}
			}
		}
	}
	if ( !isdefined( closestPartDist ) )
		return;
	if ( closestPartDist < 0 )
		return;
	if ( damagedParts.size <= 0 )
		return;
	
	//--------------------------------------------------------------------------
	// Damage each part depending on how close it was to the splash damage point
	//--------------------------------------------------------------------------
	for( i = 0 ; i < damagedParts.size ; i++ )
	{
		distanceMod = ( damagedParts[ i ].v[ "distance" ] * 1.4 );
		damageAmount = ( damage - ( distanceMod - closestPartDist ) );
		
		if ( damageAmount <= 0 )
			continue;
		
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			if ( isdefined( damagedParts[ i ].v[ "tagName" ] ) )
				print3d( self getTagOrigin( damagedParts[ i ].v[ "tagName" ] ), damageAmount, ( 1, 1, 1 ), 1.0, 0.5, 200 );				
		}
		
		self thread destructible_update_part( damageAmount, damagedParts[ i ].v[ "modelName" ], damagedParts[ i ].v[ "tagName" ], point, direction_vec, self);
	}
}

isAttackerValid( partIndex, stateIndex, attacker )
{
	if ( !isdefined( attacker ) )
		return true;
	
	sType = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "validAttackers" ];
	if ( !isdefined( sType ) )
		return true;
	
	if ( sType == "no_player" )
	{
		if ( attacker != level.player )
			return true;
	}
	else
	if ( sType == "player_only" )
	{
		if ( attacker == level.player )
			return true;
	}
	else
	if ( sType == "no_ai" )
	{
		if ( !isAI( attacker ) )
			return true;
	}
	else
	if ( sType == "ai_only" )
	{
		if ( isAI( attacker ) )
			return true;
	}
	else
	{
		assertMsg( "Invalid attacker rules on destructible vehicle. Valid types are: ai_only, no_ai, player_only, no_player" );
	}
	
	return false;
}

loopfx_onTag( loopfx, loopfx_tag, loopRate, partIndex )
{
	self endon( "FX_State_Change" + partIndex );
	for(;;)
	{
		playfxontag( loopfx, self, loopfx_tag );
		wait loopRate;
	}
}

health_drain( amount, interval, partIndex, modelName, tagName )
{
	self endon( "Health_Drain_State_Change" + partIndex );
	wait interval;
	while( self.destructible_parts[ partIndex ].v[ "health" ] > 0 )
	{
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			iprintln( "health before damage: " + self.destructible_parts[ partIndex ].v[ "health" ] );
			iprintln( "doing " + amount + " damage" );
		}
		self notify( "damage", amount, undefined, ( 0, 0, 0 ) , ( 0, 0, 0 ), "MOD_BULLET", modelName, tagName );
		wait interval;
	}
}

physics_launch( partIndex, stateIndex, point, initial_velocity )
{	
	modelName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ];
	tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "tagName" ];
	
	// Make sure this part is still attached to the base model
	if ( !isModelAttached( modelName, tagName ) )
		return;
	
	// Detach the part
	self detach( modelName, tagName );
	
	if ( getdvar( "destructibles_enable_physics" ) == "0" )
		return;
	
	// Spawn a model to use for physics using the modelname and position of the part
	physicsObject = spawn( "script_model", self getTagOrigin( tagName ) );
	physicsObject.angles = self getTagAngles( tagName );
	physicsObject setModel( modelName );
	
	physicsObject physicsLaunch( point, initial_velocity );
}

explode( partIndex, force_min, force_max, range, mindamage, maxdamage )
{
	// for now make all attached models come off
	// chad - todo: make it so only specified parts will come off,
	//				maybe some command per part that makes a child
	assert( isdefined( force_min ) );
	assert( isdefined( force_max ) );
	wait 0.05;
	
	tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ self.destructible_parts[ partIndex ].v[ "currentState" ] ].v[ "tagName" ];
	if ( isdefined( tagName ) )
		explosionOrigin = self getTagOrigin( tagName );
	else
		explosionOrigin = self.origin;
	
	self notify( "damage", maxdamage, self, ( 0, 0, 0 ), explosionOrigin, "MOD_EXPLOSIVE", "", "" );
	
	waittillframeend;
	
	if ( isdefined( level.destructible_type[self.destuctableInfo].parts ) )
	{
		for( i = ( level.destructible_type[ self.destuctableInfo ].parts.size - 1 ) ; i >= 0  ; i-- )
		{
			if ( i == partIndex )
				continue;
			
			stateIndex = self.destructible_parts[ i ].v[ "currentState" ];
			if ( stateIndex >= level.destructible_type[ self.destuctableInfo ].parts[ i ].size )
				stateIndex = level.destructible_type[ self.destuctableInfo ].parts[ i ].size - 1;
			modelName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "modelName" ];
			tagName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "tagName" ];
			
			if ( !isdefined( modelName ) )
				continue;
			if ( !isdefined( tagName ) )
				continue;
			
			if ( isModelAttached( modelName, tagName ) )
			{
				point = self getTagOrigin( tagName );
				initial_velocity = vectorNormalize( point - explosionOrigin );
				initial_velocity = vectorScale( initial_velocity, randomfloatrange( force_min, force_max ) );
				
				self thread physics_launch( i, stateIndex, point, initial_velocity );
			}
		}
	}
	self notify( "stop_taking_damage" );
	wait 0.1;
	self.explosion_done = true;
	
	//chad - todo: make this radius damage work - causes a script error right now for some reason
	wait 0.05;
	radiusdamage( explosionOrigin, range, maxdamage, mindamage );
}

isModelAttached( modelName, tagName )
{
	qAttached = false;
	
	assert( isdefined( modelName ) );
	if( !isdefined( tagName ) )
		return qAttached;
	
	attachedModelCount = self getattachsize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
		attachedModels[ i ] = self getAttachModelName( i );
	
	for( i = 0 ; i < attachedModels.size ; i++ )
	{
		if ( attachedModels[i] != modelName )
			continue;
		
		sName = self getattachtagname( i );
		if ( tolower( tagName ) != tolower( sName ) )
			continue;
		
		qAttached = true;
		break;
	}
	return qAttached;
}