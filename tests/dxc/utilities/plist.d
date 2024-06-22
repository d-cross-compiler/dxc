import dxc.utilities.plist;

@"getInteger" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <integer>2</integer>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);
    assert(plist.getInteger("Foo") == 2);
}

@"getString" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <string>bar</string>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);
    assert(plist.getString("Foo") == "bar");
}
