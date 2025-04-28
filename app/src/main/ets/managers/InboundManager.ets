import { PreferencesUtil } from "@pura/harmony-utils"
import { Inbound } from "../interfaces/Inbound"

const InboundKey = 'INBOUND_KEY'

@ObservedV2
export class InboundManager {

  static readonly inboundTag: string = 'tun'
  static readonly inboundAddress: string = '172.16.0.1'
  static readonly inboundAddressPrefixLength: number = 30
  static readonly inboundDNSAddress: string = '172.16.0.2'
  static readonly inboundMTU: number = 1500

  @Trace sniffingEnabled: boolean = false
  @Trace sniffingOverrideDestinationForProtocol: string[] = []
  @Trace sniffingMetadataOnly: boolean = false
  @Trace sniffingRouteOnly: boolean = false

  private static readonly default: Inbound = {
    tag: InboundManager.inboundTag,
    fd: 0,
    config: {
      addresses: [
        {
          address: {
            address: InboundManager.inboundAddress
          },
          prefixLength: InboundManager.inboundAddressPrefixLength
        }
      ],
      dnsAddresses: [InboundManager.inboundDNSAddress],
      mtu: InboundManager.inboundMTU
    },
    sniffing: {
      enabled: false,
      overrideDestinationForProtocol: [],
      metadataOnly: false,
      routeOnly: false
    }
  }

  constructor() {
    const inbound = PreferencesUtil.getSync(InboundKey, InboundManager.default) as Inbound
    this.sniffingEnabled = inbound.sniffing.enabled ?? false
    this.sniffingOverrideDestinationForProtocol = inbound.sniffing.overrideDestinationForProtocol ?? []
    this.sniffingMetadataOnly = inbound.sniffing.metadataOnly ?? false
    this.sniffingRouteOnly = inbound.sniffing.routeOnly ?? false
  }

  update(): void {
    PreferencesUtil.put(InboundKey, {
      tag: InboundManager.default.tag,
      config: InboundManager.default.config,
      sniffing: {
        enabled: this.sniffingEnabled,
        overrideDestinationForProtocol: this.sniffingOverrideDestinationForProtocol,
        metadataOnly: this.sniffingMetadataOnly,
        routeOnly: this.sniffingRouteOnly
      }
    } as Inbound)
  }

  static inbound(): Inbound {
    return PreferencesUtil.getSync(InboundKey, InboundManager.default) as Inbound
  }
}