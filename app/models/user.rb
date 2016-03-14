class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :moderated_libraries, :class_name => "Library"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #acts_as_reader
  has_many :subscriptions
  has_many :libraries, through: :subscriptions
  has_many :libraries_created, :class_name => "Library", :foreign_key => "creator_id"
  has_many :invitations_created, :class_name => "Invitation", :foreign_key => "creator_id"
  has_many :invitations_received, :class_name => 'Invitation', :primary_key => 'email', :foreign_key => 'receiver_email'
  enum mode: [:read, :edit] #read: 0, edit: 1
  
  validates_presence_of :user_name, :email#, :password
  validates_uniqueness_of :user_name, :email




  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def role_symbols
    (roles || []).map{|r| r.title.to_sym}.append(:user)
  end

  protected
  def confirmation_required?
    false
  end

end
