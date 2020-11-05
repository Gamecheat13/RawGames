// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	self._gib_def = level._gibbing_actor_models["c_mul_pmc_body_1_1"];
}

precache()
{
	register_gibs();
}

register_gibs()
{

	if(!isDefined(level._gibbing_actor_models))
	{
		level._gibbing_actor_models = [];
	}

	gib_spawn = spawnstruct();

	gib_spawn.gibSpawn1 = "c_mul_pmc_body_1_1_g_spawn_rarm";
	gib_spawn.gibSpawnTag1 = "J_Elbow_RI";
	gib_spawn.gibSpawn2 = "c_mul_pmc_body_1_1_g_spawn_larm";
	gib_spawn.gibSpawnTag2 = "J_Elbow_LE";
	gib_spawn.gibSpawn3 = "c_mul_pmc_body_1_1_g_spawn_rleg";
	gib_spawn.gibSpawnTag3 = "J_Knee_RI";
	gib_spawn.gibSpawn4 = "c_mul_pmc_body_1_1_g_spawn_lleg";
	gib_spawn.gibSpawnTag4 = "J_Knee_LE";

	level._gibbing_actor_models["c_mul_pmc_body_1_1"] = gib_spawn;

}