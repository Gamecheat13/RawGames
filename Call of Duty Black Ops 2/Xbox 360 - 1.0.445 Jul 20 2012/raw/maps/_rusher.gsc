/*
 * Feature Rusher
 *
 * Implementation: Sumeet Jakatdar
 *	
 * 
*/

// --------------------------------------------------------------------------------
// ---- Global TODO list ----
// --------------------------------------------------------------------------------


#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\anims_table;
#include animscripts\anims_table_rusher;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree( "generic_human" );
// ---------------------------------------------------------------------------------
// ---- inits rusher behavior, supposed to be called in the level main function ----
// ---------------------------------------------------------------------------------

init_rusher()
{
	// Constants
	level.RUSHER_DEFAULT_GOALRADIUS    = 64;
	level.RUSHER_DEFAULT_PATHENEMYDIST = 200;
	level.RUSHER_PISTOL_PATHENEMYDIST  = 300;
}

// ---------------------------------------------------------------------------------
// ---- Called by the level scripter, guy starts rushing towards the player ----
// ---------------------------------------------------------------------------------

rush( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;

	// if this guy is a rusher already dont do this again
	if( IsDefined( self.rusher ) )
		return;

	// tell everyone that he is a rusher
	self.rusher = true;
	
	// set the rusher type
	self set_rusher_type();
	
	if( ISCQB(self) )
		disable_cqb();
	
	self.a.neverSprintForVariation = true;
	self.noHeatAnims = true;
	self.disableReact = true;
	self disable_tactical_walk();
	
	// set rusher specific animations
	self setup_rusher_anims();

	// modify the goalradius of the AI so that he closes in to the player
	self.oldgoalradius 		= self.goalradius;
	self.goalradius    		= level.RUSHER_DEFAULT_GOALRADIUS;

	// don't want the pistol rusher to get close enough to melee
	if( self.rusherType == "pistol" )
	{
		// set the path enemy distance
		self.a.fakePistolWeaponAnims = true;
		self.oldpathenemyFightdist	= self.pathenemyFightdist;
		self.pathenemyFightdist = level.RUSHER_PISTOL_PATHENEMYDIST;
	}
	else
	{
		// set the path enemy distance
		self.oldpathenemyFightdist	= self.pathenemyFightdist;
		self.pathenemyFightdist = level.RUSHER_DEFAULT_PATHENEMYDIST;

		// disable exits and arrivals
		self.disableExits = true;
		self.disableArrivals = true;
	}

	// dont react to the player anymore.	
	self disable_react();

	// ignore suppression, so that this AI will not stop if shot
	self.ignoresuppression = true;

	// give this AI more health
	self.health = self.health + 100;
	
	// get the closest player, making it co-op friendly
	player = get_closest_player( self.origin );

	// set this player as a favoriteenemy, so we dont pick up a new en enemy
	self.favoriteenemy = player;
	
	// spawn in a goal entity and use that instead of the player
	self.rushing_goalent = Spawn( "script_origin", player.origin );
	self.rushing_goalent LinkTo( player );

	// keep setting the goal entity on the player - so we never loose him.
	self thread keep_rushing_player( /*player*/ );

	// start yelling once in while, so that the player notices
	self thread rusher_yelling();

	// start a thread for wait for going back to normal behavior if needed
	if( IsDefined( endon_flag ) || IsDefined( timeout ) )
	{
		self thread rusher_go_back_to_normal( endon_flag, timeout );
	}
}

rusher_go_back_to_normal( endon_flag, timeout, b_stop_immediately = false )
{
	self endon("death");

	if ( !b_stop_immediately )
	{
		if( IsDefined( timeout ) )
		{
			self thread notifyTimeOut( timeout, false, "stop_rushing_timeout" );
		}
		
		if( !IsDefined( endon_flag ) )
			endon_flag = "nothing"; // this will never be sent
	
		// waittill rushing needs to be stopped
		self waittill_any( endon_flag , "stop_rushing_timeout");
	}

	// stop all the thread that are trying to rush this guy
	self notify("stop_rushing");

	self rusher_reset();
}

rusher_reset()
{
	// reset animations back to normal
	self reset_rusher_anims();

	// this AI is not a rusher anymore
	self.rusher = false;
	
	// rest the goalradius
	self.goalradius	= 	self.oldgoalradius;

	// reset the path enemy distance
	self.pathenemyFightdist = self.oldpathenemyFightdist;

	// move normal speed, SUMEET_TODO - Eventually the actual animation will be faster
	self.moveplaybackrate = 1;

	// enable reacting back again
	self enable_react();

	// get suppressed if fired upon
	self.ignoresuppression = false;

	// enable exits and arrivals
	self.disableExits = false;
	self.disableArrivals = false;

	//delete the goal entity attached to the player so that AI doesnt follow it anymore
	self.rushing_goalent Delete();
}

//PARAMETER CLEANUP
keep_rushing_player( /*player*/ )
{
	self endon("death");
	self endon("stop_rushing");

	while(1)
	{
		// Attack the player
		self SetGoalEntity( self.rushing_goalent );
		self thread notifyTimeOut( 8, true, "timeout" );
		self waittill_any("goal", "timeout");
	}
}	

notifyTimeOut( timeout, endon_goal, notify_string )
{
	self endon ( "death" );
	self endon("stop_rushing");
	
	if( IsDefined( endon_goal ) && endon_goal )
	{
		self endon ( "goal" );
	}
	
	wait ( timeOut );
	
	self notify ( notify_string );
}


rusher_yelling()
{
	self endon("death");
	self endon("stop_rushing");

	if( IsDefined( self.noRusherYell ) && self.noRusherYell )
		return;

	while(1)
	{
		// wait for certain amount of time and play rushing sound_effect	
		// SUMEET_TODO - this should be replaced by DDS/Battlechatter system
		wait( RandomFloatRange( 1, 3 ) );
		self PlaySound ("chr_npc_charge_viet");
	}
}

set_rusher_type()
{
	if( self usingShotgun() )
	{
		self.rusherType			= "shotgun";
				
		self.perfectAim			= 1;
		self.noRusherYell		= true;
		self.noWoundedRushing	= true;
	}
	else if( self usingPistol() )
	{
		self.rusherType			= "pistol";

		self.noRusherYell		= true;
		self.noWoundedRushing	= true;
	}
	else
	{
		self.rusherType			= "default";

		if( self.animType == "spetsnaz" )
		{
			self.noRusherYell		= true;
			self.noWoundedRushing	= true;
		}
	}
}




