module dxc.sdk.apple.apple_sdk_url_finder;

import std.conv;

import dxc.sdk.apple.catalog;
import dxc.utilities.downloader;

class AppleSdkUrlFinder
{
    enum defaultCatalogUrl = "https://swscan.apple.com/content/catalogs/others/" ~
        "index-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-" ~
        "mountainlion-lion-snowleopard-leopard.merged-1.sucatalog";

    private immutable string catalogUrl;
    private Downloader downloader;

    this(
        string catalogUrl = defaultCatalogUrl,
        Downloader downloader = Downloader.default_
    )
    {
        this.catalogUrl = catalogUrl;
        this.downloader = downloader;
    }

    string find()
    {
        immutable data = downloader.download(catalogUrl).text;
        return Catalog.parse(data).latestSdkUrl;
    }
}
