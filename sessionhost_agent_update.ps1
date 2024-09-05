Connect-Azaccount -identity

$all_hostpools=Get-AzResource | Select-Object Name,ResourceGroupName,ResourceType | Where-Object {$_.ResourceType -EQ "Microsoft.DesktopVirtualization/hostpools"}
$out_of_date_sessionhosts = 0

foreach ($hostpool in $all_hostpools){
       
        write-output "Checking hostpool:  $($hostpool.Name)"
        $sessionHosts = Get-AzWvdSessionHost -ResourceGroupName $hostpool.ResourceGroupName -HostPoolName $hostpool.Name
        $highestAgentVersion = $sessionHosts | Sort-Object -Property AgentVersion -Descending | Select-Object -First 1 -ExpandProperty AgentVersion
        $lowerVersionHosts = @()
        # Loop through each session host and add to the array if the agent version is lower than the highest
        foreach ($sessionHost in $sessionHosts) {
           #Extract VM Name
            $splitted=$sessionhost.Name -split("/")  
            $vm_name = $splitted[1] 
                if ($sessionHost.AgentVersion -lt $highestAgentVersion) {
                $lowerVersionHosts += $sessionHost
                Write-Output "Turning on $vm_name with AVD Agent Version: $($sessionHost.AgentVersion)"
                $vmrg = (Get-AzResource | Select-Object Name,ResourceGroupName | Where-Object {$_.name -like $vm_name}).ResourceGroupName
                Start-AzVM -ResourceGroupName $vmrg -Name $vm_name -NoWait

            $out_of_date_sessionhosts += 1
        }
    }
}
Write-Output "$out_of_date_sessionhosts Session Hosts are out of date"
