#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\coup;
#include common_scripts\utility;

temp_prints( line1, line2, line3, line4 )
{
	if ( 1 )
		return;
	
	temp_killprints();
	level.intro_offset = 0;
	lines = [];
	if ( isdefined( line1 ) )
		lines[ lines.size ] = line1;
	
	if ( isdefined( line2 ) )
		lines[ lines.size ] = line2;
	
	if ( isdefined( line3 ) )
			lines[ lines.size ] = line3;
	
	if ( isdefined( line4 ) )
			lines[ lines.size ] = line4;


	for ( i = 0; i < lines.size; i++ )
		maps\_introscreen::introscreen_corner_line( lines[ i ] );
	
	thread temp_prints_internal();
}

temp_prints_internal()
{
	level endon( "destroy_hud_elements" );	
	wait 3.5;
	temp_killprints();
}

temp_killprints()
{
	level notify( "destroy_hud_elements" );
}

fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

dialogprint( string, delay )
{
	iprintln( string );
	
	if ( isdefined( delay ) && delay > 0 )
		wait delay;
}

initDOF()
{
    setDvar( "scr_dof_enable", 0 );

    for ( ;; )
    {
        setdefaultdepthoffield();
        wait 0.05;
    }
}

setdefaultdepthoffield()
{
		level.player setDepthOfField( 
								level.dofDefault[ "nearStart" ], 
								level.dofDefault[ "nearEnd" ], 
								level.dofDefault[ "farStart" ], 
								level.dofDefault[ "farEnd" ], 
								level.dofDefault[ "nearBlur" ], 
								level.dofDefault[ "farBlur" ]
								 );
}

setDOF( nearStart, nearEnd, nearBlur, farStart, farEnd, farBlur, duration )
{
	if ( isdefined( duration ) && duration > 0 )
	{
		duration = int( duration * 1000 );
		
	    startTime = getTime();
	    curTime = getTime();
	    
	    while ( curTime <= startTime + duration )
	    {
	    	lerpAmount = ( ( curTime - startTime ) / duration );
	
			lerpDoFValue( "nearStart", nearStart, lerpAmount );
			lerpDoFValue( "nearEnd", nearEnd, lerpAmount );
			lerpDoFValue( "nearBlur", nearBlur, lerpAmount );
			lerpDoFValue( "farStart", farStart, lerpAmount );
			lerpDoFValue( "farEnd", farEnd, lerpAmount );
			lerpDoFValue( "farBlur", farBlur, lerpAmount );
	
	    	wait 0.05;
	    	curTime = getTime();
	    }
	}

    level.dof[ "nearStart" ] = nearStart;
    level.dof[ "nearEnd" ] = nearEnd;
    level.dof[ "nearBlur" ] = nearBlur;
    level.dof[ "farStart" ] = farStart;
    level.dof[ "farEnd" ] = farEnd;
    level.dof[ "farBlur" ] = farBlur;
}

lerpDoFValue( valueName, targetValue, lerpAmount )
{
	level.dofDefault[ valueName ] = level.dof[ valueName ] + ( ( targetValue - level.dof[ valueName ] ) * lerpAmount ) ;	
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i = 0; i < spawner.size; i++ )
		ai[ i ] = scripted_spawn2( value, key, stalingrad, spawner[ i ] );
	return ai;
}

scripted_spawn2( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with " + key + " " + value + " does not exist." );
	
	if ( isdefined( spawner.script_drone ) )
	{
		drone = dronespawn( spawner );
		drone thread [[ level.drone_spawn_func ]]();
		return drone;
	}
	else
	{
		if ( isdefined( stalingrad ) )
			ai = spawner stalingradSpawn();
		else
			ai = spawner dospawn();
		spawn_failed( ai );
		assert( isDefined( ai ) );
		return ai;
	}
}

DeleteCharacterTriggers()
{
	triggers = getentarray( "deleteai", "targetname" );
	for ( i = 0; i < triggers.size; i++ )
	{
		trigger = triggers[ i ];
		
		if ( isdefined( trigger.script_deleteai ) )
			trigger thread DeleteCharacter();
	}
}

// TODO: Make sure deleting these drones doesn't screw with the global drone arrays
DeleteCharacter()
{
	self waittill( "trigger" );
	
	aiarray = getaiarray();
	for ( i = 0; i < aiarray.size; i++ )
	{
		ai = aiarray[ i ];
		if ( isdefined( ai.script_deleteai ) && ai.script_deleteai == self.script_deleteai )
			ai delete();
	}
	
	teams[ 0 ] = "axis";
	teams[ 1 ] = "allies";
	teams[ 2 ] = "neutral";

	for ( i = 0; i < teams.size; i++ )
	{
		dronearray = level.drones[ teams[ i ] ].array;
		
		for ( k = 0; k < dronearray.size; k++ )
		{
			drone = dronearray[ k ];
			if ( isdefined( drone.script_deleteai ) && drone.script_deleteai == self.script_deleteai )
				drone delete();
		}
	}
}

// change so full fraction of 1 will not break
// handle initialization and changing of level.vision_totalpercent
// make sure we aren't doing vision stuff all through the whole level
// updateBlackOutOverlay()
pulseFadeVision( duration, value )
{
	level.player endon( "death" );

	level.vision_totalpercent = 100;
	thread updatePulseFadeAmount( duration, value );

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	min_length = 1;
	max_length = 4;
	min_alpha = .25;
	max_alpha = 1;

	min_percent = 0;
	max_percent = 100;
	
	fraction = 0;

	for ( ;; )
	{
		while ( level.vision_totalpercent > min_percent )
		{
			percent_range = max_percent - min_percent;
			fraction = ( level.vision_totalpercent - min_percent ) / percent_range;

			if ( fraction < 0 )
				fraction = 0;
			else if ( fraction > 1 )
				fraction = 1;

			length_range = max_length - min_length;
			length = min_length + ( length_range * ( 1 - fraction ) );
			
			alpha_range = max_alpha - min_alpha;
			alpha = min_alpha + ( alpha_range * fraction );

			blur = 7.2 * alpha;
			end_alpha = fraction * 0.5;
			end_blur = 7.2 * end_alpha;

			// println( "fraction: ", fraction, " length: ", length, " alpha: ", alpha, " blur: ", blur );
			
			// if ( fraction == 1 )
				// break;
			
			duration = length / 2;

			overlay fadeOverlay( duration, alpha, blur );
			overlay fadeOverlay( duration, end_alpha, end_blur );

			// wait a variable amount based on level.vision_totalpercent, this is the space in between pulses
			wait( fraction * 0.5 );
		}

		// if ( fraction == 1 )
			// break;
		
		// if ( overlay.alpha != 0 )
			// overlay fadeOverlay( 1, 0, 0 );
		
		wait 0.05;
	}

	// overlay fadeOverlay( 2, 1, 6 );
}

updatePulseFadeAmount( duration, value )
{
	frequency = 0.05;
	steps = int( duration / frequency );

	while ( steps > 1 )
    {
	    level.vision_totalpercent = level.vision_totalpercent + ( value - level.vision_totalpercent ) / steps;
	    steps -- ;
	 // println( "level.vision_totalpercent: ", level.vision_totalpercent, " steps: ", steps );

	    wait frequency;
	}

	level.vision_totalpercent = value;
}

dropdead()
{
	self waittill( "death", other );

	self animscripts\shared::DropAllAIWeapons();
	self startragdoll();	
	org = self.origin;
	org = org + ( 0, 16, 0 );
	forward = AnglesToForward( ( 0, 270, 0 ) );
	force = vectorScale( forward, 2 );
	//thread maps\_debug::drawArrowForever( org, ( 0, 270, 0 ) );
	PhysicsJolt( org, 250, 250, force );
}