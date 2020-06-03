#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\sniper;


sniper_stealth_main()
{
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	level.corpsecount = [];
	level.stealthactors = [];
	level thread found_corpse_notify();
	level.e1_return_nodes = getnodearray("return_from_player_search", "script_noteworthy");
}

stealth_actors()
{
	level.stealthactors = array_add(level.stealthactors, self);
	thread remove_on_death(self);
}

remove_on_death(guy)
{
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	guy waittill ("death");
	level.stealthactors = array_remove(level.stealthactors, guy);
}

sniper_stealth_ai_setup()
{
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	self endon ("death");
	level thread corpse_adder(self);
	self thread corpsefind_wait();
	self thread isspotting_player();
	self thread stealth_actors();
	self.pacifist = true;
}

corpse_adder(guy)
{
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	guy waittill ("death");
	corpse = spawn("script_origin", guy.origin);
	corpse.seeme = spawn("script_origin", corpse.origin+(0,0,65) );
	corpse.fresh = 1;
	time = 0;
	level.corpsecount = array_add(level.corpsecount, corpse);
	while (isdefined(guy) && time < .7)
	{
		if (corpse.origin != guy.origin)
		{
			corpse.origin = guy.origin;
		}
		wait 0.1;
		time = time + .1;
	}

	wait 2;
	corpse.fresh = 2;
}

corpsefind_wait()
{
	self endon ("death");
	//level endon ("corpse_found");
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	foundcorpse = false;
	while(foundcorpse == false)
	{
		for (i=0; i < level.corpsecount.size; i++)
		{
			corpse = level.corpsecount[i];
			dist = distance(corpse.origin, self.origin);
			corpse_in_front = self entity_is_in_front_of_me(corpse);
			if (  ((dist < 400 && dist > 150) || corpse.fresh == 1)
				 && !isdefined(level.corpsecount[i].marked) && (self cansee(corpse.seeme) || corpse_in_front == true) )
			{
				self stopanimscripted();
				self notify ("i_found_corpse");
				level.corpsecount[i].marked = true;
				self.animname = "generic";
				self set_run_anim("_stealth_patrol_jog");
				vec = self.origin- corpse.origin;
				nvec = vectornormalize(vec);
				neg = dist - 146;								//146 is offset of canned animation
				factor = neg / length(nvec);  // find out how many times to do the normalized vector
				animspot = spawn ("script_origin", self.origin-(nvec*factor));
				backwardsvec = corpse.origin - self.origin;
				animspot.origin = animspot.origin+(0,0,5);
				//mygroundpos = physicstrace(animspot.origin, animspot.origin+(0,0,-1000));
				//gheight = distance(mygroundpos, animspot.origin);  // make sure we're playing animation on ground
				corpsespot = spawn("script_origin", animspot.origin ) ; // now we know where to play the animation from
				corpsespot.angles = vectortoangles(backwardsvec);
				self endon ("reach_failed");
				self thread corpse_reach_fail(animspot, corpsespot);
				corpsespot anim_reach_solo(self,"_stealth_find_jog");
				corpsespot thread anim_single_solo(self,"_stealth_find_jog");
				wait 5;
				level notify ("corpse_found");
				animspot delete();
				corpsespot delete();
				foundcorpse=true;
				self thread found_corpse_behavior();
				break;
			}		
		}
		wait 0.5;
	}
}

corpse_reach_fail(animspot, corpsespot)
{
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	self endon ("goal");
	wait 8;
	self notify ("reach_failed");
	animspot delete();
	corpsespot delete();
	self thread found_corpse_behavior();
}

found_corpse_notify()
{
	level endon("player_spotted");
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	while(1)
	{
		level waittill ("corpse_found");
		if (!flag("bombers_passing")|| flag("outof_fountain"))
			break;
	}
	wait 2;
	array_thread(level.stealthactors, ::found_corpse_behavior);
}


found_corpse_behavior()
{
	self endon ("death");
	self endon ("i_found_corpse");
	self notify ("started_corpse_found_behavior");
	self endon ("started_corpse_found_behavior");
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	self.animname = "generic";
	initial_reactions = [];
	initial_reactions[0] = "_stealth_look_around2";
	initial_reactions[1] = "_stealth_behavior_generic2";
	initial_reactions[2] = "_stealth_behavior_generic4";
	run_anims = [];
	run_anims[0] = "_stealth_combat_jog";
	run_anims[1] = "_stealth_combat_jog";
	run_anims[2] = "_stealth_combat_jog";
	run_anims[3] = "_stealth_patrol_walk";
	myrunanim = run_anims[randomint(run_anims.size)];
	lastnode = undefined;
	self.animname = "generic";
	self set_run_anim(myrunanim);
	counter = 1;
	while( 1 )
	{
		self.animname = "generic";
		nodes = getnodearray("searching_for_player_nodes"+counter, "script_noteworthy");
		anime = initial_reactions[randomint(initial_reactions.size)];
		if (isdefined(lastnode))
		{
			lastnode anim_single_solo(self, anime);
		}
		else
		{
			self anim_single_solo(self, anime);
		}
			
		for (i=0; i < nodes.size; i++)
		{
			if (!isdefined(nodes[i].isacquired))
			{
				self thread maps\_spawner::go_to_node(nodes[i]);
				if (isdefined(lastnode))
					lastnode.isacquired = undefined;
				nodes[i].isacquired = true;
				self.goalradius = 32;
				wait 0.5;
				self waittill ("goal");
				lastnode = nodes[i];
				counter++;
				break;
			}
		}
		if (counter > 2)
		{
			self anim_single_solo(self, initial_reactions[randomint(initial_reactions.size)]);
			break;
		}
		if (flag("barfight_ison") )
		{
			self solo_set_pacifist(false);
			return;
		}
		
	}
	if (flag("outof_event1"))
	{
		self.animname = "generic";		
		self set_run_anim( "_stealth_patrol_walk");
		
		
		for (i=0; i < level.e1_return_nodes.size; i++)
		{
			if (!isdefined(level.e1_return_nodes[i].seatstaken))
			{
				self thread maps\_spawner::go_to_node(level.e1_return_nodes[i]);
				self.goalradius = 32;
				level.e1_return_nodes[i].seatstaken = true;
				wait 0.5;
				self thread goal_failsafe(20);
				
				self waittill ("goal");
				wait 60;
				self dodamage(self.health*10, (0,0,0));
			}
		}
	}
	else
	{
		self setgoalentity(get_players()[0]);
		self.pacifist = false;
		trig = getent("e1_where_u_goin", "targetname");
		trig trigger_on();
		trig waittill ("trigger");
		shotspot = self gettagorigin("tag_flash");
		magicbullet ("kar98k", shotspot, get_players()[0].origin);
		get_players()[0] dodamage(50, self.origin);
		wait 0.2;
		magicbullet ("kar98k", shotspot, get_players()[0].origin);
		get_players()[0] dodamage(50, self.origin);
		wait 0.2;
		magicbullet ("kar98k", shotspot, get_players()[0].origin);
		get_players()[0] dodamage(50, self.origin);
		wait 0.2;
		magicbullet ("kar98k", shotspot, get_players()[0].origin);
		get_players()[0] dodamage(50, self.origin);
		wait 0.2;
	}
		
}

entity_is_in_front_of_me( target_entity )
{
	// We do this by:
	// 1, Form a line going from left to the right of self.
	// 2. Find the perpendicular vector from this line to the target entity's origin
	// 3. Dot product this vector with self's forward angle
	// 4. If the dot is positive (same direction vectors) it's in front
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	point1 = self.origin; // 2 points needed to determine a line
	right_vector = anglestoright( self.angles );
	point2 = point1 + right_vector;

	vector_to_target = VectorFromLineToPoint( point1, point2, target_entity.origin );

	forward_vector = anglestoforward( self.angles );
	dot_product = vectordot( forward_vector, vector_to_target );

	if( dot_product >= 0 )
	{
		return true;
	}
	return false;
}

isspotting_player()
{
	self endon("death");
	level endon ("player_broke_stealth");
	level endon ("player_broke_stealth_inshop");
	while(1)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			dist = distance(self.origin, players[i].origin);
			player_infront = self entity_is_in_front_of_me(players[i]);
			if (dist < 800 &&  self cansee(players[i]) && player_infront==true)
			{
				if(players[i] getstance() == "stand")
				{
					maps\sniper_event1::stealth_condition_checker();
				}
				else if(players[i] getstance() == "crouch" && dist < 400)
				{
					maps\sniper_event1::stealth_condition_checker();
				}
				else if(players[i] getstance() == "prone" && dist < 150)
				{
					maps\sniper_event1::stealth_condition_checker();
				}
			}
		}
		wait 1;
	}
}
					