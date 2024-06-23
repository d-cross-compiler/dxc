module dxc.utilities.plist;

import std;

import dxml.dom;

struct Plist
{
    private alias Element = DOMEntity!string;
    private Element root;

    static Plist parse(string data)
    {
        auto root = parseDOM(data).children.front;
        auto rootDict = root.children.front;

        return Plist(rootDict);
    }

    int getInteger(string key) => getTextFor(key, ofType: "integer").to!int;
    string getString(string key) => getTextFor(key, ofType: "string");
    SysTime getDate(string key) =>
        SysTime.fromISOExtString(getTextFor(key, ofType: "date"));

    Plist getDict(string key) => Plist(getElementFor(key, ofType: "dict"));

private:

    string getTextFor(string key, string ofType) =>
        getElementFor(key, ofType).children.front.text;

    Element getElementFor(string key, string ofType)
    {
        auto element = root.children[indexOfKey(key) + 1];
        assert(element.name == ofType, element.name);
        return element;
    }

    size_t indexOfKey(string key) =>
        root
            .children
            .countUntil!(e => e.name == "key" && e.children.front.text == key);
}
