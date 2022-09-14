class WikiPageEditSerializer < ActiveModel::Serializer
  attributes :title, :body, :id, :username, :summary, :created_at

  def username
    object.user.username
  end
end
