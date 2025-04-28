import { AppUtil } from '@pura/harmony-utils'
import { LaunchPageViewModel } from './LaunchPageViewModel'
import { router } from '@kit.ArkUI'

@Entry
@ComponentV2
struct LaunchPage {

  private vm = new LaunchPageViewModel()

  aboutToAppear(): void {
    this.vm.prepare().then(() => {
      router.replaceUrl({ url: 'pages/main/MainPage' })
    }).catch(() => {
      AppUtil.getContext().terminateSelf()
    })
  }

  build() {
    Column() {
      Column({ space: 8 }) {
        LoadingProgress()
          .size({ width: 54, height: 54 })
          .color($r('sys.color.ohos_id_color_text_primary'))
        Text('初始化...')
          .fontSize(12)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)
      Text('—— Powered By Xray-core ——')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
        .padding(16)
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}