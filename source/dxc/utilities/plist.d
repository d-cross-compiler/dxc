module dxc.utilities.plist;

import std;

import dxml.dom;

import lime.core.optional;

struct Plist
{
    private Element root;

    static Plist parse(string data)
    {
        auto root = parseDOM(data).children.front;
        auto rootDict = root.children.front;

        return Plist(rootDict);
    }

    static Array emptyArray() => Array([]);

    Optional!int getInteger(string key) =>
        getTextFor(key, ofType: "integer").map(e => e.to!int);

    Optional!string getString(string key) => getTextFor(key, ofType: "string");

    Optional!SysTime getDate(string key) =>
        getTextFor(key, ofType: "date").map(e => SysTime.fromISOExtString(e));

    Optional!Plist getDict(string key) =>
        getElementFor(key, ofType: "dict").map(e => Plist(e));

    Optional!Array getArray(string key) =>
        getElementFor(key, ofType: "array").map(e => Array(e.children));

    ByKeyValueRange byKeyValue() => ByKeyValueRange(root.children);
    ByValueRange byValue() => ByValueRange(root.children);
    bool containsKey(string key) => indexOfKey(key) != -1;

private:

    Optional!string getTextFor(string key, string ofType) =>
        getElementFor(key, ofType)
            .map(e => e.children.front.text);

    Optional!Element getElementFor(string key, string ofType)
    {
        const index = indexOfKey(key);

        if (index == -1)
            return none!Element;

        auto element = root.children[index + 1];
        assert(element.name == ofType, element.name);
        return element.some;
    }

    size_t indexOfKey(string key) =>
        root
            .children
            .countUntil!(e => e.name == "key" && e.children.front.text == key);
}

private:

alias Element = DOMEntity!string;

struct ByValueRange
{
    private Element[] elements;

    Value front() => Value(elements[1]);

    void popFront()
    {
        elements.popFront();
        elements.popFront();
    }

    bool empty() => elements.empty;
}

struct ByKeyValueRange
{
    private ByValueRange base;
    alias base this;

    this(Element[] elements)
    {
        base = ByValueRange(elements);
    }

    FrontElement front() => FrontElement(key, base.front);

    void popFront()
    {
        base.popFront();
    }

    bool empty() => base.empty;

private:

    string key()
    {
        auto keyElement = elements.front;
        assert(keyElement.name == "key", keyElement.name);

        return keyElement.children.front.text;
    }
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

struct Array
{
    private Element[] elements;

    Value front() => Value(elements[0]);
    void popFront() => elements.popFront();
    bool empty() => elements.empty;
}
