class FruitSummonSerializer < ActiveModel::Serializer
  attributes :name, :id
  belongs_to :user

  def name
    object.fruit_summon_entity.name
  end
end
