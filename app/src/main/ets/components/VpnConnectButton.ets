import { VpnManager, VpnStatus } from '../managers/VpnManager'
import { picker } from '@kit.CoreFileKit'
import { JSON, util } from '@kit.ArkTS'
import { FileUtil } from '@pura/harmony-utils'
import { fs } from '../utils/fs'

@ComponentV2
export struct VpnConnectButton {

  @Require @Param manager: VpnManager

  build() {
    Button(this.connectButtonText())
      .fontColor($r('app.color.white'))
      .fontWeight(FontWeight.Bold)
      .fontSize(12)
      .width(80).height(32)
      .backgroundColor(this.connectButtonBackgroundColor())
      .onClick(() => this.onConnectButtonClick())
  }

  private connectButtonText(): string {
    switch (this.manager.status) {
      case VpnStatus.Disconnected:
        return '连接'
      case VpnStatus.Connecting:
        return '连接中'
      case VpnStatus.Connected:
        return '断开'
      case VpnStatus.Disconnecting:
        return '断开中'
    }
  }

  private connectButtonBackgroundColor(): ResourceColor {
    switch (this.manager.status) {
      case VpnStatus.Disconnected:
        return $r('app.color.blue_800')
      case VpnStatus.Connecting:
        return $r('app.color.blue_800')
      case VpnStatus.Connected:
        return $r('app.color.green_800')
      case VpnStatus.Disconnecting:
        return $r('app.color.green_800')
    }
  }

  private onConnectButtonClick() {
    switch (this.manager.status) {
      case VpnStatus.Disconnected:
        this.chooseConfig()
      case VpnStatus.Connecting:
        return
      case VpnStatus.Connected:
        this.manager.stopVpn()
      case VpnStatus.Disconnecting:
        return
    }
  }

  private chooseConfig() {
    const options = new picker.DocumentSelectOptions()
    options.fileSuffixFilters = ['.json']
    options.maxSelectNumber = 1
    const documentPicker = new picker.DocumentViewPicker()
    documentPicker.select(options).then((file) => {
      if (file.length === 1) {
        const id = util.generateRandomUUID()
        const srcPath = file[0]
        const dstPath = FileUtil.getTempDirPath(undefined, `${id}.json`)
        fs.copy(srcPath, dstPath).then(() => {
          this.manager.processConfig(dstPath).then(() => {
            this.manager.startVpn(id)
          })
        })
      }
    })
  }
}