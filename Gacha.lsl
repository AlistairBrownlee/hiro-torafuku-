// Early draft. Will add dialogs, gacha item types, options for more rares, profit split, http ,etc later
integer price = 15;  //SET PRICE HERE
string  rare_item = "";  //SET RARE ITEM HERE
integer rare_multiplier = 2; //SET RARE MUTLIPIER HERE


key requestid;
string avatar;

default
{
    state_entry()
    {
        llSetPayPrice(PAY_HIDE, [price ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        
    }
    touch_start(integer number)
    {   
        string id = llDetectedKey(0);
        string scriptname = llGetScriptName();
        llInstantMessage(id, "Click pay to play the Gatcha!");
    }
    money(key id, integer amount) 
       {
        list items;
        list items_less_rare;
        list finalitems;
        string name;
        string stuff;
        string returnitem;
        integer num = llGetInventoryNumber(INVENTORY_ALL);
        integer finalnum = num - 1;
        string folder = llGetObjectName();
        integer i;
        integer min = 0;
        string scriptname = llGetScriptName();
        
        
        integer random = (integer)llFrand(finalnum);
        if(random == num) {
            random -= 1 ;
            }
        for (i = 0; i < num; ++i) {
            name = llGetInventoryName(INVENTORY_ALL, i);
            items += name;
            }
        integer placeinlist = llListFindList(items, [scriptname]);
        finalitems = llDeleteSubList(items, placeinlist, placeinlist);
        integer rareinlist = llListFindList(finalitems, [rare_item]);
        items_less_rare = llDeleteSubList(finalitems, rareinlist, rareinlist);
        for (i=2; i < rare_multiplier; ++i) {
            items_less_rare = items_less_rare + items_less_rare;
            }
        items_less_rare = finalitems + items_less_rare;
        integer rnd2 = (integer)llGetListLength(items_less_rare);
        rnd2 -= 1;
        rnd2 = (integer)llFrand(rnd2);
        
        returnitem =  llList2String(items_less_rare, rnd2);                                   
        
        integer finallen = llGetListLength( finalitems );   
        avatar = llKey2Name(id);
        
       if(amount != price)
            {
            llInstantMessage(id, "You paid "+(string)amount+", which is the wrong amount, the price is: "+(string)price);
            state default;
            }  
       
        llSleep(2.0);
      
        
        llInstantMessage(id, "You Purchased " + ": " + returnitem);
        llGiveInventory(id, returnitem);             
             
        }
}

