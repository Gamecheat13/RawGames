//player controlled bombing runs, modified from the rocket barrage hotness
/*
To use:

Call this line above _load:
	thread maps\oki3_dpad_asset::airstrike_init(); 

Call this line in your onPlayerSpawn function in your level:
		self thread maps\oki3_dpad_asset::airstrike_player_init();
	

*/
#include maps\_utility;
#include common_scripts\utility;
#include maps\oki3_util;

#using_animtree ("generic_human");

// needs to be called above _load in your level
airstrike_init()
{	
	level._effect["target_arrow"]						= loadfx ("misc/fx_ui_airstrike");
	level._effect["target_arrow_confirm"]		= loadfx ("misc/fx_ui_airstrike_confirm");
	
	level.rocketbarrage_traceLength = 4000;			// the furthest distance the player can fire
	level.barrage_charge_time = 45; 						// time in seconds until player can use again
	level.rocket_barrage_allowed = false;				// is the barrage allowed to be used now?
	level.friendly_check_radius = 512;					// friendlies in this radius will disallow barrage use
	level thread airstrike_ammo_giver();
	level thread airstrike_ammo_taker();																						
}

// needs to be threaded on each player in your onSpawn function in your level
airstrike_player_init()
{	
	self.rocket_targeting_on = false;							// is the player targeting at the moment?
	self.is_firing_rocket_barrage = false;				// the barrage being fired by the player?
	self.rocket_barrages_remaining = 1;						// number of barrages left
	self.rockets_are_out_times = 0;								// this is for the radio guys dialogue: keeping tally on how many barrages you have left
	self.rocket_barrage_friendly_fire_count = 0;	// this is for the radio guys dialogue: you aimed at an enemy
	self.rocket_barrage_ai_was_hit = false;				// this is for the radio guys dialogue: was enemy hit?
	self.rocket_barrage_ok = false;								// is the barrage fire valid?	
	
	self thread rocket_barrage_watcher();	
	//self thread rocket_barrage_hud_elements_think();
}

airstrike_ammo_taker()
{
	level endon("stop_air_support");
	while(1)
	{
		level waittill("take_ammo");
		remove_airstrike_from_all();
	}
}

airstrike_ammo_giver()
{
	level endon("stop_air_support");
	while(1)
	{	
		level waittill("give_ammo");
		give_airstrike_to_all();
	}
}

// this basically stays on, looping. this keeps an eye on everything, allows, targeting
// etc.
rocket_barrage_watcher()
{
	self endon ("death");													// remember to put these on player functions for co-op
	self endon ("disconnect");
	level endon("stop_air_support");									
			
	for(;;)
	{
		weap = self getcurrentweapon();
		
		if(weap == "air_support" && !is_radio_available(self) )
		{
				//do nothing - radio not available
		}
				
		else if (weap == "air_support" && self maps\_laststand::player_is_in_laststand() )
		{
			self GiveWeapon( self.laststandpistol );
			ammoclip = WeaponClipSize( self.laststandpistol );
			self SetWeaponAmmoStock( self.laststandpistol, ammoclip * 2 );
			self SwitchToWeapon( self.laststandpistol );				
		}		
		else
		{
		// if the player isn't firing and firing is allowed at the moment
			if (!self.is_firing_rocket_barrage && level.rocket_barrage_allowed )
			{
								
				// if the weapons is the rocket barrage and targeting isnt on
				if(self getcurrentweapon() == "air_support" && !self.rocket_targeting_on )//&& isDefined(self.first_with_radio) )
				{
					// begin targeting (smoke)
					self thread rocket_barrage_targeting();
					self.rocket_targeting_on = true;
					//wait_network_frame();
				}	
				// if the weapon is rocket barrage and you're already targeting, turn it off
				else if(self getcurrentweapon() != "air_support" && self.rocket_targeting_on)
				{
					self.Rocket_Targeting_On = false;							
					self notify("end rocket barrage targeting");							
					delete_spotting_target();
					//wait_network_frame();
				}
				else if( self getcurrentweapon() != "air_support") 
				{
					self.Rocket_Targeting_On = false;							
					self notify("end rocket barrage targeting");							
					delete_spotting_target();
					//wait_network_frame();				
				}
			}
			// if player is firing and the barrage is allowed
			else if (self.is_firing_rocket_barrage && level.rocket_barrage_allowed)
			{
				// if the player is trying to fire while the barrage is going, send a notify
				if(self getcurrentweapon() == "air_support")
				{
					self notify ("activate pressed during barage");
					wait 0.1;
				}
			}
		}
		wait_network_frame();
	}
}

// Targeting thread, sets up the drawing of smoke
rocket_barrage_targeting()
{
	self endon ("end rocket barrage targeting");		
	self endon ("rocket barrage firing");
	self endon ("death");
	self endon ("disconnect");	
	self notify("start rocket barrage targeting");	
	
	for (;;)
	{

		// Trace to where the player is looking
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();
		
		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace2 = bullettrace( eye, eye + vector_multiply( direction_vec , level.rocketbarrage_traceLength ), 0, undefined );
		//trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"] - (0,0,100000), 0, undefined );
		
		//if we've already got a target reticule , just move it
		if(isDefined(self.rocket_barrage_target))
		{
			self.rocket_barrage_target.origin = trace2["position"];
			self.rocket_barrage_target rotateTo( vectortoangles( trace2["normal"] ), 0.15 );
		}
//		
		//grab all the friendlies & players and make sure that players can't target too close
		friends = getaiarray("allies");
		players = get_players();		
		friends = array_merge(friends, players);
		strike_ok = true;		
		for (i = 0; i < friends.size; i++)
		{
			if (distance(trace2["position"], friends[i].origin) <= level.friendly_check_radius)
			{
				strike_ok = false; 
			}			
		}		
		self.rocket_barrage_ok = strike_ok;
		
		
		//not a valid target area
		if(get_firepoint_target( trace2["position"] ) == "none")
		{
			self.rocket_barrage_ok = false;
		}
		else
		{
			self.rocket_barrage_ok = true;
		}
		
		//draw the reticule and allow the player to target if it's OK 
		//if(self.rocket_barrage_ok)
		//{
			if(!isdefined(self.rocket_barrage_target))
			{
				targetpoint = spawn("script_model", trace2["position"]);
				targetpoint setmodel("tag_origin");
				self.rocket_barrage_target = targetpoint;
				self thread draw_target(self.rocket_barrage_target);
			}
			else
			{
				self.rocket_barrage_target.origin = trace2["position"];
				self.rocket_barrage_target rotateTo( vectortoangles( trace2["normal"] ), 0.15 );
				self thread draw_target(self.rocket_barrage_target);
			}
			
		//}

		//else
		//{
		//	delete_spotting_target();
		//}	
		
		self thread air_support_watch( trace2["position"] );
				
		wait_network_frame();
	}
}

// draws the target reticule
draw_target(targetpoint)
{
		self endon ("death");
		self endon ("disconnect");
		self endon ("target smoke deleted");
		
		if(!isDefined(targetpoint.fx_drawn))
		{	
			targetpoint.fx_drawn = true;
			playfxontag(level._effect["target_arrow"], targetpoint, "tag_origin");
		}
}


air_support_watch(fire_point)
{		
	self endon ("death");
	self endon ("disconnect");
		
	// confirming the player's fire
	if(self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && self.rocket_barrage_ok)
	{	
		//make sure they're targetting the right building	
		if(is_valid_airstrike_target(get_firepoint_target(fire_point)))
		{		
			self thread air_support_switch_back();
			self.is_firing_rocket_barrage = true;
			self.rocket_targeting_on = false;								
			self.rocket_barrages_remaining--;				
			self thread rocket_barrage_fire(fire_point);
		}
		else
		{	
			self notify("end rocket barrage targeting");		
			level.last_hero thread do_dialogue("negative");
			delete_spotting_target();
			self thread air_support_switch_back();
		}
	}	
	
	// let the player know how much time is left
	else if(self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && self.rocket_barrages_remaining <= 0)
	{
		self thread air_support_switch_back();
	}
	
	// friendly fire! not firing!
	else if (self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && !self.rocket_barrage_ok)
	{
		self notify("end rocket barrage targeting");
		level.last_hero thread do_dialogue("negative");
		delete_spotting_target();
		self thread air_support_switch_back();		
	}
}

// rocket barrage is actually firing now
rocket_barrage_fire(fire_point)
{
	self endon ("death");
	self endon ("disconnect");
	level endon("stop_air_support");		

	self notify ("rocket barrage firing");
	target = get_firepoint_target(fire_point);
	
		
	switch(target)
	{
		case "building_1": 
			
			thread maps\oki3_courtyard::destroy_building1();
			self thread arcademode_airstrike_score();
			break;
			
		case "building2": 
		case "building3": 
			break;
		
		case "building_4": 
		case "building_5":
		case "building_6": 		
			
			thread maps\oki3_courtyard::destroy_building4();
			self thread arcademode_airstrike_score();
			break;
		
		case "courtyard_ne":thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_ne_spline");break;
		case "courtyard_se":thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_se_spline");break;
		case "courtyard_nw":thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_nw_spline");break;
		case "courtyard_sw":thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_sw_spline");break;

		case "none": break;
	}
	
	// remove target reticule	
	if(target == "none" ||  target == "building_5" ||  target == "building_6" || target == "building_7")
	{
		self notify("end rocket barrage targeting");
		level.last_hero thread do_dialogue("negative");			
		delete_spotting_target();
		return;
	}
	else
	{
		level.no_nag_dialogue = true;
		self.rocket_barrage_confirm = spawn("script_model",fire_point);
		self.rocket_barrage_confirm setmodel("tag_origin");
		self.rocket_barrage_confirm.angles = self.rocket_barrage_target.angles;
		delete_target();
		playfxontag(level._effect["target_arrow_confirm"], self.rocket_barrage_confirm, "tag_origin");
		thread delete_confirm_arrow();
		
		//remove ammo for all players
		level notify("take_ammo");	
		
		level.last_hero thread do_dialogue("confirmed" + randomint(2));
		level notify("airstrike_used",target);
	}
	
	// wait until recharge	
	//wait (level.barrage_charge_time);
	do_countdown_dialogue();
		
	level notify("give_ammo");		
	level.last_hero thread do_dialogue("available" + randomint(4));
	level.no_nag_dialogue = undefined;
	
	self notify ("rocket barrage recharging");
	self.rocket_barrage_fired_at_time = gettime();
	
	self.is_firing_rocket_barrage = false;
}

remove_airstrike_from_all()
{	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] setweaponammoclip("air_support",0);
		players[i].rocket_barrages_remaining = 0;

	}	
}


give_airstrike_to_all()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] giveweapon ( "air_support" );
 		players[i] GiveMaxAmmo( "air_support" );
 		players[i].rocket_barrages_remaining ++;
	}
}



delete_target(wait_time)
{
	self endon("death");
	self endon("disconnect");
	
	if(isDefined(wait_time))
	{
		wait(wait_time);
	}
	delete_spotting_target();
	
}

delete_confirm_arrow()
{
	self endon("death");
	self endon("disconnect");
	
	wait(11);
	if(isDefined(self.rocket_barrage_confirm))
	{
		self.rocket_barrage_confirm delete();
	}
	
}


// get rid of the spotting target, just delete it
delete_spotting_target()
{
	self endon ("death");
	self endon ("disconnect");
			
	if (isdefined(self.rocket_barrage_target))
	{
		self.rocket_barrage_target delete();
	}	
	self.rocket_barrage_target = undefined;
	self notify ("target smoke deleted");
			
}

//show/hide the air support 
rocket_barrage_hud_elements_think()
{
	self endon ("death");
	self endon ("disconnect");
			
	while (1)
	{
		self waittill ("rocket barrage firing");
		level notify("airstrike");
		wait(level.barrage_charge_time);
	}
}

/*------------------------------------
check to see where the player targeted the air support
------------------------------------*/
get_firepoint_target(fire_point)
{
	x = spawn("script_origin",fire_point);
	
	trigs = getentarray("airstrike_target","targetname");
	for(i=0;i<trigs.size;i++)
	{
		if(x istouching(trigs[i]))
		{
			x delete();
			return trigs[i].script_noteworthy;
		}
	}	
	x delete();
	return("none");
	
}


/*------------------------------------
switch the weapon back after the radio is used
------------------------------------*/
air_support_switch_back()
{		
	primaryWeapons = self GetWeaponsListPrimaries();

	if( IsDefined( primaryWeapons ) )
	{
		// CODER_MOD: Austin (7/24/08): switch to "colt" if using these cheats
		if ( maps\_collectibles::has_collectible( "collectible_sticksstones" ) || maps\_collectibles::has_collectible( "collectible_berserker" ) )
			self SwitchToWeapon( primaryWeapons[0] );
		else
			self SwitchToWeapon( primaryWeapons[1] );
	}
	
	self.rocket_targeting_on = false;
}


is_valid_airstrike_target(target)
{

	switch(target)
	{
		
		case "building_1":					
			if(isDefined(level.building1_destroyed) && level.building1_destroyed)
			{
				return false;
			}
			else
			{
				return true;
			}
			break;					
			
		case "building_4":
			if(!isDefined(level.building1_destroyed))
			{
				return false;
			}
			else
			{	
				return true;
			}
			break;
					
		case "courtyard_ne"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_ne_spline");break;
		case "courtyard_se"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_se_spline");break;
		case "courtyard_nw"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_nw_spline");break;
		case "courtyard_sw":
			return true;
			
		default:
			return false;
		}
}

do_countdown_dialogue()
{
	wait(7);
	level.last_hero thread do_dialogue("45_sec");
	for(i=level.barrage_charge_time;i>0;i--)
	{
		wait(1);
		if(i == 30)
		{
			level.last_hero thread do_dialogue("30_sec");
		}
		if(i == 20)
		{
			level.last_hero thread do_dialogue("20_sec");
		}
		
		if(i == 10)
		{
			level.last_hero thread do_dialogue("10_sec");
		}
		
		if(i == 5)
		{
			level.last_hero thread do_dialogue("5_sec");
		}
	}
	
}

arcademode_airstrike_score()
{
	self endon("death");
	self endon("disconnect");
	
	wait(13);
	maps\_utility::arcademode_assignpoints( "arcademode_score_generic250", self );
	
}