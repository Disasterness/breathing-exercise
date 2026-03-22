import { LengthUnit } from '@kit.ArkUI'

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
      Text(label).fontColor('#006064').fontSize(14).width('40%')
      Row() {
        Button('-').onClick(onMinus).backgroundColor('#334EB8DA').width(30).height(30).fontColor('#006064')
        Text(value.toString()).fontColor('#006064').margin({ left: 10, right: 10 }).fontSize(16)
        Button('+').onClick(onPlus).backgroundColor('#334EB8DA').width(30).height(30).fontColor('#006064')
      }
    }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(5)
  }

  build() {
    Column() {
      Text('Settings').fontSize(22).fontColor('#006064').fontWeight(FontWeight.Bold).margin({ bottom: 10 })

      List() {
        ListItem() {
          Column() {
            Text('Session Duration (min)').fontColor('#006064').fontSize(12)
            Row() {
              Button('-').onClick(() => { if (this.time > 1) this.time-- }).backgroundColor('#334EB8DA').fontColor('#006064')
              Text(this.time.toString()).fontColor('#006064').margin(10).fontSize(20)
              Button('+').onClick(() => { if (this.time < 30) this.time++ }).backgroundColor('#334EB8DA').fontColor('#006064')
            }
          }.padding(10).backgroundColor('#1A4EB8DA').borderRadius(15).width('90%')
        }

        ListItem() {
          Column({ space: 5 }) {
            Text('Custom Rhythm (sec)').fontColor('#006064').fontSize(14).fontWeight(FontWeight.Bold)
            this.Adjuster('Inhale', this.customInhale, () => { if (this.customInhale > 1) this.customInhale-- }, () => { this.customInhale++ })
            this.Adjuster('Hold', this.customHold, () => { if (this.customHold > 0) this.customHold-- }, () => { this.customHold++ })
            this.Adjuster('Exhale', this.customExhale, () => { if (this.customExhale > 1) this.customExhale-- }, () => { this.customExhale++ })
          }.padding(10).backgroundColor('#1A4EB8DA').borderRadius(15).width('90%')
        }

        ListItem() {
          Row() {
            Text('Daily Reminder').fontColor('#006064')
            Toggle({ type: ToggleType.Switch, isOn: this.dailyReminder })
              .onChange((isOn) => { this.dailyReminder = isOn })
          }.width('90%').justifyContent(FlexAlign.SpaceBetween).padding(10).backgroundColor('#1A4EB8DA').borderRadius(15)
        }
      }
      .height('80%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#E0F7FA')
  }
}
