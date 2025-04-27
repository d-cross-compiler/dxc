import fluent.asserts;
import mocked;

import dxc.core.config;
import dxc.core.target;
import dxc.sdk.sdk_downloader;
import dxc.sdk.installer;
import dxc.utilities.data;
import dxc.utilities.file_system;

@"Installer.install" unittest
{
    const data = Data("foo");
    Mocker mocker;
    scope downloader = mocker.mock!SdkDownloader;
    downloader.expect.download().returns(data);

    scope fileSystem = mocker.mock!FileSystem;
    fileSystem.expect.write(data, "/temp/sdk-0.0.0-x86_64-unknown-openbsd7.3.tar.xz");

    const target = Target.parse("x86_64-unknown-openbsd7.3");

    scope installer = new Installer(
        target,
        downloader: downloader,
        fileSystem: fileSystem,
        config: Config(
            tempDirectory: "/temp",
            sdkVersion: "0.0.0"
        )
    );

    installer.install();
}
