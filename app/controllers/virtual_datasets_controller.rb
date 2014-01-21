class VirtualDatasetsController < ApplicationController


	include DAV4Rack::HTTPStatus

	def options

      response['Allow'] = 'OPTIONS,HEAD,GET,PUT,POST,DELETE,PROPFIND,PROPPATCH,MKCOL,COPY,MOVE,LOCK,UNLOCK'
      response['Ms-Author-Via'] = 'DAV'
      OK
      render :text => "fake options"
    end


end