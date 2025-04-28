import { vpnExtension, VpnExtensionAbility, VpnExtensionContext } from "@kit.NetworkKit";
import { JSON, process, taskpool, util } from "@kit.ArkTS";
import app from "libapp.so";
import { Want } from "@kit.AbilityKit";
import { Inbound } from "../interfaces/Inbound";

export default class VpnAbility extends VpnExtensionAbility {

  private vpnConnection: vpnExtension.VpnConnection = Object()

  async onCreate(want: Want): Promise<void> {
    try {
      this.vpnConnection = vpnExtension.createVpnConnection(this.context)
      if (want.parameters) {
        const inbound = want.parameters['inbound'] as Inbound
        const id = want.parameters['id'] as string
        inbound.fd = await this.vpnConnection.create(inbound.config)
        await taskpool.execute(Run, id, inbound, this.context)
      } else {
        throw new Error
      }
    } catch {
      const pm = new process.ProcessManager()
      pm.exit(0)
    }
  }

  async onDestroy(): Promise<void> {
    await this.vpnConnection.destroy()
  }
}

interface VpnRunConfig {
  id: string
  inbound: Inbound
  filesDir: string
  cacheDir: string
  tempDir: string
}

@Concurrent
function Run(id: string, inbound: Inbound, context: VpnExtensionContext) {
  const cfg: VpnRunConfig = {
    id: id,
    inbound: inbound,
    filesDir: context.filesDir,
    cacheDir: context.cacheDir,
    tempDir: context.tempDir
  }
  const encoder = new util.TextEncoder()
  if (app.run(encoder.encodeInto(JSON.stringify(cfg))) === 0) {
    return
  } else {
    throw new Error('VPN RUN FAILED')
  }
}