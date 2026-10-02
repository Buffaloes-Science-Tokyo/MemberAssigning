# Kick Members

キックプレーのメンバー編成ボード。Flutter Web アプリとして Vercel にデプロイし、
データは各端末のブラウザ内 (SQLite/WASM) に保存するので **オフラインでも動く**。
オンライン時に **Sync ボタンを押すと** Neon (Postgres) と同期する。

```
app/        Flutter アプリ (lib/README.md に構成説明)
api/        Vercel Functions: /api/sync (Neon に保存)
scripts/    Vercel ビルド・オフライン用 Service Worker 生成
```

## 仕組み

- **オフライン動作**: ビルド時に `scripts/gen-sw.mjs` が `sw.js` を生成し、
  アプリ本体 (main.dart.js / CanvasKit / sqlite3.wasm など約17MB) を初回アクセス時に
  すべてキャッシュする。2回目以降は電波がなくても起動できる。
  再デプロイ時は中身が変わったファイルだけ再取得される。
- **データ**: 端末ごとのブラウザ内 SQLite (Drift)。編集は常にローカルに即保存。
- **同期 (手動)**: サーバーは「全データのスナップショット + バージョン番号」を1つ持つ。
  Sync を押すと
  - サーバーだけ変わっていた → サーバーの内容を取り込む
  - この端末だけ変わっていた → サーバーへアップロード
  - 両方変わっていた → どちらを残すか選ぶダイアログ（選ばなかった側は上書き）
  - Sync アイコンの赤い点 = 未同期の変更あり

## デプロイ手順 (初回)

1. **Neon**: プロジェクトを作成し、接続文字列 (`postgresql://...`) を控える。
   テーブルは初回アクセス時に API が自動作成する。
2. **Vercel**: このリポジトリを Import (Root Directory はリポジトリ直下のまま)。
   `vercel.json` にビルド設定があるので Framework Preset は "Other" のままでよい。
3. Vercel の Environment Variables に設定:
   - `DATABASE_URL` … Neon の接続文字列 (Vercel の Neon 連携を使えば自動で入る)
   - `SYNC_TOKEN` … 同期キー。長いランダム文字列にする
     (例: `node -e "console.log(crypto.randomUUID())"`)
4. デプロイ後、各端末でサイトを開き、雲アイコン → Sync key に `SYNC_TOKEN` を入力。
5. iPad/iPhone は Safari の「ホーム画面に追加」推奨
   (追加しないと Safari が長期間未使用のサイトのデータを消すことがある)。

新しい端末で初めて Sync を押すと「サーバーに既にデータがある」ダイアログが出るので、
通常は **Use server** を選ぶ。

## 開発

```sh
cd app && flutter run -d chrome     # 開発 (Service Worker なし)
cd app && flutter test              # Flutter 側テスト
npm install && npm test             # API のテスト (PGlite を使うので DB 不要)
bash scripts/vercel-build.sh        # 本番ビルド (app/build/web)
npx vercel dev                      # API 込みでローカル実行 (要 .env に DATABASE_URL / SYNC_TOKEN)
```

### ローカル DB で同期を試す (Neon 不要)

```sh
npm run dev                # http://localhost:8787/api/sync  (データは .local-db/ に保存)
npm run dev -- --memory    # 毎回まっさらな DB
cd app && flutter run -d chrome --dart-define=SYNC_SERVER_URL=http://localhost:8787
```

- DB は PGlite (Node 内で動く Postgres)。本番と同じ `api/_lib/store.js` を使う。
- Sync key は `dev` (環境変数 `SYNC_TOKEN` で変更可)。アプリの雲アイコンから入力する。
- VS Code の Debug 構成 (`app/.vscode/launch.json`) には `SYNC_SERVER_URL` 指定済み。
- 設定画面で Server URL を保存済みだとそちらが優先されるので、空欄の保存ではなく
  ローカル URL を入れるか、ブラウザのサイトデータを消す。
- DB をリセットするには `.local-db/` を削除。
