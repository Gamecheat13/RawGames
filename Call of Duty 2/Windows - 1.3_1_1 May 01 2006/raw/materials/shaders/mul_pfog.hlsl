#define USE_DETAIL		0
#define PIXEL_FOG
#include "lib/multiply_fog.hlsl"


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	half3		oneMinusMultiplyColor;
	half4		diffuseColor;

	diffuseColor.rgb = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );

	// Cm = (1 - pixel.color.a) + diffuseColor.rgb * pixel.color.a;
	// (1 - Cm) = 1 - (1 - pixel.color.a) - diffuseColor.rgb * pixel.color.a;
	// (1 - Cm) = 1 - 1 + pixel.color.a - diffuseColor.rgb * pixel.color.a;
	// (1 - Cm) = pixel.color.a - diffuseColor.rgb * pixel.color.a;

	oneMinusMultiplyColor = pixel.color.a - diffuseColor.rgb * pixel.color.a;
	fragment.color.rgb = oneMinusMultiplyColor * pixel.fogColor;
	fragment.color.a = 1;

	return fragment;
}
