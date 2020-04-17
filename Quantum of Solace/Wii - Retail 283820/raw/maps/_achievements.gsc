























#include maps\_utility;
#include common_scripts\utility;



main()
{
	
	
	level phonebook_init();

	
	
	
	level power_weapon_init();

	

}


ach_cam_d_watch()
{
	

	
	IncrementAchievementStat( "camera_disabled" );

	
	if( GetAchievementStat( "camera_disabled" ) == 15 )
	{
		
		GiveAchievement( "Accumulation_DisableCameras" );
	}
}



ach_lock_hack_watch()
{
	

	
	IncrementAchievementStat( "lock_hack" );

	
	
	if( GetAchievementStat( "lock_hack" ) == 15 )
	{
		
		GiveAchievement( "Accumulation_HackLocks" );
	}
}




		
		


ach_headshot_watch()
{
	
	level.player endon( "death" );


	sAttacker = undefined;
	sType = undefined;
	sTagName = undefined;
	

	
	if( !isdefined( self.health ) )
	{
					return;
	}

	
	while( self.health > 0 )
	{
					
					self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
	}


	
	if( sAttacker == level.player )
	{
					
					if( sType == "MOD_RIFLE_BULLET" || sType == "MOD_PISTOL_BULLET" )
					{
									
									if( sTagName == "head" )
									{
													
													IncrementAchievementStat( "headshot" );
									}
					}
	}

	
	
	
	if( GetAchievementStat( "headshot" ) == 1 )
	{
		
		GiveAchievement( "FirstTime_headshot" );
	}

	
	

	
	if( GetAchievementStat( "headshot" ) == 50 )
	{
		
		GiveAchievement( "Accumulation_headshots" );
	}
}



ach_quick_kill_watch()
{
	
	level.player endon( "death" );

	sAttacker = undefined;
	sType = undefined;
	
	

	
	if( !isdefined( self.health ) )
	{
					return;
	}

	
	while( self.health > 0 )
	{
					
					self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
	}


	
	if( sAttacker == level.player )
	{
		
		if( sType == "MOD_MELEE" )
		{
			 
			 IncrementAchievementStat( "quick_kill" );
		}
	}

	
	if( GetAchievementStat( "quick_kill" ) == 50 )
	{
		
		GiveAchievement( "Accumulation_Subdue" );
	}

}

phonebook_init()
{
	
	

				
				
				level.phonebook = [];
				
				int_whites_estate = 5;
				int_siena_rooftops = 5;
				int_operahouse = 3;
				int_sink_hole = 1;
				int_shantytown = 3;
				int_constructionsite = 0;
				int_sciencecenter_a = 5;
				int_sciencecenter_b = 7;
				int_airport = 5;
				int_montenegrotrain = 5;
				int_casino = 4;
				int_casino_poison = 0;
				int_barge = 6;
				int_gettler = 4;
				int_eco_hotel = 5;
				int_haines_estate = 2;
				
				temp_struct = undefined;
				int_phone_amount = 0;

				


				
				
				
				for( i=1; i<int_whites_estate; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "whites_estate";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_siena_rooftops; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "siena_rooftops";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_operahouse; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "operahouse";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_sink_hole; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "sink_hole";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				for( i=1; i<int_shantytown; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "shantytown";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_sciencecenter_a; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "sciencecenter_a";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_sciencecenter_b; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "sciencecenter_b";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_airport; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "airport";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_montenegrotrain; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "montenegrotrain";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_casino; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "casino";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_barge; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "barge";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_gettler; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "gettler";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_eco_hotel; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "eco_hotel";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				for( i=1; i<int_haines_estate; i++ )
				{
								
								temp_struct = spawnstruct();
								temp_struct.id = "haines_estate";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 63 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 63 )
								{
												
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								
								int_phone_amount++;

								
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								
								temp_struct = undefined;
				}
				
				
				
				
				
				
				
				
				
				
				
				
				

				
				

				
				
				
				
				
				
				level thread phone_clear_found();

}



phone_set_collectible( str_level, int_script_phonenum )
{
	
	
	
	
	assertex( isdefined( str_level ), "level string missing phone_set_collectible" );
	assertex( isdefined( int_script_phonenum ), "script int missing from phone_set_collectible" );

	
	for( i=0; i<level.phonebook.size; i++ )
	{
		
		if( level.phonebook[i].id == str_level )
		{
			
			if( level.phonebook[i].script_int == int_script_phonenum )
			{
				if( level.phonebook[i].picked_up == 0 )
				{
					
					if( i <= 31 )
					{
						
						setcollectiblefound( "cell_phone_a", i );

						
						
					}
					else if( i >= 32 )
					{
						
						setcollectiblefound( "cell_phone_b", i - 32 );

						
						
					}
				}

				
				return;
			}
		}
	}

	
	
	for( i=0; i<level.phonebook.size; i++ )
	{
		
		if( level.phonebook[i].picked_up == 0 )
		{
			
			return;
		}
	}

	
	GiveAchievement( "Collector_CellPhone3" );
	

}



phone_clear_found()
{
	
	

				
				
				level_models = GetEntArray( "script_model", "classname" );
				phones = [];

				
				
				for( i=0; i<level_models.size; i++ )
				{
								
								if( level_models[i].model == "p_msc_phone_pickup")
								{
												
												phones = maps\_utility::array_add( phones, level_models[i] );
								}
								
								else if( level_models[i].model != "p_msc_phone_pickup" )
								{

												
												continue;
								}
				}

	

		
		

		
		for( i=0; i<level.phonebook.size; i++ )
		{	
			
			if( level.phonebook[i].id == level.script )
			{
				
				if( level.phonebook[i].picked_up == 1 )
				{
					
					

					
					for( j=0; j<phones.size; j++ )
					{
						
						
						if( IsDefined( phones[j].script_int ) && phones[j].script_int == level.phonebook[i].script_int )
						{
							
							

							if ( IsDefined( phones[j].script_image ) )
							{
								data_collection_add( phones[j].script_int, "image", phones[j].script_image, level.strings[phones[j].name], level.strings[phones[j].script_string], true );

																												
							}
							else if ( IsDefined(phones[j].script_soundalias ) )
							{
								data_collection_add( phones[j].script_int, "audio", phones[j].script_soundalias, level.strings[phones[j].name], level.strings[phones[j].script_string], true );
								
							}
							else
							{
								data_collection_add( phones[j].script_int, "text", level.strings[phones[j].script_string], level.strings[phones[j].name], "", true );
								
							}
							
							self notify( "stop_ring" );
							
							phones[j] delete();
						}
						else
						{
							
							iprintlnbold( "This level is missing a phone!" );
							
							continue;
						}
					}
					
					break;
				}
			}
		}

	

}





















power_weapon_init()
{
				

				
				
				level.power_weapons = [];

				
				
				
				
				level.power_weapons[0] = spawnstruct();
				level.power_weapons[0].id = "whites_estate";
				level.power_weapons[0].picked_up = iscollectiblefound( "power_weapon", 0 );
				
				
				
				level.power_weapons[1] = spawnstruct();
				level.power_weapons[1].id = "siena_rooftops";
				level.power_weapons[1].picked_up = iscollectiblefound( "power_weapon", 1 );
				
				
				
				level.power_weapons[2] = spawnstruct();
				level.power_weapons[2].id = "sink_hole";
				level.power_weapons[2].picked_up = iscollectiblefound( "power_weapon", 2 );
				
				
				
				level.power_weapons[3] = spawnstruct();
				level.power_weapons[3].id = "operahouse";
				level.power_weapons[3].picked_up = iscollectiblefound( "power_weapon", 3 );
				
				
				
				level.power_weapons[4] = spawnstruct();
				level.power_weapons[4].id = "shantytown";
				level.power_weapons[4].picked_up = iscollectiblefound( "power_weapon", 4 );
				
				
				
				level.power_weapons[5] = spawnstruct();
				level.power_weapons[5].id = "sciencecenter_a";
				level.power_weapons[5].picked_up = iscollectiblefound( "power_weapon", 5 );
				
				
				
				level.power_weapons[6] = spawnstruct();
				level.power_weapons[6].id = "sciencecenter_b";
				level.power_weapons[6].picked_up = iscollectiblefound( "power_weapon", 6 );
				
				
				
				level.power_weapons[7] = spawnstruct();
				level.power_weapons[7].id = "airport";
				level.power_weapons[7].picked_up = iscollectiblefound( "power_weapon", 7 );
				
				
				
				level.power_weapons[8] = spawnstruct();
				level.power_weapons[8].id = "montenegrotrain";
				level.power_weapons[8].picked_up = iscollectiblefound( "power_weapon", 8 );
				
				
				
				level.power_weapons[9] = spawnstruct();
				level.power_weapons[9].id = "montenegrotrain";
				level.power_weapons[9].picked_up = iscollectiblefound( "power_weapon", 9 );
				
				
				
				level.power_weapons[10] = spawnstruct();
				level.power_weapons[10].id = "gettler";
				level.power_weapons[10].picked_up = iscollectiblefound( "power_weapon", 10 );
				
				
				
				level.power_weapons[11] = spawnstruct();
				level.power_weapons[11].id = "eco_hotel";
				level.power_weapons[11].picked_up = iscollectiblefound( "power_weapon", 11 );



}



power_weapon_set_collectible( str_level )
{
	

	

	
	assertex( isdefined( str_level ), "level is not set for power_weapon_set_collectible" );
	assertex( isdefined( level.power_weapons ), "level.power_weapons is not defined" );

	
	for( i=0; i<level.power_weapons.size; i++ )
	{
		
		if( level.power_weapons[i].id == str_level )
		{
			
			if( level.power_weapons[i].picked_up == 0 )
			{
				
				setcollectiblefound( "power_weapon", i );
			}
		}
	}

	
	
	
	for( i=0; i<level.power_weapons.size; i++ )
	{
		
		if( level.power_weapons[i].picked_up == 0 )
		{
			
			return;
		}
	}

	
	GiveAchievement( "Collector_PowerWeapons" );

}
