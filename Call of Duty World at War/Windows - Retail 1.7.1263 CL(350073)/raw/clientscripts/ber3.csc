// Test clientside script for ber3

#include clientscripts\_utility;
#include clientscripts\_music;

resolve_struct_targets()
{
	for(i = 0; i < level.struct.size; i ++)
	{
		struct = level.struct[i];
		
		if(isdefined(struct.target))
		{
			targ_struct = getstructarray(struct.target, "targetname");
			
			if(isdefined(targ_struct))
			{
				struct.targeted = [];
				for(j = 0; j < targ_struct.size; j ++)
				{
					struct.targeted[struct.targeted.size] = targ_struct[j];
				}
			}
		}
	}
}

debug_position(model)
{
/#
	while(1)
	{
		print3d(self.origin," + " + model, (0.0,1.0,0.0), 1,3,30);
		realwait(1.0);
	}
#/	
}

decorate_level()
{
	// Array of decoration models.
	
	models = [];
	models[models.size] = "vehicle_rus_tracked_t34_dmg";
	models[models.size] = "vehicle_rus_tracked_t34_dmg";
	models[models.size] = "vehicle_rus_tracked_t34_dmg";
	models[models.size] = "vehicle_rus_tracked_t34_dmg";
	
	level waittill("dl");
	
	structs = getstructarray("coop_dest_tank_spot","targetname");
	
	players = getlocalplayers();
	
	for(i = 0; i < structs.size; i ++)
	{
		struct = structs[i];
		
		model = models[randomintrange(0, models.size)];
	
		// Create the same model for all local players - just in case we are running in split screen
			
		for(j = 0; j < players.size; j ++)
		{
			ent = spawn(j, structs[i].origin, "script_model");			
			
			ent setmodel(model);
			ent.angles = structs[i].angles;	// model is in same orientation as the node.
			
/*			if(j == 0)
			{
				ent thread debug_position(model);
			} */
			
		}
	}
}

main()
{

	// _load!
	clientscripts\_load::main();

	resolve_struct_targets();

	clientscripts\_artillery::main("artillery_ger_pak43", "pak43");
	clientscripts\_katyusha::main("vehicle_rus_wheeled_bm13" );
	clientscripts\_t34::main("vehicle_rus_tracked_t34" );

	clientscripts\ber3_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\ber3_amb::main();

	thread decorate_level();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
		
	println("*** Client : ber3 running...");
}
