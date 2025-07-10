// app/api/screenshot/route.ts
export const runtime = 'nodejs'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
  const target = req.nextUrl.searchParams.get('url')
  console.log('📸 screenshot for', target)
  if (!target) return NextResponse.json({ error: 'Missing ?url=' }, { status: 400 })

  const chromium = require('@sparticuz/chromium')
  const puppeteer = require('puppeteer-core')
  let browser = null

  try {
    browser = await puppeteer.launch({
      args: [...chromium.args, '--no-sandbox','--disable-setuid-sandbox'],
      executablePath: await chromium.executablePath(),
      headless: chromium.headless,
    })
    const page = await browser.newPage()
    await page.goto(target, { waitUntil: 'networkidle2', timeout: 30_000 })
    const buffer = await page.screenshot({ fullPage: true })
    console.log('✅ took screenshot:', buffer.byteLength, 'bytes')
    return new NextResponse(buffer, {
      status: 200,
      headers: {
        'Content-Type':'image/png',
        'Cache-Control':'s-maxage=3600,stale-while-revalidate'
      },
    })
  } catch (err: any) {
    console.error('🚨 screenshot error:', err)
    return NextResponse.json({ error: err.message }, { status: 500 })
  } finally {
    if (browser) await browser.close()
  }
}
