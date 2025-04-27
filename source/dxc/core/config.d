module dxc.core.config;

import std.path;

const struct Config
{
    const string baseDirectory = buildPath("~", ".dxc");
    const string tempDirectory = buildPath(baseDirectory, "temp");
    const string sdkVersion = "0.0.1";
}
