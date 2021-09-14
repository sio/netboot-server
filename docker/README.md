# Docker image for network boot server

When using with `network_mode: host` the following ports need to be open on
host
([docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/mt670791(v=ws.11)))

- `udp/67` - BOOTP server
- `udp/68` - BOOTP client
- `udp/69` - TFTP server
- `udp/4011` - PXE server
