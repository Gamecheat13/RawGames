#using scripts\codescripts\struct;
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\killstreaks\_turret;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\entityheadicons_shared;

#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );

#precache( "string", "KILLSTREAK_AUTO_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AIRSPACE_FULL" );
#precache( "string", "KILLSTREAK_EARNED_MICROWAVE_TURRET" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE" );
#precache( "eventstring", "mpl_killstreak_turret" );
#precache( "eventstring", "mpl_killstreak_auto_turret" );
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
#precache( "fx", "explosions/fx_exp_equipment_lg" );
#precache( "model", "t6_wpn_turret_sentry_gun_yellow" );
#precache( "model", "t6_wpn_turret_sentry_gun_red" );

#using_animtree( "mp_microwaveturret" );


#namespace microwave_turret;

function init()
{
	killstreaks::register( "microwave_turret", "microwave_turret", "killstreak_" + "microwave_turret", "microwave_turret" + "_used", &ActivateMicrowaveTurret, false, true );
	killstreaks::register_strings( "microwave_turret", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
	killstreaks::register_dialog( "microwave_turret", "mpl_killstreak_turret", 14, undefined, 98, 116, 98 );
	
	level.microwaveOpenAnim = %o_hpm_open;
	level.microwaveCloseAnim = %o_hpm_close;
	level.microwaveDestroyedAnim = %o_hpm_destroyed;
	
	clientfield::register( "scriptmover", "turret_microwave_open", 1, 1, "int" );
	clientfield::register( "scriptmover", "turret_microwave_close", 1, 1, "int" );
	clientfield::register( "scriptmover", "turret_microwave_destroy", 1, 1, "int" );	
	clientfield::register( "scriptmover", "turret_microwave_sounds", 1, 1, "int" );
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
	
	maxhealth = ( 1800 );
	
	tableHealth = killstreaks::get_max_health( "microwave_turret" );
	
	if ( isdefined( tableHealth ) )
	{
		maxhealth = tableHealth;
	}	
	
	turret = player placeables::SpawnPlaceable( "microwave_turret", killstreakId, 
	                                            &OnPlaceTurret, &OnCancelPlacement, &OnPickupTurret, &OnShutdown, &OnDeath, &OnEMP,
	                                            "t6_wpn_turret_ads_world", "t6_wpn_turret_ads_carry", "t6_wpn_turret_ads_carry_red",
	                                            &"KILLSTREAK_MICROWAVE_TURRET_PICKUP", 90000, maxhealth, ( ( 1800 ) + 1 ) );
	
	turret thread WatchKillstreakEnd( killstreakId, player.team );
	
	event = turret util::waittill_any_return( "placed", "cancelled", "death" );
	if( event != "placed" )
	{
		return false;
	}
	
	self killstreaks::play_killstreak_start_dialog( "microwave_turret", self.team );
	
	return true;
}

function OnPlaceTurret( turret )
{
	player = self;
	assert( IsPlayer( player ) );
	
	turret placeables::UpdatePlacementModels( "t6_wpn_turret_ads_world", "t6_wpn_turret_ads_carry_animate", "t6_wpn_turret_ads_carry_animate_red" );
	
	forward = AnglesToForward( turret.angles );
	forwardOffset = VectorScale( forward, ( -100 ) );
	killcamPos = turret.origin + forwardOffset + ( 0, 0, 100 );
	turret.killCamEnt = spawn( "script_model", killcamPos );
	turret entityheadicons::setEntityHeadIcon( player.team, turret, ( 0, 0, 80 ) );
	
	turret StartMicrowave();
}

function OnCancelPlacement( turret )
{
	turret notify( "microwave_turret_shutdown" );
}

function OnPickupTurret( turret )
{
	turret.killCamEnt Delete();
	turret StopMicrowave();
	turret entityheadicons::destroyEntityHeadIcons();
}

function OnEMP( attacker )
{
	turret = self;
	//TODO: Play Turret EMP FX
}

function OnDeath( attacker, weapon )
{
	turret = self;
	scoreevents::processScoreEvent( "destroyed_microwave_turret", attacker, turret, weapon );
	turret notify( "microwave_turret_shutdown" );
}

function OnShutdown( turret )
{
	turret StopMicrowave();
	turret notify( "microwave_turret_shutdown" );
}

function WatchKillstreakEnd( killstreak_id, team )
{
	turret = self;
	turret waittill( "microwave_turret_shutdown" );

	if( isdefined( turret.killCamEnt ) )
	{
		turret.killCamEnt delete();
	}
	
	killstreakrules::killstreakStop( "microwave_turret", team, killstreak_id );
}

function StartMicrowave()
{
	turret = self;
	turret.trigger = spawn("trigger_radius", turret.origin + (0,0,-( 750 )), level.aiTriggerSpawnFlags | level.vehicleTriggerSpawnFlags, ( 750 ), ( 750 )*2);
	turret thread TurretThink();
	
	turret clientfield::set( "enemyvehicle", 1 );
	turret clientfield::set( "turret_microwave_close", 0 );
	turret clientfield::set( "turret_microwave_open", 1 );

	turret turret::CreateTurretInfluencer( "turret" );
	turret turret::CreateTurretInfluencer( "turret_close" );
}

function StopMicrowave()
{
	turret = self;
	turret spawning::remove_influencers();
	
	if( isdefined( turret ) )
	{
		turret clientfield::set( "turret_microwave_sounds", ( 0 ) );

		turret.microwaveFXHash = undefined;
		turret.microwaveFXHashRight = undefined;
		turret.microwaveFXHashLeft = undefined;
		if( isdefined( turret.microwaveFXEnt ) )
		{
			turret.microwaveFXEnt delete();
		}
		
		if( isdefined( turret.trigger ) )
		{
			turret.trigger notify( "microwave_end_fx" );
			turret.trigger Delete();
		}
	}
}

function TurretThink()
{
	turret = self;
	turret endon( "microwave_turret_shutdown" );
	
	turret.trigger endon( "death" );
	turret.trigger endon( "delete" );
	
	turret thread StartMicrowaveFx();

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

	waitAmount = ( 15 );
	
	while( true )
	{
		angles = self GetTagAngles( "tag_flash" );
		origin = self GetTagOrigin( "tag_flash" );
		forward = AnglesToForward( angles );
		forward = VectorScale( forward, ( 750 ) );
		forwardRight = AnglesToForward( angles - (0, ( 75 ) / 3, 0) );
		forwardRight = VectorScale( forwardRight, ( 750 ) );
		forwardLeft = AnglesToForward( angles + (0, ( 75 ) / 3, 0) );
		forwardLeft = VectorScale( forwardLeft, ( 750 ) );
	
		trace = BulletTrace( origin, origin + forward, false, turret );
		traceRight = BulletTrace( origin, origin + forwardRight, false, turret );
		traceLeft = BulletTrace( origin, origin + forwardLeft, false, turret );
		
		FXHash = self MicrowaveFxHash( trace, origin );
		FXHashRight = self MicrowaveFxHash( traceRight, origin );
		FXHashLeft = self MicrowaveFxHash( traceLeft, origin );
		if( isdefined( self.microwaveFXHash ) && turret.microwaveFXHash == FXHash &&  
		    isdefined( self.microwaveFXHashRight ) && turret.microwaveFXHashRight == FXHashRight && 
		    isdefined( self.microwaveFXHashLeft ) && turret.microwaveFXHashLeft == FXHashLeft )
		{
			return;
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
		
		wait( 0.1 );
		
		turret.microwaveFXEnt PlayMicrowaveFx( trace, traceRight, TraceLeft, origin );
		turret clientfield::set( "turret_microwave_sounds", ( 1 ) );
		wait( waitAmount );
	}
}

function MicrowaveFxHash( trace, origin )
{
	hash = 0;
	counter = 1;
	for ( i = 0; i < 5; i++ )
	{
		distSq = ( i * ( 135 ) ) * ( i * ( 135 ) );

		if( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			hash += counter;
		}
		
		counter *= 2;
	}
	return hash;
}

function PlayMicrowaveFx( trace, traceRight, traceLeft, origin )
{
	rows = 5;
	
	for ( i = 0; i < rows; i++ )
	{
		distSq = ( i * ( 135 ) ) * ( i * ( 135 ) );

		if ( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx11" );
					{wait(.05);};
					break;					
				case 1:
					break;
				case 2:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx32" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx42" );
					{wait(.05);};
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx43" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx53" );
					{wait(.05);};
					break;
			}
		}
		
		if ( DistanceSquared( origin, traceLeft[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx22" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx33" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx44" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx54" );	
					{wait(.05);};				
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx55" );
					{wait(.05);};
					break;
			}
		}
		
		if ( DistanceSquared( origin, traceRight[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx21" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx31" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx41" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx51" );	
					{wait(.05);};				
					PlayFxOnTag( "killstreaks/fx_sg_distortion_cone_ash", self, "tag_fx52" );
					{wait(.05);};
					break;
			}
		}
	}
}

function MicrowaveEntityPostShutdownCleanup( entity )
{
	entity endon( "disconnect" );
	
	self waittill( "microwave_turret_shutdown" );
	
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
	
	turret thread MicrowaveEntityPostShutdownCleanup( entity );

	entity.beingMicrowaved = true;
	entity.beingMicrowavedBy = self.owner;
	entity.microwaveEffect = 0;
	
	turreWeapon = GetWeapon( "microwave_turret" );
	
	// randomly wait a bit before applying intial damage to "stagger" it and prevent performance spikes
	wait RandomFloatRange( ( 0.1 ), ( 0.3 ) );
	
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
			return;
		}
		
		damage = ( 10 );
		
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

		entity DoDamage( damage, 							// iDamage Integer specifying the amount of damage done
						 turret.origin, 						// vPoint The point the damage is from?
						 turret.owner, 						// eAttacker The entity that is attacking.
						 turret, 								// eInflictor The entity that causes the damage.(e.g. a turret)
						 0, 
						 "MOD_TRIGGER_HURT", 				// sMeansOfDeath Integer specifying the method of death
						 0, 								// iDFlags Integer specifying flags that are to be applied to the damage
						 turreWeapon );						// Weapon The weapon used to inflict the damage

		entity.microwaveEffect++;
		
		if( IsPlayer(entity) && !(entity IsRemoteControlling() ) )
		{
			if( entity.microwaveEffect % 2 == 1 )
			{
				if ( DistanceSquared( entity.origin, turret.origin ) > (( 750 ) * 2/3) * (( 750 ) * 2/3) )
				{			    
					entity shellshock( "mp_radiation_low", 1.5 );
					entity ViewKick( 25, turret.origin );
				}
				else if ( DistanceSquared( entity.origin, turret.origin ) > (( 750 ) * 1/3) * (( 750 ) * 1/3) )
				{			    
					entity shellshock( "mp_radiation_med", 1.5 );
					entity ViewKick( 50, turret.origin );
				}
				else
				{
					entity shellshock( "mp_radiation_high", 1.5 );
					entity ViewKick( 75, turret.origin );
				}
			}
		}
		
		if( IsPlayer( entity ) && entity.microwaveEffect % 3 == 2 )
		{
			scoreevents::processScoreEvent( "hpm_suppress", turret.owner, entity, turreWeapon );
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
		
	entDirection = vectornormalize( entity.origin - turret.origin );
	forward = anglesToForward( turret.angles );
	dot = vectorDot( entDirection, forward );
	if( dot < cos( ( 15 ) ) )
	{
		return false;
	}
	
	pitchDifference =  int( abs( vectortoangles(entDirection)[0] - turret.angles[0])) % 360;
	if( pitchDifference > 15 && pitchDifference < 345 )
	{
		return false;
	}
	
	if( entity damageConeTrace( turret.origin + (0,0,40), turret ) <= 0 )
	{
		return false;
	}
	
	return true;
}
