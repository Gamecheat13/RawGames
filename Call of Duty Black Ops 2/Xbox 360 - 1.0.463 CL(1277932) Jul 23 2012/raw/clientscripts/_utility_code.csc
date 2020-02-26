// clientscripts\_utility_code.csc

init_session_mode_flags()
{
	// should stay the same as eGameModes in com_gamemodes.h
	level.GAMEMODE_PUBLIC_MATCH			= 0;
	level.GAMEMODE_PRIVATE_MATCH		= 1;
	level.GAMEMODE_LOCAL_SPLITSCREEN	= 2;
	level.GAMEMODE_WAGER_MATCH			= 3;
	level.GAMEMODE_BASIC_TRAINING		= 4;
	level.GAMEMODE_THEATER				= 5;
	level.GAMEMODE_LEAGUE_MATCH			= 6;
	level.GAMEMODE_RTS					= 7;
}

struct_class_init()
{
	assert( !isdefined( level.struct_class_names ), "level.struct_class_names is being initialized in the wrong place! It shouldn't be initialized yet." );
	
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_label" ] = [];
	level.struct_class_names[ "classname" ] = [];
	
	for( i=0; i<level.struct.size; i++ )
	{
		if( isdefined( level.struct[ i ].targetname ) )
		{
			if( !isdefined( level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] ) )
				level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] = [];
			
			size = level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ].size;
			level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ][ size ] = level.struct[ i ];
		}
		if( isdefined( level.struct[ i ].target ) )
		{
			if( !isdefined( level.struct_class_names[ "target" ][ level.struct[ i ].target ] ) )
				level.struct_class_names[ "target" ][ level.struct[ i ].target ] = [];
			
			size = level.struct_class_names[ "target" ][ level.struct[ i ].target ].size;
			level.struct_class_names[ "target" ][ level.struct[ i ].target ][ size ] = level.struct[ i ];
		}
		if( isdefined( level.struct[ i ].script_noteworthy ) )
		{
			if( !isdefined( level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] ) )
				level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] = [];
			
			size = level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ][ size ] = level.struct[ i ];
		}
		
		if( isdefined(level.struct[i].script_label ) )
		{
			if( !isdefined( level.struct_class_names[ "script_label" ][ level.struct[ i ].script_label ] ) )
				level.struct_class_names[ "script_label" ][ level.struct[ i ].script_label] = [];
			
			size = level.struct_class_names[ "script_label" ][ level.struct[ i ].script_label].size;
			level.struct_class_names[ "script_label" ][ level.struct[ i ].script_label ][ size ] = level.struct[ i ];

		}
		
		if( isdefined(level.struct[i].classname ) )
		{
			if( !isdefined( level.struct_class_names[ "classname" ][ level.struct[ i ].classname ] ) )
				level.struct_class_names[ "classname" ][ level.struct[ i ].classname] = [];
			
			size = level.struct_class_names[ "classname" ][ level.struct[ i ].classname].size;
			level.struct_class_names[ "classname" ][ level.struct[ i ].classname ][ size ] = level.struct[ i ];

		}		
	}
}
