class WikiPageSerializer < ActiveModel::Serializer
  attributes :title, :body, :id
end
