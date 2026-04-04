module ApplicationHelper
  def attribute_name(model, attribute)
    model.human_attribute_name(attribute)
  end
end
