echo 'compiling dust templates...'
duster templates templates/templates.js

echo 'compiling less css...'
lessc -x ./less/agency/agency.less > ./css/agency.min.css
lessc -x ./less/AdminLTE.less > ./css/AdminLTE.css

echo 'starting server for testing...'
python -m SimpleHTTPServer