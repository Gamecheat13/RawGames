init()
{
	// This number should match the values of the enum listed in sv_snapshot_demo.h
	level.bookmark["kill"] = 0; // DEMO_BOOKMARK_KILL
	level.bookmark["event"] = 1; // DEMO_BOOKMARK_EVENT
	level.bookmark["zm_round_end"] = 2; // DEMO_BOOKMARK_ZM_ROUND_END
	level.bookmark["zm_player_downed"] = 3; // DEMO_BOOKMARK_ZM_PLAYER_DOWNED
	level.bookmark["zm_player_revived"] = 4; // DEMO_BOOKMARK_ZM_PLAYER_REVIVED
	level.bookmark["zm_player_bledout"] = 5; // DEMO_BOOKMARK_ZM_PLAYER_BLEDOUT
	level.bookmark["zm_sidequest_event"] = 6; // DEMO_BOOKMARK_ZM_SIDEQUEST_EVENT
	level.bookmark["score_event"] = 7; // DEMO_BOOKMARK_SCORE_EVENT
	level.bookmark["medal"] = 8; // DEMO_BOOKMARK_MEDAL
}

bookmark( type, time, clientEnt1, clientEnt2, inflictorEnt, weapon )
{
	assert( isdefined( level.bookmark[type] ), "Unable to find a bookmark type for type - " + type );

	client1 = 255;
	client2 = 255;
	inflictorEntNum = -1;
	inflictorEntType = 0;
	inflictorBirthTime = 0;
	overrideEntityCamera = false;

	if ( isDefined( clientEnt1 ) )
		client1 = clientEnt1 getEntityNumber();

	if ( isDefined( clientEnt2 ) )
		client2 = clientEnt2 getEntityNumber();

	if ( isDefined( inflictorEnt ) )
	{
		inflictorEntNum = inflictorEnt getEntityNumber();
		inflictorEntType = inflictorEnt getEntityType();

		if ( isDefined( inflictorEnt.birthTime ) )
			inflictorBirthTime = inflictorEnt.birthTime;
	}

	if ( isDefined( weapon ) )
	{
		overrideEntityCamera = maps\mp\killstreaks\_killstreaks::shouldOverrideEntityCameraInDemo( weapon );
	}

	addDemoBookmark( level.bookmark[type], time, client1, client2, inflictorEntNum, inflictorEntType, inflictorBirthTime, overrideEntityCamera );
}