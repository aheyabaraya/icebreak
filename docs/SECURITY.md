# Security Practices

- Do **not** commit `.env`; include secrets only in runtime environment.
- Required env vars:
  - `AGORA_APP_ID`
  - `NAVER_MAP_CLIENT_ID`
  - `KAKAO_CLIENT_ID`
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
- Use `.env.example` to document variables and keep `.env` in `.gitignore`.
- Validate env presence before calling vendors; stubs default to safe no-op behavior when vars are absent.


## Flutter env file
- Keep secrets in pps/mobile/assets/.env (not committed).
- pps/mobile/assets/.env.example is committed with empty placeholders.

