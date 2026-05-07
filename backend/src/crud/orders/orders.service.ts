import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common'
import { PrismaService } from 'src/prisma/prisma.service'
import { CreateOrderDto, UpdateOrderStatusDto } from './dto'

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.order.findMany({
      include: { items: { include: { product: true } }, user: { select: { id: true, username: true, email: true } } },
    })
  }

  async findOne(id: string) {
    const order = await this.prisma.order.findUnique({
      where: { id },
      include: { items: { include: { product: true } }, user: { select: { id: true, username: true, email: true } } },
    })
    if (!order) throw new NotFoundException('Order not found')
    return order
  }

  async findByUser(userId: string) {
    return this.prisma.order.findMany({
      where: { userId },
      include: { items: { include: { product: true } } },
    })
  }

  async create(userId: string, dto: CreateOrderDto) {
    return this.prisma.order.create({
      data: {
        userId,
        items: {
          create: dto.items.map((item) => ({
            productId: item.productId,
            quantity: item.quantity,
          })),
        },
      },
      include: { items: { include: { product: true } } },
    })
  }

  async updateStatus(id: string, userId: string, role: string, dto: UpdateOrderStatusDto) {
    const order = await this.findOne(id)
    if (role !== 'admin' && order.userId !== userId) {
      throw new ForbiddenException('Access Denied')
    }
    return this.prisma.order.update({
      where: { id },
      data: { status: dto.status },
      include: { items: { include: { product: true } } },
    })
  }

  async remove(id: string, userId: string, role: string) {
    const order = await this.findOne(id)
    if (role !== 'admin' && order.userId !== userId) {
      throw new ForbiddenException('Access Denied')
    }
    return this.prisma.order.delete({ where: { id } })
  }
}
