import { uniformTypeDescriptor } from '@kit.ArkData';
import { TitleTextModifier } from "../../components/TitleTextModifier"
import { LogManager } from "../../managers/LogManager"
import { systemShare } from "@kit.ShareKit"
import { common } from "@kit.AbilityKit"
import { FileUtil, PreviewUtil, ToastUtil } from '@pura/harmony-utils';
import { filePreview } from '@kit.PreviewKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
export function SettingsLogPageBuilder(_name: string, _params: Object) {
  SettingsLogPage()
}

@ComponentV2
struct SettingsLogPage {

  private manager = new LogManager()

  build() {
    NavDestination() {
      List({ space: 32 }) {
        ListItem()
        ListItemGroup() {
          ListItem() {
            this.buildLogLevelView()
          }
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
        ListItemGroup() {
          ListItem() {
            this.buildDNSLogEnableView()
          }
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildMaskLevelView()
          }
        }
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 16, right: 16 })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius(16)
        ListItemGroup() {
          ListItem() {
            this.buildLogEntryView('访问日志')
          }
          .onClick(() => PreviewUtil.openPreviewEasy(FileUtil.getUriFromPath(LogManager.accessLogPath)))
          ListItem() {
            this.buildDivider()
          }
          ListItem() {
            this.buildLogEntryView('错误日志')
          }
          .onClick(() => PreviewUtil.openPreviewEasy(FileUtil.getUriFromPath(LogManager.errorLogPath)))
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
    .title('日志设置', { mainTitleModifier: new TitleTextModifier() })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onHidden(() => this.manager.update())
  }

  @Builder
  private buildLogLevelView() {
    Row({ space: 12 }) {
      Text('日志等级')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Select(LogManager.displayLogLevels.map((value): SelectOption => { return { value } }))
        .backgroundColor(Color.Transparent)
        .selected(this.manager.logLevelIndex)
        .value(LogManager.displayLogLevels[this.manager.logLevelIndex])
        .controlSize(ControlSize.SMALL)
        .font({ size: 14 })
        .divider(null)
        .onSelect((index: number) => this.manager.logLevelIndex = index)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildDNSLogEnableView() {
    Row({ space: 12 }) {
      Text('域名查询日志')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.manager.dnsLogEnabled })
        .onChange((value) => this.manager.dnsLogEnabled = value)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildMaskLevelView() {
    Row({ space: 12 }) {
      Text('地址遮罩')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Select(LogManager.displayMaskLevels.map((value): SelectOption => { return { value } }))
        .backgroundColor(Color.Transparent)
        .selected(this.manager.maskLevelIndex)
        .value(LogManager.displayMaskLevels[this.manager.maskLevelIndex])
        .controlSize(ControlSize.SMALL)
        .font({ size: 14 })
        .divider(null)
        .onSelect((index: number) => this.manager.maskLevelIndex = index)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  private buildLogEntryView(title: string) {
    Row({ space: 12 }) {
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
  private buildDivider() {
    Divider()
      .padding({ left: 12 })
  }
}