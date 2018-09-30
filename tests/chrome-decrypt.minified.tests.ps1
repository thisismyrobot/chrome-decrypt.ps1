$scriptRoot = Split-Path $MyInvocation.MyCommand.Path

Describe "testing minified script execution" {

    It "lists all accounts" {

        $env:LOCALAPPDATA = "$scriptRoot"

        .\chrome-decrypt.minified.ps1 | Should -Be @('https://www.example.com/', 'john.doe@gmail.com', 'P@ssword!1234')
    }
}
