#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#using scripts\mp\_shoutcaster;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       






function main()
{	
	clientfield::register( "actor", "robot_state" , 1, 2, "int",  &robot_state_changed, !true, true );
	
	callback::on_localclient_connect( &on_localclient_connect );
}

function onPrecacheGameType()
{
}

function onStartGameType()
{	
}

function on_localclient_connect( localClientNum )
{
	// Initialize the ui model values
	SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.robotStatusText" ), &"MPUI_ESCORT_ROBOT_MOVING" );
	SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.robotStatusVisible" ), 0 );
	SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.enemyRobot" ), 0 );
	
	level wait_team_changed( localClientNum );
}

// Clientfield Callbacks
//========================================

function robot_state_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( bNewEnt )
	{
		if ( !isdefined( level.escortRobots ) ) level.escortRobots = []; else if ( !IsArray( level.escortRobots ) ) level.escortRobots = array( level.escortRobots ); level.escortRobots[level.escortRobots.size]=self;;
		
		self thread update_robot_team( localClientNum );
	}
	
	if ( newVal == 1 )
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.robotStatusVisible" ), 1 );
	}
	else
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.robotStatusVisible" ), 0 );
	}
}


// HUD Updates
//========================================

function wait_team_changed( localClientNum )
{
	while( 1 )
	{
		level waittill( "team_changed" );
		
		// the local player might not be valid yet and will cause the team detection functionality not to work
		while ( !isdefined(	GetNonPredictedLocalPlayer( localClientNum ) ) )
		{
			wait( .05 );
		}
	
		if ( !isdefined( level.escortRobots ) )
		{
			continue;
		}
		
		foreach ( robot in level.escortRobots )
		{
			robot thread update_robot_team( localClientNum );
		}
	}
}

function update_robot_team( localClientNum )
{
	localPlayerTeam = GetLocalPlayerTeam( localClientNum );
	
	friend = self.team == localPlayerTeam;
	
	if ( friend )
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.enemyRobot" ), 0 );	
	}
	else
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "escortGametype.enemyRobot" ), 1 );	
	}
	
	// TODO: FOR SHIP - Get this working when a player switches teams mid game
	// Update the robot friend/enemy material
	self duplicate_render::update_dr_flag( "enemyvehicle_fb", !friend );
}