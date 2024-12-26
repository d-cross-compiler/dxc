module dxc.utilities.phobos_downloader;

import dxc.utilities.downloader;

class PhobosDownloader : Downloader
{
    import std.net.curl;
    import std.exception;

    string download(string url) => get(url).assumeUnique;
}
