#include common_scripts\utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include animscripts\anims;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

// (Note that animations called right are used with left corner nodes, and vice versa.)

main()
{
	self.hideYawOffset = 180; // pillar nodes just face straight

	scriptName = "cover_pillar";
	usingPistol = usingPistol();
	
	if( usingPistol )
	{
		if( ISNODEDONTRIGHT(self.node) )
		{
			self.hideYawOffset = -90;
			scriptName = "cover_right";	
		}
		else
		{
			self.hideYawOffset = 90;
			scriptName = "cover_left";
		}
	}
	
    self trackScriptState( "Cover Pillar Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize(scriptName);

	if( ISNODEDONTRIGHT(self.node) )
	{
		if( usingPistol )
			animscripts\cover_corner::corner_think( "left", -90 );
		else
			animscripts\cover_corner::corner_think( "left", 180 );
	}
	else
	{
		if( usingPistol )
			animscripts\cover_corner::corner_think( "right", 90 );
		else	
			animscripts\cover_corner::corner_think( "right", 180 );
	}
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}