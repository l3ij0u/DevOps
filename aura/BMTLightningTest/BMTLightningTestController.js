({

    getCustomerData : function(component) {
      
        var action = component.get("c.customerData");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var returnValue =response.getReturnValue();
                component.set("v.customers", returnValue );
           }
        });
        $A.enqueueAction(action);
    }
})