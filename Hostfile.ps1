#For use within Chick Fil A Environment Only
#Created by Drew Rollins - drollins@securethinking.com
#Powershell script to change host file to those needed for Manitou

function setHostEntries([hashtable] $entries) {
    $hostsFile = "$env:windir\System32\drivers\etc\hosts"
    $newLines = @()

    $c = Get-Content -Path $hostsFile
    foreach ($line in $c) {
        $bits = [regex]::Split($line, "\s+")
        if ($bits.count -eq 2) {
            $match = $NULL
            ForEach($entry in $entries.GetEnumerator()) {
                if($bits[1] -eq $entry.Key) {
                    $newLines += ($entry.Value + '     ' + $entry.Key)
                    Write-Host Replacing HOSTS entry for $entry.Key
                    $match = $entry.Key
                    break
                }
            }
            if($match -eq $NULL) {
                $newLines += $line
            } else {
                $entries.Remove($match)
            }
        } else {
            $newLines += $line
        }
    }

    foreach($entry in $entries.GetEnumerator()) {
        Write-Host Adding HOSTS entry for $entry.Key
        $newLines += $entry.Value + '     ' + $entry.Key
    }

    Write-Host Saving $hostsFile
    Clear-Content $hostsFile
    foreach ($line in $newLines) {
        $line | Out-File -encoding ASCII -append $hostsFile
    }
}

$entries = @{
    'la-man-review' = "10.2.10.230"
    'la-man-review2' = "10.2.10.231"
    'MC-MAN-CHKFILA' = "10.1.10.237"
    'MC-MAN-CHKFILA.co.manitoucloud.com' = "10.1.10.237"
    'CO-MAN-CHKFILA' = "10.1.11.237"
    'CO-MAN-CHKFILA.co.manitoucloud.com' = "10.1.11.237"
    'LA-MAN-CHKFILA' = "10.2.10.237"
    'LA-MAN-CHKFILA.co.manitoucloud.com' = "10.2.10.237"
    'AW-MAN-CHKFILA' = "127.27.2.237"
    'AW-MAN-CHKFILA.co.manitoucloud.com' = "127.27.2.237"
};
setHostEntries($entries)
