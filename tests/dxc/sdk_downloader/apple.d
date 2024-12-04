import dxml.dom;
import std;

import fluent.asserts;
import lime.core.optional;

import dxc.utilities.algorithms;
import dxc.utilities.plist;

struct AppleDownloader
{
    void download()
    {
        // .download("https://swscan.apple.com/content/catalogs/others/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog");
    }
}

struct Package
{
    string url;
}

struct Product
{
    string metadataUrl;
    Package[] packages;
}

enum catalogData =
`<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Products</key>
        <dict>
            <key>052-59890</key>
            <dict>
                <key>ServerMetadataURL</key>
                <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSNMOS_SDK.smd</string>
                <key>Packages</key>
                <array>
                    <dict>
                        <key>Digest</key>
                        <string>4313552d5c36a9953bb24396238f86f2a8ca07c1</string>
                        <key>Size</key>
                        <integer>48539454</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_SwiftBackDeploy.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_SwiftBackDeploy.pkg</string>
                    </dict>
                    <dict>
                        <key>Digest</key>
                        <string>62e4e81eb9ab5dc4af40bb6a3a3e601bb2a8a316</string>
                        <key>Size</key>
                        <integer>59320979</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSNMOS_SDK.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSNMOS_SDK.pkg</string>
                    </dict>
                    <dict>
                        <key>Digest</key>
                        <string>92e85a0f035a02000847ad273eca90f2e056789c</string>
                        <key>Size</key>
                        <integer>565536039</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_Executables.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_Executables.pkg</string>
                    </dict>
                    <dict>
                        <key>Digest</key>
                        <string>51e67d551c2f2ff3a50cab8259b11b3f88638143</string>
                        <key>Size</key>
                        <integer>5369</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOS_SDK.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOS_SDK.pkg</string>
                    </dict>
                    <dict>
                        <key>Digest</key>
                        <string>d661c35e47232c8bbbf810368e99ff48bff0fab7</string>
                        <key>Size</key>
                        <integer>51079417</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSLMOS_SDK.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSLMOS_SDK.pkg</string>
                    </dict>
                </array>
                <key>PostDate</key>
                <date>2024-03-05T21:14:36Z</date>
                <key>Distributions</key>
                <dict>
                    <key>English</key>
                    <string>https://swdist.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/052-59890.English.dist</string>
                </dict>
            </dict>
        </dict>
    </dict>
</plist>`;

struct Catalog
{
    private Plist plist;

    static Catalog parse(string data) => Catalog(Plist.parse(data));

    string latestSdkUrl()
    {
        return latestSdkProduct
            .packages
            .map!(e => e.url)
            .find!(e => e.endsWith("CLTools_macOSNMOS_SDK.pkg"))
            .or("");
    }

private:

    Product latestSdkProduct()
    {
        alias isMacOSNMOS_SDK = e => e
            .getString("ServerMetadataURL")
            .any!(e => e.endsWith("CLTools_macOSNMOS_SDK.smd"));

        auto latestProductElement = plist
            .getDict("Products")
            .byValue
            .flatMap!(e => e.map!(f => f.asDict))
            .filter!isMacOSNMOS_SDK
            .filter!(e => e.containsKey("PostDate"))
            .maxElement!(e => e.getDate("PostDate").or(SysTime()));

        return Product(
            metadataUrl: latestProductElement.getString("ServerMetadataURL").or(""),
            packages: packages(latestProductElement)
        );
    }

    Package[] packages(Plist product)
    {
        return product
            .getArray("Packages")
            .or(Plist.emptyArray)
            .map!(e => e.asDict)
            .map!(e => Package(url: e.getString("URL").or("")))
            .array;
    }
}

@"Download macOS SDK" unittest
{
    auto catalog = Catalog.parse(catalogData);
    expect(catalog.latestSdkProduct.metadataUrl).to.equal("https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSNMOS_SDK.smd");

    expect(catalog.latestSdkProduct.packages[0].url).to.equal("https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_SwiftBackDeploy.pkg");

    expect(catalog.latestSdkUrl).to.equal("https://swcdn.apple.com/content/downloads/14/48/052-59890-A_I0F5YGAY0Y/p9n40hio7892gou31o1v031ng6fnm9sb3c/CLTools_macOSNMOS_SDK.pkg");

    // const catalog = readText("/Users/jacobcarlborg/development/d/dxc/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.plist");
    // auto plist = Plist.parse(catalog);
    //
    // // auto p = plist.getDict("Products").getDict("061-7415").getString("ServerMetadataURL");
    //
    // alias isMacOSNMOS_SDK = e => e.getString("ServerMetadataURL").any!(e => e.endsWith("CLTools_macOSNMOS_SDK.smd"));
    //
    // plist
    //     .getDict("Products")
    //     .get
    //     .byValue
    //     .map!(e => e.asDict)
    //     .filter!isMacOSNMOS_SDK
    //     .filter!(e => e.containsKey("PostDate"))
    //     .maxElement!(e => e.getDate("PostDate").get)
    //     .writeln;
    //     // .map!(v => v.asDict.getString("ServerMetadataURL"))
}

// https://developerservices2.apple.com/services/download?path=/Developer_Tools/tvOS_17.5_Simulator_Runtime/tvOS_17.5_Simulator_Runtime.dmg
//
// https://download.developer.apple.com/Developer_Tools/tvOS_17.5_Simulator_Runtime/tvOS_17.5_Simulator_Runtime.dmg
