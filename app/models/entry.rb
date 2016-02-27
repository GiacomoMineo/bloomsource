class Entry < ActiveRecord::Base

	# enable search for entries
	include PgSearch
	pg_search_scope :search_full_text,
									:against => {
											:title => 'A', # priorities: title first, then description, then url
											:link => 'C',
											:description => 'B'
									},
									:using => {
											:tsearch => { # full text search
													:any_word => true,
													:prefix => true
											},
											:trigram => { # trigram search for spelling mistakes, etc.
													:only => [:title]
											},
											:dmetaphone => { # metaphone search for similar-sounding results
													:any_word => true
											}
									},
									:ignoring => :accents # search without accents, i.e. "pina colada instead of "piña colada"

	# prepares the entry for being shown, including read marks
	# if user != nil
	scope :prepare_for, ->(user) do
		includes(:tags, :group)
		.order(cached_votes_score: :desc, updated_at: :desc, created_at: :asc)
		.possibly_with_read_marks(user)
	end
	scope :possibly_with_read_marks, ->(user) do
		with_read_marks_for(user) if user
	end

	# scope for all entries in a certain library
	scope :in_library, ->(library) do
		where('section_id IN (?)',	Section.in_library(library).select(:id))
	end

	acts_as_votable
	acts_as_readable :on => :created_at

	belongs_to :group
	belongs_to :section
	has_and_belongs_to_many :tags
	
	validates_presence_of :section, :title, :link, :description, :group
	validates_format_of :link, :with => URI::regexp
	
	def rating
		cached_votes_score
	end
end
