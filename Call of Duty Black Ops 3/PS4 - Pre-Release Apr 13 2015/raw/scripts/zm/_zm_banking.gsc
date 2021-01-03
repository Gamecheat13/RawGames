#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

                                                                                                                               

#namespace zm_banking;

function autoexec __init__sytem__() {     system::register("zm_banking",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_connect( &onPlayerConnect_bank_deposit_box );

	if (!IsDefined(level.ta_vaultfee))
	{
		level.ta_vaultfee = 100;
	}
	
	if (!IsDefined(level.ta_tellerfee))
	{
		level.ta_tellerfee = 100;	
	}
}

function main()
{
	if (!IsDefined(level.banking_map))
		level.banking_map = level.script;
	level thread bank_teller_init();
	level thread bank_deposit_box();
}

//=============================================================================
// BANK TELLER

function bank_teller_init() //allows players to share $$ with other teammates
{
	
	level.bank_teller_dmg_trig = getent("bank_teller_tazer_trig","targetname");
	if ( IsDefined(level.bank_teller_dmg_trig) )
	{
		level.bank_teller_transfer_trig = getent(level.bank_teller_dmg_trig.target,"targetname");
		level.bank_teller_powerup_spot = struct::get(level.bank_teller_transfer_trig.target,"targetname");
		
		level thread bank_teller_logic();
		
		//turn off the $$ trig
		level.bank_teller_transfer_trig.origin = level.bank_teller_transfer_trig.origin + (-25,0,0);
		level.bank_teller_transfer_trig TriggerEnable( false );
		
		level.bank_teller_transfer_trig SetHintString(&"ZOMBIE_TELLER_GIVE_MONEY",level.ta_tellerfee);
		
		//glint FX
		//playfx(level._effect["fx_zmb_tranzit_key_glint"],(760, 461 ,-30),(0,-90,0) );
		//playfx(level._effect["fx_zmb_tranzit_key_glint"],(760 ,452 ,-30),(0,-90,0) );
	}
}

function bank_teller_logic()
{
	level endon("end_game");
	
	while(1)
	{
		level.bank_teller_dmg_trig waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, blah );
		if(isDefined(attacker) && isPlayer(attacker) && damage == 1500 && type == "MOD_MELEE") //for now since triggers don't seem to return the weapon from the damage callback
		{
			bank_teller_give_money();
			level.bank_teller_transfer_trig TriggerEnable( false );			
		}
	}
}
	
function bank_teller_give_money()
{
	level endon("end_game");
	level endon("stop_bank_teller");
	
	level.bank_teller_transfer_trig TriggerEnable( true );
	bank_transfer = undefined;
			
	while(1)
	{
		level.bank_teller_transfer_trig waittill("trigger",player);
		if(!zm_utility::is_player_valid( player, false ) || player.score < ( 1000 + level.ta_tellerfee) )
		{
			//TODO - add generic no money sound here
			continue;
		}
		if(!isDefined(bank_transfer))
		{
			bank_transfer = zm_powerups::specific_powerup_drop( "teller_withdrawl", level.bank_teller_powerup_spot.origin + (0,0,-40) );
			bank_transfer thread stop_bank_teller();
			bank_transfer.value = 0;
		}
		bank_transfer.value += 1000;
		
		bank_transfer notify("powerup_reset"); //reset the timer
		bank_transfer thread zm_powerups::powerup_timeout();
		
		player zm_score::minus_to_player_score( 1000 + level.ta_tellerfee );

		level notify( "bank_teller_used" );
	}	
}

function stop_bank_teller()
{
	level endon("end_game");
	self waittill("death");
	level notify("stop_bank_teller");
}

function delete_bank_teller()
{
	wait(1);
	level notify("stop_bank_teller");
	
	
	bank_teller_dmg_trig = getent("bank_teller_tazer_trig","targetname");
	bank_teller_transfer_trig = getent(bank_teller_dmg_trig.target,"targetname");
	
	
	bank_teller_dmg_trig delete();
	bank_teller_transfer_trig delete();

	
}

//=============================================================================
// DEPOSIT BOX

function onPlayerConnect_bank_deposit_box()
{
	online_game = SessionModeIsOnlineGame();
	if ( !online_game )
		self.account_value = 0;
	else
		self.account_value = self zm_stats::get_map_stat( "depositBox", level.banking_map );
}

function bank_deposit_box()
{
	level.bank_deposit_max_amount = 250000; // Taken From The Zombie Stats.DDL
	level.bank_deposit_ddl_increment_amount = 1000; // Taken From The Zombie Stats.DDL

	level.bank_account_max = ( level.bank_deposit_max_amount / level.bank_deposit_ddl_increment_amount );
	level.bank_account_increment = int ( level.bank_deposit_ddl_increment_amount / 1000 );

	deposit_triggers = struct::get_array( "bank_deposit", "targetname" );
	array::thread_all( deposit_triggers, &bank_deposit_unitrigger );

	withdraw_triggers = struct::get_array( "bank_withdraw", "targetname" );
	array::thread_all( withdraw_triggers, &bank_withdraw_unitrigger );
}


function bank_deposit_unitrigger()
{
	bank_unitrigger( "bank_deposit", &trigger_deposit_update_prompt, &trigger_deposit_think, 5, 5, undefined, 5 );
}

function bank_withdraw_unitrigger()
{
	bank_unitrigger( "bank_withdraw", &trigger_withdraw_update_prompt, &trigger_withdraw_think, 5, 5, undefined, 5 );
}


// NOTE: You can't store KVP's like (script_width ot script_height) on script structs, so adding optional overrides
//
function bank_unitrigger( name, prompt_fn, think_fn, override_length, override_width, override_height, override_radius )
{
	unitrigger_stub = SpawnStruct();
	
	unitrigger_stub.origin = self.origin; 
	if (IsDefined(self.script_angles))
		unitrigger_stub.angles = self.script_angles;
	else
		unitrigger_stub.angles = self.angles; 
	unitrigger_stub.script_angles = unitrigger_stub.angles;

	if( IsDefined(override_length) )
	{
		unitrigger_stub.script_length = override_length;
	}
	else if (IsDefined(self.script_length))
	{
		unitrigger_stub.script_length = self.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 32;
	}

	if( IsDefined(override_width) )
	{
		unitrigger_stub.script_width = override_width;
	}
	else if (IsDefined(self.script_width))
	{
		unitrigger_stub.script_width = self.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 32;
	}

	if( IsDefined(override_height) )
	{
		unitrigger_stub.script_height = override_height;
	}
	else if (IsDefined(self.script_height))
	{
		unitrigger_stub.script_height = self.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 64;
	}

	if( IsDefined(override_radius) )
	{
		unitrigger_stub.script_radius = override_radius;
	}
	else if (IsDefined(self.radius))
	{
		unitrigger_stub.radius = self.radius;
	}
	else
	{
		unitrigger_stub.radius = 32;
	}
	
	if (IsDefined(self.script_unitrigger_type))
	{
		unitrigger_stub.script_unitrigger_type = self.script_unitrigger_type;
	}
	else
	{
		unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		unitrigger_stub.origin -= ( AnglesToRight( unitrigger_stub.angles ) * ( unitrigger_stub.script_length / 2 )) ;
	}

	unitrigger_stub.cursor_hint = "HINT_NOICON";
	//* unitrigger_stub.require_look_at = true;
	unitrigger_stub.targetname = name;
	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );

	unitrigger_stub.prompt_and_visibility_func = prompt_fn;
	zm_unitrigger::register_static_unitrigger( unitrigger_stub, think_fn );
}

function trigger_deposit_update_prompt( player )
{
	if ( player.score < level.bank_deposit_ddl_increment_amount || player.account_value >= level.bank_account_max )
	{
		player show_balance();
		self SetHintString( "" );
		return false; 
	}

	self SetHintString( &"ZOMBIE_BANK_DEPOSIT_PROMPT", level.bank_deposit_ddl_increment_amount );
	return true; 
}

function trigger_deposit_think( )
{
	self endon("kill_trigger");
	while ( true )
	{
		self waittill( "trigger", player );
		
		if ( !zm_utility::is_player_valid( player ) )
		{
			continue;
		}
		
		if ( player.score >= level.bank_deposit_ddl_increment_amount && player.account_value < level.bank_account_max )
		{
			player playsoundtoplayer( "zmb_vault_bank_deposit", player );
			player.score -= level.bank_deposit_ddl_increment_amount;
			
			player.account_value += level.bank_account_increment;

			player zm_stats::set_map_stat( "depositBox", player.account_value, level.banking_map );
			
			if( IsDefined(level.custom_bank_deposit_VO) )
			{			
				player thread [[ level.custom_bank_deposit_VO ]]();
			}
			
			if ( player.account_value >= level.bank_account_max )
			{
				self SetHintString( "" );
			}
		}
		else
		{
			player thread zm_utility::do_player_general_vox("general","exert_sigh",10,50);
		}
		player show_balance();
	}
}

function trigger_withdraw_update_prompt( player )
{
	if ( player.account_value <= 0 )
	{
		self SetHintString( "" );
		player show_balance();
		return false; 
	}

	self SetHintString( &"ZOMBIE_BANK_WITHDRAW_PROMPT", level.bank_deposit_ddl_increment_amount, level.ta_vaultfee );
	return true; 
}

function trigger_withdraw_think( )
{
	self endon("kill_trigger");
	while ( true )
	{
		self waittill( "trigger", player );
		
		if ( !zm_utility::is_player_valid( player ) )
		{
			continue;
		}
		
		if ( player.account_value >= level.bank_account_increment )
		{
			player playsoundtoplayer( "zmb_vault_bank_withdraw", player );
			player.score += level.bank_deposit_ddl_increment_amount;

			level notify( "bank_withdrawal" );
			
			player.account_value -= level.bank_account_increment;
			player zm_stats::set_map_stat( "depositBox", player.account_value, level.banking_map );
			
			if( IsDefined(level.custom_bank_withdrawl_VO) )
			{
				player thread [[ level.custom_bank_withdrawl_VO ]]();
			}
			else
			{
				player thread zm_utility::do_player_general_vox("general","exert_laugh",10,50);	
			}
			player thread player_withdraw_fee();
			if ( player.account_value < level.bank_account_increment )
			{
				self SetHintString( "" );
			}
		}
		else
		{
			player thread zm_utility::do_player_general_vox("general","exert_sigh",10,50);
		}
		player show_balance();
	}
}

function player_withdraw_fee()
{
	self endon("disconnect");
	
	util::wait_network_frame();
	self.score -= level.ta_vaultfee;
}

function show_balance()
{
	/#
	IPrintLnBold("DEBUG BANKER: "+self.name+" account worth "+self.account_value);
	#/
}

