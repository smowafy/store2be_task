# frozen_string_literal: true

class SpaceDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def to_json
    {
      title: title,
      size: size,
      price_per_day: price_per_day,
      price_per_week: price_per_week,
      price_per_month: price_per_month
    }
  end
end
