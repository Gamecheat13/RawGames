#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;

main()
{
	self endon("killanimscript");
	self endon ("melee");

	maps\mp\animscripts\zm_utility::initialize("zombie_combat");
	
	self AnimMode("zonly_physics", false);
	
	// before, we oriented to enemy briefly and then changed to face current.
	// now we just face current immediately and rely on turning.
	self OrientMode( "face angle", self.angles[1] );
	
	for(;;)
	{
		if ( TryMelee() )
		{
			return;
		}

		exposedWait();
	}
}


exposedWait()
{
	if ( !isDefined(self.can_always_see) && (!IsDefined( self.enemy ) || !self cansee( self.enemy )) )
	{
		self endon("enemy");
		
		wait 0.2 + RandomFloat( 0.1 );
	}
	else
	if ( !IsDefined( self.enemy ) )
	{
			self endon("enemy");
			
			wait 0.2 + RandomFloat( 0.1 );
	}
	else
	{
		wait 0.05;
	}
}

TryMelee()
{
	if ( is_true( self.cant_melee ) )
	{
		return false;
	}
	if ( !IsDefined( self.enemy ) )
	{
		return false;
	}

	// early out
	if ( DistanceSquared( self.origin, self.enemy.origin ) > 512*512 )
	{
		return false;
	}
	
	canMelee = maps\mp\animscripts\zm_melee::CanMeleeDesperate();

	if ( !canMelee )
	{
		return false;
	}

	self thread maps\mp\animscripts\zm_melee::MeleeCombat();

	return true;
}
