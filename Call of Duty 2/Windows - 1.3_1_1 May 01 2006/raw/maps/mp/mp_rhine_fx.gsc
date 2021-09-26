main()
{
	thread lampglowfx();

	precacheFX();
	ambientFX();
	level.scr_sound["flak88_explode"]			= "flak88_explode";
}

precacheFX()
{
	//ambient fx
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["dust_wind"]					= loadfx ("fx/dust/dust_wind_eldaba.efx");
	level._effect["battlefield_smokebank_S"]	= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["flak_explosion"]				= loadfx("fx/explosions/flak88_explosion.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");         																																																																																
	level._effect["thin_light_smoke_L"]			= loadfx ("fx/smoke/thin_light_smoke_L.efx");         																																																																																
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");         		

}

ambientFX()
{
/*
	maps\mp\_fx::loopfx("fogbank_small_duhoc", (1568,2712,-47), 2, (1568,2712,52));
	maps\mp\_fx::loopfx("fogbank_small_duhoc", (-1102,1725,-27), 2, (-1102,1725,72));
	maps\mp\_fx::loopfx("fogbank_small_duhoc", (567,3433,-52), 2, (567,3433,47));
	//maps\mp\_fx::loopfx("thin_black_smoke_M", (266,620,280), 1, (266,620,379));

	//original dust fx DO NOT DELETE
	maps\mp\_fx::loopfx("dust_wind", (-240,1574,-23), 1, (-240,1574,76));
	maps\mp\_fx::loopfx("dust_wind", (-240,1110,-23), 1, (-240,1110,76));
	maps\mp\_fx::loopfx("dust_wind", (473,966,-2), 1, (473,966,97));
	maps\mp\_fx::loopfx("dust_wind", (1546,2003,-42), 1, (1546,2003,57));
	maps\mp\_fx::loopfx("dust_wind", (1511,1078,-39), 1, (1511,1078,60));
	maps\mp\_fx::loopfx("dust_wind", (1398,349,-16), 1, (1398,349,83));
	maps\mp\_fx::loopfx("dust_wind", (935,2569,-49), 1, (935,2569,50));
	maps\mp\_fx::loopfx("dust_wind", (-228,2353,-15), 1, (-228,2353,84));
	maps\mp\_fx::loopfx("dust_wind", (470,238,2), 1, (470,238,101));
	maps\mp\_fx::loopfx("dust_wind", (362,-202,46), 1, (362,-202,145));
	maps\mp\_fx::loopfx("dust_wind", (372,-673,46), 1, (372,-673,145));
	maps\mp\_fx::loopfx("dust_wind", (-242,485,-8), 1, (-242,485,90));
*/

	//Fogbanks
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (6477,14914,416), 1, (6477,14914,516));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (7538,15131,416), 1, (7538,15131,516));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (7046,15279,416), 1, (7046,15279,516));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (2706,15368,340), 0.8, (2706,15368,440));
	maps\mp\_fx::loopfx("thin_light_smoke_L", (4331,17680,486), 0.6, (4331,17680,586));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (3841,15623,369), 1, (3841,15623,469));
	maps\mp\_fx::loopfx("thin_light_smoke_M", (7057,14874,392), 0.6, (7057,14874,492));
	maps\mp\_fx::loopfx("thin_light_smoke_M", (6546,17309,459), 0.6, (6546,17309,559));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (4419,16849,486), 1, (4419,16849,586));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (5229,16347,510), 1, (5229,16347,610));
	maps\mp\_fx::loopfx("battlefield_smokebank_S", (7848,15866,416), 1, (7848,15866,516));
	maps\mp\_fx::loopfx("thin_light_smoke_M", (4732,15787,345), 0.6, (4732,15787,445));
	maps\mp\_fx::loopfx("thin_light_smoke_M", (4456,14790,379), 0.6, (4456,14790,479));
	maps\mp\_fx::loopfx("thin_light_smoke_M", (5761,14953,402), 0.6, (5761,14953,502));

	//Dust
	maps\mp\_fx::loopfx("dust_wind", (3444,16002,317), 0.6, (3444,16002,417));
	maps\mp\_fx::loopfx("dust_wind", (3688,16570,401), 0.6, (3688,16570,501));
	maps\mp\_fx::loopfx("dust_wind", (6384,16816,477), 0.6, (6384,16816,577));
	maps\mp\_fx::loopfx("dust_wind", (6659,15766,445), 0.6, (6659,15766,545));
	maps\mp\_fx::loopfx("dust_wind", (3289,15617,317), 0.6, (3289,15617,417));
	maps\mp\_fx::loopfx("dust_wind", (5032,14842,391), 0.6, (5032,14842,491));
	maps\mp\_fx::loopfx("dust_wind", (6771,16499,445), 0.6, (6771,16499,545));
	maps\mp\_fx::loopfx("dust_wind", (5287,14871,423), 0.6, (5287,14871,523));
	maps\mp\_fx::loopfx("dust_wind", (4231,17205,529), 0.6, (4231,17205,629));
	maps\mp\_fx::loopfx("dust_wind", (4311,16284,441), 0.6, (4311,16284,541));
	maps\mp\_fx::loopfx("dust_wind", (3542,14915,346), 0.6, (3542,14915,446));
	maps\mp\_fx::loopfx("dust_wind", (6580,15490,386), 0.6, (6580,15490,486));

}



lampglowfx()
{
	if (!isdefined(level._effect))
		level._effect = [];
	if (!isdefined(level._effect["lantern_light"]))
		level._effect["lantern_light"]	= loadfx("fx/props/glow_latern.efx");
//	thread maps\mp\_fx::loopfx("lantern_light", self.origin, 0.3, self.origin + (0,0,1), undefined, "lantern_stop");
}
