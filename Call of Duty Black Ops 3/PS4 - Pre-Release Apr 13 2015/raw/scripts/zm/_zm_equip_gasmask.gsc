#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;

#precache( "string", "ZOMBIE_EQUIP_GASMASK_PICKUP_HINT_STRING" );

#namespace zm_equip_gasmask;

function autoexec __init__sytem__() {     system::register("zm_equip_gasmask",&__init__,undefined,undefined);    }

function __init__()
{
	level.weaponZMEquipGasMask = GetWeapon( "equip_gasmask" );
	level.weaponZMEquipGasMaskLower = GetWeapon( "lower_equip_gasmask" );
	name = level.weaponZMEquipElectricTrap.name;

	zm_equipment::register( name, &"ZOMBIE_EQUIP_GASMASK_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_GASMASK_HOWTO", undefined, "gasmask",&gasmask_activation_watcher_thread );

	level.deathcard_spawn_func =&remove_gasmask_on_player_bleedout;

	callback::on_connect( &gasmask_on_player_connect );
	
	clientfield::register( "player", "toggle_gasmask_overlay", 1, 1, "int" );
}


function gasmask_on_player_connect()
{
}

function gasmask_removed_watcher_thread()
{
	self notify("only_one_gasmask_removed_thread");
	self endon("only_one_gasmask_removed_thread");
	self endon("disconnect");
	
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipGasMask );

	self waittill( notify_strings.taken );
	
	//  Do switch to normal player model/head here.
	
	if(isdefined(level.zombiemode_gasmask_reset_player_model))
	{
		ent_num = self.characterindex;// GetEntityNumber();
		
		if(isdefined(self.zm_random_char))
		{
			ent_num = self.zm_random_char;
		}
				
		self [[level.zombiemode_gasmask_reset_player_model]](ent_num);
	}
	
	if(isdefined(level.zombiemode_gasmask_reset_player_viewmodel))
	{
		ent_num = self.characterindex;// GetEntityNumber();
		
		if(isdefined(self.zm_random_char))
		{
			ent_num = self.zm_random_char;
		}
				
		self [[level.zombiemode_gasmask_reset_player_viewmodel]](ent_num);
	}
	
	self clientfield::set( "toggle_gasmask_overlay", 0 );
}

/*
	level.zombiemode_gasmask_reset_player_model =&gasmask_reset_player_model;
	level.zombiemode_gasmask_reset_player_viewmodel =&gasmask_reset_player_set_viewmodel;
	level.zombiemode_gasmask_set_player_model =&gasmask_set_player_model;
	level.zombiemode_gasmask_set_player_viewmodel =&gasmask_set_player_viewmodel;
*/

function gasmask_activation_watcher_thread()
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipGasMask );

	self endon("zombified");
	self endon("disconnect");
	self endon( notify_strings.taken );
	
	self thread gasmask_removed_watcher_thread();
	
	self thread remove_gasmask_on_game_over();

	if(isdefined(level.zombiemode_gasmask_set_player_model))
	{
		ent_num = self.characterindex;// GetEntityNumber();
		
		if(isdefined(self.zm_random_char))
		{
			ent_num = self.zm_random_char;
		}
		
		self [[level.zombiemode_gasmask_set_player_model]](ent_num);
	}
	
	if(isdefined(level.zombiemode_gasmask_set_player_viewmodel))
	{
		ent_num = self.characterindex;// GetEntityNumber();
		
		if(isdefined(self.zm_random_char))
		{
			ent_num = self.zm_random_char;
		}
				
		self [[level.zombiemode_gasmask_set_player_viewmodel]](ent_num);
	}	
	
	while(1)
	{
		self util::waittill_either( notify_strings.activate, notify_strings.deactivate );
		
		if(self zm_equipment::is_active(level.weaponZMEquipGasMask))
		{
			self zm_utility::increment_is_drinking();

			// clear the actionslot during the anim to prevent the player breaking the anims by spamming the dpad 
			self SetActionSlot( 1, "" );

			// Switch to hazmat suited player model, with gasmask here.
			if ( isdefined( level.zombiemode_gasmask_set_player_model ) )
			{
				ent_num = self.characterindex;// GetEntityNumber();
				
				if(isdefined(self.zm_random_char))
				{
					ent_num = self.zm_random_char;
				}
								
				self [[level.zombiemode_gasmask_change_player_headmodel]]( ent_num, true );
			}

			//wait(2.1);
			util::clientNotify( "gmsk2" );
			self waittill( "weapon_change_complete" );

			// Start overlay on client.
			
			//util::clientNotify( "_gasmask_on_pristine" );
			//self util::clientNotify("gmon");//util::setClientSysState("levelNotify", "gmon", self);			
			self clientfield::set( "toggle_gasmask_overlay", 1 );
		}
		else
		{
			self zm_utility::increment_is_drinking();

			// clear the actionslot during the anim to prevent the player breaking the anims by spamming the dpad 
			self SetActionSlot( 1, "" );

			// Switch to hazmat suited player model, without gasmask here.
			if ( isdefined( level.zombiemode_gasmask_set_player_model ) )
			{
				ent_num = self.characterindex;// GetEntityNumber();
				
				if(isdefined(self.zm_random_char))
				{
					ent_num = self.zm_random_char;
				}
				
				self [[level.zombiemode_gasmask_change_player_headmodel]]( ent_num, false );
			}

			self TakeWeapon(level.weaponZMEquipGasMask);
			self GiveWeapon(level.weaponZMEquipGasMaskLower);
			self SwitchToWeapon(level.weaponZMEquipGasMaskLower);
			{wait(.05);};
			self clientfield::set( "toggle_gasmask_overlay", 0 );
			self waittill( "weapon_change_complete" );

			self TakeWeapon(level.weaponZMEquipGasMaskLower);
			self GiveWeapon(level.weaponZMEquipGasMask);
		}

		if ( !self laststand::player_is_in_laststand() )
		{
			if( self zm_utility::is_multiple_drinking() )
			{
				self zm_utility::decrement_is_drinking();
				// now re-set the cleared the actionslot during the anim to prevent the player breaking the anims by spamming the dpad 
				self setactionslot( 1, "weapon", level.weaponZMEquipGasMask );
				self notify("equipment_select_response_done");
				continue;
			}
			else if ( isdefined( self.prev_weapon_before_equipment_change ) && self HasWeapon( self.prev_weapon_before_equipment_change ) )
			{
				if ( self.prev_weapon_before_equipment_change != self GetCurrentWeapon() )
				{
					self SwitchToWeapon( self.prev_weapon_before_equipment_change );

					self waittill( "weapon_change_complete" );
				}
			}
			else
			{
				primaryWeapons = self GetWeaponsListPrimaries();
				if ( isdefined( primaryWeapons ) && primaryWeapons.size > 0 )
				{
					if ( primaryWeapons[0] != self GetCurrentWeapon() )
					{
						self SwitchToWeapon( primaryWeapons[0] );

						self waittill( "weapon_change_complete" );
					}
				}
				else
				{
					// need to switch away from the mask somehow
					self SwitchToWeapon( zm_utility::get_player_melee_weapon() );
				}
			}
		}

		// now re-set the cleared the actionslot during the anim to prevent the player breaking the anims by spamming the dpad 
		self setactionslot( 1, "weapon", level.weaponZMEquipGasMask );

		if ( !self laststand::player_is_in_laststand() && !( isdefined( self.intermission ) && self.intermission ) )
		{
			self zm_utility::decrement_is_drinking();
		}

		self notify("equipment_select_response_done");
	}
}

function remove_gasmask_on_player_bleedout()
{
	self clientfield::set( "toggle_gasmask_overlay", 1 );
	util::wait_network_frame();
	util::wait_network_frame();
	self clientfield::set( "toggle_gasmask_overlay", 0 );
}

function remove_gasmask_on_game_over()
{
	notify_strings = zm_equipment::get_notify_strings( level.weaponZMEquipGasMask );

	self endon( notify_strings.taken );
	level waittill("pre_end_game");
	
	self clientfield::set( "toggle_gasmask_overlay", 0 );
}

/#
function gasmask_debug_print( msg, color )
{

	if ( !GetDvarInt( "scr_gasmask_debug" ) )
	{
		return;
	}

	if ( !isdefined( color ) )
	{
		color = (1, 1, 1);
	}

	Print3d(self.origin + (0,0,60), msg, color, 1, 1, 40); // 10 server frames is 1 second

}
#/
