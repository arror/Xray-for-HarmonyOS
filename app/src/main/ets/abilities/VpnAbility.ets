import { vpnExtension, VpnExtensionAbility, VpnExtensionContext } from "@kit.NetworkKit";
import { JSON, process, taskpool, util } from "@kit.ArkTS";
import app from "libapp.so";
import { Tun } from "../constant/Tun";
import { FileUtil } from "@pura/harmony-utils";

export default class VpnAbility extends VpnExtensionAbility {

  private vpnConnection: vpnExtension.VpnConnection = Object()

  async onCreate(): Promise<void> {

    try {
      this.vpnConnection = vpnExtension.createVpnConnection(this.context)
      const path = this.context.tempDir + '/config.json'
      interface Tun {
        fd: number
        mtu: number
      }
      interface Config {
        tun: Tun
      }
      const config = JSON.parse(await FileUtil.readText(path)) as Config
      config.tun.mtu = Tun.mtu
      config.tun.fd = await this.vpnConnection.create({
        addresses: [{ address: { address: Tun.address }, prefixLength: Tun.addressPrefixLength }],
        dnsAddresses: [Tun.dnsAddress],
        mtu: Tun.mtu
      })
      console.log(JSON.stringify(config))
      await FileUtil.unlink(path)
      await FileUtil.writeEasy(path, JSON.stringify(config), false)
      await taskpool.execute(Run, this.context)
    } catch {
      const pm = new process.ProcessManager()
      pm.exit(0)
    }
  }

  async onDestroy(): Promise<void> {
    await this.vpnConnection.destroy()
  }
}

@Concurrent
function Run(context: VpnExtensionContext) {
  const encoder = new util.TextEncoder()
  if (app.run(encoder.encodeInto(JSON.stringify({
    filesDir: context.filesDir,
    cacheDir: context.cacheDir,
    tempDir: context.tempDir
  }))) === 0) {
    return
  } else {
    throw new Error('VPN RUN FAILED')
  }
}