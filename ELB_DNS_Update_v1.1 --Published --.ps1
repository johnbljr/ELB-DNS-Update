<#
------------------------------------------------------------
Author: John Leger
Date: Feb. 20, 2019
Powershell Version Built/Tested on: 5.1
Title: PowerShell Bulk AD User Creation from CSV
Website: https://github.com/johnbljr
License: GNU General Public License v3.0
------------------------------------------------------------
#>   

## Must be run as Domain Admin

$DNSServer = 'DNSServerName'
$csv = Import-Csv c:\temp\ELB.csv
foreach ($element in $csv)
    {
        $azDNS = $Element.Name
        $rec = $Element.Record

$ns = (nslookup.exe $azDNS)[-4..-3]
$lookup = [PSCustomObject]@{
Name = ($ns[0] -split ‘:’)[1].Trim()
Address = ($ns[1] -split ‘:’)[1].Trim()
Record = $rec
        }
$lookup  | Export-csv C:\temp\DNS.csv -notypeinformation
    }

$csv1 = Import-csv c:\Temp\DNS.csv
foreach ($rec in $csv) 
{
$Address = $csv1.Address
$aRec = Get-DnsServerResourceRecord -Name $rec.Record -ZoneName $rec.Record -Computer $DNSServer -rrtype A
$ip = $aRec 
$ip | Select -expand recorddata |export-csv c:\temp\recdata.csv -notypeinformation
$csv2 = Import-Csv c:\temp\recdata.csv
$locrec = $csv2.ipv4address
if ($locrec -eq $Address)
    {
#exit
    }
else
    {
Remove-DnsServerResourceRecord -ZoneName $csv1.Record -name $csv1.Record -RRType A -ComputerName apexdcw01 -Confirm:$false -force
Add-DnsServerResourceRecordA -ZoneName $csv1.Record -name $csv1.Record -IPv4Address $csv1.Address -ComputerName $DNSServer  
    }
}  

<#
CSV File Format
Name,Record
a1cc5a304b5c911e8aecd02164f9a6e4-1924120963.us-east-2.elb.amazonaws.com,1800.apexsupplychain.com
#>
