module dxc.utilities.algorithms;

template flatMap(func...)
if (func.length >= 1)
{
    import std.range : isInputRange, tee;
    import std.traits : Unqual;
    import std.algorithm : cache, map, joiner;

    auto flatMap(Range)(Range range)
    if (isInputRange!(Unqual!Range)) => map!func(range).cache.joiner;
}

///
unittest
{
    import std.algorithm : equal;

    [1, 2, 3, 4]
        .flatMap!(e => [e, -e])
        .equal([1, -1, 2, -2, 3, -3, 4, -4]);
}
