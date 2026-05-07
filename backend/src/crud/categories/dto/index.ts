import { ApiProperty } from '@nestjs/swagger'
import { z } from 'zod'

export const createCategorySchema = z.object({
  name: z.string().min(1),
})

export const updateCategorySchema = createCategorySchema.partial()

export class CreateCategoryDto {
  static schema = createCategorySchema
  @ApiProperty() name: string
}

export class UpdateCategoryDto {
  static schema = updateCategorySchema
  @ApiProperty({ required: false }) name?: string
}
