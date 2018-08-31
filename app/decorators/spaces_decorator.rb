# frozen_string_literal: true

class SpacesDecorator < Draper::CollectionDecorator
  def to_json
    object.map do |instance|
      instance.decorate.to_json
    end
  end
end
