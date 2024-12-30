module dxc.utilities.phobos_downloader;

import dxc.utilities.data;
import dxc.utilities.downloader;

class PhobosDownloader : Downloader
{
    import std.net.curl;
    import std.exception;

    Data download(string url) => Data.assumeUnique(get(url));
}
