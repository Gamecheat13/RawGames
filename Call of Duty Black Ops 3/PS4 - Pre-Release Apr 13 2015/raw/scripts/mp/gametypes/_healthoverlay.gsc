#using scripts\codescripts\struct;

#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace hostmigration;

function Callback_HostMigrationSave()
{
//	/#
//	hostmigration::debug_script_structs();
//	#/
}

function Callback_HostMigration()
{
//	/#
//	hostmigration::debug_script_structs();
//	#/

	setSlowMotion( 1, 1, 0 );
	//makeDvarServerInfo( "ui_guncycle", 0 );
	
	level.hostMigrationReturnedPlayerCount = 0;
	
	if (level.inPrematchPeriod)
		level waittill("prematch_over");
	
	if ( level.gameEnded )
	{
/#	
		println( "Migration starting at time " + gettime() + ", but game has ended, so no countdown." );	
#/
		return;
	}
		
/#	
	println( "Migration starting at time " + gettime() );	
#/
	
	level.hostMigrationTimer = true;
	sethostmigrationstatus(true);
	
	level notify( "host_migration_begin" );
	
	thread hostmigration::lockTimer();
	
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player thread hostmigration::hostMigrationTimerThink();
	}
	
	level endon( "host_migration_begin" );
	hostMigrationWait();

	level.hostMigrationTimer = undefined;
	sethostmigrationstatus(false);
/#	
	println( "Migration finished at time " + gettime() );	
#/

	// Setup match recorder for the new host
	recordMatchBegin();
	
	level notify( "host_migration_end" );
}
