class ForumThreadSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true
end
