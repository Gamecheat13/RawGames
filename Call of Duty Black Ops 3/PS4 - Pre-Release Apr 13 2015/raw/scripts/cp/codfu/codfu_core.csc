#using scripts\cp\codfu\codfu_camera;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

function autoexec __init__sytem__() {     system::register("codfu_core",&__init__,undefined,undefined);    }

function __init__()
{
	//client fields
	clientfield::register( "allplayers", "health1", 1, 10, "int", &set_health1, !true, true);
	clientfield::register( "allplayers", "health2", 1, 10, "int", &set_health2, !true, true);
	clientfield::register( "allplayers", "health3", 1, 10, "int", &set_health3, !true, true);
	clientfield::register( "allplayers", "health4", 1, 10, "int", &set_health4, !true, true);
}

function main()
{
	callback::add_callback( #"on_player_spawned", &on_player_spawn);

	codfu_camera::setup_camera_parameters();

	globalModel 			= GetGlobalUIModel();
	level.codfuUiModel	= CreateUIModel(globalModel, "CodfuGlobal");
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player1name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player2name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player3name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player4name"),"" );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player1health"),0 );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player2health"),0 );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player3health"),0 );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "player4health"),0 );
	SetUIModelValue( CreateUIModel(level.codfuUiModel, "fightBanner"),0 );
}


function setup_player_camera()
{
	self CameraSetUpdateCallback( &codfu_camera::update_camera );
}

function on_player_spawn( localClientNum )
{
	ForceGameModeMappings( localClientNum, "codfu" );
	
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player"+(self GetEntityNumber()+1)+"name"), 			self.name);
//	SetUIModelValue( GetUIModel(level.codfuUiModel, "player"+(self GetEntityNumber()+1)+"health"), 			100);
}

function set_health1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player1health"), 			newVal);
}

function set_health2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player2health"), 			newVal);
}

function set_health3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player3health"), 			newVal);
}

function set_health4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	SetUIModelValue( GetUIModel(level.codfuUiModel, "player4health"), 			newVal);
}

