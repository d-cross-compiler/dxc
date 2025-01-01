import std.conv;

import fluent.asserts;

import mocked;

import dxc.sdk.apple.apple_sdk_downloader;
import dxc.utilities.data;
import dxc.utilities.downloader;

@"AppleSdkDownloader.download - it returns downloaded data" unittest
{
    Mocker mocker;
    auto expectedData = Data("this is the SDK data");
    scope downloader = mocker.stub!Downloader;
    downloader.stub.download.returns(expectedData);
    scope sdkDownloader = new AppleSdkDownloader(
        downloader: downloader
    );

    expect(sdkDownloader.download).to.equal(expectedData);
}

@"AppleSdkDownloader.download - it downloads the correct URL" unittest
{
    enum manifestUrl = "https://example.com/apple.json";
    Mocker mocker;
    scope downloader = mocker.mock!Downloader;
    scope sdkDownloader = new AppleSdkDownloader(
        manifestUrl: manifestUrl,
        downloader: downloader,
    );

    enum sdkUrl = "https://example.com/CLTools_macOSNMOS_SDK.pkg";
    enum manifestData = i`
{
  "url": "$(sdkUrl)"
}
`.text;

    downloader
        .expect
        .download(manifestUrl)
        .returns(Data(manifestData));

    downloader.expect.download(sdkUrl);
    sdkDownloader.download();
}
