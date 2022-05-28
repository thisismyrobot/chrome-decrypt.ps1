# chrome-decrypt.ps1

This script dumps Chrome saved credentials, taking advantage of the fact that
Win10 now ships with SQLite support *built-in* (as winsqlite3.dll).

This dramatically reduces the payload size for this script, as opposed to
needing to include or download System.Data.SQLite.dll.

Tested with PowerShell 5.1 Windows 10, and also supports PowerShell 7.x.

## TODO

 * Unicode passwords (may work, I haven't tested).

## Minified version

This is hand-minified (1267 chars), if you can do better please consider
opening a PR so I can include it here and give your PS minification skills
some credit! :)

## Acknowledgements

This script wouldn't have happened without the guidance from these examples:

 * https://github.com/p0z/CPD
 * https://github.com/ValterBricca/SQLite.Net-PCL
 * https://github.com/ericsink/SQLitePCL.raw
 * https://github.com/byt3bl33d3r/chrome-decrypter
 * https://github.com/agentzex/chrome_v80_password_grabber
 * https://github.com/0xfd3/Chrome-Password-Recovery

## I have to say it...

This is for educational purposes only, please don't misuse this script.