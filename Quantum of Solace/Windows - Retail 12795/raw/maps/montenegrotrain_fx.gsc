// Montenegro Train fx
// Builder: Don Sielke
// Scripter: Don Sielke
///////////////////////////////////////////////////////////////////////////////////////////
#include maps\_utility;
///////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// adding the _weather include
#include maps\_weather;
///////////////////////////////////////////////////////////////////////////////////////////
main()
{
				thread initFXModelAnims();

				precache_FX();

				maps\createfx\MontenegroTrain_fx::main();

				//turning on the quick kill effects
				level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
				wait(1);
				ent1 = getent( "fxanim_cargo_straps", "script_noteworthy" );
				ent2 = getent( "fxanim_jump_break", "script_noteworthy" );
				ent3 = getent( "fxanim_knuckle_release_1", "script_noteworthy" );
				ent4 = getent( "fxanim_knuckle_release_2", "script_noteworthy" );
				ent5 = getent( "fxanim_knuckle_break_1", "script_noteworthy" );
				ent6 = getent( "fxanim_knuckle_break_2", "script_noteworthy" );
				ent17 = getent( "fxanim_box_fall", "script_noteworthy" );
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// these things will be multiples across the level
				// need to call arrays on them
				ent7 = getentarray( "fxanim_chain_arch_1", "script_noteworthy" );
				ent20 = getentarray( "fxanim_chain_arch_2", "script_noteworthy" );
				ent8 = getentarray( "fxanim_chain_short", "script_noteworthy" );
				ent9 = getentarray( "fxanim_streamer_4_1", "script_noteworthy" );
				ent18 = getentarray( "fxanim_streamer_4_2", "script_noteworthy" );
				ent10 = getentarray( "fxanim_streamer_5_1", "script_noteworthy" );
				ent19 = getentarray( "fxanim_streamer_5_2", "script_noteworthy" );
				ent11 = getentarray( "fxanim_old_wheels", "script_noteworthy" );
				ent12 = getentarray( "fxanim_luggage_net", "script_noteworthy" );
				ent13 = getentarray( "fxanim_rope_arch", "script_noteworthy" );
				ent14 = getentarray( "fxanim_rope_short", "script_noteworthy" );
				ent15 = getentarray( "fxanim_chain_long", "script_noteworthy" );
				ent16 = getentarray( "fxanim_rope_long", "script_noteworthy" );
				//////////////////////////////////////////////////////////////////////////
				ent_array1 = getentarray( "fxanim_knuckle_rattle_1", "script_noteworthy" );
				ent_array2 = getentarray( "fxanim_knuckle_rattle_2", "script_noteworthy" );
				ent_array3 = getentarray( "fxanim_knuckle_rattle_3", "script_noteworthy" );

				if (IsDefined(ent1)) { ent1 thread cargo_straps();   println("************* FX: cargo_straps *************"); }
				if (IsDefined(ent2)) { ent2 thread jump_break();   println("************* FX: jump_break *************"); }
				if (IsDefined(ent17)) { ent17 thread box_fall();   println("************* FX: box_fall *************"); }

				if ( IsDefined(ent3) && IsDefined(ent4) ) 
				{ 
								ent3 thread knuckle_release_1_rattle();
								ent3 thread knuckle_release_1_release();
								ent4 thread knuckle_release_2_rattle();
								ent4 thread knuckle_release_2_release();
				}

				if ( IsDefined(ent5) && IsDefined(ent6) ) 
				{ 
								ent5 thread knuckle_break_1_rattle();
								ent5 thread knuckle_break_1_break();
								ent6 thread knuckle_break_2_rattle();
								ent6 thread knuckle_break_2_break();
				}

				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// changing these into for loops
				// so the function runs on each ent individually
				// sorry for changing th format, just using what I'm comfortable with
				//////////////////////////////////////////////////////////////////////////
				// chain arch_1
				if( IsDefined( ent7 ) ) 
				{ 
								// start a for loop to go through each array spot
								for( i=0; i<ent7.size; i++ )
								{
												// thread the function on the container spot
												ent7[i] thread chain_arch_1();
												println("************* FX: chain_arch_1 *************"); 
												wait( 0.05 );
								}

				}
				
				// chain arch_2
				if( IsDefined( ent20 ) ) 
				{ 
								// start a for loop to go through each array spot
								for( i=0; i<ent20.size; i++ )
								{
												// thread the function on the container spot
												ent20[i] thread chain_arch_2();
												println("************* FX: chain_arch_2 *************"); 
												wait( 0.05 );
								}

				}
				// chain short
				if( IsDefined( ent8 ) ) 
				{
								// for loop goes through each spot
								for( i=0; i<ent8.size; i++ )
								{
												// thread the function on the ent
												ent8[i] thread chain_short();   
												//debug text
												println("************* FX: chain_short *************"); 
												// no wait unless needed
												// 05-19-08
												// monkey is complaining about potential infinites
												wait( 0.05 );
								}

				}
				// streamer 4_1
				if( IsDefined( ent9 ) ) 
				{ 
								// for loop goes through each spot
								for( i=0; i<ent9.size; i++ )
								{
												// thread the function on the ent
												ent9[i] thread streamer_4_1();
												println("************* FX: streamer_4_1 *************");
												wait( 0.05 );
								}

				}
				
				// streamer 4_2
				if( IsDefined( ent18 ) ) 
				{ 
								// for loop goes through each spot
								for( i=0; i<ent18.size; i++ )
								{
												// thread the function on the ent
												ent18[i] thread streamer_4_2();
												println("************* FX: streamer_4_2 *************");
												wait( 0.05 );
								}

				}
				// streamer 5_1
				if( IsDefined( ent10 ) ) 
				{ 
								// for loop goes through each spot
								for( i=0; i<ent10.size; i++ )
								{
												// thread the function on each ent
												ent10[i] thread streamer_5_1();
												println("************* FX: streamer_5_1 *************"); 
												wait( 0.05 );
								}

				}
				
				// streamer 5_2
				if( IsDefined( ent19 ) ) 
				{ 
								// for loop goes through each spot
								for( i=0; i<ent19.size; i++ )
								{
												// thread the function on each ent
												ent19[i] thread streamer_5_2();
												println("************* FX: streamer_5_2 *************"); 
												wait( 0.05 );
								}

				}
				// old wheels
				if( IsDefined( ent11 ) ) 
				{ 
								// for loop goes through each spot
								for( i=0; i<ent11.size; i++ )
								{
												// thread the function on each ent
												ent11[i] thread old_wheels();   
												// debug text
												println("************* FX: old_wheels *************"); 
												// no wait unless needed
												// 05-19-08
												// monkey is complaining about potential infinites
												wait( 0.05 );
								}

				}

				// luggage_net
				if( IsDefined( ent12 ) ) 
				{ 
								// start a for loop to go through each array spot
								for( i=0; i<ent12.size; i++ )
								{
												// thread the function on the container spot
												ent12[i] thread luggage_net();   
												// debug text
												println("************* FX: luggage_net *************"); 
												// no wait unless needed
												// 05-19-08
												// monkey is complaining about potential infinites
												wait( 0.05 );
								}

				}

				// rope_arch
				if( IsDefined( ent13 ) ) 
				{ 
								// start a for loop to go through each array spot
								for( i=0; i<ent13.size; i++ )
								{
												// thread the function on the container spot
												ent13[i] thread rope_arch();   
												// debug text
												println("************* FX: rope_arch *************"); 
												// no wait unless needed
												// 05-19-08
												// monkey is complaining about potential infinites
												wait( 0.05 );
								}

				}

				// rope_short
				if( IsDefined( ent14 ) ) 
				{ 
								// start a for loop to go through each array spot
								for( i=0; i<ent14.size; i++ )
								{
												// thread the function on the container spot
												ent14[i] thread rope_short();   
												// debug text
												println("************* FX: rope_short *************"); 
												// no wait unless needed
												// 05-19-08
												// monkey is complaining about potential infinites
												wait( 0.05 );
								}

				}

				// chain long
				if( IsDefined( ent15 ) ) 
				{
								for( i=0; i<ent15.size; i++ )
								{
												ent15[i] thread chain_long();
												println("************* FX: chain_long *************");
												wait( 0.05 );
								}

				}

				// rope long
				if( IsDefined( ent16 ) ) 
				{
								for( i=0; i<ent16.size; i++ )
								{
												ent16[i] thread rope_long();
												println("************* FX: rope_long *************");
												wait( 0.05 );
								}

				}
				//////////////////////////////////////////////////////////////////////////

				if (IsDefined(ent_array1)) { ent_array1 thread knuckle_rattle_1();   println("************* FX: knuckle_rattle_1 *************"); }
				if (IsDefined(ent_array2)) { ent_array2 thread knuckle_rattle_2();   println("************* FX: knuckle_rattle_2 *************"); }
				if (IsDefined(ent_array3)) { ent_array3 thread knuckle_rattle_3();   println("************* FX: knuckle_rattle_3 *************"); }

				level initTrainAnim();
}

//I should move these into an effects utility script file
loopTag_Effect( animName, noteID, effectID, bone, playCount, offset, angle)
{	
	if ( playCount != -1 )
	{
		while(playCount > 0)
		{
			self waittillmatch(animName, noteID);
			self link_effect_to_ent( effectID, bone, offset, angle, 0.75 );
			playCount--;
		}
	}
	else
	{
	//println( "##################### FX: Waiting for looping note... #####################" );
		while(1)
		{
			self waittillmatch(animName, noteID);
			self link_effect_to_ent( effectID, bone, offset, angle, 0.75 );
			//println( "##################### FX: --looping note-- #####################" );
		}
	}
	//print( "#####################  FX: loopTag_Effect: " );
	//print( noteID );
	//println( " STOP! #####################" );
}

link_effect_to_ent( effectID, bone, offset, angle, kill_delay )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, (-45,0,0) );

	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
	wait(kill_delay);
	ent_tag delete();
}

initTrainAnim()
{
				level waittill("train_anim_start");

				//level notify("cargo_straps_start"); // start_fxgroup_1
				//level notify("knuckle_rattle_start"); // start_fx_group_1_3_4
				level notify("knuckle_release_rattle_start");
				level notify("knuckle_break_rattle_start");
				//level notify("chain_arch_start"); // start_fxgroup_2
				//level notify("chain_short_start"); // start_fxgroup_2
				//level notify("chain_long_start");  // start_fxgroup_2
				//level notify("streamer_4_start");  //start_fxgroup_1_3
				//level notify("streamer_5_start");  //start_fxgroup_1_3
			    //level notify("old_wheels_start");  // DO NOT TRIGGER
				//level notify("luggage_net_start"); // start_fxgroup_5
				//level notify("rope_arch_start"); // start_fxgroup_4
				//level notify("rope_short_start"); // start_fxgroup_4
				//level notify("rope_long_start"); // start_fxgroup_4

}

#using_animtree("fxanim_cargo_straps");
cargo_straps()
{
				level waittill("start_fxgroup_1");
				self UseAnimTree(#animtree);
				self animscripted("a_cargo_straps", self.origin, self.angles, %fxanim_cargo_straps);
				
				level waittill("delete_fxgroup_1");
				self delete();
}

#using_animtree("fxanim_knuckle_rattle");
knuckle_rattle_1()
{
				level waittill("start_fxgroup_1");
				for (i=0; i<self.size; i++)
				{
								self[i] UseAnimTree(#animtree);
								self[i] animscripted("a_knuckle_rattle", self[i].origin, self[i].angles, %fxanim_knuckle_rattle);
				}
				
				level waittill("delete_fxgroup_1");
				for (i=0; i<self.size; i++)
				{
								self[i] delete();
				}
}

#using_animtree("fxanim_knuckle_rattle");
knuckle_rattle_2()
{
				level waittill("start_fxgroup_3");
				for (i=0; i<self.size; i++)
				{
								self[i] UseAnimTree(#animtree);
								self[i] animscripted("a_knuckle_rattle", self[i].origin, self[i].angles, %fxanim_knuckle_rattle);
				}
				
				level waittill("delete_fxgroup_3");
				for (i=0; i<self.size; i++)
				{
								self[i] delete();
				}
}

#using_animtree("fxanim_knuckle_rattle");
knuckle_rattle_3()
{
				level waittill("start_fxgroup_4");
				for (i=0; i<self.size; i++)
				{
								self[i] UseAnimTree(#animtree);
								self[i] animscripted("a_knuckle_rattle", self[i].origin, self[i].angles, %fxanim_knuckle_rattle);
				}
				
				level waittill("delete_fxgroup_4");
				for (i=0; i<self.size; i++)
				{
								self[i] delete();
				}
}

#using_animtree("fxanim_jump_break");
jump_break()
{
				level waittill("jump_break_start");
				self UseAnimTree(#animtree);
				self animscripted("a_jump_break", self.origin, self.angles, %fxanim_jump_break);

				//play an effect on a notetrack (if one is found)	
				if (animhasnotetrack(%fxanim_jump_break, "flap_spark_big") && animhasnotetrack(%fxanim_jump_break, "flap_spark_small"))
				{
								//println( "##################### FX: Waiting for notes, jump_break #####################" );
								self thread loopTag_Effect("a_jump_break", "flap_spark_big", "train_metal_sparks_pop", "flap_1_jnt", 4, (-18, 54, 0), (-45,0,0));
								self thread loopTag_Effect("a_jump_break", "flap_spark_small", "train_metal_sparks_scrape", "flap_1_jnt", 9, (-18, 54, 0), (-45,0,0));		
				}	

				wait(5.84);
				jump_break_flap();
}

#using_animtree("fxanim_jump_break_flap");
jump_break_flap()
{
				self UseAnimTree(#animtree);
				self animscripted("a_jump_break_flap", self.origin, self.angles, %fxanim_jump_break_flap);

				if (animhasnotetrack(%fxanim_jump_break_flap, "flap_spark_big") && animhasnotetrack(%fxanim_jump_break_flap, "flap_spark_small"))
				{
								//println( "##################### FX: Waiting for notes, jump_break_flap #####################" );
								self thread loopTag_Effect("a_jump_break_flap", "flap_spark_big", "train_metal_sparks_pop", "flap_1_jnt", -1, (-18, 54, 0), (-45,0,0));
								self thread loopTag_Effect("a_jump_break_flap", "flap_spark_small", "train_metal_sparks_scrape", "flap_1_jnt", -1, (-18, 54, 0), (-45,0,0));		
				}	
}

#using_animtree("fxanim_knuckle_release_1_rattle");
knuckle_release_1_rattle()
{
				level waittill("knuckle_release_rattle_start");
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_release_1_rattle", self.origin, self.angles, %fxanim_knuckle_release_1_rattle);
}

#using_animtree("fxanim_knuckle_release_1_release");
knuckle_release_1_release()
{
				level waittill("knuckle_release_release_start");
				self StopAnimScripted();
				self StopUseAnimTree();
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_release_1_release", self.origin, self.angles, %fxanim_knuckle_release_1_release);
}

#using_animtree("fxanim_knuckle_release_2_rattle");
knuckle_release_2_rattle()
{
				level waittill("knuckle_release_rattle_start");
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_release_2_rattle", self.origin, self.angles, %fxanim_knuckle_release_2_rattle);
}

#using_animtree("fxanim_knuckle_release_2_release");
knuckle_release_2_release()
{
				level waittill("knuckle_release_release_start");
				self StopAnimScripted();
				self StopUseAnimTree();
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_release_2_release", self.origin, self.angles, %fxanim_knuckle_release_2_release);
}

#using_animtree("fxanim_knuckle_break_1_rattle");
knuckle_break_1_rattle()
{
				level waittill("knuckle_break_rattle_start");
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_break_1_rattle", self.origin, self.angles, %fxanim_knuckle_break_1_rattle);
}

#using_animtree("fxanim_knuckle_break_1_break");
knuckle_break_1_break()
{
				level waittill("knuckle_break_break_start");
				self StopAnimScripted();
				self StopUseAnimTree();
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_break_1_break", self.origin, self.angles, %fxanim_knuckle_break_1_break);
}

#using_animtree("fxanim_knuckle_break_2_rattle");
knuckle_break_2_rattle()
{
				level waittill("knuckle_break_rattle_start");
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_break_2_rattle", self.origin, self.angles, %fxanim_knuckle_break_2_rattle);
}

#using_animtree("fxanim_knuckle_break_2_break");
knuckle_break_2_break()
{
				level waittill("knuckle_break_break_start");
				self StopAnimScripted();
				self StopUseAnimTree();
				self UseAnimTree(#animtree);
				self animscripted("a_knuckle_break_2_break", self.origin, self.angles, %fxanim_knuckle_break_2_break);
}

#using_animtree("fxanim_chain_arch");
chain_arch_1()
{
				level waittill("start_fxgroup_2");
				self UseAnimTree(#animtree);
				self animscripted("a_chain_arch", self.origin, self.angles, %fxanim_chain_arch);
				
				level waittill("delete_fxgroup_2");
				self delete();
				
}

#using_animtree("fxanim_chain_arch");
chain_arch_2()
{
				level waittill("start_fxgroup_4");
				self UseAnimTree(#animtree);
				self animscripted("a_chain_arch", self.origin, self.angles, %fxanim_chain_arch);
				
				level waittill("delete_fxgroup_4");
				self delete();
}

#using_animtree("fxanim_chain_short");
chain_short()
{
				level waittill("start_fxgroup_2");
				self UseAnimTree(#animtree);
				self animscripted("a_chain_short", self.origin, self.angles, %fxanim_chain_short);
				
				level waittill("delete_fxgroup_2");
				self delete();
}

#using_animtree("fxanim_streamer_4");
streamer_4_1()
{
				level waittill("start_fxgroup_1");
				self UseAnimTree(#animtree);
				self animscripted("a_streamer_4", self.origin, self.angles, %fxanim_streamer_4);
				
				level waittill("delete_fxgroup_1");
				self delete();
}

#using_animtree("fxanim_streamer_4");
streamer_4_2()
{
				level waittill("start_fxgroup_3");
				self UseAnimTree(#animtree);
				self animscripted("a_streamer_4", self.origin, self.angles, %fxanim_streamer_4);
				
				level waittill("delete_fxgroup_3");
				self delete();
}

#using_animtree("fxanim_streamer_5");
streamer_5_1()
{
				level waittill("start_fxgroup_1");
				self UseAnimTree(#animtree);
				self animscripted("a_streamer_5", self.origin, self.angles, %fxanim_streamer_5);
				
				level waittill("delete_fxgroup_1");
				self delete();
}

#using_animtree("fxanim_streamer_5");
streamer_5_2()
{
				level waittill("start_fxgroup_3");
				self UseAnimTree(#animtree);
				self animscripted("a_streamer_5", self.origin, self.angles, %fxanim_streamer_5);
				
				level waittill("delete_fxgroup_3");
				self delete();
}

#using_animtree("fxanim_old_wheels");
old_wheels()
{
				level waittill("old_wheels_start");
				self UseAnimTree(#animtree);
				self animscripted("a_old_wheels", self.origin, self.angles, %fxanim_old_wheels);
}

#using_animtree("fxanim_luggage_net");
luggage_net()
{
				level waittill("start_fxgroup_5");
				self UseAnimTree(#animtree);
				self animscripted("a_luggage_net", self.origin, self.angles, %fxanim_luggage_net);
				
				level waittill("delete_fxgroup_5");
				self delete();
}

#using_animtree("fxanim_rope_arch");
rope_arch()
{
				level waittill("start_fxgroup_4");
				self UseAnimTree(#animtree);
				self animscripted("a_rope_arch", self.origin, self.angles, %fxanim_rope_arch);
				
				level waittill("delete_fxgroup_4");
				self delete();
}

#using_animtree("fxanim_rope_short");
rope_short()
{
				level waittill("start_fxgroup_4");
				self UseAnimTree(#animtree);
				self animscripted("a_rope_short", self.origin, self.angles, %fxanim_rope_short);
				
				level waittill("delete_fxgroup_4");
				self delete();
}

#using_animtree("fxanim_rope_long");
rope_long()
{
				level waittill("start_fxgroup_4");
				self UseAnimTree(#animtree);
				self animscripted("a_rope_long", self.origin, self.angles, %fxanim_rope_long);
				
				level waittill("delete_fxgroup_4");
				self delete();
}

#using_animtree("fxanim_chain_long");
chain_long()
{
				level waittill("start_fxgroup_2");
				self UseAnimTree(#animtree);
				self animscripted("a_chain_long", self.origin, self.angles, %fxanim_chain_long);
				
				level waittill("delete_fxgroup_2");
				self delete();
}

#using_animtree("fxanim_box_fall");
box_fall()
{
				level waittill("box_fall_start");
				self UseAnimTree(#animtree);
				self animscripted("a_box_fall", self.origin, self.angles, %fxanim_box_fall);
}


//////////////////////////////////////////////////////////////////////////////////////////
//	FX_precache.
//////////////////////////////////////////////////////////////////////////////////////////
precache_FX()
{
				level._effect["fx_metalhit_lg"]		= loadfx ("impacts/large_metalhit");
				level._effect["bullet_pierce"] = loadfx ( "maps/Casino/casino_vent_bullet_vol" );
				level._effect["container_dust"] = loadfx( "maps/MontenegroTrain/train_smoke_cloud" );
				level._effect["fx_glass_break"]		= loadfx ("breakables/science_glass_shatter01");
				level._effect["flash"] = loadfx ( "weapons/MP/flashbang");
				level._effect["spark"] = Loadfx( "misc/camera_sparks" );
				level._effect["welding_sparks"] 	= loadfx ( "maps/constructionsite/const_workerFX3" );
				level._effect["powerwire_sparks"] 	= loadfx ( "maps/montenegrotrain/train_wire_sparks_runner" );
				level._effect["light_blinking_red"] = loadfx ( "misc/light_blinking_red" );
				level._effect["light_blinking_green"] = loadfx ( "misc/light_blinking_green" );
				level._effect["light_blinking_blue"] = loadfx ( "misc/light_blinking_blue" );
				level._effect["light_blinking_yellow"] = loadfx ( "misc/light_blinking_yellow" );
				level._effect["airport_emergency_light"] = loadfx ( "maps/miamiairport/airport_emergency_light" );
				level._effect["airport_vol_light01"] = loadfx ( "maps/miamiairport/airport_vol_light01" );
				level._effect["airport_vol_light02"] = loadfx ( "maps/miamiairport/airport_vol_light02" );
				level._effect["airport_vol_light03"] = loadfx ( "maps/miamiairport/airport_vol_light03" );
				level._effect["airport_vol_light04"] = loadfx ( "maps/miamiairport/airport_vol_light04" );
				level._effect["airport_vol_light05"] = loadfx ( "maps/miamiairport/airport_vol_light05" );

				//animation effects
				level._effect["train_metal_sparks_pop"] 	= loadfx ( "maps/montenegrotrain/train_metal_sparks_pop" );
				level._effect["train_metal_sparks_scrape"] 	= loadfx ( "maps/montenegrotrain/train_metal_sparks_scrape" );


				

				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// adding the precache for the rain and lightning effects
				// rain
				// 04-17-08
				// commenting out all this extra rain for now
				/*	level._effect["rain_heavy_cloudtype"]	= loadfx ("weather/rain_heavy_cloudtype");
				level._effect["rain_10"]		= loadfx ("weather/rain_heavy_mist");
				level._effect["rain_9"]			= loadfx ("weather/rain_9");
				level._effect["rain_8"]			= loadfx ("weather/rain_9");
				level._effect["rain_7"]			= loadfx ("weather/rain_9");
				level._effect["rain_6"]			= loadfx ("weather/rain_9");
				level._effect["rain_5"]			= loadfx ("weather/rain_9");
				level._effect["rain_4"]			= loadfx ("weather/rain_9");
				level._effect["rain_3"]			= loadfx ("weather/rain_9");
				level._effect["rain_2"]			= loadfx ("weather/rain_9");
				level._effect["rain_1"]			= loadfx ("weather/rain_9");	
				level._effect["rain_0"]			= loadfx ("weather/rain_0");
				*/

				// lightning
				//	level._effect["lightning"]				= loadfx ("weather/lightning");
				//	level._effect["lightning_bolt"]			= loadfx ("weather/lightning_bolt");
				//	level._effect["lightning_bolt_lrg"]		= loadfx ("weather/lightning_bolt_lrg");
				level._effect["lightning"]		= loadfx ("weather/lightning_runner");
				//	level._effect["testadd"]		= loadfx ("weather/addtest");
				//level._effect["rain9"] = loadfx("weather/rain_runner_angle");
				//level._effect["rain_bg"] = loadfx("weather/rain_bg_angle");
				level._effect["rain_bg"] = loadfx("weather/rain_bg_angle");
				level._effect["rain_mid"] = loadfx("weather/rain_mid_angle");
				level._effect["rain_9"] = loadfx("weather/rain_9_angle");
				level._effect["rain_far"] = loadfx("weather/rain_far_angle");
				// 08-14-08 WWilliams
				// including the rain for the cutscene
				level._effect["rain_9_cutscene"] = loadfx( "weather/rain_9_train_cutscene" );

				/*	
				ent_tag = undefined;
				ent_tag = Spawn("script_model", (0,0,0));
				ent_tag SetModel("tag_origin");
				ent_tag.angles = (90,0,0);

				PlayFxOnTag(level._effect["lightning"], ent_tag, "tag_origin");
				ent_tag.pos = (0,0,0);	

				*/		

				// 04-17-08
				// wwilliams
				// setting up the exploders for lightning?
				// copied this from _cargoship
				//	addLightningExploder(10); // these exploders make lightning flashes in the sky
				//	addLightningExploder(11);
				//	addLightningExploder(12);
				// this sets up the random lightning I believe
				//	level.nextLightning = gettime() + 1;//10000 + randomfloat(4000); // sets when the first lightning of the level will go off
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				// stupid fog...
				setExpFog(0,100000,0,0,0,0);

}	


