using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TrailCamera : MonoBehaviour
{
    void Update()
    {
        Vector3 cameraPos = transform.position;
        float cameraSize = GetComponent<Camera>().orthographicSize;

        Shader.SetGlobalVector("HeroCamMinPosition", cameraPos - Vector3.one * cameraSize);        
        Shader.SetGlobalVector("HeroCamMaxPosition", cameraPos + Vector3.one * cameraSize);
    }
}
