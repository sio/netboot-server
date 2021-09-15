# iPXE boot scripts

Serve this directory from any HTTP server and point the PXE server to
`main.ipxe` via `IPXE_SCRIPT_URL`

`main.ipxe` will attempt to load client-specific configuration or will
fall back to generic boot instructions.
