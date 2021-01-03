    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                          	                                   	                                   	                                                    	                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
     

#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;


function autoexec main()
{
	// clientfield setup
	RegisterClientFields();
	
	//effects caching
	LoadEffects();
}

function RegisterClientFields()
{
	clientfield::register( "actor", "arch_human_fire_fx", 1, 2, "int", &actor_fire_fx_state, !true, !true );
}

function LoadEffects()
{
	//fire fx
	level._effect["fire_j_wrist_le_loop"]			= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_j_wrist_ri_loop"]			= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_j_elbow_le_rot_loop"]		= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_j_elbow_ri_rot_loop"]		= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_j_shoulder_le_rot_loop"]		= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["fire_j_shoulder_ri_rot_loop"]		= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["fire_j_neck_loop"] 				= "fire/fx_fire_ai_human_head_loop";
	level._effect["fire_j_hip_ri_loop"]				= "fire/fx_fire_ai_human_torso_loop";
	level._effect["fire_j_hip_le_loop"]				= "fire/fx_fire_ai_human_torso_loop";
	level._effect["fire_j_knee_le_loop"]				= "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["fire_j_knee_ri_loop"]				= "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["fire_j_head_loop"] 				= "fire/fx_fire_ai_human_head_loop";
	level._effect["fire_j_wrist_le_os"]				= "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_j_wrist_ri_os"]				= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_j_elbow_le_rot_os"]			= "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_j_elbow_ri_rot_os"]			= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_j_shoulder_le_rot_os"]		= "fire/fx_fire_ai_human_arm_left_os";
	level._effect["fire_j_shoulder_ri_rot_os"]		= "fire/fx_fire_ai_human_arm_right_os";
	level._effect["fire_j_neck_os"] 					= "fire/fx_fire_ai_human_head_os";
	level._effect["fire_j_hip_ri_os"]				= "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_j_hip_le_os"]				= "fire/fx_fire_ai_human_torso_os";
	level._effect["fire_j_knee_le_os"]				= "fire/fx_fire_ai_human_leg_left_os";
	level._effect["fire_j_knee_ri_os"]				= "fire/fx_fire_ai_human_leg_right_os";
	level._effect["fire_j_head_os"] 					= "fire/fx_fire_ai_human_head_os";
}

//------------------------------FIRE FX------------------------------

function private _burnTag(localClientNum, tag, postfix)
{
	if(isDefined(self))
	{
		fxname = "fire_"+tag+postfix;
		return PlayFXOnTag(localClientNum, level._effect[fxname], self, tag);
	}
}

function private _burnStage(localClientNum, tagArray, shouldWait )
{
	if(!isDefined(self))
		return;
		
	self endon("entityshutdown");
	
	tags = array::randomize(tagArray);
	
	for(i=1;i<tags.size;i++)//drop random one for variance.
	{
		self.activeFX[self.activeFX.size] = self _burnTag(localClientNum, tags[i],(shouldWait?"_loop":"_os") );
		if(shouldWait)
		{
			wait RandomFloatRange(0.1,.3);
		}
	}
	if(shouldWait)
	{
		wait RandomFloatRange(0,1);
	}
	if (  isDefined(self) )
		self notify("burn_stage_finished");
}

function private _burnBody(localClientNum)
{
	self endon("entityshutdown");
	
	stage1BurnTags 	= array("j_wrist_le","j_wrist_ri");
	stage2BurnTags	= array("j_elbow_le_rot","j_elbow_ri_rot");
	stage3BurnTags	= array("j_shoulder_le_rot","j_shoulder_ri_rot","j_neck");
	stage4BurnTags	= array("j_hip_ri","j_hip_le");
	stage5BurnTags	= array("j_head","j_knee_ri","j_knee_le");
	
	self.activeFX = [];
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage1BurnTags,true);
	self waittill("burn_stage_finished");
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage2BurnTags,true);
	self waittill("burn_stage_finished");
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage3BurnTags,true);
	self waittill("burn_stage_finished");
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage4BurnTags,true);
	self waittill("burn_stage_finished");
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage5BurnTags,true);
}

function private _burnCorpse(localClientNum, burningDuration)
{
	self endon("entityshutdown");
	
	stage1BurnTags 	= array("j_wrist_le","j_wrist_ri");
	stage2BurnTags	= array("j_elbow_le_rot","j_elbow_ri_rot");
	stage3BurnTags	= array("j_shoulder_le_rot","j_shoulder_ri_rot","j_neck");
	stage4BurnTags	= array("j_hip_ri","j_hip_le");
	stage5BurnTags	= array("j_head","j_knee_ri","j_knee_le");
	
	self.activeFX = [];
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage1BurnTags,true);
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage2BurnTags,true);
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage3BurnTags,true);
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage4BurnTags,true);
	self.activeFX[self.activeFX.size] = self thread _burnStage(localClientNum, stage5BurnTags,true);
	wait burningDuration;
	if(isDefined(self))
	{
		foreach(fx in self.activeFX)
		{
			StopFx(localClientNum,fx);
			wait RandomFloatRange(0.25,2);
		}
		if(isDefined(self))
			self.activeFX = [];
	}
}

function actor_fire_fx(localClientNum, value, burningDuration)
{
	switch(value)
	{
		case 0: //turn off burning
		if (isDefined(self.activeFX))
		{
			foreach(fx in self.activeFX)
			{
				StopFx(localClientNum,fx);
			}
		}
		self.activeFX = [];
		break;
		case 1:	//burning
			self thread _burnBody(localClientNum);
		break;
		case 2:
			self thread _burnCorpse(localClientNum, burningDuration);
		break;
	}
}

function actor_fire_fx_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self actor_fire_fx(localClientNum, newVal, 5);
}