# Vendor Notes

## Agora
- Replace `AGORA_APP_ID` in `.env` and load via `flutter_dotenv`.
- No keys in repo; stub `agora_stub.dart` uses placeholder.

## Naver Map
- Provide `NAVER_MAP_CLIENT_ID` in `.env` and configure Android/iOS manifest.
- `naver_map_stub.dart` wraps `NaverMap` with defaults.

## Kakao
- Supply `KAKAO_CLIENT_ID` for login.
- Follow Kakao SDK setup per https://developers.kakao.com

## In-App Purchases
- Configure App Store Connect / Google Play credentials.
- `in_app_purchase` plugin handles platform billing flows.

## Supabase
- Use `SUPABASE_URL` and `SUPABASE_ANON_KEY` from env.
- `supabase_stub.dart` reads these values safely.
