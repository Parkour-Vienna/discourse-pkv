import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";

export default {
  name: "clickable-banner",
  initialize() {
    withPluginApi("2.0.0", (api) => {
      api.modifyClass(
        "component:discourse-banner",
        (DiscourseBanner) =>
          class extends DiscourseBanner {
            get content() {
              const content = super.content;
              return htmlSafe(
                `<a style="color: inherit" href="/t/${super.banner.key}">${content}</a>`
              );
            }
          }
      );
    });
  },
};
