#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

       

#precache( "fx", "weapon/fx_lightninggun_arc" );

#namespace lightninggun;

function init_shared()
{
	level.weaponLightningGun = GetWeapon( "hero_lightninggun" );
	level.weaponLightningGunArc = GetWeapon( "hero_lightninggun_arc" );
	level.weaponLightningGunReact = GetWeapon( "hero_lightninggun_react" );

	level.lightninggun_arc_range = 450;
	level.lightninggun_arc_range_sq = level.lightninggun_arc_range * level.lightninggun_arc_range;
	level.lightninggun_arc_speed = 650;
	level.lightninggun_arc_speed_sq = level.lightninggun_arc_speed * level.lightninggun_arc_speed;
	level.lightninggun_arc_fx_min_range = 1;
	level.lightninggun_arc_fx_min_range_sq = level.lightninggun_arc_fx_min_range * level.lightninggun_arc_fx_min_range;

	level._effect["lightninggun_arc"] = "weapon/fx_lightninggun_arc";

	if ( !IsDefined( level.vsmgr_prio_overlay_lightninggun_electrified ) )
	{
		level.vsmgr_prio_overlay_lightninggun_electrified = 20;
	}					
	visionset_mgr::register_info( "overlay", "lightninggun_electrified", 1, level.vsmgr_prio_overlay_lightninggun_electrified, 7, true, &visionset_mgr::duration_lerp_thread_per_player, false );

	clientfield::register( "allplayers", "damaged_by_lightninggun", 1, 1, "int" );

	callback::add_weapon_damage( level.weaponLightningGun, &on_damage_lightninggun );
}

function lightninggun_start_damage_effects()
{
/#
	If ( IsGodMode( self ) )
	{
		return;
	}
#/

	self GiveWeapon( level.weaponLightningGunReact );
	self SwitchToWeaponImmediate( level.weaponLightningGunReact );

	visionset_mgr::activate( "overlay", "lightninggun_electrified", self, 1.25, 1.25 );

	self clientfield::set( "damaged_by_lightninggun", 1 );

	self SetElectrifiedState( true );

	self Shellshock( "lightninggun_victim", 1.25 );

	self PlayRumbleOnEntity( "lightninggun_victim" );

	self thread lightninggun_end_damage_effects();
}

function lightninggun_end_damage_effects()
{
	self endon( "disconnect" );

	self waittill( "death" );

	visionset_mgr::deactivate( "overlay", "lightninggun_electrified", self );

	self clientfield::set( "damaged_by_lightninggun", 0 );

	self StopShellshock();

	self StopRumble( "lightninggun_victim" );

	// need to wait to make sure the DeathAnimDamageTypeCondition has been set before clearing the electrified state
	waittillframeend;
	self SetElectrifiedState( false );
}

function lightninggun_arc_fx( arc_source_pos, arc_target, arc_target_pos, distanceSq )
{
	if ( !IsDefined( arc_target ) )
	{	
		return;
	}
	
	waitTime = 0.25;
	if ( level.lightninggun_arc_speed_sq > 100 && distanceSq > 1 )
	{
		waitTime = distanceSq / level.lightninggun_arc_speed_sq;
	}

	if ( distanceSq < level.lightninggun_arc_fx_min_range_sq )
	{
		//Not playing arcing FX. Enemies too close
		return;
	}
	
	fxOrg = spawn( "script_model", arc_source_pos );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["lightninggun_arc"], fxOrg, "tag_origin" );
	playsoundatposition( "wpn_lightning_gun_bounce", fxOrg.origin );
	
	fxOrg MoveTo( arc_target_pos, waitTime );
	fxOrg waittill( "movedone" );
	fxOrg delete();
}

function lightninggun_arc( delay, eAttacker, arc_source, arc_source_origin, arc_source_pos, arc_target, arc_target_pos, distanceSq )
{
	if ( delay )
	{
		wait( delay );
		
		if ( !IsDefined( arc_target ) || !IsAlive( arc_target ) )
		{
			return;
		}
		
		// make sure we're still in range after the delay
		distanceSq = DistanceSquared( arc_target.origin, arc_source_origin );
		if ( distanceSq > level.lightninggun_arc_range_sq )
		{
			return;
		}
	}

	arc_target DoDamage( 1, arc_source_pos, eAttacker, arc_source, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc );
	
	if ( !IsDefined( arc_target ) || !IsAlive( arc_target ) )
	{
		return;
	}
	
	level thread lightninggun_arc_fx( arc_source_pos, arc_target, arc_target_pos, distanceSq );
	arc_target thread lightninggun_start_damage_effects();

	ret_val = self util::waittill_any_timeout( 1.25, "death", "disconnect" );

	if ( "death" == ret_val )
	{
		if ( eAttacker != self.lastattacker	)
		{
			scoreevents::processScoreEvent( "electrified", eAttacker );
		}

		if ( !IsDefined( arc_target ) )
		{
			arc_target SetElectrifiedState( false );
		}
	}

	if ( !IsDefined( arc_target ) )
	{
		return;
	}

	if ( IsAlive( arc_target ) )
	{
		arc_target DoDamage( arc_target.health, arc_source_pos, eAttacker, arc_source, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc );
	}
}

// arc_source_origin is the origin of the player initially hit, arc_source_pos is the pos of the tag the arc will be emanating from
function lightninggun_find_arc_targets( eAttacker, arc_source, arc_source_origin, arc_source_pos )
{
	delay = 0.05;

	allEnemyAlivePlayers = util::get_other_teams_alive_players_s( eAttacker.team );
		
	closestPlayers = ArraySort( allEnemyAlivePlayers.a, arc_source_origin, true );

	foreach( player in closestPlayers )
	{
		if ( IsDefined( arc_source ) && player == arc_source )
		{
			continue;
		}

		if ( isdefined( player.spawntime ) && isdefined(level.spawnProtectionTime) && ( gettime() - player.spawntime )/1000 <= level.spawnProtectionTime )
		{
			continue;
		}
		
		distanceSq = DistanceSquared( player.origin, arc_source_origin );
		if ( distanceSq > level.lightninggun_arc_range_sq )
		{
			break;
		}

		if ( eAttacker != player && weaponobjects::friendlyFireCheck( eAttacker, player ) )
		{
			if ( !player DamageConeTrace( arc_source_pos, self ) )
			{
				continue;
			}

			level thread lightninggun_arc( delay, eAttacker, arc_source, arc_source_origin, arc_source_pos, player, player GetTagOrigin( "j_spineupper" ), distanceSq );
			delay += 0.05;
		}
	}
}

function lightninggun_damage_response( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	source_pos = eAttacker.origin;

	arc_source = self;
	arc_source_origin = self.origin;
	arc_source_pos = self GetTagOrigin( "j_spineupper" );

	self thread lightninggun_start_damage_effects();

	ret_val = self util::waittill_any_timeout( 1.25, "death", "disconnect" );

	if ( "death" == ret_val )
	{
		if ( eAttacker != self.lastattacker	)
		{
			scoreevents::processScoreEvent( "electrified", eAttacker );
		}

		if ( !IsDefined( self ) )
		{
			self SetElectrifiedState( false );
		}
	}

	if ( !IsDefined( self ) )
	{
		self thread lightninggun_find_arc_targets( eAttacker, undefined, arc_source_origin, arc_source_pos );
		return;
	}

	// get latest positioning
	arc_source_origin = self.origin;
	arc_source_pos = self GetTagOrigin( "j_spineupper" );

	self thread lightninggun_find_arc_targets( eAttacker, arc_source, arc_source_origin, arc_source_pos );

	if ( IsAlive( self ) )
	{
		self DoDamage( self.health, source_pos, eAttacker, eAttacker, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc );
	}
}

function on_damage_lightninggun( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	if ( "MOD_PISTOL_BULLET" != meansOfDeath && "MOD_HEAD_SHOT" != meansOfDeath )
		return;

	// no additional lightning gun damage response if the player has armor on for now.
  if ( self flagsys::get( "gadget_armor_on" ) )
  	return;
  	
	self thread lightninggun_damage_response( eAttacker, eInflictor, weapon, meansOfDeath, damage );
}
