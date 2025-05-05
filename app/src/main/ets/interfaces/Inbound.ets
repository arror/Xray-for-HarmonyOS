export interface TunSniffingConfig {
  enabled: boolean
  overrideDestinationForProtocol: string[]
  metadataOnly: boolean
  routeOnly: boolean
}

export interface TunConfig {
  tag: string
  fd: number
  mtu: number
  sniffing: TunSniffingConfig
}