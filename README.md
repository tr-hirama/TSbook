# TSbook

ブラウザだけで動く **AVIF / JPG 画像・PDF ビューワー / ZIP 対応コミックリーダー**。
`index.html` ＋ 同梱の PDF.js のみ。ビルド不要・完全クライアント処理（サーバー送信なし）。

🔗 ライブデモ: https://tr-hirama.github.io/TSbook/

## 特長

- **AVIF / JPG / PNG / WebP / GIF** を表示（AVIF はブラウザのネイティブデコードで軽量・高速）
- **PDF** を表示（[PDF.js](https://mozilla.github.io/pdf.js/) 同梱）。各ページを画像化し、ツリーでは 📕 フォルダ＝1ページ1サムネ、←→ でページめくり、ズーム/パンや PNG/JPEG 変換も画像と同一UI
- 画像 / PDF / フォルダ / **ZIP** をドラッグ＆ドロップ、またはファイル選択で読み込み（ZIP 内の PDF も展開）
- **ZIP 内のフォルダ階層をツリー表示**し、巻・章ごとに閲覧
- **大容量 ZIP 対応**: `File.slice` で必要な部分だけを読み、画像は表示時に展開（500MB 級でも即ツリー表示）
  - STORED（無圧縮）はスライスのみ、DEFLATE はブラウザ標準 `DecompressionStream('deflate-raw')` で展開（外部ライブラリ不要）
  - ファイル名は UTF-8 / Shift-JIS を自動判別
- ライトボックス: ホイールズーム（カーソル基準）/ ドラッグパン / フィット / 等倍 / ダブルクリック切替
- サムネイルは遅延読み込み（IntersectionObserver）でメモリを抑制
- スライドショー（秒数指定）、フィルムストリップ
- 表示中の画像を **PNG / JPEG** に変換してダウンロード（JPEG は白背景で合成）

## キーボード操作

| キー | 動作 |
|---|---|
| ← / → | 前 / 次のページ |
| Esc | ビューアを閉じる |
| Space | スライドショー切替 |
| + / − | ズーム |
| 0 | 等倍 (100%) |
| F | フィット |

## 使い方

`index.html` をブラウザで開くだけ（ダブルクリックで可）。
画像・PDF・ZIP はすべてローカルで処理され、サーバーへ送信されることはありません。

> PDF は `file://` 直開きだと一部ブラウザで Worker が無効化され PDF.js がメインスレッド動作（やや低速）になります。快適に使うには下記の `serve.ps1` か[ライブデモ](https://tr-hirama.github.io/TSbook/)経由を推奨。

ローカルで HTTP 配信したい場合は同梱の `serve.ps1`（PowerShell のみ・追加ランタイム不要）:

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
# → http://localhost:8795/
```

## 対応ブラウザ

AVIF のネイティブデコードと `DecompressionStream('deflate-raw')` に対応した最新版の
**Chrome / Edge / Firefox**。
