/*---------------------------------------------------
spiderhole stuff



USAGE:  
	
	-spawner has "script_spiderhole" key/value set to 1
	-spawner targets a script_origin( this is where the emerge animation is played from until the anims are don )
	-spawner targets a script_brushmodel with script_noteworthy name of "blocker" and monsterclip texture( this blocks AI from falling into the exposed hole in the ground ). Should be the same size and shape of the spiderhole.

---------------------------------------------------*/

#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_anim; 
spiderhole()
{
	self endon( "death" ); 

	//Make sure the animations are setup properly.
/#
	assertex( IsDefined( level.scr_anim["spiderhole"]["sprint"][0] ), "Missing spiderhole sprint animations (array)." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["spiderhole_idle_crouch"][0] ), "Missing spiderhole spiderhole_idle_crouch animations (array)." );
	
	assertex( IsDefined( level.scr_anim["spiderhole"]["jump_out"] ), "Missing spiderhole jump_out animation." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["stumble_out"] ), "Missing spiderhole stumble_out animation." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["grenade_toss"] ), "Missing spiderhole grenade_toss animation." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["gun_spray"] ), "Missing spiderhole gun_spray animation." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["crouch2stand"] ), "Missing spiderhole crouch2stand animation." );
	assertex( IsDefined( level.scr_anim["spiderhole"]["jump_attack"] ), "Missing spiderhole jump_attack animation." );

#/
	
	//wait until the guy is done spawning and make sure he doesn't have any enemy
	self waittill( "finished spawning" );
	
	//wait a frame for each spiderhole dude since they use up some ents to spawn in
	wait_network_frame();
	
	self.ignoreme = true; 
	self.pacifist = true; 
	self.old_animname = self.animname;
	self.animname = "spiderhole";

	spider_lid = undefined;
	target_node = undefined;

	/*---------------------------------------------------
	Assert if there is no target...there must at least be a script_origin defined for the anim to play from.
	---------------------------------------------------*/
	ASSERTex( IsDefined( self.target ), " Spiderhole Spawner @ " + self.origin + " does NOT target anything!" ); 
	
	/*---------------------------------------------------
	Get all the targeted entitiles
	---------------------------------------------------*/
	ents = getentarray( self.target, "targetname" );
	anim_org = GetStruct( self.target, "targetname" );

	for( i = 0; i < ents.size; i++ )
	{
		//spiderhole lid 
		if( isDefined( ents[i].script_noteworthy )  && ents[i].script_noteworthy == "spiderhole_lid" )
		{
/#
			assertex( IsDefined( level.scr_animtree["spiderhole_lid"] ), "Missing spiderhole lid animtree." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["jump_out"] ), "Missing spiderhole lid jump_out animation." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["stumble_out"] ), "Missing spiderhole lid stumble_out animation." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["grenade_toss"] ), "Missing spiderhole lid grenade_toss animation." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["gun_spray"] ), "Missing spiderhole lid gun_spray animation." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["crouch2stand"] ), "Missing spiderhole_lid crouch2stand animation." );
			assertex( IsDefined( level.scr_anim["spiderhole_lid"]["jump_attack"] ), "Missing spiderhole lid jump_attack animation." );
#/

			spider_lid = ents[i];
			//self thread monitor_spiderhole_death(spider_lid);

		}
	}
	
	/*-------------------------------------------------- 
	assert if the spiderhole doesn't have the origin set
	---------------------------------------------------*/
	ASSERTex( IsDefined( anim_org ), " SpiderHole Spawner @ " + self.origin + " does NOT target a script_struct!" ); 	

	
	/*-------------------------------------------------- 
	set a looping animation on the guy until he emerges from the spiderhole
	---------------------------------------------------*/	
	anim_org thread anim_loop_solo( self, "spiderhole_idle_crouch", undefined, "open_lid" ); 

	if( IsDefined( spider_lid ) && IsDefined( spider_lid.radius ) )
	{
		emerge_trig = spawn( "trigger_radius", self.origin, 0, spider_lid.radius, spider_lid.radius ); 
		emerge_trig waittill( "trigger" ); 
		emerge_trig delete(); 		
	}
	
	if( isDefined( self.script_delay_min ) && isDefined( self.script_delay_max ) )
	{
		wait( RandomFloatRange( self.script_delay_min, self.script_delay_max ) ); 
	}


	/*-------------------------------------------------- 
	Don't emerge if the player is standing too close to a spider hole!
	---------------------------------------------------*/
	while( 1 )
	{
		closest_player = get_closest_player( self.origin );
		if( distancesquared( closest_player.origin, self.origin ) > 96 * 96 )
		{
			break;
		}

		wait( 0.05 ); 
	}
		
	/*-------------------------------------------------- 
	You can target 1 or more pathnodes for the guy to run to if he doesn't spawn in and charge the player.
	If more than 1 node is targeted, then it will pick a random one.
	
	Get any nodes that might be targeted by the spawner.	
	If any pathnodes were found , then set a random one as the target_node. 
	---------------------------------------------------*/
	nodes = getnodearray( self.target, "targetname" ); 
	if( nodes.size > 0 )
	{		
		target_node = nodes[RandomInt( nodes.size )]; 
	}	

	
	/*-------------------------------------------------- 
	Check to see if there was a "lid" targeted by this spawner.
	- check to see if there is a script_fxid defined and play FX when the lid opens
	---------------------------------------------------*/
	if( isdefined( spider_lid ) )
	{
		
		if( isDefined( spider_lid.script_fxid ) )
		{
			playfx( level._effect[spider_lid.script_fxid], spider_lid.origin ); 
		}
	
	}	
	
	/*-------------------------------------------------- 
	chance for this guy to charge at the player and melee attack him
	 
	If the guy does not spawn in and charge the player, check for a targeted node. If there are no nodes targeted, then just leave him in his box
	---------------------------------------------------*/
	chance = 0; 
	if( isDefined( self.script_spiderhole_charge ) ) 
	{
		chance = self.script_spiderhole_charge; 	
	}	
	
	self notify( "open_lid" );
	anim_org notify("open_lid");
	level notify("open_lid");	
	spider_lid notify("emerge");
	spider_lid notSolid();

	radius = 1024;
	if( IsDefined( spider_lid ) && IsDefined( spider_lid.script_radius ) )
	{
		radius = spider_lid.script_radius;
	}
	
	self.pacifist = false; 
	closest_player = get_closest_player( self.origin );
	
	//CP ...guys always should go into banzai mode if they have been set to charge
	//if( chance >= RandomInt( 100 ) && DistanceSquared( closest_player.origin , self.origin ) < radius * radius ) 
	if( chance >= RandomInt( 100 ))
	{
		self thread spiderhole_charge( anim_org, spider_lid, closest_player );
	}
	else
	{
		self thread spiderhole_run_to_node( anim_org, spider_lid, target_node );
	}
}

spiderhole_charge( anim_org, spider_lid, closest_player )
{
	self endon( "death" );
	
	self spiderhole_anim( anim_org, spider_lid, closest_player );
	self.goalradius = 64;
	self.ignoreall = false;
	self.pacifist = false;
	
	self.banzai_no_wait = true;
	self maps\_banzai::banzai_force();

//	self.meleeRange = 2048; 
//	self.meleeRangeSq = 2048 * 2048; 	
//	
//	size = level.scr_anim["spiderhole"]["sprint"].size;
//	run_anim = level.scr_anim["spiderhole"]["sprint"][RandomInt( size )];
//	
//	self.old_run_combatanim = self.run_combatanim; 
//	self.run_combatanim = run_anim; 
//	self.pathenemyFightdist = 64; 
//	self.pathenemyLookahead = 64; 		
//	
//	self thread spiderhole_charge_internal();

}


spiderhole_charge_internal()
{
	
	players = get_players(); 
	squad = getaiarray( "allies" );
	
	//remove hero's from the squad
	squad = array_remove(squad,level.sarge);
	squad = array_remove(squad,level.polonsky);
		
	combined = array_combine( players, squad ); 
	guy = get_closest_living( self.origin, combined, 1024);
	
	//if there is nobody chosen for some reason, then just force him on a player
	if(!isDefined(guy))
	{
		guy = players[randomint(players.size)];
	} 	
	
	//self SetGoalEntity( guy );		<-- bugs! no longer works
	self thread set_goal_to_guy( guy ); 		
	
	self playsound( "jpn_charge" );
	self thread spiderhole_charge_think();
}


set_goal_to_guy(guy)
{
	self endon("death");

	while(issentient(guy))
	{
		self setgoalpos(guy.origin);
		wait(.1);
	}
	
	self thread spiderhole_charge_internal();
	
}


//don't make the guy charge at the player for too long
spiderhole_charge_think()
{
	self endon( "death" ); 
	
	self waittill("stop_spiderhole");
	
	self.goalradius = 2048; 
	self set_default_pathenemy_settings(); 
	
	if( isDefined( self.old_run_combatanim ) )
	{
		self.run_combatanim = self.old_run_combatanim; 
	}		
}

spiderhole_run_to_node( anim_org, spider_lid, target_node )
{
	self endon( "death" );

	if( isDefined( target_node ) )
	{
		//Chris_P - changed this so that they still open the lid 
		//toward the player before running to their node
		closest_player = get_closest_player( self.origin );
		self spiderhole_anim( anim_org, spider_lid ,closest_player);
				
		assertex( self.goalheight == 80, "Tried to set goalheight on guy with export " + self.export + " before running spawn_failed on the guy." ); 
			
		if( IsDefined( target_node.height ) )
		{
			self.goalheight = target_node.height; 
		}
		else
		{
			self.goalheight = level.default_goalheight; 
		}
		
		if( target_node.radius != 0 )
		{
			self.goalradius = target_node.radius; 
		}
		else
		{
			self.goalradius = 32; 
		}
		
		self SetGoalNode( target_node ); 		
						
	}
	else
	{
		self.allowdeath = true; 				
		self spiderhole_anim_internal( self.script_spiderhole_anim, self, spider_lid );
	}
}

// starts once guys decide to exit their spiderhole, allowing them to be
// burned and such a little while later
spiderhole_reset_death( delay )
{
	self endon( "death" );
	
	wait( delay ); // long enough for animations and stuff to play
	self.nodeathragdoll = false;
	self.deathanim = undefined;
	self.nodeathragdoll = undefined;	
}

#using_animtree("generic_human");
spiderhole_anim( anim_org, lid, closest_object )
{
	if( isDefined( self.script_spiderhole_anim ) )
	{
		self.allowdeath = true;
		self.deathanim =%exposed_crouch_death_fetal;
		self.nodeathragdoll = true;
		self.ignoreme = false; 

		self spiderhole_anim_internal( self.script_spiderhole_anim, anim_org, lid, closest_object );
		self spiderhole_duck( self.script_spiderhole_anim, anim_org, lid, closest_object );

		return;
	}

	self spiderhole_getout_anim( anim_org, lid, closest_object );

	self.nodeathragdoll = false;
	self.deathanim = undefined;
	self.nodeathragdoll = undefined;
}

spiderhole_getout_anim( anim_org, lid, closest_object )
{
	num = RandomInt( 100 );

	if( num > 80 )
	{
		getout_anim = "stumble_out";
	}
	else
	{
		getout_anim = "jump_out";
	}

	self spiderhole_anim_internal( getout_anim, anim_org, lid, closest_object );

	lid thread spiderhole_drop_lid_to_ground(); // JAS Drop the lid to the ground, because they float sometimes.
	self thread spiderhole_reset_death( 1 ); // JAS crappy hack to get them burnable
}

spiderhole_anim_internal( anim_ref, anim_org, lid, closest_object )
{
	//test CP
	//preturn_angles = lid.angles;
	//end test
	
	if( IsDefined( closest_object ) )
	{
		angles = VectorToAngles( closest_object.origin - self.origin );
		anim_org.angles = ( 0, angles[1], 0 );
	}

	if( IsDefined( lid ) )
	{
		// TEMP
//		lid.angles = anim_org.angles;
//		wait( 0.05 );
		tag_origin = Spawn( "script_model", lid.origin );
		tag_origin SetModel( "tag_origin_animate" );
		//test CP
		//tag_origin.angles = preturn_angles + (0,270,0);
			tag_origin.angles = anim_org.angles;
		//end test
		
		//tag_origin thread line_to_tag( "origin_animate_jnt" );

		//lid LinkTo( tag_origin, "origin_animate_jnt", (0,0,0), (0,180,0) );
		lid LinkTo( tag_origin, "origin_animate_jnt");//, (0,0,0), (0,180,0) );
		lid.tag_lid = tag_origin;
		lid.tag_lid.anim_ref = anim_ref;
		
		//tag_origin thread draw_tag_angles( "origin_animate_jnt" );

		tag_origin assign_animtree( "spiderhole_lid" );
		tag_origin SetAnimKnob( level.scr_anim["spiderhole_lid"][anim_ref], 1, 0.2, 1 );
	}

	addNotetrack_customFunction( self.animname, "fire", ::spiderhole_gun_spray, anim_ref );
	addNotetrack_customFunction( self.animname, "grenade_toss", ::spiderhole_grenade_toss, anim_ref );
	anim_org anim_single_solo( self, anim_ref );
	self notify("out_of_spiderhole");
	if(isDefined(lid))
	{
		lid notify("out_of_spiderhole");
	}
}

// This is really hacky.
spiderhole_drop_lid_to_ground()
{
	//Chris_P - this looks really bad in oki3..causes the lids to float upwards most of the time
	//adding a level flag so that it can be bypassed 
	if(!isDefined(level.no_spider_lid_drop))
	{
		wait(1.5);
		self Unlink();
		groundPos = PhysicsTrace( self.origin + (0,0,64), self.origin - (0,0,256) );	
		self MoveTo( groundPos + (0,0,6), 0.5 );
	}
	
}

spiderhole_duck( anim_ref, anim_org, lid, closest_object )
{
	self endon( "death" );

	if( anim_ref == "grenade_toss" || anim_ref == "gun_spray" )
	{
		anim_org thread anim_loop_solo( self, "spiderhole_idle_crouch", undefined, "emerge" ); 

		if( isDefined( self.script_delay_min ) && isDefined( self.script_delay_max ) )
		{
			wait( RandomFloatRange( self.script_delay_min, self.script_delay_max ) ); 
		}
		else
		{
			wait( .1);//RandomFloatRange( 2, 3 ) ); 
		}

		while( 1 )
		{
			closest_player = get_closest_player( self.origin );
			if( DistanceSquared( closest_player.origin, self.origin ) > 96 * 96 )
			{
				break;
			}
	
			wait( 0.05 ); 
		}
		
		self notify( "emerge" );

		self spiderhole_getout_anim( anim_org, lid, closest_object );
	}
}

spiderhole_grenade_toss( guy )
{
	tag = guy GetTagOrigin( "tag_weapon_left" );

	target = get_closest_player( guy.origin );
	guy MagicGrenade( tag, target.origin, 3 );
	
}

spiderhole_gun_spray( guy )
{
	guy Shoot( guy.accuracy );
}

line_to_tag( tag_name )
{
	self endon( "death" );
	player = get_players()[0];

	while( 1 )
	{
		line( player.origin, self GetTagorigin( tag_name ) );
		wait( 0.05 );
	}
}

do_print3d( msg, time, offset )
{
/#
	if( !IsDefined( time ) )
	{
		time = 3;
	}

	time = GetTime() + ( time * 1000 );

	if( !IsDefined( offset ) )
	{
		offset = ( 0, 0, 32 );
	}

	while( GetTime() < time )
	{
		offset = offset + ( 0, 0, 1.5 );
		print3d( self.origin + offset, msg );
		wait( 0.05 );
	}
#/
}

draw_tag_angles( tagname )
{
/#
	while( 1 )
	{
		forward = AnglesToForward( self GetTagAngles( tagname ) );
		pos2 = self GetTagOrigin( tagname ) + vector_multiply( forward, 48 );
		line( self GetTagOrigin( tagname ), pos2 );
		wait( 0.05 );
	}
#/
}

monitor_spiderhole_death(lid)
{
	self endon("out_of_spiderhole");
	
	self waittill("death");
	lid solid();
	lid notify("guy_dead");

}