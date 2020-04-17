///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Bond QoS Achievements
// Utility script to watch for achievements in Bond QoS
// Authors: Mark Maestas, Zach Vulaj, Walter Williams
// 
// Global Achievement notifies:
// Disable camera = ACH_CAM_DISABLED
// Lock Pick = ACH_LOCK_PASS
// Cell phone pickup = ACH_CELL_PICKUP
// headshot = MOD_HEAD_SHOT
// Quick Kill = MOD_QK_NORMAL
//
// Global Achievement Stats:
// Disable camera = "camera_disabled"
// Lock Pick = "lock_hack"
// Cell phone pickup = "cell_phone_a" or "cell_phone_b", depending on which group the instance of phone is in
// headshot = "headshot"
// Quick Kill = "quick_kill"
// Power weapon = "power_weapon"  // 06-07-08 **Currently no way to watch for this!**
// Cam Feed Box = "FEED_BOX_ACCESSED" // 06-07-08 **Currently no way to watch for this!**
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;
#include common_scripts\utility;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main function
main()
{
				// sets up the table for _achievements of all the phones in the game
				// this is a single shot function with no waits
				level phonebook_init();

				// arranges the table for _achievements of all power weapons
				// in the game
				// this is a single shot function with no waits
				level power_weapon_init();

				//creates a list of all locks in the game and which have been picked before
				level lock_hacks_init();

				//creates a list of all camera boxes in the game and which has been destroyed before
				level cameras_init();


}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Stat increase
// These functions wait for the corresponding notifies and then increments the stat
// after increment it checks the new value for achievement requirements
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function watches the security cameras for disable
ach_cam_d_watch(str_level, int_script_phonenum)
{
	if(!IsDefined(str_level) || !IsDefined(int_script_phonenum))
	{
		iPrintLnBold("Camera box is not in the global list, bug this to design");
		return;
	}

	//run through the camera book to see if that camera was already disabled
	set_as_found(str_level, int_script_phonenum, "camera_disabled", level.camera_book);

	// accumulation:disable camera
	if( number_found(level.camera_book) == 10 )
	{
		// award achievement
		GiveAchievement( "Accumulation_DisableCameras" );
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Lock Hack function
// function fires off from the _doors::keypad_unlock()
ach_lock_hack_watch(str_level, int_script_phonenum)
{
	if(!IsDefined(str_level) || !IsDefined(int_script_phonenum))
	{
		iPrintLnBold("Lock is not in the global list, bug this to design");
		return;
	}


	// run through the lock book to see if that lock was already hacked
	set_as_found(str_level, int_script_phonenum, "lock_hack", level.lock_book);

	// check to see if the condition has been met
	// accumulation:lock_hacks
	if( number_found(level.lock_book) == 9 )
	{
		// award achievement 
		GiveAchievement( "Accumulation_HackLocks" );
	}
}

// function watches for headshots
ach_headshot_watch()
{
				// endon
				level.player endon( "death" );

				// define objects for function
				// defineing this outside the while loop to make sure I can use it
				// for the whole function
				iDamage = undefined;
				//vDirection = undefined;
				//vPoint = undefined;
				sModelName = undefined;
				sAttacker = undefined;
				sType = undefined;
				sTagName = undefined;
				//sAttachTag = undefined;

				// double check self
				if( !isdefined( self.health ) )
				{
								return;
				}

				// while loop to constantly check
				//while( self.health > 0 )
				//{
								// wait for the guy to take damage
								self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName);
				//}

				// iprintlnbolds
				// iprintlnbold( " iDamage is:" + iDamage );
				// println(" iDamage is:" + iDamage  );
				// iprintlnbold( " sAttacker is:" + sAttacker.targetname );
				// println(" sAttacker is:" + sAttacker.targetname  );
				// iprintlnbold( " vDirection is:" + vDirection );
				// println( " vDirection is:" + vDirection  );
				// iprintlnbold( " vPoint is:" + vPoint );
				// println( " vPoint is:" + vPoint  );
				// iprintlnbold( " sType is:" + sType );
				// println( " sType is:" + sType  );
				// iprintlnbold( " sModelName is:" + sModelName );
				// println(" sModelName is:" + sModelName  );
				// iprintlnbold( " sAttachTag is:" + sAttachTag );
				// println(" sAttachTag is:" + sAttachTag );
				// iprintlnbold( " sTagName is:" + sTagName );
				// println(" sTagName is:" + sTagName );

				// check to make sure the player caused the damage
				if( sAttacker == level.player )
				{
					// check to see what kind of damage it is
					if( sType == "MOD_RIFLE_BULLET" || sType == "MOD_PISTOL_BULLET" || sType == "MOD_HEAD_SHOT" )
					{
						
						wait(.05);
						if( !IsAlive(self) )//iDamage >= self.maxHealth )
						{
							IncrementAchievementStat("headshot");
						}
						// check to see if the tag was head
								//				if( sTagName == "head" )
								//				{
								//								// increment the stat
								//								IncrementAchievementStat( "headshot" );
								//				}
					}
				}

				// check the stat value against the 
				// achievement requirement
				// first time:headshot
				if( GetAchievementStat( "headshot" ) == 1 )
				{
								// award achievement
								GiveAchievement( "FirstTime_headshot" );
				}

				// frame wait
				// wait( 0.05 );

				// accumulation:headshot
				if( GetAchievementStat( "headshot" ) == 50 )
				{
								// award achievement 
								GiveAchievement( "Accumulation_headshots" );
				}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function controls quick_kill
ach_quick_kill_watch()
{
				// endon
				level.player endon( "death" );

				// define objects for function
				// defineing this outside the while loop to make sure I can use it
				// for the whole function
				// iDamage = undefined;
				// vDirection = undefined;
				// vPoint = undefined;
				// sModelName = undefined;
				sAttacker = undefined;
				sType = undefined;
				// sTagName = undefined;
				// sAttachTag = undefined;

				// double check self
				if( !isdefined( self.health ) )
				{
								return;
				}

				// while loop to constantly check
				while( self.health > 0 )
				{
								// wait for the guy to take damage
								self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
				}

				// iprintlnbolds
				//iprintlnbold( " iDamage is:" + iDamage );
				//println(" iDamage is:" + iDamage  );
				//iprintlnbold( " sAttacker is:" + sAttacker.targetname );
				//println(" sAttacker is:" + sAttacker.targetname  );
				//iprintlnbold( " vDirection is:" + vDirection );
				//println( " vDirection is:" + vDirection  );
				//iprintlnbold( " vPoint is:" + vPoint );
				//println( " vPoint is:" + vPoint  );
				//iprintlnbold( " sType is:" + sType );
				//println( " sType is:" + sType  );
				//iprintlnbold( " sModelName is:" + sModelName );
				//println(" sModelName is:" + sModelName  );
				//iprintlnbold( " sAttachTag is:" + sAttachTag );
				//println(" sAttachTag is:" + sAttachTag );
				//iprintlnbold( " sTagName is:" + sTagName );
				//println(" sTagName is:" + sTagName );

				// check to make sure the player caused the damage
			//	if( sAttacker == level.player )
			//	{
								// check to see what kind of damage it is
								if( sType == "MOD_MELEE" )
								{
												 // increment the stat
												 IncrementAchievementStat( "quick_kill" );
								}
		//		}

				// accumulation:take downs
				if( GetAchievementStat( "quick_kill" ) == 50 )
				{
								// award achievement 
								GiveAchievement( "Accumulation_Subdue" );
				}

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phone Functions
// These functions sets up the array that watches the phones,
// sets up phones that should show and the phones that should not,
// awards the player for locating all the phones in the game,
// sets the information in Bond's phone to show if the player has found the phone linked ot the info
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
phonebook_init()
{
				// endon
				// single shot function

				// objects to define for the function
				// phone array
				level.phonebook = [];
				
				// int_level_phones 55 total
				int_whites_estate = 5;
				int_siena_rooftops = 4;
				int_operahouse = 3;
				int_sink_hole = 1;
				int_shantytown = 3;
				int_constructionsite = 0;
				int_sciencecenter_a = 5;
				int_sciencecenter_b = 6;
				int_airport = 5;
				int_montenegrotrain = 5;
				int_casino = 3;
				int_casino_poison = 0;
				int_barge = 6;
				int_gettler = 4;
				int_eco_hotel = 5;
				
				temp_struct = undefined;
				int_phone_amount = 0;

				// create a struct for each spot in the array


				///////////////////////////////////////////////////////////////////////
				// White's Estate "whites_estate"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_whites_estate; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "whites_estate";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Siena Rooftops "siena_rooftops"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_siena_rooftops; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "siena_rooftops";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
				
				///////////////////////////////////////////////////////////////////////
				// Opera House "operahouse"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_operahouse; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "operahouse";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Sink Hole "sink_hole"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_sink_hole; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "sink_hole";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Shantytown "shantytown"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_shantytown; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "shantytown";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Science Center Ext "sciencecenter_a"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_sciencecenter_a; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "sciencecenter_a";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
		
				///////////////////////////////////////////////////////////////////////
				// Science Center Int "sciencecenter_b"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_sciencecenter_b; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "sciencecenter_b";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Airport "airport"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_airport; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "airport";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
		
				///////////////////////////////////////////////////////////////////////
				// Montenegro Train "montenegrotrain"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_montenegrotrain; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "montenegrotrain";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Casino "casino"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_casino; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "casino";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Barge "barge"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_barge; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "barge";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Gettler "gettler"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_gettler; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "gettler";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// Eco Hotel "eco_hotel"
				///////////////////////////////////////////////////////////////////////
				for( i=0; i<int_eco_hotel; i++ )
				{
								// setup the phone struct
								temp_struct = spawnstruct();
								temp_struct.id = "eco_hotel";
								temp_struct.script_int = i;
								if( int_phone_amount <= 31 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_a", int_phone_amount );
								}
								else if( int_phone_amount > 31 && int_phone_amount <= 55 )
								{
												temp_struct.picked_up = iscollectiblefound( "cell_phone_b", int_phone_amount - 32 );
								}
								else if( int_phone_amount > 55 )
								{
												// debug text
												iprintlnbold( "phones are greater than 64! not enough room in index!" );
								}

								// increase phone_amount
								int_phone_amount++;

								// add this struct to the phonebook array
								level.phonebook = add_to_array( level.phonebook, temp_struct );

								// undefine temp_struct
								temp_struct = undefined;
				}
			
				///////////////////////////////////////////////////////////////////////
				// END PHONE STRUCT SETUP
				///////////////////////////////////////////////////////////////////////

				// wait for the phonebook to be setup and more of the level to load
				// wait( 0.05 );

				///////////////////////////////////////////////////////////////////////
				// Phone_clear_found()
				// Function cleans up any phones that have already been found by
				// the player in the level. Not threaded so it can fix everything 
				// quickly
				///////////////////////////////////////////////////////////////////////
				level phone_clear_found();

}

lock_hacks_init()
{
	//a listing of every lock hack in the game
	level.lock_book = [];

	level.lock_book = add_to_array(level.lock_book, create_array_element("whites_estate", 0, "lock_hack", level.lock_book) );

	level.lock_book = add_to_array(level.lock_book, create_array_element("sciencecenter_a", 0, "lock_hack", level.lock_book) );

	level.lock_book = add_to_array(level.lock_book, create_array_element("sciencecenter_b", 0, "lock_hack", level.lock_book) );
	level.lock_book = add_to_array(level.lock_book, create_array_element("sciencecenter_b", 1, "lock_hack", level.lock_book) );

	level.lock_book = add_to_array(level.lock_book, create_array_element("airport", 0, "lock_hack", level.lock_book) );
	level.lock_book = add_to_array(level.lock_book, create_array_element("airport", 1, "lock_hack", level.lock_book) );
	level.lock_book = add_to_array(level.lock_book, create_array_element("airport", 2, "lock_hack", level.lock_book) );

	level.lock_book = add_to_array(level.lock_book, create_array_element("casino", 0, "lock_hack", level.lock_book) );

	level.lock_book = add_to_array(level.lock_book, create_array_element("eco_hotel", 0, "lock_hack", level.lock_book) );

	//grabs all the models for the lock hack in the level and assigns it a script_int index for saving purposes
	level_models = GetEntArray( "script_model", "classname" );
	index = 0;
	for( i=0; i<level_models.size; i++ )
	{
		if( level_models[i].model == "p_msc_security_keypad")
		{
			if( !IsDefined(level_models[i].script_int) )
			{
				level_models[i].script_int = index;
				index++;
			}
		}
	}
	
}

cameras_init()
{
	//a listing of every camera box in the game
	level.camera_book = [];

	level.camera_book = add_to_array(level.camera_book, create_array_element("operahouse", 0, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("operahouse", 1, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("operahouse", 2, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("operahouse", 3, "camera_disabled", level.camera_book) );

	level.camera_book = add_to_array(level.camera_book, create_array_element("sciencecenter_a", 0, "camera_disabled", level.camera_book) );

	level.camera_book = add_to_array(level.camera_book, create_array_element("sciencecenter_b", 0, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("sciencecenter_b", 1, "camera_disabled", level.camera_book) );

	level.camera_book = add_to_array(level.camera_book, create_array_element("airport", 0, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("airport", 1, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("airport", 2, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("airport", 3, "camera_disabled", level.camera_book) );

	level.camera_book = add_to_array(level.camera_book, create_array_element("barge", 0, "camera_disabled", level.camera_book) );
	level.camera_book = add_to_array(level.camera_book, create_array_element("barge", 1, "camera_disabled", level.camera_book) );

	//grabs all the models for the camera in the level and assigns it a script_int index for saving purposes
	level_models = GetEntArray( "script_model", "classname" );
	index = 0;
	for( i=0; i<level_models.size; i++ )
	{
		if( level_models[i].model == "p_msc_cctv_box")
		{
			if( !IsDefined(level_models[i].script_int) )
			{
				level_models[i].script_int = index;
				index++;
			}
		}
	}
}

//creates an array element for a save book
create_array_element(level_name, level_index, saved_var, collect_book)
{
	temp_struct = spawnstruct();
	temp_struct.id = level_name;
	temp_struct.script_int = level_index;
	temp_struct.picked_up = iscollectiblefound( saved_var, collect_book.size);
	return temp_struct;
}

//looks at the appropriate save book and finds the entry specified, sets it to picked up if it hasn't been mark it
set_as_found(level_name, level_index, saved_var, collect_book)
{
	for( i = 0; i < collect_book.size; i++)
	{
		if( collect_book[i].id == level_name )
		{
			if( collect_book[i].script_int == level_index )
			{
				if( collect_book[i].picked_up == 0)
				{
					//set the bit of the variable
					setcollectiblefound( saved_var , i );
					collect_book[i].picked_up = 1;
				}
			}
		}
	}
}

//looks through a save book and finds the total number of data picked up
number_found(collect_book)
{
	count = 0;
	for(i = 0; i < collect_book.size; i++)
	{
		if(collect_book[i].picked_up)
		{
			count++;
		}
	}
	return count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function waits for a phone to be picked up then sets the collectible for that phone
phone_set_collectible( str_level, int_script_phonenum )
{
				// endon
				// single shot function
				
				// double check the items passed in
				assertex( isdefined( str_level ), "level string missing phone_set_collectible" );
				assertex( isdefined( int_script_phonenum ), "script int missing from phone_set_collectible" );

				// look through the array for the right level id
				for( i=0; i<level.phonebook.size; i++ )
				{
								// check to see if the array spot struct id matches the str_level passed in
								if( level.phonebook[i].id == str_level )
								{
												// now check int_script_phonenum against the script_int
												if( level.phonebook[i].script_int == int_script_phonenum )
												{
																if( level.phonebook[i].picked_up == 0 )
																{
																				//mark the entry in the save book as picked up
																				level.phonebook[i].picked_up = 1;

																				// should have the correct phone now
																				if( i <= 31 )
																				{
																								// set the collectible
																								setcollectiblefound( "cell_phone_a", i );
																				}
																				else if( i >= 32 )
																				{
																								// set the collectible
																								setcollectiblefound( "cell_phone_b", i - 32 );
																				}
																}
												}
								}
				}

				// verify that 30 phones have been found
				// collector: cellphone2 1/2 PHONES
				phonecount = 0;
				for(i = 0; i < level.phonebook.size; i++)
				{
					// check to see if the picked_up in each spot is found
					if( level.phonebook[i].picked_up == 1 )
					{
						phonecount++;
					}
					if(phonecount >= 30)
					{
						giveachievement( "Collector_CellPhone2" );
					}
				}

				// verify the count of the phone stat
				// collector: cellphone3 3/3 ALL
				for( i=0; i<level.phonebook.size; i++ )
				{
								// check to see if the picked_up in each spot is found
								if( level.phonebook[i].picked_up == 0 )
								{
												// stop the function cause the player has not found each phone
												return;
								}
				}

				// award achievement 
				GiveAchievement( "Collector_CellPhone3" );
				

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function clears the phones that have been found for the level
phone_clear_found()
{
				// objects to be defined for this function
				// phones in level
				level_models = GetEntArray( "script_model", "classname" );
				phones = [];

				// clean out all the models that aren't the phone
				// loop through the array
				for( i=0; i<level_models.size; i++ )
				{
								// check the model of the array spot
								if( level_models[i].model == "p_msc_phone_pickup")
								{
												// add to the phone array
												phones = maps\_utility::array_add( phones, level_models[i] );
								}
								// check to see if the model is not the right type
								else if( level_models[i].model != "p_msc_phone_pickup" )
								{

												// go to the next spot
												continue;
								}
				}

				// level.phonebook should already be defined
				// double check
				assertex( isdefined( level.phonebook ), "level.phonebook not defined" );
				assertex( isdefined( phones ), "phones not defined for clearing" );

				// step through all the phones in the array
				for( i=0; i<level.phonebook.size; i++ )
				{	
					// check the array for the level.script to match level.phonebook[i].id
					if( level.phonebook[i].id == level.script || ( level.phonebook[i].id == "siena_rooftops" && level.script == "siena" ) )
					{
						// loop through the phones in the level
						for( j=0; j<phones.size; j++ )
						{
							// check to see if the phones[i].script int matches the table 
							// level.phonebook[i].script_int
							if( IsDefined( phones[j].script_int ) && (phones[j].script_int == level.phonebook[i].script_int) )
							{	
								// check to see if this phone has been found already
								if( level.phonebook[i].picked_up == 1 )
								{
									// need to turn this phone off
									// quick and dirty, just trigger it
									phone_offset = phones[j].script_int + 1;
									if ( IsDefined( phones[j].script_image ) )
									{
										data_collection_add( phone_offset, "image", phones[j].script_image, level.strings[phones[j].name], level.strings[phones[j].script_string], true );
									}
									else if ( IsDefined(phones[j].script_soundalias ) )
									{
										data_collection_add( phone_offset, "audio", phones[j].script_soundalias, level.strings[phones[j].name], level.strings[phones[j].script_string], true );
									}
									else
									{
										data_collection_add( phone_offset, "text", level.strings[phones[j].script_string], level.strings[phones[j].name], "", true );
									}
								
									// stop the cell_phone_ring
									self notify( "stop_ring" );

									// delete the phone
									phones[j] delete();
								}
							}
						}
					}
				}

				// turn back on the phone updated notifications with func from scrowe

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Power Weapon Functions
// Functions control registering when the player has found a power weapon
// Also checks the levels that have power weapons to see if the player has
// found them all
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function builds the table for the power weapons
// Levels with power weapons
// Whites Estate = HutchinsonA3
// Siena = LTSKM
// Sink Hole = DAD
// Opera House = LTD-22
// Shanty = 8CAT
// Science Center A = DAD
// Science Center B = Calico 22
// Airport = DAD
// Train = LTSKM
// Barge = LTD-22
// Gettler = LTSKM
// Eco Hotel = DAD
power_weapon_init()
{
				// endon

				// objects to define for this function
				// level array
				level.power_weapons = [];

				// create a struct in each array spot
				///////////////////////////////////////////////////////////////////////
				// Whites Estate = HutchinsonA3
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[0] = spawnstruct();
				level.power_weapons[0].id = "whites_estate";
				level.power_weapons[0].picked_up = iscollectiblefound( "power_weapon", 0 );
				///////////////////////////////////////////////////////////////////////
				// Siena = LTSKM
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[1] = spawnstruct();
				level.power_weapons[1].id = "siena_rooftops";
				level.power_weapons[1].picked_up = iscollectiblefound( "power_weapon", 1 );
				///////////////////////////////////////////////////////////////////////
				// Sink Hole = DAD
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[2] = spawnstruct();
				level.power_weapons[2].id = "sink_hole";
				level.power_weapons[2].picked_up = iscollectiblefound( "power_weapon", 2 );
				///////////////////////////////////////////////////////////////////////
				// Opera House = LTD-22
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[3] = spawnstruct();
				level.power_weapons[3].id = "operahouse";
				level.power_weapons[3].picked_up = iscollectiblefound( "power_weapon", 3 );
				///////////////////////////////////////////////////////////////////////
				// Shanty town = 8CAT
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[4] = spawnstruct();
				level.power_weapons[4].id = "shantytown";
				level.power_weapons[4].picked_up = iscollectiblefound( "power_weapon", 4 );
				///////////////////////////////////////////////////////////////////////
				// Science Center A = DAD
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[5] = spawnstruct();
				level.power_weapons[5].id = "sciencecenter_a";
				level.power_weapons[5].picked_up = iscollectiblefound( "power_weapon", 5 );
				///////////////////////////////////////////////////////////////////////
				// Science Center B = Calico 22
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[6] = spawnstruct();
				level.power_weapons[6].id = "sciencecenter_b";
				level.power_weapons[6].picked_up = iscollectiblefound( "power_weapon", 6 );
				///////////////////////////////////////////////////////////////////////
				// Airport = DAD
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[7] = spawnstruct();
				level.power_weapons[7].id = "airport";
				level.power_weapons[7].picked_up = iscollectiblefound( "power_weapon", 7 );
				///////////////////////////////////////////////////////////////////////
				// Train = LTSKM
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[8] = spawnstruct();
				level.power_weapons[8].id = "montenegrotrain";
				level.power_weapons[8].picked_up = iscollectiblefound( "power_weapon", 8 );
				///////////////////////////////////////////////////////////////////////
				// Barge = LTD-22
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[9] = spawnstruct();
				level.power_weapons[9].id = "montenegrotrain";
				level.power_weapons[9].picked_up = iscollectiblefound( "power_weapon", 9 );
				///////////////////////////////////////////////////////////////////////
				// Gettler = LTSKM 
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[10] = spawnstruct();
				level.power_weapons[10].id = "gettler";
				level.power_weapons[10].picked_up = iscollectiblefound( "power_weapon", 10 );
				///////////////////////////////////////////////////////////////////////
				// Eco Hotel = DAD  
				///////////////////////////////////////////////////////////////////////
				level.power_weapons[11] = spawnstruct();
				level.power_weapons[11].id = "eco_hotel";
				level.power_weapons[11].picked_up = iscollectiblefound( "power_weapon", 11 );



}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// function runs when a player picks up the power weapon
power_weapon_set_collectible( str_level )
{
				// endon

				// objects to define for this function

				// double check passed in variables
				assertex( isdefined( str_level ), "level is not set for power_weapon_set_collectible" );
				assertex( isdefined( level.power_weapons ), "level.power_weapons is not defined" );

				// search through the array 
				for( i=0; i<level.power_weapons.size; i++ )
				{
								// search for the array spot.level that matches the str_level
								if( level.power_weapons[i].id == str_level )
								{
												// make sure the power weapon hasn't already be found
												if( level.power_weapons[i].picked_up == 0 )
												{
																// set the index spot to found for the weapon
																setcollectiblefound( "power_weapon", i );
																//set the value to true for the check for all found
																level.power_weapons[i].picked_up = 1;
												}
								}
				}

				// check to see if the 
				// verify the count of the power weapons found
				// collector: cellphone3 3/3 ALL
				for( i=0; i<level.power_weapons.size; i++ )
				{
								// check to see if the picked_up in each spot is found
								if( level.power_weapons[i].picked_up == 0 )
								{
												// stop the function cause the player has not found each phone
												return;
								}
				}

				// award achievement 
				GiveAchievement( "Collector_PowerWeapons" );

}