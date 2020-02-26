



#include maps\_utility;




#include maps\_weather;

main()
{
	thread initFXModelAnims();
	
	precache_FX();
	
	maps\createfx\MontenegroTrain_fx::main();
	
	
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
	wait(1);
	
	ent2 = getent( "fxanim_jump_break", "script_noteworthy" );
	ent3 = getent( "fxanim_knuckle_release_1", "script_noteworthy" );
	ent4 = getent( "fxanim_knuckle_release_2", "script_noteworthy" );
	ent5 = getent( "fxanim_knuckle_break_1", "script_noteworthy" );
	ent6 = getent( "fxanim_knuckle_break_2", "script_noteworthy" );
	ent17 = getent( "fxanim_box_fall", "script_noteworthy" );
	
	
	
	
	
	
	
	
	
	ent11 = getentarray( "fxanim_old_wheels", "script_noteworthy" );
	
	
	
	
	
	
	ent_array1 = getentarray( "fxanim_knuckle_rattle", "script_noteworthy" );
	
	
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	if( IsDefined( ent11 ) ) 
	{ 
		
		for( i=0; i<ent11.size; i++ )
		{
			
			ent11[i] thread old_wheels();   
			
			println("************* FX: old_wheels *************"); 
			
			
			
			wait( 0.05 );
		}

	}
	
	
	
	

	if (IsDefined(ent_array1)) { ent_array1 thread knuckle_rattle();   println("************* FX: knuckle_rattle *************"); }
	
	level initTrainAnim();
}


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
		
		while(1)
		{
			self waittillmatch(animName, noteID);
			self link_effect_to_ent( effectID, bone, offset, angle, 0.75 );
			
		}
	}
	
	
	
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
	
	level notify("cargo_straps_start");
	level notify("knuckle_rattle_start");
	level notify("knuckle_release_rattle_start");
	level notify("knuckle_break_rattle_start");
	level notify("chain_arch_start");
	level notify("chain_short_start");
	level notify("chain_long_start");
	level notify("streamer_4_start");
	level notify("streamer_5_start");
	level notify("old_wheels_start");
	level notify("luggage_net_start");
	level notify("rope_arch_start");
	level notify("rope_short_start");
	level notify("rope_long_start");

}

#using_animtree("fxanim_cargo_straps");
cargo_straps()
{
	level waittill("cargo_straps_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_straps", self.origin, self.angles, %fxanim_cargo_straps);
}

#using_animtree("fxanim_knuckle_rattle");
knuckle_rattle()
{
	level waittill("knuckle_rattle_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_knuckle_rattle", self[i].origin, self[i].angles, %fxanim_knuckle_rattle);
	}
}

#using_animtree("fxanim_jump_break");
jump_break()
{
	level waittill("jump_break_start");
	self UseAnimTree(#animtree);
	self animscripted("a_jump_break", self.origin, self.angles, %fxanim_jump_break);
	
	
	if (animhasnotetrack(%fxanim_jump_break, "flap_spark_big") && animhasnotetrack(%fxanim_jump_break, "flap_spark_small"))
	{
		
		self thread loopTag_Effect("a_jump_break", "flap_spark_big", "train_metal_sparks_pop", "flap_1_jnt", 4, (-18, 54, 0), (-45,0,0));
		self thread loopTag_Effect("a_jump_break", "flap_spark_small", "train_metal_sparks_scrape", "flap_1_jnt", 9, (-18, 54, 0), (-45,0,0));		
	}	
	
	wait(5.84);
	
}

#using_animtree("fxanim_jump_break_flap");
jump_break_flap()
{
	self UseAnimTree(#animtree);
	self animscripted("a_jump_break_flap", self.origin, self.angles, %fxanim_jump_break_flap);
	
	if (animhasnotetrack(%fxanim_jump_break_flap, "flap_spark_big") && animhasnotetrack(%fxanim_jump_break_flap, "flap_spark_small"))
	{
		
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
chain_arch()
{
	level waittill("chain_arch_start");
	self UseAnimTree(#animtree);
	self animscripted("a_chain_arch", self.origin, self.angles, %fxanim_chain_arch);
}

#using_animtree("fxanim_chain_short");
chain_short()
{
	level waittill("chain_short_start");
	self UseAnimTree(#animtree);
	self animscripted("a_chain_short", self.origin, self.angles, %fxanim_chain_short);
}

#using_animtree("fxanim_streamer_4");
streamer_4()
{
	level waittill("streamer_4_start");
	self UseAnimTree(#animtree);
	self animscripted("a_streamer_4", self.origin, self.angles, %fxanim_streamer_4);
}

#using_animtree("fxanim_streamer_5");
streamer_5()
{
	level waittill("streamer_5_start");
	self UseAnimTree(#animtree);
	self animscripted("a_streamer_5", self.origin, self.angles, %fxanim_streamer_5);
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
	level waittill("luggage_net_start");
	self UseAnimTree(#animtree);
	self animscripted("a_luggage_net", self.origin, self.angles, %fxanim_luggage_net);
}

#using_animtree("fxanim_rope_arch");
rope_arch()
{
	level waittill("rope_arch_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rope_arch", self.origin, self.angles, %fxanim_rope_arch);
}

#using_animtree("fxanim_rope_short");
rope_short()
{
	level waittill("rope_short_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rope_short", self.origin, self.angles, %fxanim_rope_short);
}

#using_animtree("fxanim_rope_long");
rope_long()
{
	level waittill("rope_long_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rope_long", self.origin, self.angles, %fxanim_rope_long);
}

#using_animtree("fxanim_chain_long");
chain_long()
{
	level waittill("chain_long_start");
	self UseAnimTree(#animtree);
	self animscripted("a_chain_long", self.origin, self.angles, %fxanim_chain_long);
}

#using_animtree("fxanim_box_fall");
box_fall()
{
	level waittill("box_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_box_fall", self.origin, self.angles, %fxanim_box_fall);
}





precache_FX()
{
	level._effect["fx_metalhit_lg"]		= loadfx ("impacts/large_metalhit");
				level._effect["bullet_pierce"] = loadfx ( "maps/Casino/casino_vent_bullet_vol" );
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
	
	
	level._effect["train_metal_sparks_pop"] 	= loadfx ( "maps/montenegrotrain/train_metal_sparks_pop" );
	level._effect["train_metal_sparks_scrape"] 	= loadfx ( "maps/montenegrotrain/train_metal_sparks_scrape" );
	
	
	
	






	


	



	level._effect["lightning"]		= loadfx ("weather/lightning_runner");

	level._effect["rain9"] = loadfx("weather/rain_runner_angle");
	level._effect["rain_bg"] = loadfx("weather/rain_bg_angle");
	
		
		
	
	
	
	



	




setExpFog(0,100000,0,0,0,0);

}	
