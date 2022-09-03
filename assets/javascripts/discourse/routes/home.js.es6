import { ajax } from 'discourse/lib/ajax';
import TopicList from "discourse/models/topic-list";
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  showFooter: true,
  model() {
    return ajax(`/home`);
  },

  setupController(controller, model) {
    let props = {};
    if (model) {
      if (model.news_topic_list) {
        model.news_topic_list.topic_list = model.news_topic_list.home_topic_list;
        props['newsTopics'] = TopicList.topicsFrom(this.store, model.news_topic_list);
      }
      if (model.team) {
        props['team'] = model.team;
      }
    }

    controller.setProperties(props);
  }
});
