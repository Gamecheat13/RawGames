//
// These are shaders for particles and other effects in game
//

bloodTrail
{
	cull disable
	{
		map textures/sfx/bloodtrail.tga
		blendFunc blend
	}
}

blood_dot1
{
	polygonOffset
	{
		map textures/sfx/blood_dot1.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

blood_dot2
{
	polygonOffset
	{
		map textures/sfx/blood_dot2.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

blood_dot3
{
	polygonOffset
	{
		map textures/sfx/blood_dot3.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

blood_dot4
{
	polygonOffset
	{
		map textures/sfx/blood_dot4.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

blood_dot5
{
	polygonOffset
	{
		map textures/sfx/blood_dot5.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

// wall marks
// use blendFunc GL_ZERO GL_ONE_MINUS_SRC_COLOR so that
// their "contribution" can be damped down in fog volumes
// with distance
bloodMark
{
	polygonOffset
	{
		map textures/sfx/bloodsplat.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		//rgbGen identityLighting
		rgbGen vertex
		alphaGen vertex
	}
}

//=====================================

gfx/misc/tracer
{
	cull none
	{
		map textures/sfx/tracer.tga
		blendFunc GL_ONE GL_ONE
	}
}

// Railgun trails are still used as debug aids for weapons
railDisc
{
	nofog
	sort nearest
	cull none
        deformVertexes wave 100 sin 0 3 0 2.4
	{
		map clamp gfx/misc/raildisc_mono2.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
		tcMod rotate -30
	}
}

railCore
{
	sort nearest
	cull none
	{
		map gfx/misc/railcorethin_mono.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
		tcMod scroll -1 0
	}
}

sparkFlareParticle
{
	cull none
	entityMergable
	{
		map textures/sfx/sparkflare.tga
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
		alphaGen vertex
	}
}

sparkParticle
{
	cull none
	entityMergable
	{
		map textures/sfx/spark.tga
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
		alphaGen vertex
	}
}

smokeTrail
{
	cull none
	entityMergable
	{
		map textures/sfx/smoketrail.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex
		alphaGen vertex
	}
}

smokeParticle
{
	cull none
	{
		map textures/sfx/smokepuff.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		alphaGen vertex
	}
}

bulletParticleTrail
{
	cull none
	entityMergable
	{
		map textures/sfx/bullettrail.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		alphaGen vertex
	}
}

distancehaze
{
	cull none
	entityMergable
	{
		map textures/sfx/distanthorizon_orange.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		alphaGen vertex
	}
}

textures/sfx/corona_heavy
{
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nolightmap
	deformvertexes autosprite
	{
		map textures/sfx/corona_heavy.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
	}
}

textures/sfx/corona_medium
{
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nolightmap
	deformvertexes autosprite
	{
		map textures/sfx/corona_medium.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
	}
}

textures/sfx/corona_smallbright
{
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nolightmap
	deformvertexes autosprite
	{
		map textures/sfx/corona_smallbright.tga
		blendFunc GL_ONE GL_ONE
		rgbGen vertex
	}
}

textures/sfx/corona_ship
{
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nolightmap
	deformvertexes autosprite
	{
		map textures/sfx/corona_ship.tga
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
	}
}

///////////////////////////////////////////////////////
//WET DECALS                                         //
///////////////////////////////////////////////////////
textures/sfx/wetworks1
{	
	polygonOffset
	surfaceparm water
	surfaceparm noshadow
	qer_editorimage textures/sfx/wetworks_shape
	{
		requires gl_arb_texture_cube_map
		requires gl_arb_texture_env_combine
		cubemap env/sewerpuddle
		tcgen reflection
		blendFunc blend
		rgbgen exactvertex
	nextbundle
		map textures/sfx/wetworks_shape
		texEnvCombine
		{
			rgb = INTERPOLATE_ARB(Cp,Ct,At)
			alpha = REPLACE(At)
		}
	}
}

textures/russia/walls/stalin_1wet
{	
	surfaceparm brick
	qer_editorimage textures/russia/walls/stalin_1wet.tga
/*
	{
		map textures/russia/walls/stalin_1wet.tga
		
	nextbundle
		map $lightmap
	}
	{
		requires gl_arb_texture_cube_map
		requires gl_arb_texture_env_combine
		cubemap env/sewerpuddle
		tcgen reflection
		blendFunc blend
		rgbgen exactvertex
	nextbundle
		map textures/russia/walls/stalin_1wet.tga
		texEnvCombine
		{
			rgb = INTERPOLATE_ARB(Cp,Ct,At)
			alpha = REPLACE(At)
		}
	}
*/
	{
		map textures/sfx/environmap_wet.tga
//		map textures/sfx/pondwater.tga
		tcgen environment
		//rgbgen lightingdiffuse
		//rgbgen exactvertex
		rgbGen constant 0.5 0.5 0.5
	}
	{
		map textures/russia/walls/stalin_1wet.tga
		blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA
		//blendFunc blend
		//rgbgen lightingdiffuse
	nextbundle
		map $lightmap
	}
}

textures/russia/walls/stalin_1wetdirty
{	
	surfaceparm brick
	qer_editorimage textures/russia/walls/stalin_1wetdirty.tga
/*
	{
		map textures/russia/walls/stalin_1wetdirty.tga
		
	nextbundle
		map $lightmap
	}
	{
		requires gl_arb_texture_cube_map
		requires gl_arb_texture_env_combine
		cubemap env/sewerpuddle
		tcgen reflection
		//blendFunc blend
		rgbgen exactvertex
	nextbundle
		map textures/russia/walls/stalin_1wetdirty.tga
		texEnvCombine
		{
			rgb = INTERPOLATE_ARB(Cp,Ct,At)
			alpha = REPLACE(At)
		}
	}
*/

	{
		map textures/sfx/environmap_wet.tga
//		map textures/sfx/pondwater.tga
		tcgen environment
		//rgbgen lightingdiffuse
		//rgbgen exactvertex
		rgbGen constant 0.5 0.5 0.5
	}

	{
		map textures/russia/walls/stalin_1wetdirty.tga
		blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA
		//blendFunc blend
		//rgbgen lightingdiffuse
	nextbundle
		map $lightmap
	}

}