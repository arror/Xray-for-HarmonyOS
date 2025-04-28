export class TitleTextModifier implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontSize(20)
    instance.fontWeight(FontWeight.Bold)
  }
}