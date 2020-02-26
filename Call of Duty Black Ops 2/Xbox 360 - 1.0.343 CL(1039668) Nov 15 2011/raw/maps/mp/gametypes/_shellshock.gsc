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

grenade_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 800 );
}

c4_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 512 );
}

satchel_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 512 );
}

barrel_earthQuake()
{
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, 512 );
}

rcbomb_earthQuake(position)
{
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, self.origin, 512 );
}

mortar_earthQuake( position )
{
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 800 );
}

artillery_earthQuake( position )
{
	PlayRumbleOnPosition( "artillery_rumble", position );
	Earthquake( 0.7, 0.75, position, 800 );
}

rocket_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "projectile_impact", weapon_name, position, explosion_radius, rocket_entity );
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 800 );
}

explosive_bolt_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, position, 512 );
}
