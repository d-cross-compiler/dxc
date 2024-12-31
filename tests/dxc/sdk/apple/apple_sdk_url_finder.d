import std.conv;

import fluent.asserts;

import mocked;

import dxc.sdk.apple.apple_sdk_url_finder;
import dxc.utilities.data;
import dxc.utilities.downloader;

enum sdkUrl = "https://swcdn.apple.com/content/CLTools_macOSNMOS_SDK.pkg";

enum catalogData =
i`<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Products</key>
        <dict>
            <key>052-59890</key>
            <dict>
                <key>ServerMetadataURL</key>
                <string>https://swcdn.apple.com/content/CLTools_macOSNMOS_SDK.smd</string>
                <key>Packages</key>
                <array>
                    <dict>
                        <key>Digest</key>
                        <string>4313552d5c36a9953bb24396238f86f2a8ca07c1</string>
                        <key>Size</key>
                        <integer>48539454</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/CLTools_SwiftBackDeploy.pkm</string>
                        <key>URL</key>
                        <string>https://swcdn.apple.com/content/CLTools_SwiftBackDeploy.pkg</string>
                    </dict>
                    <dict>
                        <key>Digest</key>
                        <string>62e4e81eb9ab5dc4af40bb6a3a3e601bb2a8a316</string>
                        <key>Size</key>
                        <integer>59320979</integer>
                        <key>MetadataURL</key>
                        <string>https://swdist.apple.com/content/CLTools_macOSNMOS_SDK.pkm</string>
                        <key>URL</key>
                        <string>$(sdkUrl)</string>
                    </dict>
                </array>
                <key>PostDate</key>
                <date>2024-03-05T21:14:36Z</date>
            </dict>
        </dict>
    </dict>
</plist>`.text;

@"dxc.sdk.apple.apple_sdk_url_finder.AppleSdkUrlFinder - find" unittest
{
    auto downloader = Mocker().stub!Downloader;
    downloader.stub.download.returns(Data(catalogData));

    auto finder = new AppleSdkUrlFinder(downloader: downloader.get);

    expect(finder.find).to.equal("https://swcdn.apple.com/content/CLTools_macOSNMOS_SDK.pkg");
}
