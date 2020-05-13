//(Frame numbers refer to burned in frames in movie files)
//\\cyprus\share\Midnight\Users\v-jidono\Playblasts\m10\spacesuck\SpaceSuck_part_one_v004.mov
// -     x117                door opening
// -     x126                ship hitting
// -     x424                exit vehiclebay
// \\cyprus\share\Midnight\Users\v-jidono\Playblasts\m10\spacesuck\SpaceSuck_part_two_v004.mov
// -	x128               First arm hit 
// -	x279               Debris/cruiser collision
// -	x350               Grunt impact 1
// -	x380               Grunt impact 2
// -	x393               Hand grab
// -	x407               grunt impact 3 (unless the grunt goes through that geom)
// -	x697               Chief splat! (damage effect)



// scratchboard section - DELETE ME ----------------------------------------
//    sleep_s(1)
//    effect_new( environments\solo\m10_crash\fx\lights\cry_tube_light.effect, 
//                fx_tube_light );
//
//    effect_new_on_object_marker(
//                 environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, 
//                 beac_2_mag_3, 
//                 left_sparks);
//
// -------------------------------------------------------------------------


// x117 When the door opens and chief starts getting sucked
// ~ frame 0 of the vignette
script static void fx_spacesuck_dooropening()
    dprint ("fx_spacesuck_dooropening");
    // effect on p_door1 marker, behind camera, atmosphere/debris through door
    effect_new( environments\solo\m10_crash\fx\atmosphere\decompression_vby_door.effect, fx_vby_atmos_door_01 ); 

end


// x126 When the ship hits the vehicle bay and starts ripping it open
// ~ frame 0 of the vignette
script static void fx_spacesuck_shiphitting()
    dprint ("fx_spacesuck_shiphitting");
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_sparks_1 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_sparks_2 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_sparks_3 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_sparks_4 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_sparks_5 );

    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_hole_1 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_hole_2 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_hull_hole_3 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_ceiling_1 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\sparks\sparks_decomp_large.effect, vb_hull, fx_ceiling_2 );


    // p_pack   3-4 big small exlposions
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\explosion_vby_decomp_quick.effect, vb_hull, flying_lock01_3 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\explosion_vby_decomp_quick.effect, vb_hull, fx_vb_locks_5 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\explosion_vby_decomp_quick.effect, vb_hull, fx_vb_locks_3 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\explosion_vby_decomp_quick.effect, vb_hull, fx_vb_locks_4 );

end


// x424 Elvis has left the building (Chief is sucked out into space)
// ~ frame 313 of the vignette
script static void fx_spacesuck_exitvehiclebay()
    dprint ("fx_spacesuck_exitvehiclebay");
    // chief damage
    // start debris field flying
    ////effect_new_on_object_marker( environments\solo\m10_crash\fx\debris\debris_space_falling_maw.effect, maw_door, maw_eye_center );
    effect_attached_to_camera_new( environments\solo\m10_crash\fx\debris\debris_space_falling_maw.effect );

end


// x128 First arm hit when chief hits debris
// ~ frame 500 of the vignette
script static void fx_spacesuck_armhit1()
    dprint ("fx_spacesuck_armhit1");
    // sparks, dusthit from arm
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_11 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_12 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_13 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_15 );
    damage_players(objects\characters\monitor\damage_effects\first_hit.damage_effect);
end


// x279 Debris/cruiser collision
// ~ frame 645 of the vignette
script static void fx_spacesuck_cruisercolldebris()
    dprint ("fx_spacesuck_cruisercolldebris");

    // p_cruiser, 1 big explosion, debris
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\spsuck_cruiser_impact_explosion.effect,vb_ship1, fx_ship_explode05 );

    // p_cruiser, 2-3 small explosions, debris
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\spsuck_cruiser_impact_explosion_small.effect,vb_ship1, fx_ship_explode01 );
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\spsuck_cruiser_impact_explosion_small.effect,vb_ship1, fx_ship_explode02 );

    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\spsuck_cruiser_impact_explosion_small.effect,vb_ship1, fx_ship_explode04 );

end


// x350 Grunt impact 1
// ~ frame 718 in the vignette
script static void fx_spacesuck_gruntimpact1()
    dprint ("fx_spacesuck_gruntimpact1");
    // splat impact effect
    effect_new_on_object_marker( environments\solo\m10_crash\fx\blood\grunt_collision_blood_spray.effect, sq_vb_grunt, body );
//NOTE need to find ship name

    // trailing blood effect
    effect_new_on_object_marker( environments\solo\m10_crash\fx\blood\grunt_blood_trailing.effect, sq_vb_grunt, body );

end


// x380 Grunt impact 2
// ~ frame 748 in the vignette
script static void fx_spacesuck_gruntimpact2()
    dprint ("fx_spacesuck_gruntimpact2");
    // splat impact effect
    effect_new_on_object_marker( environments\solo\m10_crash\fx\blood\grunt_collision_blood_spray.effect, sq_vb_grunt, body );

    // trailing blood effect
    effect_new_on_object_marker( environments\solo\m10_crash\fx\blood\grunt_blood_trailing.effect, sq_vb_grunt, body );

end


// x393 Hand grab
// ~ frame 760
script static void fx_spacesuck_handgrab()
    dprint ("fx_spacesuck_handgrab");

    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_20 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_21 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_22 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_23 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_24 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_25 );
    effect_new( environments\solo\m10_crash\fx\sparks\sparks_space_impact_small.effect, fx_debris_armhit_26 );

end

// x393 Hand grab
// ~ frame 760
script static void fx_ship_explosion_2()
    dprint ("fx_ship_explosion_2");

    // explosion to travel through
    effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\spsuck_cruiser_impact_explosion_engulfing.effect, vb_ship1, fx_ship_explode05 );

    // have the grunt trail some fire, needs to be timed to happen after he is engulfed in flames
    effect_new_on_object_marker( environments\solo\m10_crash\fx\fire\fire_flying_grunt.effect, sq_vb_grunt, body );

end

// x407 grunt impact 3 (unless the grunt goes through that geom)
// ~ frame 875
script static void fx_spacesuck_gruntimpact3()
    dprint ("fx_spacesuck_gruntimpact3");
    // splat impact effect
    //effect_new_on_object_marker( environments\solo\m10_crash\fx\blood\grunt_collision_blood_spray.effect, sq_vb_grunt, body );

end



// x697 Chief splat! (damage effect)
// ~ frame 949
script static void fx_spacesuck_chiefsplat()
    dprint ("fx_spacesuck_chiefsplat");
    // sheild effect
    object_can_take_damage(player0);
    object_can_take_damage(player1);
    object_can_take_damage(player2);
    object_can_take_damage(player3);
    damage_players(objects\characters\monitor\damage_effects\first_hit.damage_effect);

end



