#include maps\_utility;
#include common_scripts\utility;
main()
{
	
	vehArray = getentarray ("dest_veh","targetname");
	array_thread(vehArray, ::bond_d_veh_setup);
}

bond_d_veh_setup()
{
	
	
	self thread bond_d_veh_death();
	
}

#using_animtree( "vehicles" );
bond_d_veh_death( iRadius, iMaxDmg, iMinDmg, sTag, vOffset, iWarnTime )
{
	
	if( IsDefined( self ) )
	{
		if( !IsDefined(self.target) )
		{
			
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is not targeting a collision script_brushmodel." );
		}
		if( !IsDefined(	GetEntArray( self.target, "targetname" ) ) )
		{
			
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is targeting a collision script_brushmodel, but target is not found." );
		}
		
		
		self UseAnimTree( #animtree );
		
		
		if( !IsDefined( iRadius ) )
		{
			iRadius = 300;
		}
		iRadiusInn = iRadius/2;
		if( !IsDefined( iMaxDmg ) )
		{
			iMaxDmg = 2048;
		}
		if( !IsDefined( iMinDmg ) )
		{
			iMinDmg = 40;
		}
		if( !IsDefined( vOffset ) )
		{
			vOffset = (0,0,42);
		}
		if( !IsDefined( iWarnTime ) )
		{
			iWarnTime = 5;
		}
		
		vPos = self LocalToWorldCoords( vOffset );
		
		
		self bond_d_veh_filter_dmg();
		
		
		if ( isalive(self) )
		{
			self waittill_notify_or_timeout( "death", iWarnTime);
		}
		
		
		self.tire_l_frnt = false;
		self.tire_r_frnt = false;
		self.tire_l_back = false;
		self.tire_r_back = false;
		
		wait( randomfloatrange(0.05,0.1) );
		self SetAnimKnob( %v_auto_explode, 1.0, 0.2, 1.0 );
		
		
		self bond_d_veh_delete_col();
		
		
		RadiusDamage( vPos, iRadius, iMaxDmg, iMinDmg, level.player, "MOD_EXPLOSIVE" );
		
		
		
		
		PhysicsExplosionSphere( vPos, iRadius, iRadiusInn, 25);
		
		
		Earthquake( 0.25, 3, self.origin, 1024 );
		
	}
	
}

bond_d_veh_filter_dmg()
{
	self endon( "death" );

	starthealth = self.health;

	while( self.health >= (starthealth * 0.5))
	{
		prevHealth = self.health;
		

		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		

		
		if( sTagName == "tag_light_l_front" || 
			sTagName == "tag_light_r_front" || 
			sTagName == "tag_light_l_back" || 
			sTagName == "tag_light_r_back" || 
			sTagName == "tag_left_wheel_01_jnt" || 
			sTagName == "tag_left_wheel_02_jnt" ||
			sTagName == "tag_right_wheel_01_jnt" ||
			sTagName == "tag_right_wheel_02_jnt" ||
			sTagName == "tag_window_l_front" ||
			sTagName == "tag_window_l_back" ||
			sTagName == "tag_window_r_front" ||
			sTagName == "tag_window_r_back" ||
			sTagName == "tag_winshield_front" ||
			sTagName == "tag_winshield_back" )
		{
			
			self.health = prevHealth;
		}
		
	}
}


#using_animtree( "vehicles" );
bond_d_veh_flat_tire()
{

	if( IsDefined( self ) )
	{

		
		self UseAnimTree( #animtree );

		
		self.tire_l_frnt = true;
		self.tire_r_frnt = true;
		self.tire_l_back = true;
		self.tire_r_back = true;

		
		while( isalive( self ) )
		{

			self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

			
			if ( issubstr( tolower( iType ), "melee" ) || issubstr( tolower( iType ), "explosive" ) )
			{
				continue;
			}

			
			if( !IsDefined( iDamage ) || ( iDamage <= 0 ) )
			{
				continue;
			}

			
			switch( sTagName )
			{
				case "tag_left_wheel_01_jnt":
					if( self.tire_l_frnt )
					{
						

							
							self.tire_l_frnt = false;
							self SetAnim( %v_auto_fl_pop, 1.0, 1.0, 1.0 );
					}
					else
					{
						
					}
					break;

				case "tag_left_wheel_02_jnt":
					if( self.tire_l_back )
					{
						

							
							self.tire_l_back = false;
							self SetAnim( %v_auto_bl_pop, 1.0, 1.0, 1.0 );
					}
					else
					{
						
					}
					break;

				case "tag_right_wheel_01_jnt":
					if( self.tire_r_frnt )
					{
						

							
							self.tire_r_frnt = false;
							self SetAnim( %v_auto_fr_pop, 1.0, 1.0, 1.0 );
					}
					else
					{
						
					}
					break;

				case "tag_right_wheel_02_jnt":
					if( self.tire_r_back )
					{
						

							
							self.tire_r_back = false;
							self SetAnim( %v_auto_br_pop, 1.0, 1.0, 1.0 );
					}
					else
					{
						
					}
					break;

				default:
					
					break;
			}
		}
	}

}

bond_d_veh_delete_col()
{
	entaClip = GetEntArray( self.target, "targetname" );
	for( i = 0; i < entaClip.size; i++ )
	{
		entaClip[i] Delete();
	}
}
