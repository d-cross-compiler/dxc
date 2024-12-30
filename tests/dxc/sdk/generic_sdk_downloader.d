import std.conv;

import fluent.asserts;

import lime.core.optional;

import mocked;

import dxc.sdk.generic_sdk_downloader;
import dxc.core.target;
import dxc.utilities.data;
import dxc.utilities.downloader;

scope class Setup
{
    enum expectedData = Data("this is some random data");
    immutable target = Target.parse("x86_64-unknown-freebsd13.1");
    Stubbed!Downloader downloader;

    GenericSdkDownloader sdkDownloader;

    this(string url = "")
    {
        downloader = Mocker().stub!Downloader;
        sdkDownloader = new GenericSdkDownloader(target,
            baseUrl: url,
            downloader: downloader
        );
    }
}

@"GenericSdkDownloader.download - it returns downloaded data" unittest
{
    scope setup = new Setup();
    setup.downloader.stub.download.returns(setup.expectedData);

    expect(setup.sdkDownloader.download()).to.equal(setup.expectedData);
}

@"GenericSdkDownloader.download - it downloads the correct URL" unittest
{
    enum url = "https://example.com/download/";
    scope setup = new Setup(url: url);
    enum expectedUrl = "https://example.com/download/x86_64-unknown-freebsd13.1.tar.xz";

    setup.downloader.stub.download(expectedUrl).returns(setup.expectedData);

    expect(setup.sdkDownloader.download()).to.equal(setup.expectedData);
}
