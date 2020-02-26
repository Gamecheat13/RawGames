// --------------------------------------------------------------------------------
// ---- Digbats for Panama ----
// --------------------------------------------------------------------------------
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;
#include animscripts\anims_table_digbats;

// --------------------------------------------------------------------------------
// ---- Init function for Digbats, called from level main script ----
// --------------------------------------------------------------------------------
#using_animtree( "generic_human" );
melee_digbat_init()
{
	PrecacheModel("t5_weapon_machete");
	PrecacheModel("t6_wpn_bat_barbedwire");
}

make_barbwire_digbat()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	self.digbat_melee_weapon = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.digbat_melee_weapon.angles = self GetTagAngles("tag_weapon_right");
	self.digbat_melee_weapon SetModel( "t6_wpn_bat_barbedwire" );
	self.digbat_melee_weapon LinkTo( self, "tag_weapon_right" );

	/# recordEnt(self.digbat_melee_weapon); #/

	// set the animations
	self set_melee_digbat_run_cycles();
	self setup_melee_digbat_anim_array();

	digbat_common_setup();
}

make_machete_digbat()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	self.digbat_melee_weapon = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.digbat_melee_weapon.angles = self GetTagAngles("tag_weapon_right");
	self.digbat_melee_weapon SetModel( "t5_weapon_machete" );
	self.digbat_melee_weapon LinkTo( self, "tag_weapon_right" );

	/# recordEnt(self.digbat_melee_weapon); #/

	// set the animations
	self set_melee_digbat_run_cycles();
	self setup_melee_digbat_anim_array();

	digbat_common_setup();
}

digbat_common_setup()
{
	// set all the script attributes
	self disable_react();	
	self allowedStances( "stand" );

	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.a.disableLongDeath   = true;
	self.disableTurns		  = true;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;
	self.dontShootWhileMoving = true;
	self.a.allow_shooting	  = false;
	self.a.allowEvasiveMovement	  = false;
	self.a.neverSprintForVariation = true;

	self.combatMode = "ambush";
	
	self thread digbat_hunt_immediately_behavior();
	self thread digbat_get_closer_if_melee_blocked();
	self thread digbat_drop_baton_on_death();
}

digbat_hunt_immediately_behavior()
{
	self endon("death");

	self.pathEnemyFightDist = 64;

	while (1)
	{
		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 199; // 200 is the melee charge dist
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
		
		wait .5;
	}
}

set_melee_digbat_run_cycles()
{
	self animscripts\anims::clearAnimCache();

	self.a.combatrunanim 	= %ai_baton_run_f;
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;

	self.alwaysRunForward	= true;
}

digbat_get_closer_if_melee_blocked()
{
	self endon("death");

	while(1)
	{
		self waittill("melee_path_blocked");

		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 32;
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
	}
}

digbat_drop_baton_on_death()
{
	self waittill("death");

	digbat_melee_weapon = self.digbat_melee_weapon;

	digbat_melee_weapon Unlink();
	digbat_melee_weapon PhysicsLaunch();

	wait(15);

	// save an ent
	digbat_melee_weapon Delete();
}

setup_digbat_volumes()
{
	if(!IsDefined(level.digbat_volumes))
		level.digbat_volumes = GetEntArray( "digbat_volumes", "script_noteworthy" );
}

setup_digbat()
{
	setup_digbat_volumes();
	
	if( !IsSubStr( ToLower( self.classname ), "digbat" ) )
	{
		self.combatmode = "only_cover";
		self.a.disableWoundedSet = true;
		return;
	}
	
	if( IsDefined(self.script_noteworthy) && self.script_noteworthy == "machete_digbat" )
	{
		make_machete_digbat();
		return;
	}
	
	if( IsDefined(self.script_noteworthy) && self.script_noteworthy == "bat_digbat" )
	{
		make_barbwire_digbat();
		return;
	}
	
	if( IsDefined(self.script_noteworthy) && self.script_noteworthy == "melee_digbat" )
	{
		if(cointoss())
			make_barbwire_digbat();
		else
			make_machete_digbat();

		return;
	}

	self.combatMode = "exposed_nodes_only";
	self.movePlayBackRate = 1.2;
	self.grenadeAwareness = 0;
	self.a.allow_sideArm = 0;
	self.ignoresuppression = 1;
	self.maxhealth = 200;
	self.health = 200;
	self.a.doExposedBlindFire = true;
	self allowedStances( "stand" );

	self setengagementmindist( 300, 200 );
	self setengagementmaxdist( 512, 768 );

	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "use_volume" )
	{
		self thread digbat_frantic_movement();
	}
}


digbat_frantic_movement()
{
	self endon("death");

	self.digbat_current_volume = undefined;
	while(1)
	{
		if( IsDefined( self.digbat_current_volume ) )
		{
			available_volumes = level.digbat_volumes;
			available_volumes = array_remove( available_volumes, self.digbat_current_volume );
		}
		else
		{
			available_volumes = level.digbat_volumes;
		}
		 
		self.digbat_current_volume = available_volumes[RandomInt( available_volumes.size )];
		self SetGoalVolumeAuto( self.digbat_current_volume );
		wait RandomIntRange( 6, 10 );
	}	
}
