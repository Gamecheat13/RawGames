init()
{
	// bayonett fx
	level._effect["character_bayonet_blood_in"] 		= LoadFx( "impacts/fx_flesh_bayonet_impact" );
	level._effect["character_bayonet_blood_front"] 	= LoadFx( "impacts/fx_flesh_bayonet_fatal_fr" );
	level._effect["character_bayonet_blood_back"] 	= LoadFx( "impacts/fx_flesh_bayonet_fatal_bk" );
	level._effect["character_bayonet_blood_right"] 	= LoadFx( "impacts/fx_flesh_bayonet_fatal_rt" );
	level._effect["character_bayonet_blood_left"] 	= LoadFx( "impacts/fx_flesh_bayonet_fatal_lf" );
	
}

has_bayonet()
{	
	currentWeapon = self.weapon;
	if ( !IsDefined( currentWeapon ) )
		return false;
	
	return IsSubStr( currentWeapon, "_bayonet" );
}