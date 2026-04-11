@echo off
echo ===================================================
echo Iniciando a publicacao do ATRIUM na VERCEL...
echo ===================================================
echo.
echo Se esta for sua primeira vez, o terminal vai pedir
echo para voce autorizar o login no navegador.
echo.
npx vercel@latest --prod
echo.
echo Publicacao finalizada!
pause
