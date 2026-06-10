# Active Directory Lab Runbook

## Objective

Build a small Windows domain lab that demonstrates identity services, DHCP/DNS configuration, client network validation, and scripted account provisioning.

## Build Steps

1. Create two VirtualBox VMs:
   - Windows Server for the domain controller.
   - Windows client for domain/network validation.
2. Configure the domain controller with:
   - NAT adapter for internet access if needed.
   - Internal network adapter for lab traffic.
3. Configure the internal adapter on the domain controller:
   - IP address: `172.16.0.1`
   - Subnet mask: `255.255.255.0`
   - DNS: `127.0.0.1`
4. Install Active Directory Domain Services and promote the server.
5. Configure the domain as `mydomain.com`.
6. Install and configure DHCP:
   - Scope: `172.16.0.0/24`
   - Router/default gateway option: `172.16.0.1`
   - DNS server option: `172.16.0.1`
7. Connect the Windows client to the same VirtualBox internal network.
8. Confirm the client receives DHCP from the domain controller.
9. Validate client connectivity:
   - `ipconfig /all`
   - `ping 172.16.0.1`
10. Run the PowerShell user provisioning script from an elevated PowerShell session on the domain controller.

## Validation Checklist

- Domain controller has static IP `172.16.0.1`.
- DHCP scope is active.
- Client receives an IP lease from the domain controller.
- Client uses `172.16.0.1` for DNS.
- Client can ping the domain controller.
- Bulk user provisioning script creates enabled AD users.

## Notes for Public Sharing

- Do not publish real passwords or private user data.
- Redact personal workstation usernames and email addresses from screenshots.
- Use documentation to explain intent, validation, and business value.
