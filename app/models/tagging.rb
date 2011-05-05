class Tagging < ActsAsTaggableOn::Tagging
end

# == Schema Information
#
# Table name: taggings
#
#  id            :integer         not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  tagger_id     :integer
#  tagger_type   :string(255)
#  context       :string(255)
#  created_at    :datetime
#

