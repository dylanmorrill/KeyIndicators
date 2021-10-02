![Icons](https://i.imgur.com/FboDH0k.png)

# Key Account Indicators Lightning Web Component

## Quick notes

1. For some reason, the spacing looks kind of funky when installing in different orgs. Can't figure it out, but as of 09/22/21 the header spacing looks funky, and the "Key Indicators" header has giant font.

## What is this?

This is a custom Lightning Web Component that shows key indicator icon alerts for an account and its related child accounts. It is easy to install and customize and can be quickly adapted to any org.

## How do I deploy it to my org?

To deploy, just use the package.xml file in the manifest folder to retrieve the necessary files and deploy them to your org.

## How do I make indicators?

To make a new indicator, update the code in the KeyAccountIndicatorsHelper.checkAccountIndicators method to add a new KeyIndicator wrapper to the keyIndicatorsToReturn list. That might sound like a pain in the ass to figure out, but it is super simple - **just copy/paste line 107-116 of the class, and update the 4 parameters to the makeIndicatorColor method accordingly.**

The available colors are grey, yellow, green, red, blue, and purple (there is a unique makeIndicator... method for each color). The available icons, the third parameter, can be any utility SLDS icon found in the [SLDS docs](https://www.lightningdesignsystem.com/icons/)

For instance to add a new yellow error icon when the account's name  = 'Test Account', just add the line below. The first parameter to the constructor below is the title of the alert, the second is the subtitle, the third is the icon name, and the fourth is the sort order.

```java

if (accountToCheck.Name == 'Test Account'){
    keyIndicatorsToReturn.add(
        makeIndicatorYellow(
            'TITLE', 
            'subtitle', 
            'wellness',
            10
        )
    );
}

```

## Default View

The default view shows a large key indicator card for each alert on the parent account, as well as de-duplicated view of all the indicators on the child accounts.

![indicator not expanded](https://i.imgur.com/sZ8nhaR.png)

## Drilldown View

The drilldown view shows the same large key indicator card for each alert on the parent account, but a simple table showing which of the alerts on the child accounts belong to which accounts.

![indicator expanded](https://i.imgur.com/oHkZG2k.png)
