class WikiPageSerializer < ActiveModel::Serializer
  attributes :title, :body, :id
  has_many :wiki_page_edits, embed: :ids, key: 'wiki_page_edits', embed_in_root: true, each_serializer: WikiPageEditSerializer
end
