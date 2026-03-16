import { ArcList, ArcListItem, LengthUnit } from '@kit.ArkUI'
import { BreathingTechnique, PRESET_TECHNIQUES } from '../model/BreathingTechnique'

@Entry
@Component
struct TechniquesPage {
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = '4-7-8';

  build() {
    Column() {
      Text('Techniques').fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold).margin({ bottom: 10 })

      ArcList() {
        ForEach(PRESET_TECHNIQUES, (item: BreathingTechnique) => {
          ArcListItem() {
            Column() {
              Text(item.name)
                .fontSize(18)
                .fontColor(this.selectedTechniqueId === item.id ? Color.Green : Color.White)
                .fontWeight(FontWeight.Bold)
              Text(item.description)
                .fontSize(12)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
            }
            .width('90%')
            .padding(10)
            .backgroundColor('#33ffffff')
            .borderRadius(15)
            .onClick(() => {
              this.selectedTechniqueId = item.id;
              this.getUIContext().getRouter().back();
            })
          }
        }, (item: BreathingTechnique) => item.id)
      }
      .space({ unit: LengthUnit.VP, value: 10 })
      .height('80%')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#ff358027')
  }
}
