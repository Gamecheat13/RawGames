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


	for ( i = 0; i < lines.size; i ++ )
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

fadeinBlackOut( duration, alpha, blur )
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

	for ( i = 0; i < spawner.size; i ++ )
		ai[ i ] = scripted_spawn2( value, key, stalingrad, spawner[ i ] );
	return ai;
}

scripted_spawn2( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with script_noteworthy " + value + " does not exist." );
	
	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn();
	else
		ai = spawner dospawn();
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

deleteai_triggers()
{
	triggers = getentarray( "deleteai", "targetname" );
	for ( i = 0; i < triggers.size; i ++ )
	{
		trigger = triggers[ i ];
		
		if ( isdefined( trigger.script_deleteai ) )
			trigger thread deleteai();
	}
}

deleteai()
{
	self waittill( "trigger" );
	
	aiarray = getaiarray();
	for ( i = 0; i < aiarray.size; i ++ )
	{
		ai = aiarray[ i ];
		if ( isdefined(ai.script_deleteai) && ai.script_deleteai == self.script_deleteai )
			ai delete();
	}
}


