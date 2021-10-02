import { LightningElement, api } from 'lwc';

export default class AccountIndicator extends LightningElement {

    @api indicator;

    renderedCallback(){
        this.template.querySelector('[data-id="indicator-footer"]').style.backgroundColor = this.indicator.footerColor;
        this.template.querySelector('[data-id="iconColor"]').classList.add('slds-icon-action-' + this.indicator.colorIconName);
    }
}