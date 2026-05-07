import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common'
import { Observable, tap, catchError } from 'rxjs'
import { PrismaService } from '../../prisma/prisma.service'

@Injectable()
export class StatsInterceptor implements NestInterceptor {
  constructor(private prisma: PrismaService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest()
    const { method, url } = req

    return next.handle().pipe(
      tap(async () => {
        await this.prisma.requestStat.create({
          data: { endpoint: url, method, status: 200, success: true },
        })
      }),
      catchError(async (err) => {
        const status = err?.status ?? 500
        await this.prisma.requestStat.create({
          data: { endpoint: url, method, status, success: false },
        })
        throw err
      }),
    )
  }
}
