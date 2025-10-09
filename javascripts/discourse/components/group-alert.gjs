import Component from "@ember/component";
import { concat } from "@ember/helper";
import { htmlSafe } from "@ember/template";
import { tagName } from "@ember-decorators/component";
import concatClass from "discourse/helpers/concat-class";
import discourseComputed from "discourse/lib/decorators";

@tagName("")
export default class GroupAlert extends Component {
  @discourseComputed
  filteredBanners() {
    let parsedSetting = JSON.parse(settings.banner_wizard);

    let userGroups = this.currentUser
      ? this.currentUser.groups
      : [{ name: "anon" }]; // if logged out, set an "anon" group

    let joinedGroups = userGroups.map(function (group) {
      return group.name;
    });

    // turn comma separated list into array and remove whitespace
    function splitTrim(array) {
      return array?.split(",").map(function (string) {
        return string.trim();
      });
    }

    // check if there's a single match between two arrays of strings
    function hasMatch(groups, matchingGroups) {
      return groups.filter((element) => matchingGroups?.includes(element))
        .length;
    }

    let filteredBanners = [];

    // check each banner's group settings against user's group membership
    parsedSetting.forEach((banner) => {
      if (banner.contents) {
        let allowedGroups = splitTrim(banner.show_for_groups);
        let hiddenGroups = splitTrim(banner.hide_for_groups);

        if (
          hasMatch(joinedGroups, allowedGroups) &&
          !hasMatch(joinedGroups, hiddenGroups)
        ) {
          filteredBanners.push(banner);
        }
      }
    });

    return filteredBanners;
  }

  <template>
    {{#each this.filteredBanners as |fb|}}
      <div class={{concatClass "wrap" fb.name}}>
        <div
          class="alert alert-custom"
          style={{htmlSafe
            (concat
              (concat "background-color:" fb.background ";")
              (concat "color: " fb.text_color ";")
            )
          }}
        >
          {{htmlSafe fb.contents}}
        </div>
      </div>
    {{/each}}
  </template>
}
