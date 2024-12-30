module dxc.utilities.downloader;

import dxc.utilities.data;
import dxc.utilities.phobos_downloader;

interface Downloader
{
    Data download(string url);

    static Downloader default_() => new PhobosDownloader;
}
