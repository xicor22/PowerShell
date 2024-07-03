oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression

function haos {
    ssh -m hmac-sha2-512-etm@openssh.com hassio@192.168.1.215
}

function rpi {
    ssh saksham@192.168.1.85
}

function winutil{
    irm "https://christitus.com/win" | iex
}

function adbi
{
    $url="https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    $loc= "C:\platform-tools-latest-windows.zip"
    $unziploc="C:\"
    $comnd=adb > $null
    if ($comnd -match "is not recognized as an internal or external command.")
    {
        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
            {
                Write-Output "Run with admin privilages."
                exit
            }
        Invoke-WebRequest -Uri $url -OutFile $loc
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($loc, $unziploc)
        Rename_Item "$loc adb"
        [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\adb', [System.EnvironmentVariableTarget]::User)
        [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\adb', [System.EnvironmentVariableTarget]::Machine)
    }
}

function dis
{
    adb disconnect
}

function phone{
    adbi
    if (-not $args)
    {
        Write-Output "!!!You forgot to enter the port number!!!"
        return
    }
    $port= $args[0]
    $out = adb connect 192.168.1.100:$port
    if ($out -match "connected to"){
        Write-Output "Connected to Moto"
    }
    else{
        $new=Read-Host "Enter a different IP and Port: "
        $out1= adb connect $new
        if ($out1 -match "connected to") {
            Write-Output "Connected to Moto"
        }
        else {
            Write-Output "Unable to connect. Entering pairing mode"
            $pair = Read-Host "Enter the IP and Port: "
            $out2= adb pair $pair
            if ($out2 -match "Successfully paired to"){
                Write-Output "Paired and connected to Moto"
            }
            else{
                Write-Output "Please check the logs for the error"
            }
        }
    }
}
