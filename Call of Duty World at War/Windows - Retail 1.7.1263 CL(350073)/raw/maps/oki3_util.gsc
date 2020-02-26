#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;



//ent = GetEnt( "myent", "targetname" );
//ai SetGoalPos( ent.origin, ent.angles );  // THE NEW HOTNESS, note the second parameter
//ai waittill( "goal" );  // wait for him to get to the goal area
//ai waittill( "orientdone" );  // wait for him to rotate to the angles you specified

/*------------------------------------
slides open the paper stye doors in the main castle building
------------------------------------*/
open_door(door,direction,move_x,wait_trig)
{
	if(isDefined(wait_trig))
	{
		trigger_wait(wait_trig,"targetname");
	}
	else
	{
		wait(randomfloat(3));
	}
	door1 = getent(door,"targetname");
	if (direction == "r")
	{
		door1 connectpaths();
		if(move_x)
		{
			door1 MoveTo( door1.origin + (56,0,0), randomfloatrange(1,1.5), 0, .05 );
		}
		else
		{
			door1 MoveTo( door1.origin + (0,56,0), randomfloatrange(1,1.5), 0, .05 );
		}
	}
	if(direction == "l")
	{

		door connectpaths();
		if(move_x)
		{
			door1 MoveTo( door1.origin + (-56,0,0), randomfloatrange(1,1.5), 0, .05 );
		}
		else
		{
			door1 MoveTo( door1.origin + (0,-56,0), randomfloatrange(1,1.5), 0, .05 );
		}
	}
}

remove_grenades_from_everyone()
{
	
	//removes grenades from all enemies, everyone!!
	guys = getspawnerarray();
	for(i=0;i<guys.size;i++)
	{
		guys[i].grenadeAmmo = 0;
	}
}


/*--------------------------------------------------
setup the friendlies ,used for start/skipto points
--------------------------------------------------*/
setup_friendlies(area)
{
	spawn_friendlies();
}


/*------------------------------------
spawn in the friendly sqad and set them up
------------------------------------*/
spawn_friendlies()
{
	//spawn in the friendlies
	simple_spawn("squad");

	wait(.35);
	
	//the guy who is going to get sniped later
	pawn = false;
	
	//grab them and set up the hero characters
	guys = get_ai_group_ai("friends");
	for(i=0;i<guys.size;i++)
	{
		
		//remove all their grenades 
		guys[i].grenadeAmmo = 0;
		guys[i].MaxSightDistSqrd = (1500 * 1500);
		if(guys[i].classname == "actor_ally_us_usmc_roebuck"|| guys[i].classname == "actor_ally_us_usmc_polonsky")
		{
			guys[i] thread magic_bullet_shield();
			if(guys[i].classname == "actor_ally_us_usmc_roebuck")
			{
				level.sarge = guys[i];
				guys[i].animname = "sarge";
			}
			else
			{
				level.polonsky = guys[i];
			}
		}
		if(!pawn && guys[i].classname != "actor_ally_us_usmc_roebuck" && guys[i].classname != "actor_ally_us_usmc_polonsky")
		{
			guys[i].script_noteworthy = "sniper_pawn";
			if(randomint(100)>50)
			{
				guys[i].name = "Pvt. Zaring";
			}
			else
			{
				guys[i].name = "Pvt. Pierro";
			}
			level.sniper_pawn = guys[i];
			pawn = true;			
		}					
	}
	level.sarge PushPlayer( true );
	level.polonsky PushPlayer(true);
}

toggle_ignoreall(all)
{
	
	if(isDefined(all))
	{
		guys = getaiarray("allies");
	}
	else
	{
		guys = get_ai_group_ai("friends");
	}
	
	for(i=0;i<guys.size;i++)
	{
		if(guys[i].ignoreall == true)
		{
			guys[i].ignoreall = false;
		}
		else
		{
			guys[i].ignoreall = true;
		}
	} 
	
}


ignoreall_on(guys)
{
	for(i=0;i<guys.size;i++)
	{
		guys[i].ignoreall = true;
	} 	
}

ignoreall_off(guys)
{
	for(i=0;i<guys.size;i++)
	{
		guys[i].ignoreall = false;
	} 	
}


/*------------------------------------
returns a group of spawners
------------------------------------*/
get_spawners(value, key)
{
	
	spawners = getentarray(value,key);	

	guys = undefined;

	for(x=0;x<spawners.size;x++)
	{
		if(!isSentient(spawners[x]))
		{
			guys = add_to_array(guys, spawners[x]);
		}
	}	
	return guys;		
}


/*------------------------------------
moves the players after spawning them in
used in skipto's/starts
------------------------------------*/
move_players(spots)
{

	players = get_players();
	points = getentarray(spots,"targetname");
	if(!points.size > 0)
	{
		points = getstructarray(spots,"targetname");
	}
	
	for(x =0;x<players.size;x++)
	{
		players[x] setorigin(points[x].origin);
		if(isDefined(points[x].angles))
		{
			players[x] setplayerangles( points[x].angles);
		}
	}
	
}

//uses a script_struct like a trigger radius ( keep down those ent counts! )
org_trigger(org,radius,notification)
{
	
	trig = false;
	while(!trig)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if( distancesquared(players[i].origin,org) < radius * radius)
			{
				trig = true;
			}
		}
		wait(.1);
	}
	
	if(isDefined(notification))	
	{
		level notify(notification);
	}
}


/*------------------------------------
moves the ai after spawning them in
used in skipto's/starts
------------------------------------*/
move_ai(spots)
{
	ai = get_ai_group_ai("friends"); //getaiarray("allies");
	if(ai.size < 3)
	{
		ai = getaiarray("allies");
	}
	points = getentarray(spots,"targetname");
	if(!points.size > 0)
	{
		points = getstructarray(spots,"targetname");
	}
	
	sarge_point = undefined;
	polonsky_point = undefined;
	pawn_point = undefined;
	//remove sarge from the array if we've set up node for sarge to start at
	for(i=0;i<points.size;i++)
	{
		if(isDefined(points[i].script_noteworthy) && points[i].script_noteworthy == "sarge")
		{
			sarge_point = points[i];
		}
		if(isDefined(points[i].script_noteworthy) && points[i].script_noteworthy == "polonsky")
		{
			polonsky_point = points[i];
		}
		if(isDefined(points[i].script_noteworthy) && points[i].script_noteworthy == "pawn")
		{
			pawn_point = points[i];
		}		
	}
	
	if(isDefined(sarge_point))
	{
		points = array_remove(points,sarge_point);
		ai = array_remove(ai,level.sarge);
		
		
		level.sarge.anchor = spawn("script_origin",level.sarge.origin);
		level.sarge linkto( level.sarge.anchor);
		level.sarge.anchor moveto(sarge_point.origin,.05);
		level.sarge.anchor waittill("movedone");
		level.sarge.anchor.angles = sarge_point.angles;
		level.sarge unlink();
		level.sarge.anchor delete();
		sarge_point= undefined;
	}
	
	if(isDefined(polonsky_point))
	{
		points = array_remove(points,polonsky_point);
		ai = array_remove(ai,level.polonsky);
		
		
		level.polonsky.anchor = spawn("script_origin",level.polonsky.origin);
		level.polonsky.anchor.angles= level.polonsky.angles;
		level.polonsky linkto( level.polonsky.anchor);
		level.polonsky.anchor moveto(polonsky_point.origin,.05);
		level.polonsky.anchor waittill("movedone");
		level.polonsky.anchor.angles = polonsky_point.angles;
		level.polonsky unlink();
		level.polonsky.anchor delete();
		polonsky_point= undefined;
	}
	
	
	if(isDefined(pawn_point))
	{
		points = array_remove(points,pawn_point);
		ai = array_remove(ai,level.sniper_pawn);
		
		
		level.sniper_pawn.anchor = spawn("script_origin",level.sniper_pawn.origin);
		level.sniper_pawn linkto( level.sniper_pawn.anchor);
		level.sniper_pawn.anchor moveto(pawn_point.origin,.05);
		level.sniper_pawn.anchor waittill("movedone");
		level.sniper_pawn.anchor.angles = pawn_point.angles;
		level.sniper_pawn unlink();
		level.sniper_pawn.anchor delete();
		pawn_point= undefined;
	}
	
	
		
	for(x=0;x<ai.size;x++)
	{
		ai[x].anchor = spawn("script_origin",ai[x].origin);
		ai[x] linkto( ai[x].anchor);
		ai[x].anchor moveto(points[x].origin,.05);
		ai[x].anchor waittill("movedone");
		if(isDefined(points[x].angles))
		{
			ai[x].anchor.angles = points[x].angles;
		}
		ai[x] unlink();
		ai[x].anchor delete();
	}	
}

/*------------------------------------
fake death
self = guy getting worked
------------------------------------*/
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	//if( die )
	//{
	self DoDamage( self.health + 150, self.origin );
	//}
}	


/*------------------------------------
play the bloody fx on a guy
self = the AI on which we're playing fx
------------------------------------*/
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

wait_for_goal(notification)
{
	self endon("death");
	
	self waittill("goal");
	level notify(notification);
}

/*------------------------------------
kill a mans
self = guy
------------------------------------*/
random_death(min,max)
{
	self endon("death");
	
	wait(randomfloatrange(min,max));
	self bloody_death();
}


///*------------------------------------
//setup the drones
//------------------------------------*/
//drones_init()
//{
//	
//	// Setup the drones
//	character\char_jap_rifle::precache();
//	level.drone_spawnFunction["axis"] = character\char_jap_rifle::main;
//	maps\_drones::init();
//	
//}


//manual_fire_mg(mg_script_noteworthy,end_on,start_on)
//{
//
//	level endon(end_on);
//	
//	if(isDefined(start_on))
//	{
//		level waittill(start_on);
//	}
//	mg = getEnt(mg_script_noteworthy, "script_noteworthy");	
//	mg thread maps\_mgturret::burst_fire_unmanned();
//	mg setmode( "auto_nonai" );
//	mg setTurretTeam( "axis" );
//	mg thread mg_think(end_on);
//}
	
//mg_think(endon_notify)
//{
//	
//	level waittill(endon_notify);
//	self setmode("auto_ai");
//	self notify("death");	
//}	


/*------------------------------------
make sure the players run into the bunker
and stay there 
------------------------------------*/
check_players_in_bunker()
{
	
	players = get_players();
	bunkers = getentarray("bunker_volume","targetname");
	shock_time = 8 * 1000;
	
	//go thru all the players and check to see if they are 
	//inside the bunker
	for(i=0;i<players.size;i++)
	{
		player = players[i];
		player_safe = false;
		
		//unsafe_players = [];

		if( !IsDefined( player.shocked_time ) )
		{
			player.shocked_time = 0;			
		}

		for(x =0;x<bunkers.size;x++)
		{
			if( player isTouching(bunkers[x]))
			{
				player_safe = true;
			}
		}

		if(!player_safe)
		{
			
			if( GetTime() > player.shocked_time )
			{
				player.shocked_time = GetTime() + shock_time;
				
				ent = spawnstruct();
				ent.origin = player.origin;
				ent.is_struct = true;
				min_dmg = 25;
				max_dmg = 50;
				dmg_mod = 1;
				for(q=0;q<players.size;q++)
				{
					if(players[q] != player && distance(players[q].origin,ent.origin) <256)
					{
						dmg_mod ++;
					}
					
				}
				
				min_dmg = min_dmg /dmg_mod;
				max_dmg = max_dmg /dmg_mod;
				
				if(!isDefined(player.not_in_bunker))				
				{
					ent thread maps\_mortar::explosion_activate( "first_mortar", 256, min_dmg, max_dmg, 0.2, 3, 512 );
				}
			}

		}

	}
	
}


get_players_in_bunker()
{
	
	players = get_players();
	bunkers = getentarray("bunker_volume","targetname");
	
	guys = [];
	
	for(i=0;i<players.size;i++)
	{
		player = players[i];

		for(x =0;x<bunkers.size;x++)
		{
			if( player isTouching(bunkers[x]))
			{
				guys[guys.size] = player;
			}
		}
	}
	return guys;
	
}


empty_spawners(guys)
{
	spawners = getentarray(guys,"targetname");
	if(isDefined(spawners))
	{
		for(i=0;i<spawners.size;i++)
		{
			if(!isSentient(spawners[i]))
			{
				spawners[i] delete();
			}
		}
	}
}


/*------------------------------------
set stances on the friendlies
------------------------------------*/
set_friendly_stances(a,b,c)
{
	friends = get_ai_group_ai("friends");

	for(i=0;i<friends.size;i++)
	{
		
		if(isDefined(a))
		{
			if(isDefined(b))
			{
				if(isDefined(c))
				{
					friends[i] allowedstances(a,b,c);
				}
				else
				{
					friends[i] allowedstances(a,b);
				}
			}
			else
			{
				friends[i] allowedstances(a);
			}
		}		
	}
}

set_friendly_poses()
{
	
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		ai[i] allowedstances("stand");
		ai[i].a.pose = "stand";
	}
	
}

/*------------------------------------
plays dialogue/animation on a guy
------------------------------------*/
do_dialogue(dialogue ,aname,anim_node,lookTarget)
{

	if(self == level.sarge)
	{
		aname = "sarge";
	}
	else if(self == level.polonsky)
	{
		aname = "polonsky";
	}
	else
	{
		self.old_animname = self.animname;		
	}
	self.animname = aname;
	if(isDefined(anim_node))
	{
		anim_node anim_single_solo( self, dialogue );
	}
	else
	{

		self thread maps\_anim::anim_facialFiller( "dialogue_done", lookTarget );
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound[aname][dialogue], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
	}
	if(isdefined(self.old_animname))
	{
		self.animname = self.old_animname;
	}
	
}

/*------------------------------------
do animation/dialogue on random non-hero character
------------------------------------*/
do_redshirt_dialogue(dialogue,trig)
{
	guys = getaiarray("allies");
	redshirts = undefined;
	redshirt = undefined;
	
	for(i=0;i<guys.size;i++)
	{
		if(guys[i] != level.sarge && guys[i] != level.polonsky)
		{
			if(isDefined(trig))
			{
				if(guys[i] istouching(getent(trig,"targetname")))
				{
					add_to_array(redshirts,guys[i]);
				}
			}
			else
			{
				add_to_array(redshirts,guys[i]);
			}
			
		}
	}
	
	if(isDefined(redshirts))
	{
		redshirt = redshirts[randomint(redshirts.size)];
	}
	if(isDefined(redshirt))
	{		
		redshirt thread do_dialogue(dialogue,"redshirt");		
	}
}


//trim_dialogue(dialogue,aname)
//{
//	
//	strng = level.scr_sound[aname][dialogue];
//	newstr = "";
//	for(x=strng.size -1;x>5;x--)
//	{
//		newstr = strng[x] + newstr;
//	}	
//	return (newstr);
//	
//}

///*------------------------------------
//USED WITH SQUAD_MANAGER TO 
//MONITOR WAVES OF GUYS
//------------------------------------*/
//monitor_squads(guys,maxWaves,strEndon)
//{
//	level endon(strEndon);
//	
//	waves = 0;
//	while(waves < maxWaves)
//	{
//		level waittill(guys + " min threshold reached");
//		waves++;
//	}
//	level notify(strEndon);		
//}

/*------------------------------------

------------------------------------*/
#using_animtree ("supply_drop");
do_supply_drop(drop,plane)
{
	//grab and hide the supply drop that lands in the bunker
	//landed_drop = getent("bunker_chute_landed","targetname");
	//landed_drop hide();
		
	supply_drop = getent("supply_drop" + drop, "targetname");
	org1 = supply_drop.origin;
	
	if(drop == 4)
	{
		org1 = supply_drop.origin;//(5717.5, 3154.5, -754);//supply_drop.origin;
	}
	
	supply_drop.origin = plane.origin;	
	supply_drop show();
	supply_drop.animname = "drop";
	supply_drop useanimtree(#animtree);
	
	supply_drop moveto( org1 + (0,0,-80) , randomfloatrange(3.5,5) );
	supply_drop waittill("movedone");
	supply_drop notify("stop_looping");
	
	supply_drop playsound("supply_box_land");
	
	the_anim = undefined;
	chance = randomint(100);
	if(chance > 50)
	{
		the_anim = level.scr_anim["drop"]["landing"];
	}
	else
	{
		the_anim = level.scr_anim["drop"]["landingb"];
	}
	
	supply_drop SetFlaggedAnimKnobRestart( "drop_landing", the_anim, 1.0, 0.2, 1.0 );
	wait(5);
	supply_drop delete();
	
}



/*------------------------------------
temp until animation gets done
------------------------------------*/
#using_animtree ("supply_drop");
do_drop_idle_anim()
{
	//self.animname = "drop1";
	self useanimtree(#animtree);
	self endon("movedone");
	self endon("stop_looping");
	while(1)
	{
		self maps\_anim::anim_single_solo(self,"drop");
		self waittill("single anim");
	}
}

/*------------------------------------
Check to see if the attacker is one of the players
attacker = entitiy
------------------------------------*/
is_player(attacker)
{
	players = get_players();
	attackerIsPlayer = false;
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if( attacker == player )
		{
			attackerIsPlayer = true;
			break;
		}
	}
	
	return attackerIsPlayer;
}

/*------------------------------------
give the user a hint to show the airstrike
------------------------------------*/
air_strike_user_notify()
{

	self endon("death");
	self endon("disconnect");
	
	//removed the icon
	//self thread do_airstrike_hud_elem();
			
	text = &"OKI3_AIRSTRIKE_HOWTO";
	
	self setup_client_hintelem();
	self.hintelem setText(text);
	wait(3.5);
	self.hintelem settext("");

}

do_airstrike_hud_elem()
{
	self endon("death");
	self endon("disconnect");	
	
	
	elem = newclienthudelem(self);
	
	
	elem.x = 280; 
	elem.y = 240; 
	elem.alpha = 0; 
		
	//elem.horzAlign = "fullscreen"; 
	//elem.vertAlign = "fullscreen"; 
	elem.foreground = true; 
	elem SetShader( "hud_icon_airstrike", 64, 64); 

	// Fade into white
	elem FadeOverTime( 0.2 ); 
	elem.alpha = 1; 
	
	
	wait 5;
	
	elem MoveOverTime( 1.5 );
	elem.y = 420;
	elem.x = elem.x + 80;
	elem ScaleOverTime( 1.5, 8, 8 ); 
	
	wait 2;
	
	elem FadeOverTime( 0.2 ); 
	elem.alpha = 0;
	wait 0.2;
	elem destroy();
}


/*------------------------------------
wait for player to use the mortars in the pits ------------------------------------*/
mortar_round_think(trig)
{
	self endon("stop_thinking");
	ent = getent("use_mortars_" + trig,"targetname");
	ent sethintstring(&"OKI3_USE_MORTAR");
	ent thread mortar_hint();
	while(1)
	{
		ent waittill("trigger",user);
		
		//fix berzerker collectible issue
		if(isDefined(user.collectibles_berserker_mode_on) && user.collectibles_berserker_mode_on )
		{
			continue;
		}
		else
		{
			//prevent mortar spamming
			if(!isDefined(user.hasmortar))
			{
				user GiveWeapon( "mortar_round" );
  				user SwitchToWeapon( "mortar_round" );
  				user setweaponammoclip("mortar_round",1);
  				user allowMelee(false);
  				user thread watch_mortar_weapon();
  				user thread watch_player_mortar_death();
			}
		}
	}
}


watch_player_mortar_death()
{
	self endon("disconnect");
	self endon("mortar_dropped");
	
	self waittill("death");
	
	self allowMelee(true);
	self.hasmortar = undefined;

	
}

watch_mortar_weapon()
{
	self endon("death");
	self endon("disconnect");	
	self endon("mortar_dropped");
		
	self.disableBerserker = true;
	while ( self getcurrentweapon() != "mortar_round")
	{
		wait_network_frame();
	}
	
	while( self getcurrentweapon() == "mortar_round" || self getcurrentweapon() == "none" )
	{
		self.hasmortar = true;
		if(!isDefined(self.mortar_hint_given))
		{
			self thread hud_mortar_hint();
			self.mortar_hint_given = true;
		}
		wait_network_frame();
	}
	if(self getcurrentweapon() != "syrette")
	{
		self takeweapon("mortar_round");
	}
	
	self allowMelee(true);
	dropped = true;
	self.hasmortar = undefined;
	self.disableBerserker = undefined;
	//self SetClientDvar( "ammoCounterHide", "0" );
	self notify("mortar_dropped");	
}

hud_mortar_hint()
{
	self endon("death");
	self endon("disconnect");
	
	text = &"OKI3_MORTAR_HINT";
	
	self setup_client_hintelem();
	self.hintelem setText(text);
	wait(5);
	self.hintelem settext("");
}





/*------------------------------------
notify a trigger
------------------------------------*/
trigger_array_notify(no_wait)
{
	if(!isDefined(no_wait))
	{
		wait(randomfloat(2));
	}
	self notify("trigger");
}

mortar_hint()
{
	level endon ("mortar_hint_given");
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if(isAlive(players[i]) && distancesquared(players[i].origin, self.origin) < 256 * 256)
			{
				if(isDefined(level.sarge))
				{
					level.sarge thread do_dialogue("mortar_nag" +randomint(2));
					level notify("mortar_hint_given");
					break;
				}
			}
		}
		wait(1);
	}	
}
//----------------------------------
//SQUAD LEADER STUFFS
//----------------------------------

/*------------------------------------
treat a group of enemies as a squad by 
assigning a leader to one of them
------------------------------------*/
squad_leader_manager(guys)
{
	if(isDefined(guys))
	{
		//select the leader
		leader = select_leader(guys);
		if(isDefined(leader))
		{
			//remove the leader from the array so we only track the followers
			guys = array_remove(guys,leader);
			leader thread debug_leader();
			
			//monitor the leader to see where he goes
			leader thread monitor_leader();
			
			//allow other guys in the squad to be promoted to leader if the leader dies
			level thread squad_promotion(guys,leader);
			
			//make the guys follow the leader
			for(i=0;i<guys.size;i++)
			{
				guys[i].goalradius = 256;
				guys[i] thread follow_the_leader(leader);
			}
		}
	}
}


/*------------------------------------
makes a guy follow the leader
self = guy following
------------------------------------*/
follow_the_leader(leader)
{
	self endon("death");
	level endon("new leader");
	
	while(isDefined(leader) && isAlive(leader))
	{
		//wait until the leader gets a new node that
		//is far away, then go to where the leader is going		
		leader waittill("node_changed",new_org);
		if(distancesquared(new_org,self.origin) > 384*384)
		{
			self notify("new_position");
			self thread goto_new_position(new_org);
		}	
	}
}

/*------------------------------------
makes the guy run to a new position
self = guy following the leader
------------------------------------*/
goto_new_position(new_org)
{
	self endon("new_position");
	self endon("death");
	
	self.goalradius = 256;
	self setgoalpos(new_org);
	self.ignoreall = true;
	self waittill("goal");
	self.ignoreall = false;
	self findcovernode();

}

/*------------------------------------
monitors for the leader to choose a new position
------------------------------------*/
monitor_leader()
{
	self endon("death");
	
	//make sure the leader always has a large goalradius
	self.goalradius = level.default_goalradius;
		
	while(1)
	{	
		//check to see if the leader has a node already
		if(isDefined(self.node) && isDefined(self.node.origin))
		{
			self.a.old_node_origin = self.node.origin;
		}
		wait(.25);
		
		//check to see if the leader  wants to run to a new node which is farther than 128 units away from his current position.
		if(isDefined(self.node) && isDefined(self.node.origin) && isDefined(self.a.old_node_origin))
		{
			if( self.a.old_node_origin != self.node.origin && distancesquared(self.node.origin,self.origin) > 128*128)
			{
				self notify("node_changed",self.node.origin);
			}
		}	
	}
}


/*------------------------------------
promote a new guy to a leader when the old 
leader gets killed
------------------------------------*/
squad_promotion(guys,leader)
{
	squadname = guys[0].script_aigroup;
	
	//wait until the leader kicks it
	leader waittill("death");
	
	//grab all the guys left in the squad and pick a new leader if there are more than 1
	guys = get_ai_group_ai(squadname);
	level notify("new leader");
	
	if(isDefined(guys) &&  guys.size > 1)
	{
		iprintln("promoting a new leader for " + squadname );	
		level thread squad_leader_manager(guys);
	}
}

/*------------------------------------
select the leader from the guys
------------------------------------*/
select_leader(guys)
{
	leader = undefined;
	for(i=0;i<guys.size;i++)
	{
		//if the guy is an officer or has a script_noteworthy of "leader" , he will be a squad leader
		if(issubstr(guys[i].classname,"officer") || isDefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "leader")
		{
			leader = guys[i];
			break;
		}
	}
	if(!isDefined(leader))
	{
		leader = guys[randomint(guys.size)];
	}
	return leader;
	
}

/*------------------------------------
show the leader
------------------------------------*/
debug_leader()
{
/#

	self endon("death");
	while( 1 )
	{	
		print3d( self.origin + ( 0, 0, 32 ), "leader" );
		wait( 0.05 );
	}
	
#/
}


/*------------------------------------
throws smoke grenades over the wall
to kick off the spiderhole ambush
------------------------------------*/
throw_smoke_from_pos( force,start_pos )
{
	
	wait(randomfloatrange(.1,1.0));
	
	smoke = self;
	
	if(isDefined(start_pos))
	{
		smoke = getstruct(start_pos,"targetname");
	}
	
	throw_force = 980;
	if(isDefined(force))
	{
		throw_force = force;
	}
	smoke1 = spawn("script_origin",smoke.origin);
	smoke1.angles = smoke.angles;
	
	
	
	forward = AnglesToForward( smoke1.angles );
	target_pos = smoke1.origin + vectorscale( forward, throw_force );

	///////// Math
	gravity = GetDvarInt( "g_gravity" );
	gravity = gravity * -1;

	dist = Distance( smoke1.origin, target_pos );
	time = 1;

	delta = target_pos - smoke1.origin;
	drop = 0.5 * gravity * ( time * time );
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
	/////////
	
	smoke1 thread smoke_trailFX();
	smoke1 MagicGrenadeType( "m8_white_smoke_light", smoke1.origin, velocity, 3 );
	//smoke1 MagicGrenadeType( "fraggrenade", smoke1.origin, velocity, 3 );
	
}

smoke_trailFX()
{
		self waittill ( "grenade_fire", grenade, weaponName );
		{
			ent = spawn("script_model",grenade.origin);
			ent.angles = grenade.angles;
			ent setmodel("tag_origin");
			ent linkto(grenade);
			playfxontag(level._effect["smoke_grn_trail"],ent,"TAG_ORIGIN");
			wait(5);
			ent delete();
		}
}


/*------------------------------------
put a guy into banzai mode
------------------------------------*/
setup_banzai_guys(no_wait)
{
	self endon("death");
	
	if(!isDefined(no_wait))
	{
		no_wait = false;
	}
	
	if(!no_wait)
	{
		wait(3);
	}
	
	self maps\_banzai::banzai_force();

}

//stolen from MikeD
// Returns a random element from the given array
get_random( array )
{
	return array[RandomInt( array.size )]; 
}

// Sets up the AI for force gibbing
set_random_gib()
{
	refs = [];
	refs[refs.size] = "right_leg";
//	refs [refs.size] = "head";
	//refs[refs.size] = "left_leg"; 
	refs[refs.size] = "right_arm";
	//refs[refs.size] = "left_arm";
	refs[refs.size] = "guts";
	
	//refs[refs.size] = "no_legs"; 

	self.a.gib_ref = get_random( refs );
}



/*------------------------------------
wait for the spiderholes to open, then play a sound

TODO - fix the deleting stuff, it should look better

------------------------------------*/
init_spiderholes()
{
	level.no_spider_lid_drop = true;
	ents = getentarray("spiderhole_lid","script_noteworthy");
	array_thread(ents,::monitor_spiderhole_lid);	
}


monitor_spiderhole_lid()
{
	//self endon("guy_dead");
	
	self waittill("emerge");
	self playsound("spider_hole_open");

	self waittill("out_of_spiderhole");
	wait(3);
	self unlink();
	if(isDefined(self.tag_lid))
	{
		self.tag_lid delete();
	}
	self notsolid();
	self moveto(self.origin + (0,0,-200),8);
	self waittill("movedone");
	self delete();


}

/*------------------------------------
picks a ranom non-hero friendly AI 
who is within range of a specific target.
Can optionally pass in someone to exclude from the selection as well
------------------------------------*/
choose_random_redshirt(target,dist_from_target,excluder)
{
	
	guys = getaiarray("allies");
	targ = getent(target,"targetname");
	
	excluded_guy = level.sarge;
	
	if(isDefined(excluder))
	{
		excluded_guy = excluder;
	}
	
	for(i=0;i<guys.size;i++)
	{

		if(guys[i] != level.polonsky && guys[i] != level.sarge && guys[i] != excluded_guy)
		{
			if(distance ( guys[i].origin,targ.origin) < dist_from_target)
			{
				return guys[i];
			}
		}
	}
	
}



choose_random_guy()
{
	
	guys = getaiarray("allies");
		
	excluded_guy = level.sarge;

	for(i=0;i<guys.size;i++)
	{

		if(guys[i] != level.polonsky && guys[i] != level.sarge)
		{
			if(!isDefined(guys[i].notme))
			{
				return guys[i];
			}
		}
	}
		
}

/*------------------------------------
spawn in guys thru script. 
------------------------------------*/
simple_spawn( name, spawn_func ,delay)
{
	
	spawners = getEntArray( name, "targetname" );
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}

	ai_array = [];

	for( i = 0; i < spawners.size; i++ )
	{
		
		if( i % 2)
		{
			//wait for a new network frame to be sent out before spawning in 
			//another guy
			wait_network_frame();
		}
		
		// check if we want to forcespawn him
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			ai = spawners[i] StalingradSpawn(); 
		}
		else
		{
			ai = spawners[i] DoSpawn(); 
		}		
		
		spawn_failed( ai );
		
		// for debug purposes (so entinfo displays their name)
		if( isdefined( ai ) )
		{
			ai.targetname = name + "_alive";
			if(isDefined(spawners[i].script_noteworthy))
			{
				ai.script_noteworthy = spawners[i].script_noteworthy;
			}
		}
		
		ai_array = add_to_array( ai_array, ai );
	}
	
	return ai_array;

}

simple_floodspawn(name)
{
	
	defenders = getentarray(name,"targetname");
	
	for(i=0;i<defenders.size;i++)
	{
		if(i % 2)
		{
			wait_network_frame();
		}
		defenders[i] thread maps\_spawner::flood_spawner_think();
	}	
	
}

/*------------------------------------
sets the players ammo loadout at the beginning of the map
------------------------------------*/
set_player_ammo_loadout()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{			
		//take away all ammo/grenades...these guys had it rough
		players[i] SetWeaponAmmoClip( "thompson", 0 );
		players[i] SetWeaponAmmoClip( "m1garand", 0 );
		players[i] SetWeaponAmmoStock( "thompson", 0 );
		players[i] setweaponammostock( "m1garand",0);
		players[i] setweaponammostock("fraggrenade",0);
		players[i] setweaponammoclip("fraggrenade",0);
		players[i] setweaponammostock("m8_white_smoke",0);
		players[i] setweaponammoclip("m8_white_smoke",0);
		players[i] setweaponammoclip("air_support",0);
		players[i] setweaponammostock("air_support",0);
		players[i] takeweapon("thompson");
		players[i] takeweapon("air_support");

		//make sure all this stuff is turned on
		players[i] setclientDvar("miniscoreboardhide","0");
		players[i] setclientDvar("compass","1");
		players[i] SetClientDvar( "hud_showStance", "1" ); 
		players[i] SetClientDvar( "ammoCounterHide", "0" );
	
	}
}


/*------------------------------------
warps all players to script_struct markers
exclude = player to not warp
------------------------------------*/
warp_players(warpto_positions,exclude)
{
	ents = getstructarray(warpto_positions,"targetname");
	
	if(ents.size == 0)
	{
		ents = getentarray(warpto_positions,"targetname");
	}
	
	assertex(isDefined(ents.size > 0), "no warpto positions found");
	
	players = get_players();	
	count = 0;
	for(i=0;i<players.size;i++)
	{
		if(isDefined(exclude))
		{
			if(  players[i] != exclude )
			{
				players[i] warp_player( ents[count] );
				count++;
			}
		}
		else
		{
			players[i] warp_player( ents[count] );
			count++;
		}
	}
	
	set_breadcrumbs(ents);	
}


/*------------------------------------
warp a player to a new position when playing
co-op. 
------------------------------------*/
warp_player(pos)
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(self.warpblack))
	{
		self.warpblack = NewClientHudElem( self ); 
		self.warpblack.x = 0; 
		self.warpblack.y = 0; 
		self.warpblack.horzAlign = "fullscreen"; 
		self.warpblack.vertAlign = "fullscreen"; 
		self.warpblack.foreground = false;
		self.sort = 50;
		self.warpblack.alpha = 0; 
		self.warpblack SetShader( "black", 640, 480 );	
	}
	self.warpblack FadeOverTime( .75 ); 
	self.warpblack.alpha = 1;
		
	wait(.75);
	self setorigin(pos.origin);
	if(isDefined(pos.angles))
	{
		self setplayerangles( pos.angles);
	}
	self.warpblack FadeOverTime( .75 ); 
	self.warpblack.alpha = 0;
		
}


hud_fade_to_black(time)
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(time))
	{
		time = 1;
	}	
	if(!isDefined(self.warpblack))
	{
		self.warpblack = NewClientHudElem( self ); 
		self.warpblack.x = 0; 
		self.warpblack.y = 0; 
		self.warpblack.horzAlign = "fullscreen"; 
		self.warpblack.vertAlign = "fullscreen"; 
		self.warpblack.foreground = false;
		self.warpblack.sort = 50;
		
		self.warpblack.alpha = 0; 
		self.warpblack SetShader( "black", 640, 480 );	
	}
	self.warpblack FadeOverTime( time ); 
	self.warpblack.alpha = 1;	
}

hud_fade_in(time)
{
	self.warpblack FadeOverTime( time ); 
	self.warpblack.alpha = 0;
}


/*------------------------------------
resest the run /combat anims back to default
------------------------------------*/
reset_run_anim()
{
	self endon ("death");
	
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}


/*------------------------------------
monitors a goal volume for enemies, can optionally
send out a level notification and a trigger notify 
when the volume is empty
------------------------------------*/

monitor_volume_for_enemies(volume,level_notify,auto_trigger)
{
	
	volume = getent(volume,"targetname");
	guys_dead = false;
	
	while(!guys_dead && isDefined(volume) )
	{
		count = 0;		
		ai = getaiarray("axis");
		for(i =0;i<ai.size;i++)
		{
			
			if( ai[i] istouching(volume))
			{
				count++;
			}
		}
		
		if(count == 0)
		{
			guys_dead = true;
		}
		
		wait(1);
	}
	
	if(isDefined(level_notify))
	{
		level notify(level_notify);
	}
	
	if( isDefined(auto_trigger) && auto_trigger == "mortarpits_front_chain")
	{
		ent = getent("mortar_block","targetname");
		if(isDefined(ent))
		{
			ent connectpaths();
			ent delete();		
		}
	}
	
	if(isDefined(auto_trigger))
	{
		trig = getent(auto_trigger,"targetname");
		trig notify("trigger");
	}
	
}

/*------------------------------------
sends a guy to a new node and gives him a new 
goalvolume
------------------------------------*/
guy_retreats(target_node,new_goalvolume)
{
	self endon("death");
	
	self.goalradius = 32;
	self.script_goalvolume = new_goalvolume;
	self setgoalnode(target_node);
	self.pacifist = true;
	self thread retreat_interrupt();
	self waittill("goal");
	self.goalradius = 1024;
	self.pacifist = false;
}



retreat_interrupt()
{

  self notify( "stop_fallback_interrupt" );
  self endon( "stop_fallback_interrupt" );
  self endon( "goal" );
  self endon( "death" );    

  while(1)
  {
    origin = self.origin;
    wait 2;
    if ( self.origin == origin )
    {
       self.pacifist  = false;
       self.goalradius = 64;
       self thread charge_at_players();
       return;
     }
   }
}


charge_at_players()
{
	self endon("death");
	while(1)
	{
		self setgoalentity( get_closest_player(self.origin) );
		wait(3);
	}
}



// Sets the players movement speed.
set_player_speed( player_speed, time )
{
	self notify( "stop_set_player_speed" ); 
	self endon( "stop_set_player_speed" ); 

	base_speed = 180; 
	level.player_speed = player_speed; 

	if( !IsDefined( time ) )
	{
		time = 0; 
	}

	steps = abs( int( time * 4 ) ); 

	target_speed_scale = player_speed / base_speed; 

	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread set_player_speed_internal( target_speed_scale, steps ); 
	}
}

set_player_speed_internal( target_speed_scale, steps )
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self notify( "stop_set_player_speed" ); 
	self endon( "stop_set_player_speed" ); 

	if( !IsDefined( self.move_speed_scale ) )
	{
		self.move_speed_scale = 1; 
	}

	// Don't set the speedscale if it's already set to it
	if( self.move_speed_scale == target_speed_scale )
	{
		return; 
	}

	difference = self.move_speed_scale - target_speed_scale; 

	for( i = 0; i < steps; i++ )
	{
		self.move_speed_scale -= difference / steps; 
		self SetMoveSpeedScale( self.move_speed_scale ); 
		wait( 0.5 ); 
	}

	self.move_speed_scale = target_speed_scale; 
	self SetMoveSpeedScale( self.move_speed_scale ); 
}


//random_path_up_stairs()
//{
//	
//	trig = getent("take_random_path","targetname");
//	while(1)
//	{
//			trig waittill("trigger",user);
//			user thread take_random_path();
//			wait(1);
//	}
//	
//}
//
//take_random_path()
//{
//	
//	self endon("death");
//	desired_goalpos = self.goalpos;
//	paths = getnodearray("stairs_paths","targetname");
//	
//	self.goalradius = 32;
//	goal = paths[randomint(paths.size)];
//	self setgoalnode(goal);
//	self waittill("goal");
//	at_pos = false;
//	while(!at_pos)
//	{
//		while(distance(self.origin,goal.origin) > 32)
//		{
//			wait(.05);
//		}
//		new_node = getnode(goal.target,"targetname");
//		self setgoalnode(new_node);
//		while(distance(self.origin,new_node.origin) > 32)
//		{
//			wait(.05);
//		}
//		at_pos = true;
//		wait(1);
//	}
//	
//	self setgoalpos(desired_goalpos);
//}


/*------------------------------------
guy jumps off his mortar and take cover
------------------------------------*/
mortar_guy_alert()
{
		
		self endon("death");
		
		node = getnode(self.target,"targetname");
		trig = undefined;
		ents = getentarray(self.target,"targetname");
		for(i=0;i<ents.size;i++)
		{
			if(ents[i].classname == "trigger_radius")
			{
				trig = ents[i];
			}
		}
		
		if(isDefined(trig))
		{
			trig = getent(self.target,"targetname");
			trig waittill("trigger");
			goto_node = getnode(trig.target,"targetname");
								
			node notify("stop_mortar");
			self stopanimscripted();
				
			if(isDefined(self.mortarAmmo) && self.mortarAmmo)
			{
				self detach(level.prop_mortar_ammunition, "TAG_WEAPON_RIGHT");
				self.mortarAmmo = false;
			}
			self.goalradius = 8;
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );
			self setgoalnode(goto_node);
			self.pacifist = false;
			self.ignoreall = false;
			self.ignoreme = false;
		}
		
}


kill_beginning_guys()
{
	group1 = get_ai_group_ai("forward_squad");	
	array_thread(group1,maps\oki3_util::bloody_death);
}


rush_player()
{
	self endon("death");
	
	self.goalradius = 256;
	while(isAlive(self))
	{
		self SetGoalEntity( get_closest_player(self.origin) ); 
		wait(5);
		if(self.goalradius > 128)
		{
			self.goalradius = self.goalradius - 64;
		}

	}
}


sniper_leafy_conceal()
{
	
	trees = getstructarray( "treesniper_origin", "targetname" );
	
	for(i=0;i<trees.size;i++)
	{
		wait(.15);
		// play the looping fx of fronds that hide the tree sniper
		model_tag_origin = spawn( "script_model", trees[i].origin + (-50,80,0));

		model_tag_origin setmodel("tag_origin");
		//model_tag_origin linkto( trees[i], "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );	
		trees[i].tag_origin = model_tag_origin;
		
		trees[i] thread tree_fx();
	}
}

/*------------------------------------
palm fronds that fall from treetops when the snipers kick off
------------------------------------*/
tree_fx()
{
	
	flag_wait( "do_tree_fx" );
	wait(randomfloatrange(0.1,5));
	
	// delete the looping fx
	self.tag_origin delete();
	
	playfx( level._effect["sniper_leaf_canned"], self.origin );	
	
}


//HUD STUFF FOR SHOWING HINTS

init_tunnel_hint()
{
	players = get_players();
	array_thread(players,::setup_client_hintelem);
}


// Tell the player to go prone during tunnel crawl

setup_client_hintelem()
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(self.hintelem))
	{
		self.hintelem = newclienthudelem(self);
	}
	self.hintelem init_hint_hudelem(320, 220, "center", "bottom", 1.3, 1.0);
}

hint_trigger_think()
{
	
	level endon("stop_hint");
	trig = getent( "show_prone","targetname");
	while(1)
	{
		trig waittill("trigger",ent);
		ent give_hint(&"OKI3_HINT_PRONE", "crouch");
	}
}

give_hint(text, stance)
{
	self endon("death");
	self endon("disconnect");	
	

	self thread watch_hint_stance(stance,text);
}

watch_hint_stance(stance,text)
{
	
	self endon("death");
	self endon("disconnect");
	hintshown = false;
	while( self getstance() != stance )
	{
		wait(.05);
		if(!hintshown)
		{
			self.hintelem setText(text);
			hintshown = true;
		}
	}
	
	wait(.5);
	
	self.hintelem setText("");
	
}

init_hint_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	//self.font = "objective";
}






/////////////////////
////
//// Protect the grass guys from all damage except from the player
////
/////////////////////////////////
//
//grass_surprise_half_shield( delay_time )
//{
//
//	level endon( "stop_grass_half_shields" );
//	
//	self thread grass_camo_halfshield_delay( delay_time );
//	
//	self.pel2_real_health = self.health;
//	self.health = 10000;
//	
//	attacker = undefined; 
//	
//	while( self.health > 0 )
//	{
//		
//		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
//		
//		type = tolower( type );
//		
//		// if it's not the player, and also a bullet weapon (non-player friendlies should still be able to kill them with their grenades)
//		if( !isplayer(attacker) && issubstr( type, "bullet" ) )
//		{
//			//iprintln( "attacked by non-player!" );
//			self.health = 10000;  // give back health for these things	
//		}
//		else
//		{
//			self.health = self.pel2_real_health;
//			self dodamage( amount, (0,0,0) );
//			self.pel2_real_health = self.health;
//			// put ff shield back on
//			self.health = 10000;
//		}
//	}	
//	
//}
//
//
//
//grass_camo_ignore_delay( wait_time )
//{
//	self endon( "death" );
//
//	wait( wait_time );
//	self.ignoreme = 0;
//}
//
//
//
//grass_camo_halfshield_delay( delay_time )
//{
//	self endon( "death" );
//
//	wait( delay_time );
//	level notify( "stop_grass_half_shields" );
//	self.health = self.pel2_real_health;
//}



grass_surprise_damage( which_flag )
{

	level endon( which_flag );

	while( 1 )
	{

		 self waittill( "damage", amount, attacker );
	 
		 // POLISH: if player throws a grenade into the grass, it should kill the dudes, not just alert them and stop their MBS
		if( isplayer( attacker ) )
		{
			flag_set( which_flag );
		}
	
	}

}

//// Conserva's fix for prone-to-run banzai transition. should be added in _anim at some point?
//old_play_anim_end_early( the_anim, how_early )
//{
//	self animscripted( "anim single", self.origin, self.angles, the_anim  );			
//	animtime = getanimlength( the_anim  );
//	
//	animtime -= how_early;
//	wait(animtime);
//	 
//	self stopanimscripted();
//}

/*------------------------------------
sWaittill = level notification sent out by sm to spawn a new group of guys
squadname = the name of the squad for sm to use
a,b,c = script_noteworthy value on the spawners to determine which 'squads' to use as spawners for sm
------------------------------------*/
squad_manager_think(sm_notify,tgtname,sEndon,sWaittill,squadname,a,b,c)
{	
	level endon(sEndon);
	
	while(1)
	{
		squads = [];
		squads[0] = "squad_a";
		if(isDefined(b))
		{
			squads[1] = "squad_b";
		}
		if (isDefined(c))
		{
			squads[2] = "squad_c";
		}
		
		noteworthy = squads[randomint(squads.size)];
		
		//turn off all spawners first
		og_spawners = getspawnerarray();
		for(i=0;i<og_spawners.size;i++)
		{
			if(isDefined(og_spawners[i].targetname) && og_spawners[i].targetname == tgtname)
			{
				if(isDefined(og_spawners[i].script_squadname))
				{
					og_spawners[i].script_squadname = undefined;
				}
				if(isDefined(og_spawners[i].script_noteworthy) && og_spawners[i].script_noteworthy == noteworthy)
				{
					og_spawners[i].script_squadname = squadname;
				}
			}
		}
		if(isDefined(sm_notify))
		{
			level notify(sm_notify);
		}
		
		level waittill(sWaittill);
	}
}


set_goal_to_nearest()
{
	self endon("death");	
	
	while(issentient(self))
	{
		
		players = get_players(); 
		squad = getaiarray( "allies" ); 
		combined = array_combine( players, squad ); 
		
		guy = get_closest_living( self.origin, combined ); 
		if(isDefined(guy))
		{
			self setgoalpos(guy.origin);
		}
		wait(3);
		if(self.goalradius > 128)
		{
			self.goalradius = self.goalradius - 128;
		}
		
	}
}

#using_animtree("generic_human");
flamedeath(attacker)
{
	anima[0] = %ai_flame_death_a;
	anima[1] = %ai_flame_death_b;
	anima[2] = %ai_flame_death_c;
	anima[3] = %ai_flame_death_d;
	
	self.deathanim = anima[randomint(anima.size)];			
	self thread death_flame_fx();
	self dodamage(self.health + 100, self.origin,attacker);
	wait(3);
	self StartTanning();	
}

/*------------------------------------
play some flame effects on the guys in the bunker 
who burn up
------------------------------------*/
death_flame_fx()
{
	tagArray = [];
	tagArray[tagArray.size] = "J_Wrist_RI";
	tagArray[tagArray.size] = "J_Wrist_LE";
	tagArray[tagArray.size] = "J_Elbow_LE";
	tagArray[tagArray.size] = "J_Elbow_RI";
	tagArray[tagArray.size] = "J_Knee_RI";
	tagArray[tagArray.size] = "J_Knee_LE";
	tagArray[tagArray.size] = "J_Ankle_RI";
	tagArray[tagArray.size] = "J_Ankle_LE";

	for( i = 0; i < 3; i++ )
	{
		PlayFxOnTag( level._effect["flame_death1"], self, tagArray[randomint(tagArray.size)] );
		PlayFxOnTag( level._effect["flame_death2"], self, "J_SpineLower" );
	}
}

get_ai_by_animname(aname)
{
	
	axis = getaiarray("allies");
	allies = getaiarray("axis");
	guys = [];
	
	ai = array_combine(axis,allies);
	for(i=0;i<ai.size;i++)
	{
		if( isDefined(ai[i]) && isDefined(ai[i].animname) && ai[i].animname == aname)
		{
			guys[guys.size]= ai[i];
		}
	}
	
	return guys;
	
}


//stole this from deathanim script, except I removed the huge amount of random force that is used in that one
oki3_pop_helmet()
{
	if( !isdefined( self ) )
	{
		return; 
	}

	if( !isdefined( self.hatModel ) || !ModelHasPhysPreset( self.hatModel ) )
	{
		return; 
	}
	// used to check self removableHat() in cod2... probably not necessary though
	
	partName = GetPartName( self.hatModel, 0 ); 

	origin = self GetTagOrigin( partName ); //self . origin +( 0, 0, 64 ); 
	angles = self GetTagAngles( partName ); //( -90, 0 + randomint( 90 ), 0 + randomint( 90 ) ); 
	
	oki3_helmet_launch( self.hatModel, origin, angles, self.damageDir ); 

	hatModel = self.hatModel; 
	self.hatModel = undefined; 
	self.helmetPopper = self.attacker;
	
	wait 0.05; 
	
	if( !isdefined( self ) )
	{
		return; 
	}

	self detach( hatModel, "" ); 
}

oki3_helmet_launch( model, origin, angles, damageDir )
{
	launchForce = damageDir; 
  
	launchForce = launchForce * randomFloatRange( 1000, 1500 ); 

	forcex = launchForce[0]; 
	forcey = launchForce[1]; 
	forcez = randomFloatRange( 900, 1800 ); 
	
	contactPoint = self.origin +( randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ) ) * 5; 
	
	CreateDynEntAndLaunch( model, origin, angles, contactPoint, ( forcex, forcey, forcez ) ); 
}


disable_player_weapons()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] disableweapons();
	}

}

enable_player_weapons(guy)
{
	wait(1);
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] enableweapons();
	}

}

/*------------------------------------
for fixing the outro when a player might be in last stand 
when the level ends
------------------------------------*/
player_prevent_bleedout()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	while(1)
	{
		if( self maps\_laststand::player_is_in_laststand() )
		{
			self.bleedout_time = 1000000;
			self RevivePlayer();
		}
		wait_network_frame();
	}
}

outro_delete_grenade()
{
	self waittill( "grenade_fire", what );
	what Delete(); // SO THERE
}



/*------------------------------------
see if any other players are using the radio
------------------------------------*/
is_radio_available(player)
{
	
	players = get_players();
	
	radio_used = false;
	
	for(i=0;i<players.size;i++)
	{
		if(players[i] != player && players[i] getcurrentweapon() == "air_support")
		{
			radio_used= true;
		}
	}
	
	if(radio_used)
	{
		return false;
	}
	else
	{
		return true;
	}	
}
