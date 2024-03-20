import DiscourseURL from 'discourse/lib/url';
import { default as computed } from 'ember-addons/ember-computed-decorators';
import Component from "@ember/component";
export default Component.extend({
  classNames: 'news-topic',

  @computed('topic.posters')
  displayUser(posters) {
    return posters[0].user;
  },
});
