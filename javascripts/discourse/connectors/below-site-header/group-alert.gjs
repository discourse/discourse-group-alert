import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import GroupAlert from "../../components/group-alert";

@classNames("below-site-header-outlet", "group-alert")
export default class GroupAlertConnector extends Component {
  <template><GroupAlert /></template>
}
