#using_animtree( "generic_human" );

main()
{
	self.a.movement = "stop";
	
	turret = self GetTurret();
	
	turret_left = false;
	if ( IsSubStr( turret.model, "_left" ) )
		turret_left = true;
	
	if ( turret_left )
	{
		self.primaryTurretAnim = %ziplineGunnerLeft_aim;
	}
	else
	{
		self.primaryTurretAnim = %ziplineGunnerRight_aim;
	}
	
	self ClearAnim( %body, 0.2 );
	
	self setTurretAnim( self.primaryTurretAnim );
	self setAnimKnobRestart( self.primaryTurretAnim, 1, 0.2, 1 );
}