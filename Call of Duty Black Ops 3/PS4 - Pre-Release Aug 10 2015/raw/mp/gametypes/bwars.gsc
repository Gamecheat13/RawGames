#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;

/*
	Bot Wars
	Objective: 	Capture all the flags by touching them
	Map ends:	When one team captures all the flags, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of owned flags, teammates and 
			enemies at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.
			Optionally, give a spawnpoint a script_linkto to specify which flag it "belongs" to (see Flag Descriptors).

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flags:
			classname       trigger_radius
			targetname      flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
		Flag Descriptors:
			classname       script_origin
			targetname      flag_descriptor
			Place one flag descriptor close to each flag. Use the script_linkname and script_linkto properties to say which flags
			it can be considered "adjacent" to in the level. For instance, if players have a primary path from flag1 to flag2, and 
			from flag2 to flag3, flag2 would have a flag_descriptor with these properties:
			script_linkname flag2
			script_linkto flag1 flag3
			
			Set scr_domdebug to 1 to see flag connections and what spawnpoints are considered connected to each flag.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_dom_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_a (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_b (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_c (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_dom_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/





#precache( "material", "compass_waypoint_captureneutral" );
#precache( "material", "compass_waypoint_capture" );
#precache( "material", "compass_waypoint_defend" );
#precache( "material", "compass_waypoint_captureneutral_a" );
#precache( "material", "compass_waypoint_capture_a" );
#precache( "material", "compass_waypoint_defend_a" );
#precache( "material", "compass_waypoint_captureneutral_b" );
#precache( "material", "compass_waypoint_capture_b" );
#precache( "material", "compass_waypoint_defend_b" );
#precache( "material", "compass_waypoint_captureneutral_c" );
#precache( "material", "compass_waypoint_capture_c" );
#precache( "material", "compass_waypoint_defend_c" );

#precache( "string", "OBJECTIVES_DOM" );
#precache( "string", "OBJECTIVES_DOM_SCORE" );
#precache( "string", "OBJECTIVES_DOM_HINT" );
#precache( "string", "MP_CAPTURING_FLAG" );
#precache( "string", "MP_LOSING_FLAG" );
//#precache( "string", "MP_LOSING_LAST_FLAG" );
#precache( "string", "MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
#precache( "string", "MP_DOM_ENEMY_FLAG_CAPTURED" );
#precache( "string", "MP_DOM_NEUTRAL_FLAG_CAPTURED" );

#precache( "string", "MP_ENEMY_FLAG_CAPTURED_BY" );
#precache( "string", "MP_NEUTRAL_FLAG_CAPTURED_BY" );
#precache( "string", "MP_FRIENDLY_FLAG_CAPTURED_BY" );
#precache( "string", "MP_DOM_FLAG_A_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_B_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_C_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_D_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_E_CAPTURED_BY" );	
//#precache( "fx", "_t6/misc/fx_ui_flagbase_gold_t5" );//TODO T7 - contact FX team to get proper replacement

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 1000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerRoundSwitch( 0, 9 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.teamBased = false;
	level.overrideTeamScore = true;
	level.overridePlayerScore = true;
	level.onStartGameType =&onStartGameType;
	level.onPlayerKilled =&onPlayerKilled;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onEndGame=&onEndGame;
	level.onRoundEndGame =&onRoundEndGame;

	gameobjects::register_allowed_gameobject( "dom" );

	game["dialog"]["gametype"] = "dom_start";
	game["dialog"]["gametype_hardcore"] = "hcdom_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	level.lastDialogTime = 0;
		
	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths" , "captures", "defends"); 
}


function onPrecacheGameType()
{
}


function onStartGameType()
{	
	util::setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	util::setObjectiveText( "axis", &"OBJECTIVES_DOM" );
	
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_DOM_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_DOM_HINT" );

	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = "_t6/misc/fx_ui_flagbase_gold_t5";//TODO T7 - contact FX team to get proper replacement
	level.flagBaseFXid[ "axis"   ] = "_t6/misc/fx_ui_flagbase_gold_t5";//TODO T7 - contact FX team to get proper replacement

	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	spawnlogic::place_spawn_points( "mp_dom_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_dom_spawn_axis_start" );
	
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = spawnlogic::get_spawnpoint_array( "mp_dom_spawn" );
	level.spawn_axis_start = spawnlogic::get_spawnpoint_array( "mp_dom_spawn_axis_start" );
	level.spawn_allies_start = spawnlogic::get_spawnpoint_array( "mp_dom_spawn_allies_start" );
	
	flagSpawns = spawnlogic::get_spawnpoint_array( "mp_dom_spawn_flag_a" );
	//assert( flagSpawns.size > 0 );
	
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
		
	if ( !util::isOneRound() && level.scoreRoundWinBased )
	{
		globallogic_score::resetTeamScores();
	}
		
	updateGametypeDvars();
	bwars_init();
	level thread bwars_update_scores();
	bwars_spawns_update();
}

function onEndGame( winningTeam )
{
}

function onRoundEndGame( roundWinner )
{
	if ( level.scoreRoundWinBased ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	}

  axisScore = [[level._getTeamScore]]( "axis" );
  alliedScore = [[level._getTeamScore]]( "allies" );

	if ( axisScore == alliedScore )
	{
		winner = "tie";
	}
	else if ( axisScore > alliedScore )
	{
		winner = "axis";
	}
	else
	{
		winner = "allies";
	}

	return winner;
}

function updateGametypeDvars()
{
	level.flagCaptureTime = GetGametypeSetting( "captureTime" );
	level.flagCaptureLPM = math::clamp( GetDvarFloat( "maxFlagCapturePerMinute", 3 ), 0, 10 );
	level.playerCaptureLPM = math::clamp( GetDvarFloat( "maxPlayerCapturePerMinute", 2 ), 0, 10 );
	level.playerCaptureMax = math::clamp( GetDvarFloat( "maxPlayerCapture", 1000 ), 0, 1000 );
	level.playerOffensiveMax = math::clamp( GetDvarFloat( "maxPlayerOffensive", 16 ), 0, 1000 );
	level.playerDefensiveMax = math::clamp( GetDvarFloat( "maxPlayerDefensive", 16 ), 0, 1000 );
}

function bwars_init()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;

	triggers = GetEntArray( "flag_primary", "targetname" );

	if ( !triggers.size )
	{
		printLn( "^1Not enough domination flags found in level!" );
		callback::abort_level();
		return;
	}

	level.bwars_flags = [];
	
	foreach( trigger in triggers )
	{
		visuals = trigger flag_model_init();

		flag = gameobjects::create_use_object( "neutral", trigger, visuals, ( 0, 0, 100 ) );
		Objective_Delete( flag.objIDAllies );
		gameobjects::release_obj_id( flag.objIDAllies );
		
		flag gameobjects::allow_use( "any" );
		flag gameobjects::set_use_time( level.flagCaptureTime );
		flag gameobjects::set_use_text( &"MP_CAPTURING_FLAG" );
		flag gameobjects::set_visible_team( "any" );

		flag flag_compass_init();

		flag.onUse =&onUse;
		flag.onBeginUse =&onBeginUse;
		flag.onUseUpdate =&onUseUpdate;
		flag.onEndUse =&onEndUse;

		level.bwars_flags[ level.bwars_flags.size ] = flag;
	}
}

function player_hud_init()
{
	if ( isdefined( self.bwars_hud ) )
	{
		return;
	}

	self.bwars_hud = [];

	x = -40;
	y = 300;

	for( i = 0; i < 4; i++ )
	{
		hud = NewClientHudElem( self );

		hud.alignX = "left";
		hud.alignY = "middle";
		hud.foreground = 1;
		hud.fontScale = 1.5;
		hud.alpha = .8;
		hud.x = x;
		hud.y = y;
		hud.hidewhendead = 1;
		hud.hidewheninkillcam = 1;

		hud.score = NewClientHudElem( self );

		hud.score.alignX = "left";
		hud.score.alignY = "middle";
		hud.score.foreground = 1;
		hud.score.fontScale = 1.5;
		hud.score.alpha = .8;
		hud.score.x = x + 125;
		hud.score.y = y;
		hud.score.hidewhendead = 1;
		hud.score.hidewheninkillcam = 1;
		
		self.bwars_hud[ self.bwars_hud.size ] = hud;

		y += 15;
	}

	level bwars_scoreboard_update();
}

function player_hud_update( names, scores )
{
	if ( !isdefined( self.bwars_hud ) )
	{
		return;
	}

	for( i = 0; i < 4; i++ )
	{
		self.bwars_hud[i] SetText( names[i] );

		if ( names[i] == "" )
		{
			self.bwars_hud[i].score SetText( "" );
		}
		else
		{
			self.bwars_hud[i].score SetValue( scores[i] );
		}

		if ( names[i] == self.name )
		{
			self.bwars_hud[i].color = ( 1, 0.84, 0 );
			self.bwars_hud[i].score.color = ( 1, 0.84, 0 );
		}
		else
		{
			self.bwars_hud[i].color = ( 1, 1, 1 );
			self.bwars_hud[i].score.color = ( 1, 1, 1 );
		}
	}
}

function bubblesort_players()
{
	players = GetPlayers();

	while( true )
	{
		swapped = false;
		
		for ( i = 1; i < players.size; i++ )
		{
			if ( players[i-1].score < players[i].score )
			{
				t = players[i-1];
				players[i-1] = players[i];
				players[i] = t;

				swapped = true;
			}
		}

		if ( !swapped )
		{
			break;
		}
	}

	return players;
}

function bwars_scoreboard_update()
{
	names = [];
	scores = [];

	players = bubblesort_players();

	for( i = 0; i < 4; i++ )
	{
		if ( players.size > i )
		{
			names[i] = players[i].name;
			scores[i] = players[i].score;
		}
		else
		{
			names[i] = "";
			scores[i] = -1;
		}
	}

	foreach( player in players )
	{
		player player_hud_update( names, scores );
	}
}

function flag_model_init()
{
	visuals = [];

	visuals[0] = spawn( "script_model", self.origin );
	visuals[0].angles = self.angles;
	visuals[0] SetModel( "p7_mp_flag_neutral" );
	visuals[0] SetInvisibleToAll();
	
	visuals[1] = spawn( "script_model", self.origin );
	visuals[1].angles = self.angles;
	visuals[1] SetModel( "p7_mp_flag_neutral" );
	visuals[1] SetVisibleToAll();

	return visuals;
}

function flag_model_update()
{
	owner = self gameobjects::get_owner_team();

	self.visuals[0] SetModel( "p7_mp_flag_allies" );
	self.visuals[0] SetInvisibleToAll();
	self.visuals[0] SetVisibleToPlayer( owner );
	
	self.visuals[1] SetModel( "p7_mp_flag_axis" );
	self.visuals[1] SetVisibleToAll();
	self.visuals[1] SetInvisibleToPlayer( owner );
}

function flag_compass_init()
{
	self.compass_icons = [];
	self.compass_icons[ 0 ] = gameobjects::get_next_obj_id();
	self.compass_icons[ 1 ] = gameobjects::get_next_obj_id();

	label = self gameobjects::get_label();

	Objective_Add( self.compass_icons[ 0 ], "active", self.curOrigin );
	Objective_Icon( self.compass_icons[ 0 ], "compass_waypoint_defend" + label );
	Objective_SetInvisibleToAll( self.compass_icons[ 0 ] );

	Objective_Add( self.compass_icons[ 1 ], "active", self.curOrigin );
	Objective_Icon( self.compass_icons[ 1 ], "compass_waypoint_captureneutral" + label );
	Objective_SetVisibleToAll( self.compass_icons[ 1 ] );
}

function flag_compass_update()
{
	label = self gameobjects::get_label();
	owner = self gameobjects::get_owner_team();

	Objective_Icon( self.compass_icons[ 0 ], "compass_waypoint_defend" + label );
	Objective_State( self.compass_icons[ 0 ], "active" );
	Objective_SetInvisibleToAll( self.compass_icons[ 0 ] );
	Objective_SetVisibleToPlayer( self.compass_icons[ 0 ], owner );

	Objective_Icon( self.compass_icons[ 1 ], "compass_waypoint_capture" + label );
	Objective_State( self.compass_icons[ 1 ], "active" );
	Objective_SetVisibleToAll( self.compass_icons[ 1 ] );
	Objective_SetInvisibleToPlayer( self.compass_icons[ 1 ], owner );
}

function player_world_icon_init()
{
	if ( isdefined( self.bwars_icons ) )
	{
		return;
	}

	self.bwars_icons = [];

	foreach( flag in level.bwars_flags )
	{
		icon = NewClientHudElem( self );

		icon.flag = flag;
		icon.x = flag.curOrigin[0];
		icon.y = flag.curOrigin[1];
		icon.z = flag.curOrigin[2] + 100;
		icon.fadeWhenTargeted = true;
		icon.archived = false;
		icon.alpha = 1;

		self.bwars_icons[ self.bwars_icons.size ] = icon;
	}

	self player_world_icon_update();
}

function player_world_icon_update()
{
	assert( isdefined( self.bwars_icons ) );

	foreach( icon in self.bwars_icons )
	{
		label = icon.flag gameobjects::get_label();
		owner = icon.flag gameobjects::get_owner_team();

		if ( IsString( owner ) && owner == "neutral" )
		{
			icon SetWaypoint( true, "waypoint_captureneutral" + label );
		}
		else if ( owner == self )
		{
			icon SetWaypoint( true, "waypoint_defend" + label );
		}
		else
		{
			icon SetWaypoint( true, "waypoint_capture" + label );
		}
	}
}

function world_icon_update()
{
	players = GetPlayers();

	foreach( player in players )
	{
		player player_world_icon_update();
	}
}

function getUnownedFlagNearestStart( team, excludeFlag )
{
	best = undefined;
	bestdistsq = undefined;
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag = level.flags[i];
		
		if ( flag getFlagTeam() != "neutral" )
			continue;
		
		distsq = distanceSquared( flag.origin, level.startPos[team] );
		if ( (!isdefined( excludeFlag ) || flag != excludeFlag) && (!isdefined( best ) || distsq < bestdistsq) )
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}

function onBeginUse( player )
{
}

function onUseUpdate( team, progress, change )
{
}

function statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}

function statusDialogEnemies( dialog, friend_team )
{
	foreach ( team in level.teams )
	{
		if ( team == friend_team )
			continue;
			
		statusDialog( dialog, team );
	}
}

function onEndUse( team, player, success )
{

}


function resetFlagBaseEffect()
{
/*
	// once these get setup we never change them
	if ( isdefined( self.baseeffect ) )
		return;
	
	team = self gameobjects::get_owner_team();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
*/
}

function onUse( player )
{
	self gameobjects::set_owner_team( player );
	self gameobjects::allow_use( "enemy" );

	self flag_compass_update();
	self flag_model_update();
	level world_icon_update();
	level bwars_spawns_update();
		
//	self resetFlagBaseEffect();
	
	//level.useStartSpawns = false;
/*
	string = &"";
	switch ( label ) 
	{
		case "_a":
		string = &"MP_DOM_FLAG_A_CAPTURED_BY";
		break;
		case "_b":
			string = &"MP_DOM_FLAG_B_CAPTURED_BY";
		break;
		case "_c":
			string = &"MP_DOM_FLAG_C_CAPTURED_BY";
		break;
		case "_d":
			string = &"MP_DOM_FLAG_D_CAPTURED_BY";
		break;
		case "_e":
			string = &"MP_DOM_FLAG_E_CAPTURED_BY";
		break;
		default:
		break;
	}
	assert ( string != &"" );
	
	// Copy touch list so there aren't any threading issues
	touchList = [];
	touchKeys = GetArrayKeys( self.touchList[team] );
	for ( i = 0 ; i < touchKeys.size ; i++ )
		touchList[touchKeys[i]] = self.touchList[team][touchKeys[i]];
	thread give_capture_credit( touchList, string );

	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dom_capture", label, team, player.origin );

	if ( oldTeam == "neutral" )
	{
		thread util::printAndSoundOnEveryone( team, undefined, &"", &"", "mp_war_objective_taken", undefined, "" );
		
		thread sound::play_on_players( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{

			statusDialog( "secure_all", team );
			statusDialogEnemies( "lost_all", team );
		}
		else
		{
			statusDialog( "secured"+self.label, team );
			statusDialogEnemies( "lost"+self.label, team );
		}
	}
	else
	{
		thread util::printAndSoundOnEveryone( team, oldTeam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );
		
//		thread delayedLeaderDialogBothTeams( "obj_lost", oldTeam, "obj_taken", team );

//		thread sound::play_on_players( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{

			statusDialog( "secure_all", team );
			statusDialog( "lost_all", oldTeam );
		}
		else
		{	
			statusDialog( "secured"+self.label, team );

			statusDialog( "lost"+self.label, oldTeam );
		}
		
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	}

	if ( dominated_challenge_check() ) 
	{
		challenges::dominated( team );
	}
	self update_spawn_influencers( team );
	level dom::change_dom_spawns();
*/
}

function give_capture_credit( touchList, string )
{
	wait .05;
	util::WaitTillSlowProcessAllowed();
	
	self updateCapsPerMinute();
	
	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		player_from_touchlist updateCapsPerMinute();
		if ( !isScoreBoosting( player_from_touchlist, self ) )
		{
			//scoreevents::processScoreEvent( "position_secure", player_from_touchlist ); TFLAME 8/28 - We shouldn't need this event for bot wars
			if( isdefined(player_from_touchlist.pers["captures"]) )
			{
				player_from_touchlist.pers["captures"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["captures"];
			}

			demo::bookmark( "event", gettime(), player_from_touchlist );
			player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );

		}

		level thread popups::DisplayTeamMessageToAll( string, player_from_touchlist );
	}
}

function delayedLeaderDialog( sound, team )
{
	wait .1;
	util::WaitTillSlowProcessAllowed();
	
	globallogic_audio::leader_dialog( sound, team );
}
function delayedLeaderDialogBothTeams( sound1, team1, sound2, team2 )
{
	wait .1;
	util::WaitTillSlowProcessAllowed();

// Eran: this function is missing.	
//	globallogic_audio::leaderdialogBothTeams( sound1, team1, sound2, team2 );
}


function bwars_update_scores()
{
	while ( !level.gameEnded )
	{
		foreach( flag in level.bwars_flags )
		{
			owner = flag gameobjects::get_owner_team();

			if ( IsPlayer( owner ) )
			{
				owner.score += 1; 
			}
		}

		level bwars_scoreboard_update();
		
		players = GetPlayers();

		foreach( player in players )
		{
			player globallogic::checkScoreLimit();
		}
		
		wait ( 5.0 );
		hostmigration::waitTillHostMigrationDone();
	}
}

function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];

	if ( level.cumulativeRoundScore == false ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	}
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
}

function getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.domFlags[i] gameobjects::get_owner_team() == team )
			score++;
	}	
	return score;
}

function getFlagTeam()
{
	return self.useObj gameobjects::get_owner_team();
}

function getBoundaryFlags()
{
	// get all flags which are adjacent to flags that aren't owned by the same team
	bflags = [];
	for (i = 0; i < level.flags.size; i++)
	{
		for (j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if (level.flags[i].useObj gameobjects::get_owner_team() != level.flags[i].adjflags[j].useObj gameobjects::get_owner_team() )
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	
	return bflags;
}

function getBoundaryFlagSpawns(team)
{
	spawns = [];
	
	bflags = getBoundaryFlags();
	for (i = 0; i < bflags.size; i++)
	{
		if (isdefined(team) && bflags[i] getFlagTeam() != team)
			continue;
		
		for (j = 0; j < bflags[i].nearbyspawns.size; j++)
			spawns[spawns.size] = bflags[i].nearbyspawns[j];
	}
	
	return spawns;
}

function getSpawnsBoundingFlag( avoidflag )
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		flag = level.flags[i];
		if ( flag == avoidflag )
			continue;
		
		isbounding = false;
		for (j = 0; j < flag.adjflags.size; j++)
		{
			if ( flag.adjflags[j] == avoidflag )
			{
				isbounding = true;
				break;
			}
		}
		
		if ( !isbounding )
			continue;
		
		for (j = 0; j < flag.nearbyspawns.size; j++)
			spawns[spawns.size] = flag.nearbyspawns[j];
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team, or that are adjacent to flags owned by the given team.
function getOwnedAndBoundingFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
		else
		{
			for (j = 0; j < level.flags[i].adjflags.size; j++)
			{
				if ( level.flags[i].adjflags[j] getFlagTeam() == team )
				{
					// add spawns near this flag
					for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
						spawns[spawns.size] = level.flags[i].nearbyspawns[s];
					break;
				}
			}
		}
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team
function getOwnedFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
	}
	
	return spawns;
}

function flagSetup()
{
	maperrors = [];
	descriptorsByLinkname = [];

	// (find each flag_descriptor object)
	descriptors = getentarray("flag_descriptor", "targetname");
	
	flags = level.flags;
	
	for (i = 0; i < level.domFlags.size; i++)
	{
		closestdist = undefined;
		closestdesc = undefined;
		for (j = 0; j < descriptors.size; j++)
		{
			dist = distance(flags[i].origin, descriptors[j].origin);
			if (!isdefined(closestdist) || dist < closestdist) {
				closestdist = dist;
				closestdesc = descriptors[j];
			}
		}
		
		if (!isdefined(closestdesc)) {
			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
			break;
		}
		if (isdefined(closestdesc.flag)) {
			maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}
		flags[i].descriptor = closestdesc;
		closestdesc.flag = flags[i];
		descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
	}
	
	if (maperrors.size == 0)
	{
		// find adjacent flags
		for (i = 0; i < flags.size; i++)
		{
			if (isdefined(flags[i].descriptor.script_linkto))
				adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
			else
				adjdescs = [];
			for (j = 0; j < adjdescs.size; j++)
			{
				otherdesc = descriptorsByLinkname[adjdescs[j]];
				if (!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor") {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if (adjflag == flags[i]) {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
					continue;
				}
				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
			}
		}
	}
	
	// assign each spawnpoint to nearest flag
	spawnpoints = spawnlogic::get_spawnpoint_array( "mp_dom_spawn" );
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (isdefined(spawnpoints[i].script_linkto)) {
			desc = descriptorsByLinkname[spawnpoints[i].script_linkto];
			if (!isdefined(desc) || desc.targetname != "flag_descriptor") {
				maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else {
			nearestflag = undefined;
			nearestdist = undefined;
			for (j = 0; j < flags.size; j++)
			{
				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
				if (!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		util::error("Map errors. See above");
		#/
		callback::abort_level();
		
		return;
	}
}

function createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;

	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.domFlags[flag_index] == self )
			break;
	}
	
	// domination: owned flag influencers
	self.owned_flag_influencer = self spawning::create_influencer( "dom_friendly", self.trigger.origin, 0 );
	
	// domination: un-owned inner flag influencers
	self.neutral_flag_influencer = self spawning::create_influencer( "dom_neutral", self.trigger.origin, 0 );
		
	// domination: enemy flag influencers
	self.enemy_flag_influencer = self spawning::create_influencer( "dom_enemy", self.trigger.origin, 0 );
	
	// default it to neutral
	self update_spawn_influencers("neutral");
}

function update_spawn_influencers( team )
{
	assert(isdefined(self.neutral_flag_influencer));
	assert(isdefined(self.owned_flag_influencer));
	assert(isdefined(self.enemy_flag_influencer));
	 
	if ( team == "neutral" )
	{
		EnableInfluencer(self.neutral_flag_influencer, true);
		EnableInfluencer(self.owned_flag_influencer, false);
		EnableInfluencer(self.enemy_flag_influencer, false);
	}
	else
	{
		EnableInfluencer(self.neutral_flag_influencer, false);
		EnableInfluencer(self.owned_flag_influencer, true);
		EnableInfluencer(self.enemy_flag_influencer, true);
	
		SetInfluencerTeammask(self.owned_flag_influencer, util::getTeamMask(team) );
		SetInfluencerTeammask(self.enemy_flag_influencer, util::getOtherTeamsMask(team) );		
	}
}

function bwars_spawns_update()
{
	spawnlogic::clear_spawn_points();	
	spawnlogic::add_spawn_points( "axis", "mp_dom_spawn" );
	spawnlogic::add_spawn_points( "allies", "mp_dom_spawn" );
	
	spawning::updateAllSpawnPoints();
}

function dominated_challenge_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		else
		{
			return false;
		}

		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}
//This function checks to see if one team owns all three flags
function dominated_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		
		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}

function updateCapsPerMinute()
{
	if ( !isdefined( self.capsPerMinute ) )
	{
		self.numCaps = 0;
		self.capsPerMinute = 0;
	}
	
	self.numCaps++;
	
	minutesPassed = globallogic_utils::getTimePassed() / ( 60 * 1000 );
	
	// players use the actual time played
	if ( IsPlayer( self ) && isdefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.capsPerMinute = self.numCaps / minutesPassed;
	if ( self.capsPerMinute > self.numCaps )
		self.capsPerMinute = self.numCaps;
}

function isScoreBoosting( player, flag )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.capsPerMinute > level.playerCaptureLPM )
		return true;
			
	if ( flag.capsPerMinute > level.flagCaptureLPM )
	  return true;
	  
	if ( player.numCaps > level.playerCaptureMax )
		return true;
			
 return false;
}