#ifndef HALF_TAP_COUNT
#error HALF_TAP_COUNT undefined
#endif
#if HALF_TAP_COUNT < 1 || HALF_TAP_COUNT > 4
#error HALF_TAP_COUNT should be from 1 to 4
#endif

#include "globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords[HALF_TAP_COUNT * 2] : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	int tapIndex;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	for ( tapIndex = 0; tapIndex < HALF_TAP_COUNT; tapIndex++ )
	{
		pixel.texCoords[tapIndex * 2 + 0] = vertex.texCoords + filterTap[tapIndex].xy;
		pixel.texCoords[tapIndex * 2 + 1] = vertex.texCoords - filterTap[tapIndex].xy;
	}

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	int tapIndex;

	fragment.color = 0;
	for ( tapIndex = 0; tapIndex < HALF_TAP_COUNT; tapIndex++ )
		fragment.color += filterTap[tapIndex].w * (tex2D( colorMapSampler, pixel.texCoords[tapIndex * 2 + 0] ) + tex2D( colorMapSampler, pixel.texCoords[tapIndex * 2 + 1] ));

	return fragment;
}
