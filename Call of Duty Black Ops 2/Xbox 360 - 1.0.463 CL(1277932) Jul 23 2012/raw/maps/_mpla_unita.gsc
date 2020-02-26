// --------------------------------------------------------------------------------
// ---- MPLA/UNITA for Angola ----
// --------------------------------------------------------------------------------
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\anims_table;
#include animscripts\anims_table_mpla;

#define MPLA_MELEE_CHARGE_DIST_SQ 		500 * 500
#define MPLA_MELEE_LONG_RANGE_DIST_SQ 	210 * 210
#define MPLA_MELEE_MID_RANGE_DIST_SQ 	140 * 140
#define MPLA_MELEE_SHORT_RANGE_DIST_SQ 	70 * 70

// MPLA and UNITA is the same thing in this script
// --------------------------------------------------------------------------------
// ---- Init function for Angola, called from level main script ----
// --------------------------------------------------------------------------------
#using_animtree( "generic_human" );
melee_mpla_init()
{
	precacheModel( "t6_wpn_machete_prop" );
	level._effect[ "flesh_hit_machete" ] = loadfx( "impacts/fx_flesh_hit_machete" );
}

setup_mpla()
{
	if( !IsSubStr( ToLower( self.classname ), "mpla" ) && !IsSubStr( ToLower( self.classname ), "unita" ) )
	{		
		return;
	}
	
	if( ( IsDefined(self.script_noteworthy) && self.script_noteworthy == "machete" ) || ( IsDefined(self.script_string) && self.script_string == "machete" ) )
	{
		make_machete_mpla();
		return;
	}

	make_default_mpla();
}

// --------------------------------------------------------------------------------
// ---- default/Rifle MPLA/UNITA ----
// --------------------------------------------------------------------------------
make_default_mpla()
{
	// set all the script attributes
	self disable_react();	
	self allowedStances( "stand" );

	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;
	self.a.allowEvasiveMovement	  = false;
	self.a.neverSprintForVariation = true;
	self.noHeatAnims = true;
	self.pathEnemyFightDist = 64;
	self.a.allow_sideArm = 0;	
	self.a.disableWoundedSet = true;
	self.a.doExposedBlindFire = false;
	
	// setup special melee	
	self.meleeChargeDistSq 	   			 = MPLA_MELEE_CHARGE_DIST_SQ;
	self.canExecureMeleeSequenceOverride = ::MPLA_Melee_AIvsAI_CanExecute;
	self.meleeSequenceOverride 			 = ::MPLA_Melee_AIvsAI;
}

// --------------------------------------------------------------------------------
// ---- Melee MPLA ----
// --------------------------------------------------------------------------------
make_machete_mpla()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	// to know this guy has a machete, we will check his machete weapon
	self.mpla_melee_weapon = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.mpla_melee_weapon.angles = self GetTagAngles("tag_weapon_right");
	self.mpla_melee_weapon SetModel( "t6_wpn_machete_prop" );
	self.mpla_melee_weapon LinkTo( self, "tag_weapon_right" );

	/# recordEnt(self.mpla_melee_weapon); #/
	
	self.hasKnifeLikeWeapon = true;
		
	// set the animations
	self set_mpla_run_cycles();
	self setup_melee_mpla_anim_array();

	// set all the script attributes
	self disable_react();	
	self allowedStances( "stand" );
	self disable_tactical_walk();
	
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
	self.noHeatAnims = true;
	self.a.disableWoundedSet = true;
	self.pathEnemyFightDist = 64;
	self.a.doExposedBlindFire = false;
	
	// setup special melee	
	self.meleeChargeDistSq = 350 * 350;
	self.canExecureMeleeSequenceOverride = ::MPLA_Melee_AIvsAI_CanExecute;
	self.meleeSequenceOverride = ::MPLA_Melee_AIvsAI;
	
	self.SPECIAL_KNIFE_ATTACK_FX_NAME = "flesh_hit_machete";
	self.SPECIAL_KNIFE_ATTACK_FX_TAG  = "tag_blood_fx";
	self.melee_weapon_ent 			  = self.mpla_melee_weapon;
		
	//self thread mpla_hunt_immediately_behavior();
	//self thread mpla_get_closer_if_melee_blocked();
	self thread mpla_drop_baton_on_death();
}

mpla_hunt_immediately_behavior()
{
	self endon("death");

	while (1)
	{
		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 64;
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
		
		wait .5;
	}
}

set_mpla_run_cycles()
{
	self animscripts\anims::clearAnimCache();

	self.a.combatrunanim 	= %ai_digbat_melee_run_f;
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;

	self.alwaysRunForward	= true;
}

mpla_get_closer_if_melee_blocked()
{
	self endon("death");

	while(1)
	{
		self waittill("melee_path_blocked");

		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 64;
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
	}
}

// --------------------------------------------------------------------------------
// ---- Utility ----
// --------------------------------------------------------------------------------
mpla_drop_baton_on_death()
{
	self waittill("death");

	mpla_melee_weapon = self.mpla_melee_weapon;

	mpla_melee_weapon Unlink();
	mpla_melee_weapon PhysicsLaunch();

	wait(15);

	// save an ent
	mpla_melee_weapon Delete();
}

is_machete_mpla()
{
	return ( IsAlive(self) && IsDefined( self.mpla_melee_weapon ) );
}

is_rifle_mpla()
{
	return ( IsAlive(self) && !IsDefined( self.mpla_melee_weapon ) );
}

// --------------------------------------------------------------------------------
// ---- Special AI vs AI melee setup for MPLA vs UNITA ----
// --------------------------------------------------------------------------------
MPLA_Melee_AIvsAI( angleDiff )
{	
	AngleThreshold = 100;
		
	// Have extra tolerance when already in progress, since some animations twist the origin quite a bit ( for example standard melee )
	if ( self.melee.inProgress )
		AngleThreshold += 50;
	
	// facing each other
	if ( abs( angleDiff ) < AngleThreshold )
		return false;

	target = self.melee.target;

	// Attacker must be able to win	
	if ( isDefined( target.magic_bullet_shield ) )
		return false;
		
	// Attacker must be able to win	
	if ( isDefined( target.meleeAlwaysWin ) )
	{
		assert( !isDefined( self.magic_bullet_shield ) );
		return false;
	}
	
	self.melee.winner = true;
	
	// Setup who gets to live
	if ( self.melee.winner )
	{
		self.melee.death = undefined;
		target.melee.death = true;
	}
	else
	{
		target.melee.death = undefined;
		self.melee.death = true;
	}
		
	// check the distance between self and the target and decide appropriate animations
	distToTarget = Distance2DSquared( self.origin, target.origin );
	
	meleeSeqs = [];
	
	if( is_machete_mpla() && target is_rifle_mpla() ) 		// machete vs rifle
	{
		if( distToTarget >= MPLA_MELEE_CHARGE_DIST_SQ )
		{
			if( cointoss() )
			{
				meleeSeqs[meleeSeqs.size] = "frontal_dodge_277";
			}
			else
			{
				meleeSeqs[meleeSeqs.size] = "frontal_dodge_210";
				meleeSeqs[meleeSeqs.size] = "frontal_dodge_140";
				meleeSeqs[meleeSeqs.size] = "frontal_dodge_70";
			}
		}
		else if( distToTarget >= MPLA_MELEE_LONG_RANGE_DIST_SQ )
		{
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_210";
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_140";
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_70";		
		}
		else if( distToTarget >= MPLA_MELEE_MID_RANGE_DIST_SQ )
		{
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_140";
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_70";		
		}
		else if( distToTarget >= MPLA_MELEE_SHORT_RANGE_DIST_SQ )
		{
			meleeSeqs[meleeSeqs.size] = "frontal_dodge_70";
		}
	}
	else if( is_rifle_mpla() && target is_machete_mpla() ) // rifle vs machete
	{
		if( distToTarget >= MPLA_MELEE_MID_RANGE_DIST_SQ )
		{
			meleeSeqs[meleeSeqs.size] = "rifle_machete_133";
		}
	}
	else if( is_machete_mpla() && target is_machete_mpla() ) // machete vs machete
	{
		if( distToTarget >= MPLA_MELEE_CHARGE_DIST_SQ )
		{
			meleeSeqs[meleeSeqs.size] = "machete_machete_314";
		}
	}

	if( meleeSeqs.size > 0 )
	{
		meleeSeq = meleeSeqs[ RandomIntRange( 0, meleeSeqs.size )];
		MPLA_Melee_AIvsAI_SetMeleeSeqAnims( meleeSeq, target );
		
		return true;
	}
	
	return false;
}

MPLA_Melee_AIvsAI_CanExecute()
{
	target = self.melee.target;
	
	if( is_machete_mpla() && target is_rifle_mpla() ) 		// machete vs rifle
	{
		return true;
	}
	else if( is_rifle_mpla() && target is_machete_mpla() )  // rifle vs machete
	{
		return true;
	}
	else if( is_machete_mpla() && target is_machete_mpla() ) // machete vs machete
	{
		return true;
	}
	
	return false;
}

MPLA_Melee_AIvsAI_SetMeleeSeqAnims( meleeSeq, target )
{
	switch ( meleeSeq )
	{
		case "frontal_dodge_277": // jump and kill - machete winner - 277
			self.melee.animName 		 = %ai_melee_rm_mwin_f_02_m; 	
			target.melee.animName 		 = %ai_melee_rm_mwin_f_02_r;
			break;
		
		case "frontal_dodge_210":  // frontal dodge - machete winner - 210 
			self.melee.animName 		 = %ai_melee_rm_mwin_f_01_210_m; 
			target.melee.animName 		 = %ai_melee_rm_mwin_f_01_210_r;
			break;
			
		case "frontal_dodge_140":  // frontal dodge - machete winner - 140 
			self.melee.animName 		 = %ai_melee_rm_mwin_f_01_140_m; 
			target.melee.animName 		 = %ai_melee_rm_mwin_f_01_140_r;
			break;
			
		case "frontal_dodge_70":	// frontal dodge - machete winner - 70 
			self.melee.animName 		 = %ai_melee_rm_mwin_f_01_70_m;  
			target.melee.animName 		 = %ai_melee_rm_mwin_f_01_70_r;
			break;
				
		case "rifle_machete_133":	// rifle hit and shoot - rifle winner - 133 
			self.melee.animName 		 = %ai_melee_rm_rwin_f_01_r;
			target.melee.animName 		 = %ai_melee_rm_rwin_f_01_m;
			break;
			
		case "machete_machete_314":	// machete battle - machete winner - 314
			self.melee.animName 		 = %ai_melee_mm_awin_f_01_attack;
			target.melee.animName 		 = %ai_melee_mm_awin_f_01_defend;
			break;
		default:
			AssertMsg( "Unsupported meleeSeq" + meleeSeq );
	}
}