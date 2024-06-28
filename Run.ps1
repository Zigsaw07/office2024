function DownloadAndRun-Executable {
    param (
        [string] $url
    )

    try {
        # Create a temporary file path with the .exe extension
        $tempFilePath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName() + ".exe")

        # Download the executable from the provided URL
        iwr $url -OutFile $tempFilePath -ErrorAction Stop

        # Unblock the downloaded file to prevent security warnings
        Unblock-File -Path $tempFilePath -ErrorAction Stop

        # Run the executable with administrator rights
        Start-Process -FilePath $tempFilePath -Verb RunAs -Wait

        # Clean up: Delete the temporary file after execution
        Remove-Item -Path $tempFilePath -Force
    }
    catch {
        Write-Error "Failed to download or run executable from $url. Error: $_"
    }
}

function Execute-RemoteScript {
    param (
        [string] $url
    )

    try {
        # Fetch and execute the remote script
        iwr $url | iex
    }
    catch {
        Write-Error "Failed to execute remote script from $url. Error: $_"
    }
}

# URLs of the executables to download and run
$urls = @(
    'https://github.com/Zigsaw07/office2024/raw/main/MSO-365.exe',
    'https://github.com/Zigsaw07/office2024/raw/main/Ninite.exe',
    'https://github.com/Zigsaw07/office2024/raw/main/RAR.exe'
)

# URL of the remote script to execute
$remoteScriptUrl = 'https://get.activated.win'

# Loop through each URL and execute the download and run function
foreach ($url in $urls) {
    DownloadAndRun-Executable -url $url
}

# Execute the remote script
Execute-RemoteScript -url $remoteScriptUrl
