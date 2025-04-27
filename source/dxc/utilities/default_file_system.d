module dxc.utilities.default_file_system;

import std.file;
import std.path;

import dxc.utilities.data;
import dxc.utilities.file_system;

class DefaultFileSystem : FileSystem
{
    void write(Data data, string to)
    {
        const path = to.absolutePath;
        mkdirRecurse(path.dirName);
        .write(path, data.bytes);
    }
}
