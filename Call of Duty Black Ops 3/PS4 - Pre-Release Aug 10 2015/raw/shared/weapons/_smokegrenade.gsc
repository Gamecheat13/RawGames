#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace smokegrenade;



function init_shared()
{
	level.willyPeteDamageRadius = 300;	
	level.willyPeteDamageHeight = 128;	
	level.smokeGrenadeDuration = 8;
	level.smokeGrenadeDissipation = 4;
	level.smokeGrenadeTotalTime = level.smokeGrenadeDuration + level.smokeGrenadeDissipation;
	level.fx_smokegrenade_single = "smoke_center";
	level.smoke_grenade_triggers = [];
	
	callback::on_spawned( &on_player_spawned );
}

function watchSmokeGrenadeDetonation( owner, statWeapon, grenadeWeaponName, duration, totalTime )
{	
	self endon( "trophy_destroyed" );
	
	owner AddWeaponStat( statWeapon, "used", 1 );

	self waittill( "explode", position, surface );
	
	oneFoot = ( 0, 0, 12 );
	startPos = position + oneFoot;

	smokeWeapon = GetWeapon( grenadeWeaponName );
	smokeDetonate( owner, statWeapon, smokeWeapon, position, 128, totalTime, duration );
	
	// do a little damage because it's white phosphorous, we want to control it here instead of the gdt entry
	damageEffectArea ( owner, startPos, smokeWeapon.explosionRadius, level.willyPeteDamageHeight, undefined );	
}	

// Spawn FX and sight blocking volumes
function smokeDetonate( owner, statWeapon, smokeWeapon, position, radius, effectLifetime, smokeBlockDuration )
{
	dir_up = (0.0, 0.0, 1.0);
	ent = SpawnTimedFX( smokeWeapon, position, dir_up, effectLifetime );
	
	ent SetTeam( owner.team );
	ent SetOwner( owner );

	ent thread smokeBlockSight( radius );
	ent thread spawnSmokeGrenadeTrigger( smokeBlockDuration );
	
	if ( isdefined ( owner ) )
	{
		owner.smokeGrenadeTime = getTime();
		owner.smokeGrenadePosition = position;
	}

	thread playSmokeSound( position, smokeBlockDuration, statWeapon.projSmokeStartSound, statWeapon.projSmokeEndSound, statWeapon.projSmokeLoopSound );
	
	return ent;
}	

function damageEffectArea ( owner, position, radius, height, killCamEnt )
{
	// spawn trigger radius for the effect areas
	effectArea = spawn( "trigger_radius", position, 0, radius, height );

	// dog stuff
	if ( isdefined( level.dogsOnFlashDogs ) )
	{
		owner thread [[level.dogsOnFlashDogs]]( effectArea );
	}

	// clean up
	effectArea delete();
}

function smokeBlockSight( radius )
{
	self endon( "death" );

	while( true )
	{
		FxBlockSight( self, radius );
		
 		/#
		if( GetDvarInt( "scr_smokegrenade_debug", 0 ) )
		{
			Sphere( self.origin, 128, (1,0,0), 0.25, false, 10, 15 );
		} 
		#/
			
		wait( 0.75 );
	}
}

function spawnSmokeGrenadeTrigger( duration )
{
	team = self.team;
	
	trigger = spawn( "trigger_radius", self.origin, 0, 128, 128 );
	
	if ( !isdefined( level.smoke_grenade_triggers ) ) level.smoke_grenade_triggers = []; else if ( !IsArray( level.smoke_grenade_triggers ) ) level.smoke_grenade_triggers = array( level.smoke_grenade_triggers ); level.smoke_grenade_triggers[level.smoke_grenade_triggers.size]=trigger;;
	self util::waittill_any_timeout( duration, "death" );
	ArrayRemoveValue( level.smoke_grenade_triggers, trigger );
	
	trigger delete();
}

function IsInSmokeGrenade()
{
	foreach( trigger in level.smoke_grenade_triggers )
	{
		if( self IsTouching( trigger ) )
		{
			return true;
		}
	}
	
	return false;
}

function on_player_spawned()
{
	self endon("disconnect");

	self thread begin_other_grenade_tracking();
}

function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self notify( "smokeTrackingStart" );	
	self endon( "smokeTrackingStart" );

	weapon_smoke = GetWeapon( "willy_pete" );

	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		if ( weapon.rootWeapon == weapon_smoke )
		{
			grenade thread watchSmokeGrenadeDetonation( self, weapon_smoke, level.fx_smokegrenade_single, level.smokeGrenadeDuration, level.smokeGrenadeTotalTime );
		}
	}
}

function playSmokeSound( position, duration, startSound, stopSound, loopSound )
{	
	smokeSound = spawn ("script_origin",(0,0,1));
	smokeSound.origin = position;
	if( isDefined( startSound ) )
	{
		smokeSound playsound( startSound );
	}
	
	if( isDefined( loopSound ) )
	{
		smokeSound playLoopSound ( loopSound );
	}
	
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	
	if( isDefined( stopSound ) )
	{
		thread sound::play_in_space( stopSound, position );
	}
	smokeSound StopLoopSound( .5);
	wait(.5);
	smokeSound delete();
}
