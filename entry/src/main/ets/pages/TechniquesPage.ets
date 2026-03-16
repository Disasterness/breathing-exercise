import { ArcList, ArcListItem, LengthUnit } from '@kit.ArkUI'
import { BreathingTechnique, PRESET_TECHNIQUES } from '../model/BreathingTechnique'

@Entry
@Component
struct TechniquesPage {
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = '4-7-8';
  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;

  getPhasesText(item: BreathingTechnique): string {
    if (item.id === 'custom') {
      return `${this.customInhale}s - ${this.customHold}s - ${this.customExhale}s`;
    }
    return item.phases.map(p => `${p.duration}s`).join(' - ');
  }

  build() {
    Column() {
      Text('Techniques').fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold).margin({ bottom: 10 })

      ArcList() {
        ForEach(PRESET_TECHNIQUES, (item: BreathingTechnique) => {
          ArcListItem() {
            Column({ space: 2 }) {
              Text(item.name)
                .fontSize(16)
                .fontColor(this.selectedTechniqueId === item.id ? '#4EB8DA' : Color.White)
                .fontWeight(FontWeight.Bold)
              Text(this.getPhasesText(item))
                .fontSize(12)
                .fontColor('#ccc')
              Text(item.description)
                .fontSize(10)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .opacity(0.8)
            }
            .width('90%')
            .padding(8)
            .backgroundColor('#1Affffff')
            .borderRadius(15)
            .onClick(() => {
              this.selectedTechniqueId = item.id;
              this.getUIContext().getRouter().back();
            })
          }
        }, (item: BreathingTechnique) => item.id)
      }
      .space({ unit: LengthUnit.VP, value: 8 })
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#1A1D21')
  }
}
