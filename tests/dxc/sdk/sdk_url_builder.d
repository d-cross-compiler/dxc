import fluent.asserts;

import dxc.core.target;
import dxc.sdk.sdk_url_builder;

@"SdkUrlBuilder.buildUrl" unittest
{
    immutable target = Target.parse("x86_64-unknown-freebsd13.1");
    immutable urlBuilder = SdkUrlBuilder(target, baseUrl: "https://example.com/");

    expect(urlBuilder.buildUrl)
        .to.equal("https://example.com/x86_64-unknown-freebsd13.1.tar.xz");
}
