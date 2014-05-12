dial-a-device
=============

## instant setup on heroku from windows

* Install Heroku Toolbelt

		https://toolbelt.heroku.com/windows
		
* Open a command shell
		
		git clone https://github.com/Cominch/dial-a-device
		
		cd dial-a-device
		
		heroku login

		heroku create
		
		heroku ...
		
		git push heroku master
		
* Open a web browser and start using dial-a-device

		http://yourappname.herokuapp.com



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
		
		CREATE ROLE lsirailsprototype SUPERUSER LOGIN PASSWORD 'lsirailsprototype';
		
	Close the postgresql console
	
		\q

	Edit /etc/postgresql/9.1/main/pg_hba.conf
	
		sudo nano /etc/postgresql/9.1/main/pg_hba.conf
		
		
	In nano, Replace line "local 	all		all		peer"
	by "local 	all		all		md5" (Save with CTRL+O, Enter, CTRL+X)

	Restart the postgres server

		sudo service postgresql restart
		
* Install additional libraries
 
		sudo apt-get install libpq-dev openbabel imagemagick

* Clone the project and set it up

        git clone https://github.com/Cominch/dial-a-device.git
        cd dial-a-device
        bundle install --without production
        rake db:create:all
        rake db:migrate
        rake db:seed

* Go!

	Start the rails server ("thin" webserver)
		
		RAILS_ENV=localserver rails s

	If rails is not detected, update your bash profile again:

		. ~/.bash_profile
		
	Open your webbrowser:
	
		http://localhost:3000/
		
## deploy on your local server

* Customize parameters
	
	host name etc. in

		config/initializers/x-customization.rb

	mail server in
		
		config/environments/localserver.rb

* Create the background service

		rvmsudo foreman export upstart /etc/init -f Procfile.localserver -a dial-a-devie -u yourusername
		
* Enable port forwarding

		iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 5000

* Make iptables permanent

		sudo su
		iptables-save > /etc/iptables.conf
		
		nano /etc/network/interfaces
		
		-- add this line after each adapter:
		post-up iptables-restore < /etc/iptables.conf
		
## deploy on heroku

* create an account on heroku and install toolbelt

	Create an account on heroku.com
	
	TODO: Explain how to install heroku toolbelt
	
		cd dial-a-device

		heroku login

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
