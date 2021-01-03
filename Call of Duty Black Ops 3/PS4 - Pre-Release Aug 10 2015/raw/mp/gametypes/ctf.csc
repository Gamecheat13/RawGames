#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_shoutcaster;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "ui/fx_ctf_flag_base_team" );

function main()
{
	callback::on_localclient_connect( &on_localclient_connect );

	level.effect_scriptbundle = struct::get_script_bundle( "teamcolorfx", "teamcolorfx_ctf_flag_base" );
}

function on_localclient_connect( localClientNum )
{	
	objective_ids = [];

	while ( !isdefined( objective_ids["allies_base"] ) )
	{
		objective_ids["allies_base"] = ServerObjective_GetObjective( localClientNum, "allies_base" );
		objective_ids["axis_base"] = ServerObjective_GetObjective( localClientNum, "axis_base" );
		wait(0.05);
	}
	
	foreach( key, objective in objective_ids )
	{
		level.ctfFlags[key] = SpawnStruct();
		level.ctfFlags[key].objectiveId = objective;
		setup_flag( localClientNum, level.ctfFlags[key] );
	}
	
	setup_fx( localClientNum );
}

function setup_flag( localClientNum, flag )
{
	flag.origin = ServerObjective_GetObjectiveOrigin( localClientNum, flag.objectiveId );
	flag_entity = ServerObjective_GetObjectiveEntity( localClientNum, flag.objectiveId );
	flag.angles = (0,0,0);
	
	if ( isdefined(flag_entity) )
	{
		flag.origin = flag_entity.origin;
		flag.angles = flag_entity.angles;
	}
	
	flag.team = ServerObjective_GetObjectiveTeam( localClientNum, flag.objectiveId );
}

function setup_flag_fx( localClientNum, flag, effects )
{
	if ( isdefined( flag.base_fx ) )
	{
		StopFx( localClientNum,	flag.base_fx );
	}
	
	up = anglesToUp(flag.angles);
	forward = anglesToForward(flag.angles);
	flag.base_fx = PlayFx(localClientNum, effects[flag.team], flag.origin, up, forward );
	SetFxTeam( localClientNum, flag.base_fx, flag.team );
}

function setup_fx( localClientNum )
{
	effects = [];
	
	if ( shoutcaster::is_shoutcaster(localClientNum) )
	{
		effects = shoutcaster::get_color_fx( localClientNum, level.effect_scriptbundle );
	}
	else
	{
		effects["allies"] = "ui/fx_ctf_flag_base_team";
		effects["axis"] = "ui/fx_ctf_flag_base_team";
	}
	
	foreach( flag in level.ctfFlags)
	{
		thread setup_flag_fx(localClientNum, flag, effects );
	}
}

function watch_for_team_change( localClientNum )
{
	level notify( "end_team_change_watch" );
	level endon( "end_team_change_watch" );

	level waittill( "team_changed" );
	
	setup_fx( localClientNum );
}