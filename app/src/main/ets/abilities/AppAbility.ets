import { ConfigurationConstant, UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AppUtil } from "@pura/harmony-utils";

export default class AppAbility extends UIAbility {

  onCreate(): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
    AppUtil.init(this.context)
  }

  onDestroy(): void {}

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    await windowStage.loadContent('pages/launch/LaunchPage')
  }

  onWindowStageDestroy(): void {}

  onForeground(): void {}

  onBackground(): void {}
}