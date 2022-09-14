class WikiPageEditSerializer < ActiveModel::Serializer
  attributes :title, :body, :id, :user_id, :summary, :created_at
end
