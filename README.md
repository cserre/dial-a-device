dial-a-device
=============

## set up your own dial-a-device server on Ubuntu 13.04


* Install Ruby on Rails environment

		sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config cmake

		curl -L get.rvm.io | bash -s stable --auto
		. ~/.bash_profile

		rvm autolibs enable
		rvm install 1.9.3
		rvm use 1.9.3
		gem install rdoc
		gem install rails -v 3.2.13
		gem install bundler

* Install PostgreSQL

		sudo apt-get install postgresql libpq-dev

	Open the postgres console:

		sudo su postgres -c psql

	Perform the following postgresql command:
		
		CREATE ROLE dialadevice SUPERUSER LOGIN PASSWORD 'dialadevice';

	Edit /etc/postgresql/9.1/main/pg_hba.conf
		
		Replace line "local 	all		all		peer"
		by "local 	all		all		md5"

	Restart the postgres server

		sudo service postgresql restart

* Clone the project and set it up

        git clone https://github.com/Cominch/dial-a-device.git
        cd dial-a-device
        bundle install --without production
        rake db:create:all
        rake db:migrate
        rake db:seed

* Go!

	Start the rails server ("thin" webserver)

		rails s

	If rails is not detected, update your bash profile again:

		. ~/.bash_profile
		
## deploy on heroku

* create an account on heroku and install toolbelt

	TODO: explain deploy procedure

* create your app on heroku

	heroku create yourappname

	heroku labs:enable user-env-compile

	heroku config:set BUNDLE_WITHOUT="development:test:localserver"

	heroku labs:enable websockets 

	heroku addons:add sendgrid

	heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi

	heroku config:add LD_LIBRARY_PATH=/app/vendor/openbabel/lib

	git push heroku master

	heroku run rake db:migrate

	heroku run rake db:seed

## access legacy devices via vnc

* set up websockify gateway
	
	git clone https://github.com/hsanjuan/websockify

* fill up target list

	cd websockify

	nano targets

	ipadress:port:token

* add to crontab
	
	crontab -e

	append this line:
	
	@reboot cd /home/username/websockify && ./websockify :8091 --target-list ./targets

## License

	[GPLv3](http://www.gnu.org/licenses/gpl.html)
