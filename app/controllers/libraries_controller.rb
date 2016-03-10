class LibrariesController < ApplicationController
	before_action :new_library, :only => [:approve, :edit, :browse]
	filter_resource_access

	def index
		@libraries_own = current_user.libraries_created
		@libraries_followed = current_user.libraries.select { |lib| lib.creator != current_user}
		@invitations = current_user.invitations_received
		
	end

	def browse
	end

	def show
		@landing = true
		@categories = @library.categories
		tot = 0
		@library.categories.each do |c|
			c.sections.each do |s|
				tot += s.entries.count
			end
		end
		@total_entries = tot
	end

	def new
		@library_new = @library
	end

	def create
		@library_new = Library.new(library_params) 
		@library_new.creator = current_user

		@group_read	 = Group.new(:name => "Read")
		@group_watch = Group.new(:name => "Watch")
		@group_learn = Group.new(:name => "Learn")
		@group_make = Group.new(:name => "Make")

		@library_new.groups.push(@group_read)
		@library_new.groups.push(@group_watch)
		@library_new.groups.push(@group_learn)
		@library_new.groups.push(@group_make)


  		if @library_new.save 
  				current_user.edit!
				redirect_to library_path(@library_new) 
  		else 
    		render 'new' 
  		end 
	end

	def edit
		@library_to_edit = @library
	end

	def update
		@library_to_edit = @library
		if @library_to_edit.update_attributes(library_params)
			redirect_to library_path(@library_to_edit), :notice => "The library has been edited"
		else
			render 'edit'
		end
	end

	def destroy
		@invitations = Invitation.all.select{ |sug| sug.library == @library}

		@invitations.each do |invite|
			invite.destroy
		end
		
    	@library.destroy
    	redirect_to '/', :notice => "The library has been deleted"
	end

	def search
		@groups = @library.groups
		@query = params[:q]
		@entries = @library.entries.where(:accepted => true).includes(:group, :tags).search_full_text(@query)
	end

	def show_suggestions
		@groups = @library.groups
		@entries = @library.entries.where(:accepted => false).includes(:group, :tags)
	end

	def subscribe
		@library.users.push(current_user)
		redirect_to request.referer || '/'
	end

	def unsubscribe
		@library.update_attributes(users: @library.users - [current_user])
		redirect_to request.referer || '/'
	end

	private
		def library_params
			params.require(:library).permit(:topic, :description, :public, {:moderator_ids => []})
		end
		def new_library
			if params[:id] then
				@library = Library.find(params[:id])
			else
				@library = Library.new
			end
		end

end
