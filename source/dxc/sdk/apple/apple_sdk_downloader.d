module dxc.sdk.apple.apple_sdk_downloader;

import std.conv;
import std.json;

import dxc.sdk.sdk_downloader;
import dxc.sdk.sdk_url_builder;
import dxc.utilities.data;
import dxc.utilities.downloader;

/**
 * Downloads the Apple SDK from Apple's servers.
 *
 * The process is as follows:
 * 1. Download a manifest containing the URL to the SDK
 * 2. Parse the manifest to extract the URL
 * 3. Download the actual SDK
 *
 * The format of the manifest is a JSON format:
 * ```
 * {
 *   "url": "https://example.com/sdk.pkg"
 * }
 * ```
 */
class AppleSdkDownloader : SdkDownloader
{
    private enum manifestVersion = "0.0.1";
    private enum defaultManifestUrl = "https://github.com/d-cross-compiler/" ~
        "sdk-apple/releases/latest/download/" ~
        i"sdk-manifest-$(manifestVersion)-apple.json".text;

    private string manifestUrl;
    private Downloader downloader;

    this(
        string manifestUrl = defaultManifestUrl,
        Downloader downloader = Downloader.default_
    )
    {
        this.manifestUrl = manifestUrl;
        this.downloader = downloader;
    }

    Data download()
    {
        immutable manifestData = downloader.download(manifestUrl);
        immutable json = parseJSON(manifestData.asString);
        immutable sdkUrl = json["url"].str;

        return downloader.download(sdkUrl);
    }
}
