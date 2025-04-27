module dxc.application.application;

import std;

import dxc.application.arguments;
import dxc.application.command;
import dxc.application.commands.sdk.install;

class Application
{
    private string[] rawArguments;
    Arguments arguments;

    this(string[] rawArguments)
    {
        this.rawArguments = rawArguments;
    }

    int run()
    {
        const result = parseArguments();
        return dispatch().run();
    }

private:

    int parseArguments()
    {
        import argparse;

        const result = CLI!Arguments.parseArgs(arguments, rawArguments[1 .. $]);

        writeln(arguments);
        return result.resultCode;
    }

    Command dispatch()
    {
        return arguments.command.match!(
            (Sdk sdk) => sdk.command.match!(
                (Sdk.Install install) => new Install(arguments)
            )
        );
    }
}
