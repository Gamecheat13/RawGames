#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

   

                                                                 
                                                                                                                               

#namespace zm_bgb_phoenix_up;


function autoexec __init__sytem__() {     system::register("zm_bgb_phoenix_up",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_phoenix_up", "activated", 1, undefined, undefined, undefined, &activation );
	bgb::register_lost_perk_override( "zm_bgb_phoenix_up", &lost_perk_override );
}

// self = player activating the buff
function activation()
{
	level notify( "bgb_phoenix_up_revive", self );

	// revive all players
	players = level.players;
	foreach( player in players )
	{
		if( self zm_laststand::can_revive( player, true, true ) ) // do revive check, ignoring sight and touch checks
		{
			player notify( "bgb_phoenix_up_revive" ); // return any lost perks after reviving the player
			wait 0.05; // give the return-perk thread a chance to run before reviving the player kills it
			player zm_laststand::auto_revive( self, false );
		}
	}
	
	self bgb::do_one_shot_use();
}

// self = any player who lost a perk
function lost_perk_override( perk )
{
	// make a thread to save off the perk (if the player revives before bgb activation, we won't return it)
	self thread revive_and_return_perk_on_bgb_activation( perk );
	
	return false; // don't prevent losing the perk
}

// self = player who lost a perk
function revive_and_return_perk_on_bgb_activation( perk )
{
	self endon( "player_revived" );
	self endon( "disconnect" );
	self endon( "bled_out" );
	level endon( "between_round_over" ); // if we advance a round and naturally revive, the player should lose this buff
	
	self waittill( "bgb_phoenix_up_revive" );
	
	// return perk, didn't buy
	self zm_perks::give_perk( perk, false );
}
