echo start building
echo ========= Audit Package Vulnerabilities =========
npm audit --parseable --registry=https://registry.npmjs.org/ | awk -F $'\t' '{print $3, "|" $5, "|" $1,"|" $2, "|" $6}' | sort -u > audit.out
echo "- [!] All Packages"
EXITCODE=0
cat audit.out
echo "- [!] Critical or High"
grep -hrE "critical|high" audit.out | wc -l
grep -hrE "critical|high" audit.out
mkdir -p report
grep -hrE "critical|high" audit.out > report/CritHigh.txt
echo "- [!] Dry run Fix"
npm audit fix --dry-run
auditsize=$(wc -c <audit.out)
if [ $auditsize -ge 1 ]; then
    EXITCODE=1
fi
mv audit.out report/.txt
#exit $EXITCODE
echo ========= Create WebApp =========
echo "REACT_APP_AUTH_AUTHORITY=$REACT_APP_AUTH_AUTHORITY" >> .env
echo "REACT_APP_AUTH_CLIENT_ID=$REACT_APP_AUTH_CLIENT_ID" >> .env
echo "REACT_APP_AUTH_SCOPE=$REACT_APP_AUTH_SCOPE" >> .env
echo "REACT_APP_AUTH_API_HOST=$REACT_APP_AUTH_API_HOST" >> .env
echo "REACT_APP_GITHUB_CLIENT_ID=$REACT_APP_GITHUB_CLIENT_ID" >> .env
echo "REACT_APP_GIT_CALLBACK_URL=$REACT_APP_GIT_CALLBACK_URL" >> .env
#a=$(Build.SourceVersion)
#b=${a:0:7}
echo "{\"version\":\"1.0.0 - 99\", \"siteTitle\": \"OneView\",\"theme\":{\"logoSrc\": \"/modernworkplace.jpg\",\"color\": \"#5e3fa2\"}}" > ./src/site-config.json
npm install
npm run build
cd build
zip -r -D ../deploy.zip *
cd ..
echo ========= build completed =========
