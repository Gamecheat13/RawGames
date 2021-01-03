#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

/#
#namespace rat_shared;

function init()
{
	if( !isdefined( level.rat ) )
	{
		level.rat = spawnstruct();
		level.rat.common = spawnstruct();
		level.rat.script_command_list = [];
			
		// called during automated playback
		rat_shared::addRATScriptCmd( "teleport", &rscTeleport );
		rat_shared::addRATScriptCmd( "teleportenemies", &rscTeleportEnemies );
		rat_shared::addRATScriptCmd( "simulatescripterror", &rscSimulateScriptError );
	
		// invoked from the record to emit playback instructions
		rat_shared::addRATScriptCmd( "rec_teleport", &rscRecTeleport );
	}
}

function addRatScriptCmd( commandName, functionCallback )
{
	init();
	level.rat.script_command_list[ commandName ] = functionCallback;
}

function codecallback_ratscriptcommand( params )
{
	init();
	
	assert( isdefined( params._cmd ) );
	assert( isdefined( params._id ) );
	
	assert( isdefined( level.rat.script_command_list[ params._cmd ] ), "Unknown rat script command " + params._cmd );
	
	callback = level.rat.script_command_list[ params._cmd ];
	level thread [[callback]]( params );
}

function rscTeleport( params )
{
	player = [[level.rat.common.gethostplayer]]();
	pos = ( Float(params.x), Float(params.y), Float(params.z) );
	player SetOrigin(pos);
	
	if( isdefined( params.ax ) )
	{
		angles = ( Float(params.ax), Float(params.ay), Float(params.az) );
		player SetPlayerAngles(angles);
	}
	RatReportCommandResult( params._id, 1 );
}


function rscTeleportEnemies( params )
{
	foreach ( player in level.players )
	{
		if( !isdefined( player.bot ) )
		{
			continue;
		}
		pos = ( Float(params.x), Float(params.y), Float(params.z) );
		player SetOrigin(pos);
	
		if( isdefined( params.ax ) )
		{
			angles = ( Float(params.ax), Float(params.ay), Float(params.az) );
			player SetPlayerAngles(angles);
		}
		if( !isdefined(params.all) )
		{
			break;
		}
	} 
	RatReportCommandResult( params._id, 1 );
}

function rscSimulateScriptError( params )
{
	if( params.errorlevel == "fatal" )
	{
		AssertMsg( "Simulating Script Assert" );	
	}
	else
	{
		thisdoesntexist.orthis = 0;
	}
	RatReportCommandResult( params._id, 1 );
}

function rscRecTeleport( params )
{
	println( "Received request for RAT teleport" );
	player = [[level.rat.common.gethostplayer]]();
	pos = player GetOrigin();
	angles = player getPlayerAngles( );
	cmd = "_cmd=teleport;x=" + pos[0] + ";y=" + pos[1] + ";z=" + pos[2] + ";ax=" + angles[0] + ";ay=" + angles[1] + ";az=" + angles[2];
	RatRecordMessage( 0, "ratscriptcmd", cmd );
	SetDvar( "rat_record_teleport_request", "0" );
}
#/