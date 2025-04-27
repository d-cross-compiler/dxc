module dxc.sdk.installer;

import std.file;
import std.conv;

import dxc.sdk.generic_sdk_downloader;
import dxc.sdk.sdk_downloader;
import dxc.sdk.sdk_url_builder;
import dxc.core.target;
import dxc.sdk.installer;

class Installer
{
    this(Target target)
    {
        this.target = target;
    }

    void install()
    {
        auto urlBuilder = SdkUrlBuilder(target);
        SdkDownloader downloader = new GenericSdkDownloader(urlBuilder);
        auto data = downloader.download();
        const filename = i"tmp/sdk-0.0.1-$(triple).tar.xz".text;

        mkdirRecurse("tmp");
        write(filename, data.bytes);
    }

private:

    const Target target;

    string triple() => target.triple;
}
