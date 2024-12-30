module dxc.utilities.data;

struct Data
{
    private immutable(ubyte)[] bytes_;

    this(immutable(ubyte)[] bytes)
    {
        bytes_ = bytes;
    }

    this(string value)
    {
        bytes_ = cast(immutable(ubyte)[]) value;
    }

    static assumeUnique(char[] bytes) => Data(cast(immutable(ubyte)[]) bytes);

    immutable(ubyte)[] bytes() => bytes_;
}
