module dxc.sdk.generic_sdk_downloader;

import std.conv;

import lime.core.optional;

import dxc.core.target;
import dxc.utilities.data;
import dxc.utilities.downloader;

class GenericSdkDownloader
{
    private enum sdkVersion = "0.0.1";

    private enum defaultBaseUrl = "https://github.com/d-cross-compiler/ " ~
        i"sdk-extractor/releases/download/v$(sdkVersion)/sdk-$(sdkVersion)-".text;

    private Target target;
    private string baseUrl;
    private Downloader downloader;
    private Optional!string url_;

    this(
        Target target,
        string baseUrl = defaultBaseUrl,
        Downloader downloader = Downloader.default_
    )
    {
        this.target = target;
        this.baseUrl = baseUrl;
        this.downloader = downloader;
    }

    Data download() => downloader.download(url);

private:

    string url()
    {
        if (!url_)
            url_ = baseUrl ~ target.triple ~ ".tar.xz";

        return url_.or("");
    }
}
