#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "t72", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_t72_tank", "vehicle_t72_tank_d_body" );
	build_shoot_shock( "tankblast" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_turret( "t72_turret2" , "tag_turret2" , "vehicle_t72_tank_pkt_coaxial_mg" , false );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
}

init_local()
{
}

set_vehicle_anims( positions )
{
	/*
	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	*/
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;

/*
	positions[ 0 ].getout = %crusader_tankride_guy0_closehatch;
	positions[ 1 ].getout = %crusader_tankride_guy1_combatdismount;
	positions[ 2 ].getout = %crusader_tankride_guy2_jumptocombatrun;
	positions[ 3 ].getout = %crusader_tankride_guy3_combatdismount;
	positions[ 4 ].getout = %crusader_tankride_guy4_combatdismount;
	positions[ 5 ].getout = %crusader_tankride_guy3_combatdismount;
	positions[ 6 ].getout = %crusader_tankride_guy6_jumptocombatrun;
	positions[ 7 ].getout = %crusader_tankride_guy3_combatdismount;
	positions[ 8 ].getout = %crusader_tankride_guy1_combatdismount;
	positions[ 9 ].getout = %crusader_tankride_guy1_combatdismount;
	positions[ 10 ].getout = %crusader_tankride_guy1_combatdismount;

	positions[ 0 ].idle[ 0 ] = %crusader_tankride_guy0_driving_idle;
	positions[ 1 ].idle[ 0 ] = %crusader_tankride_guy3_driving_idle;
	positions[ 2 ].idle[ 0 ] = %crusader_tankride_guy2_driving_idle;
	positions[ 3 ].idle[ 0 ] = %crusader_tankride_guy3_driving_idle;
	positions[ 4 ].idle[ 0 ] = %crusader_Tankride_guy4_driving_idle;
	positions[ 5 ].idle[ 0 ] = %crusader_tankride_guy3_driving_idle;
	positions[ 6 ].idle[ 0 ] = %crusader_tankride_guy6_driving_idle;
	positions[ 7 ].idle[ 0 ] = %crusader_tankride_guy3_driving_idle;
	positions[ 8 ].idle[ 0 ] = %crusader_Tankride_guy4_driving_idle;
	positions[ 9 ].idle[ 0 ] = %crusader_Tankride_guy4_driving_idle;
	positions[ 10 ].idle[ 0 ] = %crusader_Tankride_guy4_driving_idle;

	positions[ 0 ].idle[ 1 ] = %crusader_tankride_guy0_lookingaround;
	positions[ 1 ].idle[ 1 ] = %crusader_tankride_guy3_lookingaround;
	positions[ 2 ].idle[ 1 ] = %crusader_tankride_guy2_lookingaround;
	positions[ 3 ].idle[ 1 ] = %crusader_tankride_guy3_lookingaround;
	positions[ 4 ].idle[ 1 ] = %crusader_Tankride_guy4_lookingaround;
	positions[ 5 ].idle[ 1 ] = %crusader_tankride_guy3_lookingaround;
	positions[ 6 ].idle[ 1 ] = %crusader_tankride_guy6_lookingaround;
	positions[ 7 ].idle[ 1 ] = %crusader_tankride_guy3_lookingaround;
	positions[ 8 ].idle[ 1 ] = %crusader_Tankride_guy4_lookingaround;
	positions[ 9 ].idle[ 1 ] = %crusader_Tankride_guy4_lookingaround;
	positions[ 10 ].idle[ 1 ] = %crusader_Tankride_guy4_lookingaround;

	positions[ 0 ].explosion_death = 	%death_explosion_up10;
	positions[ 1 ].explosion_death = 	%death_explosion_forward13;
	positions[ 2 ].explosion_death = 	%death_explosion_back13;
	positions[ 3 ].explosion_death = 	%death_explosion_left11;
	positions[ 4 ].explosion_death = 	%death_explosion_forward13;
	positions[ 5 ].explosion_death = 	%death_explosion_right13;
	positions[ 6 ].explosion_death = 	%death_explosion_back13;
	positions[ 7 ].explosion_death = 	%death_explosion_left11;
	positions[ 8 ].explosion_death = 	%death_explosion_forward13;
	positions[ 9 ].explosion_death = 	%death_explosion_right13;
	positions[ 10 ].explosion_death = 	%death_explosion_back13;

	positions[ 0 ].deathscript = ::deathremove;
	positions[ 1 ].deathscript = ::deathremove;
	positions[ 2 ].deathscript = ::deathremove;
	positions[ 3 ].deathscript = ::deathremove;
	positions[ 4 ].deathscript = ::deathremove;
	positions[ 5 ].deathscript = ::deathremove;
	positions[ 6 ].deathscript = ::deathremove;
	positions[ 7 ].deathscript = ::deathremove;
	positions[ 8 ].deathscript = ::deathremove;
	positions[ 9 ].deathscript = ::deathremove;
	positions[ 10 ].deathscript = ::deathremove;
	
	positions[ 0 ].idle_right = %crusader_tankride_guy0_leanright;
	positions[ 1 ].idle_right = %crusader_Tankride_guy1_leanright;
	positions[ 2 ].idle_right = %crusader_tankride_guy2_leanleft;
	positions[ 3 ].idle_right = %crusader_tankride_guy3_leanback;
	positions[ 4 ].idle_right = %crusader_Tankride_guy4_leanright;
	positions[ 5 ].idle_right = %crusader_tankride_guy3_leanforward;
	positions[ 6 ].idle_right = %crusader_tankride_guy6_leanleft;
	positions[ 7 ].idle_right = %crusader_Tankride_guy4_leanleft;
	positions[ 8 ].idle_right = %crusader_Tankride_guy4_leanright;
	positions[ 9 ].idle_right = %crusader_Tankride_guy1_leanright;
	positions[ 10 ].idle_right = %crusader_Tankride_guy1_leanright;

	positions[ 0 ].idle_left = %crusader_tankride_guy0_leanleft;
	positions[ 1 ].idle_left = %crusader_Tankride_guy1_leanleft;
	positions[ 2 ].idle_left = %crusader_tankride_guy2_leanleft;
	positions[ 3 ].idle_left = %crusader_tankride_guy3_leanforward;
	positions[ 4 ].idle_left = %crusader_Tankride_guy4_leanleft;
	positions[ 5 ].idle_left = %crusader_tankride_guy3_leanback;
	positions[ 6 ].idle_left = %crusader_tankride_guy6_leanright;
	positions[ 7 ].idle_left = %crusader_tankride_guy3_leanback;
	positions[ 8 ].idle_left = %crusader_Tankride_guy4_leanleft;
	positions[ 9 ].idle_left = %crusader_Tankride_guy1_leanleft;
	positions[ 10 ].idle_left = %crusader_Tankride_guy1_leanleft;
	
	for( i=0;i<positions.size;i++ )
	{
		positions[ i ].idle_hardright = positions[ i ].idle_right;
		positions[ i ].idle_hardleft = positions[ i ].idle_left;
		positions[ i ].sittag = "tag_guy"+i;
		positions[ i ].idleoccurrence[ 0 ] = 1000;
		positions[ i ].idleoccurrence[ 1 ] = 200;
	}
*/
	return positions;
}

