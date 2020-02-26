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
	
}

// nate

guy_snipe( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
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
