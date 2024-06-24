module dxc.utilities.plist;

import std;

import dxml.dom;

struct Plist
{
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
    ByKeyValueRange byKeyValue() => ByKeyValueRange(root.children);

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

private:

alias Element = DOMEntity!string;

struct ByKeyValueRange
{
    private Element[] elements;

    FrontElement front() => FrontElement(key, value);

    void popFront()
    {
        elements.popFront();
        elements.popFront();
    }

    bool empty() => elements.empty;

private:

    string key()
    {
        auto keyElement = elements.front;
        assert(keyElement.name == "key", keyElement.name);

        return keyElement.children.front.text;
    }

    Value value() => Value(elements[1]);
}

struct FrontElement
{
    string key;
    Value value;
}

struct Value
{
    private Element element;

    Plist asDict()
    {
        assert(element.name == "dict", element.name);
        return Plist(element);
    }
}
