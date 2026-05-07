import type { ReactNode } from 'react'

export const metadata = {
  title: 'Admin Panel',
  description: 'Modern Admin Panel'
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="ru">
      <body>{children}</body>
    </html>
  )
}
