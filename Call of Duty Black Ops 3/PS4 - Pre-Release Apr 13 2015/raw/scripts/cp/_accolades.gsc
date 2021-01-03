#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace accolades;

function autoexec __init__sytem__() {     system::register("accolades",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.accolades = [];
	callback::on_connect( &on_player_connect );
}

/@
"Name: register( <str_accolade>, [str_increment_notify] )"
"Summary: Register an accolade for this level.  The accolade name needs to match the name in the stats table."
"CallOn: NA"
"MandatoryArg: <str_accolade> The accolade name."
"OptionalArg: [str_increment_notify] A notify that, when send to a player, will increment that player's stat for this accolade."
"Example: accolades::register( "sgen_kill_x_stuff, "stuff_killed" )"
@/
function register( str_accolade, str_increment_notify )
{
	level.accolades[ str_accolade ] = SpawnStruct();
	level.accolades[ str_accolade ].increment_notify = str_increment_notify;
}

// self == player
function on_player_connect()
{
	foreach ( str_accolade, s_accolade in level.accolades )
	{
		self.accolades[ str_accolade ] = SpawnStruct();
		self.accolades[ str_accolade ].current_value = 0;
		
		if ( isdefined( s_accolade.increment_notify ) )
		{
			self thread _increment_by_notify( str_accolade, s_accolade.increment_notify );
		}
	}
}

// self == player
function private _increment_by_notify( str_accolade, str_notify )
{
	while ( true )
	{
		self waittill( str_notify, n_val );
		increment( str_accolade, n_val );
	}
}

/@
"Name: increment_accolade( <str_accolade>, [n_val = 1] )"
"Summary: Increment an accolade stat.  Progress is only saved at skiptos."
"CallOn: level for all players, or on an individual player."
"MandatoryArg: <str_accolade> The accolade name."
"OptionalArg: [n_val] How much to increment the stat by."
"Example: accolades::increment( "sgen_kill_x_stuff, "stuff_killed" )"
@/
function increment( str_accolade, n_val = 1 )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player increment( str_accolade );
		}
	}
	else
	{
		self.accolades[ str_accolade ].current_value += n_val;
		
		// commit(); // TODO: commit the accolade if the goal value was met
	}
}

/@
"Name: commit()"
"Summary: Calls the code API to commit the current accolade stats."
"CallOn: level for all players, or on an individual player."
"Example: level accolades::commit()"
@/
function commit()
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{		
			player commit();
		}
	}
	else if ( IsArray( self.accolades ) )
	{
		foreach ( str_accolade, s_accolade in self.accolades )
		{
			self AddPlayerStat( str_accolade, s_accolade.current_value );
		}
	}
}
