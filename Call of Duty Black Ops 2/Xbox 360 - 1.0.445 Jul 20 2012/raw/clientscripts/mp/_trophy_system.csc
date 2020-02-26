#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

init( localClientNum )
{
	level._effect["fx_trophy_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
	level._effect["fx_trophy_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
}

spawned( localClientNum ) // self == the grenade
{
	self endon( "entityshutdown" );
	self thread clientscripts\mp\_fx::blinky_light( localClientNum, "tag_fx", level._effect["fx_trophy_friendly_light"], level._effect["fx_trophy_enemy_light"] );
}
