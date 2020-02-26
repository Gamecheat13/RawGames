#include maps\_utility;
#include common_scripts\utility;
main()
{
	// Get all destructible vehicles
	vehArray = getentarray ("dest_veh","targetname");
	array_thread(vehArray, ::bond_d_veh_setup);
}

#using_animtree( "vehicles" );
bond_d_veh_setup()
{
	// Any setup we might need to do in the future for different types of vehicles

	self.anims = [];

	// set anim tree
	self UseAnimTree( #animtree );
	
	if ( issubstr( tolower( self.model ), "v_electric_car" ) )
	{
		precacheshellshock ("exploder");
		
		self.anims["bl"] = %v_hatchback_bl_pop;
		self.anims["br"] = %v_hatchback_br_pop;
		self.anims["fl"] = %v_hatchback_fl_pop;
		self.anims["fr"] = %v_hatchback_fr_pop;
		self.anims["explode"] = %v_hatchback_explode;
		
		self thread bond_d_veh_elec_death();
	}
	else if( issubstr( tolower( self.model ), "v_sedan_" ) )
	{
		precacheshellshock ("exploder");
		
		self.anims["bl"] = %v_sedan_bl_pop;
		self.anims["br"] = %v_sedan_br_pop;
		self.anims["fl"] = %v_sedan_fl_pop;
		self.anims["fr"] = %v_sedan_fr_pop;
		self.anims["explode"] = %v_sedan_explode;
		
		self thread bond_d_veh_death();
	}
	else if( issubstr( tolower( self.model ), "v_suv_" ) )
	{
		precacheshellshock ("exploder");
		
		self.anims["bl"] = %v_suv_bl_pop;
		self.anims["br"] = %v_suv_br_pop;
		self.anims["fl"] = %v_suv_fl_pop;
		self.anims["fr"] = %v_suv_fr_pop;
		self.anims["explode"] = %v_suv_explode;
		
		self thread bond_d_veh_death();
	}
	else if( issubstr( tolower( self.model ), "v_hatchback_" ) )
	{
		precacheshellshock ("exploder");
		
		self.anims["bl"] = %v_hatchback_bl_pop;
		self.anims["br"] = %v_hatchback_br_pop;
		self.anims["fl"] = %v_hatchback_fl_pop;
		self.anims["fr"] = %v_hatchback_fr_pop;
		self.anims["explode"] = %v_hatchback_explode;
		
		self thread bond_d_veh_death();
	}
	else if( issubstr( tolower( self.model ), "v_van_" ) )
	{
		precacheshellshock ("exploder");
		
		self.anims["bl"] = %v_auto_bl_pop;
		self.anims["br"] = %v_auto_br_pop;
		self.anims["fl"] = %v_auto_fl_pop;
		self.anims["fr"] = %v_auto_fr_pop;
		self.anims["explode"] = %v_auto_explode;
		
		self thread bond_d_veh_death();
	}
	self thread bond_d_veh_flat_tire();
}

#using_animtree( "vehicles" );
bond_d_veh_death( iRadius, iMaxDmg, iMinDmg, sTag, vOffset, iWarnTime )
{
	
	if( IsDefined( self ) )
	{
		if( !IsDefined(self.target) )
		{
			//iprintlnbold ( "Warning: Destructible vehicle at origin " + self.origin + " is not targeting a collision script_brushmodel. THIS WILL BECOME FATAL!!" );
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is not targeting a collision script_brushmodel." );
		}
		if( !IsDefined(	GetEntArray( self.target, "targetname" ) ) )
		{
			//iprintlnbold ( "Warning: Destructible vehicle at origin " + self.origin + " is targeting a collision script_brushmodel, but target is not found. THIS WILL BECOME FATAL!!" );
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is targeting a collision script_brushmodel, but target is not found." );
		}
		
		// set anim tree
		self UseAnimTree( #animtree );
		
		// set defaults
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
			vOffset = (0,0,32);
		}
		if( !IsDefined( iWarnTime ) )
		{
			iWarnTime = 5;
		}
		
		
		//Handle damage
		self bond_d_veh_filter_dmg();
		
		badplace_cylinder("", (iWarnTime + 1), self.origin, iRadius, 128, "axis");

		//Handle burn
		if ( isalive(self) )
		{
			self waittill_notify_or_timeout( "death", iWarnTime);
		}
		
		vPos = self LocalToWorldCoords( vOffset );

		// play anim
		self.tire_l_frnt = false;
		self.tire_r_frnt = false;
		self.tire_l_back = false;
		self.tire_r_back = false;
		//wait( 0.05 );
		wait( randomfloatrange(0.05,0.1) );
		self SetAnimKnob( self.anims["explode"] , 1.0, 0.2, 1.0 );
		
		//Delete linked collision/cover	
		self bond_d_veh_delete_col();
		
		//Shellshock
		start = self.origin;
		end = level.player.origin;
		dist = distance( start, end );
		distpercent = (iRadius - dist) / iRadius;
		if (distpercent > 1 )
		{
			distpercent = 1;
		}
		if (distpercent < 0 )
		{
			distpercent = 0;
		}
		seconds = (3 * distpercent);
		if ( seconds >= (3 * 0.25))
		{
			level.player shellshock( "exploder", seconds );
		}
		
		//kill the prop
		//self dodamage(2000, (self.origin[0] + 1, self.origin[1] + 1, self.origin[2] + 1 ) );
		
		// do large damage radius
		RadiusDamage( self.origin, iRadius, iMaxDmg, iMinDmg, self, "MOD_EXPLOSIVE" ); //concuss
		
		// physics explosion
		//wait 0.05;
		PhysicsExplosionSphere( vPos, iRadius, iRadiusInn, 25);
		
		// earthquake
		Earthquake( 0.25, 3, self.origin, 1024 );
		
	}
	
}

bond_d_veh_elec_death( iRadius, iMaxDmg, iMinDmg, sTag, vOffset, iWarnTime, vOffset_phys )
{
	if( IsDefined( self ) )
	{
		if( !IsDefined(self.target) )
		{
			//iprintlnbold ( "Warning: Destructible vehicle at origin " + self.origin + " is not targeting a collision script_brushmodel. THIS WILL BECOME FATAL!!" );
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is not targeting a collision script_brushmodel." );
		}
		if( !IsDefined(	GetEntArray( self.target, "targetname" ) ) )
		{
			//iprintlnbold ( "Warning: Destructible vehicle at origin " + self.origin + " is targeting a collision script_brushmodel, but target is not found. THIS WILL BECOME FATAL!!" );
			AssertMsg( "Destructible vehicle at origin " + self.origin + " is targeting a collision script_brushmodel, but target is not found." );
		}
		
		// set anim tree
		self UseAnimTree( #animtree );
		
		// set defaults
		if( !IsDefined( iRadius ) )
		{
			iRadius = 150;
		}
		iRadiusInn = iRadius/2;
		if( !IsDefined( iMaxDmg ) )
		{
			iMaxDmg = 80;
		}
		if( !IsDefined( iMinDmg ) )
		{
			iMinDmg = 40;
		}
		if( !IsDefined( vOffset ) )
		{
			vOffset = (64,0,64);
		}
		if( !IsDefined( iWarnTime ) )
		{
			iWarnTime = 3;
		}
		
		self.health = 250;
		
		
		//Handle damage
		self bond_d_veh_filter_dmg();
		
		badplace_cylinder("", (iWarnTime + 1), self LocalToWorldCoords( vOffset ) - (0,0,64), iRadius, 128, "axis");

		//Handle burn
		if ( isalive(self) )
		{
			self waittill_notify_or_timeout( "death", iWarnTime);
		}
		
		vPos = self LocalToWorldCoords( vOffset );

		
		/*
		// play anim
		self.tire_l_frnt = false;
		self.tire_r_frnt = false;
		self.tire_l_back = false;
		self.tire_r_back = false;
		/*
		//wait( 0.05 );
		wait( randomfloatrange(0.05,0.1) );
		self SetAnimKnob( self.anims["explode"] , 1.0, 0.2, 1.0 );
		*/
		
		//Delete linked collision/cover	
		self bond_d_veh_delete_col();
		
		self dodamage( 250, vPos );

		wait(0.1);

		//Shellshock
		start = vPos;
		end = level.player.origin;
		dist = distance( start, end );
		distpercent = (iRadius - dist) / iRadius;
		if (distpercent > 1 )
		{
			distpercent = 1;
		}
		if (distpercent < 0 )
		{
			distpercent = 0;
		}
		seconds = (3 * distpercent);
		if ( seconds >= (3 * 0.25))
		{
			level.player shellshock( "flashbang", seconds );
		}
		
		// do large damage radius
		level.player radiusdamage( vPos, iRadius, iMaxDmg, iMinDmg, self, "MOD_COLLATERAL", "WEAPON_NOT_SPECIFIED", false, 0, 0, 0, false ); // + (0,0,16)
		
		// physics explosion
		wait( randomfloatrange(0.05,0.1) );
		PhysicsExplosionSphere( vPos, iRadius, iRadiusInn, 22);
		
		// earthquake
		//Earthquake( 0.25, 3, self.origin, 1024 );
	}
}

bond_d_veh_filter_dmg()
{
	self endon( "death" );

	starthealth = self.health;

	while( self.health >= (starthealth * 0.5))
	{
		prevHealth = self.health;
		//print3d (self.origin+(0,0,128), prevHealth, (0.5,1,0.5), 1, 1, 100);

		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		//print3d (self.origin+(0,0,92), sTagName, (0.5,1,0.5), 1, 1, 200);

		
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
			//print3d (self.origin+(0,0,82), "FILTERED", (0.5,1,0.5), 1, 1, 100);
			self.health = prevHealth;
		}
		
	}
}


#using_animtree( "vehicles" );
bond_d_veh_flat_tire()
{

	if( IsDefined( self ) )
	{

		// set anim tree
		self UseAnimTree( #animtree );

		// setup tires to undamaged flag
		self.tire_l_frnt = true;
		self.tire_r_frnt = true;
		self.tire_l_back = true;
		self.tire_r_back = true;

		// wait for damage
		while( isalive( self ) )
		{

			self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

			// filter out melee and explosions
			if ( issubstr( tolower( iType ), "melee" ) || issubstr( tolower( iType ), "explosive" ) )
			{
				continue;
			}

			// continue if no damage is done
			if( !IsDefined( iDamage ) || ( iDamage <= 0 ) )
			{
				continue;
			}

			// identify part damaged & animate
			switch( sTagName )
			{
				case "tag_left_wheel_01_jnt":
					if( self.tire_l_frnt )
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "LEFT FRONT DAMAGED", (0, 1, 0), 1, 1, 90 );
							}
						*/

							// update tire to damaged & animate
							self.tire_l_frnt = false;
							self SetAnim( self.anims["fl"] , 1.0, 1.0, 1.0 );
					}
					else
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "LEFT FRONT NO EFFECT", (0, 1, 0), 1, 1, 90 );
							}
						*/
					}
					break;

				case "tag_left_wheel_02_jnt":
					if( self.tire_l_back )
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "LEFT BACK DAMAGED", (0, 1, 0), 1, 1, 90 );
							}
						*/

							// update tire to damaged & animate
							self.tire_l_back = false;
							self SetAnim( self.anims["bl"] , 1.0, 1.0, 1.0 );
					}
					else
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "LEFT BACK NO EFFECT", (0, 1, 0), 1, 1, 90 );
							}
						*/
					}
					break;

				case "tag_right_wheel_01_jnt":
					if( self.tire_r_frnt )
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "RIGHT FRONT DAMAGED", (0, 1, 0), 1, 1, 90 );
							}
						*/

							// update tire to damaged & animate
							self.tire_r_frnt = false;
							self SetAnim( self.anims["fr"] , 1.0, 1.0, 1.0 );
					}
					else
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "RIGHT FRONT NO EFFECT", (0, 1, 0), 1, 1, 90 );
							}
						*/
					}
					break;

				case "tag_right_wheel_02_jnt":
					if( self.tire_r_back )
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "RIGHT BACK DAMAGED", (0, 1, 0), 1, 1, 90 );
							}
						*/

							// update tire to damaged & animate
							self.tire_r_back = false;
							self SetAnim( self.anims["br"] , 1.0, 1.0, 1.0 );
					}
					else
					{
						/*
							if( GetDVarInt( "secr_camera_debug" ) == 1 )
							{	
								Print3d( self.origin + (0, 0, 64), "RIGHT BACK NO EFFECT", (0, 1, 0), 1, 1, 90 );
							}
						*/
					}
					break;

				default:
					/*
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), sTagName, (0, 1, 0), 1, 1, 90 );
						}
					*/
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
