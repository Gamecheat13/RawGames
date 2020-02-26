#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;

#using_animtree ("generic_human");
main()
{
	
	animated_model_setup();
	
	level.scr_anim[ "razorwire_guy" ][ "razor_setup" ] = %armada_wire_setup_guy;
	level.scr_anim[ "barbed_wire_long" ][ "razor_setup" ] = %armada_wire_setup_wire;
	level.scr_anim[ "razorwire_guy" ][ "razor_idle" ] = %armada_wire_setup_guy_startidle;
	level.scr_anim[ "barbed_wire_long" ][ "razor_idle" ] = %armada_wire_setup_wire_startidle;
	level.scr_anim[ "razorwire_guy" ][ "razor_endidle" ] = %armada_wire_setup_guy;
	level.scr_anim[ "barbed_wire_long" ][ "razor_endidle" ] = %armada_wire_setup_wire_endidle;
	level.scr_animtree[ "barbed_wire_long" ] = #animtree;	
	
	
	level.scr_sound[ "price" ][ "stand_down" ]				= "armada_pri_allteamsstanddown";
	level.scr_sound[ "price" ][ "roger_hq" ]				= "armada_pri_rogerhq";
	level.scr_sound[ "price" ][ "heads_up" ]				= "armada_pri_headsup";
	//level.price anim_single_queue( level.price, "heads_up" );
	
	level.scr_sound[ "generic" ][ "tvstation" ]				= "armada_gm1_tvstation";
	level.scr_sound[ "price" ][ "get_into_pos" ]				= "armada_usl_getintoposition";

}

// nate

guy_snipe( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	self notify ("ropeidleend");
	
	if( pos == 2 )
	{
		animontag( guy, animpos.sittag, %armada_blackhawk_sniper_idle );
	}
	thread guy_idle( guy, pos );
}





#using_animtree ("animated_props");
animated_model_setup()
{
	level.anim_prop_models["foliage_tree_palm_tall_3"]["still"] = %palmtree_tall3_still;
	level.anim_prop_models["foliage_tree_palm_tall_3"]["strong"] = %palmtree_tall3_sway;
	level.anim_prop_models["foliage_tree_palm_med_2"]["still"] = %palmtree_med2_still;
	level.anim_prop_models["foliage_tree_palm_med_2"]["strong"] = %palmtree_med2_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["still"] = %palmtree_bushy1_still;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["strong"] = %palmtree_bushy1_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["still"] = %palmtree_bushy2_still;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["strong"] = %palmtree_bushy2_sway;
	level.anim_prop_models["foliage_tree_palm_tall_2"]["still"] = %palmtree_tall2_still;
	level.anim_prop_models["foliage_tree_palm_tall_2"]["strong"] = %palmtree_tall2_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_3"]["still"] = %palmtree_bushy3_still;
	level.anim_prop_models["foliage_tree_palm_bushy_3"]["strong"] = %palmtree_bushy3_sway;
	level.anim_prop_models["foliage_tree_palm_med_1"]["still"] = %palmtree_med1_still;
	level.anim_prop_models["foliage_tree_palm_med_1"]["strong"] = %palmtree_med1_sway;
	level.anim_prop_models["foliage_tree_palm_tall_1"]["still"] = %palmtree_tall1_still;
	level.anim_prop_models["foliage_tree_palm_tall_1"]["strong"] = %palmtree_tall1_sway;
}


#using_animtree ("vehicles");

player_heli_ropeanimoverride()
{
	// oh no, I've gone and made the fastrope very difficult to simply override animations so I'm overriding the whole damn thing for the ride in on armada - Nate.
	
	tag = "TAG_FastRope_RI";
	model = "rope_test_ri";
	snipeanim = %armada_blackhawk_sniper_idle_fastrope80;
	idleanim = %armada_blackhawk_sniper_idle_loop_fastrope80;
	dropanim = %armada_blackhawk_sniper_drop_fastrope80;
	
	array = [];
	array[ "TAG_FastRope_RI" ] = spawnstruct();
	self.attach_model_override = array;  // gets rid of blackhawks standard fastrope stuff for this rig

	rope = spawn("script_model", level.player.origin);
	rope setmodel (model);
	rope linkto (self, tag, (0,0,0),(0,0,0));
	rope useanimtree (#animtree);
	
	flag_wait ("snipefromheli");
	//self notify ("groupedanimevent","snipe");  //tells the ai to snipe.
	//maps\_vehicle_aianim::animontag( rope, tag, snipeanim );
	thread player_heli_ropeanimoverride_idle( rope, tag, idleanim );
	self waittill ("unload");
	thread maps\_vehicle_aianim::animontag( rope, tag, dropanim );
	wait getanimlength( dropanim ) - .2;

 	rope unlink();
	wait 10;
	rope delete();  // possibly do something to delete when the player is not looking at it.	
}

player_heli_ropeanimoverride_idle( guy, tag, animation )
{
	self endon ("unload");
	while(1)
		maps\_vehicle_aianim::animontag( guy, tag, animation );
}