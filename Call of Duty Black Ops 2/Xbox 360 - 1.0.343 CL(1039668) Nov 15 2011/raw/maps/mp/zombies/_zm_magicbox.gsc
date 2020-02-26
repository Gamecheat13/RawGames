#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_weapons; 


init()
{
	PrintLn( "ZM >> MagicBox Init (_zm_magicbox.gsc)" );
	
	treasure_chest_init();
}



// for the random weapon chest
//
//	The chests need to be setup as follows:
//		trigger_use - for the chest
//			targets the lid
//		lid - script_model.  Flips open to reveal the items
//			targets the script origin inside the box
//		script_origin - inside the box, used for spawning the weapons
//			targets the box
//		box - script_model of the outer casing of the chest
//		rubble - pieces that show when the box isn't there
//			script_noteworthy should be the same as the use_trigger + "_rubble"
//
treasure_chest_init()
{
//T6todo	if( level.mutators["mutator_noMagicBox"] )
//T6todo	{
//T6todo		chests = GetEntArray( "treasure_chest_use", "targetname" );
//T6todo		for( i=0; i < chests.size; i++ )
//T6todo		{
//T6todo			chests[i] get_chest_pieces();
//T6todo			chests[i] hide_chest();
//T6todo		}
//T6todo		return;
//T6todo	}
	
	flag_init("moving_chest_enabled");
	flag_init("moving_chest_now");
	flag_init("chest_has_been_used");
	
	level.chest_moves = 0;
	level.chest_level = 0;	// Level 0 = normal chest, 1 = upgraded chest
	level.chests = GetEntArray( "treasure_chest_use", "targetname" );
	PrintLn( "ZM >> Magic Box Count " + level.chests.size );
	
	if( level.chests.size==0 )
		return;
	
	for (i=0; i<level.chests.size; i++ )
	{
		level.chests[i].orig_origin = level.chests[i].origin;
		level.chests[i] get_chest_pieces();

		if ( isDefined( level.chests[i].zombie_cost ) )
		{
			level.chests[i].old_cost = level.chests[i].zombie_cost;
		}
		else
		{
			// default chest cost
			level.chests[i].old_cost = 950;
		}
	}

	level.chest_accessed = 0;

	if (level.chests.size > 1)
	{
		flag_set("moving_chest_enabled");
	
		level.chests = array_randomize(level.chests);

		//determine magic box starting location at random or normal
		//init_starting_chest_location();
	}
	else
	{
		level.chest_index = 0;
	}
	
	//determine magic box starting location at random or normal
	init_starting_chest_location();

	PrintLn( "ZM >> Run think on " + level.chests.size + "magix boxes" );
	array_thread( level.chests, ::treasure_chest_think );
}



init_starting_chest_location()
{
	level.chest_index = 0;
	start_chest_found = false;
	
	if( level.chests.size==1 )
	{
		//Only 1 chest in the map
		level.chests[level.chest_index] hide_rubble();
		start_chest_found = true;
	}
	else
	{
		for( i = 0; i < level.chests.size; i++ )
		{
			if( isdefined( level.random_pandora_box_start ) && level.random_pandora_box_start == true )
			{
				if ( start_chest_found || (IsDefined( level.chests[i].start_exclude ) && level.chests[i].start_exclude == 1) )
				{
					level.chests[i] hide_chest();	
				}
				else
				{
					level.chest_index = i;
					level.chests[level.chest_index] hide_rubble();
					start_chest_found = true;
				}

			}
			else
			{
				// Semi-random implementation (not completely random).  The list is randomized
				//	prior to getting here.
				// Pick from any box marked as the "start_chest"
				if ( start_chest_found || !IsDefined(level.chests[i].script_noteworthy ) || ( !IsSubStr( level.chests[i].script_noteworthy, "start_chest" ) ) )
				{
					println( "ZM >> START CHEST HIDDEN" );
					level.chests[i] hide_chest();	
				}
				else
				{
					println( "ZM >> START CHEST FOUND!!!!!!!!" );
					level.chest_index = i;
					level.chests[level.chest_index] hide_rubble();
					start_chest_found = true;
				}
			}
		}
	}

	// Show the beacon
	if( !isDefined( level.pandora_show_func ) )
	{
		level.pandora_show_func = ::default_pandora_show_func;
	}

	level.chests[level.chest_index] thread [[ level.pandora_show_func ]]();
}


//
//	Rubble is the object that is visible when the box isn't
hide_rubble()
{
	rubble = getentarray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	if ( IsDefined( rubble ) )
	{
		for ( x = 0; x < rubble.size; x++ )
		{
			rubble[x] hide();
		}
	}
	else
	{
		println( "^3Warning: No rubble found for magic box" );
	}
}


//
//	Rubble is the object that is visible when the box isn't
show_rubble()
{
	if ( IsDefined( self.chest_rubble ) )
	{
		for ( x = 0; x < self.chest_rubble.size; x++ )
		{
			self.chest_rubble[x] show();
		}
	}
	else
	{
		println( "^3Warning: No rubble found for magic box" );
	}
}


set_treasure_chest_cost( cost )
{
	level.zombie_treasure_chest_cost = cost;
}

//
//	Save off the references to all of the chest pieces
//		self = trigger
get_chest_pieces()
{
	self.chest_lid		= GetEnt(self.target,				"targetname");
	self.chest_origin	= GetEnt(self.chest_lid.target,		"targetname");

//	println( "***** LOOKING FOR:  " + self.chest_origin.target );

	self.chest_box		= GetEnt(self.chest_origin.target,	"targetname");

	//TODO fix temp hax to separate multiple instances
	self.chest_rubble	= [];
	rubble = GetEntArray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	for ( i=0; i<rubble.size; i++ )
	{
		if ( DistanceSquared( self.origin, rubble[i].origin ) < 10000 )
		{
			self.chest_rubble[ self.chest_rubble.size ]	= rubble[i];
		}
	}
}

play_crazi_sound()
{
	self playlocalsound("zmb_laugh_child");
}



//
//	Show the chest pieces
//		self = chest use_trigger
//
show_chest()
{
	self thread [[ level.pandora_show_func ]]();

	self enable_trigger();

	self.chest_lid show();
	self.chest_box show();

	self.chest_lid playsound( "zmb_box_poof_land" );
	self.chest_lid playsound( "zmb_couch_slam" );
}

hide_chest()
{
	self disable_trigger();
	self.chest_lid hide();
	self.chest_box hide();

	if ( IsDefined( self.pandora_light ) )
	{
		self.pandora_light delete();
	}
}

default_pandora_fx_func( )
{
	self.pandora_light = Spawn( "script_model", self.chest_origin.origin );
	self.pandora_light.angles = self.chest_origin.angles + (-90, 0, 0);
	//	level.pandora_light.angles = (-90, anchorTarget.angles[1] + 180, 0);
	self.pandora_light SetModel( "tag_origin" );
//T6todo	playfxontag(level._effect["lght_marker"], self.pandora_light, "tag_origin");
}


//
//	Show a column of light
//
default_pandora_show_func( anchor, anchorTarget, pieces )
{
	if ( !IsDefined(self.pandora_light) )
	{
		// Show the column light effect on the box
		if( !IsDefined( level.pandora_fx_func ) )
		{
			level.pandora_fx_func = ::default_pandora_fx_func;
		}
		self thread [[ level.pandora_fx_func ]]();
	}
	playsoundatposition( "zmb_box_poof", self.chest_lid.origin );
	wait(0.5);

	playfx( level._effect["lght_marker_flare"],self.pandora_light.origin );
	
	//Add this location to the map
	//Objective_Add( 0, "active", "Mystery Box", self.chest_lid.origin, "minimap_icon_mystery_box" );
}

treasure_chest_think()
{
	PrintLn( "ZM >> START treasure_chest_think (_zm_magicbox.gsc)" );
	
	if( IsDefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] )
	{
		PrintLn( "ZM >> treasure_chest_think set_hint_string fire sale on(_zm_magicbox.gsc)" );
		self set_hint_string( self, "powerup_fire_sale_cost" );
	}
	else
	{
		PrintLn( "ZM >> treasure_chest_think set default hint string (_zm_magicbox.gsc)" );
		self set_hint_string( self, "default_treasure_chest_" + self.zombie_cost );
	}
	
	PrintLn( "ZM >> treasure_chest_think BOOOOOOOO (_zm_magicbox.gsc)" );
	self setCursorHint( "HINT_NOICON" );

	// waittill someuses uses this
	user = undefined;
	user_cost = undefined;
	while( 1 )
	{
		self waittill( "trigger", user ); 
		
		if( user in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( user is_drinking() )
		{
			wait( 0.1 );
			continue;
		}

		if ( is_true( self.disabled ) )
		{
			wait( 0.1 );
			continue;
		}

		if( user GetCurrentWeapon() == "none" )
		{
			wait( 0.1 );
			continue;
		}

		// make sure the user is a player, and that they can afford it
		if( is_player_valid( user ) && user.score >= self.zombie_cost )
		{
			user maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost );
			user_cost = self.zombie_cost; 
			self.chest_user = user;
			break; 
		}
		else if ( user.score < self.zombie_cost )
		{
			user maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 2 );
			continue;	
		}

		wait 0.05; 
	}

	flag_set("chest_has_been_used");

	self._box_open = true;
	self._box_opened_by_fire_sale = false;
	if ( is_true( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		self._box_opened_by_fire_sale = true;
	}

	//open the lid
	self.chest_lid thread treasure_chest_lid_open();

	// SRS 9/3/2008: added to help other functions know if we timed out on grabbing the item
	self.timedOut = false;

	// mario kart style weapon spawning
	self.chest_origin thread treasure_chest_weapon_spawn( self, user ); 

	// the glowfx	
	self.chest_origin thread treasure_chest_glowfx(); 

	// take away usability until model is done randomizing
	self disable_trigger(); 

	self.chest_origin waittill( "randomization_done" ); 

	// refund money from teddy.
	if (flag("moving_chest_now") && !self._box_opened_by_fire_sale && IsDefined(user_cost))
	{
		user maps\mp\zombies\_zm_score::add_to_player_score( user_cost, false );
	}

	if (flag("moving_chest_now") && !level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		//CA AUDIO: 01/12/10 - Changed dialog to use correct function
		//self.chest_user maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "box_move" );
		self thread treasure_chest_move( self.chest_user );
	}
	else
	{
		// Let the player grab the weapon and re-enable the box //
		self.grab_weapon_hint = true;
		self.chest_user = user;
		self sethintstring( &"ZOMBIE_TRADE_WEAPONS" ); 
		self setCursorHint( "HINT_NOICON" ); 
		
		
		self	thread decide_hide_show_hint( "weapon_grabbed");
		//self setvisibletoplayer( user );

		// Limit its visibility to the player who bought the box
		self enable_trigger(); 
		self thread treasure_chest_timeout();

		// make sure the guy that spent the money gets the item
		// SRS 9/3/2008: ...or item goes back into the box if we time out
		while( 1 )
		{
			self waittill( "trigger", grabber );
			
			if( IsDefined( grabber.is_drinking ) && grabber is_drinking() )
			{
				wait( 0.1 );
				continue;
			}

			if ( grabber == user && user GetCurrentWeapon() == "none" )
			{
				wait( 0.1 );
				continue;
			}

			if( grabber == user || grabber == level )			
			{
				current_weapon = "none";
				
				if(is_player_valid(user))
				{
					current_weapon = user GetCurrentWeapon();
				}
				
				if( grabber == user && is_player_valid( user ) && !user is_drinking() && !is_placeable_mine( current_weapon ) && "syrette_sp" != current_weapon )
				{
			//T6todo		bbPrint( "zombie_uses: playername %s playerscore %d teamscore %d round %d cost %d name %s x %f y %f z %f type magic_accept",
			//T6todo			user.playername, user.score, level.team_pool[ user.team_num ].score, level.round_number, self.zombie_cost, self.chest_origin.weapon_string, self.origin );
					self notify( "user_grabbed_weapon" );
					user thread treasure_chest_give_weapon( self.chest_origin.weapon_string );
					break; 
				}
				else if( grabber == level )
				{
					// it timed out
					unacquire_weapon_toggle( self.chest_origin.weapon_string );
					self.timedOut = true;
			//T6todo		if(is_player_valid(user))
			//T6todo		{
			//T6todo			bbPrint( "zombie_uses: playername %s playerscore %d teamscore %d round %d cost %d name %s x %f y %f z %f type magic_reject",
			//T6todo				user.playername, user.score, level.team_pool[ user.team_num ].score, level.round_number, self.zombie_cost, self.chest_origin.weapon_string, self.origin );
			//T6todo		}
					break;
				}
			}

			wait 0.05; 
		}

println( "ZM >> Weapon HINT REMOVED" );
		self.grab_weapon_hint = false;
		self.chest_origin notify( "weapon_grabbed" );

		if ( !is_true( self._box_opened_by_fire_sale ) )
		{
			//increase counter of amount of time weapon grabbed, but not during a fire sale
			level.chest_accessed += 1;
		}
			
		// PI_CHANGE_BEGIN
		// JMA - we only update counters when it's available
		if( level.chest_moves > 0 && isDefined(level.pulls_since_last_ray_gun) )
		{
			level.pulls_since_last_ray_gun += 1;
		}
		
		if( isDefined(level.pulls_since_last_tesla_gun) )
		{				
			level.pulls_since_last_tesla_gun += 1;
		}
		// PI_CHANGE_END

		self disable_trigger();

		// spend cash here...
		// give weapon here...
		self.chest_lid thread treasure_chest_lid_close( self.timedOut );

		//Chris_P
		//magic box dissapears and moves to a new spot after a predetermined number of uses

		wait 3;
		if ( is_true( level.zombie_vars["zombie_powerup_fire_sale_on"] ) || self == level.chests[level.chest_index] )
		{
			self enable_trigger();
			self setvisibletoall();
		}
	}

	self._box_open = false;
	self._box_opened_by_fire_sale = false;
	self.chest_user = undefined;
	
	self notify( "chest_accessed" );
	
	self thread treasure_chest_think();
}

//-------------------------------------------------------------------------------
//	Disable trigger if can't buy weapon and also if someone else is using the chest
//	DCS: Disable magic box hint if claymores out.
//-------------------------------------------------------------------------------
decide_hide_show_chest_hint( endon_notify )
{
	if( isDefined( endon_notify ) )
	{
		self endon( endon_notify );
	}

	while( true )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			// chest_user defined if someone bought a weapon spin, false when chest closed
			if ( (IsDefined(self.chest_user) && players[i] != self.chest_user ) ||
				 !players[i] can_buy_weapon() )
			{
				self SetInvisibleToPlayer( players[i], true );
			}
			else
			{
				self SetInvisibleToPlayer( players[i], false );
			}
		}
		wait( 0.1 );
	}
}

decide_hide_show_hint( endon_notify )
{
println( "ZM >> decide_hide_show_hint START" );

	if( isDefined( endon_notify ) )
	{
		self endon( endon_notify );
	}

	while( true )
	{
		if(IsDefined(self.chest_user))
		{
			if( is_placeable_mine( self.chest_user GetCurrentWeapon() ) )
			{
				self SetInvisibleToPlayer( self.chest_user);
			}
			else
			{
				self SetVisibleToPlayer( self.chest_user );
			}
		}
		else // all players
		{	
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] can_buy_weapon())
				{
					self SetInvisibleToPlayer( players[i], false );
				}
				else
				{
					self SetInvisibleToPlayer( players[i], true );
				}
			}
		}	
		wait( 0.1 );
	}
}

can_buy_weapon()
{
	if( IsDefined( self.is_drinking ) && self is_drinking() )
	{
		return false;
	}

	current_weapon = self GetCurrentWeapon();
	if( is_placeable_mine( current_weapon ) )
	{
		return false;
	}
	if( self in_revive_trigger() )
	{
		return false;
	}
	
	if( current_weapon == "none" )
	{
		return false;
	}

	return true;
}

//
//	Chest movement sequence, including lifting the box up and disappearing
//
treasure_chest_move( player_vox )
{
	level waittill("weapon_fly_away_start");

	players = get_players();
	
	array_thread(players, ::play_crazi_sound);

	level waittill("weapon_fly_away_end");

	self.chest_lid thread treasure_chest_lid_close(false);
	self setvisibletoall();

	self hide_chest();

	fake_pieces = [];
	fake_pieces[0] = spawn("script_model",self.chest_lid.origin);
	fake_pieces[0].angles = self.chest_lid.angles;
	fake_pieces[0] setmodel(self.chest_lid.model);

	fake_pieces[1] = spawn("script_model",self.chest_box.origin);
	fake_pieces[1].angles = self.chest_box.angles;
	fake_pieces[1] setmodel(self.chest_box.model);


	anchor = spawn("script_origin",fake_pieces[0].origin);
	soundpoint = spawn("script_origin", self.chest_origin.origin);

	anchor playsound("zmb_box_move");
	for(i=0;i<fake_pieces.size;i++)
	{
		fake_pieces[i] linkto(anchor);
	}

	playsoundatposition ("zmb_whoosh", soundpoint.origin );
	playsoundatposition ("zmb_vox_ann_magicbox", soundpoint.origin );


	anchor moveto(anchor.origin + (0,0,50),5);

	//anchor rotateyaw(360 * 10,5,5);
	if( isDefined( level.custom_vibrate_func ) )
	{
		[[ level.custom_vibrate_func ]]( anchor );
	}
	else
	{
	   //Get the normal of the box using the positional data of the box and self.chest_lid
	   direction = self.chest_box.origin - self.chest_lid.origin;
	   direction = (direction[1], direction[0], 0);
	   
	   if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	   {
            direction = (direction[0], direction[1] * -1, 0);
       }
       else if(direction[0] < 0)
       {
            direction = (direction[0] * -1, direction[1], 0);
       }
	   
        anchor Vibrate( direction, 10, 0.5, 5);
	}
	
	//anchor thread rotateroll_box();
	anchor waittill("movedone");
	//players = get_players();
	//array_thread(players, ::play_crazi_sound);
	//wait(3.9);
	
	playfx(level._effect["poltergeist"], self.chest_origin.origin);
	
	//TUEY - Play the 'disappear' sound
	playsoundatposition ("zmb_box_poof", soundpoint.origin);
	for(i=0;i<fake_pieces.size;i++)
	{
		fake_pieces[i] delete();
	}

	// 
	self show_rubble();
	wait(0.1);
	anchor delete();
	soundpoint delete();
	
	//Delaying the Player Vox
	if( IsDefined( player_vox ) )
    {    
        player_vox maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "box_move" );
    }

	// DCS 072710: check if fire sale went into effect during move, reset with time left.
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] == true)
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		//IPrintLnBold("need to reset this box spot! Time left is ", current_sale_time);

		wait_network_frame();				
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;

		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}	
	}	
	else
	{
		// Now choose a new location
		wait(5);
	}
	level.verify_chest = false;

	// Check to see if there's a chest selection we should use for this move
	// This is indicated by a script_noteworthy of "moveX*"
	//	(e.g. move1_chest0, move1_chest1)  We will randomly choose between 
	//		one of those two chests for that move number only.
	index = -1;
	for ( i=0; i<level.chests.size; i++ )
	{
		// Check to see if there is something that we have a choice to move to for this move number
		if ( IsSubStr( level.chests[i].script_noteworthy, ("move"+(level.chest_moves+1)) ) &&
			 i != level.chest_index )
		{
			index = i;
			break;
		}
	}

	if ( index != -1 )
	{
		level.chest_index = index;
	}
	else
	{
		level.chest_index++;
	}

	if (level.chest_index >= level.chests.size)
	{
		//PI CHANGE - this way the chests won't move in the same order the second time around
		temp_chest_name = level.chests[level.chest_index - 1].script_noteworthy;
		level.chest_index = 0;
		level.chests = array_randomize(level.chests);
		//in case it happens to randomize in such a way that the chest_index now points to the same location
		// JMA - want to avoid an infinite loop, so we use an if statement
		if (temp_chest_name == level.chests[level.chest_index].script_noteworthy)
		{
			level.chest_index++;
		}
		//END PI CHANGE
	}

	//wait for all the chests to reset 
	wait(7);
		
	playfx(level._effect["poltergeist"], level.chests[level.chest_index].chest_origin.origin);
	level.chests[level.chest_index] show_chest();
	level.chests[level.chest_index] hide_rubble();
	
	flag_clear("moving_chest_now");
}


fire_sale_fix()
{
	if( !isdefined ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		return;
	}

	if( level.zombie_vars["zombie_powerup_fire_sale_on"] )
	{
		self.old_cost = 950;
		self thread show_chest();
		self thread hide_rubble();
		self.zombie_cost = 10;
		self set_hint_string( self , "powerup_fire_sale_cost" );

		wait_network_frame();

		level waittill( "fire_sale_off" );
		
		while(is_true(self._box_open ))
		{
			wait(.1);
		}		
		
		playfx(level._effect["poltergeist"], self.origin);
		self playsound ( "zmb_box_poof_land" );
		self playsound( "zmb_couch_slam" );
		self thread hide_chest();
		self thread show_rubble();
	
		self.zombie_cost = self.old_cost;
		self set_hint_string( self , "default_treasure_chest_" + self.zombie_cost );
	}
}

check_for_desirable_chest_location()
{
	if( !isdefined( level.desirable_chest_location ) )
		return level.chest_index;

	if( level.chests[level.chest_index].script_noteworthy == level.desirable_chest_location )
	{
		level.desirable_chest_location = undefined;
		return level.chest_index;
	}
	for(i = 0 ; i < level.chests.size; i++ )
	{
		if( level.chests[i].script_noteworthy == level.desirable_chest_location )
		{
			level.desirable_chest_location = undefined;
			return i;
		}
	}

	/#
		iprintln(level.desirable_chest_location + " is an invalid box location!");
#/
	level.desirable_chest_location = undefined;
	return level.chest_index;
}


rotateroll_box()
{
	angles = 40;
	angles2 = 0;
	//self endon("movedone");
	while(isdefined(self))
	{
		self RotateRoll(angles + angles2, 0.5);
		wait(0.7);
		angles2 = 40;
		self RotateRoll(angles * -2, 0.5);
		wait(0.7);
	}
	


}
//verify if that magic box is open to players or not.
verify_chest_is_open()
{

	//for(i = 0; i < 5; i++)
	//PI CHANGE - altered so that there can be more than 5 valid chest locations
	for (i = 0; i < level.open_chest_location.size; i++)
	{
		if(isdefined(level.open_chest_location[i]))
		{
			if(level.open_chest_location[i] == level.chests[level.chest_index].script_noteworthy)
			{
				level.verify_chest = true;
				return;		
			}
		}

	}

	level.verify_chest = false;


}


treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );

	wait( 12 );
	self notify( "trigger", level ); 
}

treasure_chest_lid_open()
{
	openRoll = 105;
	openTime = 0.5;

	self RotateRoll( 105, openTime, ( openTime * 0.5 ) );

	play_sound_at_pos( "open_chest", self.origin );
	play_sound_at_pos( "music_chest", self.origin );
}

treasure_chest_lid_close( timedOut )
{
	closeRoll = -105;
	closeTime = 0.5;

	self RotateRoll( closeRoll, closeTime, ( closeTime * 0.5 ) );
	play_sound_at_pos( "close_chest", self.origin );
}

treasure_chest_ChooseRandomWeapon( player )
{
	// this function is for display purposes only, so there's no need to bother limiting which weapons can be displayed
	// while they float, only the last selection needs to be limited, which is decided by treasure_chest_ChooseWeightedRandomWeapon()
	// plus, this is all clientsided at this point anyway
	keys = GetArrayKeys( level.zombie_weapons );
	return keys[RandomInt( keys.size )];

}

treasure_chest_ChooseWeightedRandomWeapon( player )
{
	keys = GetArrayKeys( level.zombie_weapons );
	
	println( "ZM >> Magic weapon count = " + level.zombie_weapons.size );

	toggle_weapons_in_use = 0;
	// Filter out any weapons the player already has
	filtered = [];
	for( i = 0; i < keys.size; i++ )
	{
		println( "ZM >> Magic weapon index = " + i );
		println( "ZM >> Magic weapon name = " + keys[i] );
		if( !get_is_in_box( keys[i] ) )
		{
			continue;
		}
		
		if( is_player_valid(player) && player has_weapon_or_upgrade( keys[i] ) )
		{
			if ( is_weapon_toggle( keys[i] ) )
			{
				toggle_weapons_in_use++;
			}
			continue;
		}

		if( !IsDefined( keys[i] ) )
		{
			continue;
		}

		num_entries = [[ level.weapon_weighting_funcs[keys[i]] ]]();
		
		for( j = 0; j < num_entries; j++ )
		{
			filtered[filtered.size] = keys[i];
		}
	}
	
	println( "ZM >> Magic weapon DONE" );
	
	// Filter out the limited weapons
	if( IsDefined( level.limited_weapons ) )
	{
		keys2 = GetArrayKeys( level.limited_weapons );
		players = get_players();
		pap_triggers = GetEntArray("zombie_vending_upgrade", "targetname");
		for( q = 0; q < keys2.size; q++ )
		{
			count = 0;
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] has_weapon_or_upgrade( keys2[q] ) )
				{
					count++;
				}
			}

			// Check the pack a punch machines to see if they are holding what we're looking for
			for ( k=0; k<pap_triggers.size; k++ )
			{
				if ( IsDefined(pap_triggers[k].current_weapon) && pap_triggers[k].current_weapon == keys2[q] )
				{
					count++;
				}
			}

			// Check the other boxes so we don't offer something currently being offered during a fire sale
			for ( chestIndex = 0; chestIndex < level.chests.size; chestIndex++ )
			{
				if ( IsDefined( level.chests[chestIndex].chest_origin.weapon_string ) && level.chests[chestIndex].chest_origin.weapon_string == keys2[q] )
				{
					count++;
				}
			}

			if ( is_weapon_toggle( keys2[q] ) )
			{
				toggle_weapons_in_use += count;
			}

			if( count >= level.limited_weapons[keys2[q]] )
			{
				filtered = array_remove( filtered, keys2[q] );
			}
		}
	}
	
	// finally, filter based on toggle mechanic
	if ( IsDefined( level.zombie_weapon_toggles ) )
	{
		keys2 = GetArrayKeys( level.zombie_weapon_toggles );
		for( q = 0; q < keys2.size; q++ )
		{
			if ( level.zombie_weapon_toggles[keys2[q]].active )
			{
				if ( toggle_weapons_in_use < level.zombie_weapon_toggle_max_active_count )
				{
					continue;
				}
			}

			filtered = array_remove( filtered, keys2[q] );
		}
	}

	// try to "force" a little more "real randomness" by randomizing the array before randomly picking a slot in it
	filtered = array_randomize( filtered );
	return filtered[RandomInt( filtered.size )];
}

// Functions namesake in _zm_weapons.csc must match this one.

weapon_is_dual_wield(name)
{
	switch(name)
	{
		case  "cz75dw_zm":
		case  "cz75dw_upgraded_zm":
		case  "m1911_upgraded_zm":
		case  "hs10_upgraded_zm":
		case  "pm63_upgraded_zm":
			return true;
		default:
			return false;
	}
}

treasure_chest_weapon_spawn( chest, player )
{
	assert(IsDefined(player));
	// spawn the model
//	model = spawn( "script_model", self.origin ); 
//	model.angles = self.angles +( 0, 90, 0 );

//	floatHeight = 40;

	//move it up
//	model moveto( model.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 

	// rotation would go here

	// make with the mario kart
	self.weapon_string = undefined;
	modelname = undefined; 
	rand = undefined; 
	number_cycles = 40;
	
	println( "ZM >> setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM)" );
	chest.chest_box setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM);
	
	for( i = 0; i < number_cycles; i++ )
	{

		if( i < 20 )
		{
			wait( 0.05 ); 
		}
		else if( i < 30 )
		{
			wait( 0.1 ); 
		}
		else if( i < 35 )
		{
			wait( 0.2 ); 
		}
		else if( i < 38 )
		{
			wait( 0.3 ); 
		}

		if( i + 1 < number_cycles )
		{
			rand = treasure_chest_ChooseRandomWeapon( player );
		}
		else
		{
			rand = treasure_chest_ChooseWeightedRandomWeapon( player );

/#
			weapon = GetDvar( "scr_force_weapon" );
			if ( weapon != "" && IsDefined( level.zombie_weapons[ weapon ] ) )
			{
				rand = weapon;
				SetDvar( "scr_force_weapon", "" );
			}
#/
		}
	}
	
	// Here's where the org get it's weapon type for the give function
	self.weapon_string = rand; 
	
	chest.chest_box clearclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM);

	wait_network_frame();

	floatHeight = 40;

	model_dw = undefined;

	model = spawn( "script_model", self.origin + ( 0, 0, floatHeight)); 
	model.angles = self.angles +( 0, 90, 0 );

	modelname = GetWeaponModel( rand );
	model setmodel( modelname ); 
	model useweaponhidetags( rand );

	if ( weapon_is_dual_wield(rand))
	{
		model_dw = spawn( "script_model", model.origin - ( 3, 3, 3 ) ); // extra model for dualwield weapons
		model_dw.angles = self.angles +( 0, 90, 0 );		

		model_dw setmodel( modelname ); 
		model_dw useweaponhidetags( rand );
	}

	// Increase the chance of joker appearing from 0-100 based on amount of the time chest has been opened.
	if( (GetDvar( "magic_chest_movable") == "1") && !is_true( chest._box_opened_by_fire_sale ) && !is_true( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		// random change of getting the joker that moves the box
		random = Randomint(100);

		if( !isdefined( level.chest_min_move_usage ) )
		{
			level.chest_min_move_usage = 4;
		}

		if( level.chest_accessed < level.chest_min_move_usage )
		{		
			chance_of_joker = -1;
		}
		else
		{
			chance_of_joker = level.chest_accessed + 20;

			// make sure teddy bear appears on the 8th pull if it hasn't moved from the initial spot
			if ( level.chest_moves == 0 && level.chest_accessed >= 8 )
			{
				chance_of_joker = 100;
			}

			// pulls 4 thru 8, there is a 15% chance of getting the teddy bear
			// NOTE:  this happens in all cases
			if( level.chest_accessed >= 4 && level.chest_accessed < 8 )
			{
				if( random < 15 )
				{
					chance_of_joker = 100;
				}
				else
				{
					chance_of_joker = -1;
				}
			}

			// after the first magic box move the teddy bear percentages changes
			if ( level.chest_moves > 0 )
			{
				// between pulls 8 thru 12, the teddy bear percent is 30%
				if( level.chest_accessed >= 8 && level.chest_accessed < 13 )
				{
					if( random < 30 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
				
				// after 12th pull, the teddy bear percent is 50%
				if( level.chest_accessed >= 13 )
				{
					if( random < 50 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
			}
		}

		if ( chance_of_joker > random )
		{
			self.weapon_string = undefined;

			model SetModel("zombie_teddybear");
		//	model rotateto(level.chests[level.chest_index].angles, 0.01);
			//wait(1);
			model.angles = self.angles;		
			
			if(IsDefined(model_dw))
			{
				model_dw Delete();
				model_dw = undefined;
			}

			flag_set("moving_chest_now");
			level.chest_accessed = 0;

			//allow power weapon to be accessed.
			level.chest_moves++;
		}
	}

	self notify( "randomization_done" );

	if (flag("moving_chest_now") && !level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		wait .5;	// we need a wait here before this notify
		level notify("weapon_fly_away_start");
		wait 2;
		model MoveZ(500, 4, 3);
		
		if(IsDefined(model_dw))
		{
			model_dw MoveZ(500,4,3);
		}
		
		model waittill("movedone");
		model delete();
		
		if(IsDefined(model_dw))
		{
			model_dw Delete();
		}
		
		self notify( "box_moving" );
		level notify("weapon_fly_away_end");
	}
	else
	{
		acquire_weapon_toggle( rand, player );

		//turn off power weapon, since player just got one
		if( rand == "tesla_gun_zm" || rand == "ray_gun_zm" )
		{
			if( rand == "ray_gun_zm" )
			{
//				level.chest_moves = false;
				level.pulls_since_last_ray_gun = 0;
			}
			
			if( rand == "tesla_gun_zm" )
			{
				level.pulls_since_last_tesla_gun = 0;
				level.player_seen_tesla_gun = true;
			}			
		}

		model thread timer_til_despawn(floatHeight);
		if(IsDefined(model_dw))
		{
			model_dw thread timer_til_despawn(floatHeight);
		}
		
		self waittill( "weapon_grabbed" );

		if( !chest.timedOut )
		{
			model Delete();
			
			if(IsDefined(model_dw))
			{
				model_dw Delete();
			}
		}
	}

	self.weapon_string = undefined;
}

//
//
chest_get_min_usage()
{
	min_usage = 4;

	/*
	players = get_players();

	// Special case min box pulls before 1st box move
	if( level.chest_moves == 0 )
	{
		if( players.size == 1 )
		{
			min_usage = 2;
		}
		else if( players.size == 2 )
		{
			min_usage = 2;
		}
		else if( players.size == 3 )
		{
			min_usage = 3;
		}
		else
		{
			min_usage = 4;
		}
	}
	// Box has moved, what is the minimum number of times it can move again?
	else
	{
		if( players.size == 1 )
		{
			min_usage = 2;
		}
		else if( players.size == 2 )
		{
			min_usage = 2;
		}
		else if( players.size == 3 )
		{
			min_usage = 3;
		}
		else
		{
			min_usage = 3;
		}
	}
	*/

	return( min_usage );
}

//
//
chest_get_max_usage()
{
	max_usage = 6;

	players = get_players();

	// Special case max box pulls before 1st box move
	if( level.chest_moves == 0 )
	{
		if( players.size == 1 )
		{
			max_usage = 3;
		}
		else if( players.size == 2 )
		{
			max_usage = 4;
		}
		else if( players.size == 3 )
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 6;
		}
	}
	// Box has moved, what is the maximum number of times it can move again?
	else
	{
		if( players.size == 1 )
		{
			max_usage = 4;
		}
		else if( players.size == 2 )
		{
			max_usage = 4;
		}
		else if( players.size == 3 )
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 7;
		}
	}
	return( max_usage );
}


timer_til_despawn(floatHeight)
{
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
	putBackTime = 12;
	self MoveTo( self.origin - ( 0, 0, floatHeight ), putBackTime, ( putBackTime * 0.5 ) );
	wait( putBackTime );

	if(isdefined(self))
	{	
		self Delete();
	}
}

treasure_chest_glowfx()
{
	fxObj = spawn( "script_model", self.origin +( 0, 0, 0 ) ); 
	fxobj setmodel( "tag_origin" ); 
	fxobj.angles = self.angles +( 90, 0, 0 ); 

	playfxontag( level._effect["chest_light"], fxObj, "tag_origin"  ); 

	self waittill_any( "weapon_grabbed", "box_moving" ); 

	fxobj delete(); 
}

// self is the player string comes from the randomization function
treasure_chest_give_weapon( weapon_string )
{
	self.last_box_weapon = GetTime();
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined; 
	weapon_limit = 2;

	if( self HasWeapon( weapon_string ) )
	{
		if ( issubstr( weapon_string, "knife_ballistic_" ) )
		{
			self notify( "zmb_lost_knife" );
		}
		self GiveStartAmmo( weapon_string );
		self SwitchToWeapon( weapon_string );
		return;
	}

//T6todo 	if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
//T6todo 	{
//T6todo 		weapon_limit = 3;
//T6todo 	}
	
	// This should never be true for the first time.
	if( primaryWeapons.size >= weapon_limit )
	{
		current_weapon = self getCurrentWeapon(); // get hiss current weapon

		if ( is_placeable_mine( current_weapon ) ) 
		{
			current_weapon = undefined;
		}

		if( isdefined( current_weapon ) )
		{
			if( !is_offhand_weapon( weapon_string ) )
			{
				// PI_CHANGE_BEGIN
				// JMA - player dropped the tesla gun
				if( current_weapon == "tesla_gun_zm" )
				{
					level.player_drops_tesla_gun = true;
				}
				// PI_CHANGE_END
				
				if ( issubstr( current_weapon, "knife_ballistic_" ) )
				{
					self notify( "zmb_lost_knife" );
				}
				
				self TakeWeapon( current_weapon );
				unacquire_weapon_toggle( current_weapon );
				if ( current_weapon == "m1911_zm" )
				{
					self.last_pistol_swap = GetTime();
				}

			} 
		} 
	} 

	self play_sound_on_ent( "purchase" );
	
	if( IsDefined( level.zombiemode_offhand_weapon_give_override ) )
	{
		self [[ level.zombiemode_offhand_weapon_give_override ]]( weapon_string );
	}

//T6todo	if( weapon_string == "zombie_cymbal_monkey" )
//T6todo	{
//T6todo		self maps\_zombiemode_weap_cymbal_monkey::player_give_cymbal_monkey();
//T6todo		self play_weapon_vo(weapon_string);
//T6todo		return;
//T6todo	}
	else if ( weapon_string == "knife_ballistic_zm" && self HasWeapon( "bowie_knife_zm" ) )
	{
		weapon_string = "knife_ballistic_bowie_zm";
	}
	else if ( weapon_string == "knife_ballistic_zm" && self HasWeapon( "sickle_knife_zm" ) )
	{
		weapon_string = "knife_ballistic_sickle_zm";
	}
	if (weapon_string == "ray_gun_zm")
	{
			playsoundatposition ("mus_raygun_stinger", (0,0,0));		
	}

	self GiveWeapon( weapon_string, 0 );
	self GiveStartAmmo( weapon_string );
	self SwitchToWeapon( weapon_string );

	self play_weapon_vo(weapon_string);

}