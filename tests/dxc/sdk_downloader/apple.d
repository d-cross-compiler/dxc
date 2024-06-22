import dxml.dom;
import std;

import dxc.utilities.plist;

struct AppleDownloader
{
    void download()
    {
        // .download("https://swscan.apple.com/content/catalogs/others/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog");
    }
}

bool isProducts(T)(T element) =>
    element.name == "key" &&
    element.children.front.text == "Products";



@"Download macOS SDK" unittest
{
    const catalog = readText("/Users/jacobcarlborg/development/d/dxc/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.plist");
    auto root = parseDOM(catalog).children[0];
    auto rootDict = root.children[0];
    auto plist = Plist(rootDict);

    // auto productsIndex = rootDict.children.countUntil!isProducts;

//    rootDict.children.map!(e => e.name).writeln;

//    auto productsIndex = rootDict
//        .children
//        .countUntil!(e => e.name == "key" && e.text == "Products");

}
