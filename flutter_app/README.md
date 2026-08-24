# 🏃‍♂️ PaceSync Marathon (Flutter Native Cross-Platform)

高精度リアルタイム友達位置トラッキング、ギガ・省電力最適化、コース脱線判定音声ナビゲーション、応援エフェクト付きのクロスプラットフォーム（iOS / Android）アプリです。

---

## 🚀 特徴機能
1. **高精度バックグラウンドGPS & 動的電池最適化**: 電池残量に応じてGPS更新周期を最適調整（3秒〜10秒）。
2. **極短縮データフォーマット (ギガ節約)**: JSON通信量を1パケットあたり320byteから85byteへ軽量化。
3. **コース脱線アラート & 音声TTS読み上げ**: ホストの作成したコースから35m以上離脱した場合に自動音声警告。
4. **ホスト専用コースビルダー**: チェックポイント・給水所のインタラクティブ追加・距離自動計算。
5. **インタラクティブ応援システム**: サポーターからのメッセージをTTS＋サウンドエフェクトで走者にリアルタイム通知。

---

## 🛠️ ローカル環境でのビルド手順

### 1. リポジトリの準備
```bash
cd flutter_app
flutter pub get
```

### 2. Android APK / AAB のビルド
```bash
# APKの生成
flutter build apk --release

# Google Playストア用 AABの生成
flutter build appbundle --release
```

### 3. iOS IPA のビルド
```bash
flutter build ipa --release
```

---

## 📂 ファイル構成
- `lib/models/`: ランナー状態, コース, 応援データ構造
- `lib/services/`: GPS, 幾何計算ナビゲーション, TTS音声, 電池最適化
- `lib/widgets/`: HUD, 順位表, ホストコース構築UI, 応援オーバーレイ
- `lib/screens/`: マラソンメイン画面
