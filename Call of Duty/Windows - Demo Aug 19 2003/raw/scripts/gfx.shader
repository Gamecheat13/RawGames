// GFX.SHADER
// 
// this file contains shaders that are used by the programmers to
// generate special effects not attached to specific geometry.  This
// also has 2D shaders such as fonts, etc.
//

white
{
	{
		map *white
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
	}
}

// the background for the netgraph
lagometer
{
	nopicmip
	{
		map gfx/2d/lag.tga
	}
}

// blinked on top of lagometer when connection is interrupted
disconnected
{
	nopicmip
	{
		map gfx/2d/net.tga
	}
}

// console background
console
{
	{
		map $whiteimage
		rgbGen constLighting ( 0.15 0.15 0.15 )
	}
}

//==========================================================================

dlightshader 	// this one is the 'default' dlight shader blob
{
	nofog
	{
		map $dlight
		rgbGen exactVertex
		blendFunc GL_DST_COLOR GL_ONE
		texGen lightmap
		depthFunc equal
	}
}

negdlightshader
{
	{
		map $dlight
		blendFunc GL_ZERO GL_ONE_MINUS_SRC_COLOR
	}
}

// markShadow is the very cheap blurry blob underneath the player
markShadow
{
	nofog
	polygonOffset
	{
		map textures/sfx/shadow_soft.tga
		blendFunc GL_ZERO GL_ONE_MINUS_SRC_COLOR
		rgbGen exactVertex
	}	
}

// wake is the mark on water surfaces for paddling players
wake
{
	{
		map clamp textures/sfx/splashalpha.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	//	blendFunc blend
		rgbGen vertex
		tcMod stretch sin 1 0.2 0 0.2 
	//	alphaGen sin 0.5 0.3 0 0.2 
	//	rgbGen wave sin .7 .07 .25 .5
		rgbGen wave sin 0.3 0.3 0 0.2
	}
//	{
//		map clamp textures/sfx/splashalpha.tga
//	//	blendFunc GL_ONE GL_ONE
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//	//	tcMod stretch sin .9 0.05 0 0.5
//	//	rgbGen wave sin .7 .3 .25 .5
//		tcMod stretch sin .9 0.03 0 0.5
//		rgbGen wave sin .7 .07 .25 .5
//	}	
}

// this version is for projectiles/etc entering/leaving water
wakeAnim
{
	{
		map clamp textures/sfx/splashalpha.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
//		alphaGen wave 0 1 0.5 1
		tcMod stretch sin 0 1 0 .25
	}	
}

viewFadeBlack
{
	sort nearest
	{
		map *white
		blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		rgbGen wave square 0 0 0 0	// just solid black
		alphaGen entity
	}	
}

// viewBloodBlend gives the blended directional cue when you get hit
viewBloodBlend1
{
	sort nearest
	{
		map gfx/2d/viewblood1.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identityLighting
		alphaGen vertex
	}
}

viewBloodBlend2
{
	sort nearest
	{
		map gfx/2d/viewblood2.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identityLighting
		alphaGen vertex
	}
}

viewBloodBlend3
{
	sort nearest
	{
		map gfx/2d/viewblood3.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identityLighting
		alphaGen vertex
	}
}

viewBloodBlend4
{
	sort nearest
	{
		map gfx/2d/viewblood4.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identityLighting
		alphaGen vertex
	}
}

viewBloodBlend5
{
	sort nearest
	{
		map gfx/2d/viewblood5.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identityLighting
		alphaGen vertex
	}
}

waterBubble
{
	sort underwater
	cull none
	entityMergable		// allow all the sprites to be merged together
	{
		map textures/sfx/waterbubble.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

bloodPool
{
	cull none
	entityMergable		// allow all the sprites to be merged together
	{
		map sprites/blood_splat.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

smokePuff
{
	nofog
	cull none
	entityMergable		// allow all the sprites to be merged together
	{
		map textures/sfx/smokepuff.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

// Rafael - cannon
smokePuffdirty
{
	cull none
	entityMergable		// allow all the sprites to be merged together
	{
		map textures/sfx/smokepuff_d.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

// Rafael - black smoke
// prerotated texture for smoke
smokePuffblack1
{
//	cull none
//	entityMergable		// allow all the sprites to be merged together
//	{
//		map textures/sfx/smokepuff_b1.tga
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//		alphaGen vertex
//	}

//	nofog
	cull none
	{
		map textures/sfx/smokepuff_b1.tga
	//	blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA	// (SA) I put it back for DM
		alphaGen vertex
	}
}

smokePuffblack2
{
//	cull none
//	entityMergable		// allow all the sprites to be merged together
//	{
//		map textures/sfx/smokepuff_b2.tga
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//		alphaGen vertex
//	}

//	nofog
	cull none
	{
		map textures/sfx/smokepuff_b2.tga
	//	blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA	// (SA) I put it back for DM
		alphaGen vertex
	}
}

smokePuffblack3
{
//	cull none
//	entityMergable		// allow all the sprites to be merged together
//	{
//		map textures/sfx/smokepuff_b3.tga
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//		alphaGen vertex
//	}

//	nofog
	cull none
	{
		map textures/sfx/smokepuff_b3.tga
	//	blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA	// (SA) I put it back for DM
		alphaGen vertex
	}
}

smokePuffblack4
{
//	cull none
//	entityMergable		// allow all the sprites to be merged together
//	{
//		map textures/sfx/smokepuff_b4.tga
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//		alphaGen vertex
//	}

//	nofog
	cull none
	{
		map textures/sfx/smokepuff_b4.tga
	//	blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA	// (SA) I put it back for DM
		alphaGen vertex
	}
}

smokePuffblack5
{
//	cull none
//	entityMergable		// allow all the sprites to be merged together
//	{
//		map textures/sfx/smokepuff_b5.tga
//		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
//		rgbGen vertex
//		alphaGen vertex
//	}
	
//	nofog
	cull none
	{
		map textures/sfx/smokepuff_b5.tga
	//	blendFunc GL_ZERO GL_ONE_MINUS_SRC_ALPHA
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA	// (SA) I put it back for DM
		alphaGen vertex
	}
}

flare
{
	cull none
	sort corona
	{
		map gfx/misc/corona_temp.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
	}
}

flareShader
{
	nofog		// don't fog
	nopicmip	// use hi-res tex all the time
	cull none
	entityMergable
	sort corona
	{
		map gfx/misc/corona_temp.tga // new one made by TALON

		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
	}
}

sunFlareShader
{
	nofog		// don't fog
	nopicmip	// use hi-res tex all the time
	cull none
	sort corona
	{
		map gfx/misc/corona_temp.tga
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
	}
}

sun
{
	nofog
	cull none
	{
		map gfx/misc/sun.tga
//		blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA
//		blendFunc GL_ONE GL_ONE
		blendFunc blend
		rgbGen vertex
	}
}
