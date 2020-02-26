// Environment mapped transparent workshop window for austria
textures/austria/windows/workshopwindow
{
	qer_editorimage textures/austria/windows/shop_window.tga
	surfaceparm glass
	surfaceparm trans
	//surfaceparm noimpact // this made grenades disappear when they hit this window
	surfaceparm nomarks
	surfaceparm nonsolid
	surfaceparm playerclip
	surfaceparm monsterclip
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .1
		blendFunc blend
	}
	{
		map textures/austria/windows/shop_window.tga
		rgbGen exactVertex
		alphaFunc GE128
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/austria/windows/shop_window.tga
		rgbGen exactVertex
		alphaFunc GE128
		blendFunc add
	nextbundle
		map $dlight
	}
}

textures/austria/windows/workshopwindow2
{
	qer_editorimage textures/austria/windows/shop_window2.tga
	surfaceparm glass
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .1
		blendFunc blend
	}
	{
		map textures/austria/windows/shop_window2.tga
		rgbGen exactVertex
		alphaFunc GE128
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/austria/windows/shop_window2.tga
		rgbGen exactVertex
		alphaFunc GE128
		blendFunc add
	nextbundle
		map $dlight
	}
}

textures/battleship/deck_flag
{
	surfaceparm trans
	polygonOffset
	{
		map textures/battleship/deck_flag_np
		blendFunc filter
	}
}

textures/battleship/deckhatch_decal
{
	surfaceparm metal
	polygonOffset
	{
		map textures/battleship/deckhatch_decal
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
}

// Shaders for battleship flag
skins/shipflag_np
{
	surfaceparm carpet
	surfaceparm trans
	cull none
	deformVertexes flap s 32 sin 4 8 0 .75
	{
		map skins/shipflag_np
		alphaFunc GE128
		rgbGen lightingDiffuse
	}
}

skins/shipflag2_np
{
	surfaceparm carpet
	surfaceparm trans
	cull none
	deformVertexes flap s 32 sin 4 8 0 .75
	{
		map skins/shipflag2_np
		alphaFunc GE128
		rgbGen lightingDiffuse
	}
}

textures/battleship2a/shipdoor2a
{
	qer_editorimage textures/editorimages/fakewindow1a.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map textures/battleship/shipdoor2a
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor2a.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship2a/shipdoor2b
{
	qer_editorimage textures/editorimages/fakewindow1b.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map textures/battleship/shipdoor2b
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor2b.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship2a/shipdoor2a_trans
{
	qer_editorimage textures/editorimages/clearwindow1a.tga
	surfaceparm metal
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/shipdoor2a_trans
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor2a_trans.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/shipdoor2b_trans
{
	qer_editorimage textures/editorimages/clearwindow1b.tga
	surfaceparm metal
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/shipdoor2b_trans
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor2b_trans.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/shipdoor3a
{
	qer_editorimage textures/editorimages/fakewindow2a.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map textures/battleship/shipdoor3a
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor3a.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/shipdoor3b
{
	qer_editorimage textures/editorimages/fakewindow2b.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map textures/battleship/shipdoor3b
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor3b.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/shipdoor3a_trans
{
	qer_editorimage textures/editorimages/clearwindow2a.tga
	surfaceparm metal
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/shipdoor3a_trans
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor3a_trans.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/shipdoor3b_trans
{
	qer_editorimage textures/editorimages/clearwindow2b.tga
	surfaceparm metal
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/shipdoor3b_trans
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/shipdoor3b_trans.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/bridgewindow
{
	qer_editorimage textures/editorimages/bridgewindow_ed.tga
	surfaceparm glass
	surfaceparm trans
	sort outerBlend
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/bridgewindow
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/bridgewindow.tga
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/bridgewindow2
{
	qer_editorimage textures/editorimages/bridgewindow2_ed.tga
	surfaceparm glass
	surfaceparm trans
	sort innerBlend
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .25
		blendFunc blend
	}
	{
		map textures/battleship/bridgewindow2
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/battleship/bridgewindow2
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

skins/yacht_window
{
	//qer_editorimage textures/editorimages/bridgewindow2_ed.tga
	surfaceparm glass
	surfaceparm trans
	//{
	//	map skins/yacht_window
	//	map textures/sfx/environmap_1day.jpg
	//	tcGen environment
	//	rgbGen exactVertex
	//	alphaGen const .25
	//	blendFunc blend
	//
	//}
	{
		map skins/yacht_window
		alphaFunc GE128
		//blendFunc blend
		rgbGen lightingDiffuse
	}
}

skins/38cm_shell
{
	//qer_editorimage textures/editorimages/fakewindow2b.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map skins/38cm_shell
		blendFunc blend
		rgbGen lightingDiffuse
	}
}


skins/38cm_fuze
{
	//qer_editorimage textures/editorimages/fakewindow2b.tga
	surfaceparm metal
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map skins/38cm_fuze
		blendFunc blend
		rgbGen lightingDiffuse
	}
}

// Window for dam control room
textures/industrial/dam_window
{
	//qer_editorimage textures/editorimages/dam_window.tga
	surfaceparm glass
	surfaceparm trans
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .1
		blendFunc blend
	}
	{
		map textures/industrial/dam_window
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/industrial/dam_window
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

// Floor for dam with env mapped brass borders
textures/industrial/dam_stone_floor
{
	qer_editorimage textures/editorimages/fakewindow2b.tga
	surfaceparm rock
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .25
		//blendFunc blend
	}
	{
		map textures/industrial/dam_stone_floor
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
	{
		perlight
		map textures/industrial/dam_stone_floor
		rgbGen exactVertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map $dlight
	}
}

textures/battleship/flagedge
{
	qer_editorimage textures/battleship/whiteplanks
	surfaceparm wood
	{
		map textures/battleship/whiteplanks.tga
		rgbGen const ( .584 0 0 )
	nextbundle
		map $lightmap
	}
}

textures/battleship/flagfore
{
	qer_editorimage textures/battleship/whiteplanks
	surfaceparm wood
	{
		map textures/battleship/whiteplanks.tga
		rgbGen exactVertex
	nextbundle
		map textures/battleship/deckflag_np.tga
		//tcMod scale .25 .25
		tcMod transform .25 0 0 .25 .375 .4375
	}
	{
		map $lightmap
		blendFunc filter
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		perlight

		map textures/battleship/whiteplanks.tga
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/battleship/deckflag_np.tga
		//tcMod scale .25 .25
		tcMod transform .25 0 0 .25 .375 .4375
		blendFunc filter
	nextbundle
		map $dlight
		blendFunc filter
	}
}

textures/battleship/flagaft
{
	surfaceparm wood
	qer_editorimage textures/battleship/whiteplanks
	{
		map textures/battleship/whiteplanks.tga
		rgbGen exactVertex
	nextbundle
		map textures/battleship/deckflag_np.tga
		//tcMod scale .25 .25
		tcMod transform .25 0 0 .25 .375 .46875
	}
	{
		map $lightmap
		blendFunc filter
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		perlight

		map textures/battleship/whiteplanks.tga
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map textures/battleship/deckflag_np.tga
		//tcMod scale .25 .25
		tcMod transform .25 0 0 .25 .375 .46875
	nextbundle
		map $dlight
	}
}

// Experimental anti-mip-out railing shaders
textures/battleship/railing
{
	qer_editorimage textures/battleship/metal_masked@railing.tga
	surfaceparm metal
	surfaceparm trans
	surfaceparm alphashadow
	surfaceparm nomarks
	surfaceparm nonsolid
	surfaceparm playerclip
	surfaceparm monsterclip
	//nomipmaps
	nopicmip
	{
		map textures/battleship/railing_verticalpiece.tga
		rgbGen exactVertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
	{
		map textures/battleship/railing_horizontalpiece.tga
		rgbGen exactVertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}
textures/battleship/railing2
{
	qer_editorimage textures/battleship/metal_masked@railing2.tga
	surfaceparm metal
	surfaceparm trans
	surfaceparm alphashadow
	surfaceparm nomarks
	surfaceparm nonsolid
	surfaceparm playerclip
	surfaceparm monsterclip
	//nomipmaps
	nopicmip
	{
		map textures/battleship/railing2_verticalpiece.tga
		rgbGen exactVertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
	{
		map textures/battleship/railing_horizontalpiece.tga
		rgbGen exactVertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}


// Shaft for dam turbines
textures/industrial/turbine_shaft
{
	surfaceparm metal
	surfaceparm nomarks
	{
		//cubemap env/chateau
		//tcGen reflection
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		//alphaGen const .5
		//blendFunc blend
	}
	{
		map textures/industrial/turbine_shaft.tga
		tcMod scroll 5 0
		blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
}

textures/industrial/turbine_shaft_top
{
	surfaceparm metal
	surfaceparm nomarks
//	{
//		//cubemap env/chateau
//		//tcGen reflection
//		map textures/sfx/environmap_1day.jpg
//		tcGen environment
//		alphaGen const .1
//		blendFunc blend
//	}
	{
		map textures/industrial/turbine_shaft_top.tga
		tcMod rotate 1800
		//blendFunc blend
		rgbGen exactVertex
	nextbundle
		map $lightmap
	}
}
///////////////////////////////////
//shaders for light globe on yard lamp model
///////////////////////////////////

skins/whiteglobe
{
	surfaceparm glass
	surfaceparm trans
	{
		map skins/whiteglobe.tga
		//alphagen 0.3
		blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}
skins/light_sprite
{
	surfaceparm trans
	surfaceparm glass
	surfaceparm noshadow
	deformvertexes autosprite
	{
		map skins/light_sprite.tga
		//blendfunc blend
		blendfunc add
		//blendfunc GL_SRC_ALPHA GL_ONE
		rgbGen identityLighting
	}
}

////////////////////////////////////
//shaders for lit exterior lamps
////////////////////////////////////

skins/exteriorlamp1_on
{
	surfaceparm metal
	surfaceparm trans
	{
		map skins/exteriorlamp1_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/exteriorlamp2_on
{
	surfaceparm metal
	surfaceparm trans
	{
		map skins/exteriorlamp2_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/streetlight1a_on
{
	surfaceparm metal
	surfaceparm trans
	{
		map skins/streetlight1a_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/streetlight2a_on
{
	surfaceparm metal
	surfaceparm trans
	{
		map skins/streetlight2a_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/ceilinglight1on
{
	surfaceparm metal
	//surfaceparm trans
	{
		map skins/ceilinglight1on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/ind_lamp1_on
{
	surfaceparm metal
	//surfaceparm trans
	{
		map skins/ind_lamp1_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}
///////////////////////////////////
//shader for hanging industrial lamp
///////////////////////////////////
skins/lightbulb_on
{
	surfaceparm glass
	surfaceparm trans
	{
		map skins/lightbulb_on.tga
		//alphagen 0.5
		blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

/////////////////////////////////////////////
//red cagelamp model textures
/////////////////////////////////////////////
skins/redbulb_on
{
	surfaceparm glass
	surfaceparm trans
	{
		map skins/redbulb_on.tga
		//alphagen 0.5
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}
skins/light_sprite_red
{
	surfaceparm trans
	surfaceparm glass
	surfaceparm noshadow
	//deformvertexes autosprite
	{
		map skins/light_sprite_red.tga
		//blendfunc blend
		//blendfunc add
		blendfunc GL_SRC_ALPHA GL_ONE
		rgbGen identityLighting
	}
}
///////////////////////////////////
//shaders for lit lantern
///////////////////////////////////

skins/lanternglass
{
	surfaceparm glass
	surfaceparm trans
	{
		map skins/lanternglass.tga
		alphagen const 0.95
		blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

skins/lantern_on
{
	surfaceparm metal
	//surfaceparm trans
	{
		map skins/lantern_on.tga
		//alphagen 0.3
		//blendfunc blend
		//rgbgen lightingDiffuse
		rgbGen identityLighting
	}
}

///////////////////////////////////////////////
//pathfinder holophane lamp corona
///////////////////////////////////////////////

skins/green_corona
{
	surfaceparm trans
	surfaceparm glass
	surfaceparm noshadow
	deformvertexes autosprite
	{
		map skins/green_corona.tga
		//blendfunc blend
		blendfunc GL_SRC_ALPHA GL_ONE
		rgbGen identityLighting
	}
}
////////////////////////////////////////////////
//shader for bomb timer clockface
////////////////////////////////////////////////

skins/timer_face
{
	surfaceparm metal
	{
		map skins/timer_face
		rgbgen lightingdiffuse
	}
	{
		map clamp gfx/misc/timer_hand.dds
		alphafunc ge128
		tcmod rotate -6
		rgbgen lightingdiffuse
	}
}

///////////////////////////////////////////////////////
//shaders to fix sorting on yachts
///////////////////////////////////////////////////////

skins/yacht_int_floor
{
	surfaceparm wood
	sort boathull
	{
		map skins/yacht_int_floor
		rgbgen lightingdiffuse
		depthfunc always
	}
}

skins/yacht_int_side
{
	surfaceparm wood
	sort boathull
	{
		map skins/yacht_int_side
		rgbgen lightingdiffuse
		depthfunc always
	}
}