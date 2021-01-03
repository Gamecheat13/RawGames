#using scripts\codescripts\struct;

#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                   

#namespace hive_gun;

#precache( "fx", "weapon/fx_hero_firefly_blood_os" );
#precache( "fx", "weapon/fx_hero_chem_gun_blob_death" );
#precache( "fx", "weapon/fx_hero_firefly_start" );
//#precache( "fx", "weapon/fx_hero_firefly_start_entity" );

function init_shared()
{			
	level.firefly_pod_weapon = GetWeapon("hero_chemicalgelgun");
	level.firefly_pod_secondary_explosion_weapon = GetWeapon("hive_gungun_secondary_explosion");

	level.firefly_debug = GetDvarInt( "scr_firefly_debug", 0 );
	level.firefly_pod_detection_radius = GetDvarInt( "scr_fireflyPodDetectionRadius", 180 );
	level.firefly_pod_grace_period = GetDvarFloat( "scr_fireflyPodGracePeriod", 0 );
	level.firefly_pod_activation_time = GetDvarFloat( "scr_fireflyPodActivationTime", 0 );
	level.firefly_pod_partial_move_percent = GetDvarFloat( "scr_fireflyPartialMovePercent", 0.8 );
	
	if ( !IsDefined( level.vsmgr_prio_overlay_gel_splat ) )
	{
		level.vsmgr_prio_overlay_gel_splat = 21;
	}					
	//visionset_mgr::register_info( "overlay", "hive_gungun_splat", VERSION_SHIP, level.vsmgr_prio_overlay_gel_splat, 7, true, &visionset_mgr::duration_lerp_thread_per_player, false );

	level.fireflies_spawn_height = getDvarInt( "betty_jump_height_onground", 55 );
	level.fireflies_spawn_height_wall = getDvarInt( "betty_jump_height_wall", 20 );
	level.fireflies_spawn_height_wall_angle = getDvarInt( "betty_onground_angle_threshold", 30 );
	level.fireflies_spawn_height_wall_angle_cos = cos( level.fireflies_spawn_height_wall_angle ); 
	level.fireflies_emit_time = getDvarFloat( "scr_firefly_emit_time", 0.2 );
	level.fireflies_min_speed = getDvarInt( "scr_firefly_min_speed", 400 );
	level.fireflies_attack_speed_scale = getDvarFloat( "scr_firefly_attack_attack_speed_scale", 1.75 );
	level.fireflies_collision_check_interval = getDvarFloat( "scr_firefly_collision_check_interval", 0.2 );

	callback::add_weapon_damage( level.firefly_pod_weapon, &on_damage_firefly_pod );

	level thread register();
	
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
		level.fireflies_min_speed = getDvarInt( "scr_firefly_speed", 250 );
		level.fireflies_attack_speed_scale = getDvarFloat( "scr_firefly_attack_attack_speed_scale", 1.15 );
		level.firefly_debug = GetDvarInt( "scr_firefly_debug", 0 );
	}
}
#/
function register()
{
	clientfield::register( "scriptmover", "firefly_state", 1, 3, "int" );
	clientfield::register( "allplayers", "fireflies_attacking", 1, 1, "int" );
	clientfield::register( "allplayers", "fireflies_chasing", 1, 1, "int" );
}

function createFireflyPodWatcher() // self == player
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher( "hero_chemicalgelgun", self.team );
	watcher.onSpawn =&on_spawn_firefly_pod;
	watcher.watchForFire = true;
	watcher.hackable = false;
	watcher.headIcon = false;
	watcher.activateFx = true;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.detectionGracePeriod = level.firefly_pod_grace_period;
	watcher.detonateRadius = level.firefly_pod_detection_radius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 0;
	watcher.onDetonateCallback =&firefly_pod_detonate;
	watcher.activationDelay = level.firefly_pod_activation_time;
	watcher.activateSound = "wpn_gelgun_blob_burst";
	watcher.shouldDamage = &firefly_pod_should_damage;
	watcher.deleteOnPlayerSpawn = true;
	watcher.timeOut = getDvarFloat( "scr_firefly_pod_timeout", 0 );
	watcher.ignoreVehicles = true;
	watcher.ignoreAI = true;
	watcher.onSupplementalDetonateCallback = &firefly_death;
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_spawn_firefly_pod( watcher, owner ) // self == betty ent
{
	weaponobjects::onSpawnProximityWeaponObject( watcher, owner );
	self playloopsound( "wpn_gelgun_blob_alert_lp", 1 );
	
	self endon("death");
	self waittill("stationary");
	
	self SetModel( "wpn_t7_hero_chemgun_residue3_grn" );
	self SetEnemyModel( "wpn_t7_hero_chemgun_residue3_org" );
}

function start_damage_effects()
{
/#
	If ( IsGodMode( self ) )
	{
		return;
	}
#/

//	visionset_mgr::activate( "overlay", "hive_gungun_splat", self, firefly_pod_SPLAT_DURATION_MAX, firefly_pod_SPLAT_DURATION_MAX );

	//self clientfield::set( "damaged_by_firefly_pod", 1 );

	self thread end_damage_effects();
}

function end_damage_effects()
{
	self endon( "disconnect" );

	self waittill( "death" );

//	visionset_mgr::deactivate( "overlay", "hive_gungun_splat", self );

	//self clientfield::set( "damaged_by_firefly_pod", 0 );
}

function on_damage_firefly_pod( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	if ( "MOD_GRENADE" != meansOfDeath && "MOD_GRENADE_SPLASH" != meansOfDeath )
	{
		return;
	}

//	self thread start_damage_effects( );
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function spawn_firefly_mover() // self == betty ent
{
//	self util::waitTillNotMoving();

//	self UseAnimTree( #animtree );
//	self SetAnim( %o_spider_mine_deploy, 1.0, 0.0, 1.0 );

	firefly_mover = spawn( "script_model", self.origin );
	firefly_mover.angles = self.angles;
	firefly_mover SetModel( "tag_origin" );
//	firefly_mover SetModel( "fx_axis_createfx" ); // temp
	firefly_mover.owner = self.owner;
	firefly_mover.killCamOffset = ( 0, 0, GetDvarFloat( "scr_fireflies_start_height", 8.0 ) );
//	firefly_mover.weapon = self.weapon;
	firefly_mover.weapon = GetWeapon("hero_firefly_swarm");
	firefly_mover.takedamage = true;
	firefly_mover.soundMod = "firefly";
	firefly_mover.team = self.team;

	killcamEnt = spawn( "script_model", firefly_mover.origin + firefly_mover.killCamOffset );
	killcamEnt.angles = ( 0,0,0 );
	killcamEnt SetModel( "tag_origin" );
	killcamEnt SetWeapon( firefly_mover.weapon );

	// store the blob entity on the killcam entity so we can chain them together
	killcamEnt killcam::store_killcam_entity_on_entity(self);
		
	firefly_mover.killcamEnt = killcamEnt;
	
	self.firefly_mover = firefly_mover;
	
	firefly_mover.debug_time = 1;

	firefly_mover thread firefly_mover_damage();
	weaponobjects::add_supplemental_object( firefly_mover );
}

function firefly_mover_damage()
{
	while(1)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );		

		if ( !isPlayer( attacker ) && isdefined( attacker.owner ) )
		{
			attacker = attacker.owner;	
		}
		
		// we're currently allowing the owner/teammate to flash their own		
		if ( level.teambased && IsPlayer( attacker ) && isdefined( self.owner ) )
 		{
			// if we're not hardcore and the team is the same, do not destroy
			if( !level.hardcoreMode && self.owner.team == attacker.pers["team"] && self.owner != attacker )
			{
				continue;
			}
		}

		if ( isdefined( weapon ) && weapon.isEmp )
		{
			firefly_death();
		}		
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function kill_firefly_mover() // self == betty ent
{
	if ( isdefined( self.firefly_mover ))
	{
		if ( isdefined( self.firefly_mover.killcamEnt ) )
		{
			self.firefly_mover.killcamEnt delete();
		}
		self.firefly_mover delete();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_detonate( attacker, weapon, target ) // self == betty
{
	if ( !IsDefined( target ) )
	{
		if ( IsDefined( weapon ) && weapon.isValid )
		{
			if ( isdefined( attacker ) )
			{
				if ( self.owner util::IsEnemyPlayer( attacker ) )
				{
					attacker challenges::destroyedExplosive( weapon );
					scoreevents::processScoreEvent( "destroyed_fireflyhive", attacker, self.owner, weapon );
				}
			}
		}
		self firefly_pod_destroyed();
		return;
	}
	else
	{
//		self.firefly_mover SetModel( self.model );
		self spawn_firefly_mover();
		
		self.firefly_mover thread firefly_watch_for_target_death( target );
		self.firefly_mover thread firefly_watch_for_game_ended( target );
		
		self thread firefly_pod_release_fireflies( attacker, target );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_destroyed(  ) // self == betty
{
	fx_ent = PlayFX( "weapon/fx_hero_chem_gun_blob_death", self.origin );
 	fx_ent.team = self.team;
	
	PlaySoundAtPosition ( "wpn_gelgun_blob_destroy", self.origin );
	
	if ( isdefined( self.trigger ) )
	{
		self.trigger delete();
	}

	self kill_firefly_mover();

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_killcam_move( position, time ) // self == script mover spawned at weaponobject location
{
	if ( !IsDefined( self.killcamEnt ) )
		return;
	
	self endon("death");
	wait( 0.5 );
	accel = 0; 
	decel = 0;
	self.killCamEnt MoveTo( position, time, accel, decel );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_killcam_stop()
{
	self notify("stop_killcam");
	if ( IsDefined( self.killcamEnt ) )
	{
		self.killcamEnt MoveTo( self.killcamEnt.origin, 0.1, 0, 0);
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_move( position, time ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	accel = 0; //time * 0.1;
	decel = 0; //time * 0.1;
	self thread firefly_killcam_move( position, time );
	self MoveTo( position, time, accel, decel );
	self waittill( "movedone" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_partial_move( position, time, percent ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	self endon("stop_killcam");
	accel = 0; //time * 0.1;
	decel = 0; //time * 0.1;z
	self thread firefly_killcam_move( position, time );
	self MoveTo( position, time, accel, decel );
	self thread firefly_check_for_collisions( position, time );
	wait( time * percent );
	self notify("movedone");
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_rotate( angles, time ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	
	self RotateTo( angles, time, 0, 0 );
	self waittill( "rotatedone" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_check_for_collisions( move_to, time ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	self endon("movedone");
	
	original_position = self.origin;
	dir = VectorNormalize(move_to - self.origin);
	dist = Distance( self.origin, move_to );
	speed = dist / time;
	
	delta = dir * ( speed * level.fireflies_collision_check_interval );
	
	while( 1 )
	{
		if ( !firefly_check_move( self.origin + delta ) )
		{
			// hit something
			self thread firefly_death();
			self playsound( "wpn_gelgun_hive_wall_impact" );
		}
		wait( level.fireflies_collision_check_interval );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_rotated_point( degrees, radius, height )
{
	angles = ( 0, degrees, 0 );
	forward = ( radius, 0, 0);
	
	point = RotatePoint( forward, angles );
	
	return self.spawn_origin + point + ( 0, 0, height );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_random_point()
{
	return firefly_pod_rotated_point( RandomInt(359), RandomInt( level.fireflies_radius ), RandomIntRange( -level.fireflies_height_variance, level.fireflies_height_variance ) );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_random_movement( ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	self endon("attacking");
	
	while (1)
	{
		point = firefly_pod_random_point();
		
		delta = point - self.origin;
		angles = VectorToAngles(delta);
		firefly_rotate( angles, 0.15 );
		
		dist = Length( delta );
		
		time = 0.01;
		
		if ( dist > 0 )
		{
			time = dist / level.fireflies_min_speed;
		}
		firefly_move( point, time );
		
		wait( RandomFloatRange( 0.1, 0.7 ) );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_spyrograph_patrol( degrees, increment, radius ) // self == script mover spawned at weaponobject location
{
	self endon("death");
	self endon("attacking");

	current_degrees = RandomInt( int(360 / degrees) ) * degrees;
	height_offset = 0;
	
	while (1)
	{
		point = firefly_pod_rotated_point( current_degrees, radius, height_offset  );
		
		delta = point - self.origin;
		angles = ( 0, current_degrees, 0 );
		thread firefly_rotate( angles, 0.15 );
		
		dist = Length( delta );
		
		time = 0.01;
		
		if ( dist > 0 )
		{
			time = dist / level.fireflies_min_speed;
		}
		firefly_move( point, time );
		
		wait( RandomFloatRange( 0.1, 0.3 ) );
		
		current_degrees = ( current_degrees + ( degrees * increment ) ) % 360;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_damage_target( target ) // self == script mover spawned at weaponobject location
{
	level endon("game_ended");
	self endon("death");
	
	target endon("disconnect");
	target endon("death");
	target endon ( "entering_last_stand" );
	
	damage = 25;
	damage_delay = 0.1;
	weapon = self.weapon;
	target playsound( "wpn_gelgun_hive_attack" );
	target notify( "snd_burn_scream" );
	
	while(1)
	{
		wait( damage_delay );
		target DoDamage( damage, self.origin, self.owner, self, "", "MOD_IMPACT", 0, weapon );
		
		if ( IsAlive( target ) )
		{
			PlayFXOnTag( "weapon/fx_hero_firefly_blood_os", target, "J_SpineLower");
		}
		else
		{
			wait( damage_delay );		
		}
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_watch_for_target_death( target ) 
{
	self endon("death");
	if ( IsAlive( target ) )
	{
		target util::waittill_any("death", "flashback", "game_ended");
	}

	target clientfield::set( "fireflies_attacking", 0 );
	target clientfield::set( "fireflies_chasing", 0 );

	self thread firefly_death();
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_watch_for_game_ended( target ) 
{
	self endon("death");
	level waittill( "game_ended");
	
	if ( IsAlive( target ) )
	{
		target clientfield::set( "fireflies_attacking", 0 );
		target clientfield::set( "fireflies_chasing", 0 );
	}
	
	self thread firefly_death();
}
	
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_death() 
{
	/#
		println("firefly_death " + self getentnum() );
	#/
	self clientfield::set( "firefly_state", 5 );
	self playsound( "wpn_gelgun_hive_die" );
	
	if ( IsDefined( self.target_entity ) )
	{
		self.target_entity clientfield::set( "fireflies_attacking", 0 );
		self.target_entity clientfield::set( "fireflies_chasing", 0 );
	}

	waittillframeend;
	
	if ( isdefined( self ) )
	{
	/#
		println("firefly_death deleting " + self getentnum() );
	#/

		self delete();
	}
}

function get_attack_speed( target )
{
	velocity = target GetVelocity();
	speed = Length( velocity ) * level.fireflies_attack_speed_scale;

	if ( speed < level.fireflies_min_speed )
	{
		speed = level.fireflies_min_speed;
	}
	
	return speed;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_attack( target, state ) 
{
	level endon("game_ended");
	self endon("death");
	target endon ( "entering_last_stand" );
	
	self thread firefly_killcam_stop();
	
	self clientfield::set( "firefly_state", state );
	target clientfield::set( "fireflies_attacking", 1 );

	target_origin = target.origin + (0,0,50);

	delta = self.origin - target_origin;
	dist = Length( delta );
	time = 0.01;
	if ( dist > 0 )
	{
		speed = get_attack_speed( target );
		time = dist / speed;
	}
	
	self.enemy = target;
	
	firefly_move( target_origin, time );
	self LinkTo( target );
	
	wait(time);
	
	if ( !IsAlive(target) )
		return;
		
	self thread firefly_damage_target( target );
}

function get_crumb_position( target )
{
	stance = target GetStance();
	height = 50;
	
	if ( stance == "crouch" )
	 	height = 30;
	else if ( stance == "prone" )
		height = 15;
		
	return target.origin + (0,0,height);
}

/#
function target_bread_crumbs_render( target )
{
	self endon("death");
	self endon("attack");
	
	
	while(1)
	{
		previous_crumb = self.origin;
		
		for( i = 0; i < self.target_breadcrumbs.size; i++ )
		{

			if ( (self.target_breadcrumb_current_index + i) > self.target_breadcrumb_last_added )
				break;
			
			crumb_index = (self.target_breadcrumb_current_index + i) % self.target_breadcrumbs.size;
			crumb = self.target_breadcrumbs[crumb_index ];
			
			sphere( crumb, 2, (0,1,0), 1, true, 10, self.debug_time );
			
			if ( i > 0 )
				line(previous_crumb, crumb, (0,1,0), 1.0, true, self.debug_time );
			
			previous_crumb = crumb;
		}
		
		{wait(.05);};
	}
}
#/

function target_bread_crumbs( target )
{
	self endon("death");
	target endon("death");
	
	self.target_breadcrumbs = [];
	self.target_breadcrumb_current_index = 0;
	self.target_breadcrumb_last_added = 0;
	
	minimum_delta_sqr = 20 * 20;
	self.max_crumbs = 20;
	
	self.target_breadcrumbs[self.target_breadcrumb_last_added] = get_crumb_position( target );
	
/#
	if ( level.firefly_debug )
	{
		self thread target_bread_crumbs_render( target );
	}
#/

	while( 1 )
	{
		wait( 0.25 );
		previous_crumb_index = self.target_breadcrumb_last_added % self.max_crumbs;
		potential_crumb_position = get_crumb_position( target );
		
		if ( DistanceSquared( potential_crumb_position, self.target_breadcrumbs[previous_crumb_index] ) > minimum_delta_sqr )
		{
			self.target_breadcrumb_last_added++;
			
			// if the newly added point will pass the currently targeted point in the buffer make sure to set the current point
			if ( self.target_breadcrumb_last_added >= (self.target_breadcrumb_current_index + self.max_crumbs) )
			    self.target_breadcrumb_current_index = self.target_breadcrumb_last_added - self.max_crumbs + 1 ;

			self.target_breadcrumbs[self.target_breadcrumb_last_added % self.max_crumbs] = potential_crumb_position;
		}
	}
}

function get_target_bread_crumb( target )
{
	if ( self.target_breadcrumb_current_index > self.target_breadcrumb_last_added )
		return get_crumb_position( target );
		
	current_index = self.target_breadcrumb_current_index % self.max_crumbs;
	
	if ( !isDefined( self.target_breadcrumbs[current_index] ) )
		return get_crumb_position( target );
	
	return self.target_breadcrumbs[current_index];
}

function firefly_check_move( position )
{
	results = PhysicsTraceEx( self.origin, position, (-5,-5,-5), (5,5,5), self );
	
	if( results["fraction"] == 1 )
	{
		return true;
	}
	
	return false;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_chase( target ) // self == script mover spawned at weaponobject location
{
	level endon("game_ended");
	self endon("death");
	target endon("death");
	target endon( "entering_last_stand" );
	
	self clientfield::set( "firefly_state", 2 );
	target clientfield::set( "fireflies_chasing", 1 );

	max_distance  = 500;
	attack_distance  = 50;
	max_offset  = 10;
	up = (0,0,1);
	
	while(1)
	{
		target_origin = target.origin + (0,0,50);
		delta = target_origin - self.origin;
		dist = Length( delta );
		
		if ( dist <= attack_distance && firefly_check_move(target_origin) )
		{
			thread firefly_attack( target, 3 );
			return;
		}
		else		
		{
			target_origin = get_target_bread_crumb( target );
			
/#
			if ( level.firefly_debug )
				sphere( self.origin, 2, (1,0,0), 1, true, 10, self.debug_time );
#/

		// this code will give some randomness to the target point.
//			delta = target_origin - self.origin;
//			normal = VectorNormalize( delta );
//			right = VectorCross( normal, up );
//			offset = RotatePointAroundAxis( (right * max_offset), normal, RandomInt(359) );
//				
//			target_origin = target_origin + offset;		
		}
		delta = target_origin - self.origin;
		angles = VectorToAngles(delta);
		
		thread firefly_rotate( angles, 0.15 );
		
		dist = Length( delta );
		time = 0.01;
		if ( dist > 0 )
		{
			speed = get_attack_speed( target );
			time = dist / speed;
		}
		
		firefly_partial_move( target_origin, time, level.firefly_pod_partial_move_percent );		

		self.target_breadcrumb_current_index++;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_start( start_pos, target, linked ) // self == script mover spawned at weaponobject location
{
	level endon("game_ended");
	self endon("death");
	self notify("attack");
	
/#
	if ( level.firefly_debug )
		sphere( self.origin, 4, (1,0,0), 1, true, 10, self.debug_time );
#/
		
	level.fireflies_height_variance = 30;
	level.fireflies_radius = 100;
	
	self.target_origin_at_start = target.origin;
	self.target_entity = target;
	
	if ( linked )
	{
//		fx_ent = PlayFX( "weapon/fx_hero_firefly_start_entity", self.origin );
//	 	fx_ent.team = self.team;
		thread firefly_attack( target, 4  );
		return;
	}
	else
	{
		// start bread crumbing immediatly 
		thread target_bread_crumbs( target );
	
		//delta = target.origin - self.origin;
		//angles = VectorToAngles(delta);
		//self.angles = angles;
		
		self MoveTo( start_pos, level.fireflies_emit_time, 0, level.fireflies_emit_time );
		self waittill( "movedone" );

		delta = target.origin - self.origin;
		angles = VectorToAngles(delta);
		self.angles = angles;

//	self thread firefly_spyrograph_patrol( 60, 1, level.fireflies_radius );
		self thread firefly_chase( target );
	}
	
	wait(30);
	
	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function firefly_pod_release_fireflies( attacker, target ) // self == script mover spawned at weaponobject location
{	
	jumpDir = VectorNormalize( AnglesToUp( self.angles ) );
	
	if ( jumpDir[2] > level.fireflies_spawn_height_wall_angle_cos )
	{
		jumpHeight = level.fireflies_spawn_height;
	}
	else
	{
		jumpHeight = level.fireflies_spawn_height_wall;
	}
	
	explodePos = self.origin + jumpDir * jumpHeight;
	
	self.firefly_mover.spawn_origin = explodePos;
		
	linked_to = self GetLinkedEnt();
	linked = (linked_to === target);
	
	if ( !linked )
	{ 
		fx_ent = PlayFX( "weapon/fx_hero_firefly_start", self.origin, AnglesToUp( self.angles )  );
	 	fx_ent.team = self.team;
		self.firefly_mover clientfield::set( "firefly_state", 1 );
		self.firefly_mover.killCamEnt MoveTo( explodePos + self.firefly_mover.killCamOffset, level.fireflies_emit_time, 0, level.fireflies_emit_time );
	}
	else
	{
//		self.firefly_mover.killCamEnt delete();
//		self.firefly_mover.killCamEnt = undefined;
	}
	
	self.firefly_mover thread firefly_pod_start( explodePos, target, linked );
	
	self delete();
}

function firefly_pod_should_damage( watcher, attacker, weapon, damage )
{
	// gel blobs do not damage eachother
	if ( weapon == watcher.weapon )
		return false;
	
	if ( weapon.isEmp || weapon.destroysEquipment )
		return true;
	
	// anything will kill it over 15 damage
	if ( self.damageTaken < 15 )
		return false;
	
	return true;
}

//function firefly_spawn_vehicle( targetEnt )
//{
//	swarm = SpawnVehicle( "spawner_bo3_cybercom_firefly", origin, angles);
//	if(isDefined(swarm))
//	{
//		swarm.threatbias = -300;
//
//		swarm.owner 		= self;
//		swarm.team			= self.team;
//		swarm.lifetime 		= 45;
//		swarm.targetEnt 	= targetEnt;	//set this if you want an initial target
//		
//		swarm.state_machine = statemachine::create( "brain", swarm, "swarm_change_state" );
//		swarm.state_machine statemachine::add_state( "init", 	&swarm_state_enter, &swarm_init, 		&swarm_state_cleanup );
//		swarm.state_machine statemachine::add_state( "attack", 	&swarm_state_enter, &swarm_attack_think,&swarm_state_cleanup );
//		swarm.state_machine statemachine::set_state( "init" );
//		targetEnt = undefined;
//	}
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function swarm_state_cleanup( params )
//{
//	if(isDefined(self.badplace))
//	{
//		badplace_delete("swarmBP_"+self.swarm_ID);
//		self.badplace = undefined;
//	}
//}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function swarm_state_enter( params )
//{
//	WAIT_SERVER_FRAME;
//}
//
//function drawOriginForever()
//{
//	for( ;; )
//	{
//		drawArrow( self.origin, self.angles );
//		WAIT_SERVER_FRAME;
//	}
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function swarm_init( params )
//{
//	self setmodel("tag_origin");
//	self notsolid();
//	self.ignoreall 	= true;
//	self.takedamage = false;
//	self.goalradius = 36;
//	self.goalheight = 36;
//	self.good_melee_target = true;
//	self SetNearGoalNotifyDist( 48 );
//	
//	if(SWARM_SHOW_DEBUG)
//	{
//		self thread drawOriginForever();
//	}
//	
////	self thread swarm_death_wait();
////	self thread swarm_split_monitor();
////	self.sndEnt = spawn( "script_origin", self.origin );
////	self.sndEnt linkto( self );
//	self clearforcedgoal();
//	self SetGoal( self.origin, true, self.goalradius );	//set the goal for swarm
//
//	if(!IS_TRUE(self.isOffspring))
//	{
//		enemies = self _get_valid_targets();
//		closeTargets = ArraySortClosest(enemies, self.origin,enemies.size,0,512);	//if no nearby targets, lets move out from our current position in the direction player was looking
//		if(closeTargets.size == 0 )
//		{
//			//Move the swarm out and away frmo FXAnim ending spot
//			//this will cause the swarm to move out towards locatoin player was observing
//			//We do this to get the swarm closer to targets that the player was looking at.
//			angles = (self.angles[0],self.angles[1],0);
//			frontGoal = self.origin + (anglestoforward( angles)*240);					//max 512 units out
//			a_trace = BulletTrace( self.origin,frontGoal, false, undefined, true );
//			hitp 	= a_trace[ "position" ];			//but lets check that we can go that far, if not, take the trace point
//			
//			queryResult = PositionQuery_Source_Navigation(hitp,	0,	72,	72,	20,	self );	//can swarm find node around where it wants to go?
//			if( queryResult.data.size > 0 )
//			{
//				pathSuccess = self FindPath(	self.origin, queryResult.data[0].origin, true, false );		//can swarm path to that location?
//				if ( pathSuccess )
//				{
//					if(SWARM_SHOW_DEBUG)
//					{
//						level thread cybercom::debug_Circle( queryResult.data[0].origin, 16, 10, (1,0,0) );
//					}	
//					self clearforcedgoal();
//					self SetGoal( queryResult.data[0].origin, true, self.goalradius );	//set the goal for swarm
//					
//					if(!self.fireBugCount)
//						self clientfield::set("firefly_state",FIREFLY_STATE_HUNT_TRANS_TO_MOVE);
//					else
//						self clientfield::set("firefly_state",FIREBUG_STATE_HUNT_TRANS_TO_MOVE);
//					
//					self util::waittill_any_timeout( 5, "near_goal" ); 
//				}
//			}
//		}
//	}
//}
