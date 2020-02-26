/@
"Name: inc_challenge_stat( <stat_name> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the challenge counter to increment "
"Example: player inc_challenge_stat( \"dronekills\" ); "
"SPMP: singleplayer"
@/
inc_challenge_stat( str_stat_name )
{
	Assert( IsDefined( level._challenge_lookup ) && IsDefined( level._challenge_lookup[ str_stat_name ] ), "Tried to increment the counter for invalid challenge "+str_stat_name+"!" );
	self AddSessStat( "PlayerSessionStats", "challengeCounters", level._challenge_lookup[str_stat_name], 1 );
}

/@
"Name: get_challenge_stat( <stat_name> )"
"Summary: wrapper to get the current count for a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the challenge to get "
"Example: killCount = player get_challenge_stat( \"spetzkills\" ); "
"SPMP: singleplayer"
@/
get_challenge_stat( str_stat_name )
{
	Assert( IsDefined( level._challenge_lookup ) && IsDefined( level._challenge_lookup[ str_stat_name ] ), "Tried to get the challenge counter for invalid challenge "+str_stat_name+"!" );
	return self GetSessStat( "PlayerSessionStats", "challengeCounters", level._challenge_lookup[str_stat_name] );
}

/@
"Name: get_challenge_complete( <stat_name> )"
"Summary: wrapper to get the current completion status for a challenge "
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the challenge to get the completion status of "
"Example: bShouldGiveReward = player get_challenge_complete( \"didcoolstuff\" ); "
"SPMP: singleplayer"
@/
get_challenge_complete( str_stat_name )
{
	Assert( IsDefined( level._challenge_lookup ) && IsDefined( level._challenge_lookup[ str_stat_name ] ), "Tried to get the completion status for the invalid challenge "+str_stat_name+"!" );
	currVal = self get_challenge_stat( str_stat_name );  
	targetVal = level._challenge_target[str_stat_name];
	return ( currVal >= targetVal );					
}


register_challenge( str_stat_name, logic_func )
{
	assert( IsPlayer( self ), "register_challenge() with stat name " + str_stat_name + " must be called on a player." );
	// assert( IsDefined( str_stat_name ) // TODO: finish scripting this line

	if ( !IsDefined( level._challenges_complete ) )
	{
		level._challenges_complete = [];
	}		
	if( !IsDefined( level._challenge_lookup ) )
	{
		level._challenge_lookup = [];
	}
	if( !IsDefined( level._challenge_target ) )
	{
		level._challenge_target = [];
	}
	
	levelAlias = GetLevelAlias();
	challengeNum = TableLookup( "sp/challengeTable.csv", 1, levelAlias, 2, str_stat_name, 0 );
	targetVal = Int( TableLookup( "sp/challengeTable.csv", 1, levelAlias, 2, str_stat_name, 4 ) );

	Assert( challengeNum != "", "Invalid challenge "+str_stat_name+" for level "+levelAlias+" requested, please check challengeTable.csv!" );

	level._challenge_lookup[ str_stat_name ] = "CHALLENGE_"+challengeNum;
	level._challenge_target[ str_stat_name ] = targetVal;
	
	maps\_utility::waitforstats();
	
	str_challenge_notify = "challenge_" + str_stat_name + "_increment";
	self thread [[logic_func]]( str_challenge_notify );
	self thread challenge_notify_listener( str_stat_name, str_challenge_notify );
}

challenge_notify_listener( str_stat_name, str_challenge_notify )
{
	self endon( "stop_" + str_stat_name );
	
	while( true )
	{
		self waittill( str_challenge_notify );
		self inc_challenge_stat( str_stat_name );
		
		is_challenge_stat_complete( str_stat_name );
	}
}

is_challenge_stat_complete( str_stat_name )
{
	if ( self get_challenge_complete( str_stat_name ) && !IsDefined( level._challenges_complete[ str_stat_name ] )  )
	{
		level notify( str_stat_name + "_challenge_complete" );
		DoChallengeCompleteUI();
		level._challenges_complete[ str_stat_name ] = true;
	}	
}

challenge_stop( str_stat_name )
{
	// TODO: put in asserts
	self notify( "stop_" + str_stat_name );
}