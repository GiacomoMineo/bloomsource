class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_filter :set_categories_for_menu
  before_filter :configure_devise_permitted_parameters, if: :devise_controller?
  helper_method :current_user 
  # prevent caching
	before_filter :set_cache_buster

  private

  def set_categories_for_menu
    @categories = Category.all
  end

#  def current_user 
 # 	@current_user ||= User.find(session[:user_id]) if session[:user_id] 
  #end

  def require_user 
  	redirect_to '/login' unless current_user 
  end

  def require_editor
  	redirect_to '/' unless current_user.editor? 
  end

  def require_admin
  	redirect_to '/' unless current_user.admin? 
  end

  def admin
    current_user.roles.include?(Role.find_by(title: 'admin'))
  end

  def configure_devise_permitted_parameters
    registration_params = [:user_name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end


  def after_sign_in_path_for(resource)
    libraries_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  #def permission_denied
  #  redirect_to root_path, :notice => "Sorry, you are not allowed to access that page."
  #end
  
	def set_cache_buster
		 response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		 response.headers["Pragma"] = "no-cache"
		 response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
	end
	
	def set_library
		@library = Library.find(params[:library_id])
	end
	def set_category
		@category = Category.find(params[:category_id])
	end
	def set_section
		@section = Section.find(params[:section_id])
	end

end
