#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weaponobjects;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\killstreaks\_turret;
#using scripts\mp\teams\_teams;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );

#precache( "string", "KILLSTREAK_AUTO_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AIRSPACE_FULL" );
#precache( "string", "KILLSTREAK_EARNED_MICROWAVE_TURRET" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_HACKED" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_INBOUND" );
#precache( "string", "KILLSTREAK_DESTROYED_MICROWAVE_TURRET" );
#precache( "triggerstring", "KILLSTREAK_MICROWAVE_TURRET_PLACE_TURRET_HINT" );
#precache( "triggerstring", "KILLSTREAK_MICROWAVE_TURRET_INVALID_TURRET_LOCATION" );
#precache( "triggerstring", "KILLSTREAK_MICROWAVE_TURRET_PICKUP" );
#precache( "string", "mpl_killstreak_turret" );
#precache( "string", "mpl_killstreak_auto_turret" );
#precache( "fx", "killstreaks/fx_sentry_emp_stun" );
#precache( "fx", "killstreaks/fx_sentry_damage_state" );
#precache( "fx", "killstreaks/fx_sentry_death_state" );
#precache( "fx", "killstreaks/fx_sentry_exp" );
#precache( "fx", "killstreaks/fx_sentry_disabled_spark" );
#precache( "fx", "killstreaks/fx_sg_emp_stun" );
#precache( "fx", "killstreaks/fx_sg_damage_state" );
#precache( "fx", "killstreaks/fx_sg_death_state" );
#precache( "fx", "killstreaks/fx_sg_exp" );
#precache( "fx", "killstreaks/fx_sg_distortion_cone_ash" );
#precache( "fx", "killstreaks/fx_sg_distortion_cone_ash_sm" );
#precache( "fx", "explosions/fx_exp_equipment_lg" );
#precache( "model", "veh_t7_turret_guardian_red" );
#precache( "model", "veh_t7_turret_guardian_yellow" );
#precache( "model", "wpn_t7_none_world" );

#using_animtree( "mp_microwaveturret" );















#namespace microwave_turret;

function init()
{
	killstreaks::register( "microwave_turret", "microwave_turret_deploy", "killstreak_" + "microwave_turret", "microwave_turret" + "_used", &ActivateMicrowaveTurret, false, true );
	killstreaks::register_strings( "microwave_turret", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE", &"KILLSTREAK_MICROWAVE_TURRET_INBOUND", undefined, &"KILLSTREAK_MICROWAVE_TURRET_HACKED", false );
	killstreaks::register_dialog( "microwave_turret", "mpl_killstreak_turret", "microwaveTurretDialogBundle", undefined, "friendlyMicrowaveTurret", "enemyMicrowaveTurret", "enemyMicrowaveTurretMultiple", "friendlyMicrowaveTurretHacked", "enemyMicrowaveTurretHacked", "requestMicrowaveTurret", "threatMicrowaveTurret" );
	
	level.microwaveOpenAnim = %o_turret_guardian_open;
	level.microwaveCloseAnim = %o_turret_guardian_close;
	
	clientfield::register( "vehicle", "turret_microwave_open", 1, 1, "int" );
	clientfield::register( "scriptmover", "turret_microwave_init", 1, 1, "int" ); // re-export model in close position to save this clientfield
	clientfield::register( "scriptmover", "turret_microwave_close", 1, 1, "int" );
	clientfield::register( "vehicle", "turret_microwave_sounds", 1, 1, "int" );
	
	vehicle::add_main_callback( "microwave_turret", &InitTurretVehicle );
	
	callback::on_spawned( &on_player_spawned );
}

function InitTurretVehicle()
{
	turretVehicle = self;
	//turretVehicle.delete_on_death = true;

	turretVehicle killstreaks::setup_health( "microwave_turret" );
	turretVehicle.damageTaken = 0;
	turretVehicle.health = turretVehicle.maxhealth;
	
	turretVehicle turret::set_max_target_distance( ( 750 ) * 1.2, 0 );
	turretVehicle turret::set_on_target_angle( (15), 0 );
	turretVehicle clientfield::set( "enemyvehicle", 1 );
	turretVehicle.soundmod = "hpm";
	
	turretVehicle.overrideVehicleDamage = &OnTurretDamage;
	turretVehicle.overrideVehicleDeath = &OnTurretDeath;
	
	turretVehicle.aim_only_no_shooting = true;
}

function on_player_spawned()
{
	player = self;
	
	// needs to reset this whenever a player spawns, could be switching teams and this var remains defined
	player.beingMicrowaved = undefined;
}

function ActivateMicrowaveTurret()
{
	player = self;
	assert( IsPlayer( player ) );
	
	killstreakId = self killstreakrules::killstreakStart( "microwave_turret", player.team, false, false );
	if( killstreakId == (-1) )
	{
		return false;
	}
	
	bundle = level.killstreakBundle["microwave_turret"];
	
	turret = player placeables::SpawnPlaceable( "microwave_turret", killstreakId, 
	                                            &OnPlaceTurret, &OnCancelPlacement, &OnPickupTurret, &OnShutdown, undefined, &OnEMP,
	                                            "wpn_t7_none_world", "veh_t7_turret_guardian_yellow", "veh_t7_turret_guardian_red",
	                                            &"KILLSTREAK_MICROWAVE_TURRET_PICKUP", 90000, undefined, ( ( 1800 ) + 1 ),
	                                            bundle.ksPlaceableHint, bundle.ksPlaceableInvalidLocationHint );
	turret killstreaks::setup_health( "microwave_turret" );
	turret.damageTaken = 0;
	turret thread WatchKillstreakEnd( killstreakId, player.team );
	turret thread util::ghost_wait_show();
	turret clientfield::set( "turret_microwave_init", 1 );
	
	event = turret util::waittill_any_return( "placed", "cancelled", "death" );
	if( event != "placed" )
	{
		return false;
	}
	
	return true;
}

function OnPlaceTurret( turret )
{
	player = self;
	assert( IsPlayer( player ) );
	
	if( isdefined( turret.vehicle ) )
	{
		turret.vehicle.origin = turret.origin;
		turret.vehicle.angles = turret.angles;
		turret.vehicle thread util::ghost_wait_show( 0.05 );
		//turret.vehicle playsound ("wpn_micro_turret_start");
	}
	else
	{
		turret.vehicle = SpawnVehicle( "microwave_turret", turret.origin, turret.angles, "dynamic_spawn_ai" );
		turret.vehicle.owner = player;
		turret.vehicle SetOwner( player );
		turret.vehicle.ownerEntNum = player.entNum;
		turret.vehicle.parentStruct = turret;
		
		turret.vehicle.team = player.team;
		turret.vehicle SetTeam( player.team );
		turret.vehicle turret::set_team( player.team, 0 );
		turret.vehicle.ignore_vehicle_underneath_splash_scalar = true;
		turret.vehicle.turret = turret;

		turret.vehicle thread util::ghost_wait_show( 0.05 );

		level thread popups::DisplayKillstreakTeamMessageToAll( "microwave_turret", player );
		
		turret.vehicle killstreaks::configure_team( "microwave_turret", turret.killstreakId, player );
		turret.vehicle killstreak_hacking::enable_hacking( "microwave_turret", &HackedPreFunction, &HackedPostFunction );
		player killstreaks::play_killstreak_start_dialog( "microwave_turret", player.pers["team"], turret.killstreakId );
	}

	turret.vehicle turret::enable( 0, false );
	Target_Set( turret.vehicle, ( 0, 0, 36 ) );
	
	turret StartMicrowave();
}

function HackedPreFunction( hacker )
{
	turretVehicle = self;
	turretvehicle.turret notify( "hacker_delete_placeable_trigger" );
	turretvehicle.turret StopMicrowave();
	turretvehicle.turret killstreaks::configure_team( "microwave_turret", turretvehicle.turret.killstreakId, hacker, undefined, undefined, undefined, true );
}

function HackedPostFunction( hacker )
{
	turretVehicle = self;
	turretvehicle.turret StartMicrowave();
}

function OnCancelPlacement( turret )
{
	turret notify( "microwave_turret_shutdown" );
}

function OnPickupTurret( turret )
{
	turret StopMicrowave();
	
	turret.vehicle thread GhostAfterWait( 0.05 );
	turret.vehicle turret::disable( 0 );

	Target_Remove( turret.vehicle );
	
	//turret.vehicle playsound ("wpn_micro_turret_stop");
}

function GhostAfterWait( wait_time )
{
	self endon( "death" );
	
	wait wait_time;
	self Ghost();
}

function OnEMP( attacker )
{
	turret = self;
	//TODO: Play Turret EMP FX
}

function OnTurretDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	empDamage = int( iDamage + ( self.healthdefault * ( 1 ) ) + 0.5 );
	
	iDamage = self killstreaks::OnDamagePerWeapon( "microwave_turret", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, self.maxhealth, undefined, self.maxhealth*0.4, undefined, empDamage, undefined, true, 1.0 );
	self.damageTaken += iDamage;
	return iDamage;
}

function OnTurretDeath( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	turretVehicle = self;
	
	if ( isdefined( turretVehicle.parentStruct ) )
	{
		turretVehicle.parentStruct placeables::ForceShutdown();
		
		turretVehicle.parentStruct killstreaks::play_destroyed_dialog_on_owner( turretVehicle.parentStruct.killstreakType, turretVehicle.parentStruct.killstreakId );
	}
	
	if ( IsPlayer( eAttacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_microwave_turret", eAttacker, self, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_MICROWAVE_TURRET", eAttacker.entnum );
	}
	
	if ( isdefined( turretVehicle.parentStruct ) )
	{
		turretVehicle.parentStruct notify( "microwave_turret_shutdown" );
	}
	
	turretVehicle vehicle_death::death_fx();
	
	wait 0.1;
	
	turretVehicle delete();
}

function OnShutdown( turret )
{
	turret StopMicrowave();
	
	if ( isdefined( turret.vehicle ) )
	{
		turret.vehicle playsound ("mpl_m_turret_exp");
		turret.vehicle Kill();
	}

	turret notify( "microwave_turret_shutdown" );
}

function WatchKillstreakEnd( killstreak_id, team )
{
	turret = self;

	turret waittill( "microwave_turret_shutdown" );
	
	killstreakrules::killstreakStop( "microwave_turret", team, killstreak_id );
}

function StartMicrowave()
{
	turret = self;
	if ( isdefined( turret.trigger ) ) 
	{
		turret.trigger delete();
	}
	turret.trigger = spawn("trigger_radius", turret.origin + (0,0,-( 750 )), level.aiTriggerSpawnFlags | level.vehicleTriggerSpawnFlags, ( 750 ), ( 750 )*2);
	turret thread TurretThink();
	
	turret clientfield::set( "turret_microwave_close", 0 );
	
	if ( isdefined( turret.vehicle ))
	{
		turret.vehicle clientfield::set( "turret_microwave_open", 1 );
	}

	turret turret::CreateTurretInfluencer( "turret" );
	turret turret::CreateTurretInfluencer( "turret_close" );
	
	/#
		turret thread TurretDebugWatch();
	#/
}

function StopMicrowave()
{
	turret = self;
	turret spawning::remove_influencers();
	
	if( isdefined( turret ) )
	{
		turret clientfield::set( "turret_microwave_close", 1 );
		
		if ( isdefined( turret.vehicle ) )
		{
			turret.vehicle clientfield::set( "turret_microwave_sounds", ( 0 ) );
			turret.vehicle clientfield::set( "turret_microwave_open", 0 );
		}
		
		turret playsound ("mpl_microwave_beam_off");

		turret.microwaveFXHash = undefined;
		turret.microwaveFXHashRight = undefined;
		turret.microwaveFXHashLeft = undefined;
		if( isdefined( turret.microwaveFXEnt ) )
		{
			turret.microwaveFXEnt delete();
			
			// /# IPrintLnBold( "Deleted Microwave Fx Ent: " + GetTime() ); #/
		}
		
		if( isdefined( turret.trigger ) )
		{
			turret.trigger notify( "microwave_end_fx" );
			turret.trigger Delete();
		}
		
		/#
			turret notify( "stop_turret_debug" );
		#/
	}
}

function TurretDebugWatch()
{
	turret = self;
	turret endon( "stop_turret_debug" );

	for(;;)
	{
		if ( GetDvarInt( "scr_microwave_turret_debug" ) != 0 )
		{
			turret TurretDebug();
			
			{wait(.05);};
		}
		else
		{
			wait 1.0;
		}
	}
}

function TurretDebug()
{
	turret = self;

	debug_line_frames = 3;
	
	angles = turret.vehicle GetTagAngles( "tag_flash" );
	origin = turret.vehicle GetTagOrigin( "tag_flash" );
		
	cone_apex =	origin;
	forward = AnglesToForward( angles ) ;
	dome_apex = cone_apex + VectorScale( forward, ( 750 ) );

	util::debug_spherical_cone( cone_apex, dome_apex, ( 15 ), 16, ( 0.95, 0.1, 0.1 ), 0.3, true, debug_line_frames );
}


function TurretThink()
{
	turret = self;
	turret endon( "microwave_turret_shutdown" );
	
	turret.trigger endon( "death" );
	turret.trigger endon( "delete" );
	
//	turret thread StartMicrowaveFx();
//	turret thread UpdateMicrowaveAim();

	while( true )
	{
		turret.trigger waittill( "trigger", ent );
		
		if( !isdefined( ent.beingMicrowaved ) || !ent.beingMicrowaved )
		{
			turret thread MicrowaveEntity( ent );
		}
	}
}

function StartMicrowaveFx()
{
	turret = self;
	turret endon( "microwave_turret_shutdown" );
	turret.trigger endon( "death" );
	turret.trigger endon( "microwave_end_fx" );
	turret.should_update_fx = true;

	wait 0.1;
	
	while( true )
	{
		if ( turret.should_update_fx == false )
		{
			wait ( 1.0 );
			continue;
		}
		
		// limit traces per frame when there are multiple microwave turrets on the field
		if ( isdefined( level.last_microwave_turret_fx_trace ) && level.last_microwave_turret_fx_trace == GetTime() )
		{
			{wait(.05);};
			
			// /# IPrintLnBold( "Delaying microwave turret fx!  Time: " + GetTime() ); #/
			continue;
		}

		angles = turret.vehicle GetTagAngles( "tag_flash" );
		origin = turret.vehicle GetTagOrigin( "tag_flash" );
		forward = AnglesToForward( angles );
		forward = VectorScale( forward, ( 750 ) );
		forwardRight = AnglesToForward( angles - (0, ( 55 ) / 3, 0) );
		forwardRight = VectorScale( forwardRight, ( 750 ) );
		forwardLeft = AnglesToForward( angles + (0, ( 55 ) / 3, 0) );
		forwardLeft = VectorScale( forwardLeft, ( 750 ) );
	
		trace = BulletTrace( origin, origin + forward, false, turret );
		traceRight = BulletTrace( origin, origin + forwardRight, false, turret );
		traceLeft = BulletTrace( origin, origin + forwardLeft, false, turret );
		
		FXHash = self MicrowaveFxHash( trace, origin );
		FXHashRight = self MicrowaveFxHash( traceRight, origin );
		FXHashLeft = self MicrowaveFxHash( traceLeft, origin );
		
		level.last_microwave_turret_fx_trace = getTime();

		if( isdefined( self.microwaveFXHash ) && turret.microwaveFXHash == FXHash &&  
		    isdefined( self.microwaveFXHashRight ) && turret.microwaveFXHashRight == FXHashRight && 
		    isdefined( self.microwaveFXHashLeft ) && turret.microwaveFXHashLeft == FXHashLeft )
		{
			wait ( 1.0 );
			continue;
		}
				
		if ( isdefined ( turret.microwaveFXEnt ) ) 
		{
			 turret.microwaveFXEnt util::deleteAfterTime( 0.1 );
		}
		
		turret.microwaveFXEnt = spawn("script_model", origin);
		turret.microwaveFXEnt SetModel("tag_microwavefx");
		turret.microwaveFXEnt.angles = angles;
			
		turret.microwaveFXHash = FXHash;
		turret.microwaveFXHashRight = FXHashRight;
		turret.microwaveFXHashLeft = FXHashLeft;
		//turret playsound ("mpl_microwave_beam_on");
		
		if ( isdefined ( turret.vehicle ) )
		{
			turret.vehicle clientfield::set( "turret_microwave_sounds", ( 1 ) );
		}
		
		wait( 0.1 );
		
		turret.microwaveFXEnt PlayMicrowaveFx( trace, traceRight, TraceLeft, origin );
		turret.should_update_fx = false;
		
		wait ( 1.0 );
	}
}

function UpdateMicrowaveAim()
{
	turret = self;
	turret endon( "microwave_turret_shutdown" );
	turret.trigger endon( "death" );

	while( true )
	{
		angles = turret.vehicle GetTagAngles( "tag_flash" );
		origin = turret.vehicle GetTagOrigin( "tag_flash" );
		
		if ( isdefined( turret.microwaveFXEnt ) )
		{
			if ( turret.microwaveFXEnt.origin != origin || turret.microwaveFXEnt.angles != angles )
			{
				turret.microwaveFXEnt.origin = origin;
				turret.microwaveFXEnt.angles = angles;
				
				turret.should_update_fx = true;
			}
		}
		
		wait 0.1;
	}
}

function MicrowaveFxHash( trace, origin )
{
	hash = 0;
	counter = 2;
	for ( i = 0; i < 5; i++ )
	{
		distSq = ( (( i * ( 135 ) ) + ( 68 + 34 )) * (( i * ( 135 ) ) + ( 68 + 34 )) );
		distPlusHalfSq = ( (( i * ( 135 ) ) + ( 68 ) + ( 68 + 34 )) * (( i * ( 135 ) ) + ( 68 ) + ( 68 + 34 )) );

		traceDistSq = DistanceSquared( origin, trace[ "position" ] );
		if( traceDistSq >= distSq )
		{
			if ( traceDistSq < distPlusHalfSq )
			{
				hash += 1;
			}
			else
			{
				hash += counter;
			}
		}
		
		counter *= 2;
	}
	return hash;
}

function PlayMicrowaveFx( trace, traceRight, traceLeft, origin )
{
	rows = 5;
	
	// /# IPrintLnBold( "Playing Microwave Fx: " + GetTime() ); #/
	
	for ( i = 0; i < rows; i++ )
	{
		distSq = ( (( i * ( 135 ) ) + ( 68 + 34 )) * (( i * ( 135 ) ) + ( 68 + 34 )) );
		distPlusHalfSq = ( (( i * ( 135 ) ) + ( 68 ) + ( 68 + 34 )) * (( i * ( 135 ) ) + ( 68 ) + ( 68 + 34 )) );
		
/#
		if ( GetDvarInt( "scr_microwave_turret_fx_debug" ) && i == 0 )
		{
			// TODO: makes this debug better by creating a separate thread, maybe
			util::debug_sphere( origin + VectorNormalize( trace[ "position" ] - origin ) * ( 68 ), 6, ( 0.95, 0.05, 0.05 ), 0.75, 20 * 20 );
			util::debug_sphere( origin + VectorNormalize( trace[ "position" ] - origin ) * ( 135 ), 6, ( 0.05, 0.05, 0.95 ), 0.75, 20 * 20 );
		}
#/
		traceDistSq = DistanceSquared( origin, trace[ "position" ] );
		if ( traceDistSq >= distSq || i == 0 )
		{
			fxName = ( ( traceDistSq < distPlusHalfSq ) ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash" );

			switch ( i )
			{
				case 0:
					PlayFxOnTag( fxName, self, "tag_fx11" );
					{wait(.05);};
					break;					
				case 1:
					break;
				case 2:
					PlayFxOnTag( fxName, self, "tag_fx32" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( fxName, self, "tag_fx42" );
					{wait(.05);};
					PlayFxOnTag( fxName, self, "tag_fx43" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( fxName, self, "tag_fx53" );
					{wait(.05);};
					break;
			}
		}
		
		traceDistSq = DistanceSquared( origin, traceLeft[ "position" ] );
		if ( traceDistSq >= distSq )
		{
			fxName = ( ( traceDistSq < distPlusHalfSq ) ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash" );
			
			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( fxName, self, "tag_fx22" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( fxName, self, "tag_fx33" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( fxName, self, "tag_fx44" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( fxName, self, "tag_fx54" );	
					{wait(.05);};				
					PlayFxOnTag( fxName, self, "tag_fx55" );
					{wait(.05);};
					break;
			}
		}
		
		traceDistSq = DistanceSquared( origin, traceRight[ "position" ] );
		if ( traceDistSq >= distSq )
		{
			fxName = ( ( traceDistSq < distPlusHalfSq ) ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash" );

			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( fxName, self, "tag_fx21" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( fxName, self, "tag_fx31" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( fxName, self, "tag_fx41" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( fxName, self, "tag_fx51" );	
					{wait(.05);};				
					PlayFxOnTag( fxName, self, "tag_fx52" );
					{wait(.05);};
					break;
			}
		}
	}

	// /# IPrintLnBold( "Done playing Microwave Fx: " + GetTime() ); #/
}

function MicrowaveEntityPostShutdownCleanup( entity )
{
	entity endon( "disconnect" );
	entity endon( "end_MicrowaveEntityPostShutdownCleanup" );

	turret = self;
	
	turret waittill( "microwave_turret_shutdown" );
	
	if ( isdefined(entity) )
	{
		entity.beingMicrowaved = false;
		entity.beingMicrowavedBy = undefined;
	}
}

function MicrowaveEntity( entity )
{
	turret = self;
			
	turret endon( "microwave_turret_shutdown" );
	entity endon( "disconnect" );
	entity endon( "death" );
	
	if ( IsPlayer( entity ) )
	{
		entity endon( "joined_team" );
		entity endon( "joined_spectators" );
	}

	turret thread MicrowaveEntityPostShutdownCleanup( entity );

	entity.beingMicrowaved = true;
	entity.beingMicrowavedBy = self.owner;
	entity.microwaveDamageInitialDelay = true;
	entity.microwaveEffect = 0;
	
	shellShockScalar = 1;
	viewKickScalar = 1;
	damageScalar = 1;
	
	if ( IsPlayer( entity ) && entity hasPerk( "specialty_microwaveprotection" ) )
	{
		shellShockScalar = getDvarFloat( "specialty_microwaveprotection_shellshock_scalar", 0.5 );
		viewKickScalar = getDvarFloat( "specialty_microwaveprotection_viewkick_scalar", 0.5 );
		damageScalar = getDvarFloat( "specialty_microwaveprotection_damage_scalar", 0.5 );
	}

	turretWeapon = GetWeapon( "microwave_turret" );
	
	while( true )
	{
		if( !isdefined( turret ) || !turret MicrowaveTurretAffectsEntity( entity ) || !isdefined( turret.trigger ) )
		{
			if( !isdefined(entity))
			{
				return;
			}
			
			entity.beingMicrowaved = false;
			entity.beingMicrowavedBy = undefined;
			
			if( isdefined( entity.microwavePoisoning ) && entity.microwavePoisoning )
			{
				entity.microwavePoisoning = false;
			}
			
			entity notify( "end_MicrowaveEntityPostShutdownCleanup" );
			
			return;
		}
		
		damage = ( 10 ) * damageScalar;
		
		if ( level.hardcoreMode )
		{
			damage = damage / 2;	
		}
		
		if ( !IsAi( entity ) && entity util::mayApplyScreenEffect() )
		{
			if ( !isdefined( entity.microwavePoisoning ) || !entity.microwavePoisoning )
			{
				entity.microwavePoisoning = true;
				entity.microwaveEffect = 0;
			}
		}
		
		// randomly wait a bit before applying intial damage to "stagger" it and prevent performance spikes
		if ( isdefined( entity.microwaveDamageInitialDelay ) )
		{
			wait RandomFloatRange( ( 0.1 ), ( 0.3 ) );
			entity.microwaveDamageInitialDelay = undefined;
		}

		entity DoDamage( damage, 							// iDamage Integer specifying the amount of damage done
						 turret.origin, 					// vPoint The point the damage is from?
						 turret.owner, 						// eAttacker The entity that is attacking.
						 turret.vehicle, 					// eInflictor The entity that causes the damage.(e.g. a turret)
						 0, 
						 "MOD_TRIGGER_HURT", 				// sMeansOfDeath Integer specifying the method of death
						 0, 								// iDFlags Integer specifying flags that are to be applied to the damage
						 turretWeapon );						// Weapon The weapon used to inflict the damage

		entity.microwaveEffect++;
		
		if( IsPlayer(entity) && !(entity IsRemoteControlling() ) )
		{
			if( entity.microwaveEffect % 2 == 1 )
			{
				if ( DistanceSquared( entity.origin, turret.origin ) > (( 750 ) * 2/3) * (( 750 ) * 2/3) )
				{			    
					entity shellshock( "mp_radiation_low", 1.5 * shellShockScalar );
					entity ViewKick( int( 25 * viewKickScalar ), turret.origin );
				}
				else if ( DistanceSquared( entity.origin, turret.origin ) > (( 750 ) * 1/3) * (( 750 ) * 1/3) )
				{			    
					entity shellshock( "mp_radiation_med", 1.5 * shellShockScalar );
					entity ViewKick( int( 50 * viewKickScalar ), turret.origin );
				}
				else
				{
					entity shellshock( "mp_radiation_high", 1.5 * shellShockScalar );
					entity ViewKick( int( 75 * viewKickScalar ), turret.origin );
				}
			}
		}
		
		if( IsPlayer( entity ) && entity.microwaveEffect % 3 == 2 )
		{
			scoreevents::processScoreEvent( "hpm_suppress", turret.owner, entity, turretWeapon );
		}
		
		wait 0.5;
	}
}

function MicrowaveTurretAffectsEntity( entity )
{
	turret = self;
	
	if( !IsAlive( entity ) )
	{
		return false;
	}
		
	if( !IsPlayer( entity ) && !IsAi( entity ) )
	{
		return false;
	}
		
	if( isdefined( turret.carried ) && turret.carried )
	{
		return false;
	}
		
	if( turret weaponobjects::isStunned() )
	{
		return false;
	}
	
	if( isdefined( turret.owner ) && entity == turret.owner )
	{
		return false;
	}
	
	if( !weaponobjects::friendlyFireCheck( turret.owner, entity, 0 ) )
	{
		return false;
	}
	
	if( DistanceSquared( entity.origin, turret.origin ) > ( 750 ) * ( 750 ) )
	{
		return false;
	}
	
	angles = turret.vehicle GetTagAngles( "tag_flash" );
	origin = turret.vehicle GetTagOrigin( "tag_flash" );	
	
	shoot_at_pos = entity GetShootAtPos( turret );

	entDirection = vectornormalize( shoot_at_pos - origin );
	forward = AnglesToForward( angles ) ;
	dot = vectorDot( entDirection, forward );
	if( dot < cos( ( 15 ) ) )
	{
		return false;
	}
	
	if( entity damageConeTrace( origin, turret, forward ) <= 0 )
	{
		return false;
	}

	return true;
}
