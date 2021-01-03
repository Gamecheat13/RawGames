#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace bb;



function init_shared()
{
	callback::on_start_gametype( &init );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************

function init()
{
	callback::on_connect( &player_init );
	callback::on_spawned( &on_player_spawned );
}

function player_init()
{
	self thread on_player_death();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_spawned()
{
	self endon("disconnect");

	self._bbData = [];
	
	// lives
	self._bbData[ "score" ] = 0;
	self._bbData[ "momentum" ] = 0;
	self._bbData[ "spawntime" ] = GetTime();

	// weapons
	self._bbData[ "shots" ] = 0;
	self._bbData[ "hits" ] = 0;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_disconnect()
{
	for(;;)
	{
		self waittill( "disconnect" );
		self commit_spawn_data();
		break;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_death()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "death" );
		self commit_spawn_data();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function commit_spawn_data() // self == player
{
	/#
	assert( isdefined( self._bbData ));
	#/
	if ( !isdefined( self._bbData ))
	{
		return;
	}

	bbprint( "mpplayerlives", "gametime %d spawnid %d lifescore %d lifemomentum %d lifetime %d name %s",
				GetTime(),
				getplayerspawnid( self ),
				self._bbData[ "score" ],
				self._bbData[ "momentum" ],
				(GetTime() - self._bbData[ "spawntime" ] ),
				self.name );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function commit_weapon_data( spawnid, currentWeapon, time0 ) // self == player
{
	/#
	assert( isdefined( self._bbData ));
	#/
	if ( !isdefined( self._bbData ))
	{
		return;
	}

	time1 = GetTime();

	bbPrint( "mpweapons", "spawnid %d name %s duration %d shots %d hits %d", 
				spawnid, 
				currentWeapon.name, 
				time1 - time0, 
				self._bbData["shots"], 
				self._bbData["hits"] );

	self._bbData[ "shots" ] = 0;
	self._bbData[ "hits" ] = 0;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function add_to_stat( statName, delta )
{
	if ( isdefined( self._bbData ) && isdefined( self._bbData[ statName ]))
	{
		self._bbData[ statName ] += delta;
	}
}