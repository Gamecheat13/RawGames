#include maps\_utility;
#include common_scripts\utility;
#include maps\payback_util;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_audio;

CONST_MPHTOIPS = 17.6;
//CONST_PLAYER_LINKTO_STAND = "tag_player";
CONST_PLAYER_LINKTO = "tag_player2";
//CONST_PLAYER_LINK_OFFSET = (0,0,-40);

DISABLE_INTRO_FOG_HACK = true;

init_compound_a_flags()
{
	flag_init("intro_tech1_shootme");
	flag_init("intro_tech2_shootme");
}

do_path(acc, spd)
{
	self goPath();
	//self setAcceleration(acc);
	//self vehicle_setSpeed(spd);
}

intro()
{
	maps\_compass::setupMiniMap("compass_map_payback_drivein","drivein_minimap_corner");

	leaving_triggers = GetEntArray( "Player_Leaving_Compound_Trigger", "targetname" );
	
	foreach ( trigger in leaving_triggers )
	{
		trigger trigger_off();
	}
	
	left_triggers = GetEntArray( "Player_Left_Compound_Trigger", "targetname" );
	
	foreach ( trigger in left_triggers )
	{
		trigger trigger_off();
	}
	
	aud_send_msg("player_slamzoom_prime"); // AUDIO: magic
	
	
	thread hack_shadow_quality();
	thread manage_intro_viewdistance();
	thread intro_technicals();
	thread bravo_puddlesplash();
	thread reset_chopper_treadfx();
	thread windshield_cracks();
	
	//SetCullDist(25000);
	
	//old lines level thread intro_vo_lines();
	maps\payback_1_script_b::remove_placeholder_hummers();
	
	//thread the bravo anim sequence
	level thread gate_closing_guys();	
	//thread intro_dof();
	
	hide_hud_for_scripted_sequence();

	waittillframeend;

	//make player invincible until intro is done
	level.player EnableInvulnerability();
	
	
	chopper_intro_struct = GetStruct("chopper_new_intro_path", "targetname");
	
	//level.player disable_hands();
	aud_send_msg("intro_hummer_ride");
	
	alpha_hummer = spawn_vehicle_from_targetname( "alpha_hummer" );	
	level.alpha_hummer = alpha_hummer;
	level.alpha_hummer.dontunloadonend = true;	//custom unloading for price and soap.
	
	bravo_hummer = spawn_vehicle_from_targetname( "bravo_hummer" );
	level.bravo_hummer = bravo_hummer;
	level.bravo_hummer thread alpha_createfx_exploders();
	level.bravo_hummer thread bravo_treadfx_logic();
	level.bravo_hummer thread bravo_wheel_skidmark_hack();
	
	level thread bravo_truck_gatecrash_anim_thread();
	
	//thread soap anim sequence
	thread intro_hummer_soap_events(level.soap);	
	thread bravo_guy_signals();
	thread barracus_intro_events();
	thread nikolai_blows_stuff_up();
	


	//price has a special getout
	level.price.get_out_override = level.scr_anim[ "price" ][ "intro_price_getout" ];
	
	//hide price's gun.
	level.price gun_remove();
	
	//attach price and soap to alpha hummer
	alpha_hummer thread maps\_vehicle_aianim::guy_enter( level.price );
	
	alpha_hummer thread maps\_vehicle_aianim::guy_enter( level.soap );
		
	//other allies ride in bravo hummer	
	level.hannibal.animname = "Hannibal";	
	bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Hannibal);
	bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Murdock);
	bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Barracus);
	
				 
	//soap line
	//wait 3.0;
	
	
	thread intro_dialog();
	
	thread intro_player_events();
	//thread introscreen_generic_black_fade_in( 6.0, 0.3 );
	level.player FreezeControls( true );

	cinematicingamesync( "payback_fade" );

	wait 0.5;

	
	exploder(1000);
	
	//level waittill("introscreen_pre_fadein");
	aud_send_msg("intro_black_begin"); // AUDIO

	//level waittill("introscreen_prime_audio");
			
	//start the action!
	//level waittill("introscreen_fade_start");
	thread intro_slamzoom();

	level.chopper Vehicle_Teleport(chopper_intro_struct.origin, chopper_intro_struct.angles);
	//level.chopper StartPath(chopper_intro_struct);
	level.chopper thread vehicle_paths(chopper_intro_struct);
	
	level.chopper Vehicle_SetSpeedImmediate( 70, 20, 20 );
	
	thread maps\payback_1_script_b::spawn_ground_opposition();
		
	set_introguys_ignoreme(true);
	thread turn_off_ignoreme();

	
	//thread price anims
	thread price_intro_anim();
	level.price thread price_unload_events();
	level notify("price_intro_line");//price_intro_anim
	
	bravo_invulnerability(true);  // this gets turned off in script_b
	
	thread jump_reaction_anims();
	
	alpha_hummer do_path();
	bravo_hummer do_path();

	// AUDIO: initialize our hummer audio
	// we override all of the vehicle system sounds with our own assets and logic
	thread maps\payback_aud::initialize_intro_hummers();
	
	
	
	//thread gate_approach_slowmo();
	
	battlechatter_off( "allies" ); // RAVEN AUDIO: disable battle chatter in favor of scripted VO until after we crash (re-enabled in payback_1_script_b::main())
	
	
	thread intro_civillians();
	
	//thread start_sandstorm_chopper_fx();
	thread sandstorm_fx(1);
	
	//soap kills guys at a certain point if the player hasn't
	level.soap thread soap_kills_intro_guys_thread();
	level thread barrels_explode_thread();

	wait(24);
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	
	//smash through gate
	gate_node = getvehiclenode("player_truck_gate_node", "targetname");
	gate_node waittill("trigger");	
	level.player PlayRumbleOnEntity( "heavy_3s" );
	Earthquake( 0.3, 0.75, level.player.origin, 200 );
	
	
	level waittill("player_exited_jeep");
    
	// give the player 3 more seconds of invulnerability
	thread safety_timer();
	
	foreach ( trigger in leaving_triggers )
	{
		trigger trigger_on();
	}
	
	foreach ( trigger in left_triggers )
	{
		trigger trigger_on();
	}
		
	thread Player_Leaving_Compound();
	thread Player_Left_Compound();
		
	maps\payback_1_script_b::main();
}

turn_off_ignoreme()
{
	vehicle_node_trigger_wait("alpha_jump_land_node");
	wait 2.0;
	set_introguys_ignoreme(false);
}

intro_dialog()
{
	wait 4.5;
	//level waittill("soap_line1");
	//level.soap dialogue_queue("payback_mct_targetsite");
	
	//next two lines happen in notetracks
	
	vehicle_node_trigger_wait("player_stand_node");
	wait 4.0;
	
	//level waittill("price_line2");
	level.price dialogue_queue("payback_pri_throughgate");
	
	//level waittill("price_line3");
	vehicle_node_trigger_wait("alpha_jump_land_node");
	wait 2.0;
	
	//level.price dialogue_queue("payback_pri_softenhim");
	wait 1.8;
	radio_dialogue("payback_nik_misslesaway");
	
	aud_send_msg("start_lfe_loop");
	
	//level waittill ("soap_line2");
	//vehicle_node_trigger_wait("alpha_post_land_node");
	//wait 2.0;
	wait .65;
	level.price dialogue_queue("payback_pri_targetsahead");	
}

vehicle_node_trigger_wait(nodename)
{
	node = 	GetVehicleNode(nodename, "script_noteworthy");
	node waittill("trigger");		
}

vehicle_play_guy_anim(anime, guy, pos, playIdle)
{	 
    animpos = anim_pos( self, pos );
    
    animation = guy getanim(anime);
    
    guy notify ("newanim");
    guy endon( "newanim" );
    guy endon( "death" );
    
	//self animontag(guy, animpos.sittag, animation );
	self anim_single_solo(guy, anime, animpos.sittag);
	
	if(!IsDefined(playIdle) || playIdle == true)
	{
		self guy_idle(guy, pos); 	
	}
}

vehicle_play_guy_anim_at_nodename(nodename, anime, guy, pos, delay, playIdle, notifyName)
{
	vehicle_node_trigger_wait(nodename);
	wait delay;
	
	guy endon( "death" );
	if(IsDefined(notifyName))
	{
		guy notify(notifyName);
	}
	vehicle_play_guy_anim(anime, guy, pos, playIdle);   
}

vehicle_play_guy_anim_on_notify(event, anime, guy, pos)
{
	level waittill(event);
	
	guy endon( "death" );
    
    animpos = anim_pos( self, pos );
    
    animation = guy getanim(anime);
    
    guy notify ("newanim");
    guy endon( "newanim" );
    
	//self animontag(guy, animpos.sittag, animation );
	self anim_single_solo(guy, anime, animpos.sittag);
	
	self guy_idle(guy, pos); 	
}

	
gate_approach_slowmo()
{
	vehicle_node_trigger_wait("barrels_explode_node");
	wait .4;
	
	SetSlowMotion(1.0, 0.3, .3);
	wait 1.0;
	SetSlowMotion(0.3, 1.0, 0.1);	
}

windshield_cracks()
{
	//magic bullet the windshield
	vehicle_node_trigger_wait("soap_leans_out_node");
	
	wait 2.0;
	
	for(i=0; i < 5; i++)
	{
		target = level.alpha_hummer.origin + (RandomFloatRange(-25, 25),0.0,RandomFloatRange(55, 60));
	
		forward = AnglesToForward(level.alpha_hummer.angles);
		
		source = (target + forward* 500);
		MagicBullet("ak47", source, target);
		wait (RandomFloatRange(0.1, 0.5));
	}
	
}

alpha_createfx_exploders()
{
	createfx_birds_node = getvehiclenode("alpha_fx_birds", "script_noteworthy");
	createfx_birds_node waittill("trigger");
	wait(2.5);
	exploder(1001);
}
bravo_treadfx_logic()
{
	//scale treadFX frequency for sandy drive - need lots of sand!
	//self.treadfx_freq_scale = 0.5;	//scales frequency in half, effect should play twice as often.
	jeep_treadfx_sand = level._effect["pb_jeep_trail"] ;
	jeep_treadfx_water = level._effect["pb_jeep_trail_water_left"] ;
	jeap_treadfx_road = level._effect["pb_jeep_trail_road"] ;
	jeep_blankfx = level._effect["blank"] ;
	skidfx = level._effect["pb_jeep_trail_road_skid"] ;
	
	level.bravo_hummer thread override_treadfx_all_wheels(jeep_treadfx_sand);
	
	
	
	//level.bravo_hummer thread treafx_splash_left_at_node("bravo_left_water");
	level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_water,"bravo_left_water");
	level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_sand,"bravo_left_water_end");
	//level.bravo_hummer thread override_treadfx_at_node("bravo_left_water",jeep_treadfx_water,"tag_fx_wheel_back_left");
	//level.bravo_hummer thread override_treadfx_at_node("bravo_left_water",jeep_treadfx_water,"tag_fx_wheel_front_left");
	//level.bravo_hummer thread override_treadfx_at_node("bravo_left_water_end",jeep_treadfx_sand,"tag_fx_wheel_back_left");
	//level.bravo_hummer thread override_treadfx_at_node("bravo_left_water_end",jeep_treadfx_sand,"tag_fx_wheel_front_left");
	level.bravo_hummer thread override_treadfx_all_wheels(jeep_blankfx,"bravo_jump_start_node",1);
	
	
	
	jump_land_node = getvehiclenode("bravo_jump_land_node", "script_noteworthy");
	jump_land_node waittill("trigger");
	
	effectUp = AnglesToUp(self.angles);
	effectFwd = AnglesToForward(self.angles);
	 
	//play the landing effect	
	PlayFX(level._effect["sand_vehicle_impact"], self.origin, effectFwd, effectUp);
		
	//PlayFXOnTag(skidfx, self, self.tagleftWheelHack);	
	level.bravo_hummer thread override_treadfx_all_wheels(jeap_treadfx_road);
	
	wait(.1);
	PlayFXOnTag(skidfx, level.bravo_hummer.tagleftWheelHack,"tag_origin");
	PlayFXOnTag(skidfx, level.bravo_hummer.tagrightWheelHack,"tag_origin");
	
	
	texploder(2300);
	exploder(2000);
	exploder(2500); // Water
	
	//maps\_treadfx::setvehiclefx( classname, "sand", "treadfx/tread_sand_heavy" );
	
	//go back to normal tread frequency
	//self.treadfx_freq_scale = undefined;
}

override_treadfx_left_wheels(fx,nodename,delay)
{
	if (IsDefined(nodename))
	{
		vehicle_node_trigger_wait(nodename);
	}
	if (IsDefined(delay))
	{
		wait(delay);
	}
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_front_left");
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_back_left");
}
override_treadfx_right_wheels(fx,nodename,delay)
{
	if (IsDefined(nodename))
	{
		vehicle_node_trigger_wait(nodename);
	}
	if (IsDefined(delay))
	{
		wait(delay);
	}
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_front_right");
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_back_right");
}

override_treadfx_all_wheels(fx,nodename,delay)
{
	//self endon("new_treadfx");
	
	if (IsDefined(nodename))
	{
		vehicle_node_trigger_wait(nodename);
	}
	if (IsDefined(delay))
	{
		wait(delay);
	}
	override_treadfx_on_wheel(fx,"tag_wheel_front_left");
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_front_right");
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_back_left");
	wait(.05);
	override_treadfx_on_wheel(fx,"tag_wheel_back_right");
}
/*
treafx_splash_left_at_node(nodename)
{
	vehicle_node_trigger_wait(nodename);
	jeep_splash_left = level._effect["jeep_water_impact_left"];
	PlayFXOnTag(jeep_splash_left,level.bravo_hummer,"tag_wheel_front_left");
}
treafx_splash_right_at_node(nodename)
{
	vehicle_node_trigger_wait(nodename);
	jeep_splash_right = level._effect["jeep_water_impact"];
	PlayFXOnTag(jeep_splash_right,level.bravo_hummer,"tag_wheel_front_right");
}
*/
override_treadfx_at_node(nodename, fx, tag, delay)
{
	//self endon("new_treadfx");
	
	if(!isdefined(delay))
	{
		delay = 0.0;		
	}
	
	vehicle_node_trigger_wait(nodename);
	
	wait delay;
	
	thread override_treadfx_on_wheel(fx, tag);	
}

override_treadfx_on_wheel(fx, tag )
{	

	sNotifyName = (tag);
	self notify("new_treadfx", sNotifyName);
	waittillframeend;
	
	self thread override_treadfx_killthread(fx, tag);	
	//waittillframeend;
	 
	//just to be sure, stop any existing instances of this fx on this tag
	//StopFXOnTag(fx,self, tag);
	PlayFXOnTag(fx, self, tag);	
	
}


override_treadfx_killthread(fx, tag)
{
	sNotifyName = (tag);
	self waittillmatch("new_treadfx", sNotifyName);
	
	StopFXOnTag(fx, self, tag);		
}
		


safety_timer()
{
	wait 3;
	level.player disableInvulnerability();
}


HasPlayerReturnedToCompound()
{
	return !flag( "Player_Leaving_Compound" );
}

Player_Leaving_Compound()
{
	while ( 1 )
	{
		flag_wait( "Player_Leaving_Compound" );
		thread radio_dialogue("payback_pri_staywithteam");
		level.player display_hint( "Payback_Dont_Abandon_Mission" );
		flag_waitopen( "Player_Leaving_Compound" );
	}
}

Player_Left_Compound()
{
	flag_wait( "Player_Left_Compound" );
	
	setDvar( "ui_deadquote", &"PAYBACK_FAIL_ABANDONED" );
	level notify( "mission failed" );
	missionFailedWrapper();
}

Handle_Chopper_Destructables()
{
	triggers = GetEntArray( "pb_guardtower_compound_trigger", "targetname" );
	foreach ( trig in triggers )
	{
		trig thread Handle_Guard_Tower_Explosion( "pb_guardtower_compound", trig.script_index, "a10_explosion", "thick_building_fire_small" );
	}
	
	triggers = GetEntArray( "pb_guardtower_compound_02_trigger", "targetname" );
	foreach ( trig in triggers )
	{
		trig thread Handle_Guard_Tower_Explosion( "pb_guardtower_compound_02", trig.script_index, "a10_explosion", "thick_building_fire_small" );
	}
}

Handle_Guard_Tower_Explosion( tower_name, part_radius, fx_name1, fx_name2 )
{
	attacker = undefined;
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		if ( attacker == level.chopper )
		{
			break;
		}
	}
	
	fx_origins = GetEntArray( tower_name + "_fx", "targetname" );
	
	fx_origin = self.origin;
	foreach ( fx in fx_origins )
	{
		if ( distancesquared( fx.origin, self.origin ) < part_radius )
		{
			fx_origin = fx.origin;
			break;
		}
	}
	
	if ( IsDefined( fx_name1 ) )
	{
		playfx( getfx( fx_name1 ), fx_origin );
	}
	
	if ( IsDefined( fx_name2 ) )
	{
		playfx( getfx( fx_name2 ), fx_origin );
	}
	
	parts = GetEntArray( tower_name + "_parts", "script_noteworthy" );
	foreach ( part in parts )
	{
		if ( distancesquared( part.origin, self.origin ) < part_radius )
		{
			part delete();
		}
	}
	
	self delete();
}



soap_kills_intro_guys_thread()
{
	node = getvehiclenode("soap_kills_guys_node", "script_noteworthy");
	node waittill("trigger");
	
	guys = get_ai_group_ai("soap_intro_targets");
	foreach(guy in guys)
	{
		if(isdefined(guy) && isalive(guy))
		{	
			//guy kill(level.soap.origin, level.soap);
			MagicBullet( level.soap.weapon, level.soap gettagorigin( "tag_flash" ), guy geteye() );		
			if(IsAlive(guy))
			{
				guy kill(level.soap.origin, level.soap, level.player);
			}
		}
		wait .1;
	}
	
}

intro_civillians()
{
	vehicle_node_trigger_wait("bravo_jump_start_node");
	
	aud_send_msg("s1_chopper_by");
	
	civies = array_spawn_targetname("intro_civillians");
	
	foreach(civ in civies)
	{		
		civ.ignoreall = true;
		civ set_generic_run_anim( "intro_civilian_A_run", true );
		//civ gun_remove();
		civ putGunAway();
		if (IsEndStr(civ.target, "auto136"))
		{
			aud_send_msg("intro_civies_run_by", civ);
		}
	}
}

barrels_explode_thread()
{
	vehNode = getvehiclenode("barrels_explode_node","script_noteworthy");
	vehNode waittill("trigger");
	
	intro_barrels_target = getstruct("intro_barrels_target", "targetname");
	
	radiusdamage(intro_barrels_target.origin, 500, 500, 500);
}

//intro_vo_lines()
//{
//	node = getvehiclenode("price_line_node","script_noteworthy");	
//	node waittill("trigger");
//
//	level.price dialogue_queue( "payback_pri_15sec_r" );
//	
//	wait .5;
//		
//	level.soap dialogue_queue("payback_mct_tagretsahead_r");
//}

freeze_at(nodename)
{
	node = getvehiclenode(nodename, "targetname");
	node waittill("trigger");
	self Vehicle_SetSpeed(0, 1000, 1000);	
}


gate_closing_guys()
{
	guys = array_spawn_targetname("gate_closing_guys", 1); //GetEntArray("gate_closing_guys", "targetname");
	
	gate_left = getent("intro_gate_left", "targetname");
	gate_right = getent("intro_gate_right", "targetname");
	
	gate_left.animname = "intro_gate";
	gate_right.animname = "intro_gate";
	
	gate_left SetAnimTree();
	gate_right SetAnimTree();
	
	gatestruct = getstruct("bravo_gate_script_anim_origin", "targetname");
	
	//originStruct = SpawnStruct();
	//originStruct.angles = (0,0,0);
	//originStruct.origin = (-1623.5, 3913.5, 203.0);
	
	
		
	guys[0].animname = "gate_guy_left";
	guys[1].animname = "gate_guy_right";
	
	group1[0] = guys[0];
	group1[1] = gate_left;
	
	group2[0] = guys[1];
	group2[1] = gate_right;
	
	gatestruct anim_first_frame(group1, "gate_close");
	gatestruct anim_first_frame(group2, "gate_close");
	
	round_last_corner_node = getvehiclenode("soap_leans_out_node", "script_noteworthy");
	round_last_corner_node waittill("trigger");
	
	wait 1.2;
	
	level notify("close_gate");
	
	aud_send_msg("aud_gatecrash_mix");
	
	thread gate_close_guy(group1, gatestruct);
	thread gate_close_guy(group2, gatestruct);
	
}

gate_close_guy(guys, gatestruct)
{	
	//level waittill("close_gate");
	
	guys[0] endon("death");	
	
	gatestruct thread anim_single(guys, "gate_close");
	
	guys[0] waittillmatch("single anim", "allow_kill");
	
	foreach ( guy in guys )
	{
		if( (guy.animname == "gate_guy_left" ) || ( guy.animname == "gate_guy_right" ) )
		{
			guy.allowdeath = true;
		}
	}

//  mmajernik:  commented these out because we apparently don't need them anymore
//  mmajernik:  the dives are now built into the gate_close anims for each guy
//	guys[0] waittillmatch("single anim", "end");
	
//	gatestruct thread anim_single_solo(guys[0], "gate_close_dive");
	
}

bravo_truck_gatecrash_anim_thread()
{
	bravo_node = getvehiclenode("bravo_gate_node","targetname");
	player_node =getvehiclenode("player_truck_gate_node", "targetname");
	
	//vehicleNode waittill("trigger");
	
	
	//find the anim origin
	gatestruct = getstruct("bravo_gate_script_anim_origin", "targetname");
	
	gate_left = getent("intro_gate_left", "targetname");
		
	thread gatecrash_anim( getent("intro_gate_right","targetname"), gatestruct, bravo_node);
	thread gatecrash_anim( gate_left, gatestruct, player_node);
	
	thread gatecrash_fx_right( getent("intro_gate_right","targetname"), bravo_node);
	
	
	thread gatecrash_fx_left( gate_left, player_node);
	
	
	player_node waittill("trigger");
	                     
	jeep_blankfx = level._effect["blank"];
	level.bravo_hummer thread override_treadfx_all_wheels(jeep_blankfx);

	
	// AUDIO: start the music as soon as the gate has been crashed
	aud_send_msg("s1_gate_crash", gate_left);
	
	//also delete the last guy that was in front of the gate
	lastGateGuy = getentarray("gate_intro_deletemeguy","script_noteworthy");
	if(isdefined(lastGateGuy))
	{
		array_call(lastGateGuy , ::kill);
	}
	
	anyoneElseLeft = getentarray("intro_roofguy","script_noteworthy");
	if(isdefined(anyoneElseLeft ))
	{
		array_call(anyoneElseLeft  , ::kill, level.player.origin, level.soap);
	}
}

gatecrash_anim(gateEnt, originStruct, node)
{	
	//originStruct thread anim_first_frame_solo(gateent, "gate_crash");
	
	node waittill("trigger");
	
	originStruct thread anim_single_solo( gateEnt, "gate_crash" );	
	
}
gatecrash_fx_left(gateEnt,node)
{
	impactFX = level._effect[ "gate_metal_impact" ];
	node waittill("trigger");
	PlayFXOnTag(impactFX,gateEnt,"fx_tag_left");
	
	window_fx = level._effect[ "car_glass_large_moving" ];
	PlayFXOnTag(window_fx,level.alpha_hummer,"TAG_BLOOD");
	
	stop_exploder(1000);
	//sandstorm_fx(2);
}

gatecrash_fx_right(gateEnt,node)
{
	impactFX = level._effect[ "gate_metal_impact" ];
	node waittill("trigger");
	PlayFXOnTag(impactFX,gateEnt,"fx_tag_right");
}

enable_weapons()
{
	//weapon = self getCurrentWeapon();
	//self TakeWeapon(weapon);
	//self GiveWeapon(weapon);
	self EnableWeapons();
	show_hud_after_scripted_sequence();
}

intro_player_events()
{
	//threaded when level starts, before jeeps start moving and while still in black screen
	
	// set up player anims, attachment
	player_rig = spawn_anim_model( "const_player_jeep_rig_1" );
	level.player_rig = player_rig;
	level.player AllowCrouch(false);
	level.player AllowProne(false);
	level.player DisableWeapons();
	level.player DisableOffhandWeapons();
	level.player AllowSprint(false);
	player_rig LinkTo(level.alpha_hummer, CONST_PLAYER_LINKTO, (0,0,0), (0,0,0));
	
	//link the player immediately to make texture streaming work correctly	
	level.player playerlinkto(level.player_rig, "tag_player");
	
	waittillframeend;
	
	
	
	//wait a bit to let the level logic start... without this the rumble doesn't seem to work.
	wait .1;
	
	
	level.alpha_hummer anim_first_frame_solo( level.player_rig , "intro_jeep_stand_player", CONST_PLAYER_LINKTO);	
	//level.player_rig SetAnimRestart(level.player_rig getanim("intro_jeep_stand_player"), 1.0, 0.0, 0.0);
	//level.player_rig SetAnimKnob(level.player_rig getanim("intro_jeep_stand_player"), 1.0, 0.0, 0.0);
			
	level.player SetPlayerAngles(level.player_rig GetTagAngles("tag_player"));
	level waittill("slam_zoom_done");
	thread intro_rumble();
	
	
	level.player_rig Show();
	
	//link player with delta so you get carried around the turn	
	level.player PlayerLinkToDelta(level.player_rig, "tag_player", 1.0, 15, 40, 30, 15);
	
	
	vehicle_node_trigger_wait("player_stand_node");
	wait 2.5;	
	thread notify_Remove_Wall();
	
	
	level.alpha_hummer anim_single_solo(level.player_rig, "intro_jeep_stand_player", CONST_PLAYER_LINKTO);
	
	//and unlock your view again
	//level.player PlayerLinkToDelta(level.player_rig, "tag_player", 1.0, 15, 40, 30, 15);		
	vehicle_node_trigger_wait("alpha_jump_start_node");
	
	//level.player PlayerLinkToDelta(level.player_rig, "tag_player", .8, 15, 15, 30, 20, true );
	level.player LerpViewAngleClamp(0.5, 0.1,0.1, 15,15,30,30);
		
	level.alpha_hummer thread anim_single_solo(level.player_rig, "intro_jeep_jump_player", CONST_PLAYER_LINKTO);	
	
	vehicle_node_trigger_wait("soap_leans_out_node");
	
	//level.player PlayerLinkToDelta(level.player_rig, "tag_player", 1.0, 40, 40, 30, 20);
	level.player LerpViewAngleClamp(0.5, 0.1,0.1, 40, 40, 30,20);
	
	
	
	level.player delayThread( 2.0, ::enable_weapons);
			
	round_last_corner_node = getvehiclenode("round_last_corner_node", "script_noteworthy");
	round_last_corner_node waittill("trigger");
	
	//at this point use a non-delta link so your view is more manageable and not thrown by bumps.

	wait .2;
	level.player PlayerLinkTo(level.player_rig, "tag_player", 0.0, 90, 90, 30, 20);	
	level.player_rig hide();
	
	//Approaching gate
	barrels_explode_node = GetVehicleNode("barrels_explode_node", "script_noteworthy");
	barrels_explode_node waittill("trigger");
	
	wait .7;
	
	level.player_rig show();
	level notify("player_exiting_jeep");
	level.player DisableWeapons();
	wait .1;
	
	level.player PlayerLinkToAbsolute(level.player_rig, "tag_player");
	
	//unload price partway through, before vehicle comes to a full stop
	level.alpha_hummer delayThread(2.3, ::vehicle_unload, "driver");
	
	
	//hack to remove price from the drivers array
	//array_remove(level.alpha_hummer.drivers, level.price);
	level.player_rig show();
	level.alpha_hummer anim_single_solo(level.player_rig, "intro_jeep_exit_player", CONST_PLAYER_LINKTO);
	
	//level.player_rig SetFlaggedAnimKnobRestart("anim_gate", level.player_rig getanim("intro_jeep_exit_player"), 1.0, 0.05, 1.0);
//	level.player_rig waittillmatch("anim_gate", "end");

	
	
	level.player Unlink();
	level.player_rig Delete();
	level.player EnableWeapons();
	level.player EnableOffhandWeapons();

	
	//level.player SetStance( "stand" );
	level.player AllowCrouch(true);
	level.player AllowProne(true);
	level.player AllowSprint(true);
	level notify("player_exited_jeep");
	
	
}

intro_rumble()
{
	level.player PlayRumbleLoopOnEntity("subtle_tank_rumble");
	
	vehicle_node_trigger_wait("alpha_jump_start_node");
	wait 1.0;
	
	level.player StopRumble("subtle_tank_rumble");
	wait .85;

	level.player PlayRumbleOnEntity("grenade_rumble");
	wait .8;
	level.player PlayRumbleLoopOnEntity("subtle_tank_rumble");
		
	gate_node = getvehiclenode("player_truck_gate_node", "targetname");
	gate_node waittill("trigger");	
	
	level.player StopRumble("subtle_tank_rumble");
	level.player PlayRumbleOnEntity("grenade_rumble");
	

}
notify_Remove_Wall()
{
	wait 10;
	sandstorm_fx(2);
	//level notify("move_sandstorm_wall");
}
bravo_guy_signals()
{
	
	level.Murdock.animname = "Murdock";
	
	level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_signals_node", "bravo_intro_signal", level.Murdock, 1, 2.0);	
}

barracus_intro_events()
{	
	
	level.barracus.animname = "Barracus";	

	thread barracus_jump_react();

	//thread this for later
	level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_guy_stands_node", "bravo_intro_stand_gatecrash", level.barracus, 2, 8.0, false, "gatecrash");
	
	level.bravo_hummer vehicle_play_guy_anim_at_nodename("bravo_signals_node", "bravo_intro_stand", level.Barracus, 2, 1.0, false);
	
	
	//loop standing idle
	level.barracus endon("jump");
	while(1)
	{
		level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_idle", level.barracus, 2, false);
	}	
}

barracus_jump_react()
{
	vehicle_node_trigger_wait("bravo_splash_node");
	
	level.barracus notify("jump");	//end idle1
	
	level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_turn", level.barracus, 2, false);
	
		
	level.barracus endon( "gatecrash" );	
	while(1)
	{
		level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_idle_2", level.barracus, 2, false);	
	}	
}


jump_reaction_anims()
{
	level.alpha_hummer thread vehicle_play_guy_anim_at_nodename("alpha_jump_start_node", "intro_jump_react", level.price, 0, 0.0);
	level.alpha_hummer thread vehicle_play_guy_anim_at_nodename("alpha_jump_start_node", "intro_jump_react", level.soap, 1, 0.0);
	
	level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_jump_start_node", "intro_jump_react", level.Hannibal, 0, 0.0);
	level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_jump_start_node", "intro_jump_react", level.Murdock, 1, 0.0);	
	
	//play the steering wheel anim when price plays his jump react.
	vehicle_node_trigger_wait("alpha_jump_start_node");
	level.alpha_hummer SetFlaggedAnimRestart( "vehicle_anim_flag", level.alpha_hummer getanim("wheel_turn") );
	
}

price_intro_anim()
{
//	level waittill("price_intro_line");
	
	level waittill("slam_zoom_done");
	
	//level.price notify ("newanim");
	//level.price endon( "newanim" );	
	
	//fire off the soap line 2 seconds before this is done (should this be a notetrack?)
	animlen = GetAnimLength(level.scr_anim["price"]["intro_price"]);
	level thread notify_delay("soap_intro_line", (animlen-2.0));
	
	//level.alpha_hummer  animontag(level.price, "tag_driver", level.scr_anim["price"]["intro_price"]);
	level.alpha_hummer vehicle_play_guy_anim("intro_price", level.price, 0, false);
		
	
	//play the shift up anim on the vehicle
	level.alpha_hummer.animname = "alpha_hummer";
	//level.alpha_hummer thread anim_single_solo(level.alpha_hummer, "shift_up");
	
	level.alpha_hummer SetFlaggedAnimRestart( "vehicle_anim_flag", level.alpha_hummer getanim("shift_up") );
	
	level.alpha_hummer vehicle_play_guy_anim("intro_price_shift_up", level.price, 0, true);
		
}

price_killguy_setup()
{
	self thread magic_bullet_shield();
	level waittill("price_unloading");
	self thread stop_magic_bullet_shield();

	
	self waittill("price_kills_me");
	
	self.noragdoll = 1;
	self.a.nodeath = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.diequietly = true;
	self.allowdeath = true;
	
	self DropWeapon(self.weapon, "right", 1);
	self gun_remove();
	
	MagicBullet( level.price.weapon, level.price gettagorigin( "tag_flash" ), self geteye() );		
	if(IsAlive(self))
	{
		self Kill(level.price.origin, level.price,level.price);
	}
	
	//self AnimMode("nophysics", false );
	
	
}

price_unload_events()
{
	// this stuff reactivated in script_b
	level.price.ignoreSuppression = true;
	level.price.ignoreall = true;

	//spawn these guys for Price to kill
	array_spawn_function_targetname("price_intro_killguys", ::price_killguy_setup);
	
	killguys = array_spawn_targetname("price_intro_killguys");
	
	thread gatecrash_price_victims_anims(killguys, getstruct("bravo_gate_script_anim_origin", "targetname"));
	
	self waittill("unload");
	self thread price_exit_jeep_pathing();
	level notify("price_unloading");
	flag_set("price_intro_targets_move");
	
	//self animscripts\shared::DoNoteTracks( "animontagdone");

	level.price gun_recall();
	
	old_primary = self.primaryweapon;	
	self forceUseWeapon("deserteagle", "secondary");
	
	animscripts\shared::placeWeaponOn( self.secondaryweapon, "right", true );
	animscripts\shared::placeWeaponOn( self.primaryweapon, "left", false );
	
	self waittillmatch("animontagdone", "fire");
	aud_send_msg("postgate_shot_01");
	
	//kill first guy
	killguys[0] notify("price_kills_me");
	
	
	//gunshot hits nobody?
	self waittillmatch("animontagdone", "fire");
	aud_send_msg("postgate_shot_02");	
	
	
	self waittillmatch("animontagdone", "fire");
	aud_send_msg("postgate_shot_03");
	
	//kill second guy
	killguys[1] notify("price_kills_me");
	
	
	self waittillmatch("animontagdone", "hide_pistol" );
	animscripts\shared::placeWeaponOn( self.secondaryweapon, "none");
	self.lastWeapon = self.primaryweapon;
	self.weapon = self.primaryweapon;

	//self waittillmatch("animontagdone", "end" );
	//animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
	//animscripts\shared::placeWeaponOn( self.primaryweapon, "right", true );
	
	//level.price delayThread(0.5, ::gun_recall);
	
	///self set_fixednode_false();
}

gatecrash_price_victims_anims(victims, origin)
{
	victims[0].animname = "price_killguy_1";
	victims[1].animname = "price_killguy_2";

	origin anim_first_frame(victims, "intro_price_shoots_guys");	
	player_node =getvehiclenode("player_truck_gate_node", "targetname");
	player_node waittill("trigger");
			
	tag = spawn_tag_origin();
	tag.origin = origin.origin;
	tag.angles = origin.angles;
	
	foreach(vic in victims)
	{
		vic linkto(tag, "tag_origin");
	}
	
	tag anim_single(victims, "intro_price_shoots_guys", "tag_origin");	
	
	//tag thread anim_custom_animmode(victims, "nophysics", "intro_price_shoots_guys" );
		
}

price_exit_jeep_pathing()
{
	price_jeep_exit_goal	= getnode("price_jeep_exit_goal", "targetname");
	old_radius = self.goalradius;
	
	self SetGoalNode(price_jeep_exit_goal);
	self set_forcegoal();
	self set_fixednode_true();
	self.goalradius = 16;
	
	//self set_fixednode_true();
	self waittill("goal");
	self set_fixednode_false();
	self unset_forcegoal();
	self.goalradius = old_radius;
}

intro_hummer_soap_events(soap)
{
	level.alpha_hummer thread vehicle_play_guy_anim_on_notify("soap_intro_line", "intro_soap", level.soap, 1);

	thread soap_stands();
	
	vehicle_node_trigger_wait("barrels_explode_node");
	
	level notify("soap_sits_down");
	
	level.alpha_hummer vehicle_play_guy_anim("intro_soap_stand_end", level.soap, 1, false);
			
		
}

soap_stands()
{
	level endon("soap_sits_down");	
	level.alpha_hummer vehicle_play_guy_anim_at_nodename("alpha_post_land_node", "intro_soap_stand", level.soap, 1, 0.2, false);
	while(1)
	{
		level.alpha_hummer vehicle_play_guy_anim("intro_soap_stand_idle", level.soap, 1, false);	
	}		
}


soap_gun_right(guy)
{
	level.soap place_weapon_on(level.soap.weapon, "right");
}

soap_gun_left(guy)
{
	level.soap place_weapon_on(level.soap.weapon, "left");
}

intro_technicals()
{
	//vehicles =maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 10 );
	vehicles = maps\_vehicle::scripted_spawn( 10 );
	
	tech1 = vehicles[0];
	
	tech1 thread handle_tech("shootme");
	
	//node = getvehiclenode("player_zoom_node","targetname");
//	node waittill("trigger");
	
	vehicle_node_trigger_wait("alpha_post_land_node");
	wait 5.0;
	
	
	tech1 notify("shootme");
		
	////tech2 = vehicles[1];
	
	//tech2 thread handle_tech("intro_tech2_shootme", "intro_heli_targ2", "intro_tech2_explode_node");*/
}

handle_tech(event, target, explode_node)
{
	self thread maps\_vehicle::godon();

	//shoot_node = GetVehicleNode(node,"script_noteworthy");	
	//shoot_node waittill("trigger");
	//self waittill(event);
	
	/*if(isdefined(target))
	{
	   	targ = GetEnt(target, "targetname");
	   	level.chopper thread maps\payback_1_script_d::Chopper_Attack_Target( targ, 0 );
	}
	else
	{
		level.chopper thread maps\payback_1_script_d::Chopper_Attack_Target(self, 0);
	}
	
	if (IsDefined(explode_node))
	{
		node = GetVehicleNode(explode_node, "script_noteworthy");
		node waittill("trigger");
	}
	else*/
	{
	//	wait 1;
	}
	
	level waittill("boom");
	
	self thread maps\_vehicle::godoff();
	RadiusDamage(self.origin, 100, (self.maxhealth*5), self.maxhealth);
	
	//spawn_smoke(self);
}

bravo_puddlesplash()
{
	vehicle_node_trigger_wait("bravo_splash_node");
	
	effectUp = AnglesToUp(level.bravo_hummer.angles);
	effectFwd = AnglesToForward(level.bravo_hummer.angles);
	
	jeep_sand_fx = level._effect["pb_jeep_trail"] ;
	jeep_treadfx_water = level._effect["pb_jeep_trail_water"] ;
	jeep_treadfx_water_left = level._effect["pb_jeep_trail_water_left"] ;
	//jeep_splash_right = level._effect["jeep_water_impact"];
	//jeep_splash_left = level._effect["jeep_water_impact_left"];
	
	level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_water_left);
	level.bravo_hummer thread override_treadfx_right_wheels(jeep_treadfx_water);
	
	//level.bravo_hummer thread override_treadfx_on_wheel(jeep_treadfx_water_left,"tag_fx_wheel_back_left");
	//level.bravo_hummer thread override_treadfx_on_wheel(jeep_treadfx_water_left,"tag_fx_wheel_front_left");
	//level.bravo_hummer thread override_treadfx_on_wheel(jeep_treadfx_water,"tag_fx_wheel_back_right");
	//level.bravo_hummer thread override_treadfx_on_wheel(jeep_treadfx_water,"tag_fx_wheel_front_right");
	
	level.player thread alpha_screenSplash();
	//level.bravo_hummer thread override_treadfx_all_wheels(jeep_water_fx);
	level.bravo_hummer PlaySound("jeep_splash_puddle"); // AUDIO: so sloshy
	level.bravo_hummer PlaySound("jeep_splash_puddle_face"); // AUDIO: face splash sweetener
	wait(.5); 
	
	level.bravo_hummer thread override_treadfx_all_wheels(jeep_sand_fx);
}
alpha_screenSplash()
{
	wait(.5);
	self SetWaterSheeting(1, 2 );
	level.player thread maps\_gameskill::grenade_dirt_on_screen( "left" );
	//overlay = create_overlay_element("sun_flare");
	//wait(2);
	//overlay Delete();	
}


create_overlay_element( shader_name)
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( shader_name, 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	return overlay;
}










nikolai_blows_stuff_up()
{
	thread nikolai_missiles();
	vehicle_node_trigger_wait("alpha_post_land_node");
	
	wait 5.0;
	//someone fires an rpg at nikolai, then he blows them to hell
	target1 = getent("intro_heli_target1", "targetname");
	
	
	//rpg shot
	//rpg_start = getStruct( "rpg_start", "targetname" );
	//rpg_target = getStruct( "rpg_target", "targetname" );
	target_ent = Spawn( "script_origin", level.chopper.origin );
	
	missileAttractor = Missile_CreateAttractorEnt( target_ent, 200000, 5000 );
	magicBullet( "rpg", target1.origin+ (0,0,200.0), target_ent.origin );
	
	wait 5.0;
	
	Missile_DeleteAttractor(missileAttractor);
	
	level.chopper thread maps\payback_1_script_d::Chopper_Attack_Target( target1, 0 );
	
	wait 1.0;
	
	radiusdamage(target1.origin, 100, 1000, 1000, level.player);
		
}

handle_missile(missile, tag, localoffset)
{
	missile SetModel("projectile_sidewinder_missile");
	missile hide();
	
	//setup a dummy model on the chopper at this tag
	dummy = spawn("script_model",(0,0,0));
	dummy SetModel("projectile_sidewinder_missile");
	dummy LinkTo(level.chopper, tag, localoffset, (0,0,0));
	
	missile waittill("launch");
	
	missile Vehicle_Teleport(dummy.origin, dummy.angles);
	missile show();
	
	dummy delete();
	
	
	mytarget = GetVehicleNode(missile.target, "targetname");
	//mytarget.origin = missile.origin;
	
	
	//missile thread vehicle_paths( mytarget );
	missile StartPath(mytarget);
	//missile SetAcceleration(500);
	
	//match missile speed to chopper speed initially	
	missile Vehicle_SetSpeedImmediate(level.chopper Vehicle_GetSpeed() -30, 100, 100);

		
	wait .45;
	
	fx = getfx( "f15_missile" );
	PlayFXOnTag( fx, missile, "tag_origin" );
	
	aud_send_msg("s1_chopper_missiles");
	
	wait .2;
	//speed up to 200 mph over about 1 second
	missile Vehicle_SetSpeed(300, 150, 200);

	
	//self PlaySound( "scn_gulag_f15_missile_fire3" );
	
	
	missile waittill("reached_dynamic_path_end");
	level notify("boom");
	aud_send_msg("intro_rockets_hit");
	
	missile delete();
	
	//missile linkto(level.chopper, tag);	
}

nikolai_missiles()
{
	
	//spawn the missiles right away, attach them to nikolai's chopper
	missile1 = spawn_vehicle_from_targetname("intro_nikolai_missile_1");
	missile2 = spawn_vehicle_from_targetname("intro_nikolai_missile_2");
	
	thread handle_missile(missile1, "tag_flash_2", (0, 15, 0));
	thread handle_missile(missile2, "tag_flash_22", (0, -15, 0));
	
	fire_missile_node = getstruct("nikolai_fires_missiles_node", "script_noteworthy");
	fire_missile_node waittill("trigger");
	
	wait 1.75;
	
	missile1 notify("launch");
	
	wait 0.3;
	missile2 notify("launch");
	
}

set_introguys_ignoreme(ignoreme)
{
	level.price.ignoreme = ignoreme;
	level.soap.ignoreme = ignoreme;
	level.player.ignoreme = ignoreme;
	level.barracus.ignoreme = ignoreme;
	level.hannibal.ignoreme = ignoreme;
	level.Murdock.ignoreme = ignoreme;
}

hack_shadow_quality()
{
	vehicle_node_trigger_wait("alpha_jump_start_node");
	setsaveddvar( "sm_sunSampleSizeNear", 0.60 );// to see the chopper shadow better
	
	vehicle_node_trigger_wait("barrels_explode_node");
	
	setsaveddvar( "sm_sunSampleSizeNear", 0.25 );// default	
}

manage_intro_viewdistance()
{
	if(DISABLE_INTRO_FOG_HACK)
	{
		return;
	}
	
	maps\_utility::vision_set_fog_changes( "payback_intro1", 0 );	
	SetCullDist(15000);
	
	vehicle_node_trigger_wait("barrels_explode_node");
	
	wait 0.5;
	
	SetCullDist(0);
	maps\_utility::vision_set_fog_changes( "payback", 1.0 );	
	
}

reset_chopper_treadfx()
{
	vehicle_node_trigger_wait("barrels_explode_node");
	
	//wait 8.0;
	
	maps\_treadfx::main( "script_vehicle_payback_hind");
}

bravo_wheel_skidmark_hack()
{
	self.tagleftWheelHack  = self setup_wheel_rubicon_treadmark_tag("tag_wheel_back_left");
	self.tagrightWheelHack = self setup_wheel_rubicon_treadmark_tag("tag_wheel_back_right");	
}


setup_wheel_rubicon_treadmark_tag(wheeltag)
{
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo(self, wheeltag, (0,0,0),(-90,0,0));
	return tag_origin;	
}

intro_slamzoom()
{
	
	
	//spawn an entity up above the vehicle for a snap zoom.
	level.snap_zoom_start_ent = spawn_tag_origin();
	level.snap_zoom_start_ent.origin = level.alpha_hummer getTagOrigin(CONST_PLAYER_LINKTO);
	level.snap_zoom_start_ent.angles = level.alpha_hummer.angles;
	
	level.player PlayerSetStreamOrigin( level.snap_zoom_start_ent.origin );

	level.snap_zoom_start_ent.origin += (0,0, 4000);	
	
			
	level.snap_zoom_end_ent = spawn_tag_origin();	
	level.snap_zoom_end_ent.origin = level.alpha_hummer getTagOrigin(CONST_PLAYER_LINKTO);
	level.snap_zoom_end_ent.angles = level.alpha_hummer.angles;
	
	level.snap_zoom_end_ent linkto(level.alpha_hummer, CONST_PLAYER_LINKTO, (0,0,0), (0,0,0));
			
	ground_origin = level.snap_zoom_end_ent.origin; 
	ground_angles = level.snap_zoom_end_ent.angles; 
	
	start_ent = level.snap_zoom_start_ent;
	
	start_angles = start_ent.angles;
	start_origin = start_ent.origin;
		
	//move the ground origin ahead to try and predict where the hummer will be
	lerp_time = 1.0;
	hummer_speed = 38;
	hummer_dir = anglestoforward(level.alpha_hummer.angles);
	offset = hummer_dir * lerp_time * hummer_speed * CONST_MPHTOIPS * .9;
	ground_origin += offset;
	start_origin += offset;

	//wait(0.95);
	aud_send_msg("player_slamzoom"); // AUDIO: for slamzoom sound timing
		
	flying_ent = Spawn( "script_origin", start_origin );

	angles = VectorToAngles( ground_origin - start_origin );
	flying_ent.angles = (angles[0], start_ent.angles[1], angles[2]);
	
	org = level.player.origin;
	level.player PlayerLinkTo( flying_ent, undefined, 1, 0, 0, 0, 0 );
	level.player SetOrigin( flying_ent.origin );

	flying_ent MoveTo( ground_origin, lerp_time, 0, 0.5 );
	level.player LerpFOV( 65, 2.5 );
	
	wait(lerp_time - .3);//wait( 1.0 );
	
	flying_ent RotateTo( ground_angles, 0.3, 0.15, 0.15 );
	
	wait( 0.3 );
	
	level notify("slam_zoom_done");
	SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	level.player FreezeControls( false );

	
	level.player PlayerClearStreamOrigin();

	// Clean up Ents
	wait .1;
	flying_ent Delete();
}

