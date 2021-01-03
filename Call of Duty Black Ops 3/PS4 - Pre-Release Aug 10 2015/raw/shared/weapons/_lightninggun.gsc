#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\player_shared;
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
	level.weaponLightningGunKillcamTime = GetDvarFloat( "scr_lightningGunKillcamTime", 0.35 );
	level.weaponLightningGunKillcamDecelPercent = GetDvarFloat( "scr_lightningGunKillcamDecelPercent", 0.25 );
	level.weaponLightningGunKillcamOffset = GetDvarFloat( "scr_lightningGunKillcamOffset", 150.0 );

	level.lightninggun_arc_range = 350;
	level.lightninggun_arc_range_sq = level.lightninggun_arc_range * level.lightninggun_arc_range;
	level.lightninggun_arc_speed = 650;
	level.lightninggun_arc_speed_sq = level.lightninggun_arc_speed * level.lightninggun_arc_speed;
	level.lightninggun_arc_fx_min_range = 1;
	level.lightninggun_arc_fx_min_range_sq = level.lightninggun_arc_fx_min_range * level.lightninggun_arc_fx_min_range;

	level._effect["lightninggun_arc"] = "weapon/fx_lightninggun_arc";

	callback::add_weapon_damage( level.weaponLightningGun, &on_damage_lightninggun );

/#
	level thread update_dvars();
#/
}

/#
function update_dvars()
{
	while(1)
	{
		wait(1);
		level.weaponLightningGunKillcamTime = GetDvarFloat( "scr_lightningGunKillcamTime", 0.35 );
		level.weaponLightningGunKillcamDecelPercent = GetDvarFloat( "scr_lightningGunKillcamDecelPercent", 0.25 );
		level.weaponLightningGunKillcamOffset = GetDvarFloat( "scr_lightningGunKillcamOffset", 150.0 );
	}
}
#/
	
function lightninggun_start_damage_effects( eAttacker )
{
	self endon( "disconnect" );

/#
	If ( IsGodMode( self ) )
	{
		return;
	}
#/

	self SetElectrifiedState( true );
	self.electrifiedBy = eAttacker;

	wait( 2 );
	
	self.electrifiedBy = undefined;
	self SetElectrifiedState( false );
}

function lightninggun_arc_killcam( arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waitTime )
{
	arc_target.killcamKilledByEnt = create_killcam_entity( original_killcam_ent.origin, original_killcam_ent.angles, level.weaponLightningGunArc );
	arc_target.killcamKilledByEnt killcam::store_killcam_entity_on_entity(original_killcam_ent);

	arc_target.killcamKilledByEnt killcam_move( arc_source_pos, arc_target_pos, waitTime );
}

function lightninggun_arc_fx( arc_source_pos, arc_target, arc_target_pos, distanceSq, original_killcam_ent )
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

	lightninggun_arc_killcam( arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waitTime );
	killcamEntity = arc_target.killcamKilledByEnt;
	
	if ( distanceSq < level.lightninggun_arc_fx_min_range_sq )
	{
		wait( waitTime );
		
		killcamEntity delete();
		
		if ( !IsDefined( arc_target ) )
		{
			arc_target.killcamKilledByEnt = undefined;
		}
		//Not playing arcing FX. Enemies too close
		return;
	}

	// this needs to be clientsided.
	fxOrg = spawn( "script_model", arc_source_pos );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["lightninggun_arc"], fxOrg, "tag_origin" );
	playsoundatposition( "wpn_lightning_gun_bounce", fxOrg.origin );
	
	fxOrg MoveTo( arc_target_pos, waitTime );
	fxOrg waittill( "movedone" );
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	fxOrg delete();
	
	killcamEntity delete();
	
	if ( !IsDefined( arc_target ) )
	{
		arc_target.killcamKilledByEnt = undefined;
	}
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

	level thread lightninggun_arc_fx( arc_source_pos, arc_target, arc_target_pos, distanceSq, arc_source.killcamKilledByEnt );
	arc_target thread lightninggun_start_damage_effects( eAttacker );
	arc_target DoDamage( arc_target.health, arc_source_pos, eAttacker, arc_source, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc );
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

		if ( player player::is_spawn_protected() )
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

function create_killcam_entity( origin, angles, weapon )
{
	killcamKilledByEnt = spawn( "script_model", origin );
	killcamKilledByEnt SetModel( "tag_origin" );
	killcamKilledByEnt.angles = angles;
	killcamKilledByEnt SetWeapon( weapon );
	return killcamKilledByEnt;
}

function killcam_move( start_origin, end_origin, time )
{
	delta = end_origin - start_origin;
	dist = Length( delta );
	delta = VectorNormalize( delta );
	move_to_dist = dist - level.weaponLightningGunKillcamOffset;
	
	end_angles = (0,0,0);
	
	if ( move_to_dist > 0 )
	{
		move_to_pos = start_origin + (delta * move_to_dist);
		self MoveTo( move_to_pos, time, 0, time * level.weaponLightningGunKillcamDecelPercent );
		end_angles = VectorToAngles( delta );	
	}
	else
	{
		delta = end_origin - self.origin;
		end_angles = VectorToAngles( delta );	
	}

	self RotateTo( end_angles, time, 0, time * level.weaponLightningGunKillcamDecelPercent );
}

function lightninggun_damage_response( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	source_pos = eAttacker.origin;
	bolt_source_pos = eAttacker GetTagOrigin( "tag_flash" );

	arc_source = self;
	arc_source_origin = self.origin;
	arc_source_pos = self GetTagOrigin( "j_spineupper" );

	delta = arc_source_pos - bolt_source_pos;
	angles = VectorToAngles( delta );
		
	arc_source.killcamKilledByEnt = create_killcam_entity( bolt_source_pos, angles, weapon );
	arc_source.killcamKilledByEnt killcam_move( bolt_source_pos, arc_source_pos, level.weaponLightningGunKillcamTime );
	killcamEntity = arc_source.killcamKilledByEnt;
	
	self thread lightninggun_start_damage_effects( eAttacker );
//	self DoDamage( self.health, source_pos, eAttacker, eAttacker, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc );

	wait( 2 );

	if ( !IsDefined( self ) )
	{
		self thread lightninggun_find_arc_targets( eAttacker, undefined, arc_source_origin, arc_source_pos );
		return;
	}

	// get latest positioning
	if ( IsDefined( self.body ) )
	{
		arc_source_origin = self.body.origin;
		arc_source_pos = self.body GetTagOrigin( "j_spineupper" );
	}

	self thread lightninggun_find_arc_targets( eAttacker, arc_source, arc_source_origin, arc_source_pos );

	// wait the maximum amount of time that we could still be arcing.  The other players 
	// will use this killcamEntity
	wait( 0.05 * 9 );
	killcamEntity delete();
	
	if ( !IsDefined( arc_source ) )
	{
		arc_source.killcamKilledByEnt = undefined;
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
