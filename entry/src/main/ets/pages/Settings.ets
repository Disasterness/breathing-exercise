@Entry
@Component
struct SettingsPage {
  @StorageLink('time') time: number = 1;
  @StorageLink('speed') speed: number = 1;

  build() {
    Column({ space: 4 }) {
      Text('Settings').fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold)
      Row({ space: 8 }) {
        Button('-').fontSize(24).fontColor(Color.White)
          .onClick(() => {
            if (this.time > 1) {
              this.time--
            }
          })
        Text(`${this.time.toString()} min`).fontColor(Color.White).fontSize(18).fontWeight(FontWeight.Bold)
        Button('+').fontSize(24).fontColor(Color.White).onClick(() => {
          if (this.time < 10) {
            this.time++
          }
        })
      }.width('100%').justifyContent(FlexAlign.Center)

      Row({ space: 8 }) {
        Button('-').fontSize(24).fontColor(Color.White)
          .onClick(() => {
            if (this.speed > 0.5) {
              this.speed -= 0.5
            }
          })
        Text(`${this.speed.toFixed(2).toString()}x`).fontColor(Color.White).fontSize(18).fontWeight(FontWeight.Bold)
        Button('+').fontSize(24).fontColor(Color.White).onClick(() => {
          if (this.speed < 3) {
            this.speed += 0.5
          }
        })
      }.width('100%').justifyContent(FlexAlign.Center)

    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#ff5f9de5');
  }
}
