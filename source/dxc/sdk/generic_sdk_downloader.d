module dxc.sdk.generic_sdk_downloader;

import std.conv;

import lime.core.optional;

import dxc.core.target;
import dxc.sdk.sdk_url_builder;
import dxc.utilities.data;
import dxc.utilities.downloader;

class GenericSdkDownloader
{
    private SdkUrlBuilder urlBuilder;
    private Downloader downloader;

    this(SdkUrlBuilder urlBuilder, Downloader downloader = Downloader.default_)
    {
        this.urlBuilder = urlBuilder;
        this.downloader = downloader;
    }

    Data download() => downloader.download(urlBuilder.buildUrl);
}
