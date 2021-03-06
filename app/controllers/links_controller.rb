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
  			link.count +=1
			link.save
  			redirect_to "#{given_link}"
  		else
  			render json: "Not found"
  		end
	end

	def get_link
		input_link = params[:long_link]
		input_name = params[:username]
		if input_link
			@short_link = shorten_link_web(input_link, input_name)
		end
	end

	def link_statistics
		#count number of times a link is shortened
		@total_links_shortened = Link.count

		#count number of times particular link is accessed
		@short_link = params[:short_link]
		@link = Link.find_by(short_link: @short_link)
	end


	def user_statistics
		user_name = params[:username]		 	
		if user_name.present?
			@user = User.find_by(username: user_name)
			if @user 
				@user_links = UserLink.where(user_id: @user.id)	
				@link_count = @user_links.count
				if @user_links.present?
					@links = []
					@user_links.each do |user_link|
						@links << Link.find(user_link.link_id)
					end
				end
			end
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

	def shorten_link_web(ip_link, ip_name)
		if ip_link.blank? or ip_name.blank?
			@message = "Please enter valid values"
		else	
		    find_link = Link.find_by(long_link: ip_link)
		    find_user = User.find_by(username: ip_name)

		    if find_link
		    	@short_link = find_link
		    else
		    	short_link = "http://localhost:3000/"+Link.get_short
		    	@short_link =  Link.create(long_link: ip_link, short_link: short_link)
		    end

		    unless find_user
		    	@user = User.create(username: ip_name)
		    end	
		    	
		    if !find_link and !find_user
		    	UserLink.create(user_id: @user.id, link_id: @short_link.id) 
		    elsif !find_user and find_link
		    	UserLink.create(user_id: @user.id, link_id: find_link.id) 
		    elsif find_user and !find_link	
		    	UserLink.create(user_id: find_user.id, link_id: @short_link.id) 
		    else	
		    end
		    if @short_link
		    	@short_link
		    end	
		end  
	end	 
end
