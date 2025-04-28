import { socket, vpnExtension } from "@kit.NetworkKit";
import { FileUtil } from "@pura/harmony-utils";
import { InboundManager } from "./InboundManager";
import { Log, LogManager } from "./LogManager";

export enum VpnStatus {
  Disconnected  = 'VPN_STATUS_DISCONNECTED',
  Connecting    = 'VPN_STATUS_CONNECTING',
  Connected     = 'VPN_STATUS_CONNECTED',
  Disconnecting = 'VPN_STATUS_DISCONNECTING'
}

@ObservedV2
export class VpnManager {

  @Trace status: VpnStatus = VpnStatus.Disconnected

  private readonly path = FileUtil.getFilesDirPath(undefined, 'vpn.sock')
  private readonly client: socket.LocalSocket = socket.constructLocalSocketInstance()

  startVpn(id: string): void {
    this.status = VpnStatus.Connecting
    setTimeout(() => {
      FileUtil.unlink(this.path).finally(() => {
        const inbound = InboundManager.inbound()
        vpnExtension.startVpnExtensionAbility({
          deviceId: '',
          bundleName: 'com.arror.vpn',
          abilityName: 'VpnAbility',
          parameters: { id, inbound }
        }).then(() => {
          this.client.on('close', () => this.stopVpn())
          this.connect(20, (ok) => {
            if (ok) {
              this.status = VpnStatus.Connected
            } else {
              this.stopVpn()
            }
          })
        }).catch(() => {
          this.status = VpnStatus.Disconnected
        })
      })
    }, 250)
  }

  stopVpn(): void {
    this.status = VpnStatus.Disconnecting
    setTimeout(() => {
      this.client.off('close')
      this.client.close().finally(() => {
        vpnExtension.stopVpnExtensionAbility({
          deviceId: '',
          bundleName: 'com.arror.vpn',
          abilityName: 'VpnAbility'
        }).finally(() => {
          this.status = VpnStatus.Disconnected
        })
      })
    }, 250)
  }

  private connect(retry: number, callback: Callback<boolean>): void {
    if (retry <= 0) {
      callback(false)
    } else {
      this.client.connect({ address: { address: this.path } }).then(() => {
        callback(true)
      }).catch(() => {
        setTimeout(() => this.connect(retry - 1, callback), 100)
      })
    }
  }

  async processConfig(path: string): Promise<void> {
    interface Any {}
    interface OutboundStreamSettings {
      sockopt: Any | undefined
    }
    interface Outbound {
      streamSettings: OutboundStreamSettings | undefined
    }
    interface Config {
      log: Log
      api: Any | undefined
      policy: Any | undefined
      transport: Any | undefined
      inbounds: Any | undefined
      outbounds: Array<Outbound> | undefined
      stats: Any | undefined
      reverse: Any | undefined
      metrics: Any | undefined
      observatory: Any | undefined
      burstObservatory: Any | undefined
    }
    const config = JSON.parse(await FileUtil.readText(path)) as Config
    config.api = undefined
    config.policy = undefined
    config.transport = undefined
    config.inbounds = undefined
    if (config.outbounds) {
      config.outbounds.forEach((ob) => {
        if (ob.streamSettings) {
          ob.streamSettings.sockopt = undefined
        }
      })
    }
    config.stats = undefined
    config.reverse = undefined
    config.metrics = undefined
    config.observatory = undefined
    config.burstObservatory = undefined
    config.log = LogManager.log()
    await FileUtil.writeEasy(path, JSON.stringify(config), false)
  }
}