class ListsController < ApplicationController  
    before_action :authenticate_user!
    include Blacklight::SearchContext
    include Blacklight::SearchHelper
    include Blacklight::TokenBasedUser
	include Harvard::LibraryCloud::Collections

	require 'json'

    def index
	  @lists = available_collections()
    end

	def show
	  @id = params[:id]
	  
	  begin 
		@list = get_collection_by_id(@id)
	  rescue JSON::ParserError
		@list = nil
	  end

	  if @list.nil?
		redirect_to '/lists'
	  end
	  
	  search_params = {}
	  search_params[:setSpec] = @list['setSpec']

	  if !params[:page].nil? && !params[:page].to_s != ''
		page_number = params[:page].to_i
		
		if page_number > 0
			search_params[:page] = params[:page]
		end
	  end

	  (@response, @document_list) = search_results(search_params)
	end 
		
	def edit
	  @id = params[:id]
	  @list = get_collection_by_id(@id)
	  rescue JSON::ParserError
		@list = nil
	  		
	  if @list.nil?
		redirect_to '/lists'
	  end
	end

	def create
		@title = params[:title]
		#@thumbnailUrn = params[:thumbnailUrn]
		@thumbnailUrn = 'https://nrs.harvard.edu/urn-3:FHCL:14220361?width=150&height=150'
		if current_or_guest_user.api_key.nil?
		  @lc_user = create_library_cloud_user
		  @lc_user_object = JSON.parse(@lc_user[:body])
          @collection = create_collection(@lc_user_object['api-key'], @title, @thumbnailUrn)
          User.update_user_api_key(current_or_guest_user.email, @lc_user_object['api-key'])
		else
          @collection = create_collection(current_or_guest_user.api_key, @title, @thumbnailUrn)
		end
        render json: @collection
	end

	def update
		@id = params[:id]
		@title = params[:title]

		render plain: "ID=" + @id + " title=" + @title
	end

	def destroy
		@id = params[:id]
	
		render plain: "DELETE ID=" + @id
	end

	def add_items_form
		if params[:item_ids].to_s == ""
			redirect_to '/lists'
			return
		end
		@item_ids = params[:item_ids]
		@items = @item_ids.split(',')
		if @items.length == 1
			@response, @single_item = fetch(@items[0])
		else
			@response, @items_found = fetch(@items)
		end

		if @response[:items].nil?
			redirect_to '/lists'
			return
		end
		
		@lists = available_collections()
		render layout: false
	end

	def add_items
	  @item_ids = params[:item_ids]
	  @list = params[:list]
	  @lists = available_collections()

	  list_found = false
	  @lists.each do |x|
		if x[:id] == @list
			list_found = true
			break
		end
	  end

	  if !list_found
	  	redirect_to '/lists'
		return
	  end

	  render plain: "item_ids=" + @item_ids + " list=" + @list
	end
end
