import { ArcList, ArcListItem, LengthUnit } from '@kit.ArkUI'

@Entry
@Component
struct SettingsPage {
  @StorageLink('time') time: number = 1;
  @StorageLink('speed') speed: number = 1;
  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;
  @StorageLink('dailyReminder') dailyReminder: boolean = false;

  @Builder
  Adjuster(label: string, value: number, onMinus: () => void, onPlus: () => void) {
    Row() {
      Text(label).fontColor(Color.White).fontSize(14).width('40%')
      Row() {
        Button('-').onClick(onMinus).backgroundColor('#33ffffff').width(30).height(30)
        Text(value.toString()).fontColor(Color.White).margin({ left: 10, right: 10 }).fontSize(16)
        Button('+').onClick(onPlus).backgroundColor('#33ffffff').width(30).height(30)
      }
    }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(5)
  }

  build() {
    Column() {
      Text('Settings').fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold).margin({ bottom: 10 })

      ArcList() {
        ArcListItem() {
          Column() {
            Text('Session Duration (min)').fontColor(Color.White).fontSize(12)
            Row() {
              Button('-').onClick(() => { if (this.time > 1) this.time-- }).backgroundColor('#33ffffff')
              Text(this.time.toString()).fontColor(Color.White).margin(10).fontSize(20)
              Button('+').onClick(() => { if (this.time < 30) this.time++ }).backgroundColor('#33ffffff')
            }
          }.padding(10).backgroundColor('#1Affffff').borderRadius(15).width('90%')
        }

        ArcListItem() {
          Column({ space: 5 }) {
            Text('Custom Rhythm (sec)').fontColor(Color.White).fontSize(14).fontWeight(FontWeight.Bold)
            this.Adjuster('Inhale', this.customInhale, () => { if (this.customInhale > 1) this.customInhale-- }, () => { this.customInhale++ })
            this.Adjuster('Hold', this.customHold, () => { if (this.customHold > 0) this.customHold-- }, () => { this.customHold++ })
            this.Adjuster('Exhale', this.customExhale, () => { if (this.customExhale > 1) this.customExhale-- }, () => { this.customExhale++ })
          }.padding(10).backgroundColor('#1Affffff').borderRadius(15).width('90%')
        }

        ArcListItem() {
          Row() {
            Text('Daily Reminder').fontColor(Color.White)
            Toggle({ type: ToggleType.Switch, isOn: this.dailyReminder })
              .onChange((isOn) => { this.dailyReminder = isOn })
          }.width('90%').justifyContent(FlexAlign.SpaceBetween).padding(10).backgroundColor('#1Affffff').borderRadius(15)
        }
      }
      .height('80%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#1A1D21');
  }
}
