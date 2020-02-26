#include maps\_utility;
#include maps\pel2_util;


main()
{
	
	maps\_tiger::main("vehicle_tiger_woodland");
	//maps\_panzer2::main("vehicle_panzer_ii_winter");
	maps\_stuka::main("vehicle_stuka_flying");
	maps\_sherman::main("vehicle_american_sherman");
	
	maps\_load::main();
	
	setup_guzzo_hud();
	
	quick_text( "Step on the blue platforms to start the tank", 4 );

	level thread tank_fight();
	
	level.mortar = LoadFx( "explosions/fx_mortarExp_dirt" );
	
	level thread maps\_mortar::hurtgen_style();
	
	wait ( 1 );
	
	level notify( "start_mortars" );
	
//	wait_node = getvehiclenode( "node_wait", "targetname" );
//	
//	tank setWaitNode( wait_node );
//	tank waittill( "reached_wait_node" );		
//
//	tank setSpeed( 0, 2, 2 );
//	
//	quick_text( "tank_stopping" );
//	
//	wait ( 2 );
//	
//	
//	quick_text( "tank_starting" );
//	
//	tank setSpeed( 5, 2, 2 );
	
	//level thread flak_gun();

//	wait 25;
//	
//	quick_text( "Stopping tiger aiming", 3 );
//	
//	tiger = getent( "tiger", "targetname" );
//	tiger notify( "attacking origins" ); 

}

tank_fight()
{
	
	trig = getent( "trig_tiger_spawn", "targetname" );
	trig waittill( "trigger" );	

	wait ( 1 );

	tank = getent( "tiger", "targetname" );
	
	sherman = getent( "sherman_1", "targetname" );
	sherman2 = getent( "sherman_2", "targetname" );
	
	while( 1 )
	{
	
		tank SetTurretTargetEnt( sherman, ( 0, 0, 0 ) );

		tank waittill( "turret_on_target" ); 

		wait ( 1 );

		tank ClearTurretTarget(); 
		tank notify( "turret_fire" ); 
		
		sherman dodamage( 100, sherman.origin );
		
		wait ( 3 );

		tank SetTurretTargetEnt( sherman2, ( 0, 0, 0 ) );

		tank waittill( "turret_on_target" ); 

		wait ( 1 );

		tank ClearTurretTarget(); 
		tank notify( "turret_fire" ); 
		
		sherman2 dodamage( 100, sherman.origin );
		
		wait ( 3 );
	
	}

	
}

flak_gun()
{

	level._effect["aa_single_tracer"] = loadfx( "misc/antiair_single_tracer" );
	
	level.flak1 = GetEnt( "aaGun", "targetname" );
	level.flak1 thread aa_fireloop();
	
}

// self = the entity whose origin is the fx starting point.  TODO make the gun actually fire.
aa_fireloop()
{
	self endon( "aa_fireloop_end" );

	interval_min = 2;
	interval_max = 5;

	fxOrigin = self.origin;

	while( 1 )
	{
		fx = PlayFX( level._effect["aa_single_tracer"], fxOrigin );
		wait( RandomFloatRange( interval_min, interval_max ) );
	}
}