module dxc.sdk.apple.catalog;

import std.algorithm;
import std.array;
import std.datetime;

import lime.core.optional;

import dxc.utilities.algorithms;
import dxc.utilities.plist;

package:

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

private:

struct Package
{
    string url;
}

struct Product
{
    string metadataUrl;
    Package[] packages;
}
