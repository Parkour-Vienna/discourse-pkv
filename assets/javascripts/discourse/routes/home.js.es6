import { ajax } from 'discourse/lib/ajax';
import TopicList from "discourse/models/topic-list";
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  model() {
    return ajax(`/home`);
  },

  setupController(controller, model) {
    let props = {};

    if (model) {
      if (model.topic_list) {
        props['topics'] = TopicList.topicsFrom(this.store, model.topic_list);

        if (props['topics'].length) {
          props['category'] = props['topics'][0].category;
        };
      }

      if (model.info_topic_list) {
        model.info_topic_list.topic_list = model.info_topic_list.home_topic_list;
        props['infoTopics'] = TopicList.topicsFrom(this.store, model.info_topic_list);
      }
    }

    controller.setProperties(props);
  }
});
