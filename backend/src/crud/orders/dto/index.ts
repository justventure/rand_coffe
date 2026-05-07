import { ApiProperty } from '@nestjs/swagger'
import { z } from 'zod'

export enum OrderStatus {
  PENDING = 'PENDING',
  CONFIRMED = 'CONFIRMED',
  COMPLETED = 'COMPLETED',
  CANCELLED = 'CANCELLED',
}

export const createOrderItemSchema = z.object({
  productId: z.string().uuid(),
  quantity: z.number().int().positive().default(1),
})

export const createOrderSchema = z.object({
  items: z.array(createOrderItemSchema).min(1),
})

export const updateOrderStatusSchema = z.object({
  status: z.nativeEnum(OrderStatus),
})

export class CreateOrderItemDto {
  static schema = createOrderItemSchema
  @ApiProperty() productId: string
  @ApiProperty({ default: 1 }) quantity: number
}

export class CreateOrderDto {
  static schema = createOrderSchema
  @ApiProperty({ type: [CreateOrderItemDto] }) items: CreateOrderItemDto[]
}

export class UpdateOrderStatusDto {
  static schema = updateOrderStatusSchema
  @ApiProperty({ enum: OrderStatus }) status: OrderStatus
}
