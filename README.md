# chrome-decrypt.ps1

This script dumps Chrome saved credentials, taking advantage of the fact that
Win10 now ships with SQLite support *built-in* (as winsqlite3.dll).

This dramatically reduces the payload size for this script, as opposed to
needing to include or download System.Data.SQLite.dll.

Tested with Powershell 5 on Windows 10.

## TODO

I haven't tested Unicode passwords yet.

## Minified version

This is hand-minified (897 chars), if you can do better please consider
opening a PR so I can include it here and give your PS minification skills
some credit! :)

## Acknowledgements

This script wouldn't have happened these examples and documentation:

 * https://github.com/p0z/CPD
 * https://github.com/ValterBricca/SQLite.Net-PCL
 * https://github.com/ericsink/SQLitePCL.raw
 * https://github.com/byt3bl33d3r/chrome-decrypter
