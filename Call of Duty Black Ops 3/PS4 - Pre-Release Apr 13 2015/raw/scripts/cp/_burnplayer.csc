#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\util_shared;

#namespace burnplayer;

function initFlameFx()
{
//	level._effect["character_fire_death_torso"] 	= "_t6/env/fire/fx_fire_player_torso_mp";
//	level._effect["character_fire_death_sm"] 		= "_t6/env/fire/fx_fire_player_md_mp";
}


function corpseFlameFx(localClientNum)
{
	self util::waittill_dobj(localClientNum);

	if( !isdefined( level._effect["character_fire_death_torso"] ) )
		initFlameFx();
		
	tagArray = [];
	
	tagArray[tagArray.size] = "J_Wrist_RI"; 
	tagArray[tagArray.size] = "J_Wrist_LE"; 
	tagArray[tagArray.size] = "J_Elbow_LE"; 
	tagArray[tagArray.size] = "J_Elbow_RI"; 
	tagArray[tagArray.size] = "J_Knee_RI"; 
	tagArray[tagArray.size] = "J_Knee_LE"; 
	tagArray[tagArray.size] = "J_Ankle_RI"; 
	tagArray[tagArray.size] = "J_Ankle_LE"; 


	if( isdefined( level._effect["character_fire_death_sm"] ) )
	{
		for ( arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++ )
		{
			PlayFxOnTag( localClientNum, level._effect["character_fire_death_sm"], self, tagArray[arrayIndex] );
		}
	}
	
	PlayFxOnTag( localClientNum, level._effect["character_fire_death_torso"], self, "J_SpineLower" );
}