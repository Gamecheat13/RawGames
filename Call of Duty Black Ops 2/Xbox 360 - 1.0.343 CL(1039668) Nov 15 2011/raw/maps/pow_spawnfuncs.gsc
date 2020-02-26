/*
	
	THIS SCRIPT HANDLES EVERY SPAWN FUNCTION

*/


#include maps\_utility;
#include common_scripts\utility;


heli_crew_init()
{
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 8;
	
	self thread heli_crew_reset_on_notify( "damage", 0 );
	self thread heli_crew_reset_on_notify( "perimeter_breached", 1 );
}


//-- reset the hind crew in the clearing
heli_crew_reset_on_notify( my_notify, on_level )
{
	if(on_level)
	{
		level waittill(my_notify);
	}
	else
	{
		self waittill(my_notify);
		

	}
	
	level notify("perimeter_breached");
	
	if(IsAlive(self))
	{
		self.goalradius = 1024;
		self.ignoreme = false;
		self.ignoreall = false;
	}
}


//-- Constantly refill rpgs
unlimited_rpgs()
{
	self endon("death");
	
	while(IsAlive(self))
	{
		self.a.rockets = 10;
		wait(1);
	}
}

//-- Kill the guys when the bridge gets destroyed
bridge_death_launch()
{
	self endon("death");
	
	self.a.nodeath = true;
	level waittill("woodbridge_start");
	
	self Delete();
	/*
	self thread ragdoll_death();
	wait(0.05);
	forward = AnglesToForward(self.angles);
	forward = forward * 100;
	self LaunchRagDoll( (forward[0], forward[1], 200), self.origin );
	*/
}

//-- turn off dodge so that AI can run through each other
ai_no_dodge( delay )
{
	self.noDodgeMove = true;
	
	if(IsDefined(delay))
	{
		wait(delay);
		self.noDodgeMove = false;
	}
}

//-- Basically overloading the normal drone death function so that I can handle some special cases
#using_animtree( "fakeshooters" ); 
drone_powDeath()
{
	level endon("end_drone_behaviors");
	
	self.b_fake_death_at_end = false;
	
	explosivedeath = false; 
	explosion_ori = ( 0, 0, 0 ); 
	
	while( IsDefined( self ) )
	{
		self SetCanDamage( true ); 
		self waittill( "damage", amount, attacker, direction_vec, damage_ori, type ); 
		
		// SRS testing special explosive death anims
		if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || 
			type == "MOD_EXPLOSIVE_SPLASH" ||  type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
		{
			self.damageweapon = "none"; 
			explosivedeath = true; 
			explosion_ori = damage_ori; 
		}
		
		self notify("drone_death");	// kill certain drone threads
		self death_notify_wrapper();
		
		if( !IsDefined( self ) )
		{
			return; 
		}
		
		self notify( "Stop shooting" ); 
		self.dontDelete = true; 
		
		deathAnim = undefined; 
		self useAnimTree( #animtree ); 
		
		max_horizontal = 150;
		max_z = 150;
		
		//-- specific to the first village
		if( IsDefined(attacker.script_noteworthy) && attacker.script_noteworthy == "pipe_tank_1" )
		{
			dir_from_impact = VectorNormalize((self.origin[0], self.origin[1], 0) - (explosion_ori[0], explosion_ori[1], 0));
			PlayFX(level._effect["drone_explode"], self.origin, dir_from_impact);
			self.dontdelete = undefined;
			self maps\_drones::drone_delete();
			return;
		}
		
		if( explosivedeath && amount > 300 && maps\pow_utility::available_ragdoll())
		{
			//-- figure out if it was a rocket and if it is one, then LaunchRagDoll in the proper direction
			//-- rocket radius is 500
			distance_from_explosion = Distance2D( self.origin, explosion_ori);
			
			if(distance_from_explosion > 120)
			{
				dist_scalar = 1 - (distance_from_explosion / 500);
				dir_from_impact = VectorNormalize((self.origin[0], self.origin[1], 0) - (explosion_ori[0], explosion_ori[1], 0));
				launch_force = (dir_from_impact * max_horizontal * dist_scalar) + (0,0, max_z * dist_scalar);
				self maps\pow_utility::add_to_ragdoll_bucket();
				//self StartRagdoll();
				self LaunchRagdoll( launch_force, self.origin );
			}	
			else
			{
				//-- basically on top of explosion so explode the drone and make him disappear
				dir_from_impact = VectorNormalize((self.origin[0], self.origin[1], 0) - (explosion_ori[0], explosion_ori[1], 0));
				PlayFX(level._effect["drone_explode"], self.origin, dir_from_impact);
				self.dontdelete = undefined;
				self maps\_drones::drone_delete();
				return;
			}
			
			random_delay = RandomFloatRange(10, 15);
			if(IsDefined(self))
			{
				self.dontdelete = undefined;
				self thread maps\_drones::drone_delete( random_delay );
			}
			return; 
		}
		
		if( IsDefined( self.running ) )
		{
			deaths[0] = %death_run_stumble; 
			deaths[1] = %death_run_onfront; 
			deaths[2] = %death_run_onleft; 
			deaths[3] = %death_run_forward_crumple; 
		}
		else
		{
			deaths[0] = %death_stand_dropinplace; 
		}
		
		//-- hit impact for the drones
		maps\_drones::drones_set_impact_effect( level._effect["drone_impact"] );
	
		level.no_drone_ragdoll = true;
		self thread maps\_drones::drone_doDeath( deaths[RandomInt( deaths.size )] ); 
		return; 
	}
}