# name: discourse-pkv
# about: PKV customisations
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/parkour-vienna/discourse-pkv

register_asset "stylesheets/common/pkv.scss"
register_asset "stylesheets/mobile/pkv.scss", :mobile

if respond_to?(:register_svg_icon)
  register_svg_icon "hard-hat"
  register_svg_icon "clock-o"
  register_svg_icon "dollar-sign"
  register_svg_icon "funnel-dollar"
  register_svg_icon "stopwatch"
  register_svg_icon "arrow-right"
end

after_initialize do
  module ::PkvHome
    class Engine < ::Rails::Engine
      engine_name "pkv_home"
      isolate_namespace PkvHome
    end
  end

  require 'homepage_constraint'
  Discourse::Application.routes.prepend do
    root to: "pkv_home/page#index", constraints: HomePageConstraint.new("home")
    get "/home" => "pkv_home/page#index"
  end

  require_dependency 'topic_list_item_serializer'
  class HomeTopicListItemSerializer < ::TopicListItemSerializer
    def excerpt
      doc = Nokogiri::HTML::fragment(object.first_post.cooked)
      doc.search('.//img').remove
      PrettyText.excerpt(doc.to_html, 300, keep_emoji_images: true)
    end

    def include_excerpt?
      true
    end
  end

  require_dependency 'topic_list_serializer'
  class HomeTopicListSerializer < ::TopicListSerializer
    has_many :topics, serializer: HomeTopicListItemSerializer, embed: :objects
  end

  require_dependency 'application_controller'
  require_dependency 'user_serializer'
  class PkvHome::PageController < ::ApplicationController
    def index
      json = {}
      guardian = Guardian.new(current_user)

      info_category = Category.find_by(name: 'Info') || Category.find_by(id: 1)

      if info_topic_list = TopicQuery.new(current_user,
          per_page: 3,
          category: info_category.id,
          no_definitions: true
        ).list_latest

        json[:info_topic_list] = HomeTopicListSerializer.new(info_topic_list,
          scope: guardian
        ).as_json
      end

      render_json_dump(json)
    end
  end

  module UserOptionExtension
    def homepage
      if homepage_id == 101
        "home"
      else
        super
      end
    end
  end
end
