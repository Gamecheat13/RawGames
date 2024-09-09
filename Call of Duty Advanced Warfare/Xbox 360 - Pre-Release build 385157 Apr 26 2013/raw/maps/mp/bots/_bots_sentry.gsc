#include common_scripts\utility;
#include maps\mp\bots\_bots_strategy;

//========================================================
//			bot_killstreak_sentry
//========================================================
bot_killstreak_sentry( killstreak_info )
{
	self endon( "bot_sentry_exited" );
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	wait( RandomIntRange( 3, 5 ) );
	
	while ( IsDefined( self.sentry_place_delay ) && GetTime() < self.sentry_place_delay )
	{
		wait 1;
	}

	if ( IsDefined( self.enemy ) && (self.enemy.health > 0) && (self BotCanSeeEntity( self.enemy )) )
		return;
	
	// Choose sentry targeting position
	targetPoint = bot_sentry_choose_target( killstreak_info );

	if ( !IsDefined( targetPoint ) )
		return;
	
	self bot_sentry_add_goal( killstreak_info, targetPoint );
}

bot_sentry_add_goal( killstreak_info, targetOrigin )
{
	placement = self bot_sentry_choose_placement( killstreak_info, targetOrigin );
	
	if ( IsDefined( placement ) )
	{
		self bot_abort_tactical_goal( "sentry_placement" );
		
		extra_params = SpawnStruct();
		extra_params.object = placement;
		extra_params.script_goal_yaw = placement.yaw;
		extra_params.script_goal_radius = 10;
		extra_params.start_thread = ::bot_sentry_path_start;
		extra_params.end_thread = ::bot_sentry_cancel;
		extra_params.should_abort = ::bot_sentry_should_abort;
		extra_params.action_thread = ::bot_sentry_activate;
		self bot_new_tactical_goal( "sentry_placement", placement.node.origin, 0, extra_params );
	}
}

bot_sentry_should_abort( tactical_goal )
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if ( IsDefined( self.enemy ) && (self.enemy.health > 0) && (self BotCanSeeEntity( self.enemy )) )
		return true;

	// As long as we are actively doing a sentry placement, dont start a new one
	self.sentry_place_delay = GetTime() + 1000;
	
	return false;
}

bot_sentry_path_start( tactical_goal )
{
	self thread bot_sentry_path_thread( tactical_goal );
}

bot_sentry_path_thread( tactical_goal )
{
	self endon( "stop_tactical_goal" );
	self endon( "bot_sentry_exited" );
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	// Switch to sentry when we are near goal
	while ( IsDefined( tactical_goal.object ) && IsDefined( tactical_goal.object.weapon ) )
	{
		if ( Distance2D( self.origin, tactical_goal.object.node.origin ) < 400 )
		{
			self SwitchToWeapon( tactical_goal.object.weapon );
			return;
		}
		wait 0.05;
	}
}

bot_sentry_choose_target( killstreak_info )
{
	// Protect my current defending goal point if I have one
	if ( IsDefined( self.bot_defending_center ) )
		return self.bot_defending_center;
	
	// Protect my current ambushing spot if I have one
	if ( IsDefined( self.node_ambushing_from ) )
		return self.node_ambushing_from.origin;
	
	// Otherwise just return the highest traffic node around me
	nodes = GetNodesInRadius( self.origin, 1000, 0, 512 );
	if ( killstreak_info.streakname == "sam_turret" )
		targetNode = self BotNodePick( nodes, 5, "node_traffic", "ignore_no_sky" );	
	else
		targetNode = self BotNodePick( nodes, 5, "node_traffic" );	
	if ( IsDefined( targetNode ) )
		return targetNode.origin;
}

bot_sentry_choose_placement( killstreak_info, targetOrigin )
{
	placement = undefined;
	
	nodes = GetNodesInRadius( targetOrigin, 1000, 0, 512 );
	if ( killstreak_info.streakname == "sam_turret" )
		placeNode = self BotNodePick( nodes, 5, "node_sentry", targetOrigin, "ignore_no_sky" );	
	else
		placeNode = self BotNodePick( nodes, 5, "node_sentry", targetOrigin );	
	
	if ( IsDefined( placeNode ) )
	{
		placement = SpawnStruct();
		placement.node = placeNode;
		placement.yaw = VectorToYaw(targetOrigin - placeNode.origin);
		placement.weapon = killstreak_info.weapon;
	}
	
	return placement;
}

bot_sentry_activate( tactical_goal )
{
	result = false;
	
	// Place the sentry if it can be placed here, otherwise cancel out of carrying it around
	if ( IsDefined( self.carriedsentry ) )
	{
		abort = false;

		if ( !self.carriedsentry.canBePlaced )
		{
			// Bot cannot currently place the turret, move away from obstruction
			time_to_try = 0.75;
			start_time = GetTime();
			
			moveYaws = [];
			moveYaws[0] = tactical_goal.object.yaw + 180;
			moveYaws[1] = tactical_goal.object.yaw + 135;
			moveYaws[2] = tactical_goal.object.yaw - 135;

			minDist = 1000;
			foreach ( moveYaw in moveYaws )
			{
				hitPos = PlayerPhysicsTrace( tactical_goal.object.node.origin, tactical_goal.object.node.origin + AnglesToForward( (0, moveYaw + 180, 0) ) * 100 );
				dist = Distance2D( hitpos, tactical_goal.object.node.origin );
				if ( dist < minDist )
				{
					minDist = dist;
					self BotSetScriptMove( moveYaw, time_to_try );
					self BotLookAtPoint( tactical_goal.object.node.origin, time_to_try, "script_forced" );
				}
			}
			
			while( !abort && IsDefined( self.carriedsentry ) && !self.carriedsentry.canBePlaced )
			{
				wait 0.05;
				time_waited = float(GetTime() - start_time) / 1000.0;
				if ( !self.carriedsentry.canBePlaced && (time_waited > time_to_try) )
				{
					abort = true;
					
					// wait a while before attempting another sentry placement
					self.sentry_place_delay = GetTime() + 30000;
				}
			}	
		}
		
		if ( IsDefined( self.carriedsentry ) && self.carriedsentry.canBePlaced )
		{
			self notify( "place_sentry" );
			result = true;
		}
	}
	
	wait 0.25;
	self bot_sentry_ensure_exit();
	
	return result;
}

bot_sentry_cancel( tactical_goal )
{
	// Cancel the sentry
	self notify( "cancel_sentry" );

	self bot_sentry_ensure_exit();
}

bot_sentry_ensure_exit()
{
	self notify( "bot_sentry_abort_goal_think" );
	self notify( "bot_sentry_ensure_exit" );

	self endon( "bot_sentry_ensure_exit" );
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	self BotClearScriptGoal();
	wait 0.25;
			
	attempts = 0;
	while ( IsDefined( self.carriedsentry ) )
	{
		attempts++;
		
		self notify( "cancel_sentry" );
		wait 0.25;

		if ( attempts > 2 )
			self bot_sentry_force_cancel();
	}

	self enableWeapons();
	self enableWeaponSwitch();

	self notify( "bot_sentry_exited" );
}

bot_sentry_force_cancel()
{
	if ( IsDefined( self.carriedsentry ) )
	{
		self.carriedsentry maps\mp\killstreaks\_autosentry::sentry_setCancelled();
	}
	self.carriedsentry = undefined;
	self enableWeapons();
	self enableWeaponSwitch();
}



