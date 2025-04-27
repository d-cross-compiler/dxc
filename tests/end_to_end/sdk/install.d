import fluent.asserts;
import fluentasserts.core.operations.registry;

import std;
import std.file : fileExists = exists;

struct path
{
    string path;

    string toString() => path;
}

IResult[] exist(ref Evaluation evaluation) @safe nothrow
{
    IResult[] results = [];
    const exists = evaluation.currentValue.strValue.to!path.path.fileExists;

    if ((evaluation.isNegated && !exists) || exists)
        return [];

    const toWord = evaluation.isNegated ? "not to" : "to";
    const actualDidWord = evaluation.isNegated ? "did" : "did not";

    try
    {
        const expectedDescription = i"path $(toWord) exist: ".text ~ evaluation.currentValue.strValue;
        const actualDescription = i"path $(actualDidWord) exist".text;
        results ~= new ExpectedActualResult(expectedDescription, actualDescription);
    }
    catch(Exception e) {}

    return results;
}

static this()
{
    Registry.instance.register("install.path", "unknown", "exist", &exist);
}

@"dxc sdk install" unittest
{
    auto result = execute(["./dxc", "sdk", "install", "x86_64-unknown-freebsd13.1"]);

    expect(result.status).to.equal(0).because(result.output);
    expect(path("tmp/sdk-0.0.1-x86_64-unknown-freebsd13.1.tar.xz")).to.exist;
}

