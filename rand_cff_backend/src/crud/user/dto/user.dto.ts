import { ApiProperty } from '@nestjs/swagger'
import { z } from 'zod'

export const UserSchema = z.object({
  username: z.string().min(1, { message: 'Username is required' }),
  password: z.string().optional(),
  email: z.string().optional(),
})

export class UserDto {
  static schema = UserSchema
  @ApiProperty()
  username: string

  @ApiProperty({ required: false })
  password?: string

  @ApiProperty({ required: false })
  email?: string
}
