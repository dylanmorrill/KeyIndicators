import { LightningElement, api } from 'lwc';

export default class AccountIndicatorSmall extends LightningElement {
    @api indicator;

    renderedCallback(){
        this.template.querySelector('[data-id="iconColor"]').classList.add('slds-icon-action-' + this.indicator.colorIconName);
    }
}