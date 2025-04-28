import { vpnExtension } from "@kit.NetworkKit"

export interface Sniffing {
  enabled: boolean
  overrideDestinationForProtocol: string[]
  metadataOnly: boolean
  routeOnly: boolean
}

export interface Inbound {
  tag: string
  fd: number
  config: vpnExtension.VpnConfig
  sniffing: Sniffing
}