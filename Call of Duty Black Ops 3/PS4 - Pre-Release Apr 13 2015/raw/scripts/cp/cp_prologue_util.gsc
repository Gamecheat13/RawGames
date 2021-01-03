#using scripts\shared\scene_shared;
#using scripts\shared\flag_shared;
#using scripts\cp\gametypes\_spawning;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\_dialog;
#using scripts\cp\voice\voice_prologue;
#using scripts\shared\ai_shared;
#using scripts\shared\turret_shared;
#using scripts\cp\_spawn_manager;
#using scripts\shared\player_shared;


function check_for_alert()
{
	self endon( "death" );
	if( !IsDefined( level.is_ai_attempting_alert ) )
	{
		level.is_ai_attempting_alert = false;
	}
	
	if( !IsDefined( level.is_base_alerted ) )
	{
		level.is_base_alerted = false;
	}
	
	while ( level.is_base_alerted != true )
	{
		if( level.is_ai_attempting_alert != true && IsDefined( self.enemy ) && self canSee( self.enemy ))
		{
			self ai_alert_attempt();
			return;
		}
		
		wait 0.1;
	}
		
}


function ai_alert_attempt()
{
	// self is the AI attempting to call the base to alert
	self endon( "death" );
	if( !IsDefined( level.is_ai_attempting_alert ) )
	{
		level.is_ai_attempting_alert = false;
	}
	
	if( level.is_ai_attempting_alert !=true )
	{
		level.is_ai_attempting_alert = true;
		self thread alert_the_whole_base();
		self thread end_alert_call_on_death();
		wait 0.1;
		if( isAlive( self ) )
		{
			self scene::play( "cp_prologue_alerting_scene" , self );
		}
	}
}


function alert_the_whole_base()
{
	self endon( "death");
	
	level waittill( "ai_alerted_base" );
	level base_alarm_goes_off();
}

function base_alarm_goes_off()
{	
	level.is_base_alerted = true;
	level flag::set_val( "is_base_alerted" , true );
	/# PrintLn( "Base is Alerted" ); #/

	level.ai_hendricks dialog::say( "hend_they_ve_id_ed_you_t_0");
	
	level util::clientnotify ("alarm_on");
		
	PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
	wait 2.0;
	PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
	wait 2.0;
	PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
}


function end_alert_call_on_death()
{
	self endon( "ai_alerted_base" );
	
	self waittill( "death" );
	
	wait RandomFloatRange( 1.0 , 3.0 );
		
	level.is_ai_attempting_alert = false;
}

/@
"Name: fake_stealth_behavior( alert_dist )"
"Summary: Sets an actor's ignore all flag to true unless an enemy is within <alert_dist> of the actor, then turns it on."
"Module: cp_prologue_util"
"CallOn: Actor"
"MandatoryArg: alert_dist : how close an enemy must get to this actor to set the ignoreall flag to false"
"MandatoryArg2: end_flag : name of a flag that is set to true when all ai that are currently running the fake stealth behavior should have their ignoreall flag set to false"
"Example: fake_stealth_behavior( 250 , "is_base_alerted" );"
@/
function fake_stealth_behavior( alert_dist , end_flag )
{
	//self is the actor the function is called on
	self endon( "death" );
	self endon( "end_fake_stealth" );
	self.fovcosine = 0.707; //sets field of view down to 90 degrees from default 180 degrees
	
	While( 1 )
	{
		if( level flag::get( end_flag ) )
		{
			self.ignoreall = false;
			self.fovcosine = 0; //sets field of view back to the default 180 degrees
			self notify( "end_fake_stealth" );
		}
		
		enemy_distance = self GetClosestEnemySqDist();
		
		if( enemy_distance >= ( alert_dist * alert_dist ) )
		{
		   	self.ignoreall = true;
		}
		else
		{
			self.ignoreall = false;
		}
		
		wait 0.1;
	}
	
}


/@
"Name: spawn_coop_player_replacement( skipto )"
"Summary: spawns in replacement AI for coop players and teleports them to the designated skipto structs"
"Module: cp_prologue_util"
"CallOn: Actor"
"MandatoryArg: skipto : Name of the skipto that the allied replacements are spawning in at.  This has their names appended and with their names appended should be the targetname of the scriptstruct they are spawning in at."
"Example: spawn_coop_player_replacement( "skipto_blend_in" );"
@/
function spawn_coop_player_replacement( skipto )
{
	primary_weapon = GetWeapon( "ar_standard_hero" );
	
	if( level.players.size <= 3 && !isDefined( level.ai_ally_01))
	{
		level.ai_ally_01 = util::get_hero( "ally_01" );
		s_struct = struct::get( skipto + "_ally_01", "targetname" );
		level.ai_ally_01 forceteleport( s_struct.origin, s_struct.angles );
		level.ai_ally_01 ai::gun_switchto( primary_weapon, "right" );
	}
	
	if( level.players.size <= 2 && !isDefined( level.ai_ally_02))
	{
		level.ai_ally_02 = util::get_hero( "ally_02" );
		s_struct = struct::get( skipto + "_ally_02", "targetname" );
		level.ai_ally_02 forceteleport( s_struct.origin, s_struct.angles );
		level.ai_ally_02 ai::gun_switchto( primary_weapon, "right" );
	}

	if( level.players.size == 1 && !isDefined( level.ai_ally_03))
	{
		level.ai_ally_03 = util::get_hero( "ally_03" );
		s_struct = struct::get( skipto + "_ally_03", "targetname" );
		level.ai_ally_03 forceteleport( s_struct.origin, s_struct.angles );
		level.ai_ally_03 ai::gun_switchto( primary_weapon, "right" );
	}
	
	if( level.players.size >=2 && isDefined( level.ai_ally_03))
	{
		level.ai_ally_03 kill();
	}
	
	if( level.players.size >=3 && isDefined( level.ai_ally_02))
	{
		level.ai_ally_02 kill();
	}
	
	if( level.players.size >=4 && isDefined( level.ai_ally_01))
	{
		level.ai_ally_01 kill();
	}
}


function give_player_weapons()
{
	if (level.b_loadout_silenced)
	{
		player_primary_weapon = GetWeapon( "ar_standard", "suppressed" );
		player_secondary_weapon = GetWeapon( "pistol_standard", "suppressed" );
	}
	else 
	{
		player_primary_weapon = GetWeapon( "ar_standard");
		player_secondary_weapon = GetWeapon( "pistol_standard" );
	}
	
	self TakeWeapon( self.primaryloadoutweapon );	
	self TakeWeapon( self.secondaryloadoutweapon );	
	
	self GiveWeapon( player_primary_weapon );
	self GiveWeapon( player_secondary_weapon );
	
	self switchToWeapon( player_primary_weapon );	
		
}

function arrive_and_spawn(vehicle, str_spawn_manager)
{
	vehicle waittill( "reached_end_node" );
	
	vehicle DisconnectPaths();
	
	spawn_manager::enable( str_spawn_manager );
}

function ai_idle_then_alert(str_wait_till)
{
	self endon( "death" );
	
	self.goalradius = 8;
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self setgoal( self.origin );
	
	level flag::wait_till( str_wait_till );
	
	self.goalradius = 32;
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	if (isdefined(self.target))
	{
		node = GetNodeArray( self.target, "targetname" );
		index = RandomIntRange(0, node.size);
		self setgoal( node[index], true );
	}	
}

/@
"Name: get_ai_allies()"
"Summary: Returns an array of the AI allies that could be replaced by players in coop. This should handle drop in/drop out robustly."
"Module: cp_prologue_util"
"Example: a_allies = get_ai_allies();"
@/
function get_ai_allies()
{
	a_ai = [];
	if( isDefined( level.ai_ally_01 ))
	{
		a_ai[a_ai.size] = level.ai_ally_01;
	}
	if( isDefined( level.ai_ally_02 ))
	{
		a_ai[a_ai.size] = level.ai_ally_02;
	}
	if( isDefined( level.ai_ally_03 ))
	{
		a_ai[a_ai.size] = level.ai_ally_03;
	}
	return a_ai;
}

/@
"Name: get_ai_allies_and_players()"
"Summary: Returns an array of any players in the level along with the AI allies that could be replaced by players in coop. This should handle drop in/drop out robustly."
"Module: cp_prologue_util"
"Example: a_team = get_ai_allies_and_players();"
@/
function get_ai_allies_and_players()
{
	a_team = GetPlayers();
	if( isDefined( level.ai_ally_01 ))
	{
		a_team[a_team.size] = level.ai_ally_01;
	}
	if( isDefined( level.ai_ally_02 ))
	{
		a_team[a_team.size] = level.ai_ally_02;
	}
	if( isDefined( level.ai_ally_03 ))
	{
		a_team[a_team.size] = level.ai_ally_03;
	}
	return a_team;
}


//*****************************************************************************
// AI follows a linked list of nodes (using script_string)
// - BLOCKING
//*****************************************************************************

// self = ai
function follow_linked_scripted_nodes()
{
	self endon( "death" );

	self.goalradius = 64;

	self.ignoreall = true;

	nd_node = GetNode( self.script_string, "targetname" );

	while( 1 )
	{
		self SetGoal( nd_node.origin );
		self waittill( "goal" );
		
		// Is there another node along the path?
		if( !IsDefined(nd_node.script_string) )
		{
			break;
		}

		nd_node = GetNode( nd_node.script_string, "targetname" );
	}
}


// self = ai
function ai_setgoal( goal )
{
	nd_node = GetNode( goal, "targetname" );
	self SetGoal( nd_node, true );	
	self waittill( "goal" );
}

function ai_low_goal_radius()
{
	self.goalradius = 512;
}

function ai_very_low_goal_radius()
{
	self.goalradius = 16;
}

function set_goal_volume (e_goal_volume)
{
	self SetGoalVolume(e_goal_volume);
}

function set_robot_unarmed()
{
	orig_team = self GetTeam();
	
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	self ai::set_behavior_attribute( "rogue_control_speed", "walk" );	
	
	self SetTeam(orig_team);
	
	self.health = Int(self.health * 1.4);
}


function spawn_and_drive_jeep_and_guy(jeep_name, spawner_name)
{
	vh_jeep = vehicle::simple_spawn_single(jeep_name);
	ai_guy = spawner::simple_spawn_single( spawner_name );
	
	tag_pos = vh_jeep GetTagOrigin( "tag_gunner1");
	tag_angle = vh_jeep GetTagAngles( "tag_gunner1");
	
	ai_guy ForceTeleport ( tag_pos, tag_angle );
	ai_guy ai::set_ignoreall( true );
	ai_guy ai::set_ignoreme( true );

	ai_guy LinkTo( vh_jeep, "tag_gunner1");
	
	vh_jeep thread vehicle::go_path();	
	     
	vh_jeep turret::enable( 1, false );
	
	fire_time_min = 2;
	fire_time_max = 2;
	burst_wait_min = 0.1;
	burst_wait_max = 0.1;
	vh_jeep turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, 1 );
	
	return vh_jeep;
}
