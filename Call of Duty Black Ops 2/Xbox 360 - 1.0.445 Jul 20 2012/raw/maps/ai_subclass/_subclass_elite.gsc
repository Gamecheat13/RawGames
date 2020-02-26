#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\utility; 
#include animscripts\ai_subclass\anims_table_elite; 

subclass_elite()
{
	if( self.type != "human" )
		return;
	
	if( self animscripts\utility::AIHasOnlyPistol() )
		return;
	
	enable_elite();	
}

enable_elite()
{
	if( self.subclass != "elite" )
		self.subclass = "elite";
	
	self.a.disableWoundedSet = true;
	self.a.useRifleAnimsForSmg = true;
		
	self.elite = true;
	self animscripts\ai_subclass\anims_table_elite::setup_elite_anim_array();
}

disable_elite() // keeps the guy elite but removes the anims. We need this so that CQB or anything like that will not mess up
{
	Assert( IS_TRUE(self.elite) );
	//Assert( self.subclass == "elite" );
	
	self.subclass = "regular";
	self animscripts\ai_subclass\anims_table_elite::reset_elite_anim_array();
}