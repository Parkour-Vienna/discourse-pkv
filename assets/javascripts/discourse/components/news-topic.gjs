import Component from "@glimmer/component";

export default class NewsTopic extends Component {
  <template>
    <div class="news-topic">
      <div class="image-div">
        <img src={{@topic.image_url}} class="banner-image" />
      </div>
      <div class="overlay"></div>
      <a class="content" href={{@topic.url}}>
        <div class="title-container">
          <h4>
            {{#if @topic.unicode_title }}
              {{ @topic.unicode_title }}
            {{ else}}
              {{ @topic.title }}
            {{/if}}
          </h4>
        </div>
      </a>
    </div>
  </template>
}
