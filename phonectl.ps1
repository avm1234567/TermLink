param(
    [string]$cmd,
    [string]$arg1,
    [string]$arg2
)


$PHONE = "http://192.168.0.193:6969"   # your phone IP
$API_KEY = "API-KEY"                    # same as in server.py

$headers = @{ "x-api-key" = $API_KEY }

switch ($cmd) {

    "battery" {
        Invoke-WebRequest -Uri "$PHONE/battery" -Headers $headers | Select-Object -ExpandProperty Content
    }

    "notif" {
        Invoke-WebRequest -Uri "$PHONE/notif" -Headers $headers | Select-Object -ExpandProperty Content
    }

    "vibrate" {
        if (-not $arg1) { Write-Host "Usage: phonectl vibrate <duration_ms>"; break }
        $body = @{ "duration" = $arg1 } | ConvertTo-Json
        Invoke-WebRequest -Method POST -Uri "$PHONE/vibrate" -Headers $headers -Body $body -ContentType "application/json"
    }

    "get" {
        if (-not $arg1 -or -not $arg2) { Write-Host "Usage: phonectl get <local_file> <phone_file>"; break }
        $body = @{ "path" = $arg2 } | ConvertTo-Json
        Invoke-WebRequest -Method POST -Uri "$PHONE/send" -Headers $headers -Body $body -ContentType "application/json" -OutFile $arg1
        Write-Host "Downloaded $arg2 → $arg1"
    }

    "send" {
        if (-not $arg1) { Write-Host "Usage: phonectl send <local_file>"; break }

        $filePath = $arg1
        $fileName = Split-Path $filePath -Leaf

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $base64 = [System.Convert]::ToBase64String($bytes)

        $json = @{ "file" = $base64; "filename" = $fileName } | ConvertTo-Json -Compress

        Invoke-RestMethod -Uri "$PHONE/receive" -Method Post -Body $json -ContentType "application/json" -Headers @{ "x-api-key" = $API_KEY }

        Write-Host "Uploaded $arg1 → phone"
    }




    default {
        Write-Host "Usage: phonectl [battery|notif|vibrate|get|send]"
    }
}
