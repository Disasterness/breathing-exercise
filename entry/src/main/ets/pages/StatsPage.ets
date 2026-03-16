import { ArcList, ArcListItem, LengthUnit } from '@kit.ArkUI'

@Entry
@Component
struct StatsPage {
  @StorageLink('streak') streak: number = 0;
  @StorageLink('totalMinutes') totalMinutes: number = 0;

  build() {
    Column({ space: 15 }) {
      Text('Statistics').fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold)

      Row() {
        Column() {
          Text('Streak').fontColor(Color.White).fontSize(14)
          Text(`${this.streak} Days`).fontColor(Color.White).fontSize(20).fontWeight(FontWeight.Bolder)
        }
        .padding(15)
        .backgroundColor('#33ffffff')
        .borderRadius(15)
        .width('45%')

        Column() {
          Text('Total Time').fontColor(Color.White).fontSize(14)
          Text(`${this.totalMinutes} Min`).fontColor(Color.White).fontSize(20).fontWeight(FontWeight.Bolder)
        }
        .padding(15)
        .backgroundColor('#33ffffff')
        .borderRadius(15)
        .width('45%')
      }.width('100%').justifyContent(FlexAlign.SpaceAround)

      Button('Back')
        .onClick(() => {
          this.getUIContext().getRouter().back()
        })
        .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#ff358027')
  }
}
