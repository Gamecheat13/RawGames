#include animscripts\Combat_utility;    
#include animscripts\Utility;
#include common_scripts\Utility;
#using_animtree ("generic_human");    

main()
{	
	self endon("killanimscript");
	
	if (weaponIsGasWeapon( self.weapon ))
	{
		self animscripts\stop::main();
		return;
	}
	
	[[ self.exception[ "cover_stand" ] ]]();
	
    self trackScriptState( "Cover Stand Main", "code" );
    animscripts\utility::initialize( "cover_stand" );

	self thread animscripts\utility::idleLookatBehavior(160, true);
	self animscripts\cover_wall::cover_wall_think( "stand" );
}

end_script()
{
	animscripts\cover_behavior::end_script();
}