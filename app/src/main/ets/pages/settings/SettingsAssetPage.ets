import { SymbolGlyphModifier } from "@kit.ArkUI";
import { PickerUtil } from "@pura/picker_utils";
import { picker } from "@kit.CoreFileKit";
import { DateUtil, FileUtil } from "@pura/harmony-utils";
import { TitleTextModifier } from "../../components/TitleTextModifier";
import { fs } from "../../utils/fs";

interface Asset {
  name: string
  size: number
  atime: number
  mtime: number
  ctime: number
}

@Builder
export function SettingsAssetPageBuilder(_name: string, _param: Object) {
  SettingsAssetPage()
}

@Entry
@ComponentV2
struct SettingsAssetPage {

  @Local private assets: Array<Asset> = []

  aboutToAppear(): void {
    this.onReload()
  }

  build() {
    NavDestination() {
      if (this.assets.length > 0) {
        List({ space: 32 }) {
          ListItem()
          ListItemGroup() {
            ForEach(this.assets, (asset: Asset, index: number) => {
              ListItem() {
                this.buildAssetItemView(asset)
              }
              if (index < (this.assets.length - 1)) {
                ListItem() {
                  Divider()
                    .padding({ left: 42 })
                }
              }
            })
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
    }
    .title('规则文件管理', { mainTitleModifier: new TitleTextModifier() })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .menus([
      {
        value: '添加',
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
        action: () => {
          this.onAddOrUpdate()
        }
      }
    ])
  }

  @Builder
  private buildAssetItemView(file: Asset) {
    Row({ space: 12 }) {
      Image($r('sys.media.ohos_ic_public_remove_filled'))
        .size({ width: 18, height: 18 })
        .fillColor($r('sys.color.ohos_id_color_warning'))
        .onClick(() => this.onDelete(file))
      Column({ space: 8 }) {
        Text(file.name)
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
        Text(`更新时间: ${DateUtil.getFormatDateStr(file.mtime)}`)
          .fontSize(11)
          .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Text(FileUtil.getFormatFileSize(file.size))
        .fontSize(11)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
  }

  private async onAddOrUpdate(): Promise<void> {
    const options = new picker.DocumentSelectOptions()
    options.fileSuffixFilters = ['.dat']
    const fps = await PickerUtil.selectDocument(options)
    if (fps.length === 0) {
      return
    }
    await Promise.all(fps.map((srcPath) => {
      const dstPath = FileUtil.getFilesDirPath('asset', FileUtil.getFileName(srcPath))
      return fs.copy(srcPath, dstPath)
    }))
    await this.onReload()
  }

  private async onDelete(asset: Asset): Promise<void> {
    await FileUtil.unlink(FileUtil.getFilesDirPath('asset', asset.name))
    await this.onReload()
  }

  private async onReload(): Promise<void> {
    const names = await FileUtil.listFile(FileUtil.getFilesDirPath('asset'))
    this.assets = await Promise.all(names.map(async (name): Promise<Asset> => {
      const stat = await fs.stat(FileUtil.getFilesDirPath('asset', name))
      return {
        name: name,
        size: stat.size,
        atime: stat.atime,
        mtime: stat.mtime,
        ctime: stat.ctime
      }
    }))
  }
}

