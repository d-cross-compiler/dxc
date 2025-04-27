module dxc.application.arguments;

import std.sumtype;

import argparse;

@(
    Command("dxc")
    .Description(
        "D Cross Compiler"
    )
)
struct Arguments
{
    SumType!(Sdk) command;
}

@(
    Command("sdk")
    .Description("Manage SDKs")
)
struct Sdk
{
    @(
        Command("install")
        .Description("Download and install the SDK for the given target triple.")
    )
    static struct Install
    {
        @(
            PositionalArgument(0)
            .Description("The target triple of the SDK to install")
        )
        string target;
    }

    SumType!(Install) command;
}
