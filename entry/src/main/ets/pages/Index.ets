import { scanBarcode, scanCore } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
struct Index {
  @State selectedTab: number = 0;
  @State macAddress: string = '';
  @State ipAddress: string = '';
  @State port: string = '';
  @State powerStatus: number = 1;
  @State cardType: number = 1;
  @State runState: number = 1

  private readonly tabs: string[] = ['配置ip', '开关机', '卡类型', '充电系统'];

  scanCode():void {
    //扫二维码
    const options: scanBarcode.ScanOptions = {
      // 使用 scanCore.ScanType 枚举
      scanTypes: [scanCore.ScanType.QR_CODE],
      // enableBeep 和 enableMultiMode 通常已被移除
      // enableBeep: true,
      // enableMultiMode: false,

      // 可以保留或移除 enableAlbum 参数，默认为 true[reference:6]
      // enableAlbum: true,
    };
    scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
      console.info(`扫码成功！内容: ${result.originalValue}, 格式: ${result.scanType}`);
    }).catch((error: BusinessError) => {
      console.error(`扫码失败，错误码: ${error.code}, 信息: ${error.message}`);
    });

  }

  build() {
    Column() {
      this.buildHeader()

      Column({ space: 18 }) {
        this.buildTabs()
        this.buildForm()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 22 })

      Blank()

      this.buildActions()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  private buildHeader() {
    Row() {
      Text('智能终端配置')
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(46)
    .backgroundColor('#B5B5B5')
  }

  @Builder
  private buildTabs() {
    Row({ space: 10 }) {
      ForEach(this.tabs, (tab: string, index: number) => {
        Button(tab)
          .height(34)
          .padding({ left: 12, right: 12 })
          .backgroundColor(this.selectedTab === index ? '#93B64C' : '#F1F1F1')
          .fontColor(this.selectedTab === index ? '#FFFFFF' : '#666666')
          .fontSize(14)
          .borderRadius(6)
          .onClick(() => {
            this.selectedTab = index;
          })
      }, (tab: string) => tab)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  private buildForm() {
    Column({ space: 12 }) {
      this.buildInputRow('mac地址', '请输入MAC地址', this.macAddress, (value: string) => {
        this.macAddress = value;
      })

      if (this.selectedTab === 0) {
        this.buildInputRow('ip', '请输入Ip', this.ipAddress, (value: string) => {
          this.ipAddress = value;
        })
        this.buildInputRow('端口', '请输入端口', this.port, (value: string) => {
          this.port = value;
        })
      }

      if (this.selectedTab === 1) {
        this.buildSwitchRow("开关机",this.powerStatus)
      }
      if(this.selectedTab === 3){
        this.buildSwitchRow("运行状态",this.runState)
      }

      if (this.selectedTab === 2) {
        this.buildCardTypeRow()
      }
    }
    .width('100%')
  }

  @Builder
  private buildInputRow(label: string, placeholder: string, value: string, onChange: (value: string) => void) {
    Row({ space: 14 }) {
      Text(label)
        .width(58)
        .fontSize(14)
        .fontColor('#666666')

      TextInput({ placeholder, text: value })
        .layoutWeight(1)
        .height(48)
        .fontSize(15)
        .placeholderColor('#B8B8B8')
        .backgroundColor('#FFFFFF')
        .borderRadius(4)
        .border({ width: 1, color: '#E6E6E6' })
        .padding({ left: 14, right: 14 })
        .onChange(onChange)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private buildSwitchRow(label: string,thIsOn:number) {
    Row({ space: 14 }) {
      Text(label)
        .width(58)
        .fontSize(14)
        .fontColor('#666666')

      Row({ space: 12 }) {
        Toggle({ type: ToggleType.Switch, isOn: thIsOn === 1 })
          .selectedColor('#5A16E8')
          .onChange((isOn: boolean) => {
            if (this.selectedTab == 1) {
              this.powerStatus = isOn ? 1 : 0;
            }else{
              this.runState = isOn ? 1 : 0;
            }

          })

        Text(thIsOn === 1 ? '开' : '关')
          .fontSize(15)
          .fontColor('#333333')
      }
      .layoutWeight(1)
      .height(48)
      .padding({ left: 14, right: 14 })
      .borderRadius(4)
      .border({ width: 1, color: '#E6E6E6' })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private buildCardTypeRow() {
    Row({ space: 14 }) {
      Text('卡类型')
        .width(58)
        .fontSize(14)
        .fontColor('#666666')

      Row({ space: 24 }) {
        this.buildRadioOption('人员卡', 1)
        this.buildRadioOption('车辆卡', 0)
      }
      .layoutWeight(1)
      .height(48)
      .padding({ left: 14, right: 14 })
      .borderRadius(4)
      .border({ width: 1, color: '#E6E6E6' })
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private buildRadioOption(label: string, value: number) {
    Row({ space: 8 }) {
      Radio({ value: `${value}`, group: 'cardType' })
        .checked(this.cardType === value)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.cardType = value;
          }
        })

      Text(label)
        .fontSize(15)
        .fontColor('#333333')
    }
    .onClick(() => {
      this.cardType = value;
    })
  }

  @Builder
  private buildActions() {
    Row({ space: 16 }) {
      Button('扫一扫')
        .width(98)
        .height(40)
        .backgroundColor('#5A16E8')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .borderRadius(4)
        .onClick(()=>{
          this.scanCode()
        })

      Button('开始广播')
        .width(118)
        .height(40)
        .backgroundColor('#5A16E8')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .borderRadius(4)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ bottom: 34 })
  }
}
