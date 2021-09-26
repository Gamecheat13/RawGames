#include "lib/globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
	float3 normal : NORMAL;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
	float3 normal : TEXCOORD2;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"

PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	pixel.normal = Transform_Dir_ObjectToView( vertex.normal );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	const float4 minColor = float4( 0.25, 0.15, 0.00, 1.00 );
	const float4 maxColor = float4( 1.00, 1.00, 0.50, 1.00 );

	PixelOutput fragment;
	float4 texColor;
	float luminance;
	float facing;
	float lerpAlpha;
	
	texColor = tex2D( colorMapSampler, pixel.texCoords );
	luminance = dot( float3( 0.333, 0.333, 0.333 ), texColor );

	facing = -normalize( pixel.normal ).z;

	lerpAlpha = (0.5 - sin( (facing * 0.5f + gameTime.z) * 3.14159 * 2.0) * 0.5f );
	fragment.color = lerp( minColor, maxColor, lerpAlpha ) * (luminance + 0.5f);
	fragment.color.a = texColor.a;

	return fragment;
}
