class TagsController < ApplicationController
	filter_resource_access
		
	def index
		if params[:library_id] and params[:search]
				@library = Library.find(params[:library_id])
				@tags = @library.tags.search(params[:search])
		else
				redirect_to(request.referer || '/', alert: "Request invalid.")
		end
	end

	def show
		@tag = Tag.find(params[:id])
		@entries = @tag.entries.prepare_for(current_user).select { |e| e.accepted == true }
		@library = @tag.library
		@groups = @library.groups
	end
end
