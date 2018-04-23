integer group_set = FALSE;
integer click_count;
integer x;
key group_key;
key Owner;
list Region;
list iItems;
integer lchan;
integer bchan;
integer lhandle;
integer bhandle;
string thisScript;



integer Check_ObjectGroup()
{
 
 list object_group = llGetObjectDetails(llGetKey(),[OBJECT_GROUP]);
 group_key = llList2Key(object_group,0);
 
 if(group_key != NULL_KEY)
 return TRUE;
 
 else return FALSE;
    
}


string GetLocation()
{
    string globe = "http://maps.secondlife.com/secondlife";
    string region = llGetRegionName();
    
   
    
    vector pos = llGetPos();
    
    string posx = (string)(llRound(pos.x));
    string posy = (string)(llRound(pos.y) - 3);
    string posz = (string)(llRound(pos.z) + 2);
    return (globe + "/" + llEscapeURL(region) +"/" + posx + "/" +posy  + "/" + posz);
}

integer UniqueChan(integer offset)
{

   return ((integer)("0x"+llGetSubString((string)llGetKey(),-8,-1)) - offset) | 0x8000000; 
   

}


default
{
    
    on_rez(integer start_param)
    {
      
      llResetScript(); 
        
        
    }
    
    state_entry()
    {
    
    Owner = llGetOwner();
    lchan = UniqueChan(7653);
    bchan = UniqueChan(226);
    
    thisScript = llGetScriptName();
    
    
    Region = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME]);
    
    group_set = Check_ObjectGroup();
    
    if(!group_set)
    {
     
     llOwnerSay("You have not set a group on this giver yet. Edit the prim and in the general tab select the spanner icon ,then select a group to set the active group.");   
        
    }   
        
    }
    
    touch_end(integer num)
    {
       key Toucher = llDetectedKey(0); 
       group_set = Check_ObjectGroup();
       
       
       if(Toucher == Owner)
       {
           
          llListenRemove(lhandle);
          lhandle = llListen(lchan, "",Owner,""); 
          llDialog(Owner,"\nSelect to add someone to the ban list, or test delivery of the items in this giver, or set number of gifts per customer, or set giver on.off.",["BAN","Test","Gift Limit","On/Off"],lchan);
          
           
       }
       
       else
       {
       if(group_set)
       {
        
        if(llDetectedGroup(0))
         {
           
           // check ban list. Move below code to http_response 
           
         //  if(on_banlist)
         
        // llInstantMessage(Toucher, "Sorry you are banned from this store, you may not receive gifts from here.");
         
         // else
         //{
        
        list inventoryItems;
        integer inventoryNumber = llGetInventoryNumber(INVENTORY_ALL);
 
        integer index;
        for ( ; index < inventoryNumber; ++index )
        {
            string itemName = llGetInventoryName(INVENTORY_ALL, index);
 
            if (itemName != thisScript)
            {
                if (llGetInventoryPermMask(itemName, MASK_OWNER) & PERM_COPY)
                {
                    inventoryItems += itemName;
                }
                else
                {
                    llInstantMessage(Owner, "The item named '" + itemName+ "' is not copyable. Your group gift giver is here: " + (string)Region +  " - " + GetLocation() +".");
                }
            }
        }
 
        if (inventoryItems == [] )
        {
            llInstantMessage(Toucher, "There are no items in this giver to hand out. Sorry about that.");
            
            llInstantMessage(Owner, "Your group gift giver is empty so there are no items to give out. The giver is here: " + (string)Region +  " - " + GetLocation() +".");
            
        }
        else
        {
           
           // send data to database date uuid name gift name region
           
           
           
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);    // 3.0 seconds delay



        }  
             
             
         }
         
         else  
         llInstantMessage(Toucher," You have the wrong group activated. Please activate the " + "secondlife:///app/group/" + (string) group_key + "/about" + " group tag then touch the prim again.");
           
        }
        
        else
        {
         
         llInstantMessage(llGetOwner(),"WARNING: You have not set a group on your giver yet so items can not be distributed to your customers! Edit the prim and in the general tab select the spanner icon, then select a group to set the active group. Your group gift giver is here: " + (string)Region +  " - " + GetLocation() +".");   
            
        } // no group set
        
        // } if not on ban list
        
       } // else if toucher is not owner 
         
    } // end of touch_end
    
    
  
  
    listen(integer chan, string name, key id, string msg)
{
    
    if(chan == lchan)
    {
 
        if(msg == "BAN")
        {
            
        }
        
        
        else if (msg == "TEST")
        {
            
        }   
        
        else if (msg == "GIFT LIMITS")
        {
            
        }
        
        else if (msg == "ON/OFF")
        {
        
        
        }
        
     }
}
    
    
 
// Needs fixing. Perhaps at end of loop, run through list and check if items are actually in inventory.

 
    changed(integer change)
    {
        
        if(change & CHANGED_INVENTORY)
        {
          integer total = llGetInventoryNumber(INVENTORY_ALL);  
          
          for(x = 0; x < total; ++x)
          {
            
            string item = llGetInventoryName(INVENTORY_ALL,x);
           
           if(item != thisScript)
           if(!~llListFindList(iItems, [item]))
             {
                 
                 if (llGetInventoryPermMask(item, MASK_OWNER) & PERM_COPY)
                {
                    iItems += item;
                }
                else
                {
                    llInstantMessage(Owner, "The item named '" + item + "' is not copyable.");
                }
                 
                 
              }
             
             else
             {
               
               integer idx = llListFindList(iItems, [item]);
               
                                
                 
              }              
              
          }
            
            
            
        }
        
    }
    
    
    timer()
    {
        
        
    }

    
}
