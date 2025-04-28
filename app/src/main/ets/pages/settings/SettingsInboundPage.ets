import { ArrayUtil, PasteboardUtil } from "@pura/harmony-utils"
import { TitleTextModifier } from "../../components/TitleTextModifier"
import { InboundManager } from "../../managers/InboundManager"

@Builder
export function SettingsInboundPageBuilder(_name: string, _params: Object) {
  SettingsInboundPage()
}

@ComponentV2
struct SettingsInboundPage {

  private manager = new InboundManager()

  build() {
    NavDestination() {
      List({ space: 32 }) {
        ListItem()
        ListItemGroup() {
          ListItem() {
            this.buildInfoView('标识', InboundManager.inboundTag)
          }
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
        ListItemGroup() {
          ListItem() {
            this.buildInfoView('网卡地址', InboundManager.inboundAddress)
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildInfoView('DNS服务器地址', InboundManager.inboundDNSAddress)
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildInfoView('最大传输单元', InboundManager.inboundMTU + '')
          }
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
        ListItemGroup() {
          ListItem() {
            this.buildSniffingEnableView()
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildSniffingOverrideDestinationForProtocolView()
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildSniffingMetadataOnlyView()
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildSniffingRouteOnlyView()
          }
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
        ListItem()
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .title('入站设置', { mainTitleModifier: new TitleTextModifier() })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onHidden(() => this.manager.update())
  }

  @Builder
  private buildSniffingEnableView() {
    Row({ space: 12 }) {
      Text('域名嗅探')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.manager.sniffingEnabled })
        .onChange((value) => this.manager.sniffingEnabled = value)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildSniffingOverrideDestinationForProtocolView() {
    Row({ space: 12 }) {
      Text('流量类型')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Row({ space: 8 }) {
        this.buildSniffingOverrideDestinationForProtocolToggleView('HTTP', 'http')
        this.buildSniffingOverrideDestinationForProtocolToggleView('TLS', 'tls')
        this.buildSniffingOverrideDestinationForProtocolToggleView('QUIC', 'quic')
        this.buildSniffingOverrideDestinationForProtocolToggleView('FakeDNS', 'fakedns')
      }
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildSniffingOverrideDestinationForProtocolToggleView(title: string, value: string) {
    Toggle({ type: ToggleType.Button, isOn: ArrayUtil.contain(this.manager.sniffingOverrideDestinationForProtocol, value) }) {
      Text(title)
        .fontSize(10)
    }
    .onChange(() => {
      if (ArrayUtil.contain(this.manager.sniffingOverrideDestinationForProtocol, value)) {
        ArrayUtil.remove(this.manager.sniffingOverrideDestinationForProtocol, value)
      } else {
        this.manager.sniffingOverrideDestinationForProtocol = ArrayUtil.append(this.manager.sniffingOverrideDestinationForProtocol, value)
      }
    })
  }

  @Builder
  private buildSniffingMetadataOnlyView() {
    Row({ space: 12 }) {
      Text('仅使用元数据')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.manager.sniffingMetadataOnly })
        .onChange((value) => this.manager.sniffingMetadataOnly = value)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildSniffingRouteOnlyView() {
    Row({ space: 12 }) {
      Text('仅用于路由')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.manager.sniffingRouteOnly })
        .onChange((value) => this.manager.sniffingRouteOnly = value)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildInfoView(title: string, detail: string) {
    Row({ space: 12 }) {
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Text(detail)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
    .onClick(() => PasteboardUtil.setDataText(detail))
  }

  @Builder
  private buildDivider() {
    Divider()
      .padding({ left: 12 })
  }
}