module dxc.core.target;

import std.conv;
import std.string;

import lime.core.optional;

immutable struct Target
{
    enum Architecture
    {
        unknown,
        x86_64
    }



    string triple;
    Architecture architecture;

    static Target parse(string triple) => TripleParser(triple).parse();
}

private:

struct TripleParser
{
    private Optional!(string[]) components_;
    private string triple;

    this(string triple)
    {
        this.triple = triple;
    }

    Target parse()
    {
        switch (components.length)
        {
            case 1: return Target(architecture: toArchitecture(components[0]));
            case 2: return Target(
                architecture: toArchitecture(components[0]),
                // operatingSystem: toOperatingSystem(components[1]),
            );
            case 3: return Target(
                triple: triple,
                architecture: toArchitecture(components[0])
            );
            default:
                assert(0);
        }

        return Target();
    }

private:

    string[] components()
    {
        return triple.split("-");
        // if (components_)
        //     return components_.get;
        //
        // components_ = triple.split("-");
        // return components_.get;
    }

    Target.Architecture toArchitecture(string value)
    {
        try return value.to!(Target.Architecture);

        catch (ConvException)
            return Target.Architecture.unknown;
    }
}
