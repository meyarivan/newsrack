class TopicSource < ActiveRecord::Base
  belongs_to :topic
  belongs_to :source
  belongs_to :feed  # unnormalized table to get quick access to the feed instead of going through source
end
