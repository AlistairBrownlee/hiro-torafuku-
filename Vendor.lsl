key Owner;
key Vendor_Key;
key Customer_Key;
key Gift_Key;
string Customer_Name;
string Gift_Name;
string Product;
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


default
{
    
    
    state_entry()
    {
       
      Owner = llGetOwner(); 
      Vendor_Key = llGetKey();
      lchan = ((integer)("0x"+llGetSubString((string)Vendor_Key,-8,-1)) - 723) | 0x8000000;  
    }

    touch_end(integer total_number)
    {
       key Toucher = llDetectedKey(0); 
       
       
       if(Toucher == Owner)
       Dialog(Toucher,admin_btns);
       
       else
       Dialog(Toucher,customer_btns);
       
    }
    
  timer()
  {
     
     llSetTimerEvent(0.0);
     llListenRemove(lhandle);
      
  }  
    
}

