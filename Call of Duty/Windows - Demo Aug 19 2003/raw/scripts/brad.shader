// Shader for russian barge flag
skins/russianboatflag
{
	surfaceparm cloth
	cull none
	deformVertexes flap s 2 sin 2 3 0 5
	{
		map skins/russianboatflag
		rgbGen lightingDiffuse
	}
}

skins/russianboatflag_noflap
{
	surfaceparm cloth
	cull none
	{
		map skins/russianboatflag
		rgbGen lightingDiffuse
	}
}

// Spinning prop for planes
skins/stuka_prop
{
	surfaceparm metal
	cull none
	{
		map clamp skins/stuka_prop
		tcMod rotate 5000
		blendFunc blend
	}
}

// light beam for Searchlight
skins/gradient1
{
	//qer_editorimage textures/sfx/gradient1
	//{
	surfaceparm nonsolid
	surfaceparm noshadow
	//cull none
	nopicmip
{
		map clamp textures/sfx/gradient1
		blendfunc blend
		rgbGen identityLighting
		rgbGen dot 0 1.5
		}	
{
		map textures/sfx/dustair
		tcmod scroll 0 0.1
		blendFunc add		
	}
}

// Alternate version
skins/searchlight_beam
{
	surfaceparm nonsolid
	surfaceparm noshadow
	DeformVertexes autosprite2
	{
		requires GL_ARB_texture_env_add
		map clamp skins\searchlight_beam
		rgbGen identityLighting
		blendfunc add
//	nextbundle
//		map textures/sfx/dustair
//		tcmod scroll 0 0.1
//		blendfunc add
	}

}

skins/parachute_inside
{
	surfaceparm cloth
	//sort innerBlend
	polygonoffset
	//nomipmaps
	//nopicmip
	{
		map skins\parachute_inside.tga
		rgbGen lightingDiffuse
		//blendFunc blend
	}
}

skins/parachute_outside
{
	surfaceparm cloth
	polygonoffset2
	{
		map skins\parachute_outside.tga
		rgbGen lightingDiffuse
	}
}


// Shader for test fire
skins/firetexture
{
	surfaceparm nonsolid
	surfaceparm noshadow
	//cull none
	//nopicmip
	deformVertexes flap s 2 sin 2 2 0 5

{
		map skins/firetexture
		blendfunc add
		rgbGen identityLighting
		//rgbGen dot 0 1.5
		nextbundle
		map textures/sfx/firemask	
	}
{
		map textures/sfx/firescroll
		tcmod scroll -1 1.5
		blendFunc add
		nextbundle
		map textures/sfx/firemask	
	}

}

////stalin statue////

skins/stalin_statue
{
	surfaceparm metal
	nomipmaps
	nopicmip
	{
		map textures/sfx/environmap_bronze.tga
		tcgen environment
		rgbgen lightingdiffuse
	}
	{
		map skins/stalin_statue
		blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA
		rgbgen lightingdiffuse
		//blendFunc blend
		//rgbGen identity
	//nextbundle
		//map $lightmap
	}
}