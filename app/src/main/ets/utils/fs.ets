import { fileIo } from "@kit.CoreFileKit"
import { FileUtil } from "@pura/harmony-utils"

export namespace fs {

  export async function copy(srcPath: string, dstPath: string): Promise<void> {
    let src: fileIo.File | undefined
    let dst: fileIo.File | undefined
    try {
      src = await FileUtil.open(srcPath, fileIo.OpenMode.READ_ONLY)
      dst = await FileUtil.open(dstPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      await FileUtil.copyFile(src.fd, dst.fd)
    } catch (e) {
      throw e as Error
    } finally {
      try {
        if (src) {
          FileUtil.close(src)
        }
      } catch {
      }
      try {
        if (dst) {
          FileUtil.close(dst)
        }
      } catch {
      }
    }
  }

  export async function stat(path: string): Promise<fileIo.Stat> {
    let file: fileIo.File | undefined
    try {
      file = await FileUtil.open(path)
      return await FileUtil.stat(file.fd)
    } catch (e) {
      throw e as Error
    } finally {
      try {
        if (file) {
          FileUtil.close(file)
        }
      } catch {
      }
    }
  }
}