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
    this(Sdk.Install arguments)
    {
        this.arguments = arguments;
    }

    int run()
    {
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

    Sdk.Install arguments;

    string triple() => arguments.target;
}
