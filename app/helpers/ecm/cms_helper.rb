module Ecm::CmsHelper
  def cms_render_navigation(name, options = {})
    options.reverse_merge! renderer: :bootstrap, expand_all: true, levels: 1

    levels              = options.delete(:levels)
    expand_all          = options.delete(:expand_all)
    container_css_class = options.delete(:container_css_class)
    renderer            = options.delete(:renderer)

    levels_as_array = (levels).is_a?(Range) ? levels.to_a : [levels]

    navigation = Ecm::Cms::Navigation.where(:name => name.to_s, :locale => I18n.locale.to_s).first
    unless navigation
      return I18n.t('ecm.cms.navigation.messages.not_found', {:lang => I18n.locale.to_s, :name => name.to_s})
    end

    roots = navigation.ecm_cms_navigation_items.roots.all
    if roots.empty?
      return I18n.t('ecm.cms.navigation.messages.empty', :lang => I18n.locale.to_s, :name => name)
    end

    depth = 1

    render_navigation(levels: levels, expand_all: expand_all, renderer: renderer) do |navigation|
      navigation.dom_class = container_css_class if levels_as_array.include?(depth)
      roots.each do |navigation_item|
        build_navigation_item(navigation, navigation_item, container_css_class)
      end
    end
  end

  def _evaled_options(option_string)
    options = {}
    begin
      evaled_options = eval(option_string)
      options.merge! evaled_options
    rescue
      logger.debug "Invalid navigation item options: #{item.options}"
    ensure
      return options
    end
  end

  def build_navigation_item(navigation, item, container_css_class)
    options = _evaled_options(item.options)

    navigation.dom_class = container_css_class
    if item.children.present?
      navigation.item item.key, item.name, item.url, options do |sub_navigation|
        item.children.each do |sub_item|
          build_navigation_item(sub_navigation, sub_item, container_css_class)
        end
      end
    else
      navigation.item item.key, item.name, item.url, options
    end
  end
end

