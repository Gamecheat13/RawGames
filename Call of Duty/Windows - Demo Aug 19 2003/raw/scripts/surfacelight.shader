textures/austria/windows/litwindow1aext
{
	q3map_lightimage textures/austria/windows/litwindow1aext.blend.tga
	surfaceparm nomarks
	q3map_surfacelight 200
	{
		map textures/austria/windows/litwindow1aext.jpg
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc filter
		rgbGen identity
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 3
		map textures/austria/windows/litwindow1aext.blend.tga
		blendFunc add
		rgbGen identityLighting
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		multiplyImage identityLighting
		map textures/austria/windows/litwindow1aext.blend.tga
		blendFunc add
		rgbGen identity
	}
	{
		perlight
		map textures/austria/windows/litwindow1aext.jpg
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map $dlight
		blendFunc filter
	}
}

textures/austria/windows/litbarrackswindowext
{
	q3map_lightimage textures/austria/windows/litbarrackswindowext.blend.tga
	surfaceparm nomarks
	q3map_surfacelight 200
	{
		map textures/austria/windows/glass@barrackswindow_ext.jpg
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc filter
		rgbGen identity
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 3
		map textures/austria/windows/litbarrackswindowext.blend.tga
		blendFunc add
		rgbGen identityLighting
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		multiplyImage identityLighting
		map textures/austria/windows/litbarrackswindowext.blend.tga
		blendFunc add
		rgbGen identity
	}
	{
		perlight
		map textures/austria/windows/glass@barrackswindow_ext.jpg
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map $dlight
		blendFunc filter
	}
}

textures/austria/windows/barrackswindow2
{
	q3map_lightimage textures/austria/windows/barrackswindow2.blend.tga
	surfaceparm nomarks
	q3map_surfacelight 200
	{
		map textures/austria/windows/barrackswindow2.jpg
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc filter
		rgbGen identity
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 3
		map textures/austria/windows/barrackswindow2.blend.tga
		blendFunc add
		rgbGen identityLighting
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		multiplyImage identityLighting
		map textures/austria/windows/barrackswindow2.blend.tga
		blendFunc add
		rgbGen identity
	}
	{
		perlight
		map textures/austria/windows/barrackswindow2.jpg
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map $dlight
		blendFunc filter
	}
}

textures/austria/windows/barrackswindow3
{
	q3map_lightimage textures/austria/windows/barrackswindow3.blend.tga
	surfaceparm nomarks
	q3map_surfacelight 200
	{
		map textures/austria/windows/barrackswindow3.jpg
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc filter
		rgbGen identity
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 3
		map textures/austria/windows/barrackswindow3.blend.tga
		blendFunc add
		rgbGen identityLighting
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		multiplyImage identityLighting
		map textures/austria/windows/barrackswindow3.blend.tga
		blendFunc add
		rgbGen identity
	}
	{
		perlight
		map textures/austria/windows/barrackswindow3.jpg
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map $dlight
		blendFunc filter
	}
} 

textures/belgium/windows/snowywindow1
{
	q3map_lightimage textures/belgium/windows/snowywindow1.tga
	surfaceparm nomarks
	q3map_surfacelight 200
	{
		map textures/belgium/windows/snowywindow1.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc filter
		rgbGen identity
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB < 3
		map textures/belgium/windows/winterwindowlit.tga
		blendFunc add
		rgbGen identityLighting
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		multiplyImage identityLighting
		map textures/belgium/windows/winterwindowlit.tga
		blendFunc add
		rgbGen identity
	}
	{
		perlight
		map textures/belgium/windows/snowywindow1.jpg
		rgbGen exactVertex
		blendFunc add
	nextbundle
		map $dlight
		blendFunc filter
	}
}
