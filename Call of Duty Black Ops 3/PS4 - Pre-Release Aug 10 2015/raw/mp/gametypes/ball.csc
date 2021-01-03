#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#using scripts\mp\_shoutcaster;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




#precache( "client_fx", "ui/fx_uplink_goal_marker" );
#precache( "client_fx", "ui/fx_uplink_goal_marker_flash" );

function main()
{	
	clientfield::register( "allplayers", "ballcarrier", 1, 1, "int", &player_ballcarrier_changed, !true, true );
	clientfield::register( "allplayers", "passoption", 1, 1, "int", &player_passoption_changed, !true, !true );
	clientfield::register( "world", "ball_home" , 1, 1, "int",  &world_ball_home_changed, !true, true );
	clientfield::register( "world", "ball_score_allies" , 1, 1, "int",  &world_ball_score_allies, !true, true );
	clientfield::register( "world", "ball_score_axis" , 1, 1, "int",  &world_ball_score_axis, !true, true );
	
	callback::on_localclient_connect( &on_localclient_connect );
	
	level.ball_score_value = [];
	level.ball_score_value["allies"] = 0;
	level.ball_score_value["axis"] = 0;
	
	level.effect_scriptbundles = [];
	level.effect_scriptbundles["goal"] = struct::get_script_bundle( "teamcolorfx", "teamcolorfx_uplink_goal" );
	level.effect_scriptbundles["goal_score"] = struct::get_script_bundle( "teamcolorfx", "teamcolorfx_uplink_goal_score" );
}

function on_localclient_connect( localClientNum )
{	
	objective_ids = [];

	while ( !isdefined( objective_ids["allies"] ) )
	{
		objective_ids["allies"] = ServerObjective_GetObjective( localClientNum, "ball_goal_allies" );
		objective_ids["axis"] = ServerObjective_GetObjective( localClientNum, "ball_goal_axis" );
		wait(0.05);
	}
	
	foreach( key, objective in objective_ids )
	{
		level.goals[key] = SpawnStruct();
		level.goals[key].objectiveId = objective;
		setup_goal( localClientNum, level.goals[key] );
	}
	
	setup_fx( localClientNum );
}

function setup_goal( localClientNum, goal )
{
	goal.origin = ServerObjective_GetObjectiveOrigin( localClientNum, goal.objectiveId );
	goal_entity = ServerObjective_GetObjectiveEntity( localClientNum, goal.objectiveId );
	
	if ( isdefined(goal_entity) )
	{
		goal.origin = goal_entity.origin;
	}
	
	goal.team = ServerObjective_GetObjectiveTeam( localClientNum, goal.objectiveId );
}

function setup_goal_fx( localClientNum, goal, effects )
{
	if ( isdefined( goal.base_fx ) )
	{
		StopFx( localClientNum,	goal.base_fx );
	}
	
	goal.base_fx = PlayFx(localClientNum, effects[goal.team], goal.origin );
	SetFxTeam( localClientNum, goal.base_fx, goal.team );
}

function setup_fx( localClientNum )
{
	effects = [];
	
	if ( shoutcaster::is_shoutcaster(localClientNum) )
	{
		effects = shoutcaster::get_color_fx( localClientNum, level.effect_scriptbundles["goal"] );
	}
	else
	{
		effects["allies"] = "ui/fx_uplink_goal_marker";
		effects["axis"] = "ui/fx_uplink_goal_marker";
	}
	
	foreach( goal in level.goals)
	{
		thread setup_goal_fx(localClientNum, goal, effects );
	}
}

function watch_for_team_change( localClientNum )
{
	level notify( "end_team_change_watch" );
	level endon( "end_team_change_watch" );

	level waittill( "team_changed" );
	
	setup_fx( localClientNum );
}

function play_score_fx( localClientNum, goal)
{
	effects = [];
	
	if ( shoutcaster::is_shoutcaster(localClientNum) )
	{
		effects = shoutcaster::get_color_fx( localClientNum, level.effect_scriptbundles["goal_score"] );
	}
	else
	{
		effects["allies"] = "ui/fx_uplink_goal_marker_flash";
		effects["axis"] = "ui/fx_uplink_goal_marker_flash";
	}

	fx_handle = PlayFx(localClientNum, effects[goal.team], goal.origin );
	SetFxTeam( localClientNum, fx_handle, goal.team );
}

function world_ball_score_allies( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal != level.ball_score_value["allies"] && !bInitialSnap )
	{
		level.ball_score_value["allies"] = newVal;
		play_score_fx( localClientNum, level.goals["allies"] );
	}
}

function world_ball_score_axis( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal != level.ball_score_value["axis"] && !bInitialSnap )
	{
		level.ball_score_value["axis"] = newVal;
		play_score_fx( localClientNum, level.goals["axis"] );
	}
}

function player_ballcarrier_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	localplayer = getlocalplayer( localClientNum );
	
	if( localplayer == self )
	{
		if( newVal )
		{
			self._hasBall = true;
		}
		else
		{
			self._hasBall = false;
			SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.passOption" ), 0 );
		}
	}
	
	if( ( localplayer != self ) && self isFriendly( localClientNum ) )
	{
		self set_player_ball_carrier_dr( newVal );
	}
	else
	{	
		self set_player_ball_carrier_dr( false );
	}
	
	if ( isdefined( level.ball_carrier ) && level.ball_carrier != self )
		return;
		
	level notify( "watch_for_death" );

	if ( newVal == 1 )
	{
		self set_hud(localClientNum);
		
		// we need to track when the player dies because if they watch killcam we will not get flag updates
		self thread watch_for_death( localClientNum );
	}
	else
	{
		self clear_hud(localClientNum);
	}
}

function set_hud( localClientNum )
{
		level.ball_carrier = self;
		
		if ( shoutcaster::is_shoutcaster( localClientNum ) )
		{
			friendly = self shoutcaster::is_friendly( localclientnum );
		}
		else
		{
			friendly = self isFriendly( localClientNum );
		}
		
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballStatusText" ),  self.name );	
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByFriendly" ), friendly );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByEnemy" ), !friendly );
}

function clear_hud( localClientNum )
{
		level.ball_carrier = undefined;

		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByEnemy" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByFriendly" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballStatusText" ),  &"MPUI_BALL_AWAY" );
}

function watch_for_death( localClientNum )
{
	level endon( "watch_for_death" );
	
	self waittill( "entityshutdown" );

	self clear_hud(localClientNum);	
}

function player_passoption_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	localplayer = getlocalplayer( localClientNum );
	
	if( ( localplayer != self ) && self isFriendly( localClientNum ) )
	{
		if( ( isdefined( localplayer._hasBall ) && localplayer._hasBall ) )
		{
			SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.passOption" ), newVal );
		}
	}
}

function world_ball_home_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 || bInitialSnap )
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByEnemy" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballHeldByFriendly" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "ballGametype.ballStatusText" ),  &"MPUI_BALL_HOME" );
	}
}

function set_player_ball_carrier_dr( on_off )
{
	self duplicate_render::update_dr_flag( "ballcarrier", on_off );
}

function set_player_pass_option_dr( on_off )
{
	self duplicate_render::update_dr_flag( "passoption", on_off );
}