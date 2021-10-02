import { LightningElement, api } from 'lwc';
import getKeyIndicators from '@salesforce/apex/KeyAccountIndicatorsHandler.getKeyAccountIndicators';
import { reduceErrors } from 'c/ldsUtils';

export default class KeyAccountIndicators extends LightningElement {
    wrapper;
    errors;
    fullyLoaded;

    @api recordId;

    connectedCallback() {
        this.getSteps();
    }

    getSteps() {
        getKeyIndicators({accountId: this.recordId})
            .then(result => {
                this.wrapper = JSON.parse(result);
                this.fullyLoaded = true;
                console.log(result);
            })
            .catch(errors => {
                this.errors = errors;
                this.fullyLoaded = true;
                console.log('getKeyIndicators Errors: ' + errors)
            });
    }

    get errorMessages() {
        return reduceErrors(this.errors);
    }
}