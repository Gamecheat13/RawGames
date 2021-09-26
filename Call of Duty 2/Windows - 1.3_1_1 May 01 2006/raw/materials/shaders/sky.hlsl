#include "lib/globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
};


struct PixelInput
{
	float4 position : POSITION;
	float3 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	float4 dir;

	dir.xyz = vertex.position - eyePosition;
	dir.w = 0;

	pixel.position = Transform_ObjectToClip( dir );
	pixel.texCoords = dir;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color.rgb = texCUBE( colorMapSampler, pixel.texCoords );
	fragment.color.a = 0.0f;

	return fragment;
}
