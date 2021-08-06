# Reverse Tunnel Wizard

This createTunnelWizard.sh creates a SystemD service to set up an autossh reverse tunnel.
This is useful for a REMOTE system (under your authorization and your control) that is behind a firewall, etc., 
which you can SSH to an external INTERMEDIATE location.

* This requires a REMOTE Port Identifier ([probably best to skip well known registered ports](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers))
* INTERMEDIATE username, interUser 
* INTERMEDIATE address, interAddress


If this is your case, you can run this script as su, have it create an autotunnel user, and create a systemD 
service to make an auto rehealing tunnel to an INTERMEDIATE server automatically. 
Then, from your LOCAL (laptop at a cafe, computer at home, iPhone on the subway, etc.) you will be able to log into your 
INTERMEDIATE using 
```
ssh <interUser>@<interAddress>
```
and from the INTERMEDIATE, connect using the REMOTE tunnel:
```
ssh -p <REMOTE PORT ID> <REMOTE user id>@localhost
```
where `<REMOTE user id>` is your user account on the REMOTE computer you wish to connect.
***
Hat-tip to: [https://hobo.house/2016/06/20/fun-and-profit-with-reverse-ssh-tunnels-and-autossh/](https://hobo.house/2016/06/20/fun-and-profit-with-reverse-ssh-tunnels-and-autossh/) for a clear working write-up.

Offered under the MIT License: [https://github.com/jacobfnl/reverse_tunnel_wizard/blob/main/LICENSE](https://github.com/jacobfnl/reverse_tunnel_wizard/blob/main/LICENSE)
