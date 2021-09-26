/****************************************************************************

Level:          Breakout
Campaign:       Britsh
Objectives:     1.(Main) Destroy German Mortar positions
                2.(Sub) Take control of field HQ
                3.(Sub) Defend HQ
                            

*****************************************************************************/

#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{
	level.campaign = "british";
	maps\_tankai::main();
	maps\_truck::main("xmodel/vehicle_opel_blitz_woodland");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_brush");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_sherman::main("xmodel/vehicle_american_sherman");
	maps\_tankai_sherman::main("xmodel/vehicle_american_sherman");
	maps\breakout_fx::main();
	maps\_load::main();
	maps\breakout_anim::main();
	
	level.xenon = false;
	
	if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
		level.xenon = true;
	
	level thread maps\breakout_amb::main();
	
	setExpFog(0.00015, 0.15, 0.14, 0.13, 0);

       
       
	precacheModel("xmodel/prop_mortar_ammunition");
	precacheModel("xmodel/vehicle_spitfire_flying");
	precacheModel("xmodel/military_tntbomb");
	precacheModel("xmodel/military_tntbomb_obj");
	precacheModel("xmodel/weapon_stickybomb");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
 	precacheShader("inventory_tnt_small");  		       
	level thread maps\breakout_amb::main();
	
	maps\_mortar::generic_style_init();  
	//array_thread(getaiarray(), ::throwSmoke);
	
	flag_clear("music_start");
	
	//*** Precaching and Text
	
	precacheString(&"BREAKOUT_REINFORCEMENTS");		
	
	level.firstmortar_obj = 0;
	level.secondmortar_obj = 0;       
	level.player.tnt = 1;
	level.inv_tnt = maps\_inventory::inventory_create("inventory_tnt_small",true);	
	
	flag_init("go_time");
		
	level thread setup_price();
	level thread setup_mcgregor();
	level thread get_brit();
	level thread intro();
	level thread take_barn();
	level thread barnguys();
	level thread barn_scene();
	level thread barn_nag();
	level thread doorkick();
	level thread halftrack01_movein();  
	level thread halftrack02_gunner();   
	level thread Objective_1_assemble_price();
	level thread setup_openingmortar();
	level thread opening_mortars();
	level thread setup_fieldmortar();
	level thread startcourtyardmortar();
	level thread setup_sortie();
	level.timersused = 0;
	
		thread music();
}

//**** setup ****/

intro()
{
	setAmbientAlias("exterior", "3");
	level.maxfriendlies = 6;
	
	friendlies = getaiarray("allies");
	level thread array_thread(friendlies,::charge_anim);
	level.price.anim_disablePain = true;
	wait 3.5;	
	//iprintlnbold ("Take cover!!! Get to the barn! Move!!!");	   
	level.price dialogue_thread("breakout_pri_takecoverbarn");	
	level.mcgregor setgoalentity (level.player);
	level.price setgoalentity (level.player);
	wait .5;
	level.price thread wave();
	level thread movement_checker();
	wait 2;
	maps\_utility::exploder(1);
	wait 1;
	maps\_utility::exploder(2);	   
	wait 8;
	//iprintlnbold ("Keep moving!!! Don't stop!!!");
	level.price dialogue_thread("breakout_pri_keepmoving");
	level.price.anim_disablePain = false;   
}



wave()
{
	self endon ("death");
	self.wave = true;
//	self.animname = "generic";
//	self anim_single_solo (self, "wave");
	self.run_noncombatanim = %run_and_wave;
	wait (2);
	self.run_noncombatanim = undefined;
}


setup_price()
{
	level.price = getent("price","script_noteworthy");
	assertex(isdefined(level.price),"Price not getting defined!");
	//level.price set_goalradius(0);
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	//level.price setBattleChatter(false);
	level.price.followmax = -3;
	level.price.followmin = -5;
	level.price thread stopblocking(); 
}

setup_mcgregor()
{
	level.mcgregor = getent("mcgregor","script_noteworthy");
	assertex(isdefined(level.mcgregor),"mcgregor not getting defined!");
	level.mcgregor.animname = "mcgregor";
	level.mcgregor thread magic_bullet_shield();
	//level.mcgregor setBattleChatter(false);
	//level.mcgregor thread throwsmoke();
	level.mcgregor.followmax = -2;
	level.mcgregor.followmin = -4;      
	level.mcgregor thread stopblocking(); 
}

stopblocking()
{
	oldsuppressionwait = self.suppressionwait; 
	self pushplayer( true );
	self.suppressionwait = 0;
	
	flag_wait("go_time");

	self pushplayer( false );
	self.suppressionwait = oldsuppressionwait;	
}

get_brit()
{
	excluders = [];
	excluders[0] = level.price;
	excluders[1] = level.mcgregor;
	brit = getClosestAIExclude (level.player getorigin(), "allies", excluders);

	if (!isdefined(brit))
		return false;

	brit.animname = "brit";
	return brit;
}

movement_checker(barn)
{
	level endon ("player_in_barn");
	barn = getent("barn", "targetname");
	dist = length(level.player.origin - barn.origin); //(returns world units)
	
	range = 256;
	time = 5;
	
	newtime = 0;
	interval = 1;
	
	mortarnum = 0;
	maxmortars = 2;
	mortartimemax = 3;
	mortartime = mortartimemax;
	while(1)
	{
		wait interval;
		newdist = length(level.player.origin - barn.origin); //(returns world units);
		
		if((dist - newdist) < range)
			newtime += interval;	
		else
		{
			newtime = 0;
			dist = newdist;
			mortarnum = 0;
		}
		
		if(newtime >= time)
		{
			if(mortartime >=mortartimemax)
			{
				if(mortarnum < maxmortars)
				{	
					x = 160 + randomfloat(60);
					if(randomint(100) > 50)
						x *= -1;
					y = 160 + randomfloat(60);
					if(randomint(100) > 50)
						y *= -1;
						
					origin = level.player.origin + (x,y,0);
					impactPoint = spawn ("script_origin", origin);
					impactPoint maps\_mortar::explosion_activate ("openingmortar", 1, 1, 2, 0.5, 2, 2000); //
					mortarnum++;
					radiusdamage(origin, 600, 80, 80);
				}
				else
				{
					impactPoint = spawn ("script_origin", level.player.origin);
					impactPoint maps\_mortar::explosion_activate ("openingmortar", 1, 1, 2, 0.5, 2, 2000); //
					killplayer();
				}
				mortartime = 0;
			}
			mortartime += interval;
		}
	}	
}


killplayer()
{
	level.player enableHealthShield( false );
	level.player doDamage (level.player.health, level.player.origin); //killplayer
	level.player enableHealthShield( true );
}


setgoalentityforguys(target)
{
       //COUNT UP THE LADS
       guys = getentarray("guys", "script_noteworthy");
       for(i=0;i<guys.size;i++)
       {
               if(isalive(guys[i]))
                       guys[i] setgoalentity (target);
       }
}

setgoalforguys(goal)
{
       //COUNT UP THE LADS
       guys = getentarray("guys", "script_noteworthy");
       for(i=0;i<guys.size;i++)
       {
               if(isalive(guys[i]))
               {
                       guys[i] setgoalnode (goal);
                       guys[i].goalradius = goal.radius;

               }
       }
       
               
}

setup_openingmortar()
{
       level.explosion_startNotify["openingmortar"] = "start openingmortar";
       level.explosion_stopNotify["openingmortar"] = "stop openingmortar";
}

setup_courtyardmortar()
{
       level.explosion_startNotify["courtyardmortar"] = "start courtyardmortar";
       level.explosion_stopNotify["courtyardmortar"] = "stop courtyardmortar";
}

setup_fieldmortar()
{
       level.explosion_startNotify["fieldmortar"] = "start fieldmortar";
       level.explosion_stopNotify["fieldmortar"] = "stop fieldmortar";
}


throwsmoke()
{
       node = getnode("gonode","targetname");
       self checkForSmokeHint(node);
       self setgoalnode(node);
}




//**************************************************************************************
//OBJECTIVES

Objective_1_assemble_price()
{
	
	//chain = get_friendly_chain_node ("0");
	//level.player SetFriendlyChain (chain);
	
	barn = getent("barn","targetname");
	assertex(isDefined(barn), "barn not found" );
	objective_add(1, "active", &"BREAKOUT_ASSEMBLE_CPT_PRC", barn.origin );
	objective_current(1);
	
	level waittill ("player_regrouped_barn");
	objective_state(1, "done");
	
	level thread Objective_2_mortar_crews();
}




Objective_2_mortar_crews()
{

	level.firstmortar = getent("first_mortar","targetname");
	assertex(isDefined(level.firstmortar), "level.firstmortar not found" );
	level.secondmortar = getent("second_mortar","targetname");
	assertex(isDefined(level.secondmortar), "level.secondmortar not found" );
	
	objective_add(2, "active");
	objective_string(2, &"BREAKOUT_ELIMINATE_THE_ENEMY_MORTAR", 2);
	objective_current(2);
	
	level.mortarcrews = 2;
	level.firstmortar thread objectives_mortarcrews(2, 0);
	level.secondmortar thread objectives_mortarcrews(2, 1);
	
	
	level waittill("bothmortars_dead");       
	level thread Objective_3_capture_field_hq();

}

objectives_mortarcrews(objnum, i)
{
	objective_additionalposition(objnum, i, self.origin);
	
	self waittill("done");
	level.mortarcrews--;
	objective_additionalposition(objnum, i, (0,0,0) );
//		objective_string(objnum, "Eliminate the German mortar teams ["+ (level.mortarcrews) + " remaining]");
	if ( level.mortarcrews )
		objective_string(objnum, &"BREAKOUT_ELIMINATE_THE_ENEMY_MORTAR", level.mortarcrews);
	else
	{
		level notify( "bothmortars_dead" );
		objective_state( objnum, "done" );
		objective_string(objnum, &"BREAKOUT_ELIMINATE_THE_ENEMY_MORTAR", 0);
	}
    wait 0.5;
}

		
Objective_3_capture_field_hq()
{

	backyard_node = getent("backyard_node","targetname");
	assertex(isDefined(backyard_node), "backyard_node trigger not found" );
	objective_add(3, "active", &"BREAKOUT_CAPTURE_FIELDHQ", backyard_node.origin);
	
	objective_current(3);
	   
	trigger = getent("found_field","targetname");
	assertex(isDefined(trigger), "found_field not found" );
	trigger waittill("trigger");
	level notify ("update Field HQ");
	//CHANGE STAR LOCATION             
	field_hq = getent("field_hq_node","targetname");
	assertex(isDefined(field_hq), "field_hq_node trigger not found" );       
	objective_position(3, field_hq.origin);
	
	level thread field_hq_counter();	 
	level waittill ("Field HQ secure");
	
	objective_state(3, "done");
	   	
	level thread Objective_4_regroup();
	level thread command_calls();
	level thread regroup_lads();
       
}

side_attackers()
{
       trigger = getent("side_attackers","targetname");
       assertex(isDefined(trigger), "side_attackers not found" );
       trigger delete();
}

Objective_4_regroup()
{
	regroup_node = getent("regroup_node","targetname");
	assertex(isDefined(regroup_node), "regroup_node not found" );
	objective_add(4, "active", &"BREAKOUT_REGROUP_CPT_PRC", regroup_node.origin);
	objective_current(4);
	
	level waittill ("regrouped");
	objective_state(4, "done");
             
}

Objective_5_defend()
{
	defend_node = getent("defend_node","targetname");
	assertex(isDefined(defend_node), "defend_node not found" );
	objective_add(5, "active", &"BREAKOUT_HOLD_HQ", defend_node.origin);
	objective_current(5);
	level thread Objective_6_tank();
	
	// WAIT TILL THEY ARE ALL DEAD
	level waittill ("tank dead");
	objective_state(5, "done");
	level thread Objective_7_end();
	     
}

Objective_6_tank()
{

	level thread tiger01_spawn_wait();
 
    level waittill ("tank_mission");
	assertex(isdefined(level.tiger01),"no tiger01");
	tank_obj_star = getent("tank_obj_star","targetname");
    assertex(isDefined(tank_obj_star), "tank_obj_star not found" );					 
	objective_add(6, "active", &"BREAKOUT_ELIMINATE_TIGER_TANK", tank_obj_star.origin);
	objective_current(5,6);
	//level.tiger = 1;

    level waittill ("tank dead");
    objective_state(6, "done");

}

Objective_7_end()
{
		      
	end_node = getent("end_node","targetname");
	assertex(isDefined(end_node), "regroup_node not found" );
	objective_add(7, "active", &"BREAKOUT_REGROUP_CPT_PRC_END", end_node.origin);
	objective_current(7);
	
	level waittill ("roll in");
	objective_state(7, "done");
             
}





//**********************************************************************************


opening_mortars()
{
	wait 1;
	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("openingmortar", 1.0, 3, 1.0, 350, 2000,false);
	level notify ("start openingmortar");
}

//BLOWING STUFF 
hide_it(connect)
{
    self hide();
    self.origin = self.origin + (0,0,-1000);
    if (isdefined(connect) && self.classname == "script_brushmodel")
        self connectpaths();
}

show_it()
{
    self show();
    self.origin = self.origin + (0,0,1000); 
}



debugTag(tag)
{
	//	self endon ("killanimscript");
	//	self endon (anim.scriptChange);
	self notify ("Debug tag");
	self endon ("Debug tag");
	for (;;)
	{
		angles = self gettagangles (tag);
		forward = anglestoforward (angles);
		forwardFar = maps\_utility::vectorScale(forward, 30);
		forwardClose = maps\_utility::vectorScale(forward, 20);
		right = anglestoright (angles);
		left = maps\_utility::vectorScale(right, -10);
		right = maps\_utility::vectorScale(right, 10);
		tagOrg = self gettagorigin (tag);
		line (tagOrg, tagOrg + forwardFar, (0.9, 0.7, 0.6), 0.9);
		line (tagOrg + forwardFar, tagOrg + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		line (tagOrg + forwardFar, tagOrg + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}



take_barn()
{

	level waittill ("barnsecure"); 
	
	price_barn = getnode("price_barn","targetname");
	barn_goal1 = getnode("barn_goal1","targetname");
	schoolcircle("barnbriefing_node", "Cpt. Price", "price_barn", level.price, "barn_goal1");	

	level notify ("player_regrouped_barn");
}

barnguys()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("barn_guys","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	
	level notify ("barnsecure");
	level.mcgregor notify("barnsecure");
	
}	



barn_nag()
{
	level endon ("player_regrouped_barn");
	level waittill ("barnsecure");
	while (1)
	{
		wait 10;
		//iprintlnbold ("Price - Regroup lads! Regroup on my position!"); 	
       	level.price thread dialogue_thread("breakout_pri_regrouplads");
    }   		
}


barn_scene()
{
	level waittill ("player_regrouped_barn");
	
	wait 2;
	//iprintlnbold ("Price - Hold up here lads! We have to take out those mortars!");
	level.price dialogue_thread("breakout_pri_holdupherelads");
	wait .5;
	//level notify  ("go time");
	flag_set("go_time");

}
	
#using_animtree("barndoor");
doorkick()
{
	door = getent("barn_door_model","targetname");
	door.animname = "barn_door";
	door useanimtree (#animtree);
	guy[0] = level.mcgregor;
	guy[1] = door;
	
	//door thread debugTag("tag_origin");
	
	animNode = getnode("doorkick_goal","targetname");
	door.origin = getStartOrigin(animNode.origin, animNode.angles, level.scr_anim[door.animName]["barndoor"]);
	door.angles = getStartAngles(animNode.origin, animNode.angles, level.scr_anim[door.animName]["barndoor"]);
	doorscript = getent("left_door","targetname");
	doorscript linkto (door, "tag_barndoor", (0,0,0),(0,0,0));
//	door hide();
	door setshadowhint("normal");
				
	trigger = getent("first_door","targetname");
	trigger waittill("trigger");
	level notify("player_in_barn");
	setAmbientAlias("exterior", "2");
	//level waittill("go_time");
	flag_wait("go_time");	
	
	/*
	goal01 = getnode("goal01","targetname");
	level.mcgregor setgoalnode(goal01);
	level.mcgregor.goalradius =0 ;
	
	level.mcgregor waittill("goal");
	*/
	
	// play kick animation on mcgregor
	animNode anim_reach_solo (guy[0], "barndoor");		
	animNode thread maps\_anim::anim_single (guy, "barndoor");
	wait 1.2;
	door playsound ("wood_door_fisthit");
	wait 1;		
	door playsound ("wood_door_shoulderhit");

	
	wait .5;
	doorScript connectpaths();
	   
	//BACK ON FC
	level.price setgoalentity (level.player);       
	level.mcgregor setgoalentity (level.player);
	setgoalentityforguys(level.player);
	
	//START SUPPLYHOUSE STUFF
	level thread setup_courtyardmortar();
	level thread supplyhouse_clear();
	level thread first_mortar_crew();
	level thread second_mortar_crew();
	level thread bothmortars_dead();
	level thread mortar01_sound();
	level thread mortar02_sound();	
	level thread mortar_sound02_trg();	
	//level thread halftrack_warning();
	  
	wait 1;
	autoSaveByName("Barn Clear");
              
}

#using_animtree("generic_human");
spawnerThink(ent)
{
	self endon ("death");
	self waittill ("spawned",spawn);
	ent.guys[ent.guys.size] = spawn;
	ent notify ("spawned_guy");
}

mortarThink(ent)
{
	self endon ("death");
	self waittill ("spawned",spawn);
	ent.guys[ent.guys.size] = spawn;
	ent notify ("spawned_guy");
}


startcourtyardmortar()
{
	trigger = getent("startcourtyardmortar","targetname");
	assertex(isDefined(trigger), "startcourtyardmortar trigger not found");
	trigger waittill("trigger");
	level notify ("stop_mortar01_sound");
	
	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("courtyardmortar", 1.0, 3, 1, 350, 2000,false);
	level notify ("start courtyardmortar");
   

}


supplyhouse_clear()
{

	//WAITS FOR PLAYER TO TRIGGER, THEN...
	trigger = getent("moveto_halftrack_trigger","targetname");
	assertex(isDefined(trigger), "moveto_halftrack_trigger not found");
	trigger waittill("trigger");
	
	//iprintlnbold ("Mcgregor - Take out those mortar crews!!!");
	level.mcgregor dialogue_thread("breakout_mcg_mortarcrews");
	//...PUTS EVERYONE BACK ON FC
	wait 1;
	level.price setgoalentity (level.player);      
	level.mcgregor setgoalentity (level.player);
	
	//level thread spawn_crew("mortar_crew_1",0);
	
	setgoalentityforguys(level.player);
	level notify ("stop openingmortar");  
	      
	wait 2;
	autoSaveByName("Supply Clear");     
   
       
}
/*
halftrack_warning()
{
       //WAITS FOR PLAYER TO TRIGGER, THEN...
       trigger = getent("halftrack_warning","targetname");
       assertex(isDefined(trigger), "halftrack_warning not found");
       trigger waittill("trigger");
			  
	   iprintlnbold ("Mcgregor - Oi! Stay off that street, that halftrack's got it locked down tighter than a bearded nun!");
	   level.mcgregor dialogue_thread("breakout_mcg_beardednun");
}
*/
halftrack01_movein()
{
    
    trigger = getent("halftrack01_movetrg", "targetname");
 	trigger waittill("trigger");
 	setAmbientAlias("exterior", "3");
 	wait 1;  
	//iprintlnbold ("Halftrack!!!");
	level.price dialogue_thread("breakout_pri_halftrackfull");

}

halftrack02_gunner()
{	

			
	guy = getent("ht_gunner", "script_noteworthy");
	guy endon ("death");
	guy thread magic_bullet_shield();
	guy.ignoreme = true;
	
	wait 120;
	guy.ignoreme = false;
	setAmbientAlias("exterior", "5");
}



first_mortar_crew()
{
	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("first_mortar_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	
	wait 2;
	level.firstmortar notify ("done");
	wait 1;
	autoSaveByName("firstmortar dead");
	wait 5;
	autoSaveByName("firstmortar dead2");

}

second_mortar_crew()
{
	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("second_mortar_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	wait 2;
	//STOPS SECOND MORTARS
	level.secondmortar notify ("done");                         
	wait 1;
	autoSaveByName("secondmortar dead");
	wait 5;
	autoSaveByName("firstmortar dead2");
}          

mortar01_sound()
{

	level playsoundinspace("weap_mortar_fire",(4756, 5150, 12));
	self endon ("stop_mortar01_sound");
	
		
}

mortar_sound02_trg()
{
	trigger = getent("mortar_sound02_trg","targetname");
	assertex(isDefined(trigger), "mortar_sound02_trg trigger not found");
	trigger waittill ("trigger");
	level notify ("stop_mortar02_sound");

}


mortar02_sound()
{

	level playsoundinspace("weap_mortar_fire",(1550, 3054, 34));
	self endon ("stop_mortar02_sound");
	
		
}


bothmortars_dead()  
{  

	level waittill("bothmortars_dead");
	setAmbientAlias("exterior", "3");        
	//if both are dead..
	level notify ("stop courtyardmortar");
    level thread doorkick02();       
    level thread backyard();		
	level thread cleanup_front(); 
	courtmortardead_goal = getnode("courtmortardead_goal","targetname");
        axis = getAIArray( "axis" );
	   for ( index = 0; index < axis.size; index++ )
			{
				axis[index].ignoreme = false;
				axis[index].goalradius = 500;
				axis[index].fightdist = 0;
				axis[index].maxdist = 0;
				axis[index] setGoalNode( courtmortardead_goal );			
			} 
             
       allies = getAIArray( "allies" );
	   for ( index = 0; index < allies.size; index++ )
			{
				allies[index].ignoreme = false;
				allies[index].goalradius = 280;
				allies[index].fightdist = 0;
				allies[index].maxdist = 0;
				allies[index] setGoalEntity( level.player );			
			} 
	
	wait 3;
	level.price dialogue_thread("breakout_pri_takefieldhq");	   
	//iprintlnbold ("Price - Come on, we've got to take that field HQ to the North!");
	wait 1;	   	   
	level notify ("moveout");
	courtmortardead_goal = getnode("courtmortardead_goal","targetname");
	setgoalforguys( courtmortardead_goal );
	level.price setgoalnode(courtmortardead_goal);

                              
}

/*
spawn_crew()
{
	
	waittillframeend;

	assert(isdefined(mortar));
	eMortar = getent(mortar,"targetname");
	eMortar thread mortar_loadfire(crew);

}

mortar_loadfire(crew)
{
	self endon("stop mortar");

	courtyard_mortar_guys[0].animname = "loadguy";
	courtyard_mortar_guys[1].animname = "aimguy";

	for (i=0; i < crew.size; i++)
	{
		crew[i] thread stopmortar_anim(self);
	}

	triggers = getentarray(self.target,"targetname");

	array_thread(triggers,::stopmortar,self);

	while(true)
	{
		self anim_single(crew,"pickup",undefined,undefined,self);
		self anim_single(crew,"fire",undefined,undefined,self);
//		self anim_single(crew,"waitidle",undefined,undefined,self);
		self thread anim_single(crew,"waittwitch",undefined,undefined,self);
		wait 4.2;
	}	
}

stopmortar_anim(mortar)
{
	self animscripts\shared::putGunInHand ("none");
	mortar waittill("stop mortar");
	self stopanimscripted();
	self animscripts\shared::putGunInHand ("right");
	level notify ("stop courtyardmortar");
}

stopmortar(mortar)
{
	self waittill("trigger");
	mortar notify("stop mortar");
	self delete();
}

mortar_crew_track(crew_id,ent)
{
	self waittill("death");
	ent.count--;
	ent notify("crew die");
}

*/



doorkick02()
{
  	wait 1;	
	//MOVES EVERYONE TO THE TRANSITION HOUSE
	courtmortardead_goal = getnode("courtmortardead_goal","targetname");	
	level.mcgregor setgoalnode(courtmortardead_goal);
	level.mcgregor.goalradius = 0 ;
	//level.mcgregor waittill("goal");
			
	//level waittill ("moveout");
	//MCGREGOR KICKS IN HOUSE DOOR
	guy[0] = level.mcgregor;
	animNode = getnode("doorkick02_goal","targetname");
	
	animNode anim_reach (guy, "chateau_kickdoor1", undefined, animNode);
	level thread maps\_anim::anim_single (guy, "chateau_kickdoor1", undefined, animNode);
	
	guy[0] waittillmatch ("single anim", "kick");
	
	door = getent("door02","targetname");
	assertex(isDefined(door), "door02 not found" );
	door rotateto((0,-90,0), 0.6, 0.01, 0.55);
	door playsound ("wood_door_kick");
	
	wait 0.1;
	
	//WAIT, THEN SET ALL ON FC
	door connectpaths();
	//NEED TO CHANGE TO RADIUS
	wait 0.1;
		
	//MOVES EVERYONE TO THE TRANSITION HOUSE
	backyard_radius = getnode("backyard_radius","targetname"); 
	level.mcgregor setgoalnode(backyard_radius);
	level.mcgregor.goalradius =256 ;
	setgoalforguys( backyard_radius );
	level.price setgoalnode(backyard_radius);
	level.price.goalradius = 256 ;
	wait 10;
	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("fieldmortar", 0.5,5,2.5,350,2000,false);
	level notify ("start fieldmortar");
	level thread stop_fieldmortar();
       
}

cleanup_front()
{

		
	trigger = getent("kill_spawners_front","targetname");
	assertex(isDefined(trigger), "kill_spawners_front trigger not found");
	trigger notify("trigger");
	
	ht2_rushers_trig = getent("ht2_rushers_trig","targetname");
	assertex(isDefined(trigger), "ht2_rushers_trig trigger not found");
	ht2_rushers_trig triggerOff();
	                
//	level waittill ("update Field HQ");	
	//CLEAN UP LOOSE ENDS
//	ai = getaiarray("axis");
//	for(i=0;i<ai.size;i++)
//	       if(isalive(ai[i]))
//	               ai[i] delete();            
}


backyard()
{

	level waittill ("update Field HQ");
	setCullDist (4500);
	setAmbientAlias("exterior", "4");
	//iprintlnbold ("Price - They know we're here ladds, dig in and fight!!");
	level.price dialogue_thread("breakout_pri_digin");
	wait 1;
	level.price setgoalentity (level.player);      
	level.mcgregor setgoalentity (level.player);	
	setgoalentityforguys(level.player);			      
	wait 20;
	//iprintlnbold ("Price - So much for the easy stuff lads, that big farm house is the center piece of the German defense here. We've got to capture it!");       
	level.price dialogue_thread("breakout_pri_easystuff"); 
	//...PUTS EVERYONE BACK ON FC
	
	wait 2;
	//iprintlnbold ("Macgregor - Move out!!");
	level.mcgregor dialogue_thread("breakout_mcg_moveout");       

}


stop_fieldmortar()
{

	trigger = getent("fieldmortar_stop_trigger","targetname");
	assertex(isDefined(trigger), "fieldmortar_stop_trigger not found");
	trigger waittill("trigger");
	level notify ("stop fieldmortar");
       
        axis = getAIArray( "axis" );
	   for ( index = 0; index < axis.size; index++ )
			{
				axis[index].ignoreme = false;
				axis[index].goalradius = 256;
				axis[index].fightdist = 0;
				axis[index].maxdist = 0;
				axis[index] setGoalEntity( level.player );			
			} 
			            
}


field_hq_counter()
{
	/*
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("fieldhq_guys","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	*/ 
	objEvent = getObjEvent("hq_kill_trigger");
	objEvent waittill_objectiveEventNoTrigger(); 
	 
	        
	level notify ("Field HQ secure");
	
	wait 1;
	autoSaveByName("Field HQ Clear");
    setAmbientAlias("exterior", "2");  
	   german_retreat = getnode("german_retreat", "targetname");
	   axis = getAIArray( "axis" );
	   for ( index = 0; index < axis.size; index++ )
			{
				axis[index].ignoreme = false;
				axis[index].goalradius = 100;
				axis[index].fightdist = 0;
				axis[index].maxdist = 0;
				axis[index] setGoalnode(german_retreat);			
			}
	maps\_utility::exploder(17);				
	wait 2;
	
	basement_germans = getent("basement_germans","targetname");
	assertex(isDefined(basement_germans), "basement_germans not found");
	basement_germans delete();
	    	
	regroup_final = getnode("regroup_final","targetname");
	setgoalforguys( regroup_final );            
	level.mcgregor setgoalnode (regroup_final);
	price_radio = getnode("price_radio","targetname");	        
	level.price setgoalnode (price_radio);
	level.price.goalradius =5 ;	 
	level.price waittill("goal");	
	//iprintlnbold ("Price - Regroup lads! Regroup on my position!");       
	level.price dialogue_thread("breakout_pri_regrouplads");
	level notify ("price_inplace"); 
	level waittill ("regrouped");	 
	wait 1; 
	//level.price waittill ("goal");
	level.price dialogue_thread("breakout_pri_takenobjective");         
	wait .1;
	//level.price dialogue_thread("breakout_brv2_understood");
	playsoundinspace("breakout_brv2_understood", (1495, 9104, 54));
		
 	//level playsoundinspace("breakout_brv2_understood",level.price.origin);    
    wait 1;
	level thread Objective_5_defend();
	wait 1;
	//iprintlnbold ("Mcgregor - You heard him lads! Take up defensive positions in the HQ, lets move!");
	level.mcgregor dialogue_thread("breakout_mcg_hearditlads");            
	wait 2;              
	level notify ("get to positions");
       
}

command_calls()
{
 	level waittill ("price_inplace");           
	trigger = getent("player_end","targetname");
	assertex(isDefined(trigger), "player_end trigger not found");
	trigger waittill("trigger");
	level notify ("regrouped");
	
	wait 1;      
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
	       if(isalive(ai[i]))
	       	{
	         ai[i] delete();
			}			
	}
	
	
	fchain01 = getent("fchain01","targetname");
	assertex(isDefined(trigger), "fchain01 trigger not found");
	fchain01 triggerOff();
	
	                  
}

regroup_lads()
{
	
	level waittill ("get to positions");	  
	defend_radius = getnode("defend_radius","targetname");
	setgoalforguys( defend_radius );
	price_defend = getnode("price_defend","targetname");
	level.price setgoalnode (price_defend);
	level.price set_goalradius(price_defend.radius);
	mac_defend = getnode("mac_defend","targetname");	   
	level.mcgregor setgoalnode (mac_defend);
	level.mcgregor set_goalradius(mac_defend.radius);
	/*
	trigger = getent("start_attack","targetname");
	assertex(isDefined(trigger), "start_attack trigger not found");
	trigger waittill("trigger");
	*/
	wait .1;
	//setgoalentityforguys(level.player);
	     
	//STARTS THE ATTACK
	level thread attack_timer();       
	level thread objective_stopwatch();
	
	//iprintlnbold ("Macgregor - They'll be coming from the south lads, find a good postion!!");       
	level.mcgregor dialogue_thread("breakout_mcg_getready");       
	autoSaveByName("FieldHQ_defend");
	wait 5;
	
	//iprintlnbold ("Macgregor - German troops, in coming! Let those Jerry's have it!!");
	level.mcgregor dialogue_thread("breakout_mcg_jerriesincoming");
            	
}	 
	

//******************DEFEND STARTS******************************

//STARTS DEFEND TIMER


objective_stopwatch()
{
	
	//fMissionLength = level.stopwatch;							//how long until relieved (minutes)	
	//iMissionTime_ms = gettime() + int(fMissionLength*60*1000);	//convert to milliseconds
	
	// Setup the HUD display of the timer.
	level.stopwatch = 1;
	level.hudTimerIndex = 20;
	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    level.timer.vertAlign = "top";
    if(level.xenon)
	{
		level.timer.fontScale = 2;
		level.timer.x = -225;
	}
	else
	{
		level.timer.fontScale = 1.6;    
		level.timer.x = -180;
	}
	level.timer.y = 100;
	level.timer.label = &"BREAKOUT_REINFORCEMENTS";
	level.timer setTimer(3.5*60);
	
	x = 10;
	
	wait(3.5*60 - x);
	
	//x seconds ahead of victory notification (which activates the next objective), tanks enter, cosmetic
	
	wait x;
	level.timer destroy();
}

germans_inhouse()
{
	trigger = getent("germans_inhouse","targetname");
	assertex(isDefined(trigger), "germans_inhouse trigger not found");
	trigger waittill("trigger");
	
	wait 1;
	//iprintlnbold ("Mcgregor - They've entered the house!!!");
	level.mcgregor dialogue_thread("breakout_mcg_theyreinside"); 
	trigger delete();

}

attack_timer()
{
	wait 2;
	level thread germans_inhouse();
	level thread side_attackers();
	level thread attack_wave01();	
	wait 3;
	level thread attack_wave02();	   
	level thread attack_wave03();	   	     	   
	wait 5;
	setAmbientAlias("exterior", "3");	
	level thread attack_player01();
	wait 5;
	level thread flanker_wave01();
	level thread flanker_wave03();
	level thread flanker_wave04();			
	wait .1;
	maps\_utility::exploder(7);	
	wait .4;
	maps\_utility::exploder(8);	
	wait .3;
	maps\_utility::exploder(9);
	wait 2; 
	//iprintlnbold ("Gen - Smoke grenades!!");
	brit = get_brit();
	if (isdefined(brit))
	brit thread Dialogue_Thread("breakout_smokeattack_warning");	   
	autoSaveByName("smokes");		   
	wait 30;
	setAmbientAlias("exterior", "4");	
	//maps\_utility::exploder(15);	
	maps\_utility::exploder(16);
	wait 3;
	//iprintlnbold ("Gen - Smoke grenades!!");	   
	brit = get_brit();
	if (isdefined(brit))
	brit thread Dialogue_Thread("breakout_smokeattack_warning");
	wait 10;
	level thread flanker_wave08();
	level thread flanker_wave05();
	autoSaveByName("flankers");			  	   				   	      	
	wait 50;
	setAmbientAlias("exterior", "5");	  	   	   
	level thread attack_halftrack02();
	level thread stop_spawners_right();
	level thread stop_spawners();  
	wait 10;
	level thread flanker_wave02();	   
	//iprintlnbold ("Mcgregor - Hold your position dammit!!!"); 	
	level.mcgregor dialogue_thread("breakout_mcg_holddammit");   	   	   
	wait 25;
	level thread flanker_wave06(); 
	level thread flanker_wave07();
	autoSaveByName("flankers2");		   
	wait 20;
	//maps\_utility::exploder(8);	   	      
	level thread attack_tigertank01();
	level thread tankdefenders();
	level thread tank_mission();
	level thread tank_nag();
	level thread tank_mission_wave();
	level thread ending();
	level thread ending_nag();
	level thread reinforcements();	  
	level thread blitz();
	autoSaveByName("tank");	
	   	     	    	   
}
/*
price_mac_hide()
{
       level.price delete();
	   level.mcgregor delete();  
	   
	   level waittill ("tank dead"); 
	   
	      

}
*/

//BACK OF FIELD
attack_wave01()
{

 	   trigger = getent("wave01_spawners", "target");
 	   trigger notify("trigger");
 	   	   
}

//RIGHT SIDE 
attack_wave02()
{
	trigger = getent("wave02_spawners", "target");
	trigger notify("trigger"); 	   	   	   	  
}

//RIGHT SIDE
attack_wave03()
{
	trigger = getent("wave03_spawners", "target");
	trigger notify("trigger");	    
}

//GERMAN HALFTRACK
attack_halftrack02()
{
	
	trigger = getent("halftrack_attack01_trigger", "targetname");
	trigger notify("trigger");
	
	wait 1;
	//iprintlnbold ("Mcgregor - Halftrack coming in from the south!!");
	level.mcgregor dialogue_thread("breakout_mcg_halftracksouth"); 	   
	wait 1;
	autoSaveByName("halfway");	   
 	
}

//RIGHT SIDE
attack_player01()
{
	wait 1;
	trigger = getent("attack_player01_spawners", "target");
	trigger notify("trigger");
	wait 20;
	//iprintlnbold ("Mcgregor - The're charging the house lads!!"); 	
	level.mcgregor dialogue_thread("breakout_mcg_holddammit");             
}

//LEFT SIDE - SET GOAL
flanker_wave01()
{
	
	trigger = getent("flanker01_spawners", "target");
	trigger notify("trigger");
	   

}

//RIGHT SIDE - SET GOAL
flanker_wave02()
{

	trigger = getent("flanker02_spawners", "target");
	trigger notify("trigger");
	

}



//LEFT SIDE - SET GOAL
flanker_wave03()
{
	trigger = getent("flanker03_spawners", "target");
	trigger notify("trigger");
	
	autoSaveByName("flankers");
	wait 4;
	//iprintlnbold ("Gen -They're coming around the left flank!!! Get over there and stop 'em!!!");
	brit = get_brit();
	if (isdefined(brit))
		brit thread Dialogue_Thread("breakout_leftflank_warning");
	
	wait 40;
	brit = get_brit();
	if (isdefined(brit))		
		brit thread Dialogue_Thread("breakout_leftflank_warning");	
                 
}

//RIGHT SIDE - TO PLAYER
flanker_wave04()
{

	trigger = getent("flanker04_spawners", "target");
	trigger notify("trigger");
   
   		

}

//LEFT SIDE - TO PLAYER
flanker_wave05()
{

	trigger = getent("flanker05_spawners", "target");
	trigger notify("trigger");
	wait 4;
	//iprintlnbold ("Gen -They're coming around the left flank!!! Get over there and stop 'em!!!");
	brit = get_brit();
	if (isdefined(brit))
		brit thread Dialogue_Thread("breakout_leftflank_warning");
	
	wait 30;
	brit = get_brit();
	if (isdefined(brit))		
		brit thread Dialogue_Thread("breakout_leftflank_warning");	
	

}

//RIGHT SIDE - TO PLAYER
flanker_wave06()
{
	trigger = getent("flanker06_spawners", "target");
	trigger notify("trigger"); 	   
}

//LEFT SIDE - TO PLAYER
flanker_wave07()
{

	trigger = getent("flanker07_spawners", "target");
	trigger notify("trigger");
   
}

//LEFT SIDE - TO PLAYER
flanker_wave08()
{

	trigger = getent("flanker08_spawners", "target");
	trigger notify("trigger");
   
}


//TANK ATTACK

tiger01_spawn_wait()
{
	level.tiger01 = maps\_vehicle::waittill_vehiclespawn("tiger01");
	level.tiger01 thread tank_explosives();
	level.tiger01.pos_id = 0;
	level.tiger01 thread objective_follow(6,"show tiger01");
		
}

tankdefenders()
{
	wait 2;
	trigger = getent("tank_defender_spawners", "target");
	trigger notify("trigger");

}

attack_tigertank01()
{
	
	trigger = getent("tiger01_trigger", "targetname");
	trigger notify("trigger");
	level.tiger01 = maps\_vehicle::waittill_vehiclespawn("tiger01");
	
	level notify ("tank_mission");  	   	   
	level.tiger01 waittill ("death");
	level notify ("tank dead");
	setAmbientAlias("exterior", "2");	
	wait 2;
	autoSaveByName("tankdead");       
       	
}

tank_mission()
{

	level waittill ("tank_mission");
	wait 3;
	//iprintlnbold ("Mcgregor -Tiger tank!!");
	level.mcgregor dialogue_thread("breakout_mcg_tigertank");
	wait 5;
	brit = get_brit();
	if (isdefined(brit))
	brit thread Dialogue_Thread("breakout_bs4_antitankweapon");
	setAmbientAlias("exterior", "3");	
	wait 5;
	level.price dialogue_thread("breakout_pri_killtank");  	
	
	level notify ("kill the tank");
	wait 5;
	autoSaveByName("tankmission");	
	tankattack_ralleypoint = getnode("tankattack_ralleypoint","targetname");
	setgoalforguys(tankattack_ralleypoint);
	
	defend_radius = getnode("defend_radius","targetname");
	price_defend = getnode("price_defend","targetname");
	level.price setgoalnode (price_defend);
	level.price set_goalradius(price_defend.radius);	
	mac_defend = getnode("mac_defend","targetname");	   
	level.mcgregor setgoalnode (mac_defend);
	level.mcgregor set_goalradius(mac_defend.radius);
  
}

tank_mission_wave()
{
	level endon ("tank dead");
	level waittill ("kill the tank");	
	while (1)
	{
		wait 5;
		tankattack_ralleypoint = getnode("tankattack_ralleypoint","targetname");
		setgoalforguys(tankattack_ralleypoint);
    } 


}

tank_nag()
{
	level endon ("bomb planted");
	level waittill ("kill the tank");

	while (1)
	{
		wait 35;
		//iprintlnbold ("Price - Sergeant Davis! Use your explosives and plant them on that tank! Go!!!!"); 	
       	level.price thread dialogue_thread("breakout_pri_killtanknag");
    }   		
}


stop_spawners()
{

	trigger = getent("kill_spawners","targetname");
	assertex(isDefined(trigger), "kill_spawners trigger not found");
	level waittill("tank dead");
	trigger notify("trigger");
 
}

stop_spawners_right()
{

	trigger = getent("kill_spawners_right","targetname");
	assertex(isDefined(trigger), "kill_spawners_right trigger not found");
	level waittill("kill the tank");
	trigger notify("trigger");

}



blitz()
{
	level waittill("tank dead");
	german_retreat = getnode("german_retreat", "targetname");
	axis = getAIArray( "axis" );
	for ( index = 0; index < axis.size; index++ )
		{
			axis[index].ignoreme = false;
			axis[index].goalradius = 100;
			axis[index].fightdist = 0;
			axis[index].maxdist = 0;
			axis[index] setGoalnode(german_retreat);			
		}
	maps\_utility::exploder(17);
	maps\_utility::exploder(18);
	level thread cleanup_all();	
	
	wait 2;	
	axis = getAIArray( "axis" );
	for ( index = 0; index < axis.size; index++ )
		{
			axis[index].ignoreme = false;
			axis[index].goalradius = 100;
			axis[index].fightdist = 0;
			axis[index].maxdist = 0;
			axis[index] setGoalnode(german_retreat);			
		}	


}	
			

cleanup_all()
{	               
	wait 10;
	//CLEAN UP LOOSE ENDS  	                              
	level endon ("roll in");
	while (1)
	{
		wait 10;
		ai = getaiarray("axis");
		for(i=0;i<ai.size;i++)
		{
		   if(isalive(ai[i]))
		   {
		    	ai[i] doDamage (ai[i].health, ai[i].origin); 
    	   }
    	}
    } 	               

			
}

goToNodeAndDie(node)
{
	self setgoalnode(node); 
	self.goalradius = 8; 
	self waittill("goal"); 
	self delete(); 

}

	
reinforcements()
{

	level waittill("tank dead");
	trigger = getent("good_guys","targetname");
	assertex(isDefined(trigger), "good_guys trigger not found");
	trigger waittill("trigger");
	
	trigger1 = getent("res_truck01_trigger", "targetname");
	trigger1 notify("trigger");
	trigger2 = getent("res_tank01_trigger", "targetname");
	trigger2 notify("trigger");
	wait 1;
	trigger3 = getent("res_tank02_trigger", "targetname");
	trigger3 notify("trigger");
	
	//level thread sky_attack();
	//level thread sky_attack2();
 	   
}

ending_nag()
{
	level endon ("roll in");
	level waittill ("tank dead");
	wait 30;

	while (1)
	{
		wait 30;
		//iprintlnbold ("Price - Regroup lads! Regroup on my position!"); 	
       	level.price thread dialogue_thread("breakout_pri_regrouplads");
    }   		
}


ending()
{

	
	level waittill ("tank dead");
	
	ending_pricenode = getnode("ending_pricenode","targetname");
	ending_noderadius = getnode("ending_noderadius","targetname");
		
	flag_set("music_start");
	wait 1;
	//iprintlnbold ("Gen - Looks like they're retreating!!");	   
	brit = get_brit();
	if (isdefined(brit))
	brit thread Dialogue_Thread("breakout_bs2_looksretreating");	   
	//iprintlnbold ("BS3 - That got him!!");  
	wait 2;
	brit = get_brit();
	if (isdefined(brit))	       	
	brit thread Dialogue_Thread("breakout_bs4_comebackanytime");
	//level waittill ("all clear");			       
	wait 2;
	//iprintlnbold ("Price - We did it lads!!"); 
	level.price dialogue_thread("breakout_pri_wedidit");         
	wait 1;
	//iprintlnbold ("Price - Regroup lads! Reinforcements have arrived!!!");
	level.price dialogue_thread("breakout_pri_regroupoutback");
	          
	schoolcircle("endbriefing_node", "Cpt. Price", "ending_pricenode", level.price, "ending_noderadius");	
		 
	level notify ("roll in");      	               
	wait 2;
	level.price dialogue_thread("breakout_pri_7tharmored");      
	//iprintlnbold ("Price -Bloody fine work, men. The 7th Armored's made it out of this mess thanks to your efforts on the exposed flank.");
	//iprintlnbold ("Our job here is done and there's no need for us to stay a moment longer. Come on - let's get the hell out of here.");   
	wait 1.5;     
	maps\_endmission::nextmission();
       
}           
       
//RANDOM JUNK

forcekillnode(node)
{
	node waittill ("trigger",other);
	radiusDamage (other.origin, 2, 10000, 9000);
}

set_goalradius(radius)
{
       if (!isdefined(radius))
       {
               if (isdefined(self.old_goalradius))
               {
                       self.goalradius = self.old_goalradius;
                       self.old_goalradius = undefined;
               }
               return;
       }

       if (!isdefined(self.old_goalradius))
               self.old_goalradius = self.goalradius;
       self.goalradius = radius;
}

set_goalnode(node,range)
{
       self endon("death");
       self notify("abort_chain");

       assert(isdefined(node));
       if (isdefined(range))
       {
               assert(range >= 0.1);
               wait randomfloatrange (0.1, range);
       }
       if (isdefined(node.radius))
               self.goalradius = node.radius;
       if (isalive(self))
               self setgoalnode(node);
}

follow_chain(first_node)
{
       self endon("death");
       self endon("abort_chain");
       node = first_node;

       while(true)
       {
               if(!isalive(self))
                       break;
               self setgoalnode(node);
               assert(isdefined(node.radius));
               self.goalradius = node.radius;
               if (!isdefined(node.target))
                       break;
               node = getnode(node.target,"targetname");
               self waittill("goal");
               wait 6; // wait time before moving on to the next goal node.
       }
}

setup_sortie()
{
    aSpawner = getentarray("sortie","script_noteworthy");
    level array_thread(aSpawner, ::sortie); }

sortie()
{
    while(true)
    {
        self waittill("spawned",ai);
        ai thread sortie_wait(self.script_wait,self.script_waittill);
    }
}

sortie_wait(waittime, waitstring)
{
    self endon("death");
    self endon("escape your doom");

    if (isdefined(waitstring))
        level waittill(waitstring);
    else
        self waittill("goal");
    if (isdefined(waittime))
        wait randomfloatrange(waittime,waittime+4);

    println("sortie " + self getentitynumber());

    self setgoalentity(level.player);
    self.goalradius = 50;
}

dialogue_thread(dialogue)
{
	self setBattleChatter(false);

	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	
	facial = undefined;	
	
	level maps\_anim::anim_single_solo(self, dialogue);
	//self thread animscripts\face::SaySpecificDialogue(facial, dialogue, 1.0, "single dialogue");
	//self waittill ("single dialogue");
	
	self setBattleChatter(true);
	self.MyIsSpeaking = false;
	self notify("my done speaking");
}

objective_follow(obj_id,notify_string)
{
	self endon("stop objective follow");
	self endon("death");

	if (isdefined(notify_string))
		level waittill(notify_string);

	if (isdefined(self.pos_id))
	{
		while (true)
		{
			wait 1;
			objective_additionalposition(obj_id, self.pos_id, self.origin);
		}
	}
	else
	{
		while (true)
		{
			wait 1;
			objective_position(obj_id, self.origin);
		}
	}
}

tank_explosives()
{
	self endon ("death");

	self thread tank_ondeath();
	self.bombTriggers = [];
	self.bombs = [];

	tags = [];
	location_angles = [];
	tags[0] = "tag_gastank_left";
	tags[1] = "tag_left_wheel_09";
	tags[2] = "tag_right_wheel_09";
	
	location_angles[0] = self.angles + (0,0,0);
	location_angles[1] = self.angles + (180,90,0);
	location_angles[2] = self.angles + (0,90,0);


	for (i=0; i < tags.size; i++)
	{
		bomb = spawn("script_model", self gettagorigin(tags[i]));
		bomb setmodel("xmodel/military_tntbomb_obj");
		bomb.angles = location_angles[i];
		bomb linkto(self,tags[i]);

		bomb.trigger = undefined;

		aTrigger = getentarray("sticky_trigger","targetname");
		for (t=0; t < aTrigger.size; t++)
		{
			if (!isdefined(aTrigger[t].inuse))
			{
				bomb.trigger = aTrigger[t];
				break;
			}
		}

		assert(isdefined(bomb.trigger));
		bomb.trigger.inuse = true;

		bomb.trigger.oldorigin = bomb.trigger.origin;
		bomb.trigger.origin = bomb.origin;
		if (!isdefined(bomb.trigger.linktoenable))
			bomb.trigger enablelinkto();
		bomb.trigger.linktoenable = true;
		bomb.trigger linkto(bomb);

		self.bombs[i] = bomb;
		self thread tank_explosives_wait(bomb.trigger,i);
	}

	self waittill ("explosives planted",id);

	badplacename = ("tank_badplace_" + randomfloat(1000));
	badplace_cylinder(badplacename, -1, self.origin, 250, 300);
	
	iprintlnbold (&"BREAKOUT_EXPLOSIVES_PLANTED");
	level notify ("bomb planted");
	bomb = self.bombs[id];

	level thread remove_stickys(self.bombs,id);

	bomb setmodel ("xmodel/military_tntbomb");
	bomb playsound ("explo_plant_rand");
	bomb playloopsound ("bomb_tick");

	self stopwatch(bomb);

	badplace_delete(badplacename);
	
	self notify ("death", level.player);
	bomb delete();

	
}

remove_stickys(bombs, id)
{
	if (!isdefined(id))
		id = 1000; // a value that will never match
	for (i=0;i < bombs.size;i++)
	{
		if (!isdefined(bombs[i]))
			continue;
		bombs[i].trigger unlink();
		bombs[i].trigger.inuse = undefined;
		bombs[i].trigger.origin =  bombs[i].trigger.oldorigin;

		if (i != id)
			bombs[i] delete();
	}
}




tank_explosives_wait(trigger,id)
{
	self endon ("death");
	self endon ("explosives planted");
	
	trigger setHintString (&"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES");
	while(true)
	{
		trigger waittill ("trigger");
		level.player.tnt--;
		if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();		

		level notify ("explosives planted");
		self notify ("explosives planted", id);
		return;
	}
}

tank_ondeath()
{
	self waittill("death");
	level thread remove_stickys(self.bombs);
	level notify("tank destroyed",self.pos_id);
}

stopwatch(bomb)
{
	if (isdefined (self.bombstopwatch))
		self.bombstopwatch destroy();
	self.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	wait level.explosiveplanttime;
	bomb stoploopsound ("bomb_tick");
	level.timersused--;
	if (level.timersused < 1)
	{
		if (isdefined (self.bombstopwatch))
			self.bombstopwatch destroy();
	}
}

music()
{
	flag_wait("music_start");
	
	wait 5;
	musicplay("breakout_victory");
}

charge_anim()
{
	self.run_noncombatanim = %combat_run_fast_3;
	level waittill("charge done");
	self.run_noncombatanim = undefined;
}

schoolcircle(nodename, leadername, leaderNodeName, leader, locationName)
{	
	//Makes any number of Allied troops assemble with a leader, useful for regrouping for in-level briefings
	
	//nodename = targetname of the nodes used by the grunts
	//leadername = script_friendname of the commanding officer character who will give the speech
	//leaderNodeName = targetname of the node used by the commander
	//leader = variable used to represent the leader character entity
	//locationName = targetname of the location shown on the compass, player must enter within 192 units of this to arrive
	
	failSafeBlocker = undefined;
	
	aTroops = [];
	nodearray = getnodearray(nodename, "targetname");
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{	
		if(!isdefined(aAllies[i].script_friendname))
		{
			aTroops[aTroops.size] = aAllies[i];
		}
		else
		if(aAllies[i].script_friendname != leadername)
		{
			if(nodename == "barnbriefing_node" && aAllies[i].script_friendname == "Cpt. Price")
			{
				price_barn = getnode("price_barn", "targetname");
				aAllies[i] setgoalnode(price_barn);
				continue;
			}
			
			if(nodename == "barnbriefing_node" && aAllies[i].script_friendname == "Pvt. MacGregor")
			{
				mac_barn = getnode("mac_barn", "targetname");
				aAllies[i] setgoalnode(mac_barn);
				continue;
			}

			if(nodename == "endbriefing_node" && aAllies[i].script_friendname == "Cpt. Price")
			{
				ending_pricenode = getnode("ending_pricenode", "targetname");
				aAllies[i] setgoalnode(ending_pricenode);
				continue;
			}
			

			
			aTroops[aTroops.size] = aAllies[i];
		}
	}
	
	for(i=0; i<aTroops.size; i++)
	{
		aTroops[i] thread schoolcircle_nav(nodearray, i);
	}
	
	leaderNode = getnode(leaderNodeName, "targetname");
	leader.goalradius = 64;
	leader setgoalnode(leaderNode);
	leader waittill ("goal");
	
	//Wait for player to meet up with the squad
	
	briefingPoint = getnode(locationName, "targetname");
	dist = length(level.player.origin - briefingPoint.origin);
	while(dist > 256)
	{
		dist = length(level.player.origin - briefingPoint.origin);
		wait 0.1;
	}	
}

schoolcircle_nav(nodearray, i)
{
	self endon ("death");
	
	wait 2.5;	//soft wait to avoid traffic jams w/ leader
	self setgoalnode(nodearray[i]);
	self.goalradius = 32;
	self.dontavoidplayer = true;
	self allowedstances ("stand");
	if(!isdefined(nodearray[i].script_noteworthy))
		return;
	if(nodearray[i].script_noteworthy == "kneel")
		thread schoolcircle_crouch(self);
}

schoolcircle_crouch(soldier)
{
	soldier waittill ("goal");
	soldier allowedstances ("crouch");
}

