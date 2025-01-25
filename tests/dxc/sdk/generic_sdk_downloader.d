import std.conv;

import fluent.asserts;

import lime.core.optional;

import mocked;

import dxc.sdk.generic_sdk_downloader;
import dxc.sdk.sdk_url_builder;
import dxc.core.target;
import dxc.utilities.data;
import dxc.utilities.downloader;

@"GenericSdkDownloader.download - it returns downloaded data" unittest
{
    enum expectedData = Data("this is some random data");
    immutable target = Target.parse("x86_64-unknown-freebsd13.1");
    auto downloader = Mocker().stub!Downloader;
    auto urlBuilder = SdkUrlBuilder(target: target);

    scope sdkDownloader = new GenericSdkDownloader(
        urlBuilder,
        downloader: downloader
    );

    downloader.stub.download.returns(expectedData);

    expect(sdkDownloader.download()).to.equal(expectedData);
}
