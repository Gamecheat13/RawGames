    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_sword;



 // 1024 * 1024
	







	


	
#precache( "lui_menu", "zod_inventory" );
#precache( "lui_menu_data", "egg_acquired" );
#precache( "lui_menu_data", "egg_level" );
#precache( "lui_menu_data", "egg_completion" );
#precache( "triggerstring", "ZM_ZOD_SWORD_DEFEND_DENY" );
#precache( "triggerstring", "ZM_ZOD_SWORD_DEFEND_START" );
#precache( "triggerstring", "ZM_ZOD_SWORD_DEFEND_PLACE" );
#precache( "triggerstring", "ZM_ZOD_SWORD_DEFEND_RETRIEVE" );
#precache( "triggerstring", "ZM_ZOD_SWORD_AETHER_ENTER" );
#precache( "triggerstring", "ZM_ZOD_SWORD_EGG_PLACE" );
// 2nd Sword - Upgrade Quest
#precache( "triggerstring", "ZM_ZOD_SWORD_MAP_ACTIVATE" );
#precache( "triggerstring", "SWORD_2ND_EGG_SLEEPS" );
#precache( "triggerstring", "SWORD_2ND_EGG_WAKES" );
#precache( "fx", "zombie/fx_egg_ready_zod_zmb" );

function autoexec __init__sytem__() {     system::register("zm_zod_sword",&__init__,&__main__,undefined);    }
	
function __init__()
{	
	clientfield::register( "scriptmover", "zod_egg_glow", 1, 1, "int" );
	clientfield::register( "scriptmover", "zod_egg_soul", 1, 1, "int" );
	callback::on_connect( &on_player_connect );
	callback::on_disconnect( &on_player_disconnect );
	callback::on_spawned( &on_player_spawned );
	zm_zod_util::on_zombie_killed( &on_zombie_killed );
	zm_zod_util::on_player_bled_out( &on_bled_out );
	/#
		level thread sword_devgui();
	#/
}

// self == player
//
function reset_egg()
{
	// Set the egg back to its initial state.
	s_initial = GetEnt( "initial_egg_statue", "script_noteworthy" );
	level.sword_quest.eggs[ self.characterIndex ] SetModel( level.sword_quest.egg_models[0] );
	self set_egg_placement( s_initial.statue_id );
	self SetLUIMenuData( self.zod_inventory_hud, "egg_acquired", 0 );
	self SetLUIMenuData( self.zod_inventory_hud, "egg_completion", 0.0 );
}

// self == player
//
function reset_sword( b_show )
{
	level.sword_quest.swords[self.characterIndex] Show();
}

function __main__()
{
	// setup basic stuff
	level.sword_quest = SpawnStruct();

	level.sword_quest.weapons = [];

	for( i = 0; i < 4; i++ ) // four characters
	{
		level.sword_quest.weapons[ i ] = [];
		level.sword_quest.weapons[ i ][ 1 ] = GetWeapon( "glaive_apothicon" + "_" + i );
		level.sword_quest.weapons[ i ][ 2 ] = GetWeapon( "glaive_keeper" + "_" + i );
		
		foreach( wpn in level.sword_quest.weapons[ i ] )
		{
			assert( wpn != level.weaponNone );
		}
	}
	
	// PART 1 - Charge the Egg using statues
	
	level.sword_quest.statues = GetEntArray( "sword_upgrade_statue", "targetname" );
	level.sword_quest.devourers = GetEntArray( "sword_upgrade_devourer", "targetname" );
	for( devourer_id = 0; devourer_id < level.sword_quest.devourers.size; devourer_id++ )
	{
		e_devourer = level.sword_quest.devourers[ devourer_id ];
		e_devourer SetInvisibleToAll(); // hide all the devourers to begin with
	}
	level.sword_quest.swords = GetEntArray( "sword_in_stone", "targetname" );
	level.sword_quest.egg_models = array( "p7_zm_zod_sword_egg_01", "p7_zm_zod_sword_egg_02", "p7_zm_zod_sword_egg_03", "p7_zm_zod_sword_egg_04" );
	for( statue_id = 0; statue_id < level.sword_quest.statues.size; statue_id++ )
	{
		e_statue = level.sword_quest.statues[ statue_id ];
		if ( ( e_statue.script_noteworthy === "initial_egg_statue" ) )
		{
			e_statue.egg_tags = array( "j_egg_location_01", "j_egg_location_02", "j_egg_location_03", "j_egg_location_04" );
			
			// Initial statue has the eggs!
			level.sword_quest.eggs = [];
			foreach( str_tag in e_statue.egg_tags )
			{
				v_origin = e_statue GetTagOrigin( str_tag );
				v_angles = e_statue GetTagAngles( str_tag );
				e_egg = util::spawn_model( level.sword_quest.egg_models[0], v_origin, v_angles );
				if ( !isdefined( level.sword_quest.eggs ) ) level.sword_quest.eggs = []; else if ( !IsArray( level.sword_quest.eggs ) ) level.sword_quest.eggs = array( level.sword_quest.eggs ); level.sword_quest.eggs[level.sword_quest.eggs.size]=e_egg;;
			}
		}
		else
		{
			e_statue.egg_tags = array( "j_sword_egg_01", "j_sword_egg_02", "j_sword_egg_03", "j_sword_egg_04" );
		}
		
		e_statue.statue_id = statue_id;
		s_trigger_pos = struct::get( e_statue.target, "targetname" );
		
		// Trigger pos targets the smash trigger, which is a prerequisite for using the statue.
		//
		if ( isdefined( s_trigger_pos.target ) )
		{
			zm_zod_smashables::add_callback( s_trigger_pos.target, &run_egg_placement, e_statue );
		}
		else
		{
			level thread run_egg_placement( e_statue );
		}
	}
	
	// PART 2 - Sword Quest Part 2

	// get the magic circles into an array, and hide the "on" versions until we get to part 2 of the quest and activate them
	init_magic_circles();

	level thread create_magic_circle_unitriggers();
	
	// Second Quest thread
	level thread second_sword_quest();
}

function create_magic_circle_unitriggers()
{
	a_s_magic_circle_trigger_locs = struct::get_array( "sword_quest_magic_circle_place", "targetname" );
	foreach( s_loc in a_s_magic_circle_trigger_locs )
	{
		create_magic_circle_unitrigger( s_loc );
	}
}

function create_magic_circle_unitrigger( s_loc )
{
	
}

function magic_circle_trigger_visibility( player )
{
}

function magic_circle_trigger_think()
{
	// sword_quest_magic_circle_player_0
}

function magic_circle_trigger_activate()
{
}


function second_sword_quest()
{
	level flag::wait_till( "ritual_pap_complete" );
	
	// turn on the magic circles throughout the map (start to glow)
	activate_all_magic_circles( true );
		
	// TODO: setup the defend events here
}

function init_magic_circles()
{
	level.sword_quest.a_magic_circles_on = [];
	level.sword_quest.a_magic_circles_off = [];

	a_circles = GetEntArray( "sword_quest_magic_circle_on", "targetname" );
	foreach( e_circle in a_circles )
	{
		// the magic circles are indexed by script int on the magic circle prefab
		level.sword_quest.a_magic_circles_on[ e_circle.script_int ] = e_circle;
	}
	
	a_circles = GetEntArray( "sword_quest_magic_circle_off", "targetname" );
	foreach( e_circle in a_circles )
	{
		// the magic circles are indexed by script int on the magic circle prefab
		level.sword_quest.a_magic_circles_off[ e_circle.script_int ] = e_circle;
	}
	
	activate_all_magic_circles( false );
}

// turn all magic circles on or off, according to b_on
function activate_all_magic_circles( b_on = true )
{
	for( i = 1; i < 5; i++ )
	{
		activate_magic_circle( i, b_on );
	}
}

// n_index - 1-4 index of magic circle (locations correspond to the ZOD RITUAL VALUES in zm_zod_craftables)
// b_on - turn the magic circle on or not
function activate_magic_circle( n_index, b_on = true )
{
	// visually activate decal
	if( b_on )
	{
		level.sword_quest.a_magic_circles_on[ n_index ] Show();
		level.sword_quest.a_magic_circles_off[ n_index ] Ghost();
	}
	else
	{
		level.sword_quest.a_magic_circles_on[ n_index ] Ghost();
		level.sword_quest.a_magic_circles_off[ n_index ] Show();
	}
}

function egg_trigger_message( e_player )
{
	n_statue = self.stub.statue_id;
	e_statue = level.sword_quest.statues[ n_statue ];
	b_inventory = !isdefined( e_player.sword_quest.egg_placement );
	b_satisfied = e_player is_egg_satisfied_at_statue( n_statue );
	b_here = e_player is_egg_at_statue( n_statue );
	b_sword_rock = ( e_statue.script_noteworthy === "initial_egg_statue" );

	if ( e_player.sword_quest.upgrade_stage >= 1 )
	{
		if ( b_sword_rock && !e_player has_sword() )
		{
			return &"ZM_ZOD_SWORD_DEFEND_RETRIEVE";
		}
		else
		{
			return &"";
		}
	}
	else
	{
		if ( b_here && b_satisfied )
		{
			return &"ZM_ZOD_X_TO_PICK_UP";
		}
		else if ( !b_here && !b_satisfied && b_inventory )
		{
			return &"ZM_ZOD_SWORD_EGG_PLACE";
		}
		else
		{
			return &"";
		}
	}
}

function reset_hud()
{
	self.zod_inventory_hud = self OpenLuiMenu( "zod_inventory" );
	self SetLUIMenuData( self.zod_inventory_hud, "pod_sprayer", 0 );
	self SetLUIMenuData( self.zod_inventory_hud, "egg_acquired", 0 );
	self SetLUIMenuData( self.zod_inventory_hud, "egg_level", 0 );
	self SetLUIMenuData( self.zod_inventory_hud, "egg_completion", 0.0 );
}

function on_player_connect()
{
	self.sword_quest = SpawnStruct();
	reset_hud();
	
	self.sword_quest.kills = [];
	self.sword_quest.all_kills_completed = false;
	self.sword_quest.upgrade_stage = 0;
	
	a_statues = GetEntArray( "sword_upgrade_statue", "targetname" );
	foreach( e_statue in a_statues )
	{
		self.sword_quest.kills[e_statue.statue_id] = 0;
		
		// Initial statue starts "satisfied."
		if ( ( e_statue.script_noteworthy === "initial_egg_statue" ) )
		{
			self.sword_quest.kills[e_statue.statue_id] = 6;
		}
	}
	
	reset_egg();
}

function on_player_spawned()
{
	reset_hud();
	reset_sword();		// They'll have to retrieve the sword from the stone again.
	
	if ( isdefined( self.sword_quest ) )
	{
		self set_egg_placement( self.sword_quest.egg_placement );
	}
	
	if ( ( isdefined( self.has_pod_spray ) && self.has_pod_spray ) )
	{
		self SetLUIMenuData( self.zod_inventory_hud, "pod_sprayer", 1 );
	}
	
	if ( isdefined( self.sword_quest.upgrade_stage ) )
	{
		self SetLUIMenuData( self.zod_inventory_hud, "egg_level", self.sword_quest.upgrade_stage );
	}
}

function on_player_disconnect()
{
	reset_egg();
	reset_sword();
}

// self == bled out player
//
function on_bled_out()
{
	/*
	// If the sword's not at the defend, put it back at the stone.
	//
	if ( !isdefined( level.sword_quest.defend.a_placement[self.characterIndex].sword_model ) )
	{
		self reset_sword();
	}
	
	// Put the egg back at the initial placement.  Make them pick it back up.
	//
	if ( self.sword_quest.upgrade_stage == 0 )
	{
		n_placement = self.sword_quest.egg_placement;
		
		// Undefined placement means it's in player inventory.  Put back at the stone.
		//
		if ( !isdefined( n_placement ) )
		{
			reset_egg();
		}
	}
	*/
}

function on_zombie_killed()
{
	foreach ( e_statue in level.sword_quest.statues )
	{
		dist_sq = DistanceSquared( self.origin, e_statue.origin );
		if ( dist_sq < 1048576 )
		{
			e_recipient = undefined;
			
			// Attacker gets first priority for banking this kill.
			if ( isdefined( self.attacker ) && IsPlayer( self.attacker ) )
			{
				if ( self.attacker is_egg_at_statue( e_statue.statue_id ) && !(self.attacker is_egg_satisfied_at_statue( e_statue.statue_id )) )
				{
					e_recipient = self.attacker;
				}
			}
			
			// If the attacker didn't have an eligible egg placed, give it to person who first placed their egg here.
			//
			if ( !isdefined( e_recipient ) )
			{
				n_earliest_time = GetTime() + 1;
				foreach ( e_player in level.players )
				{
					// If the egg is in the statue.
					if ( !e_player is_egg_at_statue( e_statue.statue_id ) )
					{
						continue;
					}
					
					// And the egg is not satisfied here.
					if ( e_player is_egg_satisfied_at_statue( e_statue.statue_id ) )
					{
						continue;
					}
					
					// And the egg was placed earlier than our current candidate.
					if ( e_player.sword_quest.egg_placement_time > n_earliest_time )
					{
						continue;
					}
					
					// This is our new candidate.
					e_recipient = e_player;
					n_earliest_time = e_player.sword_quest.egg_placement_time;
				}
			}
			
			if ( isdefined( e_recipient ) )
			{
				self bank_zombie_kill( e_recipient, e_statue );
			}
		}
	}
}

// self == zombie
//
function private bank_zombie_kill( e_player, e_statue )
{
	e_player.sword_quest.kills[ e_statue.statue_id ]++;
	e_player update_egg_completion_hud();
	/#
	if ( ( isdefined( e_player.sword_quest.cheat ) && e_player.sword_quest.cheat ) )
	{
		e_player.sword_quest.kills[ e_statue.statue_id ] = 6;
	}
	#/

	// Set this statue as completed for this player.
	if ( e_player is_egg_satisfied_at_statue( e_statue.statue_id ) )
	{
		// Check if all kills have been completed at all statues.
		e_player.sword_quest.all_kills_completed = true;
		n_statues_complete = 0;
		foreach ( e_statue in level.sword_quest.statues )
		{
			n_kills = e_player.sword_quest.kills[e_statue.statue_id];
			if ( n_kills < 6 )
			{
				e_player.sword_quest.all_kills_completed = false;
			}
			else if ( !( e_statue.script_noteworthy === "initial_egg_statue" ) )
			{
				n_statues_complete++;
			}
		}
		
		str_model = level.sword_quest.egg_models[ n_statues_complete ];
		e_model = level.sword_quest.eggs[e_player.characterIndex];
		e_model SetModel( str_model );
		e_model clientfield::set( "zod_egg_glow", 1 );
	}
	
	self thread zombie_blood_soul_streak_fx( e_statue, e_player );
}

// self == player
function private is_egg_at_statue( statue_id )
{
	if ( !isdefined( self.sword_quest.egg_placement ) )
	{
		return false;
	}
	
	return self.sword_quest.egg_placement == statue_id;
}

// self == player
function private is_egg_satisfied_at_statue( statue_id )
{
	return self.sword_quest.kills[ statue_id ] >= 6;
}

// self == zombie
function private zombie_blood_soul_streak_fx( e_statue, e_killer )
{
	v_start = self GetTagOrigin( "J_SpineLower" );
	e_fx = zm_zod_util::tag_origin_allocate( v_start, self.angles );
	e_fx clientfield::set( "zod_egg_soul", 1 );
	v_endpos = e_statue GetTagOrigin( e_statue.egg_tags[ e_killer.characterIndex ] );
	e_fx MoveTo( v_endpos, 1.0 );
	e_fx waittill( "movedone" );
	wait 0.25;
	e_fx clientfield::set( "zod_egg_soul", 0 );
	e_fx zm_zod_util::tag_origin_free();
	
	// on the first kill, swap the statue for the devourer alien
	if( e_killer.sword_quest.kills[ e_statue.statue_id ] === 1 )
	{
		e_statue SetInvisibleToAll();
		e_devourer = level.sword_quest.devourers[ e_statue.statue_id ];
		e_devourer SetVisibleToAll();
	}
}

// self == zombie
//
function private spawn_zombie_clone()
{
	clone = spawn( "script_model", self.origin );
	clone.angles = self.angles;
	clone SetModel( self.model );
	
	if (isdefined(self.headModel))
	{
		clone.headModel = self.headModel;
		clone attach(clone.headModel, "", true);
	}

	return clone;
}

function update_egg_completion_hud()
{
	n_pct = 0.0;
	
	if ( self.sword_quest.upgrade_stage == 0 )
	{
		n_kills_needed = 0;
		n_kills_total = 0;
	
		foreach( e_statue in level.sword_quest.statues )
		{
			if ( ( e_statue.script_noteworthy === "initial_egg_statue" ) )
		    {
				continue;
		    }
			
			statue_id = e_statue.statue_id;
			n_kills_needed += 6;
			n_kills_total += self.sword_quest.kills[ statue_id ];
		}
		
		Assert( n_kills_needed > 0 );
		n_pct = Float( n_kills_total ) / Float( n_kills_needed );
	}
	//else if ( self.sword_quest.upgrade_stage == UPGRADE_STAGE_AUTOKILL )
	//{
	//	s_placement = level.sword_quest.defend.a_placement[ self.characterIndex ];
	//	if ( isdefined( s_placement.sword_model ) )
	//	{
	//		n_pct = Float( level.sword_quest.defend.raps_killed ) / Float( level.sword_quest.defend.raps_total );
	//	}
	//}
	
	// value is actually offset within this range.
	const pct_min = 0.15;
	const pct_max = 0.95;
	n_pct = LerpFloat( pct_min, pct_max, n_pct );
	
	self SetLUIMenuData( self.zod_inventory_hud, "egg_completion", n_pct );
}

// self == player
//
// undefined = removed/in player inventory
// 0-n = placed at statue.
//
function set_egg_placement( n_egg_placement, b_completed = false )
{
	self.sword_quest.egg_placement = n_egg_placement;
	self.sword_quest.egg_placement_time = GetTime();
	e_egg = level.sword_quest.eggs[ self.characterIndex ];
	if ( !isdefined( n_egg_placement ) )
	{
		self SetLUIMenuData( self.zod_inventory_hud, "egg_acquired", 1 );
		e_egg Ghost();
		e_egg clientfield::set( "zod_egg_glow", 0 );
	}
	else
	{
		// Put it in the position associated with this player at this statue.
		e_statue = level.sword_quest.statues[ n_egg_placement ];
		e_egg.origin = e_statue GetTagOrigin( e_statue.egg_tags[ self.characterIndex ] );
		e_egg.angles = e_statue GetTagAngles( e_statue.egg_tags[ self.characterIndex ] );
		e_egg Show();
		
		if ( !( e_statue.script_noteworthy === "initial_egg_statue" ) )
		{
			self SetLUIMenuData( self.zod_inventory_hud, "egg_acquired", 0.5 );
		}
	}
}

// self == trigger
//
// e_player: player reading message on trigger.
//
function defend_player_message( e_player )
{
	s_placement = level.sword_quest.defend.a_placement[ e_player.characterIndex ];
	
	if ( e_player has_sword( 1 ) )
	{
		return &"ZM_ZOD_SWORD_DEFEND_PLACE";
	}
	else if ( isdefined( s_placement.sword_model ) && e_player.sword_quest.upgrade_stage == 2 )
	{
		return &"ZM_ZOD_SWORD_DEFEND_RETRIEVE";
	}
	else
	{
		return &"";
	}
}

// self == player
function give_sword( n_sword_level )
{
	wpn_sword = level.sword_quest.weapons[ self.characterIndex ][ n_sword_level ]; // get the correct sword level and character indexed variant of the sword
	assert( isdefined( wpn_sword ) );
	
	foreach( wpn in level.sword_quest.weapons[ self.characterIndex ] )
	{
		if ( wpn != wpn_sword && self HasWeapon( wpn ) )
		{
			self TakeWeapon( wpn );
		}
	}

	self zm_weapons::weapon_give( wpn_sword, false, false, true );
	self GadgetPowerChange( 0, 100 );
	self SwitchToWeapon( wpn_sword );
	
	//self thread sword_use_hint(); 
}

// self == player
//
function take_sword()
{
	n_level = self.sword_quest.upgrade_stage;
	if ( self has_sword( n_level ) )
	{
		self TakeWeapon( level.sword_quest.weapons[ self.characterIndex ][ n_level ] );
	}
}

// self == player
//
// n_sword_level (optional): sword level, or undefined for any sword.
//
function has_sword( n_sword_level )
{
	if ( !isdefined( n_sword_level ) )
	{
		n_sword_level = self.sword_quest.upgrade_stage;
	}
	return self HasWeapon( level.sword_quest.weapons[ self.characterIndex ][ n_sword_level ] );
}

// self == player
//
// n_sword_level (optional): sword level, or undefined for any sword.
//
function sword_equipped( n_sword_level )
{
	if ( !isdefined( n_sword_level ) )
	{
		n_sword_level = self.sword_quest.upgrade_stage;
	}
	
	return self GetCurrentWeapon() == level.sword_quest.weapons[ self.characterIndex ][ n_sword_level ];
}



// self == player
function sword_use_hint()
{
	if ( ( isdefined( self.ever_had_sword ) && self.ever_had_sword ) )
		return;
	self.ever_had_sword=true;
	// wait till wielding sword
	self waittill( "weapon_change_complete" );
	
	// wait till sword put away
	self waittill("weapon_change");
	
	// tell them how to get it back
	zm_equipment::show_hint_text( &"ZM_ZOD_SWORD_HINT", 3 );

}

function run_egg_placement( e_statue )
{
	if ( isdefined( e_statue.trigger ) )
	{
		return;
	}
	
	s_trigger_pos = struct::get( e_statue.target, "targetname" );
	e_statue.trigger = zm_zod_util::spawn_trigger_radius( s_trigger_pos.origin, 64, true, &egg_trigger_message );
	e_statue.trigger.statue_id = e_statue.statue_id;
	
	while ( true )
	{
		e_statue.trigger zm_zod_util::unitrigger_refresh_message();
		
		e_statue.trigger waittill( "trigger", e_who );
		
		// In a statue?
		if ( isdefined( e_who.sword_quest.egg_placement ) )
		{
			// Correct statue?
			if ( e_who.sword_quest.egg_placement == e_statue.statue_id )
			{
				// Kills completed?
				if ( e_who.sword_quest.kills[e_statue.statue_id] >= 6 )
				{
					// Put it in the player inventory.
					e_who set_egg_placement( undefined );
					
					if ( e_who.sword_quest.all_kills_completed )
					{
						e_who set_sword_upgrade_level( 1 );
					}
				}
			}
		}
		
		// Needs more kills?
		else if ( e_who.sword_quest.kills[e_statue.statue_id] < 6 )
		{
			// Place it in the statue.
			e_who set_egg_placement( e_statue.statue_id );
			e_who playsound( "zmb_buildable_piece_add" );
		}
		else if ( e_who.sword_quest.upgrade_stage > 0 && ( e_statue.script_noteworthy === "initial_egg_statue" ) )
		{
			//e_who playsound( "zmb_buildable_complete" );
			level.sword_quest.swords[e_who.characterIndex] Ghost();
			e_who give_sword( e_who.sword_quest.upgrade_stage );
			e_who update_egg_completion_hud();
		}
	}
}

// self == player
function set_sword_upgrade_level( n_level )
{
	if ( self.sword_quest.upgrade_stage == n_level )
	{
		return;
	}
	
	// Disable functionality of previous stage.
	switch ( self.sword_quest.upgrade_stage )
	{
		case 1:
			break;
	}
	
	// Enable functionality of new stage.
	//
	self.sword_quest.upgrade_stage = n_level;
	self SetLUIMenuData( self.zod_inventory_hud, "egg_level", n_level );
}

/#
	
	
function sword_devgui()
{
	SetDvar( "zod_sword_level", 0 );
	SetDvar( "zod_sword_cheat", "" );
	SetDvar( "swordpreserve", "" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Sword/Level 1\" \"zod_sword_level 1\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Sword/Level 2\" \"zod_sword_level 2\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Sword/Preserve:3\" \" swordpreserve on\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Sword/Cheat\" \"zod_sword_cheat on\"\n" );
	
	s_sword_rock = GetEnt( "initial_egg_statue", "script_noteworthy" );
	
	while ( true )
	{
		n_level = GetDvarInt( "zod_sword_level" );
		if ( n_level > 0 )
		{
			//Cheat
			foreach( e_player in level.players )
			{
				e_player.swordpreserve = true;
			}
			
			thread run_egg_placement( s_sword_rock );
			foreach( e_player in level.players )
			{
				e_player SetLUIMenuData( e_player.zod_inventory_hud, "egg_acquired", 1 );
				e_player set_sword_upgrade_level( n_level );
				s_sword_rock.trigger notify( "trigger", e_player );
				
				util::wait_network_frame();
				
				// If they didn't have the egg yet, we'll need to use that trigger again to get the sword.
				//
				if ( !e_player has_sword() )
				{
					s_sword_rock.trigger notify( "trigger", e_player );
				}
				
				e_player update_egg_completion_hud();
				
				util::wait_network_frame();
			}


			SetDvar( "zod_sword_level", 0 );
		}
		
		str_cheat = GetDvarString( "zod_sword_cheat" );
		switch( str_cheat )
		{
			case "on":
				foreach( e_player in level.players )
				{
					e_player.sword_quest.cheat = true;
				}
				break;
			default:
				break;
		}
		
		str_cheat = GetDvarString( "swordpreserve" );
		switch( str_cheat )
		{
			case "on":
				foreach( e_player in level.players )
				{
					e_player.swordpreserve = true;
				}
				break;
			default:
				break;
		}
		
		util::wait_network_frame();
	}
}


#/

