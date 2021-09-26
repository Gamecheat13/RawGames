#include "lib/globals.hlsl"


struct VertexInput
{
    float4 position : POSITION;
    float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
    float4 position : POSITION;
    float2 texCoords[4] : TEXCOORD0;
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

    pixel.texCoords[0] = vertex.texCoords + float2( -renderTargetSize[SIZECONST_INV_WIDTH], 0 );
    pixel.texCoords[1] = vertex.texCoords + float2( renderTargetSize[SIZECONST_INV_WIDTH], 0 );
    pixel.texCoords[2] = vertex.texCoords + float2( 0, -renderTargetSize[SIZECONST_INV_HEIGHT] );
    pixel.texCoords[3] = vertex.texCoords + float2( 0, renderTargetSize[SIZECONST_INV_HEIGHT] );

    return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
    PixelOutput fragment;    

    fragment.color = tex2D( shadowCookieSampler, pixel.texCoords[0] );
	fragment.color += tex2D( shadowCookieSampler, pixel.texCoords[1] );
	fragment.color += tex2D( shadowCookieSampler, pixel.texCoords[2] );
	fragment.color += tex2D( shadowCookieSampler, pixel.texCoords[3] );
	fragment.color *= 0.25;

    return fragment;
}
