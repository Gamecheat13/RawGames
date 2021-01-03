#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\cp\_util;
#using scripts\shared\spawner_shared;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\shared\animation_shared;
#using scripts\shared\stealth;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace vengeance_util;

#precache( "fx", "fire/fx_fire_ai_human_arm_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_arm_right_loop" );
#precache( "fx", "fire/fx_fire_ai_human_head_loop" );
#precache( "fx", "fire/fx_fire_ai_human_leg_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_leg_right_loop" );
#precache( "fx", "fire/fx_fire_ai_human_torso_loop" );
#precache( "fx", "fire/fx_fire_ai_human_hip_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_hip_right_loop" );


//============================================================
//
// AI functions
//
//============================================================

/@
"Name: init_hero( <str_hero> , <str_objective> , <b_generic_start> )"
"Summary: Spawn hero AI for use at beginning of level or skipto checkpoints."
"MandatoryArg: <str_hero> : Name of hero to be spawned.  Valid options are 'Hendricks' or 'Rachel'."
"MandatoryArg: <str_objective> : Name of skipto checkpoint."
"OptionalArg: <b_generic_start> : If true, will teleport AI to struct with str_objective_ai.  Otherwise, will teleport to struct with str_objective_hero."
"Example: vengeance_util::init_hero( "hendricks", "safehouse", true );"
@/
function init_hero( str_hero, str_objective, b_generic_start )
{
	hero = undefined;
	
	//Spawn AI and make a hero
	if( str_hero == "hendricks" )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		hero = level.ai_hendricks;
		level.ai_hendricks colors::set_force_color( "r" );
	}
	else if( str_hero == "rachel" )
	{
		level.ai_rachel = util::get_hero( "rachel" );
		hero = level.ai_rachel;
		level.ai_rachel colors::set_force_color( "b" );
	}
	else
	{
		AssertMsg( "Invalid hero defined for vengeance_util::init_hero." );
	}
	
	//Teleport to generic checkpoint location or specific checkpoint location
	if( isdefined( b_generic_start ) && b_generic_start )
	{
    	skipto::teleport_ai( str_objective );
	}
	else
	{
		s_start = struct::get( str_objective + "_" + str_hero, "targetname" );

		if( !isdefined( s_start ))
		{
			AssertMsg( "No struct defined for " + str_hero + " at checkpoint " + str_objective + "." );
		}
		
		hero ForceTeleport( s_start.origin, s_start.angles, true );
	}
}
	
//An AI will find the nearest pathnode and start a patrol.  
//If the AI is targeted at a specific pathnode, it will use that node instead.
function setup_patroller()
{
    wait( 1.0 );
    if( isDefined( self.target ))
    {
        patroller_start_node = GetNode( self.target, "targetname" );
    }
    if ( !isDefined( patroller_start_node ) )
    {
        //patroller_start_node = getnearestnode( self.origin, "Path" );
        nodes = GetNodesInRadiusSorted( self.origin, 1000, 1, 1000, "Path" );
    }
    if ( isDefined( nodes ) && nodes.size > 0 )
    {
        patroller_start_node = nodes[ 0 ];
    }
    if( isDefined( patroller_start_node ))
    {
        self.patroller_start_node = patroller_start_node;
    }
    else 
    {
        Assert( !isDefined( patroller_start_node ), "Can't find a valid starting patrol node!" );
    }
    self thread ai::patrol( self.patroller_start_node );
}

//============================================================
//
// Police Setup
//
//============================================================

//pass in a targetname of the group of police spawners you want
function spawn_police( targetname )
{
	if ( !isdefined( level.a_objectives[ "module_rescue_xy" ] ) )
	{
		level.rescued_police = 0;
		level.killed_police = 0;
		
		level.total_police_spawners = getentarray( "police_spawner", "script_noteworthy" );
		
		objectives::set( "cp_level_vengeance_police_rescue" );
		objectives::update_counter( "cp_level_vengeance_police_rescue", level.rescued_police, level.total_police_spawners.size );
		level thread rescued_police_progress();
	}
		
	//setup police
	police_spawners = getentarray( targetname, "targetname" );
	foreach ( spawner in police_spawners )
	{
		spawner spawner::add_spawn_function( &setup_police );
	}
	level.police = spawner::simple_spawn( targetname );
	
	// to place the waypoint on the police
	objectives::set( "cp_level_vengeance_police_rescue_waypoint", level.police  );
}

function rescued_police_progress()
{
	while( 1 )
	{
		msg = level util::waittill_any_return( "police_rescued", "police_killed" );
		
		if ( isDefined( msg ) )
		{
			if ( msg == "police_rescued" )
			{
				level.rescued_police++;
				objectives::update_counter( "cp_level_vengeance_police_rescue", level.rescued_police );
				IPrintLnBold( "A Police Has Been Rescued" );
			}
			
			else if ( msg == "police_killed" )
			{
				level.killed_police++;
				IPrintLnBold( "A Police Has Been Killed" );
			}
			
			if ( level.rescued_police == level.total_police_spawners.size )
			{
				IPrintLnBold( "All Police Have Been Rescued" );
				level notify( "all_police_rescued" );
				objectives::complete( "cp_level_vengeance_police_rescue" );
				break;
			}
			
			/*
			else if ( level.killed_police + level.rescued_police == level.police.size )
			{
				IPrintLnBold( "All Police in Area Have Been Rescued or Killed" );
				level notify( "all_police_rescued_or_killed" );
				break;
			}
			*/
		}
	}
}

function setup_police()
{
	level endon( "end_setup_police" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self ai::gun_remove();
	self.health = 1;
	self allowedstances( "crouch" );
	police_crouch_nodes = getnodearraysorted( "police_crouch_node", "targetname", self.origin, 512 );
	self setgoalnode( police_crouch_nodes[ 0 ], true, 16, 16 );
	self.t_use = create_trigger_radius( self.origin, 32, 64, undefined, undefined, true );
	self.t_use SetHintString( &"CP_MI_SING_VENGEANCE_RESCUE_POLICE_TRIGGER" );
	self.t_use enablelinkto();
	self.t_use linkto( self, "tag_origin", ( 0, 0, 32 ), ( 0, 0, 0 ) ); //link with a z offset of 32 because the trigger_use_radius requires lookat and the offset puts it on the center of the guy
	self thread animation::play( "ch_ram_03_02_defend_vign_last_stand_loop_guy01", self.origin, self.angles );
	self.allowdeath = true;
	self.a.pose = "prone_back";
	self thread police_use_trigger_watcher();

	msg = self util::waittill_any_return( "rescued", "death" );
	
	self stopanimscripted();
	
	if ( isdefined( msg ) )
	{
		if ( isdefined( self.t_use ) )
			self.t_use Delete();
		
		if ( msg == "rescued" )
		{
			level notify( "police_rescued" );
			
			objectives::complete( "cp_level_vengeance_police_rescue_waypoint", self );
			
			if ( isdefined( self.rescued_function ) )
			{
				self thread [[ self.rescued_function ]]();
			}
			
			else
			{
				police_escape_nodes = getnodearraysorted( "police_escape_node", "targetname", self.origin, 2048 );
				self setgoalentity( police_escape_nodes[ 0 ], true, 16, 16 );
				
				self waittill( "goal" );
				
				self Delete();
			}
		}
		
		else if ( msg == "death" )
		{
			level notify( "police_killed" );
			objectives::complete( "cp_level_vengeance_police_rescue_waypoint", self );
			if ( isdefined( self ) )
				self startragdoll();
		}
	}
}

function police_execute_watcher()
{
	//wait for the hostage takers to become alerted
	self ai::set_ignoreme( false );
}

function police_use_trigger_watcher()
{
	self endon( "death" );
	
	self.t_use trigger::wait_till();
	
	self notify( "rescued" );
}

//spawns a trigger radius use ent
function create_trigger_radius( v_position, n_radius, n_height, n_spawn_flags = 0, str_trigger_type = "trigger_radius_use", requireLookAt )
{
	Assert( IsDefined( v_position ), "v_position is required for create_trigger_radius_use!" );
	Assert( IsDefined( n_radius ), "n_radius is required for create_trigger_radius_use!" );
	Assert( IsDefined( n_height ), "n_height is required for create_trigger_radius_use!" );
	
	t_use = Spawn( str_trigger_type, v_position, n_spawn_flags, n_radius, n_height );
	
    t_use TriggerIgnoreTeam();
    t_use SetVisibleToAll();
    t_use SetTeamForTrigger( "none" );
    
    if ( isdefined( requireLookAt ) && requireLookAt == true )
    	t_use UseTriggerRequireLookAt();	
    
    if ( str_trigger_type == "trigger_radius_use" )
    {
    	t_use SetCursorHint( "HINT_NOICON" );  // text will not show up without this call
    }
    
    return t_use;
}

/@
"Name: skipto_baseline( <str_objective> <b_starting> )"
"Summary: Setup level baseline for all skipto points in this map
"Example: vengeance_util::skipto_baseline( str_objective, b_starting );"
@/
function skipto_baseline( str_objective, b_starting )
{
	if ( !isDefined( str_objective ) )
		str_objective = "";
	
	if ( !isDefined( b_starting ) )
		b_starting = true;

	if ( b_starting )
	{
		// Setup stealth event awareness parameters
		LoadSentientEventParameters( "sentientevents_vengeance_default" );

		stealth::init();
	}
}

/@
"Name: handle_door( <n_time> <b_reverse> )"
"Summary: Simple function for rotating door over time at desired angle. If targeted to clip bmodel, it will rotate as well."
"MandatoryArg: <n_time> : Float of how long you want the door to move."
"OptionalArg: <b_reverse> : Set to true if you want to move the door opposite your original setting."
"Example: vengeance_util::handle_door( 2.0 );"
@/
function handle_door( n_time, b_reverse )
{
	str_rotation = self.script_noteworthy;
	n_rotation = 0;
	
	n_rotation = Int( str_rotation );
	
	if( isDefined( b_reverse ) && b_reverse == true )
	{
		n_rotation = n_rotation * -1;
	}
	
	if( isDefined( self.target ))
	{
		e_clip = GetEnt( self.target, "targetname" );
		e_clip rotateyaw( n_rotation, n_time );
	}
		
	self rotateyaw( n_rotation, n_time );
}

/@
"Name: enable_nodes( <str_key> <str_val> <b_enable> )"
"Summary: Toggle a group of nodes on or off."
"MandatoryArg: <str_key> : Name of nodes."
"OptionalArg: <str_val> : Targetname, script_noteworthy....whatever you set the name to."
"OptionalArg: <b_enable> : True or false."
"Example: vengeance_util::enable_nodes( "window_mantle_nodes", "targetname", true );"
@/
function enable_nodes( str_key, str_val = "targetname", b_enable = true )
{
	a_nodes = GetNodeArray( str_key, str_val );
	foreach( nd_node in a_nodes )
	{
		SetEnableNode( nd_node, b_enable );
	}
}

//-- used for staging vignettes/battles where you need the AI to stay alive, before the player
// reaches a certain point.  Then notify/kill the AI's magic bulletshield globally

/@
"Name: magic_bullet_shield_till_notify( <str_kill_mbs> <b_disable_w_player_shot> <str_phalanx_scatter_notify> )"
"Summary: Used for staging vignettes/battles where you need the AI to stay alive before the player reaches a certain point.  Then notify/kill the AI's magic_bullet_shield."
"MandatoryArg: <str_kill_mbs> : Notify to kill magic_bullet_shield."
"OptionalArg: <b_disable_w_player_shot> : If true, magic_bullet_shield will end if player shoots AI, regardless of notify."
"OptionalArg: <str_phalanx_scatter_notify> : If a robot phalanx exists, shooting one can disable magic_bullet_shield for all."
"Example: vengeance_util::magic_bullet_shield_till_notify( "stop_gunner_mbs", "true" );"
@/
function magic_bullet_shield_till_notify( str_kill_mbs, b_disable_w_player_shot, str_phalanx_scatter_notify )
{
	self endon( "death" );
	
	util::magic_bullet_shield( self );
	
	if( b_disable_w_player_shot )
	{
		self thread stop_magic_bullet_shield_on_player_damage( str_kill_mbs, str_phalanx_scatter_notify );
	}
	
	util::waittill_any_ents( level, str_kill_mbs, self, str_kill_mbs );
	
	util::stop_magic_bullet_shield( self );
}

function stop_magic_bullet_shield_on_player_damage( str_kill_mbs, str_phalanx_scatter_notify )
{
	self endon( "ram_kill_mb" ); // Unique string to this function
	self endon( str_kill_mbs );
	level endon( str_kill_mbs );
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker );
		
		if( IsPlayer( attacker ) )
		{
			//-- if you are breaking up a phalanx, then also kill mbs on that entire group
			if( IsDefined( str_phalanx_scatter_notify ) )
			{
				level notify( str_phalanx_scatter_notify );
				wait 0.05; //process the scatter notify seperately
				level notify( str_kill_mbs );
			}
			
			self notify( str_kill_mbs );
		}
	}
}

function fire_fx()
{
	//fire fx
	level._effect[ "civ_burn_j_elbow_le_loop" ]		= "fire/fx_fire_ai_human_arm_left_loop";	// hand and forearm fires
	level._effect[ "civ_burn_j_elbow_ri_loop" ]		= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect[ "civ_burn_j_shoulder_le_loop" ]	= "fire/fx_fire_ai_human_arm_left_loop";	// upper arm fires
	level._effect[ "civ_burn_j_shoulder_ri_loop" ]	= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect[ "civ_burn_j_spine4_loop" ]			= "fire/fx_fire_ai_human_torso_loop";		// upper torso fires
	level._effect[ "civ_burn_j_hip_le_loop" ]			= "fire/fx_fire_ai_human_hip_left_loop";	// thigh fires
	level._effect[ "civ_burn_j_hip_ri_loop" ]			= "fire/fx_fire_ai_human_hip_right_loop";
	level._effect[ "civ_burn_j_knee_le_loop" ]		= "fire/fx_fire_ai_human_leg_left_loop";	// shin fires
	level._effect[ "civ_burn_j_knee_ri_loop" ]		= "fire/fx_fire_ai_human_leg_right_loop";
	level._effect[ "civ_burn_j_head_loop" ] 			= "fire/fx_fire_ai_human_head_loop";		// head fire
}

function set_civilian_on_fire( b_cointoss = true )
{
	self endon( "death" );
	
	//always have a torso fire
	PlayFXOnTag( level._effect[ "civ_burn_j_spine4_loop" ], self, "J_Spine4" );
	
	if( isDefined( b_cointoss ) && b_cointoss == false )
	{
		wait 0.5;
		
		PlayFXOnTag( level._effect[ "civ_burn_j_head_loop" ], self, "J_Head" );
		
		wait randomFloatRange( 0.1, 2.0 );
		
		PlayFXOnTag( level._effect[ "civ_burn_j_shoulder_le_loop" ], self, "J_Shoulder_LE" );
		PlayFXOnTag( level._effect[ "civ_burn_j_shoulder_ri_loop" ], self, "J_Shoulder_RI" );
		
		wait randomFloatRange( 0.1, 2.0 );
		
		PlayFXOnTag( level._effect[ "civ_burn_j_hip_le_loop" ], self, "J_Hip_LE" );
		PlayFXOnTag( level._effect[ "civ_burn_j_hip_ri_loop" ], self, "J_Hip_RI" );
		
		wait randomFloatRange( 0.1, 2.0 );
		
		PlayFXOnTag( level._effect[ "civ_burn_j_elbow_le_loop" ], self, "J_Elbow_LE" );
		PlayFXOnTag( level._effect[ "civ_burn_j_elbow_ri_loop" ], self, "J_Elbow_RI" );
		
		wait randomFloatRange( 0.1, 2.0 );

		PlayFXOnTag( level._effect[ "civ_burn_j_knee_le_loop" ], self, "J_Knee_LE" );
		PlayFXOnTag( level._effect[ "civ_burn_j_knee_ri_loop" ], self, "J_Knee_RI" );
	}
	else
	{
		wait randomFloatRange( 0.1, 2.0 );
			
		//elbows
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_elbow_le_loop" ], self, "J_Elbow_LE" );
		}
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_elbow_ri_loop" ], self, "J_Elbow_RI" );
		}
		
		wait randomFloatRange( 0.1, 2.0 );
		
		//shoulders
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_shoulder_le_loop" ], self, "J_Shoulder_LE" );
		}
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_shoulder_ri_loop" ], self, "J_Shoulder_RI" );
		}
		
		wait randomFloatRange( 0.1, 2.0 );
		
		//hips
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_hip_le_loop" ], self, "J_Hip_LE" );
		}
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_hip_ri_loop" ], self, "J_Hip_RI" );
		}
		
		wait randomFloatRange( 0.1, 2.0 );
		
		//knees
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_knee_le_loop" ], self, "J_Knee_LE" );
		}
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_knee_ri_loop" ], self, "J_Knee_RI" );
		}
		
		wait randomFloatRange( 0.1, 2.0 );
		
		//Head
		if ( math::cointoss() )
		{
			PlayFXOnTag( level._effect[ "civ_burn_j_head_loop" ], self, "J_Head" );
		}
	}
}