#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_spawner;

/*
 * NOTE: Zombie teams are currently set up as "Allies" and "Team3" since Zombies are technically "Axis"
 * Team Setup will have to change once they properly setup Team functionality.
 * Since feature complete is the current push, team functionality may not properly get in for the deadline
 * This system has a high chance of breaking once they submit proper team functionality
*/

#namespace zm_audio_announcer;

function autoexec __init__sytem__() {     system::register("zm_audio_announcer",&__init__,undefined,undefined);    }

function __init__()
{
	game["zmbdialog"] = [];
	
	game["zmbdialog"]["prefix"] = "vox_zmba";
	
	createVox( "carpenter", "powerup_carpenter" );
	createVox( "insta_kill", "powerup_instakill" );
	createVox( "double_points", "powerup_doublepoints" );
	createVox( "nuke", "powerup_nuke" );
	createVox( "full_ammo", "powerup_maxammo" );
	createVox( "fire_sale", "powerup_firesale" );
	createVox( "minigun", "powerup_death_machine" );
	createVox( "boxmove", "event_magicbox" );
	createVox( "dogstart", "event_dogstart" );
	
	thread init_GameModeSpecificVox( GetDvarString( "ui_gametype" ), GetDvarString( "ui_zm_mapstartlocation" ) );
	
	level.allowZmbAnnouncer = true;
}
function init_GameModeSpecificVox( mode, location )
{
	switch( mode )
	{
		case "zmeat":
			init_MeatVox("meat");
			break;
			
		case "zrace":
			init_RaceVox( "race", location );
			break;
		case "zgrief":
			init_GriefVox("grief");
			break;
		case "zcleansed":
			init_Cleansed( location );
			break;
			
		default:
			init_GameModeCommonVox();
			break;
	}
}
function init_GameModeCommonVox( prefix )
{
	createVox( "rules", "rules", prefix );
	createVox( "countdown", "intro", prefix );
	createVox( "side_switch", "side_switch", prefix );	//TODO
	createVox( "round_win", "win_rd", prefix );
	createVox( "round_lose", "lose_rd", prefix );
	createVox( "round_tied", "tied_rd", prefix );
	createVox( "match_win", "win", prefix );
	createVox( "match_lose", "lose", prefix );
	createVox( "match_tied", "tied", prefix );
}

function init_GriefVox( prefix )
{
	init_GameModeCommonVox(prefix);
	
	createVox("1_player_down","1rivdown",prefix);
	createVox("2_player_down","2rivdown",prefix);
	createVox("3_player_down","3rivdown",prefix);
	createVox("4_player_down","4rivdown",prefix);
	createVox("grief_restarted","restart",prefix);
	createVox("grief_lost","lose",prefix);
	createVox("grief_won","win",prefix);
	
	createVox("1_player_left","1rivup",prefix);
	createVox("2_player_left","2rivup",prefix);
	createVox("3_player_left","3rivup",prefix);
	createVox("last_player","solo",prefix);
	
	
}

function init_Cleansed( prefix )
{
	init_GameModeCommonVox(prefix);
	
	/*

	createVox("dr_start_single_0","dr_start_0");  // Wunderbar news, people! We have something brand new for you to try today!
	createVox("dr_start_2","dr_start_1");                // There is a cure, my friends... But not enough for everybody!
	createVox("dr_start_3","dr_start_2");                // Someone’s got to find it, so the fun starts now!... 

	//createVox("dr_start_line","dr_start_single");
	//createVox("dr_start_b_line","dr_start_single_b");
	createVox("dr_cure_found_line","dr_cure_found");
	createVox("dr_monkey_line","dr_monkey");
	createVox("dr_monkey_killer","dr_monkey_0");
	createVox("dr_monkey_killee","dr_monkey_1");

	createVox("dr_plr_survive_line","dr_plr_survive");
	createVox("dr_zmb_survive_line","dr_zmb_survive");
	createVox("dr_kill_plr_line","dr_kill_plr");
	createVox("dr_time_line","dr_time");

 	*/
	
	createVox("dr_start_single_0","dr_start_0");  // Wunderbar news, people! We have something brand new for you to try today!
	createVox("dr_start_2","dr_start_1");                // There is a cure, my friends... But not enough for everybody!
	createVox("dr_start_3","dr_start_2");                // Someone’s got to find it, so the fun starts now!... 

	createVox("dr_cure_found_line","dr_cure_found");
	createVox("dr_monkey_killer","dr_monkey_0");
	createVox("dr_monkey_killee","dr_monkey_1");

	createVox("dr_human_killed","dr_kill_plr");
	createVox("dr_human_killer","dr_kill_plr_2");

	createVox("dr_survival","dr_plr_survive_0");
	createVox("dr_zurvival","dr_zmb_survive_2");

	createVox("dr_countdown0","dr_plr_survive_1");
	createVox("dr_countdown1","dr_plr_survive_2");
	createVox("dr_countdown2","dr_plr_survive_3");
	createVox("dr_ending","dr_time_0");
	//createVox("dr_ended","anim_intro23");

}

function init_MeatVox( prefix )
{
	init_GameModeCommonVox( prefix );
	
	//MEAT SPECIFIC
	createVox( "meat_drop", "drop", prefix );
	createVox( "meat_grab", "grab", prefix );
	createVox( "meat_grab_A", "team_cdc", prefix );	//Plays when opposite team grabs meat
	createVox( "meat_grab_B", "team_cia", prefix );	//Plays when opposite team grabs meat
	createVox( "meat_land", "land", prefix );
	createVox( "meat_hold", "hold", prefix );
	createVox( "meat_revive_1", "revive1", prefix );
	createVox( "meat_revive_2", "revive2", prefix );
	createVox( "meat_revive_3", "revive3", prefix );
	createVox( "meat_ring_splitter", "ring_tripple", prefix );
	createVox( "meat_ring_minigun", "ring_death", prefix );
	createVox( "meat_ring_ammo", "ring_ammo", prefix );
}
//TOWN, TUNNEL, POWER
function init_RaceVox( prefix, location )
{
	init_GameModeCommonVox( prefix );
	
	//Switch RULES and INTRO based off location, as races in different areas function differently
	switch( location )
	{
		case "tunnel":
			createVox( "rules", "rules_" + location, prefix );
			createVox( "countdown", "intro_" + location, prefix );
			break;
			
		case "power":
			createVox( "rules", "rules_" + location, prefix );
			createVox( "countdown", "intro_" + location, prefix );
			createVox( "lap1", "lap1", prefix );
			createVox( "lap2", "lap2", prefix );
			createVox( "lap_final", "lap_final", prefix );
			break;	
			
		case "farm":
			createVox( "rules", "rules_" + location, prefix );
			createVox( "countdown", "intro_" + location, prefix );
			createVox( "hoop_area", "hoop_area", prefix );
			createVox( "hoop_miss", "hoop_miss", prefix );
			break;	
			
		default:
			break;
	}
	
	createVox( "race_room_2_ally", "room2_ally", prefix );
	createVox( "race_room_3_ally", "room3_ally", prefix );
	createVox( "race_room_4_ally", "room4_ally", prefix );
	createVox( "race_room_5_ally", "room5_ally", prefix );
	createVox( "race_room_2_axis", "room2_axis", prefix );
	createVox( "race_room_3_axis", "room3_axis", prefix );
	createVox( "race_room_4_axis", "room4_axis", prefix );
	createVox( "race_room_5_axis", "room5_axis", prefix );
	createVox( "race_ahead_1_ally", "ahead1_ally", prefix );
	createVox( "race_ahead_2_ally", "ahead2_ally", prefix );
	createVox( "race_ahead_3_ally", "ahead3_ally", prefix );
	createVox( "race_ahead_4_ally", "ahead4_ally", prefix );
	createVox( "race_ahead_1_axis", "ahead1_axis", prefix );
	createVox( "race_ahead_2_axis", "ahead2_axis", prefix );
	createVox( "race_ahead_3_axis", "ahead3_axis", prefix );
	createVox( "race_ahead_4_axis", "ahead4_axis", prefix );
	createVox( "race_kill_15", "door15", prefix );	//TODO
	createVox( "race_kill_10", "door10", prefix );	//TODO
	createVox( "race_kill_5", "door5", prefix );	//TODO		
	createVox( "race_kill_3", "door3", prefix );	//TODO
	createVox( "race_kill_1", "door1", prefix );	//TODO
	createVox( "race_door_open", "door_open", prefix );
	createVox( "race_door_nag", "door_nag", prefix );
	createVox( "race_grief_incoming", "grief_income_ammo", prefix );
	createVox( "race_grief_land", "grief_land", prefix );
	createVox( "race_laststand", "last_stand", prefix );	//TODO: Plays when a player goes down, letting them know they'll be revived
}
function createVox( type, alias, gametype )
{
	if( !isdefined( gametype ) )
		gametype = "";
	else
		gametype = gametype + "_";
	
	game["zmbdialog"][type] = gametype + alias;
}

function announceRoundWinner( winner, delay )
{
	if ( isdefined( delay ) && delay > 0 )
		wait delay;

	if ( !isdefined( winner ) || isPlayer( winner ) )
		return;
	
	if( winner != "tied" )
	{
		players = GetPlayers();
		foreach( player in players )
		{
			if( isdefined( player._encounters_team ) && player._encounters_team == winner )
			{
				winning_team = player.pers["team"];
				break;
			}
		}
	
		losing_team = getOtherTeam( winning_team );

		leaderDialog( "round_win", winning_team, undefined, true );
		leaderDialog( "round_lose", losing_team, undefined, true );
	}
	else
	{
		leaderDialog( "round_tied", undefined, undefined, true );
	}
}

function announceMatchWinner( winner, delay )
{
	if ( isdefined( delay ) && delay > 0 )
		wait delay;

	if ( !isdefined( winner ) || isPlayer( winner ) )
		return;
	
	if( winner != "tied" )
	{
		players = GetPlayers();
		foreach( player in players )
		{
			if( isdefined( player._encounters_team ) && player._encounters_team == winner )
			{
				winning_team = player.pers["team"];
				break;
			}
		}
	
		losing_team = getOtherTeam( winning_team );

		leaderDialog( "match_win", winning_team, undefined, true );
		leaderDialog( "match_lose", losing_team, undefined, true );
	}
	else
	{
		leaderDialog( "match_tied", undefined, undefined, true );
	}
}

function announceGamemodeRules()
{
	//TODO: Add in check to see if ANY players have not played this mode; if so, play the rules. If everyone has played before, no rules
	
	if( GetDvarString( "ui_zm_mapstartlocation" ) == "town" )
		leaderDialog( "rules", undefined, undefined, undefined, 20 );

	//DELAY START OF GAME BY 19 SECONDS
	//wait(19);
}

function leaderDialog( dialog, team, group, queue, waittime )
{
	assert( isdefined( level.players ) );
		
	if ( !isdefined( team ) )
	{
		leaderDialogBothTeams( dialog, "allies", dialog, "axis", group, queue, waittime );
		return;
	}
	
	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog, group, queue, waittime );
		return;
	}
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isdefined( player.pers["team"] ) && ( player.pers["team"] == team ) )
			player leaderDialogOnPlayer( dialog, group, queue, waittime );
	}
}

function leaderDialogBothTeams( dialog1, team1, dialog2, team2, group, queue, waittime )
{
	assert( isdefined( level.players ) );
	
	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog1, group, queue, waittime );
		return;
	}

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
			
		if ( !isdefined( team ) )
			continue;
			
		if ( team == team1 )
			player leaderDialogOnPlayer( dialog1, group, queue, waittime );
		else if ( team == team2 )
			player leaderDialogOnPlayer( dialog2, group, queue, waittime );
	}
}


function leaderDialogOnPlayer( dialog, group, queue, waittime )
{
	team = self.pers["team"];

	if ( !isdefined( team ) )
		return;
	
		return;
	
	if ( team != "allies" && team != "axis" )
		return;
	
	if ( isdefined( group ) )
	{
		// ignore the message if one from the same group is already playing
		if ( self.zmbDialogGroup == group )
			return;

		hadGroupDialog = isdefined( self.zmbDialogGroups[group] );

		self.zmbDialogGroups[group] = dialog;
		dialog = group;		
		
		// exit because the "group" dialog call is already in the queue
		if ( hadGroupDialog )
			return;
	}

	if ( !self.zmbDialogActive )
		self thread playLeaderDialogOnPlayer( dialog, team, waittime );
	else if( ( isdefined( queue ) && queue ) )
		self.zmbDialogQueue[self.zmbDialogQueue.size] = dialog;
}


function playLeaderDialogOnPlayer( dialog, team, waittime )
{
	self endon ( "disconnect" );
	
	if( level.allowZmbAnnouncer )
	{
		if ( !isdefined( game[ "zmbdialog" ][ dialog ] ) )
	    {
			/#
		    if( GetDvarInt( "debug_audio" ) > 0 )
		        PrintLn( "DIALOG DEBUGGER: No VOX created for - " + dialog );
		    #/
			
			return;
	    }
	}

	self.zmbDialogActive = true;
	if ( isdefined( self.zmbDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.zmbDialogGroups[group];
		self.zmbDialogGroups[group] = undefined;
		self.zmbDialogGroup = group;
	}

	if( level.allowZmbAnnouncer )
	{
		alias = game["zmbdialog"]["prefix"] + "_" + game["zmbdialog"][dialog];
		variant = self getLeaderDialogVariant( alias );
		
		if( !isdefined( variant ) )
			full_alias = alias;
		else
			full_alias = alias + "_" + variant;
		//iprintlnbold( "ZMBANN ALIAS:  " + full_alias );
		self playLocalSound( full_alias );
	}
	
	if( isdefined( waittime ) )
		wait( waittime );
	else
		wait ( 4.0 );
	
	self.zmbDialogActive = false;
	self.zmbDialogGroup = "";

	if ( self.zmbDialogQueue.size > 0 && level.allowZmbAnnouncer )
	{
		nextDialog = self.zmbDialogQueue[0];
		
		for ( i = 1; i < self.zmbDialogQueue.size; i++ )
			self.zmbDialogQueue[i-1] = self.zmbDialogQueue[i];
		self.zmbDialogQueue[i-1] = undefined;
		
		self thread playLeaderDialogOnPlayer( nextDialog, team );
	}
}

function getLeaderDialogVariant( alias )
{
	if( !isdefined( alias ) )
		return;
	
	if( !isdefined ( level.announcer_dialog ) )
	{
		level.announcer_dialog = [];
		level.announcer_dialog_available = [];
	}
				
	num_variants = zm_spawner::get_number_variants( alias );      
		
	if( num_variants <= 0 )
	{
		/#
		if( GetDvarInt( "debug_audio" ) > 0 )
		    PrintLn( "DIALOG DEBUGGER: No variants found for - " + alias );
		#/
		return undefined;
	}
		
	for( i = 0; i < num_variants; i++ )
	{
		level.announcer_dialog[ alias ][ i ] = i;     
	}	
		
	level.announcer_dialog_available[ alias ] = [];
	
	if( level.announcer_dialog_available[ alias ].size <= 0 )
	{
		level.announcer_dialog_available[ alias ] = level.announcer_dialog[ alias ];
	}
  
	variation = array::random( level.announcer_dialog_available[ alias ] );
	level.announcer_dialog_available[ alias ] = ArrayRemoveValue( level.announcer_dialog_available[ alias ], variation );
    
    return( variation );
}

function getRoundSwitchDialog( switchType )
{
	switch( switchType )
	{
		case "halftime":
			return "halftime";
		case "overtime":
			return "overtime";
		default:
			return "side_switch";
	}
}

function getOtherTeam( team )
{
	if( team == "allies" )
		return "axis";
	else
		return "allies";
}
