module dxc.utilities.file_system;

import dxc.utilities.data;
import dxc.utilities.default_file_system;

interface FileSystem
{
    void write(Data data, string to);

    static opCall() => new DefaultFileSystem;
}
