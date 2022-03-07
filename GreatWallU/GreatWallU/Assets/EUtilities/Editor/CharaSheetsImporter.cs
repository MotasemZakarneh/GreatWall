using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using System.Linq;
using UnityEditorInternal;
using UnityEditor.U2D.Sprites;

public class CharaSheetsImporter : AssetPostprocessor
{
    //Refereinces
    //https://forum.unity.com/threads/getting-original-size-of-texture-asset-in-pixels.165295/
    //https://forum.unity.com/threads/automated-sprite-slicing-on-import.949056/
    //https://forum.unity.com/threads/creating-multi-sprite-assets-in-textureimporter-sprites-not-appearing-as-assets.741725/#post-5653831

    //Naming Convention
    //first () is the cell size
    //second () is the pivot position (only from 0 to 100)
    //Ch_Igor_Walk_(71M64)_(50M50)
    string aPath => assetPath.ToLower();
    bool fnTest => aPath.Contains("ch_") || aPath.Contains("sh") || aPath.Contains("sheet");
    string fn => Path.GetFileNameWithoutExtension(assetPath);

    public void OnPreprocessTexture()
    {
        if (fnTest)
        {
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            CharaSheetNameParser.ParseName(fn, out string charaName, out string animName, out Vector2 cellSizeV, out Vector2 pivotV, out string cellSize, out string pivot);
            ApplySheetSettings(textureImporter, pivotV);
        }
    }
    public void OnPostprocessTexture(Texture2D texture)
    {
        if (!fnTest) return;
        TextureImporter importer = assetImporter as TextureImporter;

        if (importer.spriteImportMode != SpriteImportMode.Multiple)
        {
            Debug.Log("something went wrong?");
            return;
        }

        List<SpriteMetaData> metas = GetSheetMetas(texture, assetPath);
        Debug.Log("OnPostprocessTexture generating sprites..." + metas.Count);
        

        importer.spritesheet = metas.ToArray();
        //This first line was the change that fixed it for me
        AssetDatabase.ForceReserializeAssets(new List<string>() { assetPath });
        //Those lines below I was already using so they may or may not be necessary
        AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceUpdate);
        AssetDatabase.SaveAssets();
    }

    public static List<SpriteMetaData> GetSheetMetas(Texture2D texture, string path)
    {
        var fn = Path.GetFileNameWithoutExtension(path);
        CharaSheetNameParser.ParseName(fn, out string charaName, out string animName, out Vector2 cellSizeV, out Vector2 pivotV, out string cellSize, out string pivot);
        Rect[] rects = InternalSpriteUtility.GenerateGridSpriteRectangles(texture, Vector2.zero, cellSizeV, Vector2.zero);
        List<Rect> sortedRects = rects.ToList();

        List<SpriteMetaData> metas = new List<SpriteMetaData>();
        int rectNum = 0;

        foreach (Rect rect in sortedRects)
        {
            SpriteMetaData meta = new SpriteMetaData();
            meta.rect = rect;
            meta.name = fn + "_" + rectNum;
            rectNum++;
            meta.alignment = (int)SpriteAlignment.Custom;
            meta.pivot = pivotV;
            metas.Add(meta);
        }
        return metas;
    }

    #region Deprecated Functions
    // private static bool GetImageSize(string assetPath, out int width, out int height)
    // {
    //     SpriteDataProviderFactories dataProviderFactories = new SpriteDataProviderFactories();

    //     dataProviderFactories.Init();

    //     ISpriteEditorDataProvider importer = dataProviderFactories.GetSpriteEditorDataProviderFromObject(AssetImporter.GetAtPath(assetPath));

    //     if (importer != null)
    //     {
    //         importer.InitSpriteEditorDataProvider();

    //         ITextureDataProvider textureDataProvider = importer.GetDataProvider<ITextureDataProvider>();

    //         textureDataProvider.GetTextureActualWidthAndHeight(out width, out height);

    //         return true;
    //     }

    //     width = height = 0;
    //     return true;
    // }
    // private void GetSheetMetasPre()
    // {
    //     bool success = GetImageSize(assetPath, out int imageWidth, out int imageHeight);
    //     int rows = (int)(imageWidth / cellSizeV.x);
    //     int cols = (int)(imageHeight / cellSizeV.y);

    //     List<SpriteMetaData> metaDatas = new List<SpriteMetaData>();
    //     int spriteWidth = (int)cellSizeV.x;
    //     int spriteHeight = (int)cellSizeV.y;
    //     int spriteCount = 0;

    //     for (int row = 0; row < rows; row++)
    //     {
    //         for (int col = 0; col < cols; col++)
    //         {
    //             int r = rows - (row + 1);
    //             SpriteMetaData metaData = new SpriteMetaData()
    //             {
    //                 rect = new Rect(col * spriteWidth, r * spriteHeight, spriteWidth, spriteHeight),
    //                 name = $"{fn}_{spriteCount}"
    //             };
    //             metaData.alignment = (int)SpriteAlignment.Custom;
    //             metaData.pivot = pivotV;
    //             metaDatas.Add(metaData);

    //             ++spriteCount;
    //         }
    //     }
    // }
    #endregion

    private void ApplySheetSettings(TextureImporter textureImporter, Vector2 pivot)
    {
        // need this class because spriteExtrude and spriteMeshType aren't exposed on TextureImporter
        //textureImporter.isReadable = true;
        var textureSettings = new TextureImporterSettings();
        textureImporter.ReadTextureSettings(textureSettings);
        textureSettings.ApplyTextureType(TextureImporterType.Sprite);
        textureSettings.textureType = TextureImporterType.Sprite;
        textureSettings.spritePivot = pivot;
        textureSettings.spriteMode = (int)SpriteImportMode.Multiple;
        textureSettings.spriteExtrude = 0;
        textureSettings.filterMode = FilterMode.Point;
        textureSettings.wrapMode = TextureWrapMode.Clamp;
        textureSettings.textureType = TextureImporterType.Sprite;
        textureSettings.spriteAlignment = (int)SpriteAlignment.Custom;
        textureSettings.alphaIsTransparency = true;
        textureSettings.alphaSource = TextureImporterAlphaSource.FromInput;
        textureSettings.mipmapEnabled = false;
        textureImporter.SetTextureSettings(textureSettings);
        textureImporter.spriteImportMode = SpriteImportMode.Multiple;

        textureImporter.maxTextureSize = 4096;
        textureImporter.textureCompression = TextureImporterCompression.Uncompressed;
        textureImporter.crunchedCompression = false;
    }
}