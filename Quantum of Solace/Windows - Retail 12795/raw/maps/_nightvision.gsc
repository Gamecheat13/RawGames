#include maps\_hud_util;
#include maps\_utility;

main()
{	
	precacheModel( "tag_origin" );
	precacheShellshock( "nightvision" );
	level.nightVision_DLight_Effect = loadfx( "misc/NV_dlight" );
	level.nightVision_Reflector_Effect = loadfx( "misc/ir_tapeReflect" );

	//RAYME: the enabled/disabled flag isn't being used
	flag_init( "nightvision_enabled" );
	flag_init( "nightvision_on" );
	flag_set( "nightvision_enabled" );
	
	flag_init( "nightvision_dlight_enabled" );
	flag_set( "nightvision_dlight_enabled" );
	flag_clear( "nightvision_dlight_enabled" );

	VisionSetNight( "default_night" );
	
	waittillframeend;
	wait 0.05;
	
	thread nightVision_Toggle();
}


nightVision_Toggle()
{
	level.player endon ( "death" );
	
	for (;;)
	{
		level.player waittill( "night_vision_on" );
		nightVision_On();
		level.player waittill( "night_vision_off" );
		nightVision_Off();
		wait 0.05;
	}
}


nightVision_check()
{
	return isdefined( level.player.nightVision_Enabled );
}


nightVision_On()
{
	// wait for the goggles to come down over the eyes
	
	level.player.nightVision_Started = true; // we've started the pulldown

	wait ( 1.0 );
	flag_set( "nightvision_on" );
	level.player.nightVision_Enabled = true;
	//thread doShellshock();
	
	// spawn an ent to play the dlight fx on
	if ( flag( "nightvision_dlight_enabled" ) )
	{
		assert( !isdefined( level.nightVision_DLight ) );
		level.nightVision_DLight = spawn( "script_model", level.player getEye() );
		level.nightVision_DLight setmodel( "tag_origin" );
		level.nightVision_DLight linkto( level.player );
		playfxontag ( level.nightVision_DLight_Effect, level.nightVision_DLight, "tag_origin" );
	}
	
	level thread nightVision_EffectsOn();
}

nightVision_EffectsOn()
{
	level endon ( "night_vision_off" );
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
		
		wait ( 2.0 );
		friendlies = getAIArray( "allies" );
	}
}

loopReflectorEffect()
{
	level endon ( "night_vision_off" );
	self endon ( "death" );

	for ( ;; )
	{
		playfxontag ( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_le" );
		playfxontag ( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_ri" );

		wait ( 0.1 );
	}
}

nightVision_Off()
{
	// wait until the goggles pull off
	wait ( 0.5 );
	// delete the DLight fx
	level notify( "night_vision_off" );
	if ( isdefined( level.nightVision_DLight ) )
		level.nightVision_DLight delete();
		
	level.player stopshellshock();
	
	level.player notify( "nightvision_shellshock_off" );
	
	flag_clear( "nightvision_on" );
	level.player.nightVision_Enabled = undefined;
	level.player.nightVision_Started = undefined;
	
	level thread nightVision_EffectsOff();
}


nightVision_EffectsOff()
{

	friendlies = getAIArray( "allies" );
	for ( index = 0; index < friendlies.size; index++ )
	{
		friendlies[index].usingNVFx = undefined;
		friendlies[index] animscripts\shared::updateLaserStatus();
	}
}


doShellshock()
{
	level.player endon( "nightvision_shellshock_off" );
	for (;;)
	{
		duration = 60;
		level.player shellshock( "nightvision", duration );
		wait duration;
	}
}


ShouldBreakNVGHintPrint()
{
	if ( isDefined( level.player.nightVision_Started ) && level.player.nightVision_Started )
		return true;

	return false;
}


NVGHintPrintWait( length )
{
	goalTime = GetTime() + length * 1000;

	for (;;)
	{
		if ( GetTime() >= goalTime )
			break;
		if ( ShouldBreakNVGHintPrint() )
			break;
		wait( 0.01 );
	}	
}


NVGHintPrint()
{
	MYFADEINTIME = 1.0;
	MYFLASHTIME = 0.75;
	MYALPHAHIGH = 0.95;
	MYALPHALOW = 0.4;

	nvgHint = createFontString( "default", 2 );
	
	nvgHint.color = ( 1, 1, .5 );
	nvgHint.alpha = 0.9;
	nvgHint.x = 0;
	nvgHint.y = -60;
	nvgHint.alignx = "center";
	nvgHint.aligny = "middle";
	nvgHint.horzAlign = "center";
	nvgHint.vertAlign = "middle";
	nvgHint.foreground = false;
	nvgHint.hidewhendead = true;

	nvgHint setText( &"SCRIPT_NIGHTVISION_USE" );

	nvgHint.alpha = 0;
	nvgHint FadeOverTime( MYFADEINTIME );
	nvgHint.alpha = MYALPHAHIGH;
	NVGHintPrintWait( MYFADEINTIME );

	for (;;)
	{
		nvgHint FadeOverTime( MYFLASHTIME );
		nvgHint.alpha = MYALPHALOW;
		NVGHintPrintWait( MYFLASHTIME );

		if ( ShouldBreakNVGHintPrint() )
			break;

		nvgHint FadeOverTime( MYFLASHTIME );
		nvgHint.alpha = MYALPHAHIGH;
		NVGHintPrintWait( MYFLASHTIME );

		if ( ShouldBreakNVGHintPrint() )
			break;
	}
	
	nvgHint Destroy();
}
