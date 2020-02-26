// _artillery.gsc
// Sets up the behavior for the 122mm Howitzer (Russian), Pak43 (German) and 47mm AT-Gun (Japanese).

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "vehicles" );
main(model,type,no_deathmodel)
{
	build_template( "artillery", model, type );
	build_localinit( ::init_local );
	
	// guzzo 6/9/08 - if we don't want a separate deathmodel, don't pass one in to build_deathmodel()
	if( isdefined( no_deathmodel ) && no_deathmodel )
	{
		build_deathmodel( "artillery_ger_pak43"  );
		build_deathmodel( "artillery_rus_m30" );
		build_deathmodel( "artillery_jap_47mm" );			
	}
	else
	{
		build_deathmodel( "artillery_ger_pak43", "artillery_ger_pak43" );
		build_deathmodel( "artillery_rus_m30", "artillery_rus_m30" );
		build_deathmodel( "artillery_jap_47mm", "artillery_jap_47mm_d" );		
	}

	build_shoot_shock( "tankblast" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	//build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );

	// Sumeet - sets the team on the artilleries.
	if ( issubstr( model,"usa") )
	{
		build_team( "allies" );
	}
	else
	{
		build_team( "axis" );
	}
		
	build_mainturret();

	arty_anims();							// sets up the anims
}

// Anthing specific to this vehicle, used globally.
init_local()
{
	self.state = "arty_start";
	self.crewsize = 0;
	
	self.arty_crew_info["animname"][0] 	= "commander";     
	self.arty_crew_info["tag_a"][0]			= "tag_handle_right"; 
	self.arty_crew_info["tag_b"][0]			= "tag_commander";	   
                                                                     
	self.arty_crew_info["animname"][1] 	= "arty_left";         
	self.arty_crew_info["tag_a"][1]			= "tag_shield_left";       
	self.arty_crew_info["tag_b"][1]			= "tag_shield_left";     
	                                                                   
	self.arty_crew_info["animname"][2]	= "arty_right";       
	self.arty_crew_info["tag_a"][2]			= "tag_shield_right";     
	self.arty_crew_info["tag_b"][2]			= "tag_shield_right";	   
	                                                                   
	self.arty_crew_info["animname"][3]	= "loader";          
	self.arty_crew_info["tag_a"][3]			= "tag_handle_left";     
	self.arty_crew_info["tag_b"][3]			=	"tag_loader";	       
	
	arty_crew_init(self);	// inits the crew
}


arty_crew_init(vehicle)
{
	arty_targets = getentarray( self.target, "targetname" );
	arty_spawners = [];
	vehicle.arty_crew = [];
			
	for( i = 0; i < arty_targets.size; i++ )
	{
		arty_target = arty_targets[ i ];
		if( issubstr( arty_target.classname, "actor" ) )
		{
			arty_spawners[arty_spawners.size] = arty_target;
		}
	}
	
	// spawn the crew, set them up	
	for (i = 0; i < arty_spawners.size; i++)
	{
		// spawn the guy in
		vehicle.arty_crew[self.arty_crew.size] = arty_spawners[i] spawn_crewmember();		
		vehicle.arty_crew[i].position = i;
			
		vehicle.arty_crew[i].animname = vehicle.arty_crew_info["animname"][i];
		vehicle.arty_crew[i].tag_a = vehicle.arty_crew_info["tag_a"][i];
		vehicle.arty_crew[i].tag_b = vehicle.arty_crew_info["tag_b"][i];	
		
		vehicle.arty_crew[i] thread arty_crew_death_think(vehicle);
		vehicle.arty_crew[i] thread arty_crew_dismount(vehicle);	
		
		vehicle.crewsize++;
								
	}
	vehicle notify ("arty crew ready");
	

}

arty_crew_death_think(vehicle)
{
	
	// dpg 9/21/07 so guys can keep firing w/o the commander
	if( self.animname == "commander" )
	{
		return;	
	}
	
	self waittill_multiple("damage","death");
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
	
	// Sumeet - Only notify if the vehicle is alive.
	if ( isdefined( vehicle ) && ( vehicle.health > 0 ) )
	{
		vehicle notify ("shut down arty");
		vehicle setspeed (0,100000,100000);
	}
}

arty_crew_dismount(vehicle)
{
	self endon( "death" );
	vehicle waittill ("shut down arty");
	self unlink();
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
	self.deathAnim = self.olddeathAnim;	
	self.health = self.oldhealth;
	self.ignoreall = false;
}

artycrew_animation_think(vehicle, tag)
{
	vehicle endon ("changing positions");
	vehicle endon ("shut down arty");
	self endon ("death");
//	self endon ("crew dismounted");
//	flak endon ("crew dismounted");
//	flak endon ("newcrew");
	for (;;)
	{
		self thread arty_crew_play_anim(vehicle, vehicle.state, tag);
		
		self waittill ("artycrew animation done");
	}
}

arty_crew_play_anim(vehicle, animname, tag)
{
	vehicle endon ("changing positions");
	vehicle endon ("shut down arty");		
	//vehicle waittill ("arty sequence started");
	self endon( "death" );
	
	tagOrigin = vehicle getTagOrigin (tag);
	tagAngles = vehicle getTagAngles (tag);
	
	if (isalive (self))
	{
		self animscripted("arty_anim_done", tagOrigin, tagAngles, level.scr_anim[self.animname][animname]);
		self.allowDeath = 1;
		self waittillmatch ("arty_anim_done","end");
		
		self notify ("artycrew animation done");
		vehicle notify ("artycrew animation done");
	}
}


arty_fire_loop()
{
	self endon( "shut down arty" );
	self endon( "stop_arty_fire_loop" );

	while( 1 )
	{
		if( self.state =="arty_fire" )
		{
			self waittill("artycrew animation done");
			self notify( "arty_fire" );
			self fireweapon();
			wait( 1 );	
		}
		
		wait( 1 );
	}
}


arty_fire_without_move()
{

	// guzzo 4-24-08, removed this prerequisite; wasn't necessary because they're assumed to be spawned and already on the gun when using this function.

//	self thread anim_reach_for_all("arty_stop", "tag_commander", self.arty_crew[0]);
//	self thread anim_reach_for_all("arty_stop", "tag_shield_left", self.arty_crew[1]);
//	self thread anim_reach_for_all("arty_stop", "tag_shield_right", self.arty_crew[2]);
//	self thread anim_reach_for_all("arty_stop", "tag_loader", self.arty_crew[3]);
//	
//	self waittill_multiple ("arty crew 1 in place", "arty crew 2 in place", "arty crew 3 in place", "arty crew 4 in place");						

	self disconnectpaths();


	// take guns away
	for (i = 0; i < self.arty_crew.size; i++)
	{	
		if( isalive( self.arty_crew[i] ) )
		{
			self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "none");
		}
	}
		
	// TODO what happens if a guy dies between the start of this thread and here? an assert, that's what. need to figure out solution (magic_bullet_shield?, isalive() check?)
		
	// link to the open up tags
	for (i = 0; i < self.arty_crew.size; i++)
	{	
		if( isalive( self.arty_crew[i] ) )
		{
			self.arty_crew[i] linkto (self, self.arty_crew[i].tag_b);	
		}
	}
	
	// the stop anims play once here
	for (i = 0; i < self.arty_crew.size; i++)
	{
		if( isalive( self.arty_crew[i] ) )
		{	
			self.arty_crew[i] thread artycrew_animation_think(self, self.arty_crew[i].tag_b);
		}
	}
	
	// play idles now
	self waittill ("artycrew animation done");
	self.state = "arty_idle";
	
}



// artillery script api goes here
// SRS 11/01/07 - added stopAtGoal (bool) to pass through to SetVehGoalPos()
arty_move( goal_pos, stopAtGoal )
{
		self endon ("shut down arty");
		self endon ("death");
		
		self notify ("changing positions");
		
		// unlink so they can move around
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] unlink ();
			self.arty_crew[i] endon ("death");		
		}
		
		self connectpaths();
	
		// think of a way to convert this so each guy goes at once, a custom anim_reach basically
		// guys get in place for pushing
		if (isdefined(self.arty_crew[0]))
		{
			self thread anim_reach_for_all("arty_start", "tag_handle_right", self.arty_crew[0]);
		}
		if (isdefined(self.arty_crew[1]))
		{
			self thread anim_reach_for_all("arty_start", "tag_shield_left", self.arty_crew[1]);
		}
		if (isdefined(self.arty_crew[2]))
		{
			self thread anim_reach_for_all("arty_start", "tag_shield_right", self.arty_crew[2]);
		}
		if (isdefined(self.arty_crew[3]))
		{
			self thread anim_reach_for_all("arty_start", "tag_handle_left", self.arty_crew[3]);
		}

		//give guns
		for (i = 0; i < self.arty_crew.size; i++)
		{	
				self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "right");
		}
		
		self waittill_multiple ("arty crew 1 in place", "arty crew 2 in place", "arty crew 3 in place", "arty crew 4 in place");						

		// take guns away
		for (i = 0; i < self.arty_crew.size; i++)
		{	
				self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "none");
		}

		self disconnectpaths();
		
		// the close up animation
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] linkto (self, self.arty_crew[i].tag_a);
		}
		
		// the close up animation
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] thread artycrew_animation_think(self, self.arty_crew[i].tag_a);
		}
		
		// closed up the arty piece
		self waittill ("artycrew animation done");
		self.state = "arty_push";
		
		// SRS 11/01/07
		if( !IsDefined( stopAtGoal ) )
		{
			stopAtGoal = 1;
		}
		
		// move the arty
		self SetSpeed( 5, 100, 100 );
		self setVehGoalPos( goal_pos, stopAtGoal );
		
		// this needs to start working at somepoint
		self waittill( "goal" );
		//wait 15;
		
		self notify ("changing positions");
		self.state = "arty_stop";		
		
		// unlink so they can move around
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] unlink ();
		}
		
		self connectpaths();
		
		//give back guns
		for (i = 0; i < self.arty_crew.size; i++)
		{	
				self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "right");
		}
		
		// get into idle / fire positions
		self thread anim_reach_for_all("arty_stop", "tag_commander", self.arty_crew[0]);
		self thread anim_reach_for_all("arty_stop", "tag_shield_left", self.arty_crew[1]);
		self thread anim_reach_for_all("arty_stop", "tag_shield_right", self.arty_crew[2]);
		self thread anim_reach_for_all("arty_stop", "tag_loader", self.arty_crew[3]);
		
		self waittill_multiple ("arty crew 1 in place", "arty crew 2 in place", "arty crew 3 in place", "arty crew 4 in place");						
//		self.arty_crew[0] anim_reach_solo( self.arty_crew[0], "arty_stop", "tag_commander", undefined, self );
//		self.arty_crew[1] anim_reach_solo( self.arty_crew[1], "arty_stop", "tag_shield_left", undefined, self );
//		self.arty_crew[2] anim_reach_solo( self.arty_crew[2], "arty_stop", "tag_shield_right", undefined, self );	
//		self.arty_crew[3] anim_reach_solo( self.arty_crew[3], "arty_stop", "tag_loader", undefined, self );

		//take away guns
		for (i = 0; i < self.arty_crew.size; i++)
		{	
				self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "none");
		}

		self disconnectpaths();
			
		// link to the open up tags
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] linkto (self, self.arty_crew[i].tag_b);
		}
		
		// the stop anims play once here
		for (i = 0; i < self.arty_crew.size; i++)
		{	
			self.arty_crew[i] thread artycrew_animation_think(self, self.arty_crew[i].tag_b);
		}
		
		// play idles now
		self waittill ("artycrew animation done");
		self.state = "arty_idle";
	
		self notify ("arty move done");
	
}

anim_reach_for_all(the_anim, the_tag, guy)
{
		// self is the vehicle, guy is the crew member
		guy anim_reach_solo( guy, the_anim, the_tag, undefined, self );
		self notify ("arty crew " + (guy.position + 1) + " in place");
}


arty_fire()
{
		self.state = "arty_fire";
		// fire animation loop goes here, needs notetack for when we actually fire it
		self thread arty_fire_loop();
}

spawn_crewmember()
{
	
	// guzzo 8-6-08, to help network traffic
	while( !OkTospawn() )
	{
		wait( 0.05 );
	}	
	
	spawn = self spawn_ai();

	if ( spawn_failed( spawn ) )
	{
		assertex( 0, "spawn failed from arty piece" );
		return;			
	}
	spawn endon( "death" );
	spawn.olddeathAnim = spawn.deathAnim;	
	//spawn.deathAnim = level.scr_anim[ "triple25_gunner1" ][ "deathin" ];
	spawn.allowDeath = true;
	spawn.oldhealth = spawn.health;
	spawn.health = 1;
	spawn.ignoreall = true;
	
	return spawn;
}

#using_animtree ("generic_human");
arty_anims()
{
	// commander anims
	level.scr_anim["commander"]["arty_fire"] 					= %crew_artillery1_commander_fire;
	level.scr_anim["commander"]["arty_idle"] 					= %crew_artillery1_commander_idle;
	level.scr_anim["commander"]["arty_pinned"] 				= %crew_artillery1_commander_pinneddown;
	level.scr_anim["commander"]["arty_push"] 					= %crew_artillery1_handleright_push_medium;
	level.scr_anim["commander"]["arty_stop"] 					= %crew_artillery1_handleright_stop;
	level.scr_anim["commander"]["arty_start"] 				= %crew_artillery1_handleright_start;
	level.scr_anim["commander"]["arty_rot_cw"] 				= %crew_artillery1_handleright_rotate_cw;
	level.scr_anim["commander"]["arty_rot_ccw"] 			= %crew_artillery1_handleright_rotate_ccw;

	
	// left guy
	level.scr_anim["arty_left"]["arty_fire"]					= %crew_artillery1_shieldleft_fire;
	level.scr_anim["arty_left"]["arty_idle"]		 			= %crew_artillery1_shieldleft_idle;		
	level.scr_anim["arty_left"]["arty_pinned"] 				= %crew_artillery1_shieldleft_pinneddown;
	level.scr_anim["arty_left"]["arty_push"]					= %crew_artillery1_shieldleft_push_medium;
	level.scr_anim["arty_left"]["arty_stop"]					= %crew_artillery1_shieldleft_push_stop;
	level.scr_anim["arty_left"]["arty_start"]					= %crew_artillery1_shieldleft_push_start;	
 	level.scr_anim["arty_left"]["arty_rot_cw"]				= %crew_artillery1_shieldleft_rotate_cw;
	level.scr_anim["arty_left"]["arty_rot_ccw"]				= %crew_artillery1_shieldleft_rotate_ccw;	

	// right guy
	level.scr_anim["arty_right"]["arty_fire"] 				= %crew_artillery1_shieldright_fire;	
	level.scr_anim["arty_right"]["arty_idle"] 				= %crew_artillery1_shieldright_idle;	
	level.scr_anim["arty_right"]["arty_pinned"] 			= %crew_artillery1_shieldright_pinneddown;	
	level.scr_anim["arty_right"]["arty_push"]					= %crew_artillery1_shieldright_push_medium;
	level.scr_anim["arty_right"]["arty_stop"]					= %crew_artillery1_shieldright_push_stop;
	level.scr_anim["arty_right"]["arty_start"]				= %crew_artillery1_shieldright_push_start;
 	level.scr_anim["arty_right"]["arty_rot_cw"]				= %crew_artillery1_shieldright_rotate_cw;
	level.scr_anim["arty_right"]["arty_rot_ccw"]			= %crew_artillery1_shieldright_rotate_ccw;
	
	// loader anims
 	level.scr_anim["loader"]["arty_fire"] 						= %crew_artillery1_loader_fire;
	level.scr_anim["loader"]["arty_idle"]		 					= %crew_artillery1_loader_idle;
	level.scr_anim["loader"]["arty_pinned"] 					= %crew_artillery1_loader_pinneddown;
	level.scr_anim["loader"]["arty_push"]		 					= %crew_artillery1_handleleft_push_medium;
 	level.scr_anim["loader"]["arty_stop"] 						= %crew_artillery1_handleleft_stop;
	level.scr_anim["loader"]["arty_start"] 						= %crew_artillery1_handleleft_start;
	level.scr_anim["loader"]["arty_rot_cw"] 					= %crew_artillery1_handleleft_rotate_cw;
 	level.scr_anim["loader"]["arty_rot_ccw"] 					= %crew_artillery1_handleleft_rotate_ccw;
}
