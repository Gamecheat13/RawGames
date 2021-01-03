/* zm_zod_quest_vo.gsc
 *
 * Purpose : 	VO-related functions for zm_zod's story quest.
 *		
 * Author : 	G Henry Schmitt
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;






#namespace zm_zod_quest_vo;


function opening_vo()
{
}

function see_map_trigger()
{
}

// plays a one-part conversation
// convo = an array of individual VO line aliases
// self = the player
function vo_play_soliloquy( convo )
{
	self endon( "disconnect" );
	
	Assert( IsDefined( convo ), "vo_play_soliloquy called with undefined conversation" );

	if ( !(level flag::get( "story_vo_playing" )) ) // we must be allowed to play story_vo
	{
		level flag::set( "story_vo_playing" );
		self thread vo_play_soliloquy_disconnect_listener();
		self.dontspeak = true;
		self clientfield::set_to_player( "isspeaking", 1 );

		for ( i=0; i<convo.size; i++ )
		{
			if ( ( isdefined( self.afterlife ) && self.afterlife ) )
			{
				self.dontspeak = false;
				self clientfield::set_to_player( "isspeaking", 0 );
				level flag::clear( "story_vo_playing" );
				self notify( "soliloquy_vo_done" );
				return;
			}
			else
			{
				self PlaySoundWithNotify( convo[i], "sound_done" + convo[i] );
				self waittill( "sound_done" + convo[i] );
			}
			
			wait 1;
		}

		self.dontspeak = false;
		self clientfield::set_to_player( "isspeaking", 0 );
		level flag::clear( "story_vo_playing" );
		self notify( "soliloquy_vo_done" );
	}
}

// clears the "story_vo_playing" flag if the player disconnects, so other vo doesn't remain blocked
function vo_play_soliloquy_disconnect_listener()
{
	self endon( "soliloquy_vo_done" );
	
	self waittill( "disconnect" );
	level flag::clear( "story_vo_playing" );
}

// plays a four-part conversation
// convo = an array of individual VO line aliases
function vo_play_four_part_conversation( convo )
{
	Assert( IsDefined( convo ), "vo_play_soliloquy called with undefined conversation" );
	
	players = GetPlayers();
	if ( ( players.size == 4 ) && !( level flag::get( "story_vo_playing" ) ) ) // there must be four players, and we must be allowed to play story_vo
	{
		level flag::set( "story_vo_playing" );
		
		old_speaking_player = undefined;
		speaking_player = undefined;
		n_dist = 0;
		n_max_reply_dist = 1500;

		// get the four characters
		e_player1 = undefined;
		e_player2 = undefined;
		e_player3 = undefined;
		e_player4 = undefined;
		foreach( player in players )
		{
			if ( IsDefined( player ) )
			{
				switch ( player.character_name )
				{
					case "Arlington":
						e_player1 = player;
						break;
					case "Sal":
						e_player2 = player;
						break;
					case "Billy":
						e_player3 = player;
						break;
					case "Finn":
						e_player4 = player;
						break;
				}
			}
		}

		// make sure all characters are defined
		if ( ( !IsDefined( e_player1 ) ) || ( !IsDefined( e_player2 ) ) || ( !IsDefined( e_player3 ) ) || ( !IsDefined( e_player4 ) ) )
		{
			return;
		}
		else
		{
			foreach( player in players )
			{
				if ( IsDefined( player ) )
				{
					player.dontspeak = true;
					player clientfield::set_to_player( "isspeaking", 1 ); 
				}	
			}
		}

		for( i=0; i<convo.size; i++ )
		{
			players = GetPlayers(); // check each time to make sure player count hasn't changed
			if ( players.size != 4 )
			{
				foreach( player in players )
				{
					if ( IsDefined( player ) )
					{
						player.dontspeak = false;
						player clientfield::set_to_player( "isspeaking", 0 );
					}
				}
				level flag::clear( "story_vo_playing" );
				return;
			}
			
			if ( IsSubStr( convo[i], "plr_0" ) )
			{
				speaking_player = e_player4;
			}
			else if ( IsSubStr( convo[i], "plr_1" ) )
			{
				speaking_player = e_player2;
			}
			else if ( IsSubStr( convo[i], "plr_2" ) )
			{
				speaking_player = e_player3;
			}
			else if ( IsSubStr( convo[i], "plr_3" ) )
			{
				speaking_player = e_player1;
			}
			
			if ( IsDefined( old_speaking_player ) )
			{
				n_dist = Distance( old_speaking_player.origin, speaking_player.origin );
			}
			
			if ( speaking_player.afterlife || ( n_dist > n_max_reply_dist ) )
			{
				foreach( player in players )
				{
					if ( IsDefined( player ) )
					{
						player.dontspeak = false;
						player clientfield::set_to_player( "isspeaking", 0 );
					}
				}
				level flag::clear( "story_vo_playing" );
				return;
			}
			else
			{
				speaking_player PlaySoundWithNotify( convo[i], "sound_done" + convo[i] );
				speaking_player waittill( "sound_done" + convo[i] );
				old_speaking_player = speaking_player;
			}
			wait 1;
		}
		
		foreach( player in players )
		{
			if ( IsDefined( player ) )
			{
				player.dontspeak = false;
				player clientfield::set_to_player( "isspeaking", 0 );
			}
		}
		level flag::clear( "story_vo_playing" );
	}
}
