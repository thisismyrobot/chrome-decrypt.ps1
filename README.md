# chrome-decrypt.ps1

This script dumps Chrome saved credentials, taking advantage of the fact that
Win10 now ships with SQLite support *built-in* (as winsqlite3.dll).

This dramatically reduces the payload size for this script, as opposed to
needing to include or download System.Data.SQLite.dll.

Tested with PowerShell 5.1 Windows 10.

## TODO

 * Unicode passwords.
 * Chrome v80.
 * Chrome v80 minified.

## Minified version

This is hand-minified (870 chars), if you can do better please consider
opening a PR so I can include it here and give your PS minification skills
some credit! :)

NOTE: This version doesn't support passwords created after Chrome v80.

## Acknowledgements

This script wouldn't have happened these examples and documentation:

 * https://github.com/p0z/CPD
 * https://github.com/ValterBricca/SQLite.Net-PCL
 * https://github.com/ericsink/SQLitePCL.raw
 * https://github.com/byt3bl33d3r/chrome-decrypter
 * https://github.com/agentzex/chrome_v80_password_grabber/blob/master/chrome_v80_password_grabber.py
