// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX3"
{
	Properties
	{
		_Roughness("Roughness", Range( 0 , 1)) = 0.8315013
		_Rotation("Rotation", Range( 0 , 2)) = 0.2816087
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float3 HeroPosition;
		uniform float _Rotation;
		uniform float _Roughness;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 appendResult7_g7 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord3.xy.x , ( v.texcoord2.xy.y * -1.0 )));
			float3 temp_output_16_0_g7 = ( 0.01 * appendResult7_g7 );
			float3 objToWorld97 = mul( unity_ObjectToWorld, float4( temp_output_16_0_g7, 1 ) ).xyz;
			float3 normalizeResult96 = normalize( cross( ( HeroPosition - objToWorld97 ) , float3(0,1,0) ) );
			float temp_output_64_0 = ( _Rotation * UNITY_PI );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_74_0 = ( ( ase_vertex3Pos - temp_output_16_0_g7 ) * float3( 1,1,1 ) );
			float3 rotatedValue61 = RotateAroundAxis( float3( 0,0,0 ), temp_output_74_0, normalizeResult96, temp_output_64_0 );
			v.vertex.xyz += ( rotatedValue61 - temp_output_74_0 );
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 rotatedValue79 = RotateAroundAxis( float3( 0,0,0 ), ase_vertexNormal, normalizeResult96, temp_output_64_0 );
			v.normal = rotatedValue79;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.5127714,0.5207428,0.6509434,0) : float4(0.2260532,0.2337451,0.3812781,0);
			o.Albedo = color1.rgb;
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
1920;0;1920;1149;2253.75;2320.025;2.755421;True;False
Node;AmplifyShaderEditor.CommentaryNode;99;-1309.982,-1067.921;Inherit;False;1047.952;632.0679;Compute rotation axis as perpendicular to the plane defined by the up & hero direction;6;88;97;98;95;96;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;46;-1536.256,-362.1361;Inherit;False;GetPivotInfo;-1;;7;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.TransformPositionNode;97;-1259.982,-623.8531;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;88;-1237.97,-1017.921;Inherit;False;Global;HeroPosition;HeroPosition;2;0;Create;True;0;0;0;False;0;False;0,1,0;13.69,0.49,-0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;102;-188.4434,-612.6674;Inherit;False;518.5385;239.8595;Angle of rotation;3;87;65;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-941.6593,-913.2354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;98;-962.4592,-741.0354;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;101;388.1025,-645.2304;Inherit;False;1103.088;437.5586;Rotating the vertex around the pivot (using relative position we use a 0,0,0 pivot point, and the subtract is used to get the realtive offset to the original point);3;73;61;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-138.4434,-562.6674;Inherit;False;Property;_Rotation;Rotation;1;0;Create;True;0;0;0;False;0;False;0.2816087;0.6788265;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;62;-707.3743,-846.1331;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PiNode;65;-52.50969,-483.8079;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;100;396.8059,-1149.758;Inherit;False;694.4332;442.8729;Rotating the vertex normal;2;78;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;96;-518.7322,-845.0608;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;438.1025,-340.6457;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;168.0951,-536.3856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;1688.304,-584.4939;Inherit;False;Property;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0.8315013;0.3909024;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;78;446.8059,-1099.758;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotateAboutAxisNode;61;700.3029,-595.2304;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;79;771.2391,-889.8852;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;1105.356,-364.5439;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;1781.714,-931.062;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.5127714,0.5207428,0.6509434,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;32;1989.859,-579.5878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2168.919,-652.8735;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;97;0;46;0
WireConnection;95;0;88;0
WireConnection;95;1;97;0
WireConnection;62;0;95;0
WireConnection;62;1;98;0
WireConnection;96;0;62;0
WireConnection;74;0;46;18
WireConnection;64;0;87;0
WireConnection;64;1;65;0
WireConnection;61;0;96;0
WireConnection;61;1;64;0
WireConnection;61;3;74;0
WireConnection;79;0;96;0
WireConnection;79;1;64;0
WireConnection;79;3;78;0
WireConnection;73;0;61;0
WireConnection;73;1;74;0
WireConnection;32;0;30;0
WireConnection;0;0;1;0
WireConnection;0;4;32;0
WireConnection;0;11;73;0
WireConnection;0;12;79;0
ASEEND*/
//CHKSM=A767A138A0B8AD3F57256C4BAF696ADFA7913511