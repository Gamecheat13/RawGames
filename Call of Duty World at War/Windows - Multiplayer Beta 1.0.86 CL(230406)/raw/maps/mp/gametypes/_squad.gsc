/********************************************************\
 _squad.gsc - Written by Sumeet 4/21/2008 9:52:34 PM       
 														  
1.Squads are only allowed in "ranked team based" matches.   
2.A player has to send an Invite to the other player in
  party to join his squad.
3.There can be multiple squads in one team depending on
  who joined whom in their respective parties.
4.The creator of the party is considered to be the squad
  leader.
5.Squad perks of the leader are only considered, while they
  are beneficial to the squad as a whole.
6.Minimum number of players in squad is "2".
7.Detailed description of the squad perks 
  
TODO:
1.Replace temp compass, waypoints, 3d marker materials - ask Gil.
														  					
\********************************************************/
#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	//Precache the compass objective shaders.
	precacheShader( "compass_squad_attack" );
	
	precacheLocationSelector( "map_squad_command" );
	
	level thread resetSquadCommands();
	level thread onPlayerConnect();

	
}

/*
=============
onPlayerConnect

=============
*/
onPlayerConnect()
{
	level endon ( "game_ended" );

	for( ;; )
	{
		level waittill( "connecting", player );
		
		player thread onPlayerSpawned();
		player thread onDisconnect();
		player thread doSquadInitialNotification();
	}
}

doSquadInitialNotification()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self waittill( "spawned_player" );
	wait( 10.0 );
	
	if ( getplayersquad( self ) )
	{
		if ( issquadleader( self ) )
		{
			self.pers["squadMessage"] = 4;
		}
		else
		{
			self.pers["squadMessage"] = 5;
		}
		self [[level.showsquadinfo]]();
	}
	
}


/*
=============
onPlayerSpawned

=============
*/
onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	for(;;)
	{
		self waittill_any( "spawned_player", "give_map" );
		
		//Set up the squad features
		self setSquadFeatures();
	}
}

/*
=============
setSquadFeatures

=============
*/
setSquadFeatures()
{
	self giveSquadFeatures();
		
	//spawn a squad threader waiting on the player.
	self thread squadCommandWaiter();
	
}


/*
=============
squadCommandWaiter

Wait on the player to press 'UP' on the dpad to access the map
The squad leader will be able to place an objective on the map
This objective will be seen by all of his squad-mates

=============
*/

squadCommandWaiter()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon("death_or_disconnect");
	
	//start death waiter  
	self thread destroyOnDeath();	

	// old weapon
	self.lastWeapon = self getCurrentWeapon();

	for ( ;; )
	{
		self waittill( "weapon_change" );
		
		self.squadId  = getplayersquad( self );
			
		currentWeapon = self getCurrentWeapon();

		if( currentWeapon != "squadcommand_mp" && currentWeapon != "none" && currentWeapon != "artillery_mp" && currentWeapon != "dogs_mp" )
			self.lastWeapon = currentWeapon;
				
		if ( currentWeapon == "squadcommand_mp" )
		{
			// Bring the map up
			self ShowSquadLocationSelectionMap();
			
			// return the last weapon to the player.	
			if ( self.lastWeapon != "none" )
				self switchToWeapon( self.lastWeapon );
		}		
	}
}


/*
=============
giveSquadFeatures

Gives the squad Features items to the player
=============
*/
giveSquadFeatures()
{
	self takeSquadFeatures();
	self SetActionSlot( 1, "weapon","squadcommand_mp" );
	self giveWeapon( "squadcommand_mp" );
}

/*
=============
takeSquadFeatures

Takes the squad features items from the player 
=============
*/

takeSquadFeatures()
{
	self.squadCommandInProgress = undefined;
	self SetActionSlot( 1, "" );

	if ( self hasWeapon("squadcommand_mp") )
		self takeWeapon( "squadcommand_mp" );
}


/*
=============
ShowSquadLocationSelectionMap
Bring the map up
The squad leader will be able to set an objective on the map
The squad members will all be able to see the objective on the compass
=============
*/

ShowSquadLocationSelectionMap()
{
	self beginLocationSelection( "map_squad_command" );
	self.selectingLocation = true;
	self.squadCommandInProgress = true;
	
	self thread endSquadCommandSelectionOn( "cancel_location" );
	self thread endSquadCommandSelectionOn( "death" );
	self thread endSquadCommandSelectionOn( "disconnect" );
	self thread endSquadCommandSelectionOnGameEnd();

	currentWeapon = self getCurrentWeapon();
	
	if (issquadleader( self ))
	{
		self thread endSquadCommandSelectionOn( "used" );

		// Attack/Confirm Command.
		self thread selectConfirmcommand( currentWeapon );
				
		// Clear/Cancel order Command.
		self thread selectClearcommand( currentWeapon );
	}


	self waittill( "stop_location_selection" );
	return true;
}


/*
=============
selectConfirmcommand

When the squad leader pulls up the location selection map these functions are waiting for players command input.

=============
*/

// Attack/Confirm Command.
selectConfirmcommand( currentWeapon )
{
	self endon ("used");	
	self waittill( "confirm_location", location );
	//location is selected, apply the command.
	if ( currentWeapon == "squadcommand_mp" )
		self finishSquadCommandUsage( location,"confirm_location", ::useSquadCommand );
}

// Clear Command.
selectClearcommand( currentWeapon )
{
	self endon ("used");	
	self waittill( "clear_squadcommand", location );
	//location is selected, apply the command.
	if ( currentWeapon == "squadcommand_mp" )
		self finishSquadCommandUsage( location,"clear_squadcommand", ::useSquadCommand );
}


/*
=============
finishSquadCommandUsage

Sets up a callback with the squadcommand and processes that command.
=============
*/
finishSquadCommandUsage( location, command, usedCallback )
{
	self stopSquadCommandLocationSelection( false );
	self [[usedCallback]]( location, command );
	return true;
}

/*
=============
stopSquadCommandLocationSelection

Player has either used or cancelled the command location selection.
=============
*/
stopSquadCommandLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}

	wait( 0.05 );
	self notify( "stop_location_selection" );
}


/*
=============
useSquadCommand

handle the squad command.
=============
*/
useSquadCommand( pos, command )
{
	pos = (pos[0], pos[1], 0.0 );
	
	// handle the squad command - compass objective, obituary.
	self createsquadCommand( pos, command );

	self.squadCommandInProgress = false;		
	self notify( "used" );
	wait(0.05);
}

/*
=============
endSquadCommandSelectionOn
=============
*/
endSquadCommandSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	
	self waittill( waitfor );

	self stopSquadCommandLocationSelection( (waitfor == "disconnect") );
}



/*
=============
endSquadCommandSelectionOnGameEnd
=============
*/
endSquadCommandSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	
	level waittill( "game_ended" );
	
	self stopSquadCommandLocationSelection( false );
}



/*
=============
createSquadCommand
=============
*/
createSquadCommand( pos, command )
{
	squadId = self.squadId;
	

	if ( command == "clear_squadcommand" )
	{
		clear_objective_squad( squadId );
		obituary_squad( self, 11 );
	}
	
	if ( command == "confirm_location" )
	{

		self playVOForSquadCommand();
		objective_squad( pos, squadId );
		obituary_squad( self, 10 );
	}
}


/*
=============
playVOForSquadCommand
=============
*/
playVOForSquadCommand()
{
	playerSquadID = getplayersquadid( self );

	if( isDefined( playerSquadID ) )
	{
		team = self.pers["team"];

		for( i = 0; i < level.squads[team][playerSquadID].size; i++ )
		{
			level.squads[team][playerSquadID][i] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "squad_move" );
		}
	}
}

/*
=============
onDisconnect

=============
*/
onDisconnect()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
}


/*
=============
destroyOnDeath

=============
*/
destroyOnDeath()
{
	self endon( "disconnect" );
	self waittill ( "death" );
	
	// take the features back from the player, it will be given to him again if he has not changed the class.
	self takeSquadFeatures();
}



/*
=============
resetsquadCommands

=============
*/
resetSquadCommands()
{
	
	self waittill ( "squad_disbanded", squadId );
	self endon ( "game_ended" );
	
	clear_objective_squad( squadId );
	
}
