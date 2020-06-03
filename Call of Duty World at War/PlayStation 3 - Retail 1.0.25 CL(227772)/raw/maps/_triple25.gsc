// _triple25.gsc
// Sets up the behavior for the Japanese AAA the Triple 25.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_utility;

main( model, type )
{
	build_template( "triple25", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "artillery_jap_triple25mm", "artillery_jap_triple25mm_d" );
	//build_shoot_shock( "tankblast" );
	build_deathfx( "explosions/fx_exp_aagun", undefined, "explo_metal_rand" );
	build_deathquake( 0.7, 1.0, 500 );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_mainturret();
	
	//load anims, this is kind of a special case since it's not a tradiational vehicle		
	load_triple25_anims();
	load_triple25_gunner_anims();
}

// Anything specific to this vehicle, used globally.
init_local()
{
	self endon ("death");
	self endon ("crew dismount");
	self endon ("crew dead");
		
	self.crewsize = 0;	
	self.triple25_gunner = [];
	
	triple25_targets = 0;
	if( isdefined( self.target ) )
	{
		triple25_targets = getentarray( self.target, "targetname" );
	}
	
	triple25_triggers = [];

	triple25_gunner_spawner = [];

	triple25_dismount_trig = undefined;
	self.triple25_aim = undefined;
	
	// CODER_MOD - DSL - 03/25/08
	// Move off some of the load to the client.
	
	self.client_side_fire = false;
	
	// guzzo 6-5-08, now that the player can use these, they shouldn't be required to have a target
	if( isdefined( self.target ) )
	{
		// some crazy IW stuff here, parses the targets of the vehicle and checks for anything with "actor" in the 
		// target. defines those as the spawners. Also checks for dismount trigger
		for( j = 0; j < triple25_targets.size; j++ )
		{
			triple25_target = triple25_targets[ j ];
			if( issubstr( triple25_target.classname, "actor" ) )
			{
				triple25_gunner_spawner[triple25_gunner_spawner.size] = triple25_target;
			}
			else if( issubstr( triple25_target.classname, "script_origin" ) )
			{
				self.triple25_aim = triple25_target;
			}
			
			else if( isdefined( triple25_target.script_noteworthy ) && triple25_target.script_noteworthy == "dismount" )
			{
				triple25_dismount_trig = triple25_target;
			}
			else
			{
				triple25_triggers[ triple25_triggers.size ] = triple25_target;
			}
		}

	}
	
	loopPacket = [];
	
	// spawn the crew, link them up	
	for (i = 0; i < triple25_gunner_spawner.size; i++)
	{
		// spawn the guy in
		self.triple25_gunner[self.triple25_gunner.size] = triple25_gunner_spawner[i] spawn_gunner();
		self.triple25_gunner[i] linkto( self, "tag_driver"+(i+1), (0,0,0), (0,0,0) );		
		self.triple25_gunner[i].position = i;
		//call animation	
		self.triple25_gunner[i] thread monitor_gunner( self, triple25_dismount_trig );
		
		self.triple25_gunner[i] thread  triple25gunner_animation_think( self );
		//loopPacket[ loopPacket.size ] = self.triple25_gunner[i] anim_at_entity( self, link_tag );
		
		self.crewsize++;
	}

	self notify ( "crew ready" );

	//loopPacket[ loopPacket.size ] = self anim_at_self();
	//self thread anim_loop_packet( loopPacket, "fire_loop", "stop_looping" );

	

	// start the firing loop for the gun
	if (isdefined (self.triple25_aim))
	{
		self thread triple25_shoot(self.triple25_aim);
	}

	//either dismount of AI or death of AI will unlink everyone
	if( isdefined( triple25_dismount_trig ) )
	{
		for (i = 0; i < self.crewsize; i++)
		{
			thread dismount_think(triple25_dismount_trig, self.triple25_gunner[i], self);
			thread death_think(self.triple25_gunner[i], self);
		}
	}
}

dismount_think(trig, guy, gun)
{
		guy endon( "death" );
		
		waittill_death_or_dismount( trig, guy, gun );
		
		if (isdefined(guy))
		{
			guy unlink();
		}
}


death_think(guy, gun)
{
		guy waittill( "death" );
		
		if (isdefined(guy))
		{
			guy unlink();
		}
}


// Animtion set up for vehicle anims
#using_animtree( "tank" );
set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree ("generic_human");
setanims()
{
	max_positions = 2;
	
	positions = [];
	for(i = 0 ; i < max_positions ;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_driver1";
	positions[1].sittag = "tag_driver2";
		
	positions[0].idle = %crew_flak1_tag1_idle_1; 
	positions[1].idle = %crew_flak1_tag2_idle_1; 

	positions[0].getout = %crew_flak1_tag1_dismount; 
	positions[1].getout = %crew_flak1_tag2_dismount; 
	
	positions[0].getout_combat = %crew_flak1_tag1_alert; 
	positions[1].getout_combat = %crew_flak1_tag2_alert; 
		
	return positions;
}

#using_animtree( "triple25" );
load_triple25_anims()
{
	level.scr_animtree[ "triple25_gun" ] = #animtree;
	level.scr_anim[ "triple25_gun" ][ "fire_loop" ][ 0 ] = %v_triple25_fire;

	thread notetrack_setup();

}

notetrack_setup()
{
	wait 1;
	//addNotetrack_sound("triple25_gun", "fire_1", "fire_loop", "triple25_fire1");
	//addNotetrack_customFunction( "triple25_gun", "fire_1", ::triple25_shoot1 );
}

#using_animtree( "generic_human" );
load_triple25_gunner_anims()
{
	level.scr_anim[ "triple25_gunner1" ][ "deathin" ] 						= %crew_flak1_tag1_death_stay_in;
	level.scr_anim[ "triple25_gunner1" ][ "deathout" ] 						= %crew_flak1_tag1_death_fall_out;
	//level.scr_anim[ "triple25_gunner1" ][ "dismount" ] 					= %crew_flak1_tag1_dismount;
	level.scr_anim[ "triple25_gunner1" ][ "dismount" ] 						= %crew_flak1_tag1_alert;
	level.scr_anim[ "triple25_gunner1" ][ "mount" ]							= %crew_flak1_tag1_mount;
	level.scr_anim[ "triple25_gunner1" ][ "fire_loop" ][ 0 ] 				= %crew_flak1_tag1_fire_1;
	level.scr_anim[ "triple25_gunner1" ][ "idle_loop" ][ 0 ] 				= %crew_flak1_tag1_idle_1;
	level.scr_anim[ "triple25_gunner1" ][ "rotateccw_loop" ][ 0 ] 			= %crew_flak1_tag1_rotate_ccw;
	level.scr_anim[ "triple25_gunner1" ][ "rotatecw_loop" ][ 0 ] 			= %crew_flak1_tag1_rotate_cw;
	//level.scr_anim[ "triple25_gunner1" ][ "deathslouchidle" ] 			= %triple25_gunner_deathslouchidle;
	
	level.scr_anim[ "triple25_gunner2" ][ "deathin" ] 						= %crew_flak1_tag2_death_stay_in;
	level.scr_anim[ "triple25_gunner2" ][ "deathout" ] 						= %crew_flak1_tag2_death_fall_out;
	//level.scr_anim[ "triple25_gunner2" ][ "dismount" ] 					= %crew_flak1_tag2_dismount;
	level.scr_anim[ "triple25_gunner2" ][ "dismount" ] 						= %crew_flak1_tag2_alert;
	//level.scr_anim[ "triple25_gunner2" ][ "mount" ]						= %crew_flak1_tag2_mount;
	level.scr_anim[ "triple25_gunner2" ][ "fire_loop" ][ 0 ] 				= %crew_flak1_tag2_fire_1;
	level.scr_anim[ "triple25_gunner2" ][ "idle_loop" ][ 0 ] 				= %crew_flak1_tag2_idle_1;
	level.scr_anim[ "triple25_gunner2" ][ "rotateccw_loop" ][ 0 ]			= %crew_flak1_tag2_rotate_ccw;
	level.scr_anim[ "triple25_gunner2" ][ "rotatecw_loop" ][ 0 ] 			= %crew_flak1_tag2_rotate_cw;
	//level.scr_anim[ "triple25_gunner2" ][ "deathslouchidle" ] 			= %triple25_gunner_deathslouchidle;
}

spawn_gunner()
{
	
	// guzzo 8-6-08, to help network traffic
	while( !OkTospawn() )
	{
		wait( 0.05 );
	}	
	
	spawn = self spawn_ai();

	if ( spawn_failed( spawn ) )
	{
		assertex( 0, "spawn failed from triple25" );
		return;			
	}
	spawn endon( "death" );
	spawn.olddeathAnim = spawn.deathAnim;	
	spawn.deathAnim = level.scr_anim[ "triple25_gunner1" ][ "deathout" ];
	spawn.allowDeath = true;
	spawn.oldhealth = spawn.health;
	spawn.health = 1;
	
	// guzzo - 4/1/08 trying to get pistol pull-out to work seamlessly
	//spawn animscripts\init::initWeapon( spawn.sidearm, "primary" );
	//spawn animscripts\shared::placeWeaponOn( spawn.sidearm, "right" );
	//spawn animscripts\utility::setAICurrentWeapon( "nambu" );
	
	return spawn;
}

//triple25gunner_animation_think(triple25)
//{
//	//initially shooting
////	self endon ( "death" ); //idle when dead
////	self endon ( "dismount gunner" ); //gunner left
////	triple25 endon ( "dismount gunner" ); //gunner left
////	triple25 endon ( "new gunner" ); //new gunner
//
//	triple25.animName = "triple25_gun";
//	// SCRIPTER_MOD: JesseS (7/21/200):  took out for now
//	triple25 assign_animtree();
//	
//	link_tag = undefined;		
//	
//	loopPacket = [];
//
//	if (self.position == 0)
//	{
//		self.animName = "triple25_gunner1";
//		link_tag			= "tag_driver1";
//	}
//	else
//	{
//		self.animName = "triple25_gunner2";
//		link_tag			= "tag_driver2";
//	}
//	
//
//	
//	return link_tag;
//}

triple25gunner_animation_think(triple25)
{
	self endon ( "death" );
	
	linktag = undefined;
	if (self.position == 0)
	{
		self.animName = "triple25_gunner1";
		link_tag			= "tag_driver1";
	}
	else
	{
		self.animName = "triple25_gunner2";
		link_tag			= "tag_driver2";
	}
	triple25.animName = "triple25_gun";
	
	triple25 assign_animtree();
	
	self thread anim_loop_solo( self, "fire_loop", link_tag, "stop_looping", triple25  );	
	
}

monitor_gunner(triple25, trig)
{
	self waittill( "death" );
	
	self notify ("stop_looping");
	
	if (isdefined(trig))
	{
		wait (0.5);
		trig notify ("trigger");
	}
		
	//triple25 setanim( level.scr_anim[ triple25.animName ][ "fire_loop" ][ 0 ], 1, 1, 0 );
	triple25.crewsize--;
	
	//if (triple25.crewsize == 0)
	//{
		triple25 notify ("crew dead");
		
		if(isdefined(triple25.client_side_fire) && triple25.client_side_fire == true)
		{
			SetClientSysState("levelNotify", "25s" + triple25 getentitynumber());
		}
		
		//triple25 notify ("crew dismount");
	//}
}

//triple25_recycle(flag)
//{
//	level endon (flag);
//	wait 20;	//recycle time before respawning unless stopped by player hitting the cancel trigger
//}

//if any trigger is activated in a trigger array
waittill_trigger_array( triggers )
{
	for( k = 1; k < triggers.size; k++ )
		triggers[k] endon( "trigger" );
	triggers[ 0 ] waittill( "trigger" );
}

waittill_death_or_dismount( trig, gunner, triple25 )
{
	gunner endon( "death" );
	trig waittill( "trigger" );
	
	gunner notify ("stop_looping");
		
	//triple25 waittillmatch( "looping anim", "end" );
	//triple25 notify( "stop_looping" );
	gunner thread triple25gunner_dismount( triple25 );
}

triple25gunner_dismount(triple25)
{
	self endon ( "death" );
	
	linktag = undefined;
	if (self.position == 0)
	{
		self.animName = "triple25_gunner1";
		link_tag			= "tag_driver1";
	}
	else
	{
		self.animName = "triple25_gunner2";
		link_tag			= "tag_driver2";
	}
	triple25.animName = "triple25_gun";
	
	triple25 assign_animtree();
	
	triple25 notify ("crew dismount");
	
	if(isdefined(triple25.client_side_fire) && triple25.client_side_fire == true)
	{
			SetClientSysState("levelNotify", "25s" + triple25 getentitynumber());
	}
		
	self thread anim_single_solo( self, "dismount", link_tag, undefined, triple25 );
	
	self.deathAnim = self.olddeathAnim;	
	self.allowDeath = false;
	self.health = self.oldhealth;
	
}

death_monitor(str)
{
	self endon("death notify");
	self waittill(str);
	
	if(isdefined(self.client_side_fire) && self.client_side_fire == true)
	{
		SetClientSysState("levelNotify", "25s" + self getentitynumber());
	}

	self notify("death notify");
}

triple25_shoot(targetent)
{	
	self endon ("death");
	self endon ("crew dead");
	self endon ("change target");
	self endon ("crew dismount");
	
	self thread death_monitor("death");
	self thread death_monitor("crew dead");
	
	// this is a temp firing loop until we get some better stuff
	self setturrettargetent(targetent);
	
	wait 2;
	
	while (1)
	{
		num_shots = randomintrange(5, 15);
		waittime = randomfloatrange(0.5, 2);

		// CODER_MOD - DSL - 03/25/08
		// See what can be done on the client.

		if(self.client_side_fire == false)
		{
			for (i = 0; i < num_shots; i++)
			{
				self fireweapon();
				wait 0.1;
			}
		}
		wait (waittime);
		
	}
}
