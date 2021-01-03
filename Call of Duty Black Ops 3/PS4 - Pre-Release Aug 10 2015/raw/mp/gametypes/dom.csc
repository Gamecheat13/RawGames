#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "ui/fx_dom_cap_indicator_team" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_neutral" );
#precache( "client_fx", "ui/fx_dom_marker_team" );
#precache( "client_fx", "ui/fx_dom_marker_neutral" );

function main()
{
	callback::on_localclient_connect( &on_localclient_connect );
}

function on_localclient_connect( localClientNum )
{
	self.domFlags = [];

	while ( !isdefined( level.domFlags["a"] ) )
	{
		self.domFlags["a"] = ServerObjective_GetObjective( localClientNum, "dom_a" );
		self.domFlags["b"] = ServerObjective_GetObjective( localClientNum, "dom_b" );
		self.domFlags["c"] = ServerObjective_GetObjective( localClientNum, "dom_c" );
		wait (0.05);
	}
	
	foreach( key, flag_objective in self.domFlags)
	{
		self thread monitor_flag_fx(localClientNum, flag_objective, key);
	}
}

function monitor_flag_fx(localClientNum, flag_objective, flag_name)
{
	if ( !IsDefined( flag_objective ) )
		return;
	
	flag = SpawnStruct();
	
	flag.name = flag_name;
	flag.objectiveId = flag_objective;
	flag.origin = ServerObjective_GetObjectiveOrigin( localClientNum, flag_objective );
	flag.angles = (0,0,0);
	
	flag_entity = ServerObjective_GetObjectiveEntity( localClientNum, flag_objective );
	
	if ( isdefined(flag_entity) )
	{
		flag.origin = flag_entity.origin;
		flag.angles = flag_entity.angles;
	}
	
	fx_name = get_base_fx( flag, "neutral" );
	play_base_fx( localClientNum, flag, fx_name, "neutral" );
	flag.last_progress = 0;
	while(1)
	{
		
		team = ServerObjective_GetObjectiveTeam( localClientNum, flag_objective );
		if ( team != flag.last_team )
		{
			flag update_base_fx( localClientNum, flag, team );
		}
		
		progress = (ServerObjective_GetObjectiveProgress( localClientNum, flag_objective ) > 0);
		if ( progress != flag.last_progress )
		{
			flag update_cap_fx( localClientNum, flag, team, progress );
		}
		
		wait(0.05);
	}
}

function play_base_fx( localClientNum, flag, fx_name, team )
{
	if ( isdefined( flag.base_fx ) )
	{
		StopFx( localClientNum, flag.base_fx );
	}
	
	up = anglesToUp(flag.angles);
	forward = anglesToForward(flag.angles);
	flag.base_fx = PlayFx(localClientNum, fx_name, flag.origin, up, forward );
	SetFxTeam( localClientNum, flag.base_fx, team );
	
	flag.last_team = team;
}

function update_base_fx( localClientNum, flag, team )
{
	fx_name = get_base_fx( flag, team );
	
	if ( team == "neutral" )
	{
		play_base_fx( localClientNum, flag, fx_name, team );
	}
	else if ( flag.last_team == "neutral" )
	{
		play_base_fx( localClientNum, flag, fx_name, team );
	}
	else
	{
		SetFxTeam( localClientNum, flag.base_fx, team );
		flag.last_team = team;
	}
}

function play_cap_fx( localClientNum, flag, fx_name, team )
{
	if ( isdefined( flag.cap_fx ) )
	{
		KillFx( localClientNum, flag.cap_fx );
	}
	
	up = anglesToUp(flag.angles);
	forward = anglesToForward(flag.angles);
	flag.cap_fx = PlayFx(localClientNum, fx_name, flag.origin, up, forward  );
	SetFxTeam( localClientNum, flag.cap_fx, team );
}

function update_cap_fx( localClientNum, flag, team, progress )
{
	if ( progress == 0 )
	{
		if ( isdefined( flag.cap_fx ) )
		{
			KillFx( localClientNum, flag.cap_fx );
		}
		flag.last_progress = progress;
		return;
	}
	
	fx_name = get_cap_fx( flag, team );
	
	play_cap_fx( localClientNum, flag, fx_name, team );
	
	flag.last_progress = progress;
}

function get_base_fx( flag, team )
{
	if ( isdefined( level.domFlagBaseFxOverride ) )
	{
		fx = [[level.domFlagBaseFxOverride]]( flag, team );
		if ( isdefined( fx ) )
			return fx;
	}
	
	if ( team == "neutral" )
	{
		return "ui/fx_dom_marker_neutral";
	}
	else
	{
		return "ui/fx_dom_marker_team";
	}
}

function get_cap_fx( flag, team )
{
	if ( isdefined( level.domFlagCapFxOverride ) )
	{
		fx = [[level.domFlagCapFxOverride]]( flag, team );
		if ( isdefined( fx ) )
			return fx;
	}
	
	if ( team == "neutral" )
	{
		return "ui/fx_dom_cap_indicator_neutral";
	}
	else
	{
		return "ui/fx_dom_cap_indicator_team";
	}
}