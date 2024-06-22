module dxc.utilities.plist;

import std;

import dxml.dom;

struct Plist
{
    private DOMEntity!string root;

    static Plist parse(string data)
    {
        auto root = parseDOM(data).children.front;
        auto rootDict = root.children.front;

        return Plist(rootDict);
    }

    int getInteger(string key) =>
        root.children[indexOfKey(key) + 1].children.front.text.to!int;

    private size_t indexOfKey(string key) =>
        root
            .children
            .countUntil!(e => e.name == "key" && e.children.front.text == key);
}
