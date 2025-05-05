import { SettingsAssetPageBuilder } from '../settings/SettingsAssetPage'
import { SettingsIcon } from '../../components/SettingsIcon'
import { VpnConnectButton } from '../../components/VpnConnectButton'
import { TitleTextModifier } from '../../components/TitleTextModifier'
import { VpnManager } from '../../managers/VpnManager'
import { SettingsLogPageBuilder } from '../settings/SettingsLogPage'

@Entry
@ComponentV2
struct MainPage {

  @Provider() private stack: NavPathStack = new NavPathStack()

  private manager = new VpnManager()

  build() {
    Navigation(this.stack) {
      List({ space: 32 }) {
        ListItem()
        ListItemGroup() {
          ListItem() {
            this.buildEntryView($r('sys.symbol.folder'), $r('app.color.blue_400'), '规则文件管理')
          }
          .onClick(() => this.stack.pushDestinationByName('SettingsAssetPage', {}))
          ListItem() {
            Divider()
              .padding({ left: 52 })
          }
          ListItem() {
            this.buildEntryView($r('sys.symbol.doc_plaintext'), $r('app.color.blue_grey_400'), '日志设置')
          }
          .onClick(() => this.stack.pushDestinationByName('SettingsLogPage', {}))
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .title('Xray for HarmonyOS', { mainTitleModifier: new TitleTextModifier() })
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .menus(this.buildVpnConnectButton())
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .navDestination(this.buildNavDestination)
  }

  @Builder
  private buildVpnConnectButton() {
    Column() {
      VpnConnectButton({ manager: this.manager })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16 })
  }

  @Builder
  private buildEntryView(icon: Resource, backgroundColor: ResourceColor, title: ResourceStr) {
    Row({ space: 12 }) {
      SettingsIcon({ icon: icon, color: backgroundColor })
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(20)
        .fontColor([$r('sys.color.ohos_id_color_text_secondary')])
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildNavDestination(name: string, param: Object) {
    if (name === 'SettingsAssetPage') {
      SettingsAssetPageBuilder(name, param)
    } else if (name === 'SettingsLogPage') {
      SettingsLogPageBuilder(name, param)
    }
  }
}