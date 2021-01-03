#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#namespace bonuszmsound;

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
		
	level.bzmDrSalim 	= Spawn( "script_origin", (0,0,0) ); // Used for playing Dr.Salims VO	
	level.bzmDolos 		= Spawn( "script_origin", (0,0,0) ); // Used for playing Dolos VO	
	level.bzmDeimos		= Spawn( "script_origin", (0,0,0) ); // Used for playing Deimos VO	
	level.bzmPlayer		= Spawn( "script_origin", (0,0,0) ); // Used for playing Deimos VO	
		
	level.BZMSalimDialogueCallback 	= &BZM_PlayDrSalimVox;
	level.BZMPlayerDialogueCallback = &BZM_PlayPlayerVox;
	level.BZMDolosDialogueCallback = &BZM_PlayDolosVox;
	level.BZMDeimosDialogueCallback = &BZM_PlayDeimosVox;
}

function BZM_PlayDrSalimVox( alias, blocking = true )
{
	assert(( SessionModeIsCampaignZombiesGame() ));
	assert( IsDefined( level.bzmDrSalim ) );	
	
	if( blocking )
		level.bzmDrSalim dialog::say( alias );
	else
		level.bzmDrSalim thread dialog::say( alias );
}

function BZM_PlayPlayerVox( alias, blocking = true )
{
	assert(( SessionModeIsCampaignZombiesGame() ));
	
	if( blocking )
		level.bzmPlayer dialog::player_say( alias );
	else
		level.bzmPlayer thread dialog::player_say( alias );
}

function BZM_PlayDolosVox( alias, blocking = true )
{
	assert(( SessionModeIsCampaignZombiesGame() ));
	
	if( blocking )
		level.bzmDolos dialog::player_say( alias );
	else
		level.bzmDolos thread dialog::player_say( alias );
}

function BZM_PlayDeimosVox( alias, blocking = true )
{
	assert(( SessionModeIsCampaignZombiesGame() ));
	
	if( blocking )
		level.bzmDeimos dialog::player_say( alias );
	else
		level.bzmDeimos thread dialog::player_say( alias );
}

// ----------------------
// Zombie Vocals - SUMEET - Look into converting these to clientfields
//-----------------------
function BZM_AIVoxThink()
{
	self endon ( "death" );
	
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	self thread BZMAIVox_AmbientVocals();		
	self thread BZMAI_VoxHandlerThink();
	self thread BZMAIVox_Death();
}

function BZMAI_VoxHandlerThink()
{
	self endon("death");
	
	while(1)
	{
		self waittill("bhtn_action_notify", notify_string);
			
		if( ( isdefined( level.bzm_worldPaused ) && level.bzm_worldPaused ) ) 
			continue;
		
		if( self IsInScriptedState() )
			continue;
		
		switch( notify_string )
		{					
			case "death":
			case "behind":
			case "attack_melee":
			case "electrocute":
			case "close":
				level thread BZMAIVox_PlayVox( self, notify_string, true );
				break;
			case "teardown":
			case "taunt":
			case "ambient":
			case "sprint":
			case "crawler":
				level thread BZMAIVox_PlayVox( self, notify_string, false );
				break;
			default:
			{
				if ( IsDefined( level._BZMAIVox_SpecialType ) )
				{
					if( IsDefined( level._BZMAIVox_SpecialType[notify_string] ) )
					{
						level thread BZMAIVox_PlayVox( self, notify_string, false );
					}
				}
				break;
			}
		}
	}
}

function BZMAIVox_PlayVox( zombie, type, override )
{
    zombie endon( "death" ); 
    
    if( !IsDefined( zombie ) )
    	return;
    
    if( !IsDefined( zombie.voicePrefix ) )
    	return; 
    
    alias = "zmb_vocals_" + zombie.voicePrefix + "_" + type;
    
    if( sndIsNetworkSafe() )
    {
	    if( ( isdefined( override ) && override ) )
	    {
	    	if( type == "death" )
	   			zombie PlaySound( alias );
	    	else
	    		zombie PlaySoundOnTag( alias, "j_head" );
	    }
	    else if( !( isdefined( zombie.talking ) && zombie.talking ) )
	    {
	        zombie.talking = true;
	        zombie PlaySoundWithNotify( alias, "sounddone", "j_head" );
	        zombie waittill( "sounddone" );
	        zombie.talking = false;
	    }
    }
}

function BZMAIVox_AmbientVocals()
{
    self endon( "death" );
    
    wait(randomfloatrange(1,3));
    
    while(1)
    {
        type = "ambient";
        
        if( !IsDefined( self.zombie_move_speed ) )
        {
            wait(.5);
            continue;
        }
        
        switch(self.zombie_move_speed)
	    {
			case "walk":    type="ambient"; break;
			case "run":     type="sprint";  break;
			case "sprint":  type="sprint";  break;
		}
		
        if( ( isdefined( self.missingLegs ) && self.missingLegs ) )
		{
		    type = "crawler";
		}
		
		self notify( "bhtn_action_notify", type );
		
		wait(RandomFloatRange(1,4));
    }
}
function BZMAIVox_Death()
{
	self endon ( "disconnect" );
	
	self waittill ( "death", attacker, meansOfDeath );
	
	if ( isdefined( self ) )
	{	
		level thread BZMAIVox_PlayVox( self, "death", true );
	}
}

function networkSafeReset()
{
	while(1)
	{
		level._numBZMAIVox = 0;
		util::wait_network_frame();
	}
}

function sndIsNetworkSafe()
{
	if ( !IsDefined( level._numBZMAIVox ) )
	{
	 	level thread networkSafeReset();
	}

	if ( level._numBZMAIVox > 4 )
	{
	  	return false;
	}

	level._numBZMAIVox++;
	return true;
}

