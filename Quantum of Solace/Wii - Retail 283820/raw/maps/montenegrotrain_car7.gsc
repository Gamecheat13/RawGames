




#include maps\_utility;




e7_main()
{
	thread maps\MontenegroTrain_util::lights_flickering();
	
	
	
	
	level thread car7_sneaky_init();

	
	level waittill( "in_car_7" );
	thread maps\MontenegroTrain_car8::e8_main();
	thread remove_train2_civilians();
}





remove_train2_civilians()
{
	civ2_array = getentarray("train2_civilian", "script_noteworthy");

	for (i = 0; i < civ2_array.size; i++)
	{
		if( IsDefined (civ2_array[i]) )
		{
  		civ2_array[i] delete();
  		}		
	}

} 







	 
car7_sneaky_init()
{
	
	wait( 1.0 );
		
	
	level notify( "playmusicpackage_action2" );
	
	
	level.player endon( "death" );

	
	
	trig_setup = getent( "sneaky_car7", "targetname" );

	
	assertex( isdefined( trig_setup ), "trig_setup not defined" );

	
	trig_setup waittill( "trigger" );

	
	level thread car7_ambush_1();
	level thread car7_ambush_2();
	level thread car7_ambush_3();
	level thread car7_amb3_backup();
	


}






car7_ambush_1()
{
	
	level.player endon( "death" );

	
	
	amb1_spawner = getent( "spwn_car7_ambush1", "targetname" );
	
	assertex( isdefined( amb1_spawner ), "amb1_spawner not defined" );
	
	amb1_node = getnode( amb1_spawner.target, "targetname" );
	
	assertex( isdefined( amb1_node ), "amb1_node not defined" );
	
	amb1_trig = getent( amb1_node.target, "targetname" );
	trig_clean_up = getent( "player_at_car_8", "targetname" );
	
	assertex( isdefined( amb1_trig ), "amb1_trig not defined" );
	assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
	
	ent_temp = undefined;

	
	ent_temp = amb1_spawner stalingradspawn( "car7_enemy" );

	
	if( spawn_failed( ent_temp ) )
	{
		
		iprintlnbold( "amb1 ent failed spawn" );

		
		wait( 5.0 );

		
		return;
	}
	
	else
	{
		
		ent_temp thread car7_amb_guy1( amb1_node, amb1_trig );

	}

	
	
	trig_clean_up waittill( "trigger" );

	
	amb1_spawner delete();
	
	amb1_trig delete();

}





car7_amb_guy1( node, trig )
{
	
	level.player endon( "death" );
	self endon( "death" );
	self endon( "damage" );

	
	self setenablesense( false );
	self setalertstatemin( "alert_red" );

	
	self thread car7_ai_back_to_normal();

	
	self setgoalnode( node );

	
	self waittill( "goal" );

	
	level waittill( "car7_first_go" );

	
	trig waittill( "trigger" );

	
	self cmdshootatentity( level.player, true, 2.0, 0.2, true );

	
	self setenablesense( true );
	self setengagerule( "tgtSight" );
	self addengagerule( "tgtPerceive" );
	self addengagerule( "Damaged" );
	self addengagerule( "Attacked" );

	
	self notify( "already_normal" );

}






car7_ambush_2()
{
	
	level.player endon( "death" );

	
	
	amb2_spawner = getent( "spwn_car7_ambush2", "targetname" );
	
	assertex( isdefined( amb2_spawner ), "amb2_spawner not defined" );
	
	amb2_node = getnode( amb2_spawner.target, "targetname" );
	
	assertex( isdefined( amb2_node ), "amb2_node not defined" );
	
	amb2_trig = getent( amb2_node.target, "targetname" );
	trig_clean_up = getent( "player_at_car_8", "targetname" );
	
	assertex( isdefined( amb2_trig ), "amb2_trig not defined" );
	assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
	
	ent_temp = undefined;

	
	ent_temp = amb2_spawner stalingradspawn( "car7_enemy" );

	
	if( spawn_failed( ent_temp ) )
	{
		
		iprintlnbold( "amb2_spawner spawn fail" );

		
		wait( 5.0 );

		
		return;
	}
	
	else
	{
		
		ent_temp thread car7_amb_guy2( amb2_node, amb2_trig );
	}

	
	
	trig_clean_up waittill( "trigger" );

	
	amb2_spawner delete();
	
	amb2_trig delete();

}





car7_amb_guy2( node, trig )
{
	
	level.player endon( "death" );
	self endon( "death" );
	self endon( "damage" );

	
	self setenablesense( false );
	self setalertstatemin( "alert_red" );

	
	self thread car7_ai_back_to_normal();

	
	self setgoalnode( node );

	
	self waittill( "goal" );

	
	trig waittill( "trigger" );

	
	self cmdshootatentity( level.player, true, 4.0, 0.6, true );

	
	level notify( "car7_first_go" );

	
	self setenablesense( true );
	self setengagerule( "tgtSight" );
	self addengagerule( "tgtPerceive" );
	self addengagerule( "Damaged" );
	self addengagerule( "Attacked" );

	
	self notify( "already_normal" );

}






car7_ambush_3()
{
	
	level.player endon( "death" );

	
	
	amb3_spawner = getent( "spwn_car7_ambush3", "targetname" );
	
	assertex( isdefined( amb3_spawner ), "amb2_spawner not defined" );
	
	amb3_start_node = getnode( amb3_spawner.target, "targetname" );
	
	assertex( isdefined( amb3_start_node ), "amb2_node not defined" );
	
	amb3_destin_node = getnode( amb3_start_node.target, "targetname" );
	
	assertex( isdefined( amb3_destin_node ), "amb3_destin_node not defined!" );
	
	amb3_trig = getent( amb3_destin_node.target, "targetname" );
	trig_clean_up = getent( "player_at_car_8", "targetname" );
	
	assertex( isdefined( amb3_trig ), "amb2_trig not defined" );
	assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
	
	ent_temp = undefined;

	
	ent_temp = amb3_spawner stalingradspawn( "car7_enemy" );

	
	if( spawn_failed( ent_temp ) )
	{
		
		iprintlnbold( "amb3_spawner spawn fail" );

		
		wait( 5.0 );

		
		return;
	}
	
	else
	{
		
		ent_temp thread car7_amb_guy3( amb3_start_node, amb3_destin_node, amb3_trig );
	}

	
	
	trig_clean_up waittill( "trigger" );

	
	amb3_spawner delete();
	
	amb3_trig delete();

}





car7_amb_guy3( start_node, destin_node, trig )
{
	
	level.player endon( "death" );
	self endon( "death" );
	self endon( "damage" );

	
	self setenablesense( false );
	self setalertstatemin( "alert_red" );

	
	self thread car7_ai_back_to_normal();

	
	self setgoalnode( start_node );

	
	self waittill( "goal" );

	
	trig waittill( "trigger" );

				
				self thread maps\MontenegroTrain_util::turn_on_sense( 5 );

	
	self setgoalnode( destin_node, 1 );

	


	
	self setenablesense( true );
	self setengagerule( "tgtSight" );
	self addengagerule( "tgtPerceive" );
	self addengagerule( "Damaged" );
	self addengagerule( "Attacked" );

	
	self notify( "already_normal" );

				
				self thread maps\MontenegroTrain_util::turn_on_sense( 5 );

	
	self setgoalnode( destin_node, 1 );

}





car7_ai_back_to_normal()
{
	
	self endon( "death" );
	self endon( "already_normal" );

	
	self waittill( "damage" );

	
	self setenablesense( true );
	self setengagerule( "tgtSight" );
	self addengagerule( "tgtPerceive" );
	self addengagerule( "Damaged" );
	self addengagerule( "Attacked" );

}





car7_amb3_backup()
{
	
	level.player endon( "death" );

	
	
	enta_car7_backup = getentarray( "spwn_car7_amb_backup", "targetname" );
	
	assertex( isdefined( enta_car7_backup ), "enta_car7_backup not defined" );
	
	trig_start = getent( "auto2156", "targetname" );
	trig_clean_up = getent( "player_at_car_8", "targetname" );
	
	assertex( isdefined( trig_start ), "trig_start is not defined" );
	assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );

	
	trig_start waittill( "trigger" );

	
	wait( 1.5 );

	
	for( i=0; i<enta_car7_backup.size; i++ )
	{
		
		enta_car7_backup[i] thread car7_backup_guy();

		
		wait( 0.05 );
	}

	
	trig_clean_up waittill( "trigger" );

	
	for( i=0; i<enta_car7_backup.size; i++ )
	{
		
		enta_car7_backup[i] delete();

		
		wait( 0.05 );
	}

}






car7_backup_guy()
{
	
	assertex( isdefined( self.target ), "ca7_backup spawner missing a target!" );

	
	self.count = 1;

	
	destin_node = getnode( self.target, "targetname" );

	
	ent_temp = self stalingradspawn( "car7_enemy" );

	
	if( spawn_failed( ent_temp ) )
	{
		
		iprintlnbold( "car7_backup_guy failed spawn" );

		
		wait( 5.0 );

		
		return;
	}
	else
	{
		
		ent_temp setalertstatemin( "alert_red" );
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		
		ent_temp setgoalnode( destin_node );

	}
	
	
}