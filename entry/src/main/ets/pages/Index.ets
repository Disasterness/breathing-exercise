import { LengthUnit } from '@kit.ArkUI'
import { TextModifier } from '../modifier/TextModifier'

@Entry
@Component
struct Index {
  @State textModifier: TextModifier = new TextModifier();

  @Builder
  CustomListItem(title: string, onClick?: () => void) {
    ListItem() {
      Row() {
        Text(title)
          .attributeModifier(this.textModifier)
          .fontColor('#006064')
      }
      .width('80%')
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      .backgroundColor('#334EB8DA')
      .height(30)
      .padding({ right: 8, left: 8 })
      .onClick(() => {
        if (onClick) {
          onClick()
        }
      })
    }
  }

  build() {
    RelativeContainer() {

      List({ initialIndex: 1, space: 8 }) {
        ListItem() {
          Text('Breathing Exercises')
            .fontSize(16)
            .fontColor('#006064')
            .fontWeight(FontWeight.Bold)
        }
        this.CustomListItem('Start', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/Main'
        }))
        this.CustomListItem('Techniques', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/TechniquesPage'
        }))
        this.CustomListItem('Statistics', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/StatsPage'
        }))
        this.CustomListItem('Settings', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/Settings'
        })
        )
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#E0F7FA')
  }
}
