module dxc.core.target;

immutable struct Target
{
    string triple;

    static Target parse(string triple) => Target(triple);
}
