import std;

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

@"getDate" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <date>2024-06-20T18:01:48Z</date>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);
    const date = DateTime(2024, 6, 20, 18, 1, 48);
    const expected = SysTime(date, UTC());

    assert(plist.getDate("Foo") == expected);
}
