module dxc.sdk.installer;

import std.file;
import std.conv;
import std.path;

import dxc.core.config;
import dxc.core.target;
import dxc.sdk.generic_sdk_downloader;
import dxc.sdk.installer;
import dxc.sdk.sdk_downloader;
import dxc.sdk.sdk_url_builder;
import dxc.utilities.file_system;

class Installer
{
    this(Target target, SdkDownloader downloader, FileSystem fileSystem, Config config)
    {
        this.target = target;
        this.downloader = downloader;
        this.fileSystem = fileSystem;
        this.config = config;
    }

    static Installer forTarget(Target target) => new Installer(
        target: target,
        downloader: new GenericSdkDownloader(SdkUrlBuilder(target)),
        fileSystem: FileSystem(),
        config: Config()
    );

    void install() => fileSystem.write(downloader.download, to: downloadPath);

private:

    const Target target;
    SdkDownloader downloader;
    FileSystem fileSystem;
    Config config;

    string triple() => target.triple;
    string downloadPath() => buildPath(config.tempDirectory, downloadFilename);
    string downloadFilename() =>
        i"sdk-$(config.sdkVersion)-$(triple).tar.xz".text;
}
