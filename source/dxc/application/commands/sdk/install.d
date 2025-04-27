module dxc.application.commands.sdk.install;

import std.file;
import std.conv;
import std.stdio : writeln;

import dxc.application.arguments;
import dxc.application.command;
import dxc.sdk.generic_sdk_downloader;
import dxc.sdk.sdk_downloader;
import dxc.sdk.sdk_url_builder;
import dxc.core.target;

class Install : Command
{
    this(Arguments arguments)
    {
        this.arguments = arguments;
    }

    int run()
    {
        const triple = "x86_64-unknown-freebsd13.1";
        const target = Target.parse(triple);
        auto urlBuilder = SdkUrlBuilder(target);
        SdkDownloader downloader = new GenericSdkDownloader(urlBuilder);
        auto data = downloader.download();
        const filename = i"tmp/sdk-0.0.1-$(triple).tar.xz".text;

        mkdirRecurse("tmp");
        write(filename, data.bytes);

        return 0;
    }

private:

    Arguments arguments;
}
