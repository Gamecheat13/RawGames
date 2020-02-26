#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

init( localClientNum )
{
	level._effect["satchel_charge_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["satchel_charge_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
}

spawned( localClientNum )
{
	self thread clientscripts\mp\_fx::blinky_light( localClientNum, "tag_light", level._effect["satchel_charge_friendly_light"], level._effect["satchel_charge_enemy_light"] );
}
