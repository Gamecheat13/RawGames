
init()
{
	level._effect["satchel_charge_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["satchel_charge_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
}

createSatchelWatcher()
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "satchel_charge", "satchel_charge_mp", self.team );
	watcher.altDetonate = true;
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.headIcon = true;
	watcher.detonate = maps\mp\gametypes\_weaponobjects::weaponDetonate;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.altWeapon = "satchel_charge_detonator_mp";
	watcher.reconModel = "weapon_c4_mp_detect";
	watcher.ownerGetsAssist = true;
}