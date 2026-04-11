@echo off
echo ===================================================
echo Iniciando a publicacao do ATRIUM no Netlify...
echo ===================================================
echo.
echo Se esta for sua primeira vez, o terminal vai pedir
echo para voce autorizar o login no navegador.
echo.
npx netlify-cli deploy --prod
echo.
echo Publicacao finalizada!
pause
