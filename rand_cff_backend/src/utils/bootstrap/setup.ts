import * as cliColor from 'cli-color'

export const onBootstrapComplete = () => {
  console.log()
  console.log(
    cliColor.blue('🌐 Application is running on: http://localhost:3000'),
  )
  console.log()
}

export const onBootstrapError = (error: unknown) => {
  console.error(cliColor.red('❌ Error during bootstrap:'), error)
}
