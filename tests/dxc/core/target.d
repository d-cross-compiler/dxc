import fluent.asserts;

import dxc.core.target;

@"Target.parse - it parses the architecture" unittest
{
    immutable target = Target.parse("x86_64-unknown-freebsd13.1");

    expect(target.architecture).to.equal(Target.Architecture.x86_64);
}
