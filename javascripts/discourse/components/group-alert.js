import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";
import I18n from "I18n";

export default Component.extend({
  tagName: "",
  isDismissed: false,

  init() {
    this._super(...arguments);
    if (localStorage.getItem(I18n.t(themePrefix("banner_content")))) {
      this.set("isDismissed", true);
    }
  },

  @discourseComputed("currentUser")
  shouldDisplay(user) {
    let alertGroups = settings.groups.split("|");
    let hideGroups = settings.hide_for_groups.split("|");
    let inGroup = false;

    if (settings.can_dismiss && this.isDismissed) {
      return inGroup;
    }

    if (user) {
      user.groups.forEach((group) => {
        if (alertGroups.indexOf(group.name) > -1) {
          inGroup = true;
        }
      });

      user.groups.forEach((group) => {
        if (hideGroups.indexOf(group.name) > -1) {
          inGroup = false;
        }
      });
    }

    return inGroup;
  },

  @action
  dismissBanner() {
    localStorage.setItem(I18n.t(themePrefix("banner_content")), "true");
    document.querySelector(".alert.alert-custom").classList.add("hidden");
    this.set("isDismissed", true);
  },
});
