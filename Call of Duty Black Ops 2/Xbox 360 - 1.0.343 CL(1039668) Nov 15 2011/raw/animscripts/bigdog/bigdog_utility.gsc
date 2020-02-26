#include animscripts\anims;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("bigdog");

// Every script calls initAnimTree to ensure a clean, fresh, known animtree state.  
// ClearAnim should never be called directly, and this should never occur other than
// at the start of an animscript
// This function now also does any initialization for the scripts that needs to happen 
// at the beginning of every main script.
initAnimTree(animscript)
{
	self ClearAnim( %body, 0.3 );
	self SetAnim( %body, 1, 0 );	// The %body node should always have weight 1.

	assert( IsDefined( animscript ), "Animscript not specified in initAnimTree" );
	self.a.prevScript = self.a.script;
	self.a.script = animscript;
	self.a.script_suffix = undefined;

	self animscripts\anims::clearAnimCache();
}

initialize( animscript )
{
	/#
		if( IsDefined(self.a.script) && !self animscripts\debug::debugShouldClearState() )
		{
			self animscripts\debug::debugPopState( self.a.script );
		}
		else
		{
			self animscripts\debug::debugClearState();
		}

		self animscripts\debug::debugPushState( animscript );
	#/

		self.a.scriptStartTime = GetTime();

		initAnimTree( animscript );
}

fire_grenade_at_target( target )
{
	// store current target
	scriptedEnemy = self.scriptenemy;

	// set new target
	self SetEntityTarget( target );

	// allow launcher firing
//	self magicgrenade( self GetTagOrigin("tag_flash"), target.origin );
	self.grenadeammo = 1;

	self waittill("grenade_fire");

	// stop firing
	self.grenadeammo = 0;

	// restore previous target
	if( IsDefined(scriptedEnemy) )
		self SetEntityTarget( target );
	else
		self ClearEntityTarget();
}

animSuffix()
{
	animSuffix = "";

	if( IsDefined( self.missingLegs["FR"] ) && IsDefined( self.missingLegs["FL"] ) && IsDefined( self.missingLegs["RL"] ) && IsDefined( self.missingLegs["RR"] ) )
		animSuffix = "_all_legs";
	if( IsDefined( self.missingLegs["FR"] ) && IsDefined( self.missingLegs["FL"] ) )
		animSuffix = "_frontlegs";
	else if( IsDefined( self.missingLegs["RR"] ) && IsDefined( self.missingLegs["RL"] ) )
		animSuffix = "_rearlegs";
	else if( IsDefined( self.missingLegs["FL"] ) && IsDefined( self.missingLegs["RL"] ) )
		animSuffix = "_leftlegs";
	else if( IsDefined( self.missingLegs["FR"] ) && IsDefined( self.missingLegs["RR"] ) )
		animSuffix = "_rightlegs";
	else if( IsDefined( self.missingLegs["FR"] ) )
		animSuffix = "_frontright";
	else if( IsDefined( self.missingLegs["FL"] ) )
		animSuffix = "_frontleft";
	else if( IsDefined( self.missingLegs["RR"] ) )
		animSuffix = "_rearright";
	else if( IsDefined( self.missingLegs["RL"] ) )
		animSuffix = "_rearleft";

	return animSuffix;
}