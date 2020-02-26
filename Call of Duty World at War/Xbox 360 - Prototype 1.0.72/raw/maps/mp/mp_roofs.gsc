main()
{
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_rooftops");

	setExpFog(500, 3500, .5, 0.5, 0.45, 0);
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	/*
	- Exploder Effects:
	Setting script_noteworthy on a bombzone
	trigger to an exploder group can be used to
	trigger additional effects.
	*/

	/*QUAKED mp_sd_spawn_attacker (0.0 1.0 0.0) (-16 -16 0) (16 16 72)

	Attacking players spawn randomly at one of these positions at the beginning of a
	round.*/

	/*QUAKED mp_sd_spawn_defender (1.0 0.0 0.0) (-16 -16 0) (16 16 72)

	Defending players spawn randomly at one of these positions at the beginning of a
	round.*/

}