#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_dev;
#using scripts\mp\gametypes\_globallogic_utils;

#using scripts\mp\_util;

#namespace gameadvertisement;

function init()
{
/#
	level.sessionAdvertStatus = true;
	thread sessionAdvertismentUpdateDebugHud();
#/

	thread sessionAdvertisementCheck();
}


function setAdvertisedStatus( onOff )
{
/#
	level.sessionAdvertStatus = onOff;
#/	
	changeAdvertisedStatus( onOff );
}

function sessionAdvertisementCheck()
{
	if( SessionModeIsPrivate() )
		return;

	if( SessionModeIsZombiesGame() )
	{
		setAdvertisedStatus( false );
		return;
	}

	runRules = getGameTypeRules();

	if( !isdefined( runRules ) )
		return;
		
	level endon( "game_end" );
	
	level waittill( "prematch_over" );

	while( true )
	{
		sessionAdvertCheckwait = GetDvarInt( "sessionAdvertCheckwait", 1 );
		
		wait( sessionAdvertCheckwait );

		advertise = [[runRules]]();

		setAdvertisedStatus( advertise );		
	}
}

function getGameTypeRules()
{
	gametype = level.gametype;

	switch( gametype )
	{
		case "dm":
			return&dm_rules;
		case  "tdm":
			return&tdm_rules;
		case  "dom":
			return&dom_rules;
		case  "hq":
			return&hq_rules;
		case  "sd":
			return&sd_rules;
		case  "dem":
			return&dem_rules;
		case  "ctf":
			return&ctf_rules;
		case  "koth":
			return&koth_rules;
		case  "conf":
			return&conf_rules;
		case  "oic":
			return&oic_rules;
		case  "sas":
			return&sas_rules;
		case  "gun":
			return&gun_rules;
		case  "shrp":
			return&shrp_rules;
	}

	return;
}

function teamScoreLimitCheck( ruleScorePercent )
{
	//====================================================================
	//	score check				
	if ( level.scoreLimit )
	{
		minScorePercentageLeft = 100;

		foreach ( team in level.teams )
		{
			scorePercentageLeft = 100 - ( ( game[ "teamScores" ][ team ] / level.scoreLimit ) * 100 );

			if( minScorePercentageLeft > scorePercentageLeft )
				minScorePercentageLeft = scorePercentageLeft;

			if( ruleScorePercent >= scorePercentageLeft )
			{	
/#
				updateDebugHud( 3, "Score Percentage Left: ", int( scorePercentageLeft ) );
#/
				return false;
			}
		}

/#
		updateDebugHud( 3, "Score Percentage Left: ", int( minScorePercentageLeft ) );
#/
	}

	return true;
}

function timeLimitCheck( ruleTimeLeft )
{
	maxTime = level.timeLimit;
		
	if( maxTime != 0 )
	{		
		timeLeft = globallogic_utils::getTimeRemaining();

		if( ruleTimeLeft >= timeLeft )
		{	
			return false;
		}
	}

	return true;
}

//========================================================================================================================================
//========================================================================================================================================
//========================================================================================================================================

function dm_rules()
{
	// Any player is within 35% of score cap
	// Time limit has less than 1.5 minutes remaining

	//====================================================================

	ruleScorePercent = 35;						// within 35%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Time limit has less than minutes remaining: ", ruleTimeLeft/( 1000 * 60 ) );
#/

	//====================================================================
	//	score check

	if ( level.scoreLimit )
	{
		highestScore = 0;
		players = GetPlayers();

		for( i = 0; i < players.size; i++)
		{
			if( players[i].pointstowin > highestScore )
				highestScore = players[i].pointstowin;
		}

		scorePercentageLeft = 100 - ( ( highestScore / level.scoreLimit ) * 100 );

/#
		updateDebugHud( 3, "Score Percentage Left: ", int( scorePercentageLeft ) );
#/

		if( ruleScorePercent >= scorePercentageLeft )
		{	
			return false;
		}
	}
		
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;

	return true;
}

function tdm_rules()
{
	// Any team is within 15% of score cap  
	// Time limit has less than 1.5 minutes remaining  

	//====================================================================

	ruleScorePercent = 15;						// within 15%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Time limit has less than minutes remaining: ", ruleTimeLeft/( 1000 * 60 ) );
#/

	//====================================================================
	//	score check

	if( teamScoreLimitCheck( ruleScorePercent ) == false )
		return false;
		
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;

	return true;
}

function dom_rules()
{
	// Either team is within 15% of score cap
	// Time limit has less than 1.5 minutes remaining
	// Is round 3
	
	//====================================================================

	ruleScorePercent = 15;						// within 15%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins
	ruleRound = 3;								// 3 rounds

	currentRound = game[ "roundsplayed" ] + 1; 

	//====================================================================

/#
	updateDebugHud( 1, "Time limit 1.5 minutes remaining in final round. Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Is round: ", ruleRound );
	updateDebugHud( 4, "Current Round: ", currentRound );
#/

	//====================================================================
	//	score check
		
	if( currentRound >= 2 ) // only check in final round
	{
		if( teamScoreLimitCheck( ruleScorePercent ) == false )
			return false;
	}
	
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;
		
	//====================================================================
	//	round check

	if( ruleRound <= currentRound )
		return false;

	return true;
}

function hq_rules()
{
	// use Hardpoint (koth) rules
	return koth_rules();
}

function sd_rules()
{
	// Any team has won 3 rounds

	//====================================================================

	ruleRound = 3;								// 3 rounds
	
	//====================================================================

/#
	updateDebugHud( 1, "Any team has won rounds: ", ruleRound );
#/

	//====================================================================
	//	round check

	maxRoundsWon = 0;
	foreach ( team in level.teams )
	{
		roundsWon = game[ "teamScores" ][ team ];

		if( maxRoundsWon < roundsWon )
			maxRoundsWon = roundsWon;
		
		if( ruleRound <= roundsWon )
		{	
/#
			updateDebugHud( 3, "Max Rounds Won: ", maxRoundsWon );
#/
			return false;
		}
	}

/#
	updateDebugHud( 3, "Max Rounds Won: ", maxRoundsWon );
#/

	return true;
}

function dem_rules()
{
	// use capture the level flag::get(ctf) rules
	return ctf_rules();
}

function ctf_rules()
{
	// Is round 3 or later

	//====================================================================

	ruleRound = 3;								// 3 rounds

	roundsPlayed = game[ "roundsplayed" ]; 

	//====================================================================

/#
	updateDebugHud( 1, "Is round or later: ", ruleRound );
	updateDebugHud( 3, "Rounds Played: ", roundsPlayed );
#/	

	//====================================================================
	//	round check

	if( ruleRound <= roundsPlayed )
		return false;

	return true;
}

function koth_rules()
{
	// Any team is within 20% of score cap
	// Time limit has less than 1.5 minutes remaining

	//====================================================================

	ruleScorePercent = 20;						// within 20%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Time limit has less than minutes remaining: ", ruleTimeLeft/( 1000 * 60 ) );
#/

	//====================================================================
	//	score check
			
	if( teamScoreLimitCheck( ruleScorePercent ) == false )
		return false;
		
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;

	return true;
}

function conf_rules()
{
	// use team deathmatch (tdm) rules
	return tdm_rules();
}

function oic_rules()
{
	// No join in progress, so shouldn’t advertise to matchmaking once the countdown timer ends

	//====================================================================

/#
	updateDebugHud( 1, "No join in progress, so shouldn’t advertise to matchmaking once the countdown timer ends.", 0 );
#/

	return false;
}

function sas_rules()
{
	// Any player is within 35% of score cap
	// Time limit has less than 1.5 minutes remaining

	//====================================================================

	ruleScorePercent = 35;						// within 35%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Time limit has less than minutes remaining: ", ruleTimeLeft/( 1000 * 60 ) );
#/

	//====================================================================
	//	score check
			
	if( teamScoreLimitCheck( ruleScorePercent ) == false )
		return false;
		
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;

	return true;
}

function gun_rules()
{
	// Any player is within 3 weapons from winning

	//====================================================================

	ruleWeaponsLeft = 3;						// within 3 weapons of winning

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within X weapons from winning: ", ruleWeaponsLeft );
#/

	//====================================================================
	//	weapons check
	minWeaponsLeft = level.gunProgression.size;
	
	foreach ( player in level.players )
	{
		weaponsLeft = level.gunProgression.size - player.gunProgress;
		
		if( minWeaponsLeft > weaponsLeft )
			minWeaponsLeft = weaponsLeft;
		
		if( ruleWeaponsLeft >= minWeaponsLeft )
		{
/#
			updateDebugHud( 3, "Weapons Left: ", minWeaponsLeft );
#/			
			return false;
		}
	}
/#
	updateDebugHud( 3, "Weapons Left: ", minWeaponsLeft );
#/	

	return true;
}

function shrp_rules()
{
	// Any player is within 35% of score cap
	// Time limit has less than 1.5 minutes remaining

	//====================================================================

	ruleScorePercent = 35;						// within 35%
	ruleTimeLeft = ( 1000 * 60 ) * 1.5;			// 1.5 mins

	//====================================================================

/#
	updateDebugHud( 1, "Any player is within percent of score cap: ", ruleScorePercent );
	updateDebugHud( 2, "Time limit has less than minutes remaining: ", ruleTimeLeft/( 1000 * 60 ) );
#/

	//====================================================================
	//	score check
			
	if( teamScoreLimitCheck( ruleScorePercent ) == false )
		return false;
		
	//====================================================================
	//	time left check

	if( timeLimitCheck( ruleTimeLeft ) == false )
		return false;

	return true;
}

//========================================================================================================================================
//========================================================================================================================================
//========================================================================================================================================

/#
function sessionAdvertismentCreateDebugHud( lineNum, alignX )
{
	debug_hud = dev::new_hud( "session_advert", "debug_hud", 0, 0, 1 );
	debug_hud.hidewheninmenu = true;
	debug_hud.horzAlign = "right";
	debug_hud.vertAlign = "middle";
	debug_hud.alignX = "right";
	debug_hud.alignY = "middle";
	debug_hud.x = alignX;
	debug_hud.y = -50 + (lineNum * 15);
	debug_hud.foreground = true;
	debug_hud.font = "default";
	debug_hud.fontScale = 1.5;
	debug_hud.color = ( 1.0, 1.0, 1.0 );
	debug_hud.alpha = 1;

	debug_hud setText( "" );

	return debug_hud;
}

function updateDebugHud( hudIndex, text, value )
{
	switch( hudIndex )
	{
	case 1:
		level.sessionAdvertHud_1A_text = text;
		level.sessionAdvertHud_1B_text = value;
		break;
	
	case 2:
		level.sessionAdvertHud_2A_text = text;
		level.sessionAdvertHud_2B_text = value;
		break;
	
	case 3:
		level.sessionAdvertHud_3A_text = text;
		level.sessionAdvertHud_3B_text = value;
		break;

	case 4:
		level.sessionAdvertHud_4A_text = text;
		level.sessionAdvertHud_4B_text = value;
		break;
	}
}

function sessionAdvertismentUpdateDebugHud()
{
	level endon( "game_end" );

	sessionAdvertHud_0 = undefined;

	sessionAdvertHud_1A = undefined;
	sessionAdvertHud_1B = undefined;
	sessionAdvertHud_2A = undefined;
	sessionAdvertHud_2B = undefined;
	sessionAdvertHud_3A = undefined;
	sessionAdvertHud_3B = undefined;
	sessionAdvertHud_4A = undefined;
	sessionAdvertHud_4B = undefined;


	level.sessionAdvertHud_0_text = "";
	level.sessionAdvertHud_1A_text = "";
	level.sessionAdvertHud_1B_text = "";
	level.sessionAdvertHud_2A_text = "";
	level.sessionAdvertHud_2B_text = "";
	level.sessionAdvertHud_3A_text = "";
	level.sessionAdvertHud_3B_text = "";
	level.sessionAdvertHud_4A_text = "";
	level.sessionAdvertHud_4B_text = "";

	while( true )
	{
		wait( 1 );

		showDebugHud = GetDvarInt( "sessionAdvertShowDebugHud", 0 );

		//====================================================================
		
		level.sessionAdvertHud_0_text = "Session is advertised";		
		if( level.sessionAdvertStatus == false )
			level.sessionAdvertHud_0_text = "Session is not advertised";

		//====================================================================

		if( !isdefined( sessionAdvertHud_0 ) && showDebugHud != 0 )
		{
			host = util::getHostPlayer();
			
			if( !isdefined( host ) )
				continue;

			sessionAdvertHud_0 = host sessionAdvertismentCreateDebugHud( 0, 0 );

			sessionAdvertHud_1A = host sessionAdvertismentCreateDebugHud( 1, -20 );
			sessionAdvertHud_1B = host sessionAdvertismentCreateDebugHud( 1, 0 );
			sessionAdvertHud_2A = host sessionAdvertismentCreateDebugHud( 2, -20 );
			sessionAdvertHud_2B = host sessionAdvertismentCreateDebugHud( 2, 0 );
			sessionAdvertHud_3A = host sessionAdvertismentCreateDebugHud( 3, -20 );
			sessionAdvertHud_3B = host sessionAdvertismentCreateDebugHud( 3, 0 );
			sessionAdvertHud_4A = host sessionAdvertismentCreateDebugHud( 4, -20 );
			sessionAdvertHud_4B = host sessionAdvertismentCreateDebugHud( 4, 0 );
			
			sessionAdvertHud_1A.color = ( 0.0, 0.5, 0.0 );
			sessionAdvertHud_1B.color = ( 0.0, 0.5, 0.0 );
			sessionAdvertHud_2A.color = ( 0.0, 0.5, 0.0 );
			sessionAdvertHud_2B.color = ( 0.0, 0.5, 0.0 );
		}
		
		if( isdefined( sessionAdvertHud_0 ) )
		{
			if( showDebugHud == 0 )
			{
				sessionAdvertHud_0 destroy();
				sessionAdvertHud_1A destroy();
				sessionAdvertHud_1B destroy();
				sessionAdvertHud_2A destroy();
				sessionAdvertHud_2B destroy();
				sessionAdvertHud_3A destroy();
				sessionAdvertHud_3B destroy();
				sessionAdvertHud_4A destroy();
				sessionAdvertHud_4B destroy();

				sessionAdvertHud_0 = undefined;
				sessionAdvertHud_1A = undefined;
				sessionAdvertHud_1B = undefined;
				sessionAdvertHud_2A = undefined;
				sessionAdvertHud_2B = undefined;
				sessionAdvertHud_3A = undefined;
				sessionAdvertHud_3B = undefined;
				sessionAdvertHud_4A = undefined;
				sessionAdvertHud_4B = undefined;
			}
			else
			{
				if( level.sessionAdvertStatus == true )
					sessionAdvertHud_0.color = ( 1.0, 1.0, 1.0 );
				else
					sessionAdvertHud_0.color = ( 0.9, 0.0, 0.0 );

				sessionAdvertHud_0 setText( level.sessionAdvertHud_0_text );

				if( level.sessionAdvertHud_1A_text != "" )
				{
					sessionAdvertHud_1A setText( level.sessionAdvertHud_1A_text );
					sessionAdvertHud_1B setValue( level.sessionAdvertHud_1B_text );
				}

				if( level.sessionAdvertHud_2A_text != "" )
				{
					sessionAdvertHud_2A setText( level.sessionAdvertHud_2A_text );
					sessionAdvertHud_2B setValue( level.sessionAdvertHud_2B_text );
				}

				if( level.sessionAdvertHud_3A_text != "" )
				{
					sessionAdvertHud_3A setText( level.sessionAdvertHud_3A_text );
					sessionAdvertHud_3B setValue( level.sessionAdvertHud_3B_text );
				}

				if( level.sessionAdvertHud_4A_text != "" )
				{
					sessionAdvertHud_4A setText( level.sessionAdvertHud_4A_text );
					sessionAdvertHud_4B setValue( level.sessionAdvertHud_4B_text );
				}
			}				
		}
	}
}
#/