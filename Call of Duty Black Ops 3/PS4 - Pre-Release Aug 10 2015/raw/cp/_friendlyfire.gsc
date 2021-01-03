// TODO: Update missionfail() to see if there are other means besides suicide
// TODO: Figure out how many participation points to remove for damaging a friendly

/**
 * Friendly fire Participation system: Friendly fire has an internal scoring system it calls participation points:
	•	Killing enemies gains you participation points (currently 250)
	•	Killing allies costs you participation points (currently 600 for friendly, 900 for civilian)
	•	Damaging a friendly will lose the number of points equal to the amount of damage you do. Damaging enemies does not have the complementary effect.
	•	Over time, your score is linearly “flattened” to zero. (currently 1pt/0.75s)
		o	The idea is that both your perceived productivity (positive score) and detriment (negative score) are lessened as time goes on.
	•	There is an upper bound on points (currently 1000) so no matter how much good you do, doing evil will quickly fail you.
	•	Once you hit the lower bound (currently -1600) you will fail the mission.
	•	Various edge cases are handled but may be out of date
		o	Determines cases for when player is in vehicle (noted on 2010)
		o	Don’t fail the mission if the death was caused by a grenade cooking during autosave
 * 
 * This system is disabled by default
 * 
 * Use TurnBackOn() and TurnOff() to toggle friendly fire. level.friendlyfire is a lie.
 * 
 **/

#using scripts\cp\_util;
#using scripts\shared\load_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\archetype_utility;

  	                                                                                   	                                                                                       
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace friendlyfire;

function autoexec __init__sytem__() {     system::register("friendlyfire",&__init__,undefined,undefined);    }

function __init__()
{
	level.friendlyfirepoints[ "min_participation" ] 	= -1600;		// when the player hits this number of participation points the mission is failed
	level.friendlyfirepoints[ "max_participation" ]		= 1000;		// the player will stop gaining participation points once this number are earned
	level.friendlyfirepoints[ "enemy_kill_points" ]		= 250;		// this many participation points are earned for killing an enemy
	level.friendlyfirepoints[ "friend_kill_points" ]	= -600;	// participation point penalty for killing a friendly
	level.friendlyfirepoints[ "civ_kill_points" ]		= -900;	// participation point penalty for killing a civ
	level.friendlyfirepoints[ "point_loss_interval" ]	= 0.75;	// amount of time a point lasts
	
	//set the damage percentage to cause to friendlies
	level.friendlyfireDamagePercentage = 1;
	
	if ( util::CoopGame() )
	{
		SetDvar( "friendlyfire_enabled", "0" ); 
	}
	
	if(!isdefined(level.friendlyFireDisabled))level.friendlyFireDisabled=false;
	callback::on_connect( &init_player );
	
}
	
// Setup for each player that spawns in, called from _load
function init_player()
{
	assert( isdefined( self ), "Player is undefined" );
	self.participation = 0;
	self thread debug_friendlyfire();
	self thread participation_point_flattenovertime();
}

function debug_log( msg )
{
	/#
	if( GetDvarString( "debug_friendlyfire" ) == "on" )
	{
		IPrintLnBold( msg );
	}
	if( GetDvarString( "debug_friendlyfire_log" ) == "on" )
	{
		println( "FRIENDLY FIRE: " + msg );
	}
	#/
}

// Shows debug output for friendly fire
// self - player
function debug_friendlyfire()
{
/#
	self endon( "disconnect" ); 
	
	
	if( GetDvarString( "debug_friendlyfire" ) == "" )
	{
		SetDvar( "debug_friendlyfire", "off" ); 
	}
	if( GetDvarString( "debug_friendlyfire_log" ) == "" )
	{
		SetDvar( "debug_friendlyfire_log", "off" ); 
	}
	
	fullpts = level.friendlyfirepoints[ "max_participation" ] - level.friendlyfirepoints[ "min_participation" ];	
	lbound = 520;
	rbound = 620;
	ypos = 130;
	bar_width = rbound - lbound;
	
	friendly_fire = NewDebugHudElem(); 
	friendly_fire.fontScale = 3;
	friendly_fire.alignX = "right";
	friendly_fire.alignY = "middle";
	friendly_fire.x = rbound - bar_width * ( level.friendlyfirepoints[ "max_participation" ] / fullpts ) - Log( self.participation ) * friendly_fire.fontScale;
	friendly_fire.y = 100;
	friendly_fire.alpha = 1;
	
	friendly_fire_lower_bound_label = NewDebugHudElem(); 
	friendly_fire_lower_bound_label.fontScale = 1.5;
	friendly_fire_lower_bound_label.alignX = "right";
	friendly_fire_lower_bound_label.alignY = "middle";
	friendly_fire_lower_bound_label.x = lbound - ( ceil( max( Log( abs( level.friendlyfirepoints[ "min_participation" ] ) ) / Log( 10 ), 0) ) - 2 + ( self.participation < 0 ) ) * friendly_fire.fontScale;
	friendly_fire_lower_bound_label.y = ypos;
	friendly_fire_lower_bound_label.alpha = 1;
	friendly_fire_lower_bound_label Setvalue( level.friendlyfirepoints[ "min_participation" ] );
	
	friendly_fire_upper_bound_label = NewDebugHudElem(); 
	friendly_fire_upper_bound_label.fontScale = 1.5;
	friendly_fire_upper_bound_label.alignX = "right";
	friendly_fire_upper_bound_label.alignY = "middle";
	friendly_fire_upper_bound_label.x = rbound + 2 * ( ceil( max( Log( abs( level.friendlyfirepoints[ "max_participation" ] ) ) / Log( 10 ), 0) ) + 2.5 + ( self.participation < 0 ) ) * friendly_fire.fontScale;
	friendly_fire_upper_bound_label.y = ypos;
	friendly_fire_upper_bound_label.alpha = 1;
	friendly_fire_upper_bound_label Setvalue( level.friendlyfirepoints[ "max_participation" ] );
	
	debug_health_bar_bg = NewClientHudElem( self );
	debug_health_bar_bg.alignX = "right";
	debug_health_bar_bg.alignY = "middle";
	debug_health_bar_bg.x = rbound;
	debug_health_bar_bg.y = ypos;
	debug_health_bar_bg.sort = 1;
	debug_health_bar_bg.alpha = 1;
	debug_health_bar_bg.foreground = 1;
	debug_health_bar_bg.color = ( 0.4, 0.4, 0.4 );
	debug_health_bar_bg setshader( "white", bar_width, 9 );
		
	debug_health_bar = NewClientHudElem( self );
	debug_health_bar.alignX = "right";
	debug_health_bar.alignY = "middle";
	debug_health_bar.x = 620;
	debug_health_bar.y = ypos;
	debug_health_bar.sort = 4;
	debug_health_bar.alpha = 1;
	debug_health_bar.foreground = 1;
	debug_health_bar.color = ( 0, 0, 0.9 );
	debug_health_bar setshader( "white", 4 , 15 );
	
	debug_health_bar_left_bound = NewClientHudElem( self );
	debug_health_bar_left_bound.alignX = "right";
	debug_health_bar_left_bound.alignY = "middle";
	debug_health_bar_left_bound.x = lbound;
	debug_health_bar_left_bound.y = ypos;
	debug_health_bar_left_bound.sort = 2;
	debug_health_bar_left_bound.alpha = 1;
	debug_health_bar_left_bound.foreground = 1;
	debug_health_bar_left_bound setshader( "black", 4 , 21 );
	
	debug_health_bar_right_bound = NewClientHudElem( self );
	debug_health_bar_right_bound.alignX = "right";
	debug_health_bar_right_bound.alignY = "middle";
	debug_health_bar_right_bound.x = rbound;
	debug_health_bar_right_bound.y = ypos;
	debug_health_bar_right_bound.sort = 2;
	debug_health_bar_right_bound.alpha = 1;
	debug_health_bar_right_bound.foreground = 1;
	debug_health_bar_right_bound setshader( "black", 4 , 21 );
	
	debug_health_bar_0_top = NewClientHudElem( self );
	debug_health_bar_0_top.alignX = "right";
	debug_health_bar_0_top.alignY = "middle";
	debug_health_bar_0_top.x = lbound + ( -level.friendlyfirepoints[ "min_participation" ] / fullpts ) * ( bar_width );
	debug_health_bar_0_top.y = ypos + 9;
	debug_health_bar_0_top.sort = 2;
	debug_health_bar_0_top.alpha = 1;
	debug_health_bar_0_top.foreground = 1;
	debug_health_bar_0_top setshader( "black", 4 , 4 );

	debug_health_bar_0_bottom = NewClientHudElem( self );
	debug_health_bar_0_bottom.alignX = "right";
	debug_health_bar_0_bottom.alignY = "middle";
	debug_health_bar_0_bottom.x = lbound + ( -level.friendlyfirepoints[ "min_participation" ] / fullpts ) * ( bar_width );
	debug_health_bar_0_bottom.y = ypos - 9;
	debug_health_bar_0_bottom.sort = 2;
	debug_health_bar_0_bottom.alpha = 1;
	debug_health_bar_0_bottom.foreground = 1;
	debug_health_bar_0_bottom setshader( "black", 4 , 4 );	
	
	
	for (;;)
	{
		if( GetDvarString( "debug_friendlyfire" ) == "on" )
		{
			friendly_fire.alpha = 1;
			friendly_fire_lower_bound_label.alpha = 1;
			friendly_fire_upper_bound_label.alpha = 1;
			debug_health_bar_bg.alpha = 1;
			debug_health_bar.alpha = 1;
			debug_health_bar_left_bound.alpha = 1;
			debug_health_bar_right_bound.alpha = 1;
			debug_health_bar_0_top.alpha = 1;
			debug_health_bar_0_bottom.alpha = 1;
		}
		else
		{
			friendly_fire.alpha = 0;
			friendly_fire_lower_bound_label.alpha = 0;
			friendly_fire_upper_bound_label.alpha = 0;
			debug_health_bar_bg.alpha = 0;
			debug_health_bar.alpha = 0;
			debug_health_bar_left_bound.alpha = 0;
			debug_health_bar_right_bound.alpha = 0;
			debug_health_bar_0_top.alpha = 0;
			debug_health_bar_0_bottom.alpha = 0;
		}
		
		xpos = (level.friendlyfirepoints["max_participation"] - self.participation ) / ( fullpts ) * ( bar_width );
		debug_health_bar.x = rbound - xpos;
		
		friendly_fire Setvalue( self.participation ); 
		friendly_fire.x = rbound - bar_width * ( level.friendlyfirepoints[ "max_participation" ] / fullpts ) + ( ceil( max( Log( abs( self.participation ) ) / Log( 10 ), 0) ) + 1 + ( self.participation < 0 ) ) * friendly_fire.fontScale * 2; //center text
		
		wait( 0.25 ); 
	}
	#/
}

// warlord is killed when his shieldhealth is gone, not his regular health.
function check_warlord_killed( entity )
{
	if( entity.archetype == "warlord_soldier" ) return entity.shieldhealth <= 0;
	return false;
}

//entity = who took the damage
function friendly_fire_callback( entity, damage, attacker, method )
{
	if( !isdefined( entity ) )
	{
		return;
	}
	
	if( !isdefined( entity.team ) )
	{
		entity.team = "allies";
	}
	
	if( !isdefined( entity ) )
	{
		return;
	}
	
	warlord_was_killed = check_warlord_killed( entity );
	if ( entity.health <= 0 )
	{
		if( !warlord_was_killed ) return;
	}
	
	if( level.friendlyFireDisabled )
	{
		return;
	}
	
	if ( ( isdefined( entity.NoFriendlyfire ) && entity.NoFriendlyfire ) ) 
	{
		return;
	}
		
	// if we dont know who the attacker is we can't do much, so ignore it. This is seldom to happen, but not impossible
	if ( !isdefined( attacker ) )
	{
		return;
	}
	
	// check to see if the death was caused by the player or the players turret
	bPlayersDamage = false;

	if( IsPlayer( attacker ) )
	{
		bPlayersDamage = true;
	}
	else if( ( isdefined( attacker.classname ) ) && ( attacker.classname == "script_vehicle" ) )
	{
		// If the attacker is a vehicle and the vehicles owner is the player
		// Make the attacker the player
		//
		// NOTE: This is a dangerous assumption, what if the vehicle has:-
		//			- Multiple gunners, it may not have been the player that shot
		//			- The player is the driver but an ai gunner fired
		//
		// MikeA: Adding ent.friendlyfire_attacker_not_vehicle_owner (09/01/10)
		//
		
		owner = attacker GetVehicleowner(); 

		if( isdefined(owner) )
		{
			if( IsPlayer(owner) )
			{
				if( !isdefined(owner.friendlyfire_attacker_not_vehicle_owner) )
				{
					bPlayersDamage = true;

					attacker = owner;	
				}
			}
		}
	}

	// if the player didn't cause the damage then disregard
	if ( !bPlayersDamage )
	{
		return;
	}

	same_team = entity.team == attacker.team;
	
	if(attacker.team == "allies")
	{
		if(entity.team == "neutral" && !( isdefined( level.ignoreNeutralFriendlyFire ) && level.ignoreNeutralFriendlyFire ) )
		{
			same_team = true;
		}
	}
	
	if( entity.team != "neutral" || ( entity.team == "neutral" && !( isdefined( level.ignoreNeutralFriendlyFire ) && level.ignoreNeutralFriendlyFire ) ) )
	{
		attacker.last_hit_team = entity.team;
	}
	
	// killed = (damage == -1);
	killed = ( damage >= entity.health ) || warlord_was_killed;
	//no killed points for entities that do not allow death
	if( !entity.allowDeath )
	{
		killed = false;
	}
	if( !same_team )
	{			
		if( killed )
		{
			// The player killed an enemy.
			attacker.participation += level.friendlyfirepoints[ "enemy_kill_points" ];
			attacker participation_point_cap();
			debug_log( "Enemy killed: +" + level.friendlyfirepoints[ "enemy_kill_points" ]);
		}
		else
		{
			// The player damaged an enemy.
		}

		return;
	}

	//player killed/damaged a friendly
	if ( isdefined( entity.no_friendly_fire_penalty ) )
	{		
		return;
	}
	
	// player killed/damaged a friendly
	if ( killed )
	{
		if(entity.team == "neutral")
		{
			level notify( "player_killed_civ" );
			attacker.participation += level.friendlyfirepoints[ "civ_kill_points" ];
			debug_log( "Civilian killed: -" + ( 0 - level.friendlyfirepoints[ "civ_kill_points" ] ) );
		}
		else
		{
			if( isdefined(entity) && isdefined( entity.ff_kill_penalty ) )
			{
				attacker.participation += entity.ff_kill_penalty;
				debug_log( "Friendly killed with custom penalty: -" + ( 0 - entity.ff_kill_penalty ) );
			}
			else
			{
				attacker.participation += level.friendlyfirepoints["friend_kill_points"];
				debug_log( "Friendly killed: -" + ( 0 - level.friendlyfirepoints[ "friend_kill_points" ] ) );
			}
		}
	}
	else
	{
		attacker.participation -= damage; // TODO
		debug_log( "Friendly hurt: -" + damage );
	}
	
	attacker participation_point_cap(); 
	
	// dont fail the mission if death was caused by a grenade that was cooking durring an autosave
	if ( check_grenade( entity, method ) && savecommit_afterGrenade() )
	{
		return;
	}
		
	attacker friendly_fire_checkpoints(); 	
}

// Every entity that influences friedly fire should run this thread( ai of both teams, vehicles of both teams )
// self 	- level
// entity -	entity to register friendly fire
function friendly_fire_think( entity )
{
	level endon( "mission failed" );
	entity endon( "no_friendly_fire" );
	
	if ( !isdefined( entity ) )
	{
		return;
	}
	
	if ( !isdefined( entity.team ) )
	{
		entity.team = "allies";
	}
		
	for (;;)
	{
		if ( !isdefined( entity ) )
		{
			return;
		}
		
		entity waittill( "damage", damage, attacker, undefined, undefined, method );

		if ( level.friendlyFireDisabled )
		{
			continue;
		}
				
		if ( !isdefined( entity ) )
		{
			return;
		}

		if ( ( isdefined( entity.NoFriendlyfire ) && entity.NoFriendlyfire ) )
		{
			continue;
		}
			
		// if we don't know who the attacker is we can't do much, so ignore it. This is seldom to happen, but is not impossible
		if ( !isdefined( attacker ) )
		{
			continue;
		}
		
		// check to see if the death was caused by the player or the player's turret
		bPlayersDamage = false;

		if ( IsPlayer( attacker ) )
		{
			bPlayersDamage = true;
		}
		
		// If the attacker is a vehicle and the vehicles owner is the player
		// Make the attacker the player
		//
		// NOTE: This is a dangerous assumption, what if the vehicle has:-
		//			- Multiple gunners, it may not have been the player that shot
		//			- The player is the driver but an ai gunner fired
		//
		// MikeA: Adding ent.friendlyfire_attacker_not_vehicle_owner (09/01/10)
		//
		
		else if ( ( isdefined( attacker.classname ) ) &&( attacker.classname == "script_vehicle" ) )
		{
			owner = attacker GetVehicleowner(); 

			if ( isdefined( owner ) )
			{
				if ( IsPlayer(owner) )
				{
					if ( !isdefined( owner.friendlyfire_attacker_not_vehicle_owner ) )
					{
						bPlayersDamage = true;
						attacker = owner;	
					}
				}
			}
		}
		
		// if the player didn't cause the damage then disregard
		if ( !bPlayersDamage )
		{
			continue;
		}

		same_team = entity.team == attacker.team;
		
		if ( attacker.team == "allies" )
		{
			if ( entity.team == "neutral" && !( isdefined( level.ignoreNeutralFriendlyFire ) && level.ignoreNeutralFriendlyFire ) )
			{
				same_team = true;
			}
		}
		
		if ( entity.team != "neutral" || ( entity.team == "neutral" && !( isdefined( level.ignoreNeutralFriendlyFire ) && level.ignoreNeutralFriendlyFire ) ) )
		{
			attacker.last_hit_team = entity.team;
		}
		
		killed = damage >= entity.health;
		
		if ( !same_team )
		{			
			if ( killed )
			{
				attacker.participation += level.friendlyfirepoints["enemy_kill_points"]; 
				attacker participation_point_cap();
				
				debug_log( "Enemy killed: +" + level.friendlyfirepoints[ "enemy_kill_points" ] );
			}

			return;
		}

		//player killed/damaged a friendly
		if ( isdefined( entity.no_friendly_fire_penalty ) )
		{		
			continue;
		}
		
		if ( killed )
		{
			if ( entity.team == "neutral" )
			{
				level notify( "player_killed_civ" );
				
				if ( attacker.participation <= 0 )
				{
					attacker.participation += level.friendlyfirepoints["min_participation"];
					debug_log( "Civilian killed with negative score, autofail!" );
				}
				else
				{
					attacker.participation += level.friendlyfirepoints["civ_kill_points"];
					debug_log( "Civilian killed: -" + ( 0 - level.friendlyfirepoints[ "civ_kill_points" ] ) );
				}
			}
			else
			{
				if ( isdefined( entity ) && isdefined( entity.ff_kill_penalty ) )
				{
					attacker.participation += entity.ff_kill_penalty;
					debug_log( "Friendly killed with custom penalty: -" + ( 0 - entity.ff_kill_penalty ) );
				}
				else
				{
					attacker.participation += level.friendlyfirepoints["friend_kill_points"];
					debug_log( "Friendly killed: -" + ( 0 - level.friendlyfirepoints[ "friend_kill_points" ] ) );
				}
			}
		}
		else
		{
			attacker.participation -= damage; // TODO
			debug_log( "Friendly hurt: -" + damage );
		}
		
		attacker participation_point_cap(); 
		
		// dont fail the mission if death was caused by a grenade that was cooking durring an autosave
		if ( check_grenade( entity, method ) && savecommit_afterGrenade() )
		{
			if ( killed )
			{
				return;
			}
			continue;
		}
			
		attacker friendly_fire_checkpoints(); 
	}
}

// fail the mission if the players participation has reached the minimum
// self - player
function friendly_fire_checkpoints()
{
	if( self.participation <= level.friendlyfirepoints["min_participation"] )
	{
		self thread missionfail(); 
	}
}

// check if the entity was killed by a grenade
// self 	- level
// entity - the damaged entity
// method - the damage type
// returns true oe false
function check_grenade( entity, method )
{
	if( !isdefined( entity ) )
	{
		return false;
	}
	
	// check if the entity was killed by a grenade
	wasGrenade = false;
	// TODO: We can change this to isgrenadeweapon...maybe?
	if( isdefined( entity.damageweapon ) && ( entity.damageweapon.name == "none" ) )
	{
		wasGrenade = true;
	}
	if( isdefined( method ) && ( method == "MOD_GRENADE_SPLASH" ) )
	{
		wasGrenade = true;
	}
	
	// if the entity was not killed by a grenade then exit
	return wasGrenade;
}

// Fixes any problems caused by saving after throwing a grenade
// self - level
// returns true or false
function savecommit_afterGrenade()
{
	currentTime = GetTime(); 
	if ( currentTime < 4500 )
	{
		/#println( "^3aborting friendly fire because the level just loaded and saved and could cause a autosave grenade loop" );#/
		return true;
	}
	return false;
}

// Caps participation points to either the max or min
// self - player
function participation_point_cap()
{
	if( !isdefined( self.participation ) )
	{
		assertmsg( "self.participation is not defined!" );
		return;	
	}

	if( self.participation > level.friendlyfirepoints["max_participation"] )
	{
		self.participation = level.friendlyfirepoints["max_participation"]; 
	}

	if( self.participation < level.friendlyfirepoints["min_participation"] )
	{
		self.participation = level.friendlyfirepoints["min_participation"]; 
	}
}

// Evens out FF participation points over time
// self - player
function participation_point_flattenOverTime()
{
	level endon( "friendly_fire_terminate" );
	self endon( "disconnect");
	
	for (;;)
	{
		if( self.participation > 0 )
		{
			self.participation--; 
		}
		else if( self.participation < 0 )
		{
			self.participation++;
		}

		wait( level.friendlyfirepoints["point_loss_interval"] ); 
	}
}

function TurnBackOn()
{
	level.friendlyFireDisabled = 0;
}

function TurnOff()
{
	level.friendlyFireDisabled = 1;
}

function missionfail()
{
	self endon( "death" );
	level endon( "mine death" );
	
	self.participation = 0;
	self.lives = 0;
	
	if ( self.last_hit_team === "neutral" )
	{
		//"You shot a civilian, watch your fire!"
		util::missionFailedWrapper_nodeath( &"SCRIPT_MISSIONFAIL_KILLTEAM_NEUTRAL" );
	}
	else
	{
		//"Friendly fire will not be tolerated!"
		util::missionFailedWrapper_nodeath( &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );
	}	
}

// Sends outs "friendlyfire_notify" upon FF damage
// self 	- level
// entity - entity to send / recieve notify 	
function notifyDamage( entity )
{
	level endon( "mission failed" );
	entity endon( "death" );
	for (;;)
	{
		entity waittill( "damage", damage, attacker, undefined, undefined, method );
		entity notify( "friendlyfire_notify", damage, attacker, undefined, undefined, method );
	}
}

function notifyDamageNotDone( entity )
{
	level endon( "mission failed" );
	entity waittill( "damage_notdone", damage, attacker, undefined, undefined, method );
	entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}

// Sends outs "friendlyfire_notify" upon FF death
// self 	- level
// entity - entity to send / recieve notify 	
function notifyDeath( entity )
{
	level endon( "mission failed" );
	entity waittill( "death" , attacker, method );
	entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}