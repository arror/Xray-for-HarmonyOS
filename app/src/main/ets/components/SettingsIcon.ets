@ComponentV2
export struct SettingsIcon {

  @Require @Param icon: Resource
  @Require @Param color: ResourceColor

  build() {
    Stack() {
      Image($r('sys.media.ohos_icon_mask_svg'))
        .fillColor(this.color)
        .size({ width: 28, height: 28 })
      SymbolGlyph(this.icon)
        .fontSize(18)
        .fontColor([Color.White])
    }
  }
}