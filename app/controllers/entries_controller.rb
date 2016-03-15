class EntriesController < ApplicationController
	before_action :new_entry
	#filter_access_to :all#, :attribute_check => true
	filter_resource_access

	def upvote
		@entry.upvote_by current_user 
		redirect_to request.referer || '/'  #go back where we came from
	end

	def downvote
		@entry.downvote_by current_user 
		redirect_to request.referer || '/'  #go back where we came from
	end

	def accept
		@entry.update_attributes(accepted: true)
		redirect_to request.referer || '/' #go back where we came from
	end

	#def read
	#	@entry.mark_as_read! :for => current_user
	#	redirect_to request.referer || '/' #go back where we came from
	#end

	def new
		@groups = @library.groups
	end

	def create
		@entry = Entry.new(entry_params)
		@entry.section = @section
		@entry.accepted = permitted_to? :accept, @entry
  		if @entry.save
				redirect_to section_path(@section), :notice => "Entry saved succesfully" 
			else 
				redirect_to new_section_entry_path(@section), :notice => "Could not save entry" 
			end
	end

	def edit
		@groups = @library.groups
	end

	def update
		if @entry.update_attributes(entry_params)
			redirect_to section_path(@section), :notice => "The entry has been edited"
		else
			render 'edit', :notice => "Could not edit entry" 
		end
	end
	
	def destroy
		@entry.destroy
		redirect_to request.referer || '/' #go back where we came from
	end

	
	private
		def entry_params
			params.require(:entry).permit(:title, :link, :description, :section_id, :group_id, :accepted, :author, :readingtime)
		end
		
		def new_entry
			if params[:id] then
				@entry = Entry.find(params[:id])
			else 
				@entry = Entry.new
			end
			
			if @entry.section then
				@section = @entry.section
			elsif params[:section_id] then
				@section = Section.find(params[:section_id])
				@entry.section = @section
			end
			
			if @section && @section.category then
				@category = @section.category
			end
			
			if @category && @category.library then
				@library = @category.library
			end
		end
end
