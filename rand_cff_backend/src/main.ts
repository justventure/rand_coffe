import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { SwaggerModule } from '@nestjs/swagger'
import * as cliColor from 'cli-color'
import { SwaggerConfig } from './utils/swagger'
import { corsOptions } from './utils/cors'
import { onBootstrapComplete, onBootstrapError } from './utils/bootstrap/setup'
import { SwaggerTheme, SwaggerThemeNameEnum } from 'swagger-themes'
import { ZodValidationPipe } from './common/pipes'
import { StatsInterceptor } from './common/interceptors/stats.interceptor'
import { PrismaService } from './prisma/prisma.service'

async function bootstrap() {
  console.log(cliColor.green('✅ NestJS application is starting...'))
  console.log()

  const app = await NestFactory.create(AppModule)

  const document = SwaggerModule.createDocument(app, SwaggerConfig)
  const theme = new SwaggerTheme()
  const options = {
    explorer: true,
    customCss: theme.getBuffer(SwaggerThemeNameEnum.DARK),
  }

  SwaggerModule.setup('api', app, document, options)

  app.enableCors(corsOptions)
  app.useGlobalPipes(new ZodValidationPipe())
  app.useGlobalInterceptors(new StatsInterceptor(app.get(PrismaService)))

  await app.listen(3000)
}

bootstrap().then(onBootstrapComplete).catch(onBootstrapError)
