Param (
    [Parameter(Mandatory)]
    $Action
)

$config = Get-Content .\config.json -Raw | ConvertFrom-Json
$hosts_tmp_file = ".\scripts\hosts.tmp"
New-Item $hosts_tmp_file -Force | Out-Null

# Generate 'hosts' file with items for all nodes in cluster
For ($i = 1; $i -le $config.controlNodes.numNodes; $i++)
# Write names and ip addresses for master nodes
{
    $hostname = "$($config.controlNodes.namePrefix)-0${i}"
    $ip = "$($config.network.hostsNetwork)$($config.network.controlNodesIpStart + $i)"
    Add-Content -Path $hosts_tmp_file -Value "$ip $hostname $($hostname).local"
}
# Write names and ip addresses for worker nodes
For ($i = 1; $i -le $config.workerNodes.numNodes; $i++)
{
    $hostname = "$($config.workerNodes.namePrefix)-0${i}"
    $ip = "$($config.network.hostsNetwork)$($config.network.workerNodesIpStart + $i)"
    Add-Content -Path $hosts_tmp_file -Value "$ip $hostname $($hostname).local"
}

If ($Action -eq 'create') {
    Write-Host "Creating environment..."
    vagrant up
} ElseIf ($Action -eq 'destroy') {
    Write-Host "Destroying environment..."
    vagrant destroy -f
} ElseIf ($Action -eq 'verify') {
    Write-Host "Verifying environment..."
    vagrant status
} Else {
    Write-Host "Not supported parameter for action: $Action"
}