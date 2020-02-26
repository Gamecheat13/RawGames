// #include maps\mp\animscripts\zm_utility;
// #include animscripts\weaponList;
// #include common_scripts\utility;
// #include animscripts\Combat_Utility;
// #include maps\_utility;

#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;


main()
{
	//IPrintLnBold( "ZM >> zombie_pain::main()" );
	
	//Zombies feel no pain!
	
//	self SetFlashBanged(false);
//	
// 	if ( IsDefined( self.longDeathStarting ) )
// 	{
// 		// important that we don't run any other animscripts.
// 		self waittill("killanimscript");
// 		return;
// 	}
// 	
//	
// 	if ( is_true(self.lander_knockdown) && (self.animname == "zombie" || self.animname == "napalm_zombie" || self.animname == "sonic_zombie") )
// 	{
// 		self playThundergunPainAnim();
// 		self.lander_knockdown = undefined;
// 		return;
// 	}
// 	
// 	if ( IsDefined( self.damageweapon ) && (self.damageweapon == "thundergun_zm" || self.damageweapon == "thundergun_upgraded_zm") && (self.damagemod != "MOD_GRENADE" && self.damagemod != "MOD_GRENADE_SPLASH") && self.animname == "zombie" )
// 	{
// 		self playThundergunPainAnim();
// 		return;
// 	}
// 	
// 	if ( [[ anim.pain_test ]]() )
// 	{
// 		return;	
// 	}
// 
// 	if ( self.a.disablePain )
// 	{
// 		return;
// 	}
// 	
// 	self notify( "kill_long_death" );
// 		
// 	self.a.painTime = GetTime();
// 
// 	if( self.a.flamepainTime > self.a.painTime )
// 	{
// 		return;
// 	}
// 
// 	if (self.a.nextStandingHitDying)
// 	{
// 		self.health = 1;
// 	}
// 
// 	dead = false;
// 	stumble = false;
// 	
// 	ratio = self.health / self.maxHealth;
// 	
//  //t6todo  self trackScriptState( "Pain Main", "code" );
//   self notify ("anim entered pain");
// 	self endon("killanimscript");
// 
// 	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
// 	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
// 	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
// 	// can be played easily whichever position the character is in.
//   maps\mp\animscripts\zm_utility::initialize("zombie_pain");
//     
//   self AnimMode("gravity");
// 
// 	//t6todo self animscripts\face::SayGenericDialogue("pain");
// 	
// 	if ( self.damageLocation == "helmet" )
// 	{
// 		self maps\mp\animscripts\zm_death::helmetPop();
// 	}
// 	
// 	if ( specialPain( self.a.special ) )
// 	{
// 		return;
// 	}
// 
// 	// if we didn't handle self.a.special, we can't rely on it being accurate after the pain animation we're about to play.
// 	self.a.special = "none";
// 
// 	painAnim = getPainAnim();
// 	
// 	/#
// 	if ( GetDvarInt( "scr_paindebug") == 1 )
// 	{
// 		println( "^2Playing pain: ", painAnim, " ; pose is ", self.a.pose );
// 	}
// 	#/
// 	
// 	playPainAnim( painAnim );
}

wasDamagedByExplosive()
{
	if ( self.damageWeapon != "none" )
	{
		if ( weaponClass( self.damageWeapon ) == "rocketlauncher" || weaponClass( self.damageWeapon ) == "grenade" || self.damageWeapon == "fraggrenade" || self.damageWeapon == "c4" || self.damageWeapon == "claymore" || self.damageWeapon == "satchel_charge_new" || self.damageWeapon == "frag_grenade_sp")
		{
			self.mayDoUpwardsDeath = (self.damageTaken > 300); // TODO: is this a good value?
			return true;
		}
	}

	if ( GetTime() - anim.lastCarExplosionTime <= 50 )
	{
		rangesq = anim.lastCarExplosionRange * anim.lastCarExplosionRange * 1.2 * 1.2;
		if ( DistanceSquared( self.origin, anim.lastCarExplosionDamageLocation ) < rangesq )
		{
			// assume this exploding car damaged us.
			upwardsDeathRangeSq = rangesq * 0.5 * 0.5;
			self.mayDoUpwardsDeath = (DistanceSquared( self.origin, anim.lastCarExplosionLocation ) < upwardsDeathRangeSq );
			return true;
		}
	}

	return false;
}

/*playThundergunPainAnim()
{
	self notify( "end_play_thundergun_pain_anim" );
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "end_play_thundergun_pain_anim" );

	if( isDefined( self.marked_for_death ) && self.marked_for_death )
	{
		return;
	}	

	if ( self.damageYaw <= -135 || self.damageYaw >= 135 )
	{
		if ( !self.has_legs )
		{
			fallAnim = random( level._zombie_knockdowns[self.animname]["front"]["no_legs"] );
			
			if ( isdefined( level.thundergun_last_knockdown_anim ) && level.thundergun_last_knockdown_anim == fallAnim )
			{
				fallAnim = random( level._zombie_knockdowns[self.animname]["front"]["no_legs"] );
			}
		}
		else
		{
			fallAnim = random( level._zombie_knockdowns[self.animname]["front"]["has_legs"] );
			
			if ( isdefined( level.thundergun_last_knockdown_anim ) && level.thundergun_last_knockdown_anim == fallAnim )
			{
				fallAnim = random( level._zombie_knockdowns[self.animname]["front"]["has_legs"] );
			}
		}

		level.thundergun_last_knockdown_anim = fallAnim;
		if ( fallAnim == %ai_zombie_thundergun_hit_deadfallknee || fallAnim == %ai_zombie_thundergun_hit_forwardtoface )
		{
			getupAnim = random( level._zombie_getups[self.animname]["belly"]["early"] );
		}
		else
		{
			getupAnim = random( level._zombie_getups[self.animname]["back"]["early"] );
		}
	}
	else if ( self.damageYaw > -135 && self.damageYaw < -45 )
	{
		fallAnim = random( level._zombie_knockdowns[self.animname]["left"] );
		getupAnim = random( level._zombie_getups[self.animname]["belly"]["early"] );
	}
	else if ( self.damageYaw > 45 && self.damageYaw < 135 )
	{
		fallAnim = random( level._zombie_knockdowns[self.animname]["right"] );
		getupAnim = random( level._zombie_getups[self.animname]["belly"]["early"] );
	}
	else
	{
		fallAnim = random( level._zombie_knockdowns[self.animname]["back"] );
		getupAnim = random( level._zombie_getups[self.animname]["belly"]["early"] );
	}

//t6todo2	self SetFlaggedAnimKnobAllRestart( "painanim", fallAnim, %body, 1, .2, self.animPlayBackRate );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "painanim", self.thundergun_handle_pain_notetracks );

	if( !IsDefined( self ) || !IsAlive( self ) || !self.has_legs || (isDefined( self.marked_for_death ) && self.marked_for_death) )
	{
		// guy died on us 
		return;
	}	
	if ( getupAnim == %ai_zombie_thundergun_getup_quick_a && (self.a.gib_ref == "left_arm" || self.a.gib_ref == "right_arm") )
	{
		return;
	}

//t6todo2	self SetFlaggedAnimKnobAllRestart( "painanim", getupAnim, %body, 1, .2, self.animPlayBackRate );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "painanim" );
}
*/