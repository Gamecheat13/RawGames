// Test clientside script for pow

#include clientscripts\_utility;

main()
{
	clientscripts\pow_fx::main();
	clientscripts\_flamethrower_plight::init();
	
	// _load!
	clientscripts\_load::main();

	level.ACTOR_BLEEDING = 3;
	level.ACTOR_CHARRING = 2;
	register_clientflag_callback("actor", level.ACTOR_CHARRING, ::actor_flag_charring_handler);
	register_clientflag_callback("actor", level.ACTOR_BLEEDING, ::actor_flag_bleeding_handler);
	register_clientflag_callback("scriptmover", level.ACTOR_BLEEDING, ::actor_flag_bleeding_handler);

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pow_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : pow running...");
}


actor_flag_charring_handler(localClientNum, set, newEnt)
{
	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 

	println("*** Client : flag callback good");
	self enable_charring(localClientNum, set);
}

enable_charring(localClientNum, set)
{
	if(!is_mature())
	{
		return;
	}
	
	self endon("death");
	println("*** Client : charring actor in progress");

	if(set)
	{
		vec0_val0_specular = 0;
		vec0_val1_dummy = 0;
		vec0_val2_char = 0;
		vec0_val3_dummy = 0;

		while(vec0_val2_char < 0.85)
		{
			println("*** Client : character is burning");
			//vec0_val0_specular += 0.01;
			//vec0_val1_dummy += 0.01;
			vec0_val2_char += 0.28;
			//vec0_val3_dummy += 0.01;

			self setshaderconstant( localClientNum, 0, vec0_val0_specular, vec0_val1_dummy, vec0_val2_char, vec0_val3_dummy );
			
			wait(0.1);
		}
	}
}

actor_flag_bleeding_handler(localClientNum, set, newEnt)
{
	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 

	println("*** Client : flag callback good");
	self enable_bleeding(localClientNum, set);
}

enable_bleeding(localClientNum, set)
{
	
	if(!is_mature())
	{
		return;
	}
	
	self endon("death");
	println("*** Client : bleeding actor in progress");

	if(set)
	{	
		unused = 0;
		bleed_amount = 0;

		while(bleed_amount < 0.82)
		{
			println("*** Client : character is bleeding: " + bleed_amount);
			//vec0_val0_specular += 0.01;
			//vec0_val1_dummy += 0.01;
			bleed_amount += 0.02;
			//vec0_val3_dummy += 0.01;

			self setshaderconstant( localClientNum, 0, unused, bleed_amount, unused, unused );
			
			wait(0.05);
		}
	}
}