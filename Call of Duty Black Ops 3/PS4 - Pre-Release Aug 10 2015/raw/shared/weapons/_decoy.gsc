#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace decoy;

function init_shared()
{
	level.decoyWeapons = [];
	level.decoyWeapons["fullauto"] = [];
	level.decoyWeapons["semiauto"] = [];
	
	level.decoyWeapons["fullauto"][level.decoyWeapons["fullauto"].size] = GetWeapon( "ar_accurate" ); // BO2: "uzi"
	
	level.decoyWeapons["semiauto"][level.decoyWeapons["semiauto"].size] = GetWeapon( "pistol_standard" ); // BO2: "m1911"
	
	callback::add_weapon_watcher( &create_watcher );
}

function create_watcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "nightingale", self.team );
	watcher.onSpawn =&on_spawn;
	watcher.onDetonateCallback =&detonate;
	watcher.deleteOnDifferentObjectSpawn = false;
	watcher.headicon = false;
}

function on_spawn(watcher, owner)
{
	owner endon("disconnect");
	self endon( "death" );
	
	weaponobjects::onSpawnUseWeaponObject(watcher, owner);
	
	self.initial_velocity = self GetVelocity();
	delay = 1;
	
	wait (delay );
	decoy_time = 30;
	spawn_time = GetTime();

	owner AddWeaponStat( self.weapon, "used", 1 );
	
	self thread simulate_weapon_fire(owner);

	while( 1 )
	{
		if ( GetTime() > spawn_time + ( decoy_time * 1000 ))
		{
			self destroy(watcher,owner);
			return;
		}
		
		{wait(.05);};
	}
}

function move( owner, count, fire_time, main_dir, max_offset_angle )
{
	self endon( "death" );
	self endon( "done" );
	
	if ( !(self IsOnGround() ) )
		return;
		
	min_speed = 100;
	max_speed = 200;
	
	min_up_speed = 100;
	max_up_speed = 200;
	
	current_main_dir = RandomIntRange(main_dir - max_offset_angle,main_dir + max_offset_angle);
	
	avel = ( RandomFloatRange( 800, 1800) * (RandomIntRange( 0, 2 ) * 2 - 1), 0, RandomFloatRange( 580, 940) * (RandomIntRange( 0, 2 ) * 2 - 1));

	intial_up = RandomFloatRange( min_up_speed, max_up_speed );
	
	start_time = GetTime();
	gravity = GetDvarint( "bg_gravity" );
	
//	PrintLn( "start time " + start_time );
	for ( i = 0; i < 1; i++ )
	{		
		angles = ( 0,RandomIntRange(current_main_dir - max_offset_angle,current_main_dir + max_offset_angle), 0 );
		dir = AnglesToForward( angles );
		
		dir = VectorScale( dir, RandomFloatRange( min_speed, max_speed ) );
		
		deltaTime = ( GetTime() - start_time ) * 0.001;
		
		// must manually manage the gravity because of the way the Launch function and the tr interpolater work
		up = (0,0, (intial_up) - (800 * deltaTime)  );
		
		self launch( dir + up, avel ); 
		
		wait( fire_time );
	}
//	PrintLn( "end time " + GetTime() );
}

function destroy(watcher,owner)
{
	self notify( "done" );
	self entityheadicons::setEntityHeadIcon("none");
	
	// play deactivated particle effect here
}

function detonate( attacker, weapon, target )
{
	// NOTE: this isn't being called currently through the watcher system
	self notify( "done" );
	self entityheadicons::setEntityHeadIcon("none");
}

function simulate_weapon_fire( owner )
{
	owner endon("disconnect");
	self endon( "death" );
	self endon( "done" );
	
	weapon = pick_random_weapon();
	
	self thread watch_for_explosion( owner, weapon );
	self thread track_main_direction();
	
	self.max_offset_angle = 30;
	
	weapon_class = util::getWeaponClass( weapon );
	
	switch ( weapon_class )
	{
		case "weapon_cqb":
		case "weapon_smg":
		case "weapon_hmg":
		case "weapon_lmg":
		case "weapon_assault":
			simulate_weapon_fire_machine_gun( owner, weapon );
			break;
		case "weapon_sniper":
			simulate_weapon_fire_sniper( owner, weapon );
			break;
		case "weapon_pistol":
			simulate_weapon_fire_pistol( owner, weapon );
			break;
		case "weapon_shotgun":
			simulate_weapon_fire_shotgun( owner, weapon );
			break;

		// for weapons like rocket launchers
		default:
			simulate_weapon_fire_machine_gun( owner, weapon );
			break;
	}

}

function simulate_weapon_fire_machine_gun( owner, weapon )
{
	if ( weapon.isSemiAuto )
	{
		simulate_weapon_fire_machine_gun_semi_auto( owner, weapon );
	}
	else
	{
		simulate_weapon_fire_machine_gun_full_auto( owner, weapon );
	}
}


function simulate_weapon_fire_machine_gun_semi_auto( owner, weapon )
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;

	burst_spacing_min = 4;
	burst_spacing_max = 10;

	while( 1 )
	{
		if ( clipSize <= 1 )
			burst_count = 1;
		else
			burst_count = RandomIntRange( 1, clipSize );
		self thread move( owner, burst_count, fireTime, self.main_dir, self.max_offset_angle );
		self fire_burst( owner, weapon, fireTime, burst_count, true );
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

function simulate_weapon_fire_pistol( owner, weapon )
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;

	burst_spacing_min = 0.5;
	burst_spacing_max = 4;

	while( 1 )
	{
		burst_count = RandomIntRange( 1, clipSize );
		self thread move( owner, burst_count, fireTime, self.main_dir, self.max_offset_angle );
		self fire_burst( owner, weapon, fireTime, burst_count, false );
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

function simulate_weapon_fire_shotgun( owner, weapon )
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;

	if ( clipSize > 2 )
		clipSize = 2;

	burst_spacing_min = 0.5;
	burst_spacing_max = 4;

	while( 1 )
	{
		burst_count = RandomIntRange( 1, clipSize );
		self thread move( owner, burst_count, fireTime, self.main_dir, self.max_offset_angle );
		self fire_burst( owner, weapon, fireTime, burst_count, false );
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

function simulate_weapon_fire_machine_gun_full_auto( owner, weapon )
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;

	if ( clipSize > 30 )
		clipSize = 30;
		
	burst_spacing_min = 2;
	burst_spacing_max = 6;

	while( 1 )
	{
		burst_count = RandomIntRange( Int(clipSize * 0.6), clipSize );
		interrupt = false; // RandomIntRange( 0, 2 );
		self thread move( owner, burst_count, fireTime, self.main_dir, self.max_offset_angle );
		self fire_burst( owner, weapon, fireTime, burst_count, interrupt );

		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

function simulate_weapon_fire_sniper( owner, weapon )
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	
	if ( clipSize > 2 )
		clipSize = 2;
		
	burst_spacing_min = 3;
	burst_spacing_max = 5;

	while( 1 )
	{
		burst_count = RandomIntRange( 1, clipSize );
		self thread move( owner, burst_count, fireTime, self.main_dir, self.max_offset_angle );
		self fire_burst( owner, weapon, fireTime, burst_count, false );
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

function fire_burst( owner, weapon, fireTime, count, interrupt )
{
	interrupt_shot = count;
	
	if ( interrupt )
	{
		interrupt_shot = Int( count * RandomFloatRange( 0.6, 0.8 ) ); 
	}
	
	self FakeFire( owner, self.origin, weapon, interrupt_shot );
	wait ( fireTime * interrupt_shot );
	
	if ( interrupt )
	{
		self FakeFire( owner, self.origin, weapon, count - interrupt_shot );
		wait ( fireTime * (count - interrupt_shot) );
	}
}

function finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max)
{
		if ( should_play_reload_sound() )
		{
			play_reload_sounds( weapon, reloadTime );
		}
		else
		{
			wait ( RandomFloatRange(burst_spacing_min, burst_spacing_max) );
		}
}

function play_reload_sounds(weapon, reloadTime)
{
	divy_it_up = (reloadTime - 0.1) / 2;
	wait (0.1);
	self PlaySound("fly_assault_reload_npc_mag_out");
	wait (divy_it_up);
	self PlaySound("fly_assault_reload_npc_mag_in");
	wait (divy_it_up);
//	self PlaySound("fly_assault_reload_npc_charge");
//	wait (divy_it_up);
}

function watch_for_explosion( owner, weapon )
{
	self thread watch_for_death_before_explosion();

	owner endon( "disconnect");
	self endon( "death_before_explode");
	self waittill("explode", pos);
	level thread do_explosion( owner, pos, weapon, RandomIntRange( 5, 10 ) );
}

function watch_for_death_before_explosion( )
{
	self waittill("death");
	wait(0.1);
	if ( IsDefined(self) )
	{
		self notify("death_before_explode");
	}
}


function do_explosion( owner, pos, weapon, count )
{
	min_offset = 100;
	max_offset = 500;
	
	for ( i = 0 ; i < count; i++ )
	{
		wait(RandomFloatRange(0.1,0.5));
		offset = ( RandomFloatRange(min_offset,max_offset)* (RandomIntRange( 0, 2 ) * 2 - 1), RandomFloatRange(min_offset,max_offset)* (RandomIntRange( 0, 2 ) * 2 - 1), 0 );
		owner FakeFire( owner, pos+offset, weapon, 1 );
	}
}

function pick_random_weapon()
{
	type = "fullauto";
	
	if ( RandomIntRange( 0, 10 ) < 3 )
	{
		type = "semiauto";
	}
	
	randomval = RandomIntRange(0,level.decoyWeapons[type].size);
	
/#	PrintLn( "Decoy type: " + type + " weapon: " + level.decoyWeapons[type][randomval].name );	#/
	
	return level.decoyWeapons[type][randomval];
}

function should_play_reload_sound()
{
 	if( RandomIntRange(0,5) == 1 )
 	{
 		return true;
 	}
 	
 	return false;
}

function track_main_direction()
{
	self endon( "death" );
	self endon( "done" );
	self.main_dir = Int(VectorToAngles((self.initial_velocity[0], self.initial_velocity[1], 0 ))[1]);
	
	up = (0,0,1);
	while( 1 )
	{
		self waittill( "grenade_bounce", pos, normal );
		
		dot = VectorDot( normal, up );
		
		// something got in the way thats somewhat vertical 
		if ( dot < 0.5 && dot > -0.5 ) 
		{
			self.main_dir = Int(VectorToAngles((normal[0], normal[1], 0 ))[1]);
		}
	}
}
