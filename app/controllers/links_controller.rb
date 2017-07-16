require 'byebug'
class LinksController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:api_shorten]

	def api_shorten
  		input_link = params[:link][:long_link]
  		render json: shorten_long_link(input_link)
	end		

	def show
  		short_url = 'http://localhost:3000/'+params[:short_link]
  		link = Link.find_by(short_link: short_url)
  		if link
  			given_link = link.long_link
  			redirect_to "#{given_link}"
			link.count +=1
			link.save
  		else
  			render json: "Not found"
  		end

	end

	private
	def link_params
		params.require(:link).permit(:long_link, :short_link, :count)
	end

	def shorten_long_link(ip_link)
	    find_link = Link.find_by(long_link: ip_link)
	    if find_link
	    	json = {"success": true, "long_link": ip_link, "short_link": find_link.short_link}
	    else
	    	short_link = "http://localhost:3000/"+Link.get_short
	    	set_user = "anonymous"
	    	@user = User.create(username: set_user)
	    	@link = @user.links.new(link_params)
	    	@link.short_link = short_link
	    	@link.long_link = ip_link

	    	if @link.save
	    		json = {"success": true, "long_link": ip_link, "short_link": short_link}
	    		@user.user_links.create(link: @link)
	    	else
	    		json = {"success": false, "long_link": ip_link, "errors": @link.errors}
	    	end	
	    end
	    json
	end
end
