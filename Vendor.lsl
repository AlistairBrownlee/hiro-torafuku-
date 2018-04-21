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




default
{
    
    
    state_entry()
    {
       
      Owner = llGetOwner(); 
      Vendor_Key = llGetKey();
      lchan = ((integer)("0x"+llGetSubString((string)Vendor_Key,-8,-1)) - 723) | 0x8000000;  
    }

    touch_start(integer total_number)
    {
       
    }
}
