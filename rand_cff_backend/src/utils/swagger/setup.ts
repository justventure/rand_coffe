import { DocumentBuilder } from '@nestjs/swagger'

export const SwaggerConfig = new DocumentBuilder()
  .setTitle('Nest js api')
  .setDescription(
    `
      Nest-js 
      boilerplate
      PrismaORM u
      Postgres 
      `,
  )
  .setVersion('6.6.6')
  .build()
