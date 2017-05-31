#!/bin/bash

if [ "$(whoami)" != "rails" ]; then
echo "Cannot run this script as root. You must sudo to the 'rails' user."
exit -1;
fi

export HOME="/home/rails"

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
source "$HOME/.rvm/scripts/rvm";
fi

cd /home/rails/contrataciones

export GOOGLE_KEY='872734752962-5t247520iabbdtlhf7lch2s9c03aasj9.apps.googleusercontent.com'
export GOOGLE_SECRET='ZuBWCaPvMaoxuH312ZmtcJbn'
export RAILS_ENV='production'
export SECRET_KEY_BASE='1tg487safjndsa94jsdfp94lhjseaf974la26123124jhasdf789'
export CONTRATACIONES_DATABASE_PASSWORD='c0ntr4t4c10n35@C!M^v'

nohup rails s -p 8000 &
