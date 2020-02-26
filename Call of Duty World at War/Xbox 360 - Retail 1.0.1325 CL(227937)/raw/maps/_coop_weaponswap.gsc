
init()
{
	precachemodel( "char_usa_raider_gear_flametank" ); 
	level._swap_flametank_model = "char_usa_raider_gear_flametank"; 
}

flamethrower_swap()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 
	
	while( 1 )
	{
		weapons = self GetWeaponsList(); 
		
		self.has_flame_thrower = false; 
		for( i = 0; i < weapons.size; i++ )
		{
			if( weapons[i] == "m2_flamethrower" || weapons[i] == "flamethrower" || weapons[i] == "m2_flamethrower_wet" )
			{
				self.has_flame_thrower = true; 
			}
		}
		
		
		if( self.has_flame_thrower )
		{
			if( !isdefined( self.flamethrower_attached ) || !self.flamethrower_attached )
			{
				self attach( level._swap_flametank_model, "j_spine4" ); 
				self.flamethrower_attached = true; 
			}
		}
		else if( !self.has_flame_thrower )
		{
			if( isdefined( self.flamethrower_attached ) && self.flamethrower_attached )
			{
				self detach( level._swap_flametank_model, "j_spine4" ); 
				self.flamethrower_attached = false; 
			}
		}
		wait( 0.2 ); 
	}
}