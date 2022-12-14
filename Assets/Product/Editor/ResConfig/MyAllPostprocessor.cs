using System.IO;
using UnityEngine;
using UnityEditor;

// todo 1.只限定某一些资源导入的时候放进配置里；   2.增加一个按钮，主动刷新配置
class MyAllPostprocessor : AssetPostprocessor
{
    private static string[] mNeedTypes =
    {
        "prefab","img",// add more
    };
    static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
    {
        string preafabName;
        foreach (string str in importedAssets)
        {
            preafabName = GetName(str);
            if (preafabName != null)
            {
                ResourceDictionary.Instance.add(preafabName, str);
            }
        }

        foreach (string str in movedAssets)
        {
            preafabName = GetName(str);
            if (preafabName != null)
            {
                ResourceDictionary.Instance.add(preafabName, str);
            }
        }

        foreach (string str in deletedAssets)
        {
            preafabName = GetName(str);
            if (preafabName != null)
            {
                ResourceDictionary.Instance.delete(preafabName);
            }
        }
        
        ResourceDictionary.Instance.ClearEpt();
    }
    static string GetName(string path)
    {
        var name = Path.GetFileName(path);
        foreach(var str in mNeedTypes)
        {
            if (name.EndsWith(str))
            {
                return name.Replace(Path.GetExtension(name), "");
            }
        }
        return null;
    }
}