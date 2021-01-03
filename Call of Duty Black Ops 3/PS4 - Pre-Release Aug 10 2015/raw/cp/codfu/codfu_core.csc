#using scripts\cp\codfu\codfu_camera;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
      	   	  

function autoexec __init__sytem__() {     system::register("codfu_core",&__init__,undefined,undefined);    }

function __init__()
{
	//client fields
	clientfield::register( "allplayers", "health1", 1, 24, "int", &set_health1, !true, true);
	clientfield::register( "allplayers", "health2", 1, 24, "int", &set_health2, !true, true);
	clientfield::register( "world", "player1", 1, 3, "int", &set_player1, !true, true);
	clientfield::register( "world", "player2", 1, 3, "int", &set_player2, !true, true);
	clientfield::register( "world", "gamestate", 1, 3, "int", &set_gamestate, !true, true);
}

function main()
{
	callback::add_callback( #"on_player_spawned", &on_player_spawn);

	codfu_camera::setup_camera_parameters();

	globalModel 			= GetGlobalUIModel();
	level.codfuUiModel	= CreateUIModel(globalModel, "CodfuGlobal");
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player1name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player2name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player1health"),0 );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player2health"),0 );
	
	level.codfu_players = [];
}


function setup_player_camera()
{
	self CameraSetUpdateCallback( &codfu_camera::update_camera );
}

function on_player_spawn( localClientNum )
{
	ForceGameModeMappings( localClientNum, "codfu" );
	
//	for (i=0;i<CODFU_MAX_PLAYERS;i++)
//	{
//		if (self GetEntityNumber() == level.codfu_players[i])
//		{
//			SetUIModelValue( GetUIModel(level.codfuUiModel, "player"+(i+1)+"name"), 			self.name);
//		//	SetUIModelValue( GetUIModel(level.codfuUiModel, "player"+(self GetEntityNumber()+1)+"health"), 			100);
//			break;
//		}
//	}
	SetExposureIgnoreTeleport(localclientnum, false);
}

function set_health1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player1health"), 			newVal/100000);
}

function set_health2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player2health"), 			newVal/100000);
}

function set_gamestate(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.codfu_gamestate = newVal;
}

function set_player1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.codfu_players[0] = newVal;
}

function set_player2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.codfu_players[1] = newVal;
}
