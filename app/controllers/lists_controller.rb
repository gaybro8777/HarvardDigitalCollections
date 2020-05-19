class ListsController < ApplicationController  
    before_action :authenticate_user!
    include Blacklight::SearchContext
    include Blacklight::SearchHelper
    include Blacklight::TokenBasedUser
	include Harvard::LibraryCloud::Collections

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

	def update
		@id = params[:id]
		@title = params[:title]

		render plain: "ID=" + @id + " title=" + @title
	end

	def destroy
		@id = params[:id]
	
		render plain: "DELETE ID=" + @id
	end
end
