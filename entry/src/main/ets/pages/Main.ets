import lottie, { AnimationItem } from '@ohos/lottie';
import { ArcButton, ArcButtonOptions, ArcButtonPosition } from '@ohos.arkui.advanced.ArcButton';
import { ArcButtonStyleMode, ButtonOptions, promptAction } from '@kit.ArkUI';
import { vibrator } from '@kit.BasicServicesKit';
import { BreathingTechnique, PRESET_TECHNIQUES, Phase } from '../model/BreathingTechnique';
import { StatsService } from '../service/StatsService';
import { SessionResult } from '../model/SessionModel';

@Entry
@Component
struct Main {
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null;
  private animateName: string = 'animation'; // name
  private sessionTimeout: null | number = null
  private phaseInterval: null | number = null
  @State isStarted: boolean = false;
  @State options: ArcButtonOptions | undefined = new ArcButtonOptions({})
  @StorageLink('speed') speed: number = 1;
  @StorageLink('time') time: number = 1;
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = '4-7-8';
  @State currentPhase: string = 'Ready';
  @State phaseCountdown: number = 0;

  private currentTechnique: BreathingTechnique = PRESET_TECHNIQUES[0];
  private currentPhaseIndex: number = 0;

  aboutToAppear(): void {
    this.updateTechnique();
    this.initButton()
  }

  aboutToDisappear(): void {
    this.stop();
  }

  updateTechnique() {
    const tech = PRESET_TECHNIQUES.find(t => t.id === this.selectedTechniqueId);
    if (tech) {
      this.currentTechnique = tech;
    }
  }

  initButton() {
    this.options = new ArcButtonOptions({
      label: this.isStarted ? 'Stop' : 'Start',
      position: ArcButtonPosition.BOTTOM_EDGE,
      styleMode: ArcButtonStyleMode.NORMAL_LIGHT,
      onClick: () => {
        if (this.isStarted) {
          this.stop()
        } else {
          this.start()
        }
      }
    })
  }

  stop(completed: boolean = false) {
    this.animateItem?.stop()
    this.isStarted = false;
    this.currentPhase = 'Ready';
    this.phaseCountdown = 0;

    if (completed) {
      const result: SessionResult = {
        techniqueName: this.currentTechnique.name,
        duration: this.time,
        totalBreaths: Math.floor((this.time * 60) / this.currentTechnique.phases.reduce((a, b) => a + b.duration, 0)),
        timestamp: Date.now()
      };
      StatsService.saveSession(result);
      this.getUIContext().getRouter().replaceUrl({
        url: 'pages/SummaryPage',
        params: { result: result }
      });
    }

    if (this.sessionTimeout) {
      clearTimeout(this.sessionTimeout);
      this.sessionTimeout = null;
    }
    if (this.phaseInterval) {
      clearInterval(this.phaseInterval);
      this.phaseInterval = null;
    }
    this.initButton()
  }

  start() {
    this.updateTechnique();
    this.animateItem?.play()
    this.isStarted = true
    this.currentPhaseIndex = 0;
    this.startPhase();

    this.initButton()
    this.sessionTimeout = setTimeout(() => {
      this.stop(true);
    }, this.time * 60000)
  }

  startPhase() {
    const phase = this.currentTechnique.phases[this.currentPhaseIndex];
    this.currentPhase = phase.name;
    this.phaseCountdown = phase.duration;

    this.vibrate();

    if (this.phaseInterval) {
      clearInterval(this.phaseInterval);
    }

    this.phaseInterval = setInterval(() => {
      this.phaseCountdown--;
      if (this.phaseCountdown <= 0) {
        this.nextPhase();
      }
    }, 1000 / this.speed);
  }

  nextPhase() {
    this.currentPhaseIndex = (this.currentPhaseIndex + 1) % this.currentTechnique.phases.length;
    this.startPhase();
  }

  vibrate() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 100,
      }, {
        id: 0,
        usage: 'alarm'
      }, (error) => {
        if (error) {
          console.error('vibrate fail, error.code: ' + error.code + ' error.message: ' + error.message);
        } else {
          console.log('vibrate success');
        }
      });
    } catch (err) {
      console.error('vibrate fail, err: ' + JSON.stringify(err));
    }
  }

  @Builder
  StartButton() {
    ArcButton({
      options: this.options
    })
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
  }

  build() {
    Stack() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Row() {
          Canvas(this.canvasRenderingContext)
            .width('100%')
            .height('100%')
            .backgroundColor(Color.White)
            .onReady(() => {
              if (this.animateItem != null) {
                this.animateItem?.resize();
              } else {
                this.canvasRenderingContext.imageSmoothingEnabled = true;
                this.canvasRenderingContext.imageSmoothingQuality = 'high'
                this.loadAnimation();
              }
            })
        }.width('100%').justifyContent(FlexAlign.Center).backgroundColor('#aaa')
      }
      .width('100%')
      .height('100%')

      if (this.isStarted) {
        Column() {
          Text(this.currentPhase)
            .fontSize(24)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
          Text(this.phaseCountdown.toString())
            .fontSize(40)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bolder)
        }
        .hitTestBehavior(HitTestMode.None)
      } else {
        Column() {
          Text(this.currentTechnique.name)
            .fontSize(16)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
          Text('Tap Start to begin')
            .fontSize(12)
            .fontColor(Color.Gray)
        }
      }

      this.StartButton()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  loadAnimation() {
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: false,
      name: this.animateName,
      contentMode: 'Contain',
      path: 'animation/Breath.json'
    })

    this.animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      this.animateItem?.changeColor([225, 25, 100, 1]);
      this.animateItem?.setSpeed(this.speed);
      this.animateItem?.resize();
    });
  }
}
