import { SessionResult } from '../model/SessionModel'

@Entry
@Component
struct SummaryPage {
  @State result: SessionResult = {
    techniqueName: '4-7-8 Breathing',
    duration: 1,
    totalBreaths: 15,
    timestamp: Date.now()
  };

  aboutToAppear() {
    const params = this.getUIContext().getRouter().getParams() as Record<string, Object>;
    if (params && params.result) {
      this.result = params.result as SessionResult;
    }
  }

  build() {
    Column({ space: 20 }) {
      Text('Session Summary')
        .fontSize(22)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      Column({ space: 10 }) {
        Text(`Technique: ${this.result.techniqueName}`)
          .fontColor(Color.White)
        Text(`Duration: ${this.result.duration} min`)
          .fontColor(Color.White)
        Text(`Total Cycles: ${this.result.totalBreaths}`)
          .fontColor(Color.White)
      }
      .padding(20)
      .backgroundColor('#33ffffff')
      .borderRadius(20)

      Button('Done')
        .onClick(() => {
          this.getUIContext().getRouter().clear();
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/Index' });
        })
        .backgroundColor(Color.Green)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#ff358027')
    .justifyContent(FlexAlign.Center)
  }
}
