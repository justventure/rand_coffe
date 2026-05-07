import { Injectable } from '@nestjs/common'
import { PrismaService } from 'src/prisma/prisma.service'

@Injectable()
export class StatsService {
  constructor(private prisma: PrismaService) {}

  async getRequestStats() {
    const [total, successful, failed] = await Promise.all([
      this.prisma.requestStat.count(),
      this.prisma.requestStat.count({ where: { success: true } }),
      this.prisma.requestStat.count({ where: { success: false } }),
    ])
    return { total, successful, failed }
  }

  async getDbStats() {
    const [products, categories, orders] = await Promise.all([
      this.prisma.product.count(),
      this.prisma.category.count(),
      this.prisma.order.count(),
    ])
    return { products, categories, orders }
  }

  async getEndpointStats() {
    const rows = await this.prisma.requestStat.groupBy({
      by: ['endpoint', 'method', 'status'],
      _count: { id: true },
    })

    const grouped: Record<string, any> = {}

    for (const row of rows) {
      const key = `${row.method} ${row.endpoint}`
      if (!grouped[key]) {
        grouped[key] = { endpoint: row.endpoint, method: row.method, total: 0, statuses: {} }
      }
      grouped[key].total += row._count.id
      grouped[key].statuses[row.status] = row._count.id
    }

    return Object.values(grouped)
  }
}
