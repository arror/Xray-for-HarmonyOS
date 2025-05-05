import { PreferencesUtil } from "@pura/harmony-utils"
import { TunSniffingConfig } from "../interfaces/Inbound"

const INBOUND_SNIFFING_KEY = 'INBOUND_SNIFFING_KEY'

@ObservedV2
export class InboundManager {

  @Trace sniffingEnabled: boolean = false
  @Trace sniffingOverrideDestinationForProtocol: string[] = []
  @Trace sniffingMetadataOnly: boolean = false
  @Trace sniffingRouteOnly: boolean = false

  constructor() {
    const sniffing = PreferencesUtil.getSync(INBOUND_SNIFFING_KEY, {
      enabled: false,
      overrideDestinationForProtocol: [],
      metadataOnly: false,
      routeOnly: false
    }) as TunSniffingConfig
    this.sniffingEnabled = sniffing.enabled ?? false
    this.sniffingOverrideDestinationForProtocol = sniffing.overrideDestinationForProtocol ?? []
    this.sniffingMetadataOnly = sniffing.metadataOnly ?? false
    this.sniffingRouteOnly = sniffing.routeOnly ?? false
  }

  update(): void {
    PreferencesUtil.put(INBOUND_SNIFFING_KEY, {
      enabled: this.sniffingEnabled,
      overrideDestinationForProtocol: this.sniffingOverrideDestinationForProtocol,
      metadataOnly: this.sniffingMetadataOnly,
      routeOnly: this.sniffingRouteOnly
    } as TunSniffingConfig)
  }

  static inboundSniffing(): TunSniffingConfig {
    return PreferencesUtil.getSync(INBOUND_SNIFFING_KEY, {
      enabled: false,
      overrideDestinationForProtocol: [],
      metadataOnly: false,
      routeOnly: false
    }) as TunSniffingConfig
  }
}