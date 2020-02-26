init( localClientNum )
{
	level._effect["networkintruder_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["networkintruder_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
}

spawned( localClientNum )
{
	self thread clientscripts\_fx::blinky_light( localClientNum, "tag_light", level._effect["networkintruder_friendly_light"] );
}
