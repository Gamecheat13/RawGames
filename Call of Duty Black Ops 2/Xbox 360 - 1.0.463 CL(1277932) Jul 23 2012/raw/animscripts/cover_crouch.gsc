#include animscripts\Combat_utility;    
#include animscripts\Utility;
#include common_scripts\Utility;

#using_animtree ("generic_human");    

main()
{	
	self endon("killanimscript");

//	if (weaponIsGasWeapon( self.weapon ))
//	{
//		self animscripts\stop::main();
//		return;
//	}
	
	[[ self.exception[ "cover_crouch" ] ]]();
	
    self trackScriptState( "Cover Crouch Main", "code" );
    animscripts\utility::initialize( "cover_crouch" );

	self animscripts\cover_wall::cover_wall_think( "crouch" );
}

end_script()
{
	animscripts\cover_behavior::end_script();
}