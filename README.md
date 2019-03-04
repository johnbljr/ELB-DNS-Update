# ELB-DNS-Update

PowerShell - Update DNS entries for Elastic Load Balancer Changes


Revisions

March 4, 2019

Version 1.1

Pulls DNS info from the csv provided then performs an NSlookup on that information.

If the information is different from what what is in the DNS record on your Windows DNS server the script will then update that DNS information. 

I have this script running as a scheduled task on my server. You can either run it as a scheduled task or as needed.
