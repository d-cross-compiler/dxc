import std;

import fluent.asserts;

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
    expect(plist.getInteger("Foo")).to.equal(2);
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
    expect(plist.getString("Foo")).to.equal("bar");
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

    expect(plist.getDate("Foo")).to.equal(SysTime(date, UTC()));
}

@"getDict" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <dict>
              <key>Bar</key>
              <integer>2</integer>
            </dict>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);
    expect(plist.getDict("Foo").getInteger("Bar")).to.equal(2);
}

@"byKeyValue" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <dict>
              <key>A</key>
              <integer>2</integer>
            </dict>
            <key>Bar</key>
            <dict>
              <key>A</key>
              <integer>4</integer>
            </dict>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);

    auto expected = only(tuple("Foo", 2), tuple("Bar", 4));

    auto actual = plist
        .byKeyValue
        .map!(kv => tuple(kv.key, kv.value.asDict.getInteger("A")));

    expect(actual).to.equal(expected);
}

@"byValue" unittest
{
    const data = q"XML
        <plist version="1.0">
          <dict>
            <key>Foo</key>
            <dict>
              <key>A</key>
              <integer>2</integer>
            </dict>
            <key>Bar</key>
            <dict>
              <key>A</key>
              <integer>4</integer>
            </dict>
          </dict>
        </plist>
XML";

    auto plist = Plist.parse(data);

    auto actual = plist
        .byValue
        .map!(value => value.asDict.getInteger("A"));

    expect(actual).to.equal(only(2, 4));
}
