class ListsController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, only: [:add_items_form]
	include Blacklight::SearchContext
    include Blacklight::SearchHelper
    include Blacklight::TokenBasedUser
  include Harvard::LibraryCloud
	include Harvard::LibraryCloud::Collections

	 before_action :set_cache_headers


	require 'json'

    def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "-1"
    end

    def index
	  set_user_api_key
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
	  search_params[:setSpec] = @list[0]['setSpec']

	  if !params[:page].nil? && !params[:page].to_s != ''
		page_number = params[:page].to_i

		if page_number > 0
			search_params[:page] = params[:page]
		end
	  end

    api = Harvard::LibraryCloud::API.new
    @export_list_url = api.get_base_uri + 'items.csv?setSpec=' + @list[0]['setSpec']

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
		@thumbnailUrn = params[:thumbnail]
		#@thumbnailUrn = 'https://nrs.harvard.edu/urn-3:FHCL:14220361?width=150&height=150'
		set_user_api_key
        @collection = create_collection(current_or_guest_user.api_key, @title, @thumbnailUrn)

        render json: @collection[:body]
	end

	def update
		@id = params[:id]
		@title = params[:title]
        @collection = update_collection(current_or_guest_user.api_key, @id, @title)
		render plain: "ID=" + @id + " title=" + @title
	end

	def destroy
		@id = params[:id]
	    @collection = destroy_collection(current_or_guest_user.api_key, @id)
		#render plain: "DELETE ID=" + @id
		render plain: @collection
	end

	def add_items_form
		if params[:item_ids].to_s == ""
			redirect_to '/lists'
			return
		end
		set_user_api_key
		@item_ids = params[:item_ids]
		@items = @item_ids.split(',')
    @items = @items.uniq
		@thumbnail = ''
		@default_list_id = ''

		if @items.length == 1
			#adding one item to list, lookup item
			@response, @single_item = fetch(@items[0])
		else
			#adding multiple items
			@response, @items_found = fetch(@items)
		end

		if @response[:items].nil?
			redirect_to '/lists'
			return
		end

		if !@single_item.nil?
			@item_count = 1
			@thumbnail = @single_item[:preview]
		else
			@item_count = @response[:pagination][:numFound]
			backup_thumbnail = ''
			first_item_found = false
			#items found aren't in the order we want, find the first item for the thumb
			@items_found.each do |item|
				if item[:identifier] == @items[0]
					first_item_found = true
					if item[:preview].to_s != ""
						@thumbnail = item[:preview]
						break
					elsif backup_thumbnail != ""
						break
					end
				elsif backup_thumbnail == "" && item[:preview].to_s != ""
					backup_thumbnail = item[:preview]
					if first_item_found
						break
					end
				end
			end

			#if thumb is still empty use the first non-empty one
			if @thumbnail == ""
				@thumbnail = backup_thumbnail
			end
		end

		@lists = available_collections()
		@has_lists = false
		if !@lists.nil? && @lists.length > 0
		  @default_list_id = @lists[0]['id']
		  @has_lists = true
		end
		render layout: false
	end

	def add_items
	  @item_ids = params[:item_ids]
	  @list = params[:list_id]
	  @lists = available_collections()

	  #validate that user owns list
	  list_found = false
	  @lists.each do |x|
		  if x['id'].to_s == @list.to_s
			  list_found = true
			  break
		  end
	  end

	  if !list_found
	  	redirect_to '/lists'
		return
	  end

      @added_items = add_item_to_collection(current_or_guest_user.api_key, @list, @item_ids)
	  render plain:  @added_items.to_json
	end

  def remove_item
	  @item_id = params[:item_id]
	  @list_id = params[:list_id]
	  
    @list = get_collection_by_id(@list_id)

	  #validate that user owns list
	  if @list.nil? || @list.count == 0
	  	redirect_to '/lists'
		  return
	  end

    @deleted_items = delete_item_from_collection(current_or_guest_user.api_key, @list_id, @item_id)
    
    #perform search on the list to get latest results on next load
    search_params = {}
	  search_params[:setSpec] = @list[0]['setSpec']
    (@response, @document_list) = search_results(search_params)
	  redirect_to '/lists/' + @list_id
	end

	private

	def set_user_api_key
	  if current_or_guest_user.api_key.nil?
	    @lc_user = create_library_cloud_user
	    @lc_user_object = JSON.parse(@lc_user[:body])
        current_or_guest_user.api_key = @lc_user_object['api-key']
		current_or_guest_user.save
	  end
	end
end
