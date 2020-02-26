#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_weapons; 

/*
 * NOTE: Zombie teams are currently set up as "Allies" and "Team3" since Zombies are technically "Axis"
 * Team Setup will have to change once they properly setup Team functionality.
 * Since feature complete is the current push, team functionality may not properly get in for the deadline
 * This system has a high chance of breaking once they submit proper team functionality
*/

init()
{
	game["zmbdialog"] = [];
	
	game["zmbdialog"]["prefix"] = "vox_zmba_";
	
	//COMMON
	game["zmbdialog"]["rules"] = "rules";
	game["zmbdialog"]["countdown"] = "intro";
	game["zmbdialog"]["side_switch"] = "side_switch";	//TODO
	game["zmbdialog"]["round_win"] = "win_rd";
	game["zmbdialog"]["round_lose"] = "lose_rd";
	game["zmbdialog"]["round_tied"] = "tied_rd";
	game["zmbdialog"]["match_win"] = "win";
	game["zmbdialog"]["match_lose"] = "lose";
	game["zmbdialog"]["match_tied"] = "tied";
	
	//MEAT
	game["zmbdialog"]["meat_drop"] = "drop";
	game["zmbdialog"]["meat_grab"] = "grab";
	game["zmbdialog"]["meat_grab_A"] = "team_cdc";	//Plays when opposite team grabs meat
	game["zmbdialog"]["meat_grab_B"] = "team_cia";	//Plays when opposite team grabs meat
	game["zmbdialog"]["meat_land"] = "land";
	game["zmbdialog"]["meat_hold"] = "hold";
	game["zmbdialog"]["meat_ally_barb"] = "ally_barb";	//TODO
	game["zmbdialog"]["meat_ally_bank"] = "ally_bank";	//TODO
	game["zmbdialog"]["meat_ally_bar"] = "ally_bar";	//TODO
	game["zmbdialog"]["meat_ally_upbarb"] = "ally_upbarb";	//TODO
	game["zmbdialog"]["meat_ally_upbar"] = "ally_upbar";	//TODO
	game["zmbdialog"]["meat_ally_laun"] = "ally_laun";	//TODO
	game["zmbdialog"]["meat_axis_barb"] = "axis_barb";	//TODO
	game["zmbdialog"]["meat_axis_bank"] = "axis_bank";	//TODO
	game["zmbdialog"]["meat_axis_bar"] = "axis_bar";	//TODO
	game["zmbdialog"]["meat_axis_upbarb"] = "axis_upbarb";	//TODO
	game["zmbdialog"]["meat_axis_upbar"] = "axis_upbar";	//TODO
	game["zmbdialog"]["meat_axis_laun"] = "axis_laun";	//TODO
	game["zmbdialog"]["meat_revive_1"] = "revive1";
	game["zmbdialog"]["meat_revive_2"] = "revive2";
	game["zmbdialog"]["meat_revive_3"] = "revive3";
	game["zmbdialog"]["meat_ring_splitter"] = "ring_tripple";
	game["zmbdialog"]["meat_ring_minigun"] = "ring_death";
	game["zmbdialog"]["meat_ring_ammo"] = "ring_ammo";
	
	//RACE
	game["zmbdialog"]["race_room_2_ally"] = "room2_ally";
	game["zmbdialog"]["race_room_3_ally"] = "room3_ally";
	game["zmbdialog"]["race_room_4_ally"] = "room4_ally";
	game["zmbdialog"]["race_room_5_ally"] = "room5_ally";
	game["zmbdialog"]["race_room_2_axis"] = "room2_axis";
	game["zmbdialog"]["race_room_3_axis"] = "room3_axis";
	game["zmbdialog"]["race_room_4_axis"] = "room4_axis";
	game["zmbdialog"]["race_room_5_axis"] = "room5_axis";
	game["zmbdialog"]["race_ahead_1_ally"] = "ahead1_ally";
	game["zmbdialog"]["race_ahead_2_ally"] = "ahead2_ally";
	game["zmbdialog"]["race_ahead_3_ally"] = "ahead3_ally";
	game["zmbdialog"]["race_ahead_4_ally"] = "ahead4_ally";
	game["zmbdialog"]["race_ahead_1_axis"] = "ahead1_axis";
	game["zmbdialog"]["race_ahead_2_axis"] = "ahead2_axis";
	game["zmbdialog"]["race_ahead_3_axis"] = "ahead3_axis";
	game["zmbdialog"]["race_ahead_4_axis"] = "ahead4_axis";
	game["zmbdialog"]["race_kill_15"] = "door15";	//TODO
	game["zmbdialog"]["race_kill_10"] = "door10";	//TODO
	game["zmbdialog"]["race_kill_5"] = "door5";	//TODO
	game["zmbdialog"]["race_kill_3"] = "door3";	//TODO
	game["zmbdialog"]["race_kill_1"] = "door1";	//TODO
	game["zmbdialog"]["race_door_open"] = "door_open";
	game["zmbdialog"]["race_door_nag"] = "door_nag";
	game["zmbdialog"]["race_grief_incoming"] = "grief_income_ammo";
	game["zmbdialog"]["race_grief_land"] = "grief_land";
	game["zmbdialog"]["race_laststand"] = "last_stand";	//TODO: Plays when a player goes down, letting them know they'll be revived
	
	level.allowZmbAnnouncer = true;
	
	if( !gametype_is_supported( GetDvar( "ui_gametype" ) ) )
		level.allowZmbAnnouncer = false;	
}

announceRoundWinner( winner, delay )
{
	if ( isdefined( delay ) && delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "A" )
	{
		leaderDialog( "round_win", "A", undefined, true );
		leaderDialog( "round_lose", "B", undefined, true );
	}
	else if ( winner == "B" )
	{
		leaderDialog( "round_win", "B", undefined, true );
		leaderDialog( "round_lose", "A", undefined, true );
	}
	else
	{
		leaderDialog( "round_tied", undefined, undefined, true );
	}
}

announceMatchWinner( winner, delay )
{
	if ( isdefined( delay ) && delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "A" )
	{
		leaderDialog( "match_win", "A", undefined, true );
		leaderDialog( "match_lose", "B", undefined, true );
	}
	else if ( winner == "B" )
	{
		leaderDialog( "match_win", "B", undefined, true );
		leaderDialog( "match_lose", "A", undefined, true );
	}
	else
	{
		leaderDialog( "match_tied", undefined, true );
	}
}

announceGamemodeRules()
{
	//TODO: Add in check to see if ANY players have not played this mode; if so, play the rules. If everyone has played before, no rules
	leaderDialog( "rules", undefined, undefined, undefined, 20 );
	//DELAY START OF GAME BY 19 SECONDS
	//wait(19);
}

leaderDialog( dialog, team, group, queue, waittime )
{
	assert( isdefined( level.players ) );
		
	if ( level.splitscreen )
		return;
		
	if ( !isDefined( team ) )
	{
		leaderDialogBothTeams( dialog, "A", dialog, "B", group, queue, waittime );
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
		if ( isDefined( player._encounters_team ) && (player._encounters_team == team ) )
			player leaderDialogOnPlayer( dialog, group, queue, waittime );
	}
}

leaderDialogBothTeams( dialog1, team1, dialog2, team2, group, queue, waittime )
{
	assert( isdefined( level.players ) );
	
	if ( level.splitscreen )
		return;

	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog1, group, queue, waittime );
		return;
	}

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player._encounters_team;
			
		if ( !isDefined( team ) )
			continue;
			
		if ( team == team1 )
			player leaderDialogOnPlayer( dialog1, group, queue, waittime );
		else if ( team == team2 )
			player leaderDialogOnPlayer( dialog2, group, queue, waittime );
	}
}


leaderDialogOnPlayer( dialog, group, queue, waittime )
{
	team = self._encounters_team;

	if ( level.splitscreen )
		return;
	
	if ( !isDefined( team ) )
		return;
	
	if ( team != "A" && team != "B" )
		return;
	
	if ( isDefined( group ) )
	{
		// ignore the message if one from the same group is already playing
		if ( self.zmbDialogGroup == group )
			return;

		hadGroupDialog = isDefined( self.zmbDialogGroups[group] );

		self.zmbDialogGroups[group] = dialog;
		dialog = group;		
		
		// exit because the "group" dialog call is already in the queue
		if ( hadGroupDialog )
			return;
	}

	if ( !self.zmbDialogActive )
		self thread playLeaderDialogOnPlayer( dialog, team, waittime );
	else if( is_true( queue ) )
		self.zmbDialogQueue[self.zmbDialogQueue.size] = dialog;
}


playLeaderDialogOnPlayer( dialog, team, waittime )
{
	self endon ( "disconnect" );
	
	self.zmbDialogActive = true;
	if ( isDefined( self.zmbDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.zmbDialogGroups[group];
		self.zmbDialogGroups[group] = undefined;
		self.zmbDialogGroup = group;
	}

	if( level.allowZmbAnnouncer )
	{
		gametype = getLeaderDialogGametype();
		alias = game["zmbdialog"]["prefix"] + gametype + "_" + game["zmbdialog"][dialog];
		variant = self getLeaderDialogVariant( alias );
		
		if( !isdefined( variant ) )
			variant = 0;
		
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

	if ( self.zmbDialogQueue.size > 0 )
	{
		nextDialog = self.zmbDialogQueue[0];
		
		for ( i = 1; i < self.zmbDialogQueue.size; i++ )
			self.zmbDialogQueue[i-1] = self.zmbDialogQueue[i];
		self.zmbDialogQueue[i-1] = undefined;
		
		self thread playLeaderDialogOnPlayer( nextDialog, team );
	}
}

getLeaderDialogVariant( alias )
{
	if( !isdefined( alias ) )
		return;
	
	if( !IsDefined ( level.announcer_dialog ) )
	{
		level.announcer_dialog = [];
		level.announcer_dialog_available = [];
	}
				
	num_variants = maps\mp\zombies\_zm_spawner::get_number_variants( alias );      
		
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
  
	variation = random( level.announcer_dialog_available[ alias ] );
	level.announcer_dialog_available[ alias ] = ArrayRemoveValue( level.announcer_dialog_available[ alias ], variation );
    
    return( variation );
}

getLeaderDialogGametype()
{
	switch( GetDvar( "ui_gametype" ) )
	{
		case "zmeat":
			return "meat";
			break;
		
		case "zrace":
			return "race";
			break;
			
		default:
			return "meat";
			break;
	}
}
gametype_is_supported( gametype )
{
	switch( gametype )
	{
		case "zmeat":
			return true;
			break;
		
		case "zrace":
			return true;
			break;
			
		default:
			return false;
			break;
	}
}

play_2d_on_team( alias, team )
{
	assert( isdefined( level.players ) );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && (player.pers["team"] == team ) )
		{
			player playLocalSound( alias );
		}	
	}
}

getRoundSwitchDialog( switchType )
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

getOtherTeam( team )
{
	if( team == "A" )
		return "B";
	else
		return "A";
}