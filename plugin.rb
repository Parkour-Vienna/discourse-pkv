# name: discourse-pkv
# about: PKV customisations
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/parkour-vienna/discourse-pkv

register_asset "stylesheets/common/pkv.scss"
register_asset "stylesheets/mobile/pkv.scss", :mobile

if respond_to?(:register_svg_icon)
  register_svg_icon "users"
  register_svg_icon "chalkboard-teacher"
  register_svg_icon "landmark"
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

      if news_topic_list = TopicQuery.new(current_user,
          per_page: 3,
          tags: [SiteSetting.pkv_news_tag],
          no_definitions: true
        ).list_latest

        json[:news_topic_list] = HomeTopicListSerializer.new(news_topic_list,
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
