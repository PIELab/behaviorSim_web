echo 'compiling dust templates...'
./node_modules/.bin/duster templates templates/templates.js

echo 'compiling less css...'
./node_modules/.bin/lessc -x ./less/agency/agency.less > ./css/agency.min.css
./node_modules/.bin/lessc -x ./less/AdminLTE.less > ./css/AdminLTE.css

echo 'starting server for testing...'
python -m SimpleHTTPServer