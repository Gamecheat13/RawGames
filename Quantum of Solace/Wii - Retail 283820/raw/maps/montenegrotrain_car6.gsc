




#include maps\_utility;

e6_main()
{
	thread delete_car6_flood();

	

	
	
	
	
	
	level thread car6_line_1();
	
	level thread car6_line_2();


	
	
	level waittill( "in_car_6" );
	thread maps\MontenegroTrain_car7::e7_main();
	
	
	
	
	
	
	


}




delete_car6_flood()
{
	trig = GetEnt( "delete_car6_flood", "targetname" );

	car6_floodspawner = GetEnt( "car6_flood", "script_noteworthy" );
	
	if ( IsDefined(trig) )
	{
		trig waittill ("trigger");
		if ( IsDefined(car6_floodspawner) )
		{
			car6_floodspawner delete();
		}	
	}	
}











car6_line_1()
{
	
	level.player endon( "death" );

	
	
	

	
	enta_car6_first_spawners = getentarray( "car6_first_spawner", "targetname" );
	
	trig = getent( "trig_lookat_box_fall", "targetname" );
	
	
	
	car5_exit_door_right = getent( "dr_car5_r_exit", "targetname" );
	car5_exit_door_left = getent( "dr_car5_l_exit", "targetname" );
	
	
	nodea_car5_exit = getnodearray( "auto2120", "targetname" );

	
	assertex( isdefined( enta_car6_first_spawners ), "enta_car6_first_spawners not defined" );
	assertex( isdefined( trig ), "trig not defined" );
	assertex( isdefined( car5_exit_door_right ), "car5_exit_door_right not defined" );
	assertex( isdefined( car5_exit_door_left ), "car5_exit_door_left not defined" );
	assertex( isdefined( nodea_car5_exit ), "nodea_car5_exit not defined" );

	
	level flag_wait( "freight_to_node3" );

	
	

	
	trig waittill( "trigger" );

	
	for( i=0; i<enta_car6_first_spawners.size; i++ )
	{
		
		enta_car6_first_spawners[i] thread car6_line_1_spawn();

		
		wait( 0.05 );
	}

	
	wait( 5.0 );

	
	

}





car6_line_1_spawn()
{
	
	level.player endon( "death" );

	
	assertex( isdefined( self.script_noteworthy ), self.origin + " missing noteworthy" );

	
	
	noda_cover = getnodearray( self.script_noteworthy, "targetname" );
	
	ent_temp = undefined;

	
	for( i=0; i<noda_cover.size; i++ )
	{
		
		assertex( isdefined( noda_cover[i].script_string ), noda_cover[i].targetname + " check script_string" );

		
		wait( 0.05 );
	}

	
	self.count = noda_cover.size;

	
	for( i=0; i<noda_cover.size; i++ )
	{
		
		ent_temp = self stalingradspawn( "car6_enemy" );

		
		if( spawn_failed( ent_temp ) )
		{
			
			iprintlnbold( self.targetname + " fail spawn" );

			
			wait( 5.0 );

			
			return;
		}

		
		ent_temp setalertstatemin( "alert_red" );
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		
		ent_temp SetCombatRole( noda_cover[i].script_string );

								
								ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

		
		ent_temp setgoalnode( noda_cover[i], 1 );

		
		wait( 1.0 );
	}
}







car6_line_2()
{
	
	level.player endon( "death" );

	
	
	trig_line2_setup = getent( "player_at_car_6", "targetname" );
	
	spawner_car6_line_2 = getent( "spwn_car6_line2", "targetname" );
	
	ent_temp = undefined;
	
	
	wait( 0.05 );

	
	assertex( isdefined( spawner_car6_line_2 ), "spawner_car6_line_2 not defined" );
	assertex( isdefined( spawner_car6_line_2.script_parameters ), "spawner_car6_line_2.script_parameters not defined" );
	assertex( isdefined( trig_line2_setup ), "trig_line2_setup not defined" );

	
	noda_car6_line_2 = getnodearray( spawner_car6_line_2.script_parameters, "targetname" );

	
	assertex( isdefined( noda_car6_line_2 ), "noda_car6_line_2 not defined" );

	
	spawner_car6_line_2.count = noda_car6_line_2.size;

	
	trig_line2_setup waittill( "trigger" );

	
	level thread car6_rusher_drop();

	
	for( i=0; i<noda_car6_line_2.size; i++ )
	{
		
		ent_temp = spawner_car6_line_2 stalingradspawn( "car6_enemy" );

		
		if( spawn_failed( ent_temp ))
		{
			
			iprintlnbold( "spawn fail in line2" );

			
			wait( 5.0 );

			
			return;
		}

		
		
		ent_temp setalertstatemin( "alert_red" );
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		
		if( isdefined( noda_car6_line_2[i].script_string ) )
		{
			
			ent_temp SetCombatRole( noda_car6_line_2[i].script_string );
		}
		
		else
		{
			
			ent_temp SetCombatRole( "flanker" );
		}

		
		wait( 1.5 );

		
		ent_temp = undefined;
	}

	
	
	spawner_car6_line_2 delete();
}




car6_rusher_drop()
{
	
	level.player endon( "death" );

	
	
	spwn_car6_rusher = getent( "spwn_car6_rusher", "targetname" );

	
	assertex( isdefined( spwn_car6_rusher.target ), "spwn_car6_rusher no target" );

	

	
	destin_node = getnode( spwn_car6_rusher.target, "targetname" );
	
	ent_temp = undefined;

	
	ent_temp = spwn_car6_rusher stalingradspawn( "car6_enemy" );

	
	if( spawn_failed( ent_temp ) )
	{
		
		iprintlnbold( "spwn_car6_rusher fail spawn" );

		
		wait( 5.0 );

		
		return;
	}

	

	
	ent_temp setalertstatemin( "alert_red" );
	ent_temp setengagerule( "tgtSight" );
	ent_temp addengagerule( "tgtPerceive" );
	ent_temp addengagerule( "Damaged" );
	ent_temp addengagerule( "Attacked" );

				
				ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

	
	ent_temp setgoalnode( destin_node, 1 );

}