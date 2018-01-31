class Answer < ApplicationRecord
  belongs_to :question
  translates :body, :contributor_type, :contributor_id
  accepts_nested_attributes_for :translations, reject_if: proc {|x| x['body'].blank? }

  
  def read_translated_attribute(name, locale)
    globalize.stash.contains?(locale, name) ? globalize.stash.read(locale, name) : translation_for(locale).send(name)
  end

  def contributor
    translation.contributor
  end
end

class Answer::Translation
   belongs_to :contributor, polymorphic: true
   validates_presence_of :contributor_id, :contributor_type
end