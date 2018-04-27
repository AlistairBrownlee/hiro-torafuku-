integer Perms;
key Owner;
key Vendor_Key;
key Customer_Key;
key Gift_Key;
string Customer_Name;
string Gift_Name;
string Product = "test Gayngel23";
string url;
integer Paid_Amount;
string Payment_Method;
integer Discount_All;
integer Discount_Group;
string Date;
string Region;
string Sale_Start;
string Sale_End;
integer Price = 899;
integer Reward_All;
integer Reward_Group;
integer lchan;
integer lhandle;
list Investors;
key requestURL;
key checkReg;
key checkBan;
key callServer;
key returnBan;
list admin_btns =["Set Active","Configure","Reset","Sales Dates","Discounts","Profit Split","Ban"];
list customer_btns = ["Gift","Credit"];
integer Active = TRUE;



Dialog(key av,list btns)
{
 llListenRemove(lhandle);
 lhandle = llListen(lchan,"",av,"");
 llDialog(av,"\nSelect an option:",btns,lchan);
 
 Timer();   
}

Timer()
{
 
 llSetTimerEvent(0.0);
  llSetTimerEvent(120.0);
    
}

init()
{

    llReleaseURL(url);
    requestURL = llRequestURL();

}


Ping()
{    
   
 //   llHTTPRequest(app+"?"+"url="+url+"&uuid="+ llEscapeURL(llGetKey()) + "&version=" + llEscapeURL(version),[HTTP_METHOD,"GET"],"Ping");


  
// Ping store php  
  
  // checkReg = llHTTPRequest();
  
  
  
  // llHTTPRequest("http://agorasl.com/stores/include/lsl/insertproduct.php",[HTTP_METHOD,"POST",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],
  //          "Owner="+(string)llGetOwner()+
   //         "&Product="+(string)Product+
    //        "&Price="+(string)Price+
     //       "&Active="+(string)Active+
      //      "&Region="+(string)Region+
       //     "&Sale_Start="+(string)Sale_Start+
        //    "&Sale_End="+(string)Sale_End+
         //   "&Date="+(string)Date+
          //  "&Discount_All="+(string)Discount_All+
           // "&Discount_Group="+(string)Discount_Group+
           // "&Reward_All="+(string)Reward_All+
            //"&Reward_Group="+(string)Reward_Group
            //);

    

}


default
{
    
    
    state_entry()
    {
       
      Owner = llGetOwner(); 
      Vendor_Key = llGetKey();
      lchan = ((integer)("0x"+llGetSubString((string)Vendor_Key,-8,-1)) - 723) | 0x8000000; 

        //llRequestPermissions(Owner,PERMISSION_DEBIT);
        init();

 
    }
    
    
    run_time_permissions(integer perm)
    {
      
      if(perm & PERMISSION_DEBIT)
      {
          
          Perms = TRUE;
          init();
          
          
          
        }
        
        else
        {
        llInstantMessage(Owner,"This vendor can not be used without granting debit permissions.");
        Perms = FALSE;
        
        }
        
        
    }
    

    touch_end(integer total_number)
    {
         key Toucher = llDetectedKey(0);  
      if(Perms)
      {  
     
       
       
       if(Toucher == Owner)
       Dialog(Toucher,admin_btns);
       
       else
       Dialog(Toucher,customer_btns);
       }
       
       else
       {
          
          if(Toucher == Owner)
          {
              llRequestPermissions(Owner,PERMISSION_DEBIT);
          }
           
        }
       
    }
    
    
     http_request(key id, string method, string body)
    {
        
         if ((method == URL_REQUEST_GRANTED) && (id == requestURL) )
        {
            // An URL has been assigned to me.
            url = body;
            requestURL = NULL_KEY;
            Ping();
        }
        else if ((method == URL_REQUEST_DENIED) && (id == requestURL))
        {
            // I could not obtain a URL
            llOwnerSay("There was a problem, and an URL was not assigned: " + body);
            requestURL = NULL_KEY;
        }
        
        else if(id == checkBan)
        {
           
           if(body == "Yes")
           {
               
              llInstantMessage(Customer_Key,"You are banned from this store, you can not buy items from this vendor.");
              returnBan = llTransferLindenDollars(Customer_Key,Paid_Amount);
 
               
            }
               
               
           else if(body == "No")
            {
                   
               integer itemcheck = llGetInventoryType(Product); 
               
               if(itemcheck == INVENTORY_NONE)
               {
                   callServer = llHTTPRequest("serverurl.com",[HTTP_METHOD,"POST",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],
             "Owner="+(string)llGetOwner()+
             "&Product="+(string)Product);
                   
                }
               
               else
                llGiveInventory(Customer_Key,Product);
                
                
           
                   
            }
              
            
         }
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        
        if(id == checkReg)
        {
            
            if(body == "Yes")
            {
                llOwnerSay("Please go to the web portal to set up this vendor."); 
               //  llLoadURL(Owner, "You need to register your store before setting up this vendor. Click this link to register.", "https://agorasl.com/stores/signup.php." ); 
             }
            
            
            else if(body == "No")
            {
              llOwnerSay("You need to register your store before setting up this vendor. Please register at https://agorasl.com/stores/signup.php.");  
              llLoadURL(Owner, "You need to register your store before setting up this vendor. Click this link to register.", "https://agorasl.com/stores/signup.php." ); 
               
                
             }    
            
        }
        
        llOwnerSay((string)id + "+" + (string)status +"+ List=" +llList2CSV(metadata)+"+"+body);
        
    }
    
    
    
    listen(integer chan, string name, key id, string msg)
{
    
    
    //list admin_btns =["Set Active","Configure","Reset","Sales Dates","Discounts","Profit Split"];
//list customer_btns = ["Gift","Credit"];
    
    if(chan == lchan)
    {
 
        if(msg == "Set Active")
        {
           
           if(Active)
           {
               Active = FALSE;
                llSetPayPrice(PAY_HIDE,[PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
                llSetClickAction(CLICK_ACTION_TOUCH);
               
               llOwnerSay("You have set this vendor to inactive. No one can buy products from it.");
               
            }
           
           else if(!Active)
            {
               Active = TRUE;
              llSetClickAction(CLICK_ACTION_PAY);
                llSetPayPrice(Price,[PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
               
                llOwnerSay("You have set this vendor to active. Evertone can buy from it.");
                
                }
            
            
        }
        
        
        else if (msg == "Configure")
        {
           
            llOwnerSay("Please go to the web portal to set up this vendor.");
           
            
        }   
        
        else if (msg == "Reset")
        {
           
          // llResetScript();
            
        }  
        
        
        else if (msg == "Sales Dates")
        {
            
            
            
        } 
        
        else if (msg == "Discounts")
        {
            
        }   
        
        else if (msg == "Profit Split")
        {
            
        }  
        
     }
}
    
    
    money(key id, integer amount)
    {
        if(Active)
        {
          
          //check banlist checkBan = llHTTPRequest();
            
        }
        
        else
        {
            
            
        }
     
     
     }
    
    
    changed(integer change)
    {
        //  note that it's & and not &&... it's bitwise!
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_TELEPORT))
        {
            init();
        }

        else if (change & (CHANGED_OWNER))
        llResetScript();
        
    } 
    
    transaction_result(key id, integer success, string data)
    {
        
        if(id == returnBan)
            {
                
              if(!success)
              {
                
                llInstantMessage(Customer_Key,"There was an error returning your money. Please contact "+"secondlife:///app/agent/" + (string)Owner + "/about"+" to get your money back.");
                  
                 llInstantMessage(Owner,"There was an error returning L$"+(string)Paid_Amount+" to "+"secondlife:///app/agent/" + (string)Customer_Key + "/about"+". Please return the money to them manually.\n]n Reason for error: " + data +".\nYou can view what this reason means here: http://wiki.secondlife.com/wiki/Transaction_result");
                  
                  
              }
                
                
                
            }
        
        
    }
    
  timer()
  {
     
     llSetTimerEvent(0.0);
     llListenRemove(lhandle);
      
  }  
    
}

