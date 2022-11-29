class FruitSummonSerializer < ActiveModel::Serializer
  attributes :name, :id

  def name
    object.fruit_summon_entity.name
  end
end
