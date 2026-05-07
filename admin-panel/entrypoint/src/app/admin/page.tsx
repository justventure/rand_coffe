'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { Grid, Card, CardContent, Typography } from '@mui/material'

const API = process.env.NEXT_PUBLIC_API_URL

export default function AdminDashboard() {
  const [requestStats, setRequestStats] = useState<any>(null)
  const [dbStats, setDbStats] = useState<any>(null)

  useEffect(() => {
    const load = async () => {
      const [req, db] = await Promise.all([
        axios.get(`${API}/stats/requests`),
        axios.get(`${API}/stats/db`)
      ])

      setRequestStats(req.data)
      setDbStats(db.data)
    }

    load()
  }, [])

  return (
    <Grid container spacing={2}>
      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Всего запросов</Typography>
            <Typography>{requestStats?.total ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>

      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Успешные запросы</Typography>
            <Typography>{requestStats?.successful ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>

      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Неудачные запросы</Typography>
            <Typography>{requestStats?.failed ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>

      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Товары</Typography>
            <Typography>{dbStats?.products ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>

      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Категории</Typography>
            <Typography>{dbStats?.categories ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>

      <Grid size={{ xs: 12, md: 4 }}>
        <Card>
          <CardContent>
            <Typography variant="h6">Заказы</Typography>
            <Typography>{dbStats?.orders ?? 0}</Typography>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  )
}
