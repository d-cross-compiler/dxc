module dxc.utilities.downloader;

import dxc.utilities.phobos_downloader;

interface Downloader
{
    string download(string url);

    static Downloader defaultDownloader() => new PhobosDownloader;
}
