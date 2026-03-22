import { TextModifier } from '../modifier/TextModifier'

@Entry
@Component
struct Index {
  @State textModifier: TextModifier = new TextModifier();

  @Builder
  MenuButton(title: string, onClick?: () => void) {
    Row() {
      Text(title)
        .attributeModifier(this.textModifier)
        .fontColor('#006064')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
    }
    .width(140)
    .height(30)
    .justifyContent(FlexAlign.Center)
    .borderRadius(15)
    .backgroundColor('#A9DDE8')
    .onClick(() => {
      if (onClick) {
        onClick()
      }
    })
  }

  build() {
    Column() {
      Column({ space: 8 }) {

        Text('Breathing Exercises')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#006064')
          .textAlign(TextAlign.Center)

        this.MenuButton('Start', () => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/Main'
          })
        })

        this.MenuButton('Techniques', () => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/TechniquesPage'
          })
        })

        this.MenuButton('Statistics', () => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/StatsPage'
          })
        })

        this.MenuButton('Settings', () => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/Settings'
          })
        })

      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 6, bottom: 6 })
    .backgroundColor('#E0F7FA')
  }
}