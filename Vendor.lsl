key Owner;
key Vendor_Key;
key Customer_Key;
key Gift_Key;
string Customer_Name;
string Gift_Name;
string Product;
string url;
integer Paid_Amount;
string Payment_Method;
integer Discount_All;
integer Discount_Group;
string Date;
string Region;
integer Active;
string Sale_Start;
string Sale_End;
integer lchan;
integer lhandle;
list Investors;
key requestURL;
list admin_btns =["Set Active","Configure","Reset","Sales Dates","Discounts","Profit Split"];
list customer_btns = ["Gift","Credit"];

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


  llHTTPRequest("http://agorasl.com/stores/include/lsl/insertproduct.php",[HTTP_METHOD,"POST",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],
            "storeuuid="+(string)llGetOwner());

    

}


default
{
    
    
    state_entry()
    {
       
      Owner = llGetOwner(); 
      Vendor_Key = llGetKey();
      lchan = ((integer)("0x"+llGetSubString((string)Vendor_Key,-8,-1)) - 723) | 0x8000000; 

        
        init(); 

 
    }

    touch_end(integer total_number)
    {
       key Toucher = llDetectedKey(0); 
       
       
       if(Toucher == Owner)
       Dialog(Toucher,admin_btns);
       
       else
       Dialog(Toucher,customer_btns);
       
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
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        
        llOwnerSay((string)id + "+" + (string)status +"+ List=" +llList2CSV(metadata)+"+"+body);
        
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
    
    
    
  timer()
  {
     
     llSetTimerEvent(0.0);
     llListenRemove(lhandle);
      
  }  
    
}

