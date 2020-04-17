#include maps\_utility;


main()
{
	initFXModelAnims();
	
	precacheFX();
	
	
	registerFXTargetName("fx_falling_debris");
	registerFXTargetName("fx_bats_tunnel1");
	registerFXTargetName("fx_bats_tunnel2");
	registerFXTargetName("fx_water_flow");
	registerFXTargetName("fx_wall_leak1");
	registerFXTargetName("fx_wall_leak2");
	registerFXTargetName("fx_wall_leak3");
	registerFXTargetName("fx_water_vortex");
	registerFXTargetName("fx_crate_smash");
	
	maps\createfx\siena_fx::main();
	
	
	
	
	
	level thread spawn_water_fx();
}

initFXModelAnims()
{
	ent2 = getent( "fxanim_tunnel_collapse_1", "targetname" );
	ent3 = getent( "fxanim_tunnel_collapse_2", "targetname" );
	ent4 = getent( "fxanim_column_fall", "targetname" );
	ent5 = getent( "fxanim_rock_fall_1", "targetname" );
	ent6 = getent( "fxanim_rock_fall_2", "targetname" );
	
	ent_array1 = getentarray( "fxanim_airport_fan", "script_noteworthy" );
	
	if (IsDefined(ent2)) { ent2 thread tunnel_collapse_1();   println("************* FX: tunnel_collapse_1 *************"); }
	if (IsDefined(ent3)) { ent3 thread tunnel_collapse_2();   println("************* FX: tunnel_collapse_2 *************"); }
	if (IsDefined(ent4)) { ent4 thread column_fall();   println("************* FX: column_fall *************"); }
	if (IsDefined(ent5)) { ent5 thread rock_fall_1();   println("************* FX: rock_fall_1 *************"); }
	if (IsDefined(ent6)) { ent6 thread rock_fall_2();   println("************* FX: rock_fall_2 *************"); }
	
	if( isdefined( ent_array1 ) )
				{
								
								ent_array1 thread fx_airport_fans();

								
								println( "************* fxanim_airport_fan ****************" );

								
								

				}
}

stagger_water_flow()
{
	level waittill("fx_water_flow");
	
	level notify("fx_water_flow1");
	wait(2);
	level notify("fx_water_flow2");
	wait(4);
	level notify("fx_water_flow3");
}

#using_animtree("fxanim_tunnel_collapse_1");
tunnel_collapse_1()
{
	level waittill("tunnel_collapse_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_tunnel_collapse_1", self.origin, self.angles, %fxanim_tunnel_collapse_1);
}

#using_animtree("fxanim_tunnel_collapse_2");
tunnel_collapse_2()
{
	level waittill("tunnel_collapse_2_start");
	self UseAnimTree(#animtree);
	self animscripted("a_tunnel_collapse_2", self.origin, self.angles, %fxanim_tunnel_collapse_2);
	
	
	level notify("fx_tunnel_dust");
}

#using_animtree("fxanim_column_fall");
column_fall()
{
	level waittill("column_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_column_fall", self.origin, self.angles, %fxanim_column_fall);
	
	
	if (animhasnotetrack(%fxanim_column_fall, "mid_section") && animhasnotetrack(%fxanim_column_fall, "water_hit_1") && animhasnotetrack(%fxanim_column_fall, "water_hit_2"))
	{
		
		c1 = GetEnt("collapse_geo_off_1","targetname");
		c1 hide();
		c2 = GetEnt("collapse_geo_off_2","targetname");
		c2 hide();
		c3 = GetEnt("collapse_geo_off_3","targetname");
		c3 hide();
		gate_c = GetEnt("gate_main01_col","targetname");
		gate = GetEnt("gate_main01","targetname");
		gate hide();
		gate_c hide();
	
		self waittillmatch("a_column_fall", "mid_section");
			level notify("fx_pillar_explosion");
			wait(.05);
			
			c1 delete();
		self waittillmatch("a_column_fall", "top_btm_section");
			wait(.1);
			
			c2 delete();
			
			c3 delete();
			
			
			
			
			
			
			
			gate delete();
			gate_c delete();

		self waittillmatch("a_column_fall", "water_hit_1");
			level notify("fx_brick_splashes");
			wait(1);
			level notify("fx_brick_dust");
		
		
	}
}

#using_animtree("fxanim_rock_fall_1");
rock_fall_1()
{
	level waittill("rock_fall_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rock_fall_1", self.origin, self.angles, %fxanim_rock_fall_1);
}

#using_animtree("fxanim_rock_fall_2");
rock_fall_2()
{
	level waittill("rock_fall_2_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rock_fall_2", self.origin, self.angles, %fxanim_rock_fall_2);
	
	if (animhasnotetrack(%fxanim_rock_fall_2, "rock_splash") && animhasnotetrack(%fxanim_rock_fall_2, "rock_splash"))
	{		
		for(i = 1; i < 17; i++)
		{
			self waittillmatch("a_rock_fall_2", "rock_splash");		
			if ( i < 10 )
				PlayFxOnTag( level._effect["siena_rocks_splash2"], self, ("rock_0"+i+"_jnt") );
			else
				PlayFxOnTag( level._effect["siena_rocks_splash2"], self, ("rock_"+i+"_jnt") );			
		}
	}
}

#using_animtree( "fxanim_airport_fan" );
fx_airport_fans()
{

				wait(.05);
				for( i=0; i<self.size; i++ )
				{
								self[i] UseAnimTree(#animtree);
								self[i] animscripted( "a_airport_fan", self[i].origin, self[i].angles, %fxanim_airport_fan );
				}

}
	
spawn_water_fx()
{
	
	
	all_water_fx_pos = [];
	all_water_fx_ang = [];
	all_water_markers = [];
	
	all_water_fx_pos[0]  = (-360.148,-626.952,-160.892); 
	all_water_fx_pos[1]  = (-2544.54,-747.215,-231.826);
	all_water_fx_pos[2]  = (-2001.29,-744.337,-231.515);	
	all_water_fx_pos[3]  = (-1729.23,-746.681,-227.342);
	all_water_fx_pos[4]  = (-1207.48,-745.129,-223.732);
	all_water_fx_pos[5]  = (-913.813,-747.822,-228.769);	
	all_water_fx_pos[6]  = (-386.667,-153.811,-225.0);
	all_water_fx_pos[7]  = (-382.678,-628.027,-225.0);
	all_water_fx_pos[8]  = (-2284.27,104.366,-225.25);
	all_water_fx_pos[9]  = (-1468.05,106.374,-227.744);
	all_water_fx_pos[10] = (-650.439,105.567,-226.875);
	all_water_fx_pos[11] = (-2010.71,103.683,-225.789);		
	all_water_fx_pos[12] = (-2294.44, 47.921,44.5879);
	all_water_fx_pos[13] = (-1745.93,51.1718,49.2278);
	all_water_fx_pos[14] = (-1203.89,56.5222,39.4588);
	all_water_fx_pos[15] = (-912.195,43.1484,44.4485);
	all_water_fx_pos[16] = (-391.559, 52.555,44.8521);
	all_water_fx_pos[17] = (-2544.72,-835.779,40.5918);
	all_water_fx_pos[18] = (-1998.39,-830.458,42.3106);
	all_water_fx_pos[19] = (-1726.45,-840.595, 46.924);
	all_water_fx_pos[20] = (-1207.87,-843.321,54.9665);
	all_water_fx_pos[21] = (-911.997,-837.508,47.9369);
	all_water_fx_pos[22] = (-388.799,-841.760,52.7056);
	all_water_fx_pos[23] = (-2292.56, -50.086,-225.0);
	all_water_fx_pos[24] = (-1744.49,-38.8485,-225.0); 
	all_water_fx_pos[25] = (-1204.93,-51.4695,-225.0);
	all_water_fx_pos[26] = (-914.266,-44.8712,-225.0);
	all_water_fx_pos[27] = (-393.768,-32.4678,-225.0);
	all_water_fx_pos[28] = (-2546.13,-741.429,-225.0);
	all_water_fx_pos[29] = (-1999.26,-740.539,-225.0);
	all_water_fx_pos[30] = (-1723.65,-755.621,-225.0);
	all_water_fx_pos[31] = (-1210.39,-760.522,-225.0);
	all_water_fx_pos[32] = (-915.866,-747.679,-225.0);
	all_water_fx_pos[33] = (-393.254,-754.734,-225.0);
	
	all_water_fx_pos[34] = (-1089.78,-218.594,-210.0);
	all_water_fx_pos[35] = (-1084.73, -560.64,-210.0);
	all_water_fx_pos[36] = (-1360.57,-505.657,-210.0);
	all_water_fx_pos[37] = (-1360.88,-243.462,-210.0);
	all_water_fx_pos[38] = (-1254.19,-511.107,-210.0);
	all_water_fx_pos[39] = (-1660.76,-429.944,-210.0);
	all_water_fx_pos[40] = (-1700.67,-332.05, -210.0);

	for(i = 0; i < all_water_fx_pos.size; i++)
		all_water_fx_ang[i] = (270,0,0); 
		
	all_water_fx_ang[7]  = (270,320.146, 39.8537);
	all_water_fx_ang[12] = (270,87.0964,0.903661);
	all_water_fx_ang[13] = (270,87.0964,0.903661);
	all_water_fx_ang[14] = (270,87.0964,0.903661);
	all_water_fx_ang[15] = (270,87.0964,0.903661);
	all_water_fx_ang[16] = (270,87.0964,0.903661);
	all_water_fx_ang[17] = (270,281.289,-9.28886);
	all_water_fx_ang[18] = (270,283.726,-15.7254);
	all_water_fx_ang[19] = (270,283.726,-15.7254);
	all_water_fx_ang[20] = (270,283.726,-15.7254);
	all_water_fx_ang[21] = (270,283.726,-15.7254);
	all_water_fx_ang[22] = (270,283.726,-15.7254);
	all_water_fx_ang[28] = (270,243.404,-59.4035);
	all_water_fx_ang[29] = (270,243.404,-59.4035);
	all_water_fx_ang[30] = (270,243.404,-59.4035);
	all_water_fx_ang[31] = (270,243.404,-59.4035);
	all_water_fx_ang[32] = (270,243.404,-59.4035);
	all_water_fx_ang[33] = (270,243.404,-59.4035);
	
	all_water_fx_ang[34] = (270,318.384,-46.3838);  	
	all_water_fx_ang[35] = (270,318.384,-46.3838);   	
	all_water_fx_ang[36] = (270,318.384,-46.3838);
	all_water_fx_ang[37] = (270,318.384,-46.3838);   	
	all_water_fx_ang[38] = (270, 50.137,-50.1367);   	
	all_water_fx_ang[39] = (270,296.394,-60.3939);   	
	all_water_fx_ang[40] = (270,345.253,-69.2526);	

	
	
	for(i = 0; i < all_water_fx_pos.size; i++)
	{
		ent_tag = Spawn("script_model", all_water_fx_pos[i]);
		ent_tag SetModel("tag_origin");
		ent_tag.angles = (all_water_fx_ang[i]);
		all_water_markers[i] = ent_tag; 
	}
	
	for(i = 1; i < 12; i++) 
		PlayFxOnTag(level._effect["siena_statue_splash"], all_water_markers[i], "tag_origin");	
	
	level thread play_water_flow(all_water_markers[12], all_water_markers[23], "fx_water_flow1"); 
	level thread play_water_flow(all_water_markers[13], all_water_markers[24], "fx_water_flow2");
	level thread play_water_flow(all_water_markers[14], all_water_markers[25], "fx_water_flow3");
	level thread play_water_flow(all_water_markers[19], all_water_markers[30], "fx_water_flow4"); 
	level thread play_water_flow(all_water_markers[18], all_water_markers[29], "fx_water_flow5");
	level thread play_water_flow(all_water_markers[17], all_water_markers[28], "fx_water_flow6");

	level waittill("fx_water_rise");	
	
	level thread move_these_fx_ents(all_water_markers,1,12,25,20);
	level thread move_these_fx_ents(all_water_markers,23,33,25,20);	
	
	level waittill("fx_water_lower");	
	
	for(i = 34; i < all_water_markers.size; i++) 
		PlayFxOnTag(level._effect["siena_water_foam2"], all_water_markers[i], "tag_origin");	
	
	level thread move_these_fx_ents(all_water_markers,1,12,-25,20); 
	level thread move_these_fx_ents(all_water_markers,34,all_water_markers.size,-25,20); 
}


play_water_flow(water_marker, splash_marker, notifyID)
{
	level notify("fx_water_rise");
	level waittill(notifyID);
	PlayFxOnTag(level._effect["siena_water_flow_start1"], water_marker, "tag_origin");
	PlayFxOnTag(level._effect["siena_water_splash1"], splash_marker, "tag_origin");
}

move_these_fx_ents(array, start_id, end_id, distance, time)
{
	for(i = start_id; i < end_id; i++)
		array[i] movez(distance,time);
}

precacheFX()
{


	level._effect["siena_tunnel_fog1"] 			= loadfx ( "maps/siena/siena_tunnel_fog1" );
	level._effect["siena_tunnel_fog2"] 			= loadfx ( "maps/siena/siena_tunnel_fog2" );
	level._effect["siena_tunnel_fog3"] 			= loadfx ( "maps/siena/siena_tunnel_fog3" );
	level._effect["siena_tunnel_fog4"] 			= loadfx ( "maps/siena/siena_tunnel_fog4" );

	level._effect["siena_falling_d1"] 			= loadfx ( "maps/siena/siena_falling_d1" );
	level._effect["siena_falling_d_runner1"] 	= loadfx ( "maps/siena/siena_falling_d_runner1" );
	level._effect["siena_falling_d_runner2"] 	= loadfx ( "maps/siena/siena_falling_d_runner2" );
	level._effect["siena_falling_d_runner3"] 	= loadfx ( "maps/siena/siena_falling_d_runner3" );
	level._effect["siena_collapse1"]	 		= loadfx ( "maps/siena/siena_collapse1");
	level._effect["siena_collapse2"]	 		= loadfx ( "maps/siena/siena_collapse2");
	level._effect["siena_collapse2_r"]	 		= loadfx ( "maps/siena/siena_collapse2_r");
	
	level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
	level._effect["siena_dripping02"]	 		= loadfx ( "maps/siena/siena_dripping02");
	level._effect["siena_water_flow_start1"]	= loadfx ( "maps/siena/siena_water_flow_start1");
	level._effect["siena_water_flow1"]	 		= loadfx ( "maps/siena/siena_water_flow1");
	level._effect["siena_water_flow2"]	 		= loadfx ( "maps/siena/siena_water_flow2");
	level._effect["siena_water_splash1"]	 	= loadfx ( "maps/siena/siena_water_splash1");
	level._effect["siena_water_splash2"]	 	= loadfx ( "maps/siena/siena_water_splash2");
	level._effect["siena_statue_water1"]	 	= loadfx ( "maps/siena/siena_statue_water1");	
	level._effect["siena_statue_splash"]	 	= loadfx ( "maps/siena/siena_statue_splash");
	level._effect["siena_bats1"]	 			= loadfx ( "maps/siena/siena_bats_front1");
	level._effect["siena_bats2"]	 			= loadfx ( "maps/siena/siena_bats_front2");
	level._effect["siena_water_foam1"]	 		= loadfx ( "maps/siena/siena_water_foam1");
	level._effect["siena_water_foam2"]	 		= loadfx ( "maps/siena/siena_water_foam2");
	level._effect["siena_water_foam3"]	 		= loadfx ( "maps/siena/siena_water_foam3");
	level._effect["siena_fountain_splash"]	 	= loadfx ( "maps/siena/siena_fountain_splash");
	level._effect["siena_wall_spray1"]	 		= loadfx ( "maps/siena/siena_wall_spray1");
	level._effect["siena_wall_spray2"]	 		= loadfx ( "maps/siena/siena_wall_spray2");

	level._effect["siena_water_vortex1"]	 	= loadfx ( "maps/siena/siena_water_vortex1");
	level._effect["siena_water_vortex2"]	 	= loadfx ( "maps/siena/siena_water_vortex2");
	

	level._effect["siena_pillar_splash"]	 	= loadfx ( "maps/siena/siena_pillar_wave_runner");

	level._effect["siena_pillar_aftermath2"]	= loadfx ( "maps/siena/siena_pillar_aftermath2");
	level._effect["siena_pillar_explosion1"]	= loadfx ( "maps/siena/siena_pillar_explosion1");
	level._effect["siena_brick_splashes"]		= loadfx ( "maps/siena/siena_brick_splashes");
	level._effect["siena_brick_dust"]			= loadfx ( "maps/siena/siena_brick_dust");
	level._effect["generator_exp"]				= loadfx ( "props/generator_exp");	
	
	level._effect["siena_lamp_sparks"]	 		= loadfx ( "maps/siena/siena_lamp_sparks");
	level._effect["siena_crate_smash"]	 		= loadfx ( "maps/siena/siena_crate_smash");
	level._effect["siena_rocks_splash2"]	 	= loadfx ( "maps/siena/siena_rocks_splash2");
	
	

	level._effect["siena_intro_drip"]	 		= loadfx ( "maps/siena/siena_intro_drip");
	level._effect["siena_bond_splash"]	 		= loadfx ( "maps/siena/siena_bond_splash");		
}
