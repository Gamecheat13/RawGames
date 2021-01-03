#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\_burnplayer;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#namespace incendiary;

function autoexec __init__sytem__() {     system::register("incendiary_grenade",&init_shared,undefined,undefined);    }


function init_shared()
{
	level.incendiaryfireDamage = GetDvarInt( "scr_incendiaryfireDamage", 35 ); // how much damage will the fire do each tick
	level.incendiaryfireDamageHardcore = GetDvarInt( "scr_incendiaryfireDamageHardcore", 5 ); // how much damage will the fire do each tick in hardcore
 	level.incendiaryfireDuration = GetDvarInt( "scr_incendiaryfireDuration", 5 ); // time damage triggers will last.
 	level.incendiaryfxDuration = GetDvarFloat( "scr_incendiaryfxDuration", 0.4 ); // Incendiary fx duration
	level.incendiaryDamageRadius = GetDvarInt( "scr_incendiaryDamageRadius", 125 ); // radius of individual damages
	level.incendiaryfireDamageTickTime = GetDvarFloat( "scr_incendiaryfireDamageTickTime", 0.4 ); // time between damage hits
	
	
 	level.incendiaryDamageThisTick = [];
 	
	callback::on_spawned( &create_incendiary_watcher );
}

/#
function updateIncendiaryFromDvars()
{
	level.incendiaryfireDamage = GetDvarInt( "scr_incendiaryfireDamage", level.incendiaryfireDamage ); 
	level.incendiaryfireDamageHardcore = GetDvarInt( "scr_incendiaryfireDamageHardcore", level.incendiaryfireDamageHardcore ); 
 	level.incendiaryfireDuration = GetDvarInt( "scr_incendiaryfireDuration", level.incendiaryfireDuration ); 
	level.incendiaryDamageRadius = GetDvarInt( "scr_incendiaryDamageRadius", level.incendiaryDamageRadius );
	level.incendiaryfireDamageTickTime = GetDvarFloat( "scr_incendiaryfireDamageTickTime", level.incendiaryfireDamageTickTime );	
 	level.incendiaryfxDuration = GetDvarFloat( "scr_incendiaryfxDuration", level.incendiaryfxDuration );
}
#/

function create_incendiary_watcher() // self == player
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "incendiary_grenade", self.team );
	
	watcher.onSpawn = &incendiary_system_spawn;
}

function incendiary_system_spawn( watcher, player ) // self == incendiary grenade
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );
	
	player AddWeaponStat( self.weapon, "used", 1 );	
	watchForExplode( player );
}


function watchForExplode( owner )
{
	self endon( "hacked" );
	self endon( "delete" );
	owner endon( "death" );
	owner endon( "disconnect" );
	
	killCamEnt = spawn( "script_model", self.origin );
	killCamEnt util::deleteAfterTime( 15.0 );
	killCamEnt.startTime = gettime();
	killCamEnt linkto( self );
	killCamEnt setWeapon( self.weapon );

	killcamEnt killcam::store_killcam_entity_on_entity(self);
	
	self waittill( "projectile_impact_explode", origin, normal, surface );
	killCamEnt unlink();
	/#
	updateIncendiaryFromDvars();
	#/
	PlaySoundAtPosition ("wpn_incendiary_core_start" ,self.origin);
	
	generateLocations( origin, owner, normal, killCamEnt );
}

function getstepoutdistance( normal )
{
	if ( normal[2] < 0.5 )
	{
		stepoutdistance = normal * GetDvarInt( "scr_incendiary_stepout_wall", 50 );
	}
	else 
	{
		stepoutdistance = normal * GetDvarInt( "scr_incendiary_stepout_ground", 12 );
	}
	return stepoutdistance;
}

function generateLocations( position, owner, normal, killCamEnt )
{
	startPos = position + getstepoutdistance( normal );
	killCamEnt moveto(startPos + (0,0,60), .5);
	rotation = RandomInt( 360 );
	
	if ( normal[2] < 0.1 ) // vertical wall
	{
		black = ( 0.1, 0.1, 0.1 );
			
		trace = hitPos( startPos, startpos + ( -normal * 70 ) + ( 0,0, -1 ) * 70, black );
		tracePosition = trace["position"];	
		incendiaryGrenade = GetWeapon( "incendiary_fire" );
		
		if ( trace["fraction"] < 0.9 )
		{
			wallnormal = trace["normal"];

			SpawnTimedFX( incendiaryGrenade, trace["position"], wallnormal, level.incendiaryfireDuration, owner.team  );
		}
	}

	fxCount = GetDvarInt( "scr_incendiary_fx_count", 6 );
	spawnAllLocs( owner, startPos, normal, 1, rotation, killcament, fxCount );
}

function getLocationForFX( startPos, fxIndex, fxCount, defaultDistance, rotation )
{
	currentAngle = ( ( 360 / fxCount ) * fxIndex );
	cosCurrent = cos( currentAngle + rotation );
	sinCurrent = sin( currentAngle + rotation );
	
	return startPos + ( defaultDistance * cosCurrent, defaultDistance * sinCurrent, 0 );
}

function spawnAllLocs( owner, startPos, normal, multiplier, rotation, killcament, fxCount )
{
	defaultDistance = GetDvarInt( "scr_incendiary_trace_distance", 220 ) * multiplier;
	defaultDropDistance = GetDvarInt( "scr_incendiary_trace_down_distance", 90 );
	
	// DROCHE:TODO
	// if we are going to keep this grenade this should be moved to code
	
	colorArray = [];
	colorArray[colorArray.size] = ( 0.9, 0.2, 0.2 );
	colorArray[colorArray.size] = ( 0.2, 0.9, 0.2 );
	colorArray[colorArray.size] = ( 0.2, 0.2, 0.9 );
	colorArray[colorArray.size] = ( 0.9, 0.9, 0.9 );


	locations = [];
	locations["color"] = [];
	locations["loc"] = [];
	locations["tracePos"] = [];
	locations["distSqrd"] = [];
	locations["fxtoplay"] = [];
	locations["radius"] = [];

	
	for( fxIndex = 0; fxIndex < fxCount; fxIndex++ )
	{
		locations["point"][fxIndex] = getLocationForFX( startPos, fxIndex, fxCount, defaultDistance, rotation );
		locations["color"][fxIndex] = colorArray[fxIndex % colorArray.size];
	}
		
	for ( count = 0; count < fxCount; count++ )
	{
		trace = hitPos( startPos, locations["point"][count], locations["color"][count] );
		tracePosition = trace["position"];
		locations["tracePos"][count] = tracePosition;
		 
		if ( trace["fraction"] < 0.7 )
		{
			locations["loc"][count] = tracePosition;
			locations["normal"][count] = trace["normal"];
			continue;
		}
		
		average = startPos/2 + tracePosition/2;

		trace = hitPos( average, average - ( 0, 0, defaultDropDistance ), locations["color"][count] );
		if ( trace["fraction"] != 1 )
		{
			locations["loc"][count] = trace["position"];
			locations["normal"][count] = trace["normal"];
		}
	}	

	// startPos = startPos - getstepoutdistance( normal ); // start pos is already a good position for fx, we are using a different sized trigger now.
	
	incendiaryGrenade = GetWeapon( "incendiary_fire" );

	SpawnTimedFX( incendiaryGrenade, startPos, normal, level.incendiaryfireDuration, owner.team );
	
	level.incendiaryDamageRadius = GetDvarInt( "scr_incendiaryDamageRadius", level.incendiaryDamageRadius );
	
	thread damageEffectArea ( owner, startPos, level.incendiaryDamageRadius, level.incendiaryDamageRadius, killCamEnt );
	
	for ( count = 0; count < locations["point"].size; count++ )
	{
		if ( isdefined ( locations["loc"][count] ) )
		{
			normal = locations["normal"][count];
				
			SpawnTimedFX( incendiaryGrenade, locations["loc"][count], normal, level.incendiaryfireDuration, owner.team );
		}
	}
}

/#
function incendiary_debug_line( from, to, color, depthTest, time )
{
	debug_rcbomb = GetDvarInt( "scr_incendiary_debug", 0 );
	if ( debug_rcbomb == 1 )
	{
		if ( !isdefined(time) )
		{
			time = 100;
		}
		if ( !isdefined(depthTest) )
		{
			depthTest = true;
		}
		Line( from, to, color, 1, depthTest, time);
	}
}
#/
	
	

function damageEffectArea ( owner, position, radius, height, killCamEnt )
{
	trigger_radius_position = position - ( 0 , 0, height );
	trigger_radius_height = height * 2;

	fireEffectArea = spawn( "trigger_radius", trigger_radius_position, 0, radius, trigger_radius_height );
	
	// Create head icon
//	objective = GetEquipmentHeadObjective( GetWeapon( "incendiary_grenade" ) );
//	killCamEnt entityheadicons::setEntityHeadIcon( owner.pers["team"], owner, (0,0,0), objective );

/#
	if( GetDvarint( "scr_draw_triggers" ) )
		level thread util::drawcylinder( trigger_radius_position, radius, trigger_radius_height, undefined, "incendiary_draw_cylinder_stop" );
#/
	
	// raps stuff
	if ( isdefined( level.rapsOnBurnRaps ) )
	{
		owner thread [[level.rapsOnBurnRaps]]( fireEffectArea );
	}

	// loop variables
	loopWaitTime = level.incendiaryFireDamageTickTime;
	durationOfIncendiary = level.incendiaryFireDuration;

	// loop for the duration of the effect
	while (durationOfIncendiary > 0)
	{
		durationOfIncendiary -= loopWaitTime;
		damageApplied = false;
		players = GetPlayers();
		for (i = 0; i < players.size; i++)
		{
			// if this is not hardcore then don't affect teammates
			if ( level.friendlyfire == 0 )
			{
				if ( players[i] != owner )				
				{
					if (!isdefined (owner) || !isdefined(owner.team) )
						continue;
					if( level.teambased && players[i].team == owner.team )
						continue;
				}
			}

			// see if we're not in the fire area
			if ((!isdefined (players[i].infireArea)) || (players[i].infireArea == false) )
			{
				// since we're not in the poison area, now see if we're in the fire area
				if (players[i] istouching(fireEffectArea) && players[i].sessionstate == "playing")
				{
					trace = bullettrace( position, players[i] GetShootAtPos(), false, players[i], true );

					if ( trace["fraction"] == 1 )
					{
						players[i].lastburnedBy = owner;
						players[i] thread damageInFireArea( fireEffectArea, killcament, trace, position, loopWaitTime );
					}
				}	
			}
		}

		wait (loopWaitTime);
	}
	
	// Delete head icon
	if ( isdefined( killCamEnt ) )
		killCamEnt entityheadicons::destroyEntityHeadIcons();
	// clean up
	fireEffectArea delete();	

/#
	if( GetDvarint( "scr_draw_triggers" ) )
		level notify( "incendiary_draw_cylinder_stop" );
#/
}	
	
function damageInFireArea( fireEffectArea, killcament, trace, position, loopWaitTime ) // self == player in fire area
{
	self endon( "disconnect" );
	self endon( "death" );

	timer = 0;

	damage = level.incendiaryfireDamage;
	if( level.hardcoreMode )
	{
		damage = level.incendiaryfireDamageHardcore;
	}
	
	if ( canDoFireDamage( killCamEnt, self, loopWaitTime ) )
	{
/#
		level.incendiary_debug = GetDvarInt( "scr_incendiary_debug", 0 );
		if ( level.incendiary_debug )
		{
			if ( !isdefined( level.incendiaryDamageTime ) )
			{
				level.incendiaryDamageTime = GetTime();
			}

			iprintlnbold( level.incendiaryDamageTime - getTime() );
			level.incendiaryDamageTime = getTime();
		}
#/
		self DoDamage( damage, fireEffectArea.origin, self.lastburnedBy, killCamEnt, "none", "MOD_BURNED", 0, GetWeapon( "incendiary_fire" ) );
		
		entnum = self getentitynumber();

		self thread sndFireDamage();
		
		if ( self util::mayApplyScreenEffect() )
		{
			self burnplayer::SetPlayerBurning( level.incendiaryfxDuration, level.incendiaryfireDamageTickTime, 0, self );
		}
	}
}


function sndFireDamage()
{	
	self notify( "sndFire" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "sndFire" );
	
	if( !isdefined( self.sndFireEnt ) )
	{
		self.sndFireEnt = spawn( "script_origin", self.origin );
		self.sndFireEnt linkto( self, "tag_origin" );
		self.sndFireEnt playsound( "chr_burn_start" );
		self thread sndFireDamage_DeleteEnt(self.sndFireEnt);
	}
	
	self.sndFireEnt playloopsound( "chr_burn_start_loop", .5 );
	wait(3);
	self.sndFireEnt delete();
	self.sndFireEnt = undefined;
}
function sndFireDamage_DeleteEnt(ent)
{
	self endon( "disconnect" );
	self waittill( "death" );
	
	if( isdefined( ent ) )
		ent delete(); //pfx_fire_incendiary
}


function hitPos( start, end, color )
{
	trace = bullettrace( start, end, false, undefined );
	
/#
	level.incendiary_debug = GetDvarInt( "scr_incendiary_debug", 0 );
	if ( level.incendiary_debug )
	{
		debugstar(trace["position"], 2 * 1000, color);
	}

	thread incendiary_debug_line( start, trace["position"], color, true, 80 );
#/
	
	return trace;
}

function canDoFireDamage( killCamEnt, victim, time )
{
	entNum = victim getentitynumber();
	if ( !isdefined( level.incendiaryDamageThisTick[entNum] ) )
	{
		level.incendiaryDamageThisTick[entNum] = 0;
		level thread resetFireDamage( entnum, time );
		return true;
	}
	
	return false;
}

function resetFireDamage( entnum, time  )
{
	if ( time > 0.05 )
	{
		wait( time - 0.05 );
	}
	level.incendiaryDamageThisTick[entnum] = undefined;
}

	