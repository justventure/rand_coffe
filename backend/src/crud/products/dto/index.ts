import { ApiProperty } from '@nestjs/swagger'
import { z } from 'zod'

export const createProductSchema = z.object({
  name: z.string().min(1),
  price: z.number().int().positive(),
  imageUrl: z.string().url().optional(),
  description: z.string().optional(),
  categoryId: z.string().uuid(),
})

export const updateProductSchema = createProductSchema.partial()

export class CreateProductDto {
  static schema = createProductSchema
  @ApiProperty() name: string
  @ApiProperty() price: number
  @ApiProperty({ required: false }) imageUrl?: string
  @ApiProperty({ required: false }) description?: string
  @ApiProperty() categoryId: string
}

export class UpdateProductDto {
  static schema = updateProductSchema
  @ApiProperty({ required: false }) name?: string
  @ApiProperty({ required: false }) price?: number
  @ApiProperty({ required: false }) imageUrl?: string
  @ApiProperty({ required: false }) description?: string
  @ApiProperty({ required: false }) categoryId?: string
}
