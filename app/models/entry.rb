class Entry < ActiveRecord::Base

	# enable search for entries
	include PgSearch
	pg_search_scope :search_full_text,
									:associated_against => {
											:section => {:name => 'C'},
											:category => {:name => 'C'}
									},
									:against => {
											:title => 'A', # priorities: title/author first, then description, then section/category
											:author => 'A',
											:description => 'B',
									},
									:using => {
											:tsearch => { # full text search
													:any_word => true,
													:prefix => true,
											},
											:trigram => { # trigram search for spelling mistakes, etc.
													:only => [:title, :author]
											},
											:dmetaphone => { # double metaphone search for similar-sounding results
													:any_word => true,
													:only => [:title, :author]
											}
									},
									:ignoring => :accents # search without accents, i.e. "pina colada instead of "piña colada"


	# prepares the entry for being shown,
	scope :prepare, ->() do
		includes(:group, :tags)
		.order(cached_votes_score: :desc, updated_at: :desc, created_at: :asc)
	end

  # includes read marks if user != nil
	scope :prepare_for, ->(user) do
		prepare.possibly_with_read_marks(user)
	end
	scope :possibly_with_read_marks, ->(user) do
		with_read_marks_for(user) if user
	end

	# scope for all entries in a certain library
	scope :in_library, ->(library) do
		where(:section => Section.in_library(library))
	end

	acts_as_votable
	#acts_as_readable :on => :created_at

	belongs_to :group
	belongs_to :section
	has_one :category, :through => :section
	has_one :library, :through => :section
	has_and_belongs_to_many :tags
	
	validates_presence_of :section, :title, :link, :description, :group
	validates_format_of :link, :with => URI::regexp
	
	def rating
		cached_votes_score
	end
end
