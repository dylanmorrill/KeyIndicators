import { LightningElement, api } from 'lwc';

export default class ChildAccountIndicators extends LightningElement {
    @api childIndicators;
    @api uniqueChildIndicators;

    viewHierarchy = false;
    setViewHierarchy(){
        this.viewHierarchy = !this.viewHierarchy;
    }

    goToAccount(event) {
        let URL = '/lightning/r/Account/' + event.target.getAttribute('name') + '/view';

        window.open(URL, "_blank");
    }
}