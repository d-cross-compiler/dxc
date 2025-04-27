module dxc.sdk.sdk_url_builder;

import std.conv;

import dxc.core.target;

struct SdkUrlBuilder
{
    private enum sdkVersion = "0.0.1";

    private enum defaultBaseUrl = "https://github.com/d-cross-compiler/" ~
        i"sdk-extractor/releases/download/v$(sdkVersion)/sdk-$(sdkVersion)-".text;

    private Target target;
    private string baseUrl;

    this(Target target, string baseUrl = defaultBaseUrl)
    {
        this.target = target;
        this.baseUrl = baseUrl;
    }

    string buildUrl() const => baseUrl ~ target.triple ~ ".tar.xz";
}
