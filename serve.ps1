# 静的配信サーバ (node/python不要)。ダブルクリックでも動くが、サーバ経由でも開ける。
$Port = 8795
$Root = $PSScriptRoot

$mime = @{
  ".html"="text/html; charset=utf-8"; ".js"="text/javascript; charset=utf-8";
  ".css"="text/css; charset=utf-8"; ".json"="application/json; charset=utf-8";
  ".avif"="image/avif"; ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg";
  ".webp"="image/webp"; ".gif"="image/gif"; ".svg"="image/svg+xml";
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host ("Serving " + $Root + " at http://localhost:$Port/")

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $isHead = $ctx.Request.HttpMethod -eq 'HEAD'
      $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrEmpty($rel)) { $rel = "index.html" }
      $path = Join-Path $Root $rel
      if (Test-Path $path -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        $ctype = $mime[$ext]; if (-not $ctype) { $ctype = "application/octet-stream" }
        $fi = Get-Item $path
        $ctx.Response.ContentType = $ctype
        $ctx.Response.ContentLength64 = $fi.Length
        if (-not $isHead) {
          $fs = [System.IO.File]::OpenRead($path)
          try { $fs.CopyTo($ctx.Response.OutputStream) } finally { $fs.Close() }
        }
      } else {
        $ctx.Response.StatusCode = 404
        if (-not $isHead) {
          $b = [System.Text.Encoding]::UTF8.GetBytes("404: $rel")
          $ctx.Response.OutputStream.Write($b, 0, $b.Length)
        }
      }
    } catch {
      Write-Host ("req error: " + $_.Exception.Message)
    } finally {
      try { $ctx.Response.OutputStream.Close() } catch {}
    }
  }
} finally { $listener.Stop() }
