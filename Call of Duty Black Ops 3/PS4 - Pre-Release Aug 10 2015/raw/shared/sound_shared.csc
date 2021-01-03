    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace sound;

function loop_fx_sound( clientNum, alias, origin, ender )
{
	sound_entity = spawn(clientNum, origin, "script_origin");

	if( isdefined( ender ) )
	{
		thread loop_delete( ender, sound_entity ); 
		self endon( ender ); 
	}
	
	sound_entity playloopsound( alias );
}

/@
"Name: play_in_space( <clientNum>, <alias> , <origin>  )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <clientNum> : local client to hear the sound."
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"Example: sound::play_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
@/ 
function play_in_space( localClientNum, alias, origin)
{
	PlaySound( localClientNum, alias, origin); 
}

function loop_delete( ender, sound_entity )
{
//	ent endon( "death" ); 
	self waittill( ender ); 
	sound_entity delete();
}

function play_on_client( sound_alias )
{
	players = level.localPlayers;

	PlaySound( 0, sound_alias, players[0].origin );
}

function loop_on_client( sound_alias, min_delay, max_delay, end_on )
{
	players = level.localPlayers;

	if( isdefined( end_on ) )
	{
		level endon( end_on );
	}

	for( ;; )
	{
		play_on_client( sound_alias );
		wait( min_delay + RandomFloat( max_delay ) );
	}
}
