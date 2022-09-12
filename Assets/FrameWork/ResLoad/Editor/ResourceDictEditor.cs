using System;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(ResourceDictionary))]
public class ResourceDictEditor : Editor
{
    private ResourceDictionary mTar;
    private void OnEnable()
    {
        mTar = ResourceDictionary.Instance;
    }

    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("清空无效资源"))
        {
            mTar.ClearEpt();
        }
        if (GUILayout.Button("清空所有"))
        {
            mTar.ClearAll();
        } 
        
        base.OnInspectorGUI();
    }
}
