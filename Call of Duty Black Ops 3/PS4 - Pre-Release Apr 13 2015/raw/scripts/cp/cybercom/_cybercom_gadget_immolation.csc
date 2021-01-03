    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	   


#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#precache( "client_fx", "fire/fx_fire_ai_human_arm_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_arm_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_hip_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_left_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_left_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_right_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_leg_right_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_torso_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_torso_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_waist_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_waist_os" );
#precache( "client_fx", "fire/fx_fire_ai_human_head_loop" );
#precache( "client_fx", "fire/fx_fire_ai_human_head_os" );


#namespace cybercom_immolate;


//todo
//this whole file needs to be moved into archetype_damage_effects.csc


function init()
{
	init_clientfields();
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	level._effect["robot_arm_left_os"]		= "fire/fx_fire_ai_human_arm_left_os";
	level._effect["robot_arm_right_os"]		= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["robot_hip_left_os"]		= "fire/fx_fire_ai_human_hip_left_os";
	level._effect["robot_hip_right_os"]		= "fire/fx_fire_ai_human_hip_right_os";
	level._effect["robot_knee_left_os"]		= "fire/fx_fire_ai_human_leg_left_os";
	level._effect["robot_knee_right_os"]	= "fire/fx_fire_ai_human_leg_right_os";
	level._effect["robot_torso_os"]			= "fire/fx_fire_ai_human_torso_os";
	level._effect["robot_waist_os"]			= "fire/fx_fire_ai_human_waist_os";
	level._effect["robot_head_os"] 			= "fire/fx_fire_ai_human_head_os";
	
	level._effect["robot_arm_left"]			= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["robot_arm_right"]		= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["robot_hip_left"]			= "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["robot_hip_right"]		= "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["robot_knee_left"]		= "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["robot_knee_right"]		= "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["robot_torso"]			= "fire/fx_fire_ai_human_torso_loop";
	level._effect["robot_waist"]			= "fire/fx_fire_ai_human_waist_loop";
	level._effect["robot_head"] 			= "fire/fx_fire_ai_human_head_loop";
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "actor", "immolation_state", 1, 2, "int", &actor_immolation_state, !true, !true );
}

//---------------------------------------------------------
function on_player_connect(localClientNum)
{	

}
function on_player_spawned(localClientNum)
{	

}

function killFxOnShutdown(note,localClientNum)
{
	self endon("killFxOnShutdown");
	self waittill(note);
	if (isDefined(self.activeFX))
	{
		foreach(fx in self.activeFX)
		{
			DeleteFX(localClientNum,fx);
		}
		self.activeFX = undefined;
	}
	self notify("killFxOnShutdown");
}

function actor_immolation_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if (newVal == 0 || newVal == oldVal )
		return;
		
	type = self.archetype;
	
	boneModifier = "";
	if ( type == "robot" )
	{
		boneModifier = "_rot";
	}
	self thread killFxOnShutdown("entityshutdown",localClientNum);
	
	switch(newVal)
	{
		case 0:	//burning
			if (isDefined(self.activeFX))
			{
				foreach(fx in self.activeFX)
				{
					StopFx(localClientNum,fx);
				}
			}
		break;
		case 1:	//burning
			self.activeFX = [];
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_left" ], 	self, "j_shoulder_le"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_left" ], 	self, "j_elbow_le"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_right" ], 	self, "j_shoulder_ri"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_right" ], 	self, "j_elbow_ri"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_hip_left" ], 	self, "j_hip_le" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_knee_left" ], 	self, "j_knee_le" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_hip_right" ], 	self, "j_hip_ri" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_knee_right" ], 	self, "j_knee_ri" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_head" ], 		self, "j_head" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_torso" ], 		self, "j_spine4" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_waist" ], 		self, "j_spinelower" );
		break;
		case 2: //turn off burning
			if (isDefined(self.activeFX))
			{
				foreach(fx in self.activeFX)
				{
					StopFx(localClientNum,fx);
				}
			}
			self.activeFX = [];
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_left_os" ], 	self, "j_shoulder_le"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_left_os" ], 	self, "j_elbow_le"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_right_os" ], 	self, "j_shoulder_ri"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_arm_right_os" ], 	self, "j_elbow_ri"+boneModifier );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_hip_left_os" ], 	self, "j_hip_le" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_knee_left_os" ], 	self, "j_knee_le" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_hip_right_os" ], 	self, "j_hip_ri" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_knee_right_os" ], 	self, "j_knee_ri" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_head_os" ], 		self, "j_head" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_torso_os" ], 		self, "j_spine4" );
			self.activeFX[self.activeFX.size] = PlayFXOnTag( localClientNum, level._effect[ type+"_waist_os" ], 		self, "j_spinelower" );
		break;
		case 3: //turn off burning
		if (isDefined(self.activeFX))
		{
			foreach(fx in self.activeFX)
			{
				StopFx(localClientNum,fx);
			}
		}
		self.activeFX = [];
		break;
	}
}

/*

function corpseFlameFx(localClientNum)
{
	self util::waittill_dobj(localClientNum);
		
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
*/