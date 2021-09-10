# Powershell Script By Drew Burgess

cls
$Global:string = Read-Host -Prompt "Enter String to become Secure Key"

Function ConvertStringTo-CharArray() {
    [String]$PlainTextString        = $Global:string
    Sleep 1                         # Wait for content to load in memory
    $OFS = ''                       # Ghetto way to clear seperator
    $PlainTextStringArray           = $PlainTextString.ToCharArray()
    return $PlainTextStringArray
}

Function Reverse-String([String]$prompt) {
    [String]$PlainTextString        = $Global:string
    Sleep 1                         # Wait for content to load in memory
    $OFS = ''                       # Ghetto way to clear seperator
    $PlainTextStringArray           = $PlainTextString.ToCharArray()
    [System.Array]::Reverse($PlainTextStringArray) -join $PlainTextStringArray
    $obj1 = [activator]::CreateInstance([String],[Char[]]$PlainTextStringArray)
    $obj = New-Object System.String($obj1) 
    return $obj
}

Function mk-privatekey() {
    If (Test-Path -Path "C:\temp\Extra\fke.txt" -PathType Leaf) { Set-Content -Path "C:\temp\Extra\fke.txt" -Value ($null) -Force } # Clear log
    [String]$PlainTextString        = $Global:string
    $reversedstring                 = Reverse-String 
    $privateKey                     = "$($PlainTextString)$($reversedstring)"
    $privateKey.Replace(' ','')
    $OriginalSize                   = ($PlainTextString.Length - 1)
    $NewSize                        = $privateKey.Length
    $CustomSize                     = ($NewSize - $OriginalSize)
    $CustomSize2                    = ($CustomSize - $reversedstring)
    If ($OriginalSize -lt $NewSize) { 
        $privateKey.Remove($CustomSize2 - 1)
        cls
    } 
    Else { 
        return $privateKey 
    }
    $privateKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content -Path C:\temp\Extra\fke.txt
}

Function mk-publickey() {
    [String]$PlainTextString        = $Global:string
    $reversedstring                 = Reverse-String
    $publicKey                      = "$($reversedstring)$($PlainTextString)"
    $publicKey.Replace(' ','')
    $OriginalSize                   = $PlainTextString.Length
    $NewSize                        = $publicKey.Length
    $CustomSize                     = ($NewSize - $OriginalSize)
    $CustomSize2                    = ($CustomSize - $reversedstring)
    If ($OriginalSize -lt $NewSize) { 
        $publicKey.Remove($CustomSize2 - 1)
        cls
    } 
    Else { 
        return $publicKey 
    }
}

Function get-key {
    $oc = Get-Content -LiteralPath "C:\temp\Extra\fke.txt" | ConvertTo-SecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($oc)) 
    return $BSTR
}


$result = mk-publickey
$result2 = mk-privatekey
$Dresult = get-key
$GetSS = Get-Content -Path "C:\temp\Extra\fke.txt"
Write-Host "`nNew Decrypted Private Key (SERVER SIDE):`n$result" 
Write-Host "`nNew Decrypted Public Key (CLIENT SIDE):`n$result2"
Write-Host "`nNew Encrypted Key From File:`n$GetSS" # data at rest




<#
Sources:

For Fixing the conversion from CharArray back to string (This one honestly stumped me for a while)
https://microsoft.public.windows.powershell.narkive.com/Ubcltgso/problem-calling-string-char-value-constructor

#>
