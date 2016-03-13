class CategoriesController < ApplicationController
	before_action :new_category
	filter_resource_access

	def index
	end
	
	def new
	end
	
	def create
		@category = Category.new(category_params)
		@category.library = @library

		if @category.save 
			redirect_to root_path
		else 
			render 'new' 
		end 
	end

	def destroy
		@category.destroy
		redirect_to root_path, :notice => "The category has been deleted"
	end

	def edit
		@library = @category.library
	end

	def update
		if @category.update_attributes(category_params)
			redirect_to root_path, :notice => "The library has been edited"
		else
			render 'edit'
		end
	end
	
	private
		def category_params
			params.require(:category).permit(:name)
		end
		
		def new_category
			if params[:id] then
				@category = Category.find(params[:id])
			else 
				@category = Category.new
			end
			
			if @category.library then
				@library = @category.library
			elsif params[:library_id] then
				@library = Library.find(params[:library_id])
				@category.library = @library
			end
		end
end
