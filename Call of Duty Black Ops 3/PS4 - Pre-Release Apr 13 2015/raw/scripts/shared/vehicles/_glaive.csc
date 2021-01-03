#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\animation_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                            	   	
                                                              	   	                             	  	                                      
                                                                                                                                                                                                                                                                                                                                                                   
                 	     

#namespace glaive;

function autoexec __init__sytem__() {     system::register("glaive",&__init__,undefined,undefined);    }

#using_animtree( "generic" );

function __init__()
{	
	vehicle::add_main_callback( "glaive", &glaive_initialize );
	clientfield::register( "vehicle", "glaive_blood_fx", 1, 1, "int" );
}

function glaive_initialize()
{
	self useanimtree( #animtree );

	//Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	//self EnableAimAssist();
	self SetNearGoalNotifyDist( 50 );

	self SetHoverParams( 0, 0, 40 );
	self playloopsound( "wpn_sword2_looper" );

	if ( isdefined( self.scriptbundlesettings ) )
	{
		self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	}
	
	// AI SPECIFIC INITIALIZATION
	blackboard::CreateBlackBoardForEntity( self );
	self Blackboard::RegisterVehicleBlackBoardAttributes();

	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0.574;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	self.goalRadius = 9999999;
	self.goalHeight = 512;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );

	self.overrideVehicleDamage = &glaive_callback_damage;
	self.allowFriendlyFireDamageOverride = &glaive_AllowFriendlyFireDamage;

	self.ignoreme = true;
	self._glaive_settings_lifetime = self.settings.lifetime;

	//self thread vehicle_ai::nudge_collision();

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::add_state( "slash",
		undefined,
		&state_slash_update,
		undefined );
    
	vehicle_ai::StartInitialState( "combat" );
	self.startTime = GetTime();
}

function is_enemy_valid()
{
	if( !IsDefined( self.enemy ) )
	{
		return false;
	}
	else if( Distance2DSquared( self.owner.origin, self.enemy.origin ) > ( (self.settings.guardradius) * (self.settings.guardradius) ) )
	{
		return false;	
	}
	return true;
}

function should_go_to_near_owner()
{
	if( IsDefined( self.owner ) && Distance2DSquared( self.origin, self.owner.origin ) > ( (self.settings.guardradius) * (self.settings.guardradius) ) )
	{
		return true;
	}
	if( IsDefined( self.owner ) && !self is_enemy_valid() )
	{
		if( Distance2DSquared( self.origin, self.owner.origin ) > ( (2 * 80) * (2 * 80) ) )
		{
			return true;
		}
		if( VectorDot( AnglesToForward( self.owner.angles ), self.origin - self.owner.origin ) < 0.0 )
		{
			return true;
		}
	}
	return false;
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_enter( params )
{
	self ASMRequestSubstate( "idle@movement" );
}

function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	pathfailcount = 0;

	while ( !isdefined( self.owner ) )
	{
		wait 0.1;

		if ( !isdefined( self.owner ) )
		{
			self.owner = GetPlayers( self.team )[0];
		}
	}

	for( ;; )
	{
		//do idle unless something else is required
		self ASMRequestSubstate( "idle@movement" );
		if( GetTime() - self.starttime > self._glaive_settings_lifetime * 1000 )
		{
			self.vehAirCraftCollisionEnabled = false;
			self go_to_owner();
		}
		else if( self should_go_to_near_owner() )
		{
			self.vehAirCraftCollisionEnabled = false;
			self go_to_near_owner();
		}
		else if( IsDefined( self.enemy ) )
		{
			foundpath = false;

			targetPos = vehicle_ai::GetTargetPos( self.enemy );
			
			if ( isdefined( targetPos ) )
			{
				if( distance2dSquared( self.origin, self.enemy.origin ) < ( (80) * (80) ) )
				{
					self vehicle_ai::set_state( "slash" );
				}
				else if( IsDefined( self.owner ) && self is_enemy_valid() && ( ( IsActor( self.enemy ) && ( isdefined( self.enemy.completed_emerging_into_playable_area ) && self.enemy.completed_emerging_into_playable_area ) ) || !IsActor( self.enemy ) ) )
				{
					self.vehAirCraftCollisionEnabled = false;
					go_back_on_navvolume();

					queryResult = PositionQuery_Source_Navigation( targetPos, 0, 64, 64, 20 * 0.4, self );
					PositionQuery_Filter_Sight( queryResult, targetPos, self GetEye() - self.origin, self, 0, self.enemy );

					foreach ( point in queryResult.data )
					{
						if ( ( isdefined( point.visibility ) && point.visibility ) )
						{
							self.current_pathto_pos = point.origin;

							foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
							if ( foundpath )
							{
								//start playing locomotion
								self ASMRequestSubstate( "forward@movement" );
								self util::waittill_any( "near_goal", "goal" );
								break;
							}
						}
					}
				}
			}

			if ( !foundpath && self is_enemy_valid() )
			{
				go_back_on_navvolume();

				pathfailcount++;

				if ( pathfailcount > 3 )
				{
					if ( isdefined( self.owner ) )
					{
						self go_to_near_owner();
					}
				}
				wait 0.1;
			}
			else
			{
				pathfailcount = 0;
			}
		}

		wait 0.2;
	}
}

function go_back_on_navvolume()
{
	self.vehAirCraftCollisionEnabled = false;

	// try to path straight to a nearby position on the nav volume
	queryResult = PositionQuery_Source_Navigation( self.origin, 0, 100, 64, 20 * 0.4, self );

	multiplier = 2;
	while ( queryResult.data.size < 1 )
	{
		queryResult = PositionQuery_Source_Navigation( self.origin, 0, 100 * multiplier, 64 * multiplier, 20 * multiplier, self );
		multiplier += 2;
	}

	if ( queryResult.data.size && !queryResult.centerOnNav )
	{
		best_point = undefined;
		best_score = -999999;

		foreach ( point in queryResult.data )
		{
			point.score = Abs( point.origin[2] - queryResult.origin[2] );

			if ( point.score > best_score )
			{
				best_score = point.score;
				best_point = point;
			}
		}

		point = queryResult.data[ 0 ];

		self.current_pathto_pos = point.origin;

		self SetVehGoalPos( self.current_pathto_pos, true, false );
		wait 0.5;
	}

	self.vehAirCraftCollisionEnabled = true;
}

function chooseSwordAnim( enemy )
{
	self endon( "change_state" );
	self endon( "death" );
	
	sword_anim = "o_zombie_zod_sword_projectile_melee_synced_a";
	
	if( IsDefined( self.archetype ) )
	{
	   	switch( enemy.archetype )
		{
			case "parasite": 
				sword_anim = "o_zombie_zod_sword_projectile_melee_parasite_synced_a";
				break;
			case "raps":
				sword_anim = "o_zombie_zod_sword_projectile_melee_elemental_synced_a";
				break;
		}
	}
	
	return sword_anim;
}

function state_slash_update( params )
{
	self endon( "change_state" );
	self endon( "death" );
	
	enemy = self.enemy;
	sword_anim = self chooseSwordAnim( enemy );

	self AnimScripted( "anim_notify", enemy GetTagOrigin( "tag_origin" ), enemy GetTagAngles( "tag_origin" ), sword_anim, "normal" );
	
	self clientfield::set( "glaive_blood_fx", 1 );
	self waittill( "anim_notify" );
	
	target_enemies = GetAITeamArray( "axis" );
	foreach( target in target_enemies )
	{
		if( Distance2DSquared( self.origin, target.origin ) < ( (128) * (128) ) )
		{
			target DoDamage( target.health + 100, self.origin, self.owner, self, "none", "MOD_UNKNOWN", 0, self.weapon );
			self playsound( "wpn_sword2_imp" );
			if( IsActor( target ) )
			{
				target zombie_utility::gib_random_parts();
				target StartRagdoll();
				target LaunchRagdoll( 100 * VectorNormalize( target.origin - self.origin ) );
			}
		}
	}	

	self waittill( "anim_notify", notetrack );
	while ( !isdefined( notetrack ) || notetrack != "end" )
	{
		self waittill( "anim_notify", notetrack );
	}
	self clientfield::set( "glaive_blood_fx", 0 );
	self vehicle_ai::set_state( "combat" );
}

function go_to_near_owner()
{
	self endon( "near_owner" );
	
	self thread back_to_near_owner_check();
	
	starttime = GetTime();
	
	//start playing locomotion animation
	self ASMRequestSubstate( "forward@movement" );
	
	while ( GetTime() - starttime < self._glaive_settings_lifetime * 1000 * 0.3 )
	{
		go_back_on_navvolume();

		targetPos = vehicle_ai::GetTargetPos( self.owner );
		
		//get a target little ahead of the owner
		ownerForwardVec = AnglesToForward( self.owner.angles );
		targetPos = targetPos + 80 * ownerForwardVec;
		
		queryResult = PositionQuery_Source_Navigation( targetPos, 0, 64, 64, 20 * 0.4, self );
		PositionQuery_Filter_Sight( queryResult, targetPos, self GetEye() - self.origin, self, 5, self.owner );

		foundPath = false;
		foreach ( point in queryResult.data )
		{
			if ( ( isdefined( point.visibility ) && point.visibility ) )
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
				if ( foundpath )
				{
					break;
				}
			}
		}

		if ( !foundPath )
		{
			foreach ( point in queryResult.data )
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
				if ( foundpath )
				{
					break;
				}
			}
		}

		wait 1;
	}
	
	if ( isdefined( self.owner ) )
	{
		self.origin = self.owner.origin + 80 * AnglesToForward( self.owner.angles ) + ( 0, 0, 80 * 0.5 );
	}
}

function go_to_owner()
{
	self thread back_to_owner_check();

	starttime = GetTime();
	
	//start playing locomotion animation
	self ASMRequestSubstate( "forward@movement" );
	
	while ( GetTime() - starttime < self._glaive_settings_lifetime * 1000 * 0.3 )
	{
		go_back_on_navvolume();

		targetPos = vehicle_ai::GetTargetPos( self.owner );
		queryResult = PositionQuery_Source_Navigation( targetPos, 0, 64, 64, 20 * 0.4, self );
		PositionQuery_Filter_Sight( queryResult, targetPos, self GetEye() - self.origin, self, 5, self.owner );

		foundPath = false;
		foreach ( point in queryResult.data )
		{
			if ( ( isdefined( point.visibility ) && point.visibility ) )
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
				if ( foundpath )
				{
					break;
				}
			}
		}

		if ( !foundPath )
		{
			foreach ( point in queryResult.data )
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
				if ( foundpath )
				{
					break;
				}
			}
		}

		wait 1;
	}
	
	if ( isdefined( self.owner ) )
	{
		self.origin = self.owner.origin + ( 0, 0, 80 * 0.5 );
	}
	self notify( "returned_to_owner" );

	wait 2;
}

function back_to_owner_check()
{
	self endon( "death" );

	while ( isdefined( self.owner ) && ( Abs( self.origin[2] - self.owner.origin[2] ) > ( (80) * (80) ) || Distance2DSquared( self.origin, self.owner.origin ) > ( (80) * (80) ) ) )
	{
		wait 0.1;
	}
	
	self notify( "returned_to_owner" );
}

function back_to_near_owner_check()
{
	self endon( "death" );

	while ( isdefined( self.owner ) && ( Abs( self.origin[2] - self.owner.origin[2] ) > ( (2 * 80) * (2 * 80) ) || Distance2DSquared( self.origin, self.owner.origin ) > ( (2 * 80) * (2 * 80) )  || VectorDot( AnglesToForward( self.owner.angles ), self.origin - self.owner.origin ) < 0.0 ) )
	{
		wait 0.1;
	}

	self notify( "near_owner" );
}

function glaive_AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	return false;
}

function glaive_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	return 1;
}
