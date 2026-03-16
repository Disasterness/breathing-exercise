import { ArcButton, ArcButtonOptions, ArcButtonPosition } from '@ohos.arkui.advanced.ArcButton';
import { ArcButtonStyleMode, ButtonOptions, promptAction } from '@kit.ArkUI';
import vibrator from '@ohos.vibrator';
import { BreathingTechnique, PRESET_TECHNIQUES, Phase } from '../model/BreathingTechnique';
import { StatsService } from '../service/StatsService';
import { SessionResult } from '../model/SessionModel';

@Entry
@Component
struct Main {
  private sessionTimeout: null | number = null
  private phaseInterval: null | number = null
  @State isStarted: boolean = false;
  @StorageLink('speed') speed: number = 1;
  @StorageLink('time') time: number = 1;
  @StorageLink('selectedTechniqueId') selectedTechniqueId: string = '4-7-8';
  @State currentPhase: string = 'Ready';
  @State phaseCountdown: number = 0;
  @State circleScale: number = 1.0;

  private currentTechnique: BreathingTechnique = PRESET_TECHNIQUES[0];
  private currentPhaseIndex: number = 0;

  aboutToAppear(): void {
    this.updateTechnique();
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

  stop(completed: boolean = false) {
    this.isStarted = false;
    this.currentPhase = 'Ready';
    this.phaseCountdown = 0;
    this.circleScale = 1.0;

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
  }

  start() {
    this.updateTechnique();
    this.isStarted = true
    this.currentPhaseIndex = 0;
    this.startPhase();

    this.sessionTimeout = setTimeout(() => {
      this.stop(true);
    }, this.time * 60000)
  }

  startPhase() {
    const phase = this.currentTechnique.phases[this.currentPhaseIndex];
    this.currentPhase = phase.name;
    this.phaseCountdown = phase.duration;

    // Set circle animation
    if (phase.name === 'Inhale') {
      animateTo({ duration: phase.duration * 1000 / this.speed, curve: Curve.EaseInOut }, () => {
        this.circleScale = 2.0;
      });
    } else if (phase.name === 'Exhale') {
      animateTo({ duration: phase.duration * 1000 / this.speed, curve: Curve.EaseInOut }, () => {
        this.circleScale = 1.0;
      });
    }

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
        }
      });
    } catch (err) {
      console.error('vibrate fail, err: ' + JSON.stringify(err));
    }
  }

  @Builder
  StartButton() {
    ArcButton({
      options: new ArcButtonOptions({
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
    })
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
  }

  build() {
    RelativeContainer() {
      // Breathing Circle
      Column() {
        Circle({ width: 100, height: 100 })
          .fill('#3371cb5b')
          .scale({ x: this.circleScale, y: this.circleScale })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

      // Text Overlay
      Column() {
        if (this.isStarted) {
          Text(this.currentPhase)
            .fontSize(24)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Text(this.phaseCountdown.toString())
            .fontSize(40)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bolder)
        } else {
          Text(this.currentTechnique.name)
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Text('Tap Start to begin')
            .fontSize(12)
            .fontColor('#ccc')
        }
      }
      .hitTestBehavior(HitTestMode.None)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

      this.StartButton()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff358027')
  }
}
