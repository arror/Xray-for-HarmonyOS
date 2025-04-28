@ObservedV2
export class LaunchPageViewModel {

  async prepare(): Promise<void> {
    await Promise.all([this.displayBrand()])
  }

  async displayBrand(): Promise<void> {
    return new Promise((resolve, _) => {
      setTimeout(() => {
        resolve()
      }, 1000)
    })
  }
}