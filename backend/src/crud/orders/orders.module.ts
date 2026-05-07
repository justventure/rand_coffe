import { Module } from '@nestjs/common'
import { APP_INTERCEPTOR } from '@nestjs/core'
import { OrdersController } from './orders.controller'
import { OrdersService } from './orders.service'
import { PrismaModule } from 'src/prisma/prisma.module'
import { RequestStatInterceptor } from 'src/common/interceptors/request-stat.interceptor'
import { AuthModule } from 'src/auth/auth.module'

@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [OrdersController],
  providers: [
    OrdersService,
    {
      provide: APP_INTERCEPTOR,
      useClass: RequestStatInterceptor,
    },
  ],
})
export class OrdersModule {}
