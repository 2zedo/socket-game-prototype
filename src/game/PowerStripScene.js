import Phaser from 'phaser'

const BASE_MAX_POWER_WATTS = 3000
const BASE_OUTLET_COUNT = 4
const SLOT_GAP = 18
const DEVICE_BODY_HEIGHT = 76
const SNAP_BODY_OFFSET_Y = 108
const LARGE_ADAPTER_PLUG_OFFSET = 68
const SHOW_HITBOX_DEBUG = false
const NEED_TICK_MS = 1000
const NEED_ROW_GAP = 50
const CYCLE_SECONDS = 60
const PHASE_SECONDS = 30

const THEME = {
  day: {
    background: '#f7f1df',
    strip: 0xded4bd,
    needTrack: 0xd8d2c5,
    needBorder: 0x6f6659,
    overlayAlpha: 0,
    text: '#24211c',
    mutedText: '#6f6659',
    explanationText: '#4c463d',
  },
  night: {
    background: '#1e2531',
    strip: 0x5d6370,
    needTrack: 0x343b48,
    needBorder: 0x9da6b5,
    overlayAlpha: 0.18,
    text: '#f1eadb',
    mutedText: '#c6bda8',
    explanationText: '#d0c7b5',
  },
}

const TIME_EFFECT_TEXT = {
  day: [
    '낮 효과',
    '- 온도가 조금 더 빠르게 증가',
    '- 재미 감소 속도 감소',
  ].join('\n'),
  night: [
    '밤 효과',
    '- 선풍기 + 낮은 온도 시 피로 회복 증가',
    '- 휴대폰 배터리 감소 속도 증가',
  ].join('\n'),
}

const EMPTY_DAY_STATS = {
  breakerTrips: 0,
  batteryCritical: 0,
  fatigueCritical: 0,
  temperatureCritical: 0,
  funCritical: 0,
}

const UPGRADE_DEFINITIONS = [
  {
    key: 'outletSlot',
    label: '콘센트 슬롯 추가',
    description: '+1 콘센트 슬롯',
    baseCost: 140,
  },
  {
    key: 'maxPower',
    label: '최대 전력 증가',
    description: '최대 전력 +500W',
    baseCost: 120,
  },
  {
    key: 'fanEfficiency',
    label: '선풍기 효율 증가',
    description: '온도 감소량 증가',
    baseCost: 100,
  },
  {
    key: 'chargerEfficiency',
    label: '충전 효율 증가',
    description: '배터리 회복량 증가',
    baseCost: 90,
  },
  {
    key: 'fatigueRecovery',
    label: '피로 회복 향상',
    description: '밤 피로 회복 증가',
    baseCost: 100,
  },
]

const NEEDS = [
  {
    key: 'phoneBattery',
    label: '배터리',
    color: 0x4f8edb,
    startsAt: 72,
  },
  {
    key: 'temperature',
    label: '온도',
    color: 0xd98742,
    startsAt: 44,
  },
  {
    key: 'fatigue',
    label: '피로',
    color: 0x8f6bb3,
    startsAt: 18,
  },
  {
    key: 'fun',
    label: '재미',
    color: 0xe0b33f,
    startsAt: 58,
  },
]

const NEED_EXPLANATION_TEXT = [
  '[배터리] 시간 감소 / 충전기 회복',
  '[온도] 시간 증가 / 선풍기 감소',
  '[피로] 더우면 증가 / 낮은 온도에서 회복',
  '[재미] 시간 감소 / 노트북 회복',
  '       낮으면 피로가 더 빨리 증가',
  '[전자레인지] 피로 완화 / 전력+열 크게 증가',
].join('\n')

const DEVICES = [
  {
    key: 'phone',
    label: '충전기',
    watts: 20,
    slots: 1,
    color: 0x4f8edb,
    plugOffsetX: 0,
    plugAnchorOffset: 0,
  },
  {
    key: 'laptop',
    label: '노트북',
    watts: 1300,
    slots: 2,
    color: 0x486064,
    plugOffsetX: -LARGE_ADAPTER_PLUG_OFFSET,
    plugAnchorOffset: 0,
  },
  {
    key: 'fan',
    label: '선풍기',
    watts: 900,
    slots: 1,
    color: 0x52a66f,
    plugOffsetX: 0,
    plugAnchorOffset: 0,
  },
  {
    key: 'microwave',
    label: '전자레인지',
    watts: 2100,
    slots: 2,
    color: 0xd98742,
    plugOffsetX: LARGE_ADAPTER_PLUG_OFFSET,
    plugAnchorOffset: 1,
  },
]

class NeedsModel {
  constructor() {
    this.values = NEEDS.reduce((values, need) => {
      values[need.key] = need.startsAt
      return values
    }, {})
    this.stability = 100
    this.warningCooldowns = {
      phoneBattery: 0,
      fatigue: 0,
      temperature: 0,
      fun: 0,
    }
  }

  update(connectedDevices, timeState, progression) {
    const hasPhoneCharger = connectedDevices.has('phone')
    const hasFan = connectedDevices.has('fan')
    const hasLaptop = connectedDevices.has('laptop')
    const hasMicrowave = connectedDevices.has('microwave')
    const isDay = timeState.phase === 'day'
    const isNight = timeState.phase === 'night'
    const difficulty = 1 + Math.min(0.55, (timeState.dayCount - 1) * 0.055)
    const temperatureBaseGain = (isDay ? 1.2 : 0.9) * difficulty
    const funLoss = (isDay ? -1 : -1.3) * difficulty
    const phoneBatteryLoss = (isNight ? -1.4 : -1.1) * difficulty
    const fanCooling = 3 + progression.upgrades.fanEfficiency * 0.55
    const chargeGain = 7 + progression.upgrades.chargerEfficiency * 1.1
    const nextTemperature = this.values.temperature + (hasFan ? -fanCooling : temperatureBaseGain) + (hasMicrowave ? 4 * difficulty : 0)
    const nextFun = this.values.fun + (hasLaptop ? 4 : funLoss)
    const fatigueDelta = this.getFatigueDelta(nextTemperature, hasFan, nextFun, hasMicrowave, isNight, progression)

    this.values.phoneBattery += hasPhoneCharger ? chargeGain : phoneBatteryLoss
    this.values.temperature = nextTemperature
    this.values.fatigue += fatigueDelta
    this.values.fun = nextFun

    if (hasMicrowave) {
      this.restoreStability(0.8)
    }

    this.clampNeeds()
    return this.collectWarnings()
  }

  getFatigueDelta(temperature, hasFan, fun, hasMicrowave, isNight, progression) {
    const difficulty = 1 + Math.min(0.5, (progression.dayCount - 1) * 0.05)
    let fatigueDelta = 0.6

    if (hasFan && temperature < 40) {
      fatigueDelta = isNight
        ? -0.7 - progression.upgrades.fatigueRecovery * 0.18
        : -0.35
    } else {
      fatigueDelta *= difficulty
    }

    if (temperature >= 80) {
      fatigueDelta += 2.4
    } else if (temperature >= 65) {
      fatigueDelta += 1.4
    }

    if (fun <= 20) {
      fatigueDelta += 1.5
    } else if (fun <= 35) {
      fatigueDelta += 0.8
    }

    if (hasMicrowave) {
      fatigueDelta -= 0.7
    }

    return fatigueDelta
  }

  clampNeeds() {
    NEEDS.forEach((need) => {
      this.values[need.key] = Phaser.Math.Clamp(this.values[need.key], 0, 100)
    })
  }

  collectWarnings() {
    const warnings = []

    this.tickWarningCooldowns()

    if (this.values.phoneBattery <= 0 && this.warningCooldowns.phoneBattery <= 0) {
      this.reduceStability(4)
      this.warningCooldowns.phoneBattery = 8
      warnings.push({
        critical: true,
        message: '배터리 0%. 안정도가 감소합니다.',
        popup: '휴대폰 배터리 부족',
        type: 'batteryCritical',
      })
    }

    if (this.values.fatigue >= 90 && this.warningCooldowns.fatigue <= 0) {
      this.reduceStability(2)
      this.warningCooldowns.fatigue = 6
      warnings.push({
        critical: true,
        message: '피로가 위험합니다. 회복이 필요합니다.',
        popup: '피로 위험!\n회복이 필요합니다',
        type: 'fatigueCritical',
      })
    } else if (this.values.fatigue >= 75 && this.warningCooldowns.fatigue <= 0) {
      this.warningCooldowns.fatigue = 5
      warnings.push({ message: '피로가 높아지고 있습니다.' })
    }

    if (this.values.temperature >= 85 && this.warningCooldowns.temperature <= 0) {
      this.warningCooldowns.temperature = 5
      warnings.push({
        critical: true,
        message: '온도가 너무 높습니다.',
        popup: '너무 더움!',
        type: 'temperatureCritical',
      })
    }

    if (this.values.fun <= 15 && this.warningCooldowns.fun <= 0) {
      this.warningCooldowns.fun = 6
      warnings.push({
        critical: true,
        message: '재미가 너무 낮아 피로가 빨리 증가합니다.',
        popup: '너무 지루함...',
        type: 'funCritical',
      })
    } else if (this.values.fun <= 30 && this.warningCooldowns.fun <= 0) {
      this.warningCooldowns.fun = 5
      warnings.push({ message: '재미가 낮습니다. 노트북이 도움이 됩니다.' })
    }

    return warnings
  }

  tickWarningCooldowns() {
    Object.keys(this.warningCooldowns).forEach((key) => {
      this.warningCooldowns[key] = Math.max(0, this.warningCooldowns[key] - 1)
    })
  }

  reduceStability(amount) {
    this.stability = Phaser.Math.Clamp(this.stability - amount, 0, 100)
  }

  restoreStability(amount) {
    this.stability = Phaser.Math.Clamp(this.stability + amount, 0, 100)
  }
}

class NeedsPanel {
  constructor(scene) {
    this.scene = scene
    this.rows = new Map()
    this.container = scene.add.container(24, 120).setDepth(30)

    NEEDS.forEach((need, index) => {
      this.rows.set(need.key, this.createRow(need, index))
    })

    this.createExplanation()
  }

  createRow(need, index) {
    const y = index * NEED_ROW_GAP
    const label = this.scene.add.text(0, y, '', {
      color: '#24211c',
      fontFamily: 'system-ui, Segoe UI, sans-serif',
      fontSize: '14px',
      fontStyle: '700',
    })
    const background = this.scene.add.rectangle(0, y + 28, 150, 12, 0xd8d2c5, 1).setOrigin(0, 0.5)
    const fill = this.scene.add.rectangle(0, y + 28, 150, 12, need.color, 1).setOrigin(0, 0.5)
    const border = this.scene.add.rectangle(0, y + 28, 150, 12, 0x000000, 0).setOrigin(0, 0.5)
    border.setStrokeStyle(1, 0x6f6659, 0.8)

    this.container.add([label, background, fill, border])

    return { label, background, fill, border }
  }

  createExplanation() {
    this.explanationText = this.scene.add.text(0, NEEDS.length * NEED_ROW_GAP + 10, NEED_EXPLANATION_TEXT, {
      color: '#4c463d',
      fontFamily: 'system-ui, Segoe UI, sans-serif',
      fontSize: '11px',
      lineSpacing: 1,
    })

    this.container.add(this.explanationText)
  }

  setPosition(x, y) {
    this.container.setPosition(x, y)
  }

  update(values) {
    NEEDS.forEach((need) => {
      const row = this.rows.get(need.key)
      const value = Math.round(values[need.key])
      row.label.setText(`${need.label}: ${value}%`)
      row.fill.setScale(value / 100, 1)
    })
  }

  setTheme(theme) {
    this.rows.forEach((row) => {
      row.label.setColor(theme.text)
      row.background.setFillStyle(theme.needTrack, 1)
      row.border.setStrokeStyle(1, theme.needBorder, 0.9)
    })
    this.explanationText.setColor(theme.explanationText)
  }
}

class DayNightModel {
  constructor() {
    this.dayCount = 1
    this.elapsedSeconds = 0
    this.phase = 'day'
    this.remainingSeconds = PHASE_SECONDS
  }

  tick() {
    this.elapsedSeconds += 1
    let completedDay = null

    if (this.elapsedSeconds >= CYCLE_SECONDS) {
      completedDay = this.dayCount
      this.elapsedSeconds = 0
      this.dayCount += 1
    }

    this.phase = this.elapsedSeconds < PHASE_SECONDS ? 'day' : 'night'
    const phaseElapsed = this.elapsedSeconds % PHASE_SECONDS
    this.remainingSeconds = PHASE_SECONDS - phaseElapsed

    return completedDay
  }

  getPhaseLabel() {
    return this.phase === 'day' ? '낮' : '밤'
  }
}

export class PowerStripScene extends Phaser.Scene {
  constructor() {
    super('PowerStripScene')

    this.devices = []
    this.outlets = []
    this.outletCount = BASE_OUTLET_COUNT
    this.maxPowerWatts = BASE_MAX_POWER_WATTS
    this.occupiedSlots = Array(this.outletCount).fill(null)
    this.isTripping = false
    this.needsModel = new NeedsModel()
    this.dayNightModel = new DayNightModel()
    this.totalPoints = 0
    this.lastPurchasedUpgrade = '없음'
    this.upgrades = {
      outletSlot: 0,
      maxPower: 0,
      fanEfficiency: 0,
      chargerEfficiency: 0,
      fatigueRecovery: 0,
    }
    this.dayStats = { ...EMPTY_DAY_STATS }
    this.isShowingResults = false
    this.isChoosingUpgrade = false
    this.warningClearEvent = null
    this.popupTween = null
    this.popupClearEvent = null
  }

  create() {
    this.cameras.main.setBackgroundColor('#f6f4ef')
    this.input.topOnly = true

    this.flashOverlay = this.add
      .rectangle(0, 0, 10, 10, 0xe94747, 0)
      .setOrigin(0)
      .setDepth(50)

    this.totalText = this.add
      .text(0, 0, '', {
        color: '#24211c',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '28px',
        fontStyle: '700',
      })
      .setOrigin(0.5)

    this.timeText = this.add
      .text(0, 0, '', {
        align: 'right',
        color: THEME.day.text,
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '15px',
        fontStyle: '700',
      })
      .setOrigin(1, 0)

    this.pointsText = this.add
      .text(0, 0, '', {
        align: 'right',
        color: THEME.day.text,
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '15px',
        fontStyle: '700',
      })
      .setOrigin(1, 0)

    this.timeEffectText = this.add
      .text(0, 0, '', {
        align: 'right',
        color: THEME.day.mutedText,
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '12px',
        lineSpacing: 2,
      })
      .setOrigin(1, 0)

    this.statusText = this.add
      .text(0, 0, '기기를 멀티탭에 끌어다 놓으세요', {
        color: '#6f6659',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '16px',
      })
      .setOrigin(0.5)

    this.lightingOverlay = this.add
      .rectangle(0, 0, 10, 10, 0x172338, 0)
      .setOrigin(0)
      .setDepth(25)

    this.warningText = this.add
      .text(0, 0, '', {
        align: 'center',
        color: '#9d3027',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '15px',
        fontStyle: '700',
      })
      .setOrigin(0.5)

    this.popupText = this.add
      .text(0, 0, '', {
        align: 'center',
        backgroundColor: 'rgba(24, 20, 16, 0.78)',
        color: '#fff4df',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '32px',
        fontStyle: '700',
        padding: { x: 28, y: 18 },
      })
      .setOrigin(0.5)
      .setDepth(70)
      .setAlpha(0)

    this.resultsPanel = this.add.container(0, 0).setDepth(80).setVisible(false)
    this.resultsBackdrop = this.add.rectangle(0, 0, 10, 10, 0x111111, 0.62).setOrigin(0.5)
    this.resultsBox = this.add.rectangle(0, 0, 460, 360, 0xf8f1df, 1)
    this.resultsBox.setStrokeStyle(3, 0x3d3933, 1)
    this.resultsText = this.add
      .text(0, 0, '', {
        align: 'center',
        color: '#24211c',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '17px',
        lineSpacing: 8,
      })
      .setOrigin(0.5)
    this.resultsPanel.add([this.resultsBackdrop, this.resultsBox, this.resultsText])

    this.upgradePanel = this.add.container(0, 0).setDepth(82).setVisible(false)
    this.upgradeBackdrop = this.add.rectangle(0, 0, 10, 10, 0x111111, 0.62).setOrigin(0.5)
    this.upgradeBox = this.add.rectangle(0, 0, 540, 430, 0xf8f1df, 1)
    this.upgradeBox.setStrokeStyle(3, 0x3d3933, 1)
    this.upgradeTitle = this.add
      .text(0, -180, '', {
        align: 'center',
        color: '#24211c',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '20px',
        fontStyle: '700',
      })
      .setOrigin(0.5)
    this.upgradePanel.add([this.upgradeBackdrop, this.upgradeBox, this.upgradeTitle])
    this.upgradeButtons = []
    this.createUpgradeButtons()

    this.needsPanel = new NeedsPanel(this)

    this.strip = this.add.container(0, 0)
    this.stripBody = this.add.rectangle(0, 0, 560, 132, 0xd9d3c7, 1)
    this.stripBody.setStrokeStyle(3, 0x5f5a51)
    this.strip.add(this.stripBody)

    this.cord = this.add.rectangle(0, 0, 130, 12, 0x5f5a51, 1)
    this.strip.add(this.cord)

    for (let index = 0; index < this.outletCount; index += 1) {
      this.outlets.push(this.createOutlet(index))
    }

    this.createDevices()
    this.input.on('dragstart', this.handleDragStart, this)
    this.input.on('drag', this.handleDrag, this)
    this.input.on('dragend', this.handleDragEnd, this)
    this.scale.on('resize', this.layout, this)
    this.time.addEvent({
      delay: NEED_TICK_MS,
      loop: true,
      callback: this.tickNeeds,
      callbackScope: this,
    })

    this.layout()
    this.updatePowerReadout()
    this.updateTimeReadout()
    this.updatePointsReadout()
    this.applyTimeTheme()
    this.needsPanel.update(this.needsModel.values)
  }

  createOutlet(index) {
    const plate = this.add.rectangle(0, 0, 96, 86, 0xf8f7f2, 1)
    plate.setStrokeStyle(2, 0x8b8376)

    const leftSlot = this.add.rectangle(-14, -8, 8, 28, 0x3c3934, 1)
    const rightSlot = this.add.rectangle(14, -8, 8, 28, 0x3c3934, 1)
    const ground = this.add.circle(0, 24, 6, 0x3c3934, 1)
    const highlight = this.add.rectangle(0, 0, 104, 94, 0x7fb069, 0)
    highlight.setStrokeStyle(4, 0x70a65f, 0)
    const occupiedOverlay = this.add.rectangle(0, 0, 104, 94, 0xd18f2f, 0)
    occupiedOverlay.setStrokeStyle(4, 0xd18f2f, 0)

    const outlet = this.add.container(0, 0, [
      highlight,
      plate,
      leftSlot,
      rightSlot,
      ground,
      occupiedOverlay,
    ])
    outlet.setData({ index, highlight, occupiedOverlay })
    this.strip.add(outlet)

    return outlet
  }

  createDevices() {
    DEVICES.forEach((definition, index) => {
      const width = definition.slots === 1 ? 112 : 232
      const container = this.add.container(0, 0)
      container.setSize(width, DEVICE_BODY_HEIGHT)
      container.setDepth(10)
      container.setData({
        ...definition,
        homeIndex: index,
        connectedStart: null,
        bodyWidth: width,
        bodyHeight: DEVICE_BODY_HEIGHT,
      })

      const body = this.add.rectangle(0, 0, width, DEVICE_BODY_HEIGHT, definition.color, 1)
      body.setStrokeStyle(3, 0x2b2926)

      const plugs = this.createDevicePlug(definition.plugOffsetX)

      const label = this.add
        .text(0, -11, definition.label, {
          align: 'center',
          color: '#fffdf8',
          fontFamily: 'system-ui, Segoe UI, sans-serif',
          fontSize: definition.slots === 1 ? '13px' : '15px',
          fontStyle: '700',
        })
        .setOrigin(0.5)

      const watts = this.add
        .text(0, 16, `${definition.watts}W`, {
          color: '#fffdf8',
          fontFamily: 'system-ui, Segoe UI, sans-serif',
          fontSize: '14px',
        })
        .setOrigin(0.5)

      container.add([body, ...plugs, label, watts])
      container.setData('plugParts', plugs)
      this.setDeviceInput(container)
      this.input.setDraggable(container)
      this.devices.push(container)
    })
  }

  createDevicePlug(plugOffsetX) {
    return [
      this.add.rectangle(plugOffsetX, 47, 38, 20, 0x2b2926, 1),
      this.add.rectangle(plugOffsetX - 8, 63, 4, 16, 0x2b2926, 1),
      this.add.rectangle(plugOffsetX + 8, 63, 4, 16, 0x2b2926, 1),
    ]
  }

  setDeviceInput(device) {
    const width = device.getData('bodyWidth')
    const height = device.getData('bodyHeight')
    const hitArea = new Phaser.Geom.Rectangle(0, 0, width, height)

    // Toggle SHOW_HITBOX_DEBUG to draw the exact draggable body area.
    // Phaser Container hit areas use top-left coordinates after displayOrigin is applied.
    // The visual body is centered in the Container, so Rectangle(0, 0, width, height)
    // maps exactly to the body bounds. The plug and prongs stay outside this hitbox.
    device.setInteractive(hitArea, Phaser.Geom.Rectangle.Contains)

    if (SHOW_HITBOX_DEBUG) {
      const debugHitbox = this.add.rectangle(0, 0, width, height, 0x00ffff, 0)
      debugHitbox.setStrokeStyle(2, 0x00ffff, 1)
      device.add(debugHitbox)
    }
  }

  layout() {
    const { width, height } = this.scale
    const targetStripWidth = 92 + this.outletCount * 120
    const stripWidth = Math.min(targetStripWidth, width - 44)
    const slotWidth = (stripWidth - SLOT_GAP * (this.outletCount + 1)) / this.outletCount
    const stripY = Math.max(250, height * 0.48)

    this.totalText.setPosition(width / 2, 38)
    this.timeText.setPosition(width - 24, 22)
    this.timeEffectText.setPosition(width - 24, 82)
    this.pointsText.setPosition(width - 24, 156)
    this.statusText.setPosition(width / 2, 74)
    this.warningText.setPosition(width / 2, 104)
    this.popupText.setPosition(width / 2, height / 2)
    this.needsPanel.setPosition(24, 118)
    this.flashOverlay.setSize(width, height)
    this.lightingOverlay.setSize(width, height)
    this.resultsPanel.setPosition(width / 2, height / 2)
    this.resultsBackdrop.setSize(width, height)
    this.upgradePanel.setPosition(width / 2, height / 2)
    this.upgradeBackdrop.setSize(width, height)

    this.strip.setPosition(width / 2, stripY)
    this.stripBody.setSize(stripWidth, 132)
    this.cord.setPosition(stripWidth / 2 + 64, 0)

    this.outlets.forEach((outlet, index) => {
      const x = -stripWidth / 2 + SLOT_GAP + slotWidth / 2 + index * (slotWidth + SLOT_GAP)
      outlet.setPosition(x, 0)
      outlet.setData('worldX', width / 2 + x)
      outlet.setData('worldY', stripY)
    })

    const columns = width < 700 ? 2 : DEVICES.length
    const columnGap = width < 700 ? 170 : 190
    const rowGap = 118
    const startX = width / 2 - ((columns - 1) * columnGap) / 2
    const startY = Math.min(height - 150, stripY + 180)

    this.devices.forEach((device, index) => {
      const homeX = startX + (index % columns) * columnGap
      const homeY = startY + Math.floor(index / columns) * rowGap
      device.setData({ homeX, homeY })

      if (device.getData('connectedStart') === null && !device.getData('isDragging')) {
        device.setPosition(homeX, homeY)
      } else if (device.getData('connectedStart') !== null) {
        this.snapDeviceToSlots(device, device.getData('connectedStart'), false)
      }
    })

    this.updateOutletVisuals()
  }

  handleDragStart(pointer, device) {
    if (this.isTripping || this.isShowingResults) {
      return
    }

    device.setData('isDragging', true)
    device.setDepth(20)
    this.releaseDeviceSlots(device)
    this.setOutletHighlights(device, true)
    device.setAlpha(0.88)
  }

  handleDrag(pointer, device, dragX, dragY) {
    if (this.isTripping || this.isShowingResults) {
      return
    }

    device.setPosition(dragX, dragY)
    this.previewDrop(device)
  }

  handleDragEnd(pointer, device) {
    device.setData('isDragging', false)
    device.setAlpha(1)
    device.setDepth(10)
    this.setOutletHighlights(device, false)

    if (this.isTripping || this.isShowingResults) {
      return
    }

    const startIndex = this.findBestSlotStart(device)

    if (startIndex !== null && this.canUseSlots(device, startIndex)) {
      this.connectDevice(device, startIndex)
      return
    }

    this.sendDeviceHome(device)
    this.statusText.setText('맞는 콘센트 공간이 없습니다')
  }

  previewDrop(device) {
    const startIndex = this.findBestSlotStart(device)
    this.updateOutletVisuals()

    if (startIndex !== null && this.canUseSlots(device, startIndex)) {
      for (let index = startIndex; index < startIndex + device.getData('slots'); index += 1) {
        const highlight = this.outlets[index].getData('highlight')
        highlight.setFillStyle(0x7fb069, 0.18)
        highlight.setStrokeStyle(4, 0x70a65f, 1)
      }
    }
  }

  connectDevice(device, startIndex) {
    for (let index = startIndex; index < startIndex + device.getData('slots'); index += 1) {
      this.occupiedSlots[index] = device
    }

    device.setData('connectedStart', startIndex)
    this.snapDeviceToSlots(device, startIndex, true)
    this.statusText.setText(`${device.getData('label')} 연결됨`)
    this.updatePowerReadout()
    this.updateOutletVisuals()

    if (this.getTotalPower() > this.maxPowerWatts) {
      this.tripBreaker()
    }
  }

  snapDeviceToSlots(device, startIndex, animate) {
    const snapPosition = this.getDeviceSnapPosition(device, startIndex)

    if (animate) {
      this.tweens.add({
        targets: device,
        x: snapPosition.x,
        y: snapPosition.y,
        duration: 130,
        ease: 'Quad.easeOut',
      })
    } else {
      device.setPosition(snapPosition.x, snapPosition.y)
    }
  }

  getDeviceSnapPosition(device, startIndex) {
    const plugAnchorIndex = startIndex + device.getData('plugAnchorOffset')
    const pluggedOutlet = this.outlets[plugAnchorIndex]
    const outletX = pluggedOutlet.getData('worldX')
    const outletY = pluggedOutlet.getData('worldY')

    return {
      x: outletX - device.getData('plugOffsetX'),
      y: outletY - SNAP_BODY_OFFSET_Y,
    }
  }

  releaseDeviceSlots(device) {
    this.occupiedSlots = this.occupiedSlots.map((occupant) => (occupant === device ? null : occupant))
    device.setData('connectedStart', null)
    this.updatePowerReadout()
    this.updateOutletVisuals()
  }

  canUseSlots(device, startIndex) {
    const slots = device.getData('slots')

    if (startIndex < 0 || startIndex + slots > this.outletCount) {
      return false
    }

    for (let index = startIndex; index < startIndex + slots; index += 1) {
      if (this.occupiedSlots[index] !== null) {
        return false
      }
    }

    return true
  }

  findBestSlotStart(device) {
    const slots = device.getData('slots')
    const plugOffsetX = device.getData('plugOffsetX')
    const plugAnchorOffset = device.getData('plugAnchorOffset')
    const candidates = []

    for (let start = 0; start <= this.outletCount - slots; start += 1) {
      const pluggedOutlet = this.outlets[start + plugAnchorOffset]
      const plugWorldX = device.x + plugOffsetX
      const plugWorldY = device.y + 62
      const distance = Phaser.Math.Distance.Between(
        plugWorldX,
        plugWorldY,
        pluggedOutlet.getData('worldX'),
        pluggedOutlet.getData('worldY'),
      )
      candidates.push({ start, distance })
    }

    candidates.sort((a, b) => a.distance - b.distance)
    return candidates[0]?.distance < 140 ? candidates[0].start : null
  }

  setOutletHighlights(device, isAvailablePreview) {
    this.outlets.forEach((outlet, index) => {
      const occupant = this.occupiedSlots[index]
      const highlight = outlet.getData('highlight')

      if (isAvailablePreview && occupant === null) {
        highlight.setFillStyle(0x7fb069, 0.08)
        highlight.setStrokeStyle(4, 0x70a65f, 0.35)
      } else {
        highlight.setFillStyle(0x7fb069, 0)
        highlight.setStrokeStyle(4, 0x70a65f, 0)
      }
    })
    this.updateOutletVisuals()
  }

  updateOutletVisuals() {
    this.outlets.forEach((outlet, index) => {
      const occupiedOverlay = outlet.getData('occupiedOverlay')
      const isOccupied = this.occupiedSlots[index] !== null

      occupiedOverlay.setFillStyle(0xd18f2f, isOccupied ? 0.18 : 0)
      occupiedOverlay.setStrokeStyle(4, 0xd18f2f, isOccupied ? 0.65 : 0)
    })
  }

  tickNeeds() {
    if (this.isShowingResults) {
      return
    }

    const completedDay = this.dayNightModel.tick()
    this.updateTimeReadout()
    this.applyTimeTheme()

    if (completedDay !== null) {
      this.showDayResults(completedDay)
      return
    }

    if (this.isTripping) {
      this.needsPanel.update(this.needsModel.values)
      return
    }

    const warnings = this.needsModel.update(this.getConnectedDeviceKeys(), this.dayNightModel, this.getProgressionContext())
    this.needsPanel.update(this.needsModel.values)

    if (warnings.length > 0) {
      this.handleWarnings(warnings)
    }
  }

  handleWarnings(warnings) {
    const latestWarning = warnings[warnings.length - 1]
    this.showWarning(latestWarning.message)

    warnings.forEach((warning) => {
      if (warning.type && this.dayStats[warning.type] !== undefined) {
        this.dayStats[warning.type] += 1
      }

      if (warning.critical) {
        this.showPopup(warning.popup)
      }
    })
  }

  showWarning(message) {
    this.warningText.setText(message)

    if (this.warningClearEvent) {
      this.warningClearEvent.remove(false)
    }

    this.warningClearEvent = this.time.delayedCall(2600, () => {
      this.warningText.setText('')
      this.warningClearEvent = null
    })
  }

  showPopup(message) {
    if (this.popupTween) {
      this.popupTween.stop()
    }

    if (this.popupClearEvent) {
      this.popupClearEvent.remove(false)
    }

    this.popupText.setText(message)
    this.popupText.setAlpha(1)

    this.popupClearEvent = this.time.delayedCall(1200, () => {
      this.popupTween = this.tweens.add({
        targets: this.popupText,
        alpha: 0,
        duration: 450,
        onComplete: () => {
          this.popupTween = null
          this.popupClearEvent = null
        },
      })
    })
  }

  createUpgradeButtons() {
    UPGRADE_DEFINITIONS.forEach((upgrade, index) => {
      const y = -120 + index * 58
      const button = this.add.rectangle(0, y, 450, 44, 0xe8ddc5, 1)
      button.setStrokeStyle(2, 0x4a443b, 1)
      const text = this.add
        .text(0, y, '', {
          align: 'center',
          color: '#24211c',
          fontFamily: 'system-ui, Segoe UI, sans-serif',
          fontSize: '14px',
        })
        .setOrigin(0.5)

      button.setInteractive({ useHandCursor: true })
      button.on('pointerdown', () => this.purchaseUpgrade(upgrade.key))
      this.upgradePanel.add([button, text])
      this.upgradeButtons.push({ button, text, upgrade })
    })

    const skipButton = this.add.rectangle(0, 170, 220, 38, 0xd1c5ad, 1)
    skipButton.setStrokeStyle(2, 0x4a443b, 1)
    const skipText = this.add
      .text(0, 170, '업그레이드 없이 계속', {
        align: 'center',
        color: '#24211c',
        fontFamily: 'system-ui, Segoe UI, sans-serif',
        fontSize: '14px',
        fontStyle: '700',
      })
      .setOrigin(0.5)
    skipButton.setInteractive({ useHandCursor: true })
    skipButton.on('pointerdown', () => this.finishUpgradeChoice())
    this.upgradePanel.add([skipButton, skipText])
  }

  getUpgradeCost(upgrade) {
    return upgrade.baseCost + this.upgrades[upgrade.key] * 55
  }

  updateUpgradeButtons() {
    this.upgradeTitle.setText([
      '업그레이드 선택',
      `총 포인트: ${this.totalPoints}`,
      '하나만 구매할 수 있습니다',
    ].join('\n'))

    this.upgradeButtons.forEach(({ button, text, upgrade }) => {
      const level = this.upgrades[upgrade.key]
      const cost = this.getUpgradeCost(upgrade)
      const canAfford = this.totalPoints >= cost
      button.setFillStyle(canAfford ? 0xe8ddc5 : 0x9d9587, 1)
      text.setText(`${upgrade.label}  Lv.${level}  비용 ${cost}\n${upgrade.description}`)
      text.setColor(canAfford ? '#24211c' : '#5f584d')
    })
  }

  purchaseUpgrade(upgradeKey) {
    if (!this.isChoosingUpgrade) {
      return
    }

    const upgrade = UPGRADE_DEFINITIONS.find((definition) => definition.key === upgradeKey)
    const cost = this.getUpgradeCost(upgrade)

    if (this.totalPoints < cost) {
      this.showPopup('포인트가 부족합니다')
      return
    }

    this.totalPoints -= cost
    this.upgrades[upgradeKey] += 1
    this.lastPurchasedUpgrade = `${upgrade.label} Lv.${this.upgrades[upgradeKey]}`
    this.applyUpgrade(upgradeKey)
    this.finishUpgradeChoice()
  }

  applyUpgrade(upgradeKey) {
    if (upgradeKey === 'outletSlot') {
      this.addOutletSlot()
    } else if (upgradeKey === 'maxPower') {
      this.maxPowerWatts += 500
      this.updatePowerReadout()
    }
  }

  addOutletSlot() {
    this.outletCount += 1
    this.occupiedSlots.push(null)
    this.outlets.push(this.createOutlet(this.outletCount - 1))
    this.layout()
  }

  finishUpgradeChoice() {
    this.upgradePanel.setVisible(false)
    this.isChoosingUpgrade = false
    this.isShowingResults = false
    this.dayStats = { ...EMPTY_DAY_STATS }
    this.updatePointsReadout()
    this.updatePowerReadout()
    this.updateTimeReadout()
  }

  showDayResults(completedDay) {
    this.isShowingResults = true
    const score = this.calculateDayScore()
    this.totalPoints += score.total
    this.updatePointsReadout()

    this.resultsText.setText([
      `DAY ${completedDay} 결과`,
      `생존 DAY: ${completedDay}`,
      '',
      ...score.lines,
      '',
      `획득 포인트: ${score.total}`,
      `총 포인트: ${this.totalPoints}`,
      `최근 업그레이드: ${this.lastPurchasedUpgrade}`,
    ].join('\n'))
    this.resultsPanel.setVisible(true)

    this.time.delayedCall(3600, () => {
      this.resultsPanel.setVisible(false)
      this.showUpgradeChoice()
    })
  }

  showUpgradeChoice() {
    this.isChoosingUpgrade = true
    this.updateUpgradeButtons()
    this.upgradePanel.setVisible(true)
  }

  calculateDayScore() {
    const lines = []
    let total = 0

    const addScore = (label, amount) => {
      total += amount
      lines.push(`${label} ${amount >= 0 ? '+' : ''}${amount}`)
    }

    addScore('생존 보너스', 100)

    if (this.needsModel.values.phoneBattery >= 50) {
      addScore('배터리 관리', 10)
    }

    if (this.needsModel.values.fatigue <= 60) {
      addScore('낮은 피로', 15)
    }

    if (this.dayStats.breakerTrips === 0) {
      addScore('과부하 없음', 20)
    } else {
      addScore('과부하 패널티', -15 * this.dayStats.breakerTrips)
    }

    if (this.dayStats.batteryCritical > 0) {
      addScore('배터리 방전 패널티', -10 * this.dayStats.batteryCritical)
    }

    if (this.dayStats.fatigueCritical > 0) {
      addScore('피로 위험 패널티', -12 * this.dayStats.fatigueCritical)
    }

    if (this.dayStats.temperatureCritical > 0) {
      addScore('고온 패널티', -8 * this.dayStats.temperatureCritical)
    }

    if (this.dayStats.funCritical > 0) {
      addScore('지루함 패널티', -8 * this.dayStats.funCritical)
    }

    return { lines, total: Math.max(0, total) }
  }

  updateTimeReadout() {
    this.timeText.setText([
      `현재 날짜: DAY ${this.dayNightModel.dayCount}`,
      `현재 시간: ${this.dayNightModel.getPhaseLabel()}`,
      `남은 시간: ${this.dayNightModel.remainingSeconds}초`,
    ].join('\n'))
    this.timeEffectText.setText(TIME_EFFECT_TEXT[this.dayNightModel.phase])
  }

  updatePointsReadout() {
    this.pointsText.setText(`총 포인트: ${this.totalPoints}`)
  }

  applyTimeTheme() {
    const theme = THEME[this.dayNightModel.phase]

    this.cameras.main.setBackgroundColor(theme.background)
    this.stripBody.setFillStyle(theme.strip, 1)
    this.lightingOverlay.setAlpha(theme.overlayAlpha)
    this.totalText.setColor(theme.text)
    this.timeText.setColor(theme.text)
    this.timeEffectText.setColor(theme.mutedText)
    this.pointsText.setColor(theme.text)
    this.statusText.setColor(theme.mutedText)
    this.needsPanel.setTheme(theme)
  }

  getConnectedDeviceKeys() {
    return this.devices.reduce((connected, device) => {
      if (device.getData('connectedStart') !== null) {
        connected.add(device.getData('key'))
      }

      return connected
    }, new Set())
  }

  getProgressionContext() {
    return {
      dayCount: this.dayNightModel.dayCount,
      upgrades: this.upgrades,
    }
  }

  getTotalPower() {
    return this.devices.reduce((total, device) => {
      return device.getData('connectedStart') === null ? total : total + device.getData('watts')
    }, 0)
  }

  updatePowerReadout() {
    if (!this.totalText) {
      return
    }

    const totalPower = this.getTotalPower()
    this.totalText.setText(`전력 사용량: ${totalPower}W / ${this.maxPowerWatts}W`)
    this.totalText.setColor(totalPower > this.maxPowerWatts ? '#be2020' : THEME[this.dayNightModel.phase].text)
  }

  tripBreaker() {
    this.isTripping = true
    this.dayStats.breakerTrips += 1
    this.needsModel.reduceStability(4 + Math.floor(this.dayNightModel.dayCount / 2))
    this.statusText.setText('과부하: 차단기 내려감')
    this.showPopup('과부하 발생!\n차단기가 내려갔습니다')
    this.flashOverlay.setAlpha(0)

    this.tweens.add({
      targets: this.flashOverlay,
      alpha: 0.62,
      duration: 80,
      yoyo: true,
      repeat: 4,
    })

    this.time.delayedCall(260, () => {
      this.occupiedSlots = Array(this.outletCount).fill(null)
      this.devices.forEach((device) => {
        device.setData('connectedStart', null)
        this.sendDeviceHome(device, 420)
      })
      this.updatePowerReadout()
      this.updateOutletVisuals()
    })

    const breakerDowntime = 980 + Math.min(1400, (this.dayNightModel.dayCount - 1) * 180)

    this.time.delayedCall(breakerDowntime, () => {
      this.isTripping = false
      this.statusText.setText('차단기 복구됨. 전력을 줄여보세요.')
    })
  }

  sendDeviceHome(device, duration = 180) {
    this.tweens.add({
      targets: device,
      x: device.getData('homeX'),
      y: device.getData('homeY'),
      duration,
      ease: 'Quad.easeOut',
    })
  }
}
