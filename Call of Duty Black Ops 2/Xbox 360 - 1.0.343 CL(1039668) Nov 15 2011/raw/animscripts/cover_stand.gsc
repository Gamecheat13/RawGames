#include animscripts\Combat_utility;    
#include animscripts\Utility;
#include common_scripts\Utility;
#using_animtree ("generic_human");    

main()
{	
//	assert( !usingSidearm() );

	self endon("killanimscript");
	
	if (self usingGasWeapon())
	{
		self animscripts\stop::main();
		return;
	}
	
	
//	[[ self.exception[ "cover_stand" ] ]]();
	
    self trackScriptState( "Cover Stand Main", "code" );
    animscripts\utility::initialize( "cover_stand" );

	self thread animscripts\utility::idleLookatBehavior(160, true);


	self animscripts\cover_wall::cover_wall_think( "stand" );
}

end_script()
{
	// AI_TODO - HACK - AI coming out of the cover_stand should always be standing.
	// coverstand_reloadA animation puts AI into crouch pose that it should not.
	self.a.pose = "stand";
	animscripts\cover_behavior::end_script();
}