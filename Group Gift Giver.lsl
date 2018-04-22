integer group_set = FALSE;
integer click_count;
integer x;
key group_key;
key Owner;
list Region;
list iItems;



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


default
{
    
    on_rez(integer start_param)
    {
      
      llResetScript(); 
        
        
    }
    
    state_entry()
    {
    
    Owner = llGetOwner();
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
       
       if(group_set)
       {
        
        if(llDetectedGroup(0))
         {
           
           // check ban list. Move below code to http_response 
           
         //  if(on_banlist)
         
        // llInstantMessage(Toucher, "Sorry you are banned from this store, you may not receive gifts from here.");
         
         // else
         
         string thisScript = llGetScriptName();
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
                    llInstantMessage(Owner, "Unable to copy the item named '" + itemName + "'. Your group gift giver is here: " + (string)Region +  " - " + GetLocation() +".");
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
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);    // 3.0 seconds delay
        }  
             
             
         }
         
         else  
         llInstantMessage(Toucher," You have the wrong group activated. Please activate the " + "secondlife:///app/group/" + (string) group_key + "/about" + " group tag then touch the prim again.");
           
        }
        
        else
        {
         
         llInstantMessage(llGetOwner(),"WARNING: You have not set a group on your giver yet so items can not be distributed to your customers! Edit the prim and in the general tab select the spanner icon, then select a group to set the active group. Your group gift giver is here: " + (string)Region +  " - " + GetLocation() +".");   
            
        } 
    }
    
    changed(integer change)
    {
        
        if(change & CHANGED_INVENTORY)
        {
          integer total = llGetInventoryNumber(INVENTORY_ALL);  
          
          for(x = 0; x < total; ++x)
          {
            
            string item = llGetInventoryName(INVENTORY_ALL,x);

              
              
          }
            
            
            
        }
        
    }

    
}
