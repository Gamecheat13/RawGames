
init()
{
	level._effect["satchel_charge_enemy_light"] = loadfx( "weapon/c4/fx_c4_light_red" );
	level._effect["satchel_charge_friendly_light"] = loadfx( "weapon/c4/fx_c4_light_green" );
}

createSatchelWatcher()
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "satchel_charge", "satchel_charge_mp", self.team );
	watcher.altDetonate = true;
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.headIcon = true;
	watcher.detonate = ::stachelDetonate;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.altWeapon = "satchel_charge_detonator_mp";
	watcher.reconModel = "t6_wpn_c4_world_detect";
	watcher.ownerGetsAssist = true;
}

stachelDetonate(attacker, weaponName )
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( !IsDefined( from_emp ) || !from_emp )
	{
		if ( IsDefined( attacker ) )
		{
			if ( ( level.teambased && attacker.team != self.owner.team ) || ( attacker != self.owner ) ) 
			{
				attacker maps\mp\_challenges::destroyedExplosive();
				maps\mp\_scoreevents::processScoreEvent( "destroyed_c4", attacker, self.owner, weaponName, true );
			}
		}
	}
	
	maps\mp\gametypes\_weaponobjects::weaponDetonate( attacker, weaponName );
}
