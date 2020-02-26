// Test clientside script for khe_sanh

#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
	clientscripts\khe_sanh_fx::main();

	// _load!
	clientscripts\_load::main();

	init_flags();
	register_clientflag_callback("scriptmover", 0, ::scriptmover_heli_crash_sound_handler);
	register_clientflag_callback("scriptmover", level.SCRIPTMOVER_CHARRING, ::scriptmover_flag_charring_handler);
	register_clientflag_callback("actor", level.ACTOR_CHARRING, ::actor_flag_charring_handler);

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\khe_sanh_amb::main();

	thread clientscripts\_flamethrower_plight::init();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	init_filter_tvguided( getlocalplayers()[0] ); 
		
	println("*** Client : khe_sanh running...");
}

init_flags()
{
	// Client Flags -- Match these in level
	level.SCRIPTMOVER_CHARRING			= 1;
	level.ACTOR_CHARRING				= 2;
}

scriptmover_flag_charring_handler(localClientNum, set, newEnt)
{
	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 

	println("*** Client : flag callback good");
	self enable_charring(localClientNum, set);
}

actor_flag_charring_handler(localClientNum, set, newEnt)
{
	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 

	println("*** Client : flag callback good");
	self enable_charring(localClientNum, set);
}

enable_charring(localClientNum, set)
{
	self endon("death");
	println("*** Client : charring actor in progress");

	if( is_mature() )
	{
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
}

scriptmover_heli_crash_sound_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		self play_heli_crash_sound();
	}	// Clearing flag
	else
	{
		self notify( "stop_heli_crash_sound" );
	}
}

play_heli_crash_sound() //self == helicopter crashing
{
	chopper_sound_ent = Spawn( 0, self.origin, "script_origin" );
	chopper_sound_ent LinkTo( self, "tag_origin" );
	play_id = chopper_sound_ent PlaySound( 0, "evt_chopper_crash_hit" );

	self thread stop_and_delete_heli_crash_sound( chopper_sound_ent, play_id );
}

stop_and_delete_heli_crash_sound( ent, play_id ) //self == helicopter crashing
{
	self waittill( "stop_heli_crash_sound" );

	StopSound( play_id );
	ent Delete();
}
