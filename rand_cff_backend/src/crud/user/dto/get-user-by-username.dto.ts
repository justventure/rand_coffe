import { ApiProperty } from '@nestjs/swagger'
import { z } from 'zod'

export const GetUserByUsernameSchema = z.object({
  username: z.string().min(2, { message: 'Username is required' }),
})

export class GetUserByUsernameDto {
  static schema = GetUserByUsernameSchema

  @ApiProperty({
    description: 'Unique identifier of the user',
    example: 'john_doe',
  })
  username: string
}
