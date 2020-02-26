#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

weapon_box_callback(localClientNum, set, newEnt)
{
	println( "ZM >> weapon_box_callback - client scripts" );
	if(localClientNum != 0)
	{
		return;
	}
	
	if(set)
	{
		self thread weapon_floats_up();
	}
	else
	{
		self notify("end_float");
		
		cleanup_weapon_models();
	}
}

cleanup_weapon_models()
{
	if(IsDefined(self.weapon_models))
	{
		players = getlocalplayers();
		for( index = 0; index < players.size; index++)
		{
			if(IsDefined(self.weapon_models[index]))
			{
				self.weapon_models[index].dw Delete();
				self.weapon_models[index] Delete();
			}
		}
		self.weapon_models = undefined;
	}
}

weapon_is_dual_wield(name)
{
	switch(name)
	{
		case  "cz75dw_zm":
		case  "cz75dw_upgraded_zm":
		case  "m1911_upgraded_zm":
		case  "hs10_upgraded_zm":
		case  "pm63_upgraded_zm":
			return true;
		default:
			return false;
	}
}

weapon_floats_up()
{
	self endon("end_float");
	
	cleanup_weapon_models();

	self.weapon_models = [];

	number_cycles = 39;
	floatHeight = 64;

	rand = treasure_chest_ChooseRandomWeapon();
	modelname = GetWeaponModel( rand );
	
	players = getlocalplayers();
	for( i = 0; i < players.size; i ++)
	{
		self.weapon_models[i] = spawn(i, self.origin, "script_model"); 
		self.weapon_models[i].angles = self.angles+( 0, 180, 0 );
		self.weapon_models[i].dw = spawn(i, self.weapon_models[i].origin - ( 3, 3, 3 ), "script_model");
		self.weapon_models[i].dw.angles = self.weapon_models[i].angles;
		self.weapon_models[i].dw Hide();
	
		self.weapon_models[i] SetModel( modelname ); 
		self.weapon_models[i].dw SetModel(modelname);
		self.weapon_models[i] useweaponhidetags( rand );

		//move it up
		self.weapon_models[i] moveto( self.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 	
		self.weapon_models[i].dw MoveTo(self.origin + (0,0,floatHeight) - ( 3, 3, 3 ), 3, 2, 0.9);
	}
	
	for( i = 0; i < number_cycles; i++ )
	{

		if( i < 20 )
		{
			wait( 0.05 ); 
		}
		else if( i < 30 )
		{
			wait( 0.1 ); 
		}
		else if( i < 35 )
		{
			wait( 0.2 ); 
		}
		else if( i < 38 )
		{
			wait( 0.3 ); 
		}

		//debugstar(self.weapon_models[0].origin, 20, (0,1,0));

		rand = treasure_chest_ChooseRandomWeapon();
		modelname = GetWeaponModel( rand );
		
		players = getlocalplayers();
		for( index = 0; index < players.size; index++)
		{
			if(IsDefined(self.weapon_models[index]))
			{
				self.weapon_models[index] SetModel( modelname ); 
				self.weapon_models[index] useweaponhidetags( rand );
				
				if(weapon_is_dual_wield(rand))
				{
					self.weapon_models[index].dw SetModel(modelname);
					self.weapon_models[index].dw useweaponhidetags(rand);
					self.weapon_models[index].dw show();
				}
				else
				{
					self.weapon_models[index].dw Hide();
				}
			}
		}
	}

	cleanup_weapon_models();
}

is_weapon_included( weapon_name )
{
	if ( !IsDefined( level._included_weapons ) )
	{
		return false;
	}

	for ( i = 0; i < level._included_weapons.size; i++ )
	{
		if ( weapon_name == level._included_weapons[i] )
		{
			return true;
		}
	}

	return false;
}


include_weapon( weapon, display_in_box, func )
{
	if ( !IsDefined( level._included_weapons ) )
	{
		level._included_weapons = [];
	}

	level._included_weapons[level._included_weapons.size] = weapon;

	if ( !IsDefined( level._display_box_weapons ) )
	{
		level._display_box_weapons = [];
	}

	if ( !IsDefined( display_in_box ) )
	{
		display_in_box = true;
	}

	if ( !display_in_box )
	{
		return;
	}

	level._display_box_weapons[level._display_box_weapons.size] = weapon;
}

treasure_chest_ChooseRandomWeapon()
{
	if ( !IsDefined(level._display_box_weapons))
	{
		level._display_box_weapons = array( "python_zm", "g11_lps_zm", "famas_zm" );
	}
	
	return level._display_box_weapons[RandomInt( level._display_box_weapons.size )];
}