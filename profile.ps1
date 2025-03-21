oh-my-posh init pwsh --config 'C:\Users\Saksham\Documents\PowerShell\theme.json' | Invoke-Expression
function adbi   #untested
{
    $url="https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    $loc= "C:\platform-tools-latest-windows.zip"
    $unziploc="C:\"
    $comnd=adb >$null 2>&1
    if ($comnd -match "is not recognized as an internal or external command.")
    {
        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
            {
                Write-Output "Run with admin privilages."
                exit
            }

        else{
            Invoke-WebRequest -Uri $url -OutFile $loc
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory($loc, $unziploc)
            Rename_Item "$loc adb"
            [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\adb', [System.EnvironmentVariableTarget]::User)
            [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\adb', [System.EnvironmentVariableTarget]::Machine)
            }
    }
}

function dis
{
    adb disconnect >$null 2>&1
    Write-Output "Disconnected all."
}

function phone{
    adbi
    if (-not $args)
    {
        Write-Output "!!!You forgot to enter the port number!!!"
        return
    }
    $port= $args[0]
    $out = adb connect 192.168.1.100:$port 2>&1
    Start-Sleep -Seconds 5
    if ($out -match "connected to"){
        Write-Output "Connected to Moto"
        return
    }
    $new=Read-Host "Enter a different IP and Port: "
    $out1= adb connect $new 2>&1
    Start-Sleep -Seconds 5
    if ($out1 -match "connected") {
        Write-Output "Connected to Moto"
        return
    }
    else {
        Write-Output "Unable to connect. Entering pairing mode"
        $pair = Read-Host "Enter the IP and Port: "
        $out2= adb pair $pair >$null 2>&1
        Start-Sleep -Seconds 5
        if ($out2 -match "Successfully paired to"){
            Write-Output "Paired and connected to Moto"
            return
        }
        else{
            Write-Output "Please check the logs for the error"
        }
        }
    }

function find{
    nano $(fzf --preview="bat --color=always {}")
}

function of{
    shutdown -a >$null 2>&1
    $sec=$args[0]*60
    shutdown -s -t $sec
}

function deej{
    taskkill /IM deej.exe /F >$null 2>&1
    cd "S:\Tools\Deej"
    .\deej.exe
    cd
}

Set-Alias cat bat

Set-Alias ccd zi

function wrt{
    clear
    ssh root@192.168.1.1
}

function site{
    $pro_path="S:\PROG\swastik-art"
    $del_path=Join-Path -Path $pro_path -ChildPath ".next"
    if (Test-Path -Path $del_path -PathType Container) {
        Remove-Item -Path $del_path -Recurse -Force
    }
    npm --prefix $pro_path run dev
}

function dpi{
    cd S:\Tools\byedpi
    .\dpi.cmd
    exit
}
