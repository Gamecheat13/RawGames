#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	precacheShellShock( "frag_grenade_mp" );
	precacheShellShock( "damage_mp" );
	precacheRumble( "artillery_rumble" );
	precacheRumble( "grenade_rumble" );
}

shellshockOnDamage( cause, damage )
{
	if ( self maps\mp\_flashgrenades::isFlashbanged() )
		return; // don't interrupt flashbang shellshock
	
	if ( cause == "MOD_EXPLOSIVE" ||
	     cause == "MOD_GRENADE" ||
	     cause == "MOD_GRENADE_SPLASH" ||
	     cause == "MOD_PROJECTILE" ||
	     cause == "MOD_PROJECTILE_SPLASH" )
	{
		time = 0;
		
		if(damage >= 90)
			time = 4;
		else if(damage >= 50)
			time = 3;
		else if(damage >= 25)
			time = 2;
		else if(damage > 10)
			time = 2;
		
		if ( time )
		{
			if ( self mayApplyScreenEffect() )
				self shellshock("frag_grenade_mp", 0.5);
		}
	}
}

endOnDeath()
{
	self waittill( "death" );
	waittillframeend;
	self notify ( "end_explode" );
}

endOnTimer( timer )
{
	self endon( "disconnect" );

	wait( timer );
	self notify( "end_on_timer" );
}

rcbomb_earthQuake(position)
{
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, self.origin, 512 );
}