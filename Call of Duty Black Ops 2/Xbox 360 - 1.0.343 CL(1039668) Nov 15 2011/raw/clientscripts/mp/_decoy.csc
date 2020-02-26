#include clientscripts\mp\_utility;

init()
{
	level._effect["decoy_fire"] = loadfx( "weapon/grenade/fx_nightingale_grenade_mp" );
	
	level thread levelWatchForFakeFire();
}

spawned(localClientNum)
{	
	self thread watchForFakeFire(localClientNum);
}

watchForFakeFire( localClientNum )
{
	self endon("entityshutdown");
	
	while(1)
	{
		self waittill( "fake_fire" );
		
		PlayFxOnTag( localClientNum, level._effect["decoy_fire"], self, "tag_origin" );
	}
}

levelWatchForFakeFire( )
{
	while(1)
	{
		self waittill( "fake_fire", origin );
		
		PlayFX( 0, level._effect["decoy_fire"], origin );
	}
}

