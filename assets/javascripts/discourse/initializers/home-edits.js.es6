import { setDefaultHomepage } from "discourse/lib/utilities";
import { withPluginApi } from 'discourse/lib/plugin-api';
import { default as computed } from 'discourse/lib/decorators';

export default {
  name: 'home-edits',
  initialize(container) {
    const currentUser = container.lookup('current-user:main');
    const siteSettings = container.lookup('site-settings:main');
    if (!currentUser || !currentUser.homepage_id) setDefaultHomepage('home');

    withPluginApi('0.8.23', api => {
      api.modifyClass('controller:preferences/interface', (Superclass) => class extends Superclass {
        @computed()
        userSelectableHome() {
          let core = super.userSelectableHome;
          core.push(...[
            { name: "Home", value: 101 },
          ]);
          return core;
        }

        homeChanged() {
          const homepageId = this.get("model.user_option.homepage_id");
          if (homepageId === 101) {
            setDefaultHomepage("home");
          } else if (homepageId === 102) {
            setDefaultHomepage("assigned");
          } else {
            super.homeChanged();
          }
        }
      });
    });
  }
};
