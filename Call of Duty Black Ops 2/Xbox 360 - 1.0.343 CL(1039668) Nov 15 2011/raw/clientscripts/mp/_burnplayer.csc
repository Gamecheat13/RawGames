#include clientscripts\mp\_utility;

initFlameFx()
{
	level._effect["character_fire_death_torso"] 	= loadfx("env/fire/fx_fire_player_torso_mp" );
	level._effect["character_fire_death_sm"] 		= loadfx("env/fire/fx_fire_player_md_mp");
}


corpseFlameFx(localClientNum)
{
	self waittill_dobj(localClientNum);

	if( !IsDefined( level._effect["character_fire_death_torso"] ) )
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


	if( IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		for ( arrayIndex = 0; arrayIndex < tagArray.size;  arrayIndex++ )
		{
			PlayFxOnTag( localClientNum, level._effect["character_fire_death_sm"], self, tagArray[arrayIndex] );
		}
	}
	
	PlayFxOnTag( localClientNum, level._effect["character_fire_death_torso"], self, "J_SpineLower" );
}