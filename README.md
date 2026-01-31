# Icebreak Mobile

Single-source docs live in `docs/`.

- Setup: `docs/SETUP.md`
- Stack: `docs/STACK.md`
- Vendor notes: `docs/VENDORS.md`
- Security: `docs/SECURITY.md`
- Install logs: `docs/logs/`

## How to run
1. (Optional) copy env:
   - `apps/mobile/assets/.env.example` -> `apps/mobile/assets/.env`
2. Install dependencies:
   - `cd apps/mobile`
   - `flutter pub get`
3. Run:
   - `flutter run`

## Bootstrap
- Windows: `powershell -ExecutionPolicy Bypass -File scripts/bootstrap.ps1`
- Mac/WSL: `bash scripts/bootstrap.sh`
