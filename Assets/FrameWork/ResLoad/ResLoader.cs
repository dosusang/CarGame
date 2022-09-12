using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;
using Object = System.Object;
#if UNITY_EDITOR
using UnityEditor;
#endif

public static class ResLoader
{
    public static UnityEngine.Object LoadRes(string path, Type type)
    {
        var obj = Resources.Load(path, type);
        return obj;
    }

    public static void LoadResAsync(string path, Type type, Action<Object> onLoaded)
    {
        var q = Resources.LoadAsync(path, type);
        q.completed += onLoaded;
    }

    public static void UnloadRes(UnityEngine.Object obj)
    {
        Resources.UnloadAsset(obj);
    }
}
