git clone git@github.com:slatedocs/slate slate

rm -r slate/source
cp source slate/source

cd slate || exit
bundle exec middleman build