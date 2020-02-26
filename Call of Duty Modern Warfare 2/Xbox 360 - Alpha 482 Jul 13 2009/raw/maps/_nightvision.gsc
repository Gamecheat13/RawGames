#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;

main( players )
{
	if ( !isdefined( players ) )
			players = level.players;

	thread init_and_run( players );
}

init_and_run( players )
{
	assert( isdefined( players ) );

	PrecacheNightVisionCodeAssets();
	PrecacheShellshock( "nightvision" );
	level.nightVision_DLight_Effect = loadfx( "misc/NV_dlight" );
	level.nightVision_Reflector_Effect = loadfx( "misc/ir_tapeReflect" );

	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];

		player ent_flag_init( "nightvision_enabled" );
		player ent_flag_init( "nightvision_on" );
		player ent_flag_set( "nightvision_enabled" );

		player ent_flag_init( "nightvision_dlight_enabled" );
		player ent_flag_set( "nightvision_dlight_enabled" );
		player ent_flag_clear( "nightvision_dlight_enabled" );

		player SetActionSlot( 1, "nightvision" );
	}

	VisionSetNight( "default_night" );

	waittillframeend;
	wait 0.05;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		player thread nightVision_Toggle();
	}
}


nightVision_Toggle()
{
	assert( isplayer( self ) );

	self endon( "death" );

	for ( ;; )
	{
		self waittill( "night_vision_on" );
		nightVision_On();
		self waittill( "night_vision_off" );
		nightVision_Off();
		wait 0.05;
	}
}


nightVision_check( player )
{
	if ( !isdefined( player ) )
		player = level.player;
	return isdefined( player.nightVision_Enabled );
}


nightVision_On()
{
	assert( isplayer( self ) );

	// wait for the goggles to come down over the eyes

	self.nightVision_Started = true;// we've started the pulldown

	wait( 1.0 );
	ent_flag_set( "nightvision_on" );
	self.nightVision_Enabled = true;
	//thread doShellshock();

	 /#
	// spawn an ent to play the dlight fx on
	if ( self ent_flag( "nightvision_dlight_enabled" ) )
	{
		assert( !isdefined( level.nightVision_DLight ) );
		level.nightVision_DLight = spawn( "script_model", self getEye() );
		level.nightVision_DLight setmodel( "tag_origin" );
		level.nightVision_DLight linkto( self );
		playfxontag( level.nightVision_DLight_Effect, level.nightVision_DLight, "tag_origin" );
	}
	#/

	ai = getaiarray( "allies" );
	array_thread( ai, ::enable_ir_beacon );

	if ( !exists_global_spawn_function( "allies", ::enable_ir_beacon ) )
		add_global_spawn_function( "allies", ::enable_ir_beacon );

//	level thread nightVision_EffectsOn();
}


enable_ir_beacon()
{
	if ( !isAI( self ) ) // ignore drones
		return;
	
	if ( isdefined( self.has_no_ir ) )
	{
		assertex( self.has_no_ir, ".has_ir must be true or undefined" );
		return;
	}

	animscripts\shared::updateLaserStatus();
	thread maps\_nightvision::loopReflectorEffect();
}

nightVision_EffectsOn()
{
	level endon( "night_vision_off" );
	friendlies = getAIArray( "allies" );
	for ( index = 0; index < friendlies.size; index++ )
	{
		for ( i = 0; i < friendlies.size; i++ )
		{
			if ( isDefined( friendlies[ i ].usingNVFx ) )
				continue;

			friendlies[ i ].usingNVFx = true;
			friendlies[ i ] animscripts\shared::updateLaserStatus();
			friendlies[ i ] thread loopReflectorEffect();
		}

		wait( 2.0 );
		friendlies = getAIArray( "allies" );
	}
}

loopReflectorEffect()
{
	level endon( "night_vision_off" );
	self endon( "death" );

	for ( ;; )
	{
		playfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_le" );
		playfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_ri" );

		wait( 0.1 );
	}
}

nightVision_Off()
{
	assert( isplayer( self ) );
	self.nightVision_Started = undefined;

	// wait until the goggles pull off
	wait( 0.5 );
	// delete the DLight fx

	level notify( "night_vision_off" );
	if ( isdefined( level.nightVision_DLight ) )
		level.nightVision_DLight delete();

//	self stopshellshock();

	self notify( "nightvision_shellshock_off" );

	ent_flag_clear( "nightvision_on" );
	self.nightVision_Enabled = undefined;

	//if any of the players are still in nightvision then we don't want to remove
	//this spawn function yet. Only when all players are not in nightvision
	someoneUsingNightvision = false;
	for ( i = 0 ; i < level.players.size ; i++ )
	{
		if ( nightvision_Check( level.players[ i ] ) )
			someoneUsingNightvision = true;
	}
	if ( !someoneUsingNightvision )
		remove_global_spawn_function( "allies", ::enable_ir_beacon );

	thread nightVision_EffectsOff();
}

nightVision_EffectsOff()
{

	friendlies = getAIArray( "allies" );
	for ( index = 0; index < friendlies.size; index++ )
	{
		friendlies[ index ].usingNVFx = undefined;
		friendlies[ index ] animscripts\shared::updateLaserStatus();
	}
}

/*
doShellshock()
{
	self endon( "nightvision_shellshock_off" );
	for (;;)
	{
		duration = 60;
		self shellshock( "nightvision", duration );
		wait duration;
	}
}
*/

ShouldBreakNVGHintPrint()
{
	assert( isplayer( self ) );

	return isDefined( self.nightVision_Started );
}

should_break_disable_nvg_print()
{
	assert( isplayer( self ) );

	return !isDefined( self.nightVision_Started );
}



