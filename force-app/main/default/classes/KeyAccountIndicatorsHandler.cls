public class KeyAccountIndicatorsHandler{
    @AuraEnabled
    public static String getKeyAccountIndicators(ID accountId){
        //Query for the account passed in from the LWC and all its related accounts
        Map<ID,Account> accountsWithRelated = new Map<ID,Account>(
            [SELECT Id
             FROM Account
             WHERE Id = :accountId
             OR ParentId = :accountId
            ORDER BY Name]
        );
        
        //Put the account and its related accounts in different variables/collections
        Account recordAccount = accountsWithRelated.remove(accountId);
        List<Account> relatedAccounts = accountsWithRelated.values();
        
        //Return a stringified version of the KeyIndicatorsWithChildIndicators wrapper to the LWC.
        //The constructors of the wrapper and its contents populate all the indicators
        return JSON.serialize(
            new KeyIndicatorsWithChildIndicators(
                recordAccount,
                relatedAccounts
            )
        );
    }
    
	//Main wrapper class that gets returned to the LWC. Contains a KeyIndicatorsWrapper for the parent account,
	//a list of KeyIndicatorsWrapper for each child account,
	//and a list of the unique KeyIndicators on the child accounts
    public class KeyIndicatorsWithChildIndicators{
        public KeyIndicatorsWrapper parentIndicators;
        public List<KeyIndicatorsWrapper> childIndicators = new List<KeyIndicatorsWrapper>();
        public List<KeyIndicator> uniqueChildIndicators = new List<KeyIndicator>();
        
        public KeyIndicatorsWithChildIndicators(Account recordAccount, List<Account> relatedAccounts){
            Map<String, KeyIndicator> uniqueChildIndicatorsMap = new Map<String,KeyIndicator>();
            
            this.parentIndicators = new KeyIndicatorsWrapper(recordAccount);
            
            if (relatedAccounts.isEmpty()){
                return;
            }
            
            for (Account relatedAccount : relatedAccounts){
                KeyIndicatorsWrapper relatedWrapper = new KeyIndicatorsWrapper(relatedAccount);
                
                if (relatedWrapper.indicators.isEmpty()){
                    continue;
                }
                
                for (KeyIndicator ind : relatedWrapper.indicators){
                     uniqueChildIndicatorsMap.put(ind.title, ind);
                }

                this.childIndicators.add(relatedWrapper);
            }
            
            this.uniqueChildIndicators = uniqueChildIndicatorsMap.values();
        }
    }
   
    //Wrapper that contains an account and a list of KeyIndicators
    public class KeyIndicatorsWrapper{
        public Account a;
        public List<KeyIndicator> indicators = new List<KeyIndicator>();
        
        public KeyIndicatorsWrapper(Account recordAccount){
            this.a = recordAccount;
            this.indicators = checkAccountIndicators(recordAccount);
        }
    }
    
    //KeyIndicator object used to style the specific alert
    public class KeyIndicator implements Comparable{
        String iconPath = '/_slds/icons/utility-sprite/svg/symbols.svg#';
        String footerColor;
        String colorIconName;
        String title;
        String subtitle;
        Integer sortOrder;
        
        public KeyIndicator(String iconName, String color, String title, String subtitle, Integer sortOrder){
            hexAndIconName hAndI = COLOR_TO_HEX_AND_ICON_MAP.get(color);
            
            this.iconPath += iconName;
            this.footerColor = hAndI.hex;
            this.colorIconName = hAndI.iconName;
            this.title = title;
            this.subtitle = subtitle;
            this.sortOrder = sortOrder;
        }
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            KeyIndicator compareToKeyInd = (KeyIndicator)compareTo;
            if (sortOrder == compareToKeyInd.sortOrder) return 0;
            if (sortOrder > compareToKeyInd.sortOrder) return 1;
            return -1;        
        }
    }
        
    //Method to just check custom logic, and add KeyIndicators to a return map
    public static  List<KeyIndicator> checkAccountIndicators(Account accountToCheck){
        List<KeyIndicator> keyIndicatorsToReturn = new List<KeyIndicator>();


        if ('HEY A STRING' != null){
            keyIndicatorsToReturn.add(
                makeIndicatorGreen(
                    'TEST ALERT', 
                    'Test alert template', 
                    'animal_and_nature',
                    0
                )
            );
        }

        keyIndicatorsToReturn.sort();

        return keyIndicatorsToReturn;
    }
    
    private static final Map<String,hexAndIconName> COLOR_TO_HEX_AND_ICON_MAP = new Map<String,hexAndIconName>{
        'grey'   => new hexAndIconName('#8199AF', 'canvas'),
        'green'  => new hexAndIconName('#7DC37D', 'record'),
        'yellow' => new hexAndIconName('#FBB439', 'priority'),
        'red'    => new hexAndIconName('#EF6E64', 'close'),
        'purple' => new hexAndIconName('#9895EE', 'fallback'),
        'blue'   => new hexAndIconName('#62B7ED', 'more')
    };
             
                
    private static final String IMAGE_PATH = '/_slds/icons/utility-sprite/svg/symbols.svg#';
    
    //Small class that holds a hex value and the value of an SLDS action icon
    //The hex color determines the footer color of the KeyIndicator and the action icon
    //name determines the color of the icon
    private class hexAndIconName{
        String hex;
        String iconName;
        
        public hexAndIconName(String hex, String iconName){
            this.hex = hex;
            this.iconName = iconName;
        }
    }
    
    @TestVisible
    //Method for making grey KeyIndicators
    private static KeyIndicator makeIndicatorGrey(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'grey', 
            title,
            subtitle,
            sortOrder
        );
    }
    
    @TestVisible
    //Method for making ggreen KeyIndicators
    private static KeyIndicator makeIndicatorGreen(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'green', 
            title,
            subtitle,
            sortOrder
        );
    }
    
    @TestVisible
    //Method for making red KeyIndicators
    private static KeyIndicator makeIndicatorRed(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'red', 
            title,
            subtitle,
            sortOrder
        );
    }
    
    @TestVisible
    //Method for making yellow KeyIndicators
    private static KeyIndicator makeIndicatorYellow(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'yellow', 
            title,
            subtitle,
            sortOrder
        );
    }
    
    @TestVisible
    //Method for making blue KeyIndicators
    private static KeyIndicator makeIndicatorBlue(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'blue', 
            title,
            subtitle,
            sortOrder
        );
    }
    
    @TestVisible
    //Method for making purple KeyIndicators
    private static KeyIndicator makeIndicatorPurple(String title, String subtitle, String icon, Integer sortOrder){
        return new KeyIndicator(
            icon, 
            'purple', 
            title,
            subtitle,
            sortOrder
        );
    }
}