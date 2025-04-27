module dxc.application.commands.sdk.install;

import dxc.application.arguments;
import dxc.application.command;
import dxc.core.target;
import dxc.sdk.installer;

class Install : Command
{
    this(Sdk.Install arguments)
    {
        this.arguments = arguments;
    }

    int run()
    {
        Installer.forTarget(target).install();
        return 0;
    }

private:

    const Sdk.Install arguments;

    string triple() => arguments.target;
    Target target() => Target.parse(triple);
}
