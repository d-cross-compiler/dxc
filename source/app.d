import std.stdio;

// version (unittest) {} else:
void main()
{
	writeln("Edit source/app.d to start your project.");
}

@("foo") unittest
{
    assert(false);
}

@("bar") unittest
{

}
