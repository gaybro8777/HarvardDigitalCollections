class ListsController < ApplicationController  
    before_action :authenticate_user!
	include Harvard::LibraryCloud::Collections
    def index
	  @lists = available_collections()
    end

	def show
	  @id = params[:id]
	  
	  @list = get_collection_by_id(@id)
	  rescue JSON::ParserError
		@list = nil
	  		
	  if @list.nil?
		redirect_to '/lists'
	  end
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
