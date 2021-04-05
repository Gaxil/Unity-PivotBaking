// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX2"
{
	Properties
	{
		_Spikeoffset("Spike offset", Range( 0 , 2)) = 0.8098202
		_Color0("Color 0", Color) = (0.5127714,0.5207428,0.6509434,0)
		_Roughness("Roughness", Range( 0 , 1)) = 0.5909025
		_Color1("Color 1", Color) = (0.9433962,0,0,0)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv4_texcoord4;
		};

		uniform float _Spikeoffset;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Roughness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 appendResult9_g7 = (float3(( 1.0 - v.color.r ) , v.color.b , v.color.g));
			float mulTime15 = _Time.y * 0.25;
			float temp_output_23_0 = ( ( sin( ( ( v.texcoord3.xy.y + mulTime15 ) * ( 2.0 * UNITY_PI ) ) ) + 1.0 ) * 0.5 );
			v.vertex.xyz += ( ( ( appendResult9_g7 - float3(0.5,0.5,0.5) ) * 2.0 ) * ( pow( temp_output_23_0 , 8.0 ) * _Spikeoffset ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime15 = _Time.y * 0.25;
			float temp_output_23_0 = ( ( sin( ( ( i.uv4_texcoord4.y + mulTime15 ) * ( 2.0 * UNITY_PI ) ) ) + 1.0 ) * 0.5 );
			float4 lerpResult29 = lerp( _Color0 , _Color1 , temp_output_23_0);
			o.Albedo = lerpResult29.rgb;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1920;0;1920;1149;1418.006;1356.473;1.861209;True;False
Node;AmplifyShaderEditor.CommentaryNode;47;-1152.325,387.8783;Inherit;False;1309.359;320.9001;Random cycle per sub object. Each object has its own offset in time/phase;8;15;16;18;17;19;22;23;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;46;-1179.258,-64.624;Inherit;False;GetPivotInfo;-1;;7;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1102.325,480.7788;Inherit;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-834.5253,437.8783;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;18;-938.5261,597.7784;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-646.0261,472.9781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;19;-477.6258,477.1784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-321.8624,462.5573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;154.6113,-44.18267;Inherit;False;701.5359;364.3931;Moving the sub object in the forward direction;3;14;7;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-186.8626,462.5573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;204.6113,204.2104;Inherit;False;Property;_Spikeoffset;Spike offset;0;0;Create;True;0;0;0;False;0;False;0.8098202;0.8098202;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-19.96622,462.644;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;220.049,-737.3287;Inherit;False;592.8683;507.1321;Colors blended according to offset;3;1;28;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;554.9822,182.888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;521.4515,-171.9084;Inherit;False;Property;_Roughness;Roughness;2;0;Create;True;0;0;0;False;0;False;0.5909025;0.5909025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;326.149,-687.3287;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.5127714,0.5207428,0.6509434,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;270.049,-442.1967;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.9433962,0,0,0;0,1,0.8586907,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;32;816.3536,-164.7851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;694.1473,5.817324;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;29;630.9175,-410.7064;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1027.649,-369.7325;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;46;1
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;19;0;17;0
WireConnection;22;0;19;0
WireConnection;23;0;22;0
WireConnection;25;0;23;0
WireConnection;14;0;25;0
WireConnection;14;1;8;0
WireConnection;32;0;30;0
WireConnection;7;0;46;2
WireConnection;7;1;14;0
WireConnection;29;0;1;0
WireConnection;29;1;28;0
WireConnection;29;2;23;0
WireConnection;0;0;29;0
WireConnection;0;4;32;0
WireConnection;0;11;7;0
ASEEND*/
//CHKSM=93DD2C3110AA06A8C7A9F1F03AD218AF3B8AF8F8