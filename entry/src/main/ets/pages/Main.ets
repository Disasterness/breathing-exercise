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

  @StorageLink('customInhale') customInhale: number = 4;
  @StorageLink('customHold') customHold: number = 4;
  @StorageLink('customExhale') customExhale: number = 4;

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
      if (tech.id === 'custom') {
        this.currentTechnique.phases = [
          { name: 'Inhale', duration: this.customInhale },
          { name: 'Hold', duration: this.customHold },
          { name: 'Exhale', duration: this.customExhale }
        ];
      }
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

    // Set circle animation based on phase
    if (phase.name === 'Inhale') {
      // Inflate - More pronounced expansion
      animateTo({ duration: phase.duration * 1000 / this.speed, curve: Curve.EaseInOut }, () => {
        this.circleScale = 2.2;
      });
    } else if (phase.name === 'Exhale') {
      // Deflate - More pronounced contraction
      animateTo({ duration: phase.duration * 1000 / this.speed, curve: Curve.EaseInOut }, () => {
        this.circleScale = 0.8;
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
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // Background layer - Light Teal (satisfied "no white background" and "not dark mode")
      Rect().width('100%').height('100%').fill('#E0F7FA')

      // Decorative elements around the circle
      Circle({ width: 12, height: 6 })
        .fill('#4EB8DA')
        .position({ x: '50%', y: '15%' })
        .translate({ x: -6 })
        .clip(new Rect({ width: 12, height: 6 }))

      Circle({ width: 8, height: 4 })
        .fill('#4EB8DA')
        .position({ x: '75%', y: '80%' })
        .rotate({ angle: 45 })

      // Breathing Circle layer with Gradient
      Circle({ width: 100, height: 100 })
        .radialGradient({
          center: [50, 50],
          radius: 50,
          colors: [['#4EB8DA', 0.0], ['#B2EBF2', 1.0]]
        })
        .scale({ x: this.circleScale, y: this.circleScale })
        .hitTestBehavior(HitTestMode.None)
        .opacity(0.9)

      // Text Guidance layer
      Column({ space: 5 }) {
        if (this.isStarted) {
          Text(this.currentPhase.toLowerCase())
            .fontSize(24)
            .fontColor('#006064')
            .fontWeight(FontWeight.Bold)
          Text(this.phaseCountdown.toString())
            .fontSize(20)
            .fontColor('#006064')
            .opacity(0.8)
        } else {
          Text(this.currentTechnique.name)
            .fontSize(16)
            .fontColor('#006064')
            .fontWeight(FontWeight.Bold)
          Text('Tap Start to begin')
            .fontSize(12)
            .fontColor('#546E7A')
        }
      }
      .hitTestBehavior(HitTestMode.None)

      // Button layer
      this.StartButton()
    }
    .width('100%')
    .height('100%')
  }
}
