/*
 * config/local/general.h
 *
 * iPXE build configuration <https://ipxe.org/buildcfg>
 */

//#define DOWNLOAD_PROTO_HTTPS
#undef NET_PROTO_IPV6  // IPv6 is broken on my router

#define NSLOOKUP_CMD
#define PING_CMD

/* Compatibility with netboot.xyz */
#define CONSOLE_CMD           /* Console command */
#define DIGEST_CMD            /* Image crypto digest commands */
#define IMAGE_TRUST_CMD       /* Image trust management commands */
#define NTP_CMD               /* NTP commands */
#define PARAM_CMD             /* Form parameter commands */
#define PCI_CMD               /* PCI commands */
#define POWEROFF_CMD          /* Power off commands */
#define REBOOT_CMD            /* Reboot command */
#define TIME_CMD              /* Time commands */
#define VLAN_CMD              /* VLAN commands */
