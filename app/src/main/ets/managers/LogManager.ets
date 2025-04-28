import { FileUtil, PreferencesUtil } from "@pura/harmony-utils"

const LogKey = 'LOG_KEY'

export interface Log {
  access: string,
  error: string,
  loglevel: string,
  dnsLog: boolean,
  maskAddress: string
}

interface LogObject {
  logLevelIndex: number
  maskLevelIndex: number
  dnsLogEnabled: boolean
}

@ObservedV2
export class LogManager {

  static readonly accessLogPath = FileUtil.getFilesDirPath('log', 'access.txt')
  static readonly errorLogPath = FileUtil.getFilesDirPath('log', 'error.txt')

  static readonly logLevels: string[] = ['debug', 'info', 'warning', 'error', 'none']
  static readonly displayLogLevels: string[] = ['调试', '信息', '警告', '错误', '关闭']

  static readonly maskLevels: string[] = ['quarter', 'half', 'full', '']
  static readonly displayMaskLevels: string[] = ['四分之一', '二分之一', '全部', '关闭']

  @Trace logLevelIndex: number = 0
  @Trace maskLevelIndex: number = 0
  @Trace dnsLogEnabled: boolean = false

  private static readonly default: LogObject = {
    logLevelIndex: 2,
    maskLevelIndex: 3,
    dnsLogEnabled: false
  }

  constructor() {
    const obj = PreferencesUtil.getSync(LogKey, LogManager.default) as LogObject
    this.logLevelIndex = obj.logLevelIndex ?? 2
    this.maskLevelIndex = obj.maskLevelIndex ?? 3
    this.dnsLogEnabled = obj.dnsLogEnabled ?? false
  }

  update(): void {
    PreferencesUtil.put(LogKey, {
      logLevelIndex: this.logLevelIndex,
      maskLevelIndex: this.maskLevelIndex,
      dnsLogEnabled: this.dnsLogEnabled
    } as LogObject)
  }

  static log(): Log {
    try {
      FileUtil.unlinkSync(LogManager.accessLogPath)
      FileUtil.unlinkSync(LogManager.errorLogPath)
    } catch {}
    const obj = PreferencesUtil.getSync(LogKey, LogManager.default) as LogObject
    return {
      access: LogManager.accessLogPath,
      error: LogManager.errorLogPath,
      loglevel: LogManager.logLevels[obj.logLevelIndex],
      dnsLog: obj.dnsLogEnabled,
      maskAddress: LogManager.maskLevels[obj.maskLevelIndex]
    }
  }
}