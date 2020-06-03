#include common_scripts\utility;
#include maps\_utility;
#include maps\oki2_util;
#include maps\_music;


/*-------------------------------------------------------------
sets up the gun bunkers in OKI2 

bnkr: Bunker ID
fire_fx: Interior fire fx for engulfing the inside of the bunker in fire. Pass in the fxID of the fx you want to play
flamejets: Script_structs. If defined it will play the flamejet FX.  Pass in the targetname of the script_structs whose origin/angles will be used to play the fx
flamejetfx: fx id to play when the flamejets are shown. Pass in the fxID of the fx you want to play
flame_guys: If defined, guys will emerge on fire from the structure. Pass in the targetname of the spawners you want to set on fire.
flame_guys_func: If defined, the flame guys will be threaded into this function. Pass in the function name.
exploderID - 
-------------------------------------------------------------*/
bunker_wait_for_flame(bnkr,fire_fx,flame_guys,flame_guys_func,exploderID)
{
	
	//stop waiting for flame damage if it's already been hit with explosives
	level endon(bnkr + "_destroyed");
	
	/* -----------------
	damage trigger inside of bunker.
	 must follow a naming convention of "bunker#_dmg_trig"	
	 -------------------*/
	trig = getent("bunker" + bnkr +"_dmg_trig","targetname");
	dmg = 0;
	
	//wait for the explosives to be tossed in after it's been flamed
	level thread bunker_wait_for_explosives(bnkr,trig,exploderID);
	
	// triggers which spawn in reinforcemetns around the bunker
	// triggers must have name of "bunker_#_support" as script_noteworthy 
	support_trigs = getentarray("bunker_" + bnkr + "_support","script_noteworthy");
	if(isDefined(support_trigs))
	{
		array_thread(support_trigs,::add_support_spawn_functions);
	}
		
	//notification string
	strNotify = bnkr +"_flamed";
	
	//wait for the trigger to take enough flame damage
	while(dmg < 500)
	{
		trig waittill("damage", amount ,attacker, direction_vec, P, type);
		if(type != "MOD_BURNED")
		{
			continue;
		}
		else
		{
			dmg = dmg + amount;
		}
	}
	//if(type != "MOD_BURNED" && type != "MOD_EXPLOSIVE" && type != "MOD_PROJECTILE_SPLASH" && type != "MOD_PROJECTILE" && type != "MOD_GRENADE_SPLASH" && type != "MOD_GRENADE")
	
	//just in case the players manage to avoid triggering the reinforcements, turn off the support triggers after the bunker has been blown
	if(isDefined(support_trigs))
	{
		for(i=0;i<support_trigs.size;i++)
		{
			if( isDefined(support_trigs[i]) ) // might've deleted itself
			{
				support_trigs[i] trigger_off();
			}
		}
	}
	
	//play some additional fire fx inside the bunker
	//thread bunker_interior_fire(bnkr,fire_fx);

	//grab all the axis inside the bunker and set them on fire 
	kill_guys_in_bunker(bnkr);
	
	//guys on fire, emerging from the bunker
	if(isDefined(flame_guys))
	{
		flamers = getentarray(flame_guys,"targetname");
		array_thread(flamers,flame_guys_func);
	}
	
	// send out the notifies
	level notify(strNotify);
	
	level notify(bnkr + "_cleared");	
}

/*------------------------------------
Wait for the the bunkers to be destroyed
------------------------------------*/
bunker_wait_for_explosives(bnkr,trig, exploderID)
{
	trig waittill( "satchel_exploded" );

	exploder(exploderID);

	if(bnkr == 1)
	{
		level.gun1 notify("trigger");
		
		if( !level.gun2_destroyed )
		{
			// used to send allies to their new color spots after the first bunker's destroyed
			alliestrig = getent("e2_linefight_a_allies","targetname");
			if( isDefined(alliestrig) )
			{
				alliestrig notify("trigger");	
			}
			
			// start up the enemies there while we're at it
			enemytrig = getent("e2_linefight_a_start","targetname");
			if( isDefined(enemytrig) )
			{
				enemytrig notify("trigger");
			}
		}
	}
	if(bnkr == 2)
	{
		level.gun2 notify("trigger");
		
		// used to send allies to their new color spots after the second bunker's destroyed
		alliestrig = getent("goto_bunker4","targetname");
		if( isDefined(alliestrig) )
		{
			alliestrig notify("trigger");
		}
		
		// start up the enemies there while we're at it
		enemytrig = getent("e2_bunker4_firstspawn","targetname");
		if( isDefined(enemytrig) )
		{
			enemytrig notify("trigger");
		}
	}
	if(bnkr == 4)
	{
		level.gun4 notify("trigger");
	}

	//grab all the axis inside the bunker and set them on fire 
	thread kill_guys_in_bunker(bnkr);

	//turn off any extra trigger once it's been destroyed
	// if it's defined , it needs to be called "bunker_#_extra"
	xtra = getent("bunker_" + bnkr + "_extra","targetname");
	if(isDefined(xtra))
	{
		xtra trigger_off();
	}

	//playSoundAtPosition( "bunker_explo", trig.origin );

	wait(1);

	// pick 2 random spots from the various that are placed inside of each of the bunkers.
	// play some fire FX on them
	spots = getstructarray("bunker_" + bnkr + "_fire","targetname");
	x1 = spots[randomint(spots.size)];

	//remove the one that was already chosen so there is no possibility of a dupe
	array_remove( spots, x1 );

	x2 = spots[randomint(spots.size)];
	
	//fire/smoke inside the bunker after satchel charge
	//playfx(level._effect["bunker_post_explosion"] ,x1.origin);
	//playfx(level._effect["bunker_post_explosion"], x2.origin);

	level notify(bnkr +"_destroyed");

	//stop the firing fx on this gun after it's been taken out
	level notify("stop_" + bnkr );
	level notify(bnkr + "_cleared");

	support_trigs = getentarray("bunker_" + bnkr + "_support","script_noteworthy");
	if(isDefined(support_trigs))
	{
		for(i=0;i<support_trigs.size;i++)
		{
			support_trigs[i] trigger_off();
		}	
	}
}

/*-------------------------------------------------------------
waits for the triggers which spawn in reinforcements to be triggered
-------------------------------------------------------------*/
add_support_spawn_functions()
{
	// self is the trigger
	target = self.target;
	spawners = getentarray( target, "targetname" );
	
	// add a spawn function to each of the dudes
	for( i=0; i<spawners.size; i++ )
	{
		spawners[i] add_spawn_function( ::guy_to_goal_blind ); // found in oki2_util
	}
}

/*-------------------------------------------------------------
kill all the mans inside the bunker
-------------------------------------------------------------*/
kill_guys_in_bunker(bnkr)
{
	
	trig = getent("bunker_" + bnkr + "_radius","targetname");
	bunker_guys = getaiarray("axis");
	for(i=0;i<bunker_guys.size;i++)
	{
		if( bunker_guys[i] istouching( trig ) )
		{
			bunker_guys[i] thread flamedeath();
		}
	}
	
}

/*-------------------------------------------------------------
play the interior fire fx
//NOTE - script_structs with "bunker_#_fire" as targetname k/v
-------------------------------------------------------------*/
bunker_interior_fire(bnkr, fx)
{
	spots = getstructarray("bunker_" + bnkr + "_fire","targetname");
	for(i=0;i<spots.size;i++)
	{
		playfx(level._effect[fx] ,spots[i].origin);
	}
	
}


/*-------------------------------------------------------------
Used to spawn guys in, catch them on fire and kill them
-------------------------------------------------------------*/
cave_flamers()
{
	//wait a short time and send a few guys out of the cave
	//wait(randomfloatrange(.5,2.5));
	guy = self stalingradspawn();
	if( isdefined(guy) )
	{
		guy waittill("finished spawning");
		guy thread flamedeath(true);	
	}
}


/*-------------------------------------------------------------
Catch guys on fire and make them die
- reach_goal: if Defined, this will play fire effects on the guy, but will wait for him to reach his targetted node before killing him
NOTE: this is mostly temp
self = guy getting owned
-------------------------------------------------------------*/
#using_animtree("generic_human");
flamedeath(wait_for_goal)
{
	
	anima[0] = %ai_flame_death_a;
	anima[1] = %ai_flame_death_b;
	anima[2] = %ai_flame_death_c;
	anima[3] = %ai_flame_death_d;
	
	self.deathanim = anima[randomint(anima.size)];	
		
	self death_flame_fx();
	if(isDefined(wait_for_goal))
	{
		self waittill("goal");
	}
		
	self dodamage(self.health + 100, self.origin);
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


/*------------------------------------
start the dialogue for taking out the bunkers 
------------------------------------*/
bunker_dialogue()
{
	//tell players that they need to take out the bunkers
	thread bunker1_dialogue_begin();
	
	//tell players to clear the bunkers and throw in explosives
	thread bunker_dialogue_clearbunker(1);
	thread bunker_dialogue_explosives_thrown(1);
	
	thread bunker_dialogue_clearbunker(2);
	thread bunker_dialogue_explosives_thrown(2);
	
	thread bunker_dialogue_clearbunker(4);
	thread bunker_dialogue_explosives_thrown(4);
}

/*------------------------------------
let the players know to take out the bunkers
------------------------------------*/
bunker1_dialogue_begin()
{
	trig1 = getent("bunker1_dialogue","script_noteworthy");
	trig1 waittill("trigger");
	
	//TEMP!!! HAX!!
	level notify("stop_cave_mg");
	
	wait(5);
	
	battlechatter_off( "allies" );
	
	maps\oki2::e2_showsatchels();
	level.sarge dialogue("threeactive");
	wait(1);
	level.sarge dialogue("flankround");
	
	battlechatter_on( "allies" );
	
	level thread players_satchel_hint();
	level notify("OBJ_1_COMPLETE"); // also progresses the objective

	//TUEY Set Music State to FUBAR
	setmusicstate("BUNKERS");

}

/*------------------------------------
dialogue for using clearing the bunkers
------------------------------------*/
bunker_dialogue_clearbunker(bnkr)
{
	level endon(bnkr +"_destroyed");
	
	trig1 = getent("bunker_" + bnkr+ "_dialogue_clearbunker","script_noteworthy");
	trig1 waittill("trigger");
	
	//nag the player if they don't use the flamer right away
	level.sarge thread nag_clear_bunker(bnkr);
	
	wait(1);
	level thread bunker_waitfor_cleared(bnkr);
	
	//waittill the bunker is cleared
	level waittill(bnkr + "_cleared");
	
	//good job! now blow it up!
	wait(2);	
	level.sarge dialogue("satchelnag1" );
	
	//nag the player if they don't throw in a satchel
	level.sarge thread nag_throw_satchel(bnkr);
}


/*------------------------------------
dialogue for after the bunker is destroyed
-----------------------------------*/
bunker_dialogue_explosives_thrown(bnkr)
{
	level waittill(bnkr + "_destroyed");

	remaining = guns_remaining();
	switch(remaining)
	{
		case 1:
			level endon( "bunker_noneleft");
			level notify( "bunker_oneleft" );
			setmusicstate("FUBAR");
			wait(4);
			level.sarge dialogue("twodown");
			wait(0.5);
			level.sarge dialogue("finishjob");
			//TUEY SET the music state back to FUBAR for the last bunker
			

			break;
		case 2:
			level endon( "bunker_oneleft");
			wait(4);
			level.sarge dialogue("onedown");
			break;			
	}
	// goto_next_bunker();		
}


/*------------------------------------
nags player if they take too long
------------------------------------*/
nag_throw_satchel(bnkr)
{
	level endon(bnkr + "_destroyed");
	
	while(1)
	{
		for(i=1;i<4;i++)
		{
			wait(10);
			if( i == 1 )
			{
				level.polonsky dialogue( "hurryitup" );
				
			}
			else
			{
				level.sarge dialogue( "satchelnag" + i );
			}
		}		
	}			
}

/*------------------------------------
send the friendlies to the next objective
------------------------------------*/
goto_next_bunker()
{
	//goto bunker 2 if gun 1 is toast, but not gun2
	if(level.gun1_destroyed && !level.gun2_destroyed)
	{
		trig = getent("goto_bunker2","targetname");
		trig notify("trigger");
	}
	
	//goto bunker 3 if gun1 and 2 are toast
	if( level.gun1_destroyed && level.gun2_destroyed)
	{
		trig = getent("goto_bunker4","targetname");
		trig notify("trigger");
	}
	
	//goto bunker 1 if the other guns are destroyed 
	if( (!level.gun1_destroyed) && (level.gun2_destroyed) && (level.gun4_destroyed) )
	{
		trig = getent("goto_bunker1","targetname");
		trig notify("trigger");
		
	}	
}

/*------------------------------------
nags players to clear enemies from the bunkers
------------------------------------*/
nag_clear_bunker(bnkr)
{
	level endon(bnkr + "_destroyed");
	level endon(bnkr + "_flamed");
	
	players = get_players();
	p1 = players[0];
	
	while(1)
	{
		wait(10);
		if( p1 hasWeapon("m2_flamethrower_wet") )
		{
			switch( randomint(8) )
			{
				case 0:
					level.sarge dialogue("flamenag");
					break;
				case 1:
					level.sarge dialogue("burnthose");
					break;
				case 2:
					level.sarge dialogue("goddamnflames");
					break;
				case 3:
					level.polonsky dialogue("burnem");
					break;
				case 4:
					level.polonsky dialogue("flamethose");
					break;
				case 5:
					level.sarge dialogue( "satchelnag1" ); // mixing in satchel ones too
					break;
				case 6:
					level.sarge dialogue( "satchelnag2"  );
					break;
				case 7:
					level.sarge dialogue( "satchelnag3" );
					break;
				default:
					level.polonsky dialogue("hurryitup");
						
			}
		}
		else
		{
			switch( randomint(4) )
			{
				case 0:
					level.sarge dialogue( "satchelnag1" ); // mixing in satchel ones too
					break;
				case 1:
					level.sarge dialogue( "satchelnag2"  );
					break;
				case 2:
					level.sarge dialogue( "satchelnag3" );
					break;
				default:
					level.polonsky dialogue("hurryitup");
						
			}
		}
	}			
}


/*------------------------------------
monitors for each gun/bunker to be destsroyed
------------------------------------*/
monitor_gun(num)
{
	switch(num)
	{
		case 1:
			level.gun1 waittill("trigger");
			level.gun1_destroyed = true;
			destroy_gun(1);
			//iprintlnbold("Bunker 1 destroyed!");
			break;
					
		case 2:
			level.gun2 waittill("trigger");
			level.gun2_destroyed = true;
			destroy_gun(2);
			//iprintlnbold("Bunker 2 destroyed!");
			break;
				
		case 4:
			level.gun4 waittill("trigger");
			level.gun4_destroyed = true;
			destroy_gun(4);
			//iprintlnbold("Bunker 4 destroyed!");
			break;	
		
	}
	
}
/*------------------------------------
notify the model3 script that the gun has been destroyed
and also update objectives after it's been destroyed
------------------------------------*/
destroy_gun(gun_num)
{
	gun = getent("gun_" + gun_num,"targetname");
	gun notify("death");
	
	update_gun_objectives();
}

/*------------------------------------
updates the objective strings
------------------------------------*/
update_gun_objectives()
{
	guns = 3; 
	if(level.gun1_destroyed) 
	{
		objective_position( 1, get_position() );
		guns --;
	}
	if(level.gun2_destroyed) 
	{
		objective_additionalposition( 1, 1, get_position() );
		guns --;
	}

	if(level.gun4_destroyed) 
	{
		objective_additionalposition( 1, 2, get_position() );
		guns --;
	}	
	
	if(guns == 0)
	{
		level.all_guns_destroyed = true;
	}
	
	switch(guns)
	{
		case 1:		objective_string( 1, &"OKI2_OBJ_2_1" );	break;
		case 2:		objective_string( 1, &"OKI2_OBJ_2_2" );	break;
		case 3: 	objective_string( 1, &"OKI2_OBJ_2_3" );	break;
		case 4:		objective_string( 1, &"OKI2_OBJ_2_4" );	break;
	}
	
	autosave_by_name( guns + " guns remaining" );
	objective_ring( 1 );
}

/*------------------------------------
returns the position of any gun which is not yet destroyed. 
used for objective stars
------------------------------------*/
get_position()
{

	if(!level.gun1_destroyed) 
	{
		return level.gun1_org;
	}
	if(!level.gun2_destroyed) 
	{
		return level.gun2_org;
	}

	if(!level.gun4_destroyed) 
	{
		return level.gun4_org;
	}
		
	return level.gun1_org;	
	
}

/*------------------------------------
returns the number of guns remaining. 
used for dialogue stuff
------------------------------------*/
guns_remaining()
{

	guns = 3; 
	if(level.gun1_destroyed) 
	{
		guns --;
	}
	if(level.gun2_destroyed) 
	{
		guns --;
	}

	if(level.gun4_destroyed) 
	{
		guns --;
	}
	
	return guns;		

}

//wait for the player to clear out the bunker in case they don't use the flamethrower
bunker_waitfor_cleared(bnkr)
{
	
	trig = getent("bunker_" + bnkr + "_radius","targetname");
	
	bunker_cleared = false;
	
	while(!bunker_cleared)
	{
		guys = 0;
		enemies = getaiarray("axis");
		for(i=0;i<enemies.size;i++)
		{
			if( enemies[i] istouching( trig ) )
			{
				guys++;
			}

		}
		if(guys==0)
		{
			bunker_cleared = true;
			level notify(bnkr + "_cleared");
		}
		wait(1);
	}	
	
}